//
//  VM+MultiSelectMode.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 28/01/25.
//

//
//  VM+EditParentObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//
import Combine

extension ViewManager {
    
    // For Observing the property of edit sate models
    func observeEditStateListener(model : BaseModel){
        // Ensure model has a unique ID to use as a key
        let modelID = model.modelId
        let parentModel = model as? ParentInfo
        
        // Initialize an empty set if this model doesn't have cancellables yet
        if editStateCancellables[modelID] == nil {
            editStateCancellables[modelID] = Set<AnyCancellable>()
        }
        
        if self.controlBarContainer.firstIndex(where: { $0.rootView.id == modelID }) == nil {
            // If no element with the specified `modelID` exists, draw the control bar
            self.drawControlBarForEdit(model: parentModel!)
        } else {
            // Optional: Handle the case where the control bar already exists
            logger.printLog("Control bar with modelID already exists.")
        }
       
        
        parentModel?.$editState.dropFirst().sink{ [weak self] isEdited in
            
            // if isEdited true then draw the children of the view.
            
            self?.templateHandler?.updateFlatternTree(modelId: parentModel!.modelId)
            let parentView = self?.rootView?.viewWithTag(modelID) as? ParentView
            if isEdited{
                self?.logger.printLog("NK Add the chile info.")
                
                //update flatten tree and load multiSelect array
               
                self?.templateHandler?.currentActionState.multiSelectedItems.removeAll(where: {$0.modelId == parentModel?.modelId})
                self?.templateHandler?.expandNode(parentModel!, expand: isEdited)
                self?.templateHandler?.currentActionState.multiUnSelectItems = self?.templateHandler?.flatternTree ?? []
                
                self?.expandParent(parentID: parentModel!.modelId)
                parentView?.vIS_EDIT = true
              //  parentView?.isEditStateSelected = true
                
                
            }
            // if isEdited false then remove the children of particular view.
            else{
                self?.logger.printLog("Remove the child info.")
                self?.templateHandler?.expandNode(parentModel!, expand: isEdited)
                self?.templateHandler?.currentActionState.multiUnSelectItems = self?.templateHandler?.flatternTree ?? []
                self?.collapseParent(parentId: parentModel!.modelId)
                parentView?.vIS_EDIT = false
               
            }
        }.store(in: &editStateCancellables[modelID]!)
    }
    
    // For removing the cancellables form the cancellable for the particular model id.
    func removeEditStateListener(for model: BaseModel) {
        let modelID = model.modelId
        let parentModel = model as? ParentInfo
        
        if let index = controlBarContainer.firstIndex(where: { $0.rootView.id == modelID }) , !parentModel!.editState {
            let controlBarView = controlBarContainer[index]
                      
            // Remove the view from the parent and the array
            controlBarView.willMove(toParent: nil)
            controlBarView.view.removeFromSuperview()
            controlBarView.removeFromParent()
              
            controlBarContainer.remove(at: index)
        }
        // Cancel all cancellables for this model and remove them from the dictionary
        editStateCancellables[modelID]?.forEach { $0.cancel() }
        editStateCancellables[modelID] = nil
    }
    
    
    func groupingDidStart(_ didStart : Bool ) {
        if didStart {
            showControlBar = false
            
            
        }else {
            rootView!.turnOffGrouping()
            removeEditListeners()
        }
    }
}
