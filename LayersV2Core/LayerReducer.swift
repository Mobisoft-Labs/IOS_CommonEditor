import Foundation

public struct LayerReducer {
    public private(set) var tree: LayerTree

    public init(tree: LayerTree) {
        self.tree = tree
        normalizeAll()
    }

    public mutating func addChild(_ node: LayerNode, to parentId: Int, atActiveIndex index: Int? = nil) {
        tree.nodes[node.id] = node
        var list = tree.childrenByParent[parentId] ?? []
        let active = activeIds(in: list)
        let insertIndex = min(index ?? active.count, active.count)
        var newActive = active
        newActive.insert(node.id, at: insertIndex)
        let deleted = softDeletedIds(in: list)
        list = newActive + deleted
        tree.childrenByParent[parentId] = list
        normalize(parentId: parentId)
    }

    public mutating func delete(id: Int) {
        guard var node = tree.nodes[id] else { return }
        node.softDelete = true
        node.lastActiveOrder = node.orderInParent
        tree.nodes[id] = node
        normalize(parentId: node.parentId)
    }

    public mutating func undelete(id: Int) {
        guard var node = tree.nodes[id] else { return }
        node.softDelete = false
        tree.nodes[id] = node

        var list = tree.childrenByParent[node.parentId] ?? []
        let active = activeIds(in: list)
        let insertIndex = min(node.lastActiveOrder ?? active.count, active.count)
        var newActive = active
        if !newActive.contains(id) {
            newActive.insert(id, at: insertIndex)
        }
        let deleted = softDeletedIds(in: list).filter { $0 != id }
        tree.childrenByParent[node.parentId] = newActive + deleted
        normalize(parentId: node.parentId)
    }

    public mutating func reorderWithinParent(parentId: Int, fromActiveIndex: Int, toActiveIndex: Int) {
        var list = tree.childrenByParent[parentId] ?? []
        var active = activeIds(in: list)
        guard fromActiveIndex >= 0, fromActiveIndex < active.count else { return }
        let destination = min(max(toActiveIndex, 0), active.count - 1)
        let moving = active.remove(at: fromActiveIndex)
        active.insert(moving, at: destination)
        let deleted = softDeletedIds(in: list)
        tree.childrenByParent[parentId] = active + deleted
        normalize(parentId: parentId)
    }

    public mutating func moveToParent(id: Int, newParentId: Int, toActiveIndex: Int? = nil) {
        guard var node = tree.nodes[id] else { return }
        let oldParentId = node.parentId
        removeFromParent(id: id, parentId: oldParentId)

        node.parentId = newParentId
        tree.nodes[id] = node

        var list = tree.childrenByParent[newParentId] ?? []
        let active = activeIds(in: list)
        let insertIndex = min(toActiveIndex ?? active.count, active.count)
        var newActive = active
        newActive.insert(id, at: insertIndex)
        let deleted = softDeletedIds(in: list)
        tree.childrenByParent[newParentId] = newActive + deleted

        normalize(parentId: oldParentId)
        normalize(parentId: newParentId)
    }

    // MARK: - Helpers

    private mutating func removeFromParent(id: Int, parentId: Int) {
        guard var list = tree.childrenByParent[parentId] else { return }
        list.removeAll { $0 == id }
        tree.childrenByParent[parentId] = list
    }

    private func activeIds(in list: [Int]) -> [Int] {
        list.compactMap { tree.nodes[$0] }
            .filter { !$0.softDelete }
            .sorted { $0.orderInParent < $1.orderInParent }
            .map { $0.id }
    }

    private func softDeletedIds(in list: [Int]) -> [Int] {
        list.compactMap { tree.nodes[$0] }
            .filter { $0.softDelete }
            .map { $0.id }
    }

    private mutating func normalize(parentId: Int) {
        guard var list = tree.childrenByParent[parentId] else { return }

        let activeNodes = list.compactMap { tree.nodes[$0] }
            .filter { !$0.softDelete }
            .sorted { $0.orderInParent < $1.orderInParent }

        var reorderedActiveIds: [Int] = []
        for (idx, var node) in activeNodes.enumerated() {
            node.orderInParent = idx
            node.lastActiveOrder = idx
            tree.nodes[node.id] = node
            reorderedActiveIds.append(node.id)
        }

        let deletedIds = list.compactMap { tree.nodes[$0] }
            .filter { $0.softDelete }
            .map { $0.id }

        list = reorderedActiveIds + deletedIds
        tree.childrenByParent[parentId] = list
    }

    private mutating func normalizeAll() {
        let parents = Set(tree.childrenByParent.keys)
        for parentId in parents {
            normalize(parentId: parentId)
        }
    }
}
