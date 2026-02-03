import XCTest
@testable import IOS_CommonEditor

final class LayerReducerTests: XCTestCase {

    private func makeTree() -> LayerTree {
        let root = LayerNode(id: 0, parentId: -1, orderInParent: 0, depth: 0, type: .Page)
        let a = LayerNode(id: 1, parentId: 0, orderInParent: 0, depth: 1, type: .Sticker)
        let b = LayerNode(id: 2, parentId: 0, orderInParent: 1, depth: 1, type: .Text)
        let c = LayerNode(id: 3, parentId: 0, orderInParent: 2, depth: 1, type: .Text)

        var nodes: [Int: LayerNode] = [0: root, 1: a, 2: b, 3: c]
        let children: [Int: [Int]] = [0: [1, 2, 3]]
        return LayerTree(nodes: nodes, childrenByParent: children, rootIds: [0])
    }

    func testReorderWithinParentMaintainsDenseOrder() {
        var reducer = LayerReducer(tree: makeTree())
        reducer.reorderWithinParent(parentId: 0, fromActiveIndex: 0, toActiveIndex: 2)

        let active = reducer.tree.activeChildren(of: 0)
        XCTAssertEqual(active.map { $0.id }, [2, 3, 1])
        XCTAssertEqual(active.map { $0.orderInParent }, [0, 1, 2])
    }

    func testSoftDeleteCreatesGapButNormalizeRemovesIt() {
        var reducer = LayerReducer(tree: makeTree())
        reducer.delete(id: 2) // delete middle

        let active = reducer.tree.activeChildren(of: 0)
        XCTAssertEqual(active.map { $0.id }, [1, 3])
        XCTAssertEqual(active.map { $0.orderInParent }, [0, 1])

        reducer.undelete(id: 2)
        let activeAfterUndo = reducer.tree.activeChildren(of: 0)
        XCTAssertEqual(activeAfterUndo.map { $0.id }, [1, 2, 3])
        XCTAssertEqual(activeAfterUndo.map { $0.orderInParent }, [0, 1, 2])
    }

    func testMoveToParentAppendsAndNormalizes() {
        var reducer = LayerReducer(tree: makeTree())
        // Make node 3 a child of node 1
        reducer.moveToParent(id: 3, newParentId: 1, toActiveIndex: nil)

        let rootActive = reducer.tree.activeChildren(of: 0)
        XCTAssertEqual(rootActive.map { $0.id }, [1, 2])
        XCTAssertEqual(rootActive.map { $0.orderInParent }, [0, 1])

        let childActive = reducer.tree.activeChildren(of: 1)
        XCTAssertEqual(childActive.map { $0.id }, [3])
        XCTAssertEqual(childActive.first?.orderInParent, 0)
        XCTAssertEqual(reducer.tree.nodes[3]?.parentId, 1)
    }

    func testMoveWithinParentWithSoftDeletedSiblingDoesNotCrash() {
        var reducer = LayerReducer(tree: makeTree())
        reducer.delete(id: 2)
        reducer.reorderWithinParent(parentId: 0, fromActiveIndex: 1, toActiveIndex: 0) // move id 3 above id 1

        let active = reducer.tree.activeChildren(of: 0)
        XCTAssertEqual(active.map { $0.id }, [3, 1])
        XCTAssertEqual(active.map { $0.orderInParent }, [0, 1])
    }
}
