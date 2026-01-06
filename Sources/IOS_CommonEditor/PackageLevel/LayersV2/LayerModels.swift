//
//  LayerModels.swift
//  IOS_CommonEditor
//
//  Lightweight data structures for Layers v2. The reducer guarantees that
//  active (non-soft-deleted) children have dense orderInParent values (0...n-1).
//

import Foundation

public struct LayerNode: Equatable {
    public var id: Int
    public var parentId: Int
    public var orderInParent: Int
    public var depth: Int
    public var softDelete: Bool
    public var lastActiveOrder: Int?
    public var isLocked: Bool
    public var isHidden: Bool
    public var isExpanded: Bool
    public var isSelected: Bool
    public var type: ContentType

    public init(
        id: Int,
        parentId: Int,
        orderInParent: Int,
        depth: Int,
        softDelete: Bool = false,
        lastActiveOrder: Int? = nil,
        isLocked: Bool = false,
        isHidden: Bool = false,
        isExpanded: Bool = false,
        isSelected: Bool = false,
        type: ContentType
    ) {
        self.id = id
        self.parentId = parentId
        self.orderInParent = orderInParent
        self.depth = depth
        self.softDelete = softDelete
        self.lastActiveOrder = lastActiveOrder
        self.isLocked = isLocked
        self.isHidden = isHidden
        self.isExpanded = isExpanded
        self.isSelected = isSelected
        self.type = type
    }
}

/// Tree representation with adjacency lists keyed by parentId.
public struct LayerTree {
    public var nodes: [Int: LayerNode]
    public var childrenByParent: [Int: [Int]]
    public var rootIds: [Int]

    public init(nodes: [Int: LayerNode], childrenByParent: [Int: [Int]], rootIds: [Int]) {
        self.nodes = nodes
        self.childrenByParent = childrenByParent
        self.rootIds = rootIds
    }

    /// Returns active (non-soft-deleted) children for a parent, ordered by orderInParent.
    public func activeChildren(of parentId: Int) -> [LayerNode] {
        let ids = childrenByParent[parentId] ?? []
        return ids.compactMap { nodes[$0] }
            .filter { !$0.softDelete }
            .sorted { $0.orderInParent < $1.orderInParent }
    }

    /// Returns all children including soft-deleted entries in stored order.
    public func allChildren(of parentId: Int) -> [LayerNode] {
        let ids = childrenByParent[parentId] ?? []
        return ids.compactMap { nodes[$0] }
    }

    /// Flattens the tree into a depth-annotated outline (respecting expansion flags).
    public func flattened(includeSoftDeleted: Bool = true) -> [LayerNode] {
        var result: [LayerNode] = []
        func dfs(_ id: Int) {
            guard let node = nodes[id] else { return }
            if !includeSoftDeleted && node.softDelete { return }
            result.append(node)
            guard node.isExpanded else { return }
            for childId in childrenByParent[id] ?? [] {
                dfs(childId)
            }
        }
        for root in rootIds {
            dfs(root)
        }
        return result
    }
}
