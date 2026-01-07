//
//  LayerOutlineAdapter.swift
//  IOS_CommonEditor
//
//  Factory for the Layers v2 outline UI. Keeps integration behind a flag.
//

import UIKit
import Combine

public struct LayersV2Feature {
    /// Toggle to turn on the new Layers v2 outline. Defaults to off to avoid impacting existing UI.
    public static var isEnabled: Bool = true
}

public final class LayerOutlineAdapter : NSObject{
    private let templateHandler: TemplateHandler
    private let logger: PackageLogger?
    private let layersConfig: LayersConfiguration?
    private var reducer: LayerReducer
    private var controller: LayerOutlineViewController!
    private var cancellables = Set<AnyCancellable>()
    private var modelCancellables: [Int: Set<AnyCancellable>] = [:]

    public var currentReducer: LayerReducer {
        reducer
    }

    public init?(templateHandler: TemplateHandler, logger: PackageLogger? = nil, layersConfig: LayersConfiguration? = nil) {
        guard let page = templateHandler.currentPageModel else { return nil }
        let tree = LayerTreeBuilder.build(from: page)
        self.reducer = LayerReducer(tree: tree)
        self.templateHandler = templateHandler
        self.logger = logger
        self.layersConfig = layersConfig
        super.init()
        self.controller = buildController()
        self.controller.adapter = self
        observeTemplateUpdates()
        observeModelChanges()
    }

    /// Returns the view controller for presentation or embedding.
    public func viewController() -> UIViewController {
        controller
    }

    /// Refresh the outline from the current TemplateHandler tree (call after external mutations).
    public func refreshFromTemplate() {
        guard let page = templateHandler.currentPageModel else { return }
        // Preserve expansion/selection
        let expandedIds: Set<Int> = Set(reducer.tree.nodes.values.filter { $0.isExpanded }.map { $0.id })
        let selectedId = reducer.tree.nodes.values.first(where: { $0.isSelected })?.id

        var tree = LayerTreeBuilder.build(from: page)
        // Reapply expansion/selection where possible
        for id in Array(tree.nodes.keys) {
            guard var node = tree.nodes[id] else { continue }
            if expandedIds.contains(id) {
                node.isExpanded = true
            }
            if let selectedId, id == selectedId {
                node.isSelected = true
            }
            tree.nodes[id] = node
        }
        reducer = LayerReducer(tree: tree)
        controller.reload(with: reducer)
        observeModelChanges()
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

    /// Move (or reorder within same parent) via TemplateHandler and refresh.
    public func move(nodeId: Int, toParent newParentId: Int, atOrder order: Int, oldOrder: Int? = nil, sameParent: Bool = false) {
        var targetOrder = order
        if sameParent, let oldOrder = oldOrder, oldOrder < order, order > 0 {
            targetOrder = order - 1
        }
        var moveModel = templateHandler.moveChildIntoNewParent(modelID: nodeId, newParentID: newParentId, order: targetOrder)
        // If move failed or empty, bail
        guard !moveModel.newMM.isEmpty else { return }

        if sameParent {
            moveModel.type = .OrderChangeOnly
            moveModel.orderChange = OrderChange(selectedModelId: nodeId, oldOrder: oldOrder ?? 0, newOrder: targetOrder)
        } else {
            moveModel.type = .MoveModel
        }

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
            dragLogicConfig: .init(),
            dragAnimationConfig: .init(),
            dragViewPosition: .centerOfDragView,
            dragHitTestPosition: .userTouch,
            onSelect: { [weak templateHandler] node in
                templateHandler?.deepSetCurrentModel(id: node.id)
            },
            onToggleLock: { [weak templateHandler] id in
                guard let model = templateHandler?.getModel(modelId: id) else { return }
                model.lockStatus.toggle()
                _ = DBManager.shared.updateLockStatus(modelId: id, newValue: model.lockStatus.toString())
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
            onMove: { [weak self] nodeId, parentId, order, oldOrder, sameParent in
                self?.move(nodeId: nodeId, toParent: parentId, atOrder: order, oldOrder: oldOrder, sameParent: sameParent)
            },
            onReorder: { [weak self] parentId, from, to in
                self?.reorderWithinParent(parentId: parentId, fromOrder: from, toOrder: to)
            },
            onClose: { [weak self] in
                guard let self else { return }
                self.layersConfig?.removeOrDismissViewController(self.controller)
            }
        )
    }

    public func updateDragLogic(config: LayerOutlineDragLogicConfig) {
        controller.updateDragLogic(config: config)
    }

    public func updateDragPresentation(animation: LayerOutlineDragAnimationConfig, position: LayerOutlineDragViewPosition) {
        controller.updateDragPresentation(animation: animation, position: position)
    }

    public func updateDragPresentation(animation: LayerOutlineDragAnimationConfig,
                                       position: LayerOutlineDragViewPosition,
                                       hitTestPosition: LayerOutlineDragHitTestPosition) {
        controller.updateDragPresentation(animation: animation, position: position, hitTestPosition: hitTestPosition)
    }

    public func currentModelId() -> Int {
        templateHandler.currentModel?.modelId ?? -1
    }

    private func observeTemplateUpdates() {
        templateHandler.currentActionState.$thumbUpdateId
            .removeDuplicates()
            .sink { [weak self] id in
                guard let self else { return }
                if id != 0 {
                    self.refreshFromTemplate()
                }
            }
            .store(in: &cancellables)
    }

    private func observeModelChanges() {
        modelCancellables.removeAll()
        guard let page = templateHandler.currentPageModel else { return }
        walk(model: page) { [weak self] model in
            guard let self else { return }
            var set = Set<AnyCancellable>()

            model.$isLayerAtive
                .removeDuplicates()
                .sink { [weak self] isActive in
                    self?.updateNode(modelId: model.modelId) { node in
                        node.isSelected = isActive
                    }
                    if isActive {
                        self?.controller.reconfigureItems([model.modelId])
                    }
                }
                .store(in: &set)

            model.$lockStatus
                .removeDuplicates()
                .sink { [weak self] isLocked in
                    self?.updateNode(modelId: model.modelId) { node in
                        node.isLocked = isLocked
                    }
                    self?.controller.reconfigureItems([model.modelId])
                }
                .store(in: &set)

            model.$isHidden
                .removeDuplicates()
                .sink { [weak self] isHidden in
                    self?.updateNode(modelId: model.modelId) { node in
                        node.isHidden = isHidden
                    }
                    self?.controller.reconfigureItems([model.modelId])
                }
                .store(in: &set)

            model.$thumbImage
                .sink { [weak self] image in
                    self?.updateNode(modelId: model.modelId) { node in
                        node.thumbImage = image
                    }
                    self?.controller.reconfigureItems([model.modelId])
                }
                .store(in: &set)

            if let parent = model as? ParentModel {
                parent.$isExpanded
                    .removeDuplicates()
                    .sink { [weak self] isExpanded in
                        self?.updateNode(modelId: parent.modelId) { node in
                            node.isExpanded = isExpanded
                        }
                        self?.controller.refreshSnapshot()
                    }
                    .store(in: &set)
            }

            modelCancellables[model.modelId] = set
        }
    }

    private func updateNode(modelId: Int, _ block: (inout LayerNode) -> Void) {
        reducer.updateNode(id: modelId, block)
    }

    private func walk(model: BaseModel, visit: (BaseModel) -> Void) {
        visit(model)
        if let parent = model as? ParentModel {
            for child in parent.children {
                walk(model: child, visit: visit)
            }
        }
    }

    /// Convenience to refresh from handler and notify controller.
    public func refreshAndReload() {
        refreshFromTemplate()
    }
}
