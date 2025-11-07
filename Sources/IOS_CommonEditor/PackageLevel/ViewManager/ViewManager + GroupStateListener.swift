//
//  ViewManager + GroupStateListener.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 29/10/24.
//

import Combine

extension ViewManager{
    
    func removeEditListeners(){
        for container in self.controlBarContainer {
            // Remove the view from the parent and the array
            container.willMove(toParent: nil)
            container.view.removeFromSuperview()
            container.removeFromParent()
        }
        for model in templateHandler!.currentActionState.multiUnSelectItems {
            print(model)
            if let parentModel = model as? ParentInfo, parentModel.editState == true{
                    parentModel.editState = false
                    self.collapseParent(parentId: model.modelId)
            }
            
        }
        controlBarContainer.removeAll()
        editStateCancellables.removeAll()
    }
    
    func hideEditButton(id : Int){

        guard let currentPageView = rootView?.currentPage else {
            logger.logError("No Current Page Found")
            return
        }
        let parentId = templateHandler?.getModel(modelId: id)?.parentId
        if parentId != currentPageView.tag{
            if let editControlIndex = self.controlBarContainer.firstIndex(where: { $0.rootView.id == parentId }){
                // If no element with the specified `modelID` exists, draw the control bar
               let editControl =  controlBarContainer[editControlIndex]
                editControl.view.isHidden = true
            }
        }
    }
    
    func unhideEditButton(id : Int){
        /* If page does not have any selected child
         then show edit button into the selected array.
         */
        let parentId = templateHandler?.getModel(modelId: id)?.parentId
        guard let currentPageView = rootView?.currentPage else {
            logger.logError("No Current Page Found")
            return
        }
        if parentId != currentPageView.tag{
            let children = templateHandler?.getChildrenFor(parentID: parentId!)
            for child in children!{
                if templateHandler!.currentActionState.multiSelectedItems.contains(where: { selectedChild in
                    selectedChild.modelId == child.modelId
                }){
                    return
                }
                if let editControlIndex = self.controlBarContainer.firstIndex(where: { $0.rootView.id == parentId }){
                    // If no element with the specified `modelID` exists, draw the control bar
                   let editControl =  controlBarContainer[editControlIndex]
                    editControl.view.isHidden = false
                }
                
            }
        }
    }
    
   
}
