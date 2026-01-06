//
//  LayerOutlineAdapter.swift
//  IOS_CommonEditor
//
//  Factory for the Layers v2 outline UI. Keeps integration behind a flag.
//

import UIKit

public struct LayersV2Feature {
    /// Toggle to turn on the new Layers v2 outline. Defaults to off to avoid impacting existing UI.
    public static var isEnabled: Bool = true
}

public final class LayerOutlineAdapter : NSObject{
    private let templateHandler: TemplateHandler
    private let logger: PackageLogger?
    private var reducer: LayerReducer
    private var controller: LayerOutlineViewController!

    public var currentReducer: LayerReducer {
        reducer
    }

    public init?(templateHandler: TemplateHandler, logger: PackageLogger? = nil) {
        guard let page = templateHandler.currentPageModel else { return nil }
        let tree = LayerTreeBuilder.build(from: page)
        self.reducer = LayerReducer(tree: tree)
        self.templateHandler = templateHandler
        self.logger = logger
        super.init()
        self.controller = buildController()
        self.controller.adapter = self
    }

    /// Returns the view controller for presentation or embedding.
    public func viewController() -> UIViewController {
        controller
    }

    /// Refresh the outline from the current TemplateHandler tree (call after external mutations).
    public func refreshFromTemplate() {
        guard let page = templateHandler.currentPageModel else { return }
        let tree = LayerTreeBuilder.build(from: page)
        reducer = LayerReducer(tree: tree)
        controller.reload(with: reducer)
    }

    /// Apply a reorder/move/delete/undelete request and refresh UI.
    public func apply(_ block: (inout LayerReducer) -> Void) {
        block(&reducer)
        controller.reload(with: reducer)
    }

    /// External refresh hook for undo/redo or engine-driven changes.
    public func externalRefresh() {
        refreshFromTemplate()
    }

    // MARK: - Move / Reorder

    /// Move a node to a new parent/position via TemplateHandler and refresh.
    public func move(nodeId: Int, toParent newParentId: Int, atOrder order: Int) {
        let moveModel = templateHandler.moveChildIntoNewParent(modelID: nodeId, newParentID: newParentId, order: order)
        // If move failed or empty, bail
        guard !moveModel.newMM.isEmpty else { return }
        // Persist DB changes for all entries
        for entry in moveModel.newMM {
            _ = DBManager.shared.updateMoveModelChild(moveModelData: entry, parentSize: templateHandler.getModel(modelId: entry.parentID)?.baseFrame.size ?? .zero)
        }
        // Emit action for undo/redo and engine listeners
        templateHandler.performGroupAction(moveModel: moveModel)
        // Normalize orders for both old and new parents
        let parentIds = Set(moveModel.oldMM.map { $0.parentID } + moveModel.newMM.map { $0.parentID })
        parentIds.forEach { normalizeOrders(forParent: $0) }
        refreshFromTemplate()
    }

    /// Reorder within same parent via TemplateHandler (swap orders).
    public func reorderWithinParent(parentId: Int, fromOrder: Int, toOrder: Int) {
        guard let parent = templateHandler.getModel(modelId: parentId) as? ParentModel else { return }
        let active = parent.activeChildren.sorted { $0.orderInParent < $1.orderInParent }
        guard fromOrder >= 0, fromOrder < active.count else { return }
        let safeTo = min(max(0, toOrder), active.count - 1)
        let moving = active[fromOrder]
        parent.changeOrder(child: moving, oldOrder: fromOrder, newOrder: safeTo)
        normalizeOrders(forParent: parentId)
        refreshFromTemplate()
    }

    /// Normalize active children orders for a given parent and persist.
    private func normalizeOrders(forParent parentId: Int) {
        guard let parent = templateHandler.getModel(modelId: parentId) as? ParentModel else { return }
        let active = parent.children.filter { !$0.softDelete }.sorted { $0.orderInParent < $1.orderInParent }
        for (idx, child) in active.enumerated() {
            child.orderInParent = idx
            _ = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: idx)
        }
        // push deleted to the tail with order -1
        let deleted = parent.children.filter { $0.softDelete }
        deleted.forEach { $0.orderInParent = -1 }
    }

    /// Refresh from TemplateHandler and return updated reducer (for UI snapshots).
    public func refreshedReducer() -> LayerReducer {
        guard let page = templateHandler.currentPageModel else { return reducer }
        let tree = LayerTreeBuilder.build(from: page)
        reducer = LayerReducer(tree: tree)
        return reducer
    }

    private func buildController() -> LayerOutlineViewController {
        return LayerOutlineViewController(
            reducer: reducer,
            logger: logger,
            onSelect: { [weak templateHandler] node in
                templateHandler?.deepSetCurrentModel(id: node.id)
            },
            onToggleLock: { [weak templateHandler] id in
                guard let model = templateHandler?.getModel(modelId: id) else { return }
                model.lockStatus.toggle()
                _ = DBManager.shared.updateLockStatus(modelId: id, newValue: model.lockStatus.toString())
                templateHandler?.currentActionState.updateThumb = true
            },
            onToggleHide: { [weak templateHandler] id in
                guard let model = templateHandler?.getModel(modelId: id) else { return }
                model.isHidden.toggle()
                templateHandler?.currentActionState.updateThumb = true
            },
            onDeleteRestore: { [weak self, weak templateHandler] id, wasDeleted in
                guard let self, let templateHandler = templateHandler, let model = templateHandler.getModel(modelId: id) else { return }
                model.softDelete = !wasDeleted
                model.orderInParent = wasDeleted ? model.orderInParent : -1
                _ = DBManager.shared.updateSoftDelete(modelId: id, newValue: model.softDelete.toInt())
                normalizeOrders(forParent: model.parentId)
                refreshFromTemplate()
            },
            onMove: { [weak self] nodeId, parentId, order in
                self?.move(nodeId: nodeId, toParent: parentId, atOrder: order)
            },
            onReorder: { [weak self] parentId, from, to in
                self?.reorderWithinParent(parentId: parentId, fromOrder: from, toOrder: to)
            }
        )
    }

    /// Convenience to refresh from handler and notify controller.
    public func refreshAndReload() {
        refreshFromTemplate()
    }
}
