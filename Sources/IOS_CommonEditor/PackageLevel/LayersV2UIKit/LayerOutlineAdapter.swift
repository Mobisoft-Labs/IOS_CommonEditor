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

public enum LayerOutlineRootMode {
    /// Outline is rooted at the current page (legacy behavior).
    case page
    /// Outline is rooted at the selected model's nearest parent (or selected parent if editState is true).
    case selectedParent
}

public final class LayerOutlineAdapter : NSObject{
    private let templateHandler: TemplateHandler
    private let logger: PackageLogger?
    private let layersConfig: LayersConfiguration?
    private var reducer: LayerReducer
    private var controller: LayerOutlineViewController!
    private var cancellables = Set<AnyCancellable>()
    private var shouldSeedFromEditState = true
    public var outlineRootMode: LayerOutlineRootMode = .page {
        didSet { refreshFromTemplate() }
    }
    /// When true in selectedParent mode, show full nested tree; otherwise show only direct children.
    public var scopedShowsNestedChildren: Bool = false {
        didSet { refreshFromTemplate() }
    }

    public var currentReducer: LayerReducer {
        reducer
    }

    public init?(templateHandler: TemplateHandler, logger: PackageLogger? = nil, layersConfig: LayersConfiguration? = nil) {
        guard let page = templateHandler.currentPageModel else { return nil }
        let tree = LayerTreeBuilder.build(from: page, includeDescendants: true)
        self.reducer = LayerReducer(tree: tree)
        self.templateHandler = templateHandler
        self.logger = logger
        self.layersConfig = layersConfig
        super.init()
        self.controller = buildController()
        self.controller.adapter = self
        updateOutlineRootContext()
        observeTemplateUpdates()
    }

    /// Returns the view controller for presentation or embedding.
    public func viewController() -> UIViewController {
        controller
    }

    /// Refresh the outline from the current TemplateHandler tree (call after external mutations).
    public func refreshFromTemplate(reconfigureIdsOverride: Set<Int>? = nil) {
        guard let root = resolveOutlineRoot(templateHandler: templateHandler, mode: outlineRootMode) else { return }
        let oldTree = reducer.tree
        var tree = LayerTreeBuilder.build(from: root, includeDescendants: includeDescendantsForCurrentMode())
        // Reapply expansion/selection where possible
        for id in Array(tree.nodes.keys) {
            guard var node = tree.nodes[id] else { continue }
            if let parent = templateHandler.getModel(modelId: id) as? ParentModel {
                if shouldSeedFromEditState {
                    node.isExpanded = parent.editState
                } else {
                    node.isExpanded = parent.isExpanded
                }
            }
            tree.nodes[id] = node
        }
        shouldSeedFromEditState = false
        reducer = LayerReducer(tree: tree)
        updateOutlineRootContext()
        let reconfigureIds = reconfigureIdsOverride ?? computeReconfigureIds(oldTree: oldTree, newTree: tree)
        controller.reload(with: reducer, reconfigureIds: reconfigureIds)
    }

    public func refreshFromTemplate(reconfigureIdsBuilder: (LayerTree, LayerTree) -> Set<Int>) {
        guard let root = resolveOutlineRoot(templateHandler: templateHandler, mode: outlineRootMode) else { return }
        let oldTree = reducer.tree
        var tree = LayerTreeBuilder.build(from: root, includeDescendants: includeDescendantsForCurrentMode())
        // Reapply expansion/selection where possible
        for id in Array(tree.nodes.keys) {
            guard var node = tree.nodes[id] else { continue }
            if let parent = templateHandler.getModel(modelId: id) as? ParentModel {
                if shouldSeedFromEditState {
                    node.isExpanded = parent.editState
                } else {
                    node.isExpanded = parent.isExpanded
                }
            }
            tree.nodes[id] = node
        }
        shouldSeedFromEditState = false
        reducer = LayerReducer(tree: tree)
        updateOutlineRootContext()
        let reconfigureIds = reconfigureIdsBuilder(oldTree, tree)
        controller.reload(with: reducer, reconfigureIds: reconfigureIds)
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
        refreshFromTemplate { oldTree, tree in
            var ids = parentIds
            ids.formUnion(descendantIds(of: nodeId, in: tree))
            ids.insert(nodeId)
            let oldParentId = oldTree.nodes[nodeId]?.parentId ?? newParentId
            let oldOrderValue = oldOrder ?? oldTree.nodes[nodeId]?.orderInParent ?? 0
            ids.formUnion(neighborIds(aroundOrder: oldOrderValue, parentId: oldParentId, in: oldTree))
            ids.formUnion(neighborIds(aroundOrder: targetOrder, parentId: newParentId, in: tree))
            return ids
        }
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
        refreshFromTemplate { oldTree, newTree in
            var ids: Set<Int> = [parentId]
            if fromOrder >= 0, fromOrder < active.count {
                ids.insert(active[fromOrder].modelId)
            }
            ids.formUnion(neighborIds(aroundOrder: fromOrder, parentId: parentId, in: oldTree))
            ids.formUnion(neighborIds(aroundOrder: safeTo, parentId: parentId, in: newTree))
            return ids
        }
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
        guard let root = resolveOutlineRoot(templateHandler: templateHandler, mode: outlineRootMode) else { return reducer }
        let tree = LayerTreeBuilder.build(from: root, includeDescendants: includeDescendantsForCurrentMode())
        reducer = LayerReducer(tree: tree)
        updateOutlineRootContext()
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

    public func setNeedsExpandSeed() {
        shouldSeedFromEditState = true
    }

    // UI-only selection highlight to match legacy (does not set current model).
    public func setLayerActiveUIOnly(id: Int) {
        guard let page = templateHandler.currentPageModel else { return }
        walk(model: page) { model in
            model.isLayerAtive = (model.modelId == id)
        }
    }

    public func synchronizeLayerUIState() {
        guard let page = templateHandler.currentPageModel else { return }
        synchronizeStateForNode(page)
        if let current = templateHandler.currentModel {
            current.isLayerAtive = true
        }
    }

    private func synchronizeStateForNode(_ node: BaseModel) {
        // Legacy parity: UI expansion follows editState, selection follows isActive.
        if let parent = node as? ParentModel {
            parent.isExpanded = parent.editState
        }
        node.isLayerAtive = node.isActive
        if let parent = node as? ParentModel {
            for child in parent.activeChildren {
                synchronizeStateForNode(child)
            }
        }
    }

    private func walk(model: BaseModel, visit: (BaseModel) -> Void) {
        visit(model)
        if let parent = model as? ParentModel {
            for child in parent.children {
                walk(model: child, visit: visit)
            }
        }
    }


    private func observeTemplateUpdates() {
        templateHandler.currentActionState.$thumbUpdateId
            .removeDuplicates()
            .sink { [weak self] id in
                guard let self else { return }
                if id != 0 { self.refreshFromTemplate() }
            }
            .store(in: &cancellables)
    }

    public func modelFor(id: Int) -> BaseModel? {
        templateHandler.getModel(modelId: id)
    }

    public func activeChildrenIds(for parentId: Int) -> [Int] {
        guard let parent = templateHandler.getModel(modelId: parentId) as? ParentModel else { return [] }
        return parent.activeChildren.sorted { $0.orderInParent < $1.orderInParent }.map { $0.modelId }
    }

    private func resolveOutlineRoot(templateHandler: TemplateHandler, mode: LayerOutlineRootMode) -> ParentModel? {
        guard let page = templateHandler.currentPageModel else { return nil }
        guard mode == .selectedParent, let selected = templateHandler.currentModel else { return page }
        if let selectedParent = selected as? ParentModel, selectedParent.editState {
            return selectedParent
        }
        if let nearest = nearestEditedParent(from: selected, templateHandler: templateHandler) {
            return nearest
        }
        if let parent = templateHandler.getModel(modelId: selected.parentId) as? ParentModel {
            return parent
        }
        return page
    }

    private func nearestEditedParent(from model: BaseModel, templateHandler: TemplateHandler) -> ParentModel? {
        var currentId = model.parentId
        while currentId != 0 {
            guard let current = templateHandler.getModel(modelId: currentId) as? ParentModel else { break }
            if current.editState { return current }
            currentId = current.parentId
        }
        return nil
    }

    private func updateOutlineRootContext() {
        guard let page = templateHandler.currentPageModel,
              let root = resolveOutlineRoot(templateHandler: templateHandler, mode: outlineRootMode) else { return }
        let parentId: Int? = (root.modelId == page.modelId) ? nil : root.parentId
        controller.updateOutlineRoot(rootId: root.modelId,
                                     parentId: parentId,
                                     orderInParent: root.orderInParent,
                                     allowNestedDrops: includeDescendantsForCurrentMode())
    }

    private func includeDescendantsForCurrentMode() -> Bool {
        if outlineRootMode == .page { return true }
        return scopedShowsNestedChildren
    }

    /// Convenience to refresh from handler and notify controller.
    public func refreshAndReload() {
        refreshFromTemplate()
    }

    private func computeReconfigureIds(oldTree: LayerTree, newTree: LayerTree) -> Set<Int> {
        var changed = Set<Int>()
        for (id, newNode) in newTree.nodes {
            guard let oldNode = oldTree.nodes[id] else {
                changed.insert(id)
                continue
            }
            if newNode.parentId != oldNode.parentId
                || newNode.orderInParent != oldNode.orderInParent
                || newNode.depth != oldNode.depth
                || newNode.softDelete != oldNode.softDelete {
                changed.insert(id)
            }
        }

        let oldParents = Set(oldTree.childrenByParent.keys)
        let newParents = Set(newTree.childrenByParent.keys)
        let allParents = oldParents.union(newParents)
        for parentId in allParents {
            let oldChildren = oldTree.childrenByParent[parentId] ?? []
            let newChildren = newTree.childrenByParent[parentId] ?? []
            if oldChildren.count != newChildren.count {
                changed.insert(parentId)
                continue
            }
            if oldChildren != newChildren {
                changed.insert(parentId)
            }
        }
        return changed
    }

    private func descendantIds(of nodeId: Int, in tree: LayerTree) -> Set<Int> {
        var result = Set<Int>()
        var stack = [nodeId]
        while let current = stack.popLast() {
            let children = tree.childrenByParent[current] ?? []
            for childId in children {
                if result.insert(childId).inserted {
                    stack.append(childId)
                }
            }
        }
        return result
    }

    private func neighborIds(aroundOrder order: Int, parentId: Int, in tree: LayerTree) -> Set<Int> {
        let children = tree.childrenByParent[parentId] ?? []
        guard !children.isEmpty else { return [] }
        let index = min(max(0, order), children.count - 1)
        var ids = Set<Int>()
        ids.insert(children[index])
        if index > 0 { ids.insert(children[index - 1]) }
        if index + 1 < children.count { ids.insert(children[index + 1]) }
        return ids
    }
}
