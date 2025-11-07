//
//  Engine+RemoveOperation.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

extension MetalEngine {
    // Method to ungroup a parent model and reassign its children to the current page model
    func ungroupParent(parentID:Int) {
        // create move child with new Properties
        var moveModel = MoveModel(type: .UnGroup, oldMM: [], newMM: [])
        
        
        if let parent = templateHandler.getModel(modelId: parentID) as? ParentInfo{
            
            
            // get the child of page
            if let page = templateHandler.currentPageModel{
                
                var count = page.children.count
                for child in parent.children{
                    // create moveModel for each child
                    
                    
                    let moveModels =  templateHandler.moveChildIntoNewParent(modelID: child.modelId, newParentID: page.modelId, order: count)
                    moveModel.oldMM.append(moveModels.oldMM[0])
                    moveModel.newMM.append(moveModels.newMM[0])
                    count += 1
                    //            }
                    
                }
                // let model =  templateHandler.currentActionState.moveModel
                moveModel.type = .UnGroup
//                moveModel.newParentID = page.modelId
//                moveModel.oldParentID = parentID
                moveModel.newLastSelected = page.children.first!.modelId
                moveModel.oldlastSelectedId = parentID
               
               
                    moveModel.shouldAddParentID = nil
                    moveModel.shouldRemoveParentID = parentID
                
                templateHandler?.performGroupAction(moveModel: moveModel)
                //                templateHandler.currentActionState.moveModel = moveModel
                //                templateHandler.setCurrentModel(id: page.modelId)
                
                //                // Check if any old parents need to be removed after ungrouping
                //                for oldParent in moveModel.oldMM.map({ $0.parentID }).unique() {
                //                    if viewManager.isParentEmpty(parentID: oldParent) {
                //                        viewManager.removeParent(parentID: oldParent)
                //                    }
                //                }
                
            }else{
                logger.printLog("page in not found")
            }
            
        }else{
            logger.printLog("parent is not found so that ungroup not perform")
        }
    }
}
