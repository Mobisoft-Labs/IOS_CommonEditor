//
//  TreeViewModel.swift
//  Tree
//
//  Created by IRIS STUDIO IOS on 30/12/23.
//

import Foundation
import Combine


public class LayersViewModel2 : ObservableObject{
    
  weak var templateHandler : TemplateHandler!
    var cancellables = Set<AnyCancellable>()
    var actionCancellables = Set<AnyCancellable>()
    var layerConfig: LayersConfiguration?
    var designSystem: LayersDesignSystem?
    var logger: PackageLogger?
//    @Published var isCellSelected : Bool = false
//    @Published var lockStatus : Bool = false
//    @Published var isEditParent : Bool = false
    var selectedID = 0
    var isLockAllStatus: Bool {
        return templateHandler.currentPageModel!.unlockedModel.count == 0 ? true : false
    }
    
//    func refreshData(child:BaseModel) {
//        
////        parentIdsSelected = isSelected(childModel: child  )
////        toExpandSelected()
//    }
    
    func synchronizeEditStateToExpansionState() {
        for layer in layers {
            synchronizeStateForNode(layer)
        }
    }

    private func synchronizeStateForNode(_ node: BaseModel) {
        // If the node is a ParentModel, synchronize editState to isExpanded
        if let parentNode = node as? ParentModel {
            parentNode.isExpanded = parentNode.editState
           
        }
        node.isLayerAtive = node.isActive
        // If the node has children, recursively synchronize their state
        if let parentNode = node as? ParentModel {
            for child in parentNode.activeChildren {
                synchronizeStateForNode(child)
            }
        }
    }
    
    
    func onDoneClicked(){
        templateHandler.deepSetCurrentModel(id: selectedID)
    }

    public func setTemplateHandler(th:TemplateHandler) {
        self.templateHandler = th
        layers = [th.currentPageModel! as BaseModel]
        layers.first?.depthLevel = 0
        actionCancellables.removeAll()
        synchronizeEditStateToExpansionState()
        updateFlatternTree()
        cancellables.removeAll()
        
        $selectedChild.sink { model in
            
            self.selectedChild?.isLayerAtive = false
            self.selectedID = model?.modelId ?? 0
            model?.isLayerAtive = true
            
        }.store(in: &cancellables)
        
        selectedChild = th.currentModel
        
    }
    func observeModel() {

    }
    var layers = [BaseModel]()
    var flatternTree = [BaseModel]()
    
    var parentIdsSelected: [Int] = []
    @Published var selectedChild:BaseModel?
    
    init() {
      
    }
    
    func setPackageLogger(logger: PackageLogger, layersConfig: LayersConfiguration){
        self.logger = logger
        self.layerConfig = layersConfig
        self.designSystem = LayersDesignSystem(config: layersConfig)
    }
    
    func updateFlatternTree() {
        flatternTree = flattenedLayers()
    }
    
    var flatternNode = [Int]()
    
    
    
    func lockAll(){
        guard let model = templateHandler.currentPageModel else {
            logger?.printLog("current Page model is nil")
            
            return
        }
        templateHandler.currentActionState.lockAllState = true
       
        // change button State
    }
    
    
    func unLockAll(){
        guard let model = templateHandler.currentPageModel else {
            logger?.printLog("current Page model is nil")
            
            return
        }
        templateHandler.currentActionState.lockAllState = false
        // change button State
    }
    
    
    func isSelected(childModel: BaseModel?) -> [Int] {
        guard let childModel = childModel else {
            return []
        }
       let flatTree = flattenedLayersForAllParent()
        
        var parentIds: [Int] = []

        // Recursive function to find parent IDs
        func findParentIds(model: BaseModel?) {
            if let parentId = model?.parentId {
                parentIds.append(parentId)
                if let parentModel = flatTree.first(where: { $0.modelId == parentId }) as? ParentModel {
//                    parentModel.editState = true
                    if parentModel.depthLevel != 0{
                        findParentIds(model: parentModel)
                    }
                  
                }
                
            }
            
        }

        findParentIds(model: childModel)

        return parentIds
    }
    
   private func binarySearchForParentID(nodes: [BaseModel], targetParentID: Int) -> BaseModel? {
        var low = 0
        var high = nodes.count - 1

        while low <= high {
            let mid = (low + high) / 2
            let midNode = nodes[mid]

            if midNode.modelId == targetParentID {
                return midNode
            } else if  midNode.modelId < targetParentID {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }

        return nil
    }
    
    // Method to flatten the tree based on expansion state
    func flattenedLayers() -> [BaseModel] {
        
        var result: [BaseModel] = []

        for layer in layers {
            result += flattenedNodes(layer)
        }
        
        return result
    }

    // Helper method to recursively flatten nodes based on expansion state
    private func flattenedNodes(_ node: BaseModel) -> [BaseModel] {
        var result: [BaseModel] = []

        
        if let node = node as? ParentModel, node.isExpanded {
            if  node.modelId != 0 && !(node is PageInfo){
//                node.isLayerAtive = node.isActive
                result.append(node)
            }
            
            for child in node.activeChildren {
                result += flattenedNodes(child)
            }
        } else {
//            node.isLayerAtive = node.isActive
            result.append(node)
        }

        return result
    }
    
    
    func expandNode(_ node:ParentModel , expand: Bool) {
        var result: [BaseModel] = []
        
        for child in node.activeChildren {
            result += flattenedNodes(child)
        }
        
        if let index = flatternTree.firstIndex(where: { $0.modelId == node.modelId }) {
            
            if expand {
                var counter = index + 1
                result.forEach { node in
                    addChildToFlatternTree(node: node, atIndex: counter)
                    counter += 1
                }
            }else{
                result.forEach { node in
                    removeChildrenFromFlatternTree(for: node.modelId)
                }
                
            }
        }
        
    }
    
    // Method to flatten the tree based on expansion state for Full tree expand
   private func flattenedLayersForAllParent() -> [BaseModel] {
        var result: [BaseModel] = []

        for layer in layers {
            result += flattenedNodesForAllParent(layer)
        }

        return result
    }
    private func flattenedNodesForAllParent(_ node: BaseModel) -> [BaseModel] {
        var result: [BaseModel] = []

        if let node = node as? ParentModel, node.children.count>0 {
            result.append(node)
            for child in node.children {
                result += flattenedNodes(child)
            }
        } else {
            result.append(node)
        }

        return result
    }
    
    // Method to toggle the expansion state of a node
    func toggleLock(nodeID: Int) {
        if let node = findNodeByID(nodeID) {
            node.lockStatus = !node.lockStatus
          //  updateFlatternTree()
        }
    }
//    func toggleHidden(nodeID: Int) {
//        if let node = findNodeByID(nodeID) {
//            node.isHidden = !node.isHidden
//          //  updateFlatternTree()
//        }
//    }
    // Method to toggle the expansion state of a node
    func toggleExpansion(nodeID: Int) {
        if let node = findNodeByID(nodeID) as? ParentModel {
            node.isExpanded = !node.isExpanded
          //  isEditParent = node.isExpanded
          //  updateFlatternTree()
        }
    }

    func removeChildrenFromFlatternTree(for nodeID: Int) {
        // Find the node in the flattened tree
        if let index = flatternTree.firstIndex(where: { $0.modelId == nodeID }) {
            let node = flatternTree[index]

            // Remove children nodes from the flattened tree
            flatternTree.remove(at: index) // All(where: { $0.parentId == node.modelId })
        }
        // You might also need to update other data structures or perform additional logic based on your data model.
    }
    
    func addChildToFlatternTree(node: BaseModel , atIndex:Int) {
        // Find the node in the flattened tree
//        if let index = flatternTree.firstIndex(where: { $0.modelId == nodeID }) {
//            let node = flatternTree[index]

            // Remove children nodes from the flattened tree
            flatternTree.insert(node, at: atIndex)
       // }
        // You might also need to update other data structures or perform additional logic based on your data model.
    }
    
    func increaseOrderId(parentNode:ParentModel,order:Int)->ParentModel{
        // order of all children
        parentNode.increaseOrderFromIndex(order)
        
        return parentNode
        
    }
    
    func decreaseOrderId(parentNode:ParentModel,order:Int)->ParentModel{
        // order of all children
        parentNode.decreaseOrderFromIndex(order)
        
        return parentNode
        
    }
    
    func increaseChildLevel(depthLevel:Int,sourceNode:ParentModel)->ParentModel{
        
        sourceNode.increaseChildLevel(newLevel: depthLevel, logger: logger)
        return sourceNode
    }
    
    
    
    func decreaseChildLevel(depthLevel:Int,sourceNode:ParentModel)->ParentModel{
        
        sourceNode.decreaseChildLevel(newLevel: depthLevel, logger: logger)
        
        return sourceNode
    }
    
    func moveNode(sourceNode: BaseModel, inParent destinationParentNode: Int?, at order: Int) {
        // Check if destination's Parent node is not null
        guard let destinationParentId = destinationParentNode, var destinationParent = findNodeByID(destinationParentId)  as? ParentModel else {
            return
        }
        logOrder(parent: destinationParent, context: "pre-move destination parentId=\(destinationParentId) insertAt=\(order) sourceId=\(sourceNode.modelId)")
        
        // Check if Source node has a parent
        guard var sourceParentNode = findNodeByID(sourceNode.parentId) as? ParentModel else {
            return
        }
        logOrder(parent: sourceParentNode, context: "pre-move source parentId=\(sourceParentNode.modelId) sourceId=\(sourceNode.modelId)")

        if destinationParent.modelId == sourceParentNode.modelId {
            
            moveNodeInSameParent(parentNode: &destinationParent, sourceNode: sourceNode, order: order)
        } else {
            moveNodeInDifferentParent(sourceParentNode: &sourceParentNode, destinationParentNode: &destinationParent, sourceNode: sourceNode, order: order)
        }

        logOrder(parent: destinationParent, context: "post-move destination parentId=\(destinationParent.modelId)")
        if destinationParent.modelId != sourceParentNode.modelId {
            logOrder(parent: sourceParentNode, context: "post-move source parentId=\(sourceParentNode.modelId)")
        }
        // Update the flattened tree if needed
        updateFlatternTree()
    }

    private func moveNodeInSameParent(parentNode: inout ParentModel, sourceNode: BaseModel, order: Int) {
        // Remove the source from current children list first.
        if let index = parentNode.children.firstIndex(where: { $0.modelId == sourceNode.modelId }) {
            parentNode.children.remove(at: index)
        }
        let active = parentNode.children.filter { !$0.softDelete }
        let targetIndex = min(max(0, order), active.count)
        var newActive = active
        newActive.insert(sourceNode, at: targetIndex)
        rebuildChildren(parentNode: &parentNode, activeChildren: newActive)
        normalizeActiveOrders(parentNode: parentNode)
    }

    private func moveNodeInDifferentParent(sourceParentNode: inout ParentModel, destinationParentNode: inout ParentModel, sourceNode: BaseModel, order: Int) {
        sourceNode.parentId = destinationParentNode.modelId

        // Remove source node from Source's parent at source sequence
        if let index = sourceParentNode.children.firstIndex(where: { $0.modelId == sourceNode.modelId }) {
            sourceParentNode.children.remove(at: index)
        }

        // Adjust depth level if needed
        if sourceNode.depthLevel == destinationParentNode.depthLevel+1{ // same parent
            // if depth level is same don't change depth level
        }else if sourceNode.depthLevel > destinationParentNode.depthLevel+1{
            // child is move to parent
            sourceNode.depthLevel = destinationParentNode.depthLevel+1
            if let sourceIsParent = sourceNode as? ParentModel {
                sourceIsParent.decreaseChildLevel(newLevel: destinationParentNode.depthLevel+1, logger: logger)
            }
            
        }else{
            // parent is move to child
            sourceNode.depthLevel = destinationParentNode.depthLevel+1
            if let sourceIsParent = sourceNode as? ParentModel {
                sourceIsParent.increaseChildLevel(newLevel: destinationParentNode.depthLevel+1, logger: logger)
            }
        }

        let destinationActive = destinationParentNode.children.filter { !$0.softDelete }
        let targetIndex = min(max(0, order), destinationActive.count)
        var newActive = destinationActive
        newActive.insert(sourceNode, at: targetIndex)
        rebuildChildren(parentNode: &destinationParentNode, activeChildren: newActive)
        normalizeActiveOrders(parentNode: destinationParentNode)
        normalizeActiveOrders(parentNode: sourceParentNode)
    }

  //  private func removeNode(parentNode: inout BaseModel, node: BaseModel, at sequence: Int) {
//        if let index = parentNode.children.firstIndex(where: { $0.modelId == node.modelId }) {
//            parentNode.children.remove(at: sequence)
//        } else {
//            print("Source node is not present at source Parent's children")
//        }
  //  }

    
   
    // Helper method to find a node by ID in the layers tree
     func findNodeByID(_ nodeID: Int) -> BaseModel? {
        for layer in layers {
            if let foundNode = layer.findNodeByID(nodeID) {
                return foundNode
            }
        }
        return nil
    }
    
    func getChildrenIndexPaths(for parentIndexPath: IndexPath) -> [IndexPath] {
        let parentNode = flatternTree[parentIndexPath.item]

        var indexPaths: [IndexPath] = []
        var currentIndex = parentIndexPath.item + 1

        // Ensure the currentIndex is within bounds
        while currentIndex < flatternTree.count {
            let currentNode = flatternTree[currentIndex]

            // Check if the currentNode is a child of the parentNode
            if parentNode.depthLevel < currentNode.depthLevel {
                let childIndexPath = IndexPath(item: currentIndex, section: parentIndexPath.section)
                indexPaths.append(childIndexPath)
            } else {
                // Break the loop if the currentNode is not a child
                break
            }

            currentIndex += 1
        }

        return indexPaths
    }
    
    private func logOrder(parent: ParentModel, context: String) {
        let childDesc = parent.children
            .map {"\($0.modelId):\($0.orderInParent)\($0.softDelete ? "D" : "ND")" }
            .joined(separator: ",")
        let activeDesc = parent.activeChildren
            .map { "\($0.modelId):\($0.orderInParent)" }
            .joined(separator: ",")
        let message = "[LayersOrder] \(context) children[\(parent.children.count)]=[\(childDesc)] active[\(parent.activeChildren.count)]=[\(activeDesc)]"
        if let logger = logger {
            logger.printLog(message)
        } else {
            print(message)
        }
    }

    private func rebuildChildren(parentNode: inout ParentModel, activeChildren: [BaseModel]) {
        let deleted = parentNode.children.filter { $0.softDelete }
        parentNode.children = activeChildren + deleted
    }

    private func normalizeActiveOrders(parentNode: ParentModel) {
        let active = parentNode.children.filter { !$0.softDelete }
        for (idx, child) in active.enumerated() {
            if child.orderInParent == idx { continue }
            child.orderInParent = idx
            _ = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: idx)
        }
    }
}

extension LayersViewModel2{
    
    func lockAllModels(){
        lockAll()
    }
    
    func unlockAllModels(){
        unLockAll()
    }
    
    func lockAll(parentInfo:ParentModel,state:Bool){
        for child in parentInfo.children{
            child.lockStatus = state
           _ = DBManager.shared.updateLockStatus(modelId: child.modelId, newValue: child.lockStatus.toString())
            if child is ParentModel{
                lockAll(parentInfo: child as! ParentModel, state: state)
            }
        }
    }

}
