//
//  MetalEngine + CRUD Operation.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 02/04/24.
//

import Foundation

// Move-Model Special 

extension MetalEngine{
   
    
    // Method to change the order of the current page model within its parent's children list
    func orderChange(newOrder: Int) {
        // Ensure there is a current page model to work with
        if let pageModel = templateHandler.currentPageModel {
            
            // Get the current order of the page model within its parent
            let oldOrder = pageModel.orderInParent
            
            if oldOrder < newOrder {
                // Decrease the order of children from oldOrder + 1 to newOrder by 1
                var updateDicNTime = templateHandler.decreaseOrderOFChildren(from: oldOrder + 1, to: newOrder, pageDuration: pageModel.baseTimeline.duration)
                var updateDict = updateDicNTime!.0
                
                var startTime =  updateDicNTime!.1
                
                var child = templateHandler.currentTemplateInfo?.pageInfo[oldOrder]
                if let startTime =  updateDicNTime?.1{
                    child?.orderInParent = newOrder
                    child?.baseTimeline.startTime = startTime
                }
                
                // Remove the page from the template at the old order position
                templateHandler.currentTemplateInfo?.pageInfo.remove(at: oldOrder)
                
                // Update the dictionary with the new order for the current page model
                updateDict[pageModel.modelId] = newOrder
                
                // Insert the page into the template at the new order position
                templateHandler.currentTemplateInfo?.pageInfo.insert(child!, at: newOrder)
                if !(isDBDisabled){
                    _ = DBManager.shared.updateOrderInParent(modelId: pageModel.modelId, newValue: newOrder)
                    _ = DBManager.shared.updateStartTime(modelId: pageModel.modelId, newValue: startTime)
                }
                
//                templateHandler.currentPageModel = pageModel
                
                templateHandler.currentActionState.updatePageArray = true
                
             } else {
                // Increase the order of children from newOrder to oldOrder - 1 by 1
                 
                 var updateDicNTime = templateHandler.increaseOrderOFChildren(from: newOrder, to: oldOrder - 1 , pageDuration: pageModel.baseTimeline.duration)
                 
                 var updateDict = updateDicNTime!.0
                 
                 var startTime =  updateDicNTime!.1
                 
                 var child = templateHandler.currentTemplateInfo?.pageInfo[oldOrder]
                 child?.orderInParent = newOrder
                 child?.baseTimeline.startTime = startTime
                 
                
                // Remove the page from the template at the old order position
                templateHandler.currentTemplateInfo?.pageInfo.remove(at: oldOrder)
                
                // Update the dictionary with the new order for the current page model
                updateDict[pageModel.modelId] = newOrder
                // Insert the page into the template at the new order position
                 templateHandler.currentTemplateInfo?.pageInfo.insert(child!, at: newOrder)
                 
                 templateHandler.currentActionState.updatePageArray = true
                 
                 if !(isDBDisabled){
                     _ = DBManager.shared.updateOrderInParent(modelId: pageModel.modelId, newValue: newOrder)
                     _ = DBManager.shared.updateStartTime(modelId: pageModel.modelId, newValue: startTime)
                 }
            }
            
            // Optionally update the orderInParent property of the page model (if needed)
            // pageModel.orderInParent = newOrder
        }
    }

    // Method to change the order of the current page model within its parent's children list
    func orderChangeInSameParent(newOrder: Int) {
        // Ensure there is a current page model to work with
        if let parentModel = templateHandler.currentSuperModel,let current = templateHandler.currentModel {
            
            // Get the current order of the page model within its parent
            let oldOrder = current.orderInParent
            
            if oldOrder < newOrder {
                // Decrease the order of children from oldOrder + 1 to newOrder by 1
//                var updateDict = templateHandler.currentTemplateInfo?.decreaseOrderOFChildren(from: oldOrder + 1, to: newOrder)
                
                // Remove the page from the template at the old order position
                parentModel.children.remove(at: oldOrder)
                
                parentModel.decreaseOrderFromIndex(oldOrder, to: newOrder-1)
                current.orderInParent = newOrder
//                parentModel.decreaseOrderFromIndex(<#T##Int#>)
                // Update the dictionary with the new order for the current page model
//                updateDict?[pageModel.modelId] = newOrder
                
                // Insert the page into the template at the new order position
                parentModel.children.insert(current, at: newOrder)
               _ = DBManager.shared.updateOrderInParent(modelId: current.modelId, newValue: newOrder)
                
            } else {
                // Increase the order of children from newOrder to oldOrder - 1 by 1
//                var updateDict = templateHandler.currentTemplateInfo?.increaseOrderOFChildren(from: newOrder, to: oldOrder - 1)
                
                // Remove the page from the template at the old order position
                parentModel.children.remove(at: oldOrder)
                current.orderInParent = newOrder
                parentModel.children.insert(current, at: newOrder)
                parentModel.increaseOrderFromIndex(newOrder+1, to: oldOrder)
                if !(isDBDisabled){
                    _ = DBManager.shared.updateOrderInParent(modelId: current.modelId, newValue: newOrder)
                }
                
                // Update the dictionary with the new order for the current page model
//                updateDict?[pageModel.modelId] = newOrder
                
                // Insert the page into the template at the new order position
//                templateHandler.currentParentModel?.children.insert(pageModel, at: newOrder)
            }
            
            // Optionally update the orderInParent property of the page model (if needed)
            // pageModel.orderInParent = newOrder
        }
    }
    
    // Method to swap pages within the template by changing their order
    private func swapPages(model: PageInfo, oldOrder: Int, newOrder: Int) {
        // Check if the old order is different from the new order
        if oldOrder == newOrder {
            return
        }
        
        // Remove the page from the old order position
        templateHandler.currentTemplateInfo?.pageInfo.remove(at: oldOrder)
        
        if oldOrder > newOrder {
            // Increase the order of children from newOrder to oldOrder - 1 by 1
           _ = templateHandler.currentTemplateInfo?.increaseOrderOFChildren(at: newOrder)
        } else if oldOrder < newOrder {
            // Decrease the order of children from oldOrder + 1 to newOrder by 1
          _ = templateHandler.currentTemplateInfo?.decreaseOrderOFChildren(at: newOrder)
        }
        
        // Insert the model into the new order position
        templateHandler.currentTemplateInfo?.pageInfo.insert(model, at: newOrder)
    }

}
