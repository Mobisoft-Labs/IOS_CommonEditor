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
    public var thumbImage: Data?

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
        type: ContentType,
        thumbImage: Data? = nil
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
        self.thumbImage = thumbImage
    }
}

public struct LayerTree {
    public var nodes: [Int: LayerNode]
    public var childrenByParent: [Int: [Int]]
    public var rootIds: [Int]

    public init(nodes: [Int: LayerNode], childrenByParent: [Int: [Int]], rootIds: [Int]) {
        self.nodes = nodes
        self.childrenByParent = childrenByParent
        self.rootIds = rootIds
    }

    public func activeChildren(of parentId: Int) -> [LayerNode] {
        let ids = childrenByParent[parentId] ?? []
        return ids.compactMap { nodes[$0] }
            .filter { !$0.softDelete }
            .sorted { $0.orderInParent < $1.orderInParent }
    }
}
