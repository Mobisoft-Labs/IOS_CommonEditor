//
//  LayerTreeBuilder.swift
//  IOS_CommonEditor
//
//  Builds a LayerTree from existing TemplateHandler models.
//

import Foundation

public enum LayerTreeBuilder {
    /// Build from a ParentModel (page or group). Includes soft-deleted nodes so undo/restore works.
    public static func build(from root: ParentModel) -> LayerTree {
        var nodes: [Int: LayerNode] = [:]
        var children: [Int: [Int]] = [:]
        var roots: [Int] = []

        func walk(model: BaseModel, depth: Int) {
            let node = LayerNode(
                id: model.modelId,
                parentId: model.parentId,
                orderInParent: model.orderInParent,
                depth: depth,
                softDelete: model.softDelete,
                lastActiveOrder: nil,
                isLocked: model.lockStatus,
                isHidden: model.isHidden,
                isExpanded: (model as? ParentModel)?.isExpanded ?? false,
                isSelected: model.isLayerAtive,
                type: model.modelType
            )
            nodes[model.modelId] = node
            if let parent = model as? ParentModel {
                let ids = parent.children.map { $0.modelId }
                children[model.modelId] = ids
                for child in parent.children {
                    walk(model: child, depth: depth + 1)
                }
            }
        }

        roots.append(root.modelId)
        walk(model: root, depth: 0)

        return LayerTree(nodes: nodes, childrenByParent: children, rootIds: roots)
    }
}
