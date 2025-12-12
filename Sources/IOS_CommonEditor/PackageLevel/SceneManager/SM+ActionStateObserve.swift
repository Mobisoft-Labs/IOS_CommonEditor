//
//  SM+ActionStateObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension SceneManager {
    public func observeCurrentActions() {
        
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
        
        
        actionStateCancellables.removeAll()
        logger.logVerbose("SM + CurrentActions listeners ON \(actionStateCancellables.count)")
        
        templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] model in
            
            guard var self = self else { return }
            logger.logVerbose("SM+ modelChange to \(model!.modelType.rawValue)")

            if let selectedModel = model {
                switch selectedModel.modelType {
                case .Page:
                    // Handle page change
                    if let newPage = self.mChildHandler.getModel(modelId: selectedModel.modelId){
                        self.currentPage = newPage
                        self.currentParent = newPage
                        self.currentChild = newPage
                       // observePage()
                        logger.printLog("Selected page model \(newPage.id)")
                    }
                case .Parent:
                    // Handle parent change
                    if let newParent = self.mChildHandler.getModel(modelId: selectedModel.modelId){//}, newParent.id != self.currentParent?.id {
                        self.currentChild = newParent
                        self.currentParent = newParent
                    
                        logger.printLog("Selected parent model \(newParent.id)")
                    }
                default:
                    // Handle other model types
                    if let newChild = self.mChildHandler.getModel(modelId: selectedModel.modelId), newChild.id != self.currentChild?.id {
                        self.currentChild = newChild
                        self.currentParent = newChild.parent
                        print("Selected child model", newChild.id)
                    }
                }
            }
            observeModel(templateHandler: templateHandler)
        
            
        }).store(in:&actionStateCancellables)
        
        
       
            
        templateHandler.$renderingState.sink { [weak self] state in
            guard let self = self else { return }
                if templateHandler.renderingState != state{
                    self.currentScene?._renderingMode = state
                    redraw()
                }
             
            }.store(in: &actionStateCancellables)
            
        
      
        templateHandler.currentActionState.$moveModel.dropFirst().sink {  [weak self] value in
            guard let self = self else { return }
         
            guard let moveModel = value else { return }
            
            
         
                if moveModel.oldMM.count<1{
                    logger.printLog("move model is empty")
                    return
                }
            
            
            // we are checking if any parent needs to be unDelete
            
            if moveModel.type == .UnGroup || moveModel.type == .Group {
                if let parentIdToAdd = moveModel.shouldAddParentID  {
                    
                    // check if its alredy avaiable in dictionary ,
                    if let mParent = mChildHandler.childDict[parentIdToAdd] as? MParent {
                        mParent.setMSoftDelete(false)
                        logger.logInfo("Group/Ungroup Parent \(parentIdToAdd) Added -SM")

                    }
                    
                    
                }
            }
            
                // old Model and new Model always same index
                // only check from one of those no of element in array
                for index in 0...moveModel.oldMM.count-1{
                    // store  child model old Value
                    let oldChildValue = moveModel.oldMM[index]
                    // stor child model new value
                    let newChildValue = moveModel.newMM[index]
                    
                  
                    // optional check old parent , newParent and extingChild
                    if var oldParent =  mChildHandler.childDict[oldChildValue.parentID] as? MParent,var newParent = mChildHandler.childDict[newChildValue.parentID] as? MParent,var existingChild = mChildHandler.childDict[oldChildValue.modelID]{
                        
                        // check if only sequence is check in same Parent
                        if oldChildValue.parentID == newChildValue.parentID{
                      
                            guard let childToMove = mChildHandler.getModel(modelId: oldChildValue.modelID) ,
                                let parent = childToMove.parent  else {
                                logger.logError("Either Parent Or Child Is Nil In MetalDict")
                                return
                            }
                            parent.changeOrder(child: childToMove, oldOrder: oldChildValue.orderInParent, newOrder: newChildValue.orderInParent)

                        }// end of checking same parent
                        else{
                            
                            // remove child and change order
                            oldParent.removeChild(existingChild)
                            oldParent.decreaseChildOrderInParent(order: oldChildValue.orderInParent)
                            
                            // change flip
                                existingChild.mFlipType_hori = newChildValue.hFlip.toFloat()
                            
                           
                                existingChild.mFlipType_vert = newChildValue.vFlip.toFloat()
                            

                            // Update the child's position
                            existingChild.setmCenter(centerX: newChildValue.baseFrame.center.x, centerY: newChildValue.baseFrame.center.y)
                            // Update the child's size
                            existingChild.setmSize(width: newChildValue.baseFrame.size.width, height: newChildValue.baseFrame.size.height)
                            existingChild.mOrder = newChildValue.orderInParent
                            existingChild.setmZRotation(rotation: newChildValue.baseFrame.rotation)
                            existingChild.setMStartTime(newChildValue.baseTime.startTime)
                            existingChild.setMDuration(newChildValue.baseTime.duration)
                            
                            for parent in newChildValue.arrayOFParents{
                                if let parentInArray =  mChildHandler.childDict[parent.modelID]{
                                    // change frame
                                    parentInArray.setmSize(width: parent.BaseFrame.size.width, height: parent.BaseFrame.size.height)
                                    parentInArray.setmCenter(centerX: parent.BaseFrame.center.x, centerY: parent.BaseFrame.center.y)
                                    parentInArray.setmZRotation(rotation: parent.BaseFrame.rotation)
                                    
                                    // change time
                                    
                                    parentInArray.setMStartTime(parent.BaseTime.startTime)
                                    parentInArray.setMDuration(parent.BaseTime.duration)
                                    
                                    
                                    for child in parent.Child{
                                        
                                        if let childModel = mChildHandler.childDict[child.modelID]{
                                            
                                            // change frame
                                            childModel.setmSize(width: child.BaseFrame.size.width, height: child.BaseFrame.size.height)
                                            childModel.setmCenter(centerX: child.BaseFrame.center.x, centerY: child.BaseFrame.center.y)
                                            childModel.setmZRotation(rotation: child.BaseFrame.rotation)
                                            
                                            // change time
                                            
                                            childModel.setMStartTime(child.BaseTime.startTime)
                                            childModel.setMDuration(child.BaseTime.duration)
                                            
                                        }
                                        
                                    }// end of child in Parent
                                    
                                    
                                }// end of get parent from child Dict
                                
                            }// end of for loop
                           
                            
                            // add child in a order
                            
                           
                            newParent.addChild(existingChild, at: newChildValue.orderInParent)
                            newParent.increaseChildOrderInParent(order:  newChildValue.orderInParent+1)
                            
                        }//end of changing value in diffrent parent
                        
                        
                    }
                    
                }

            if moveModel.type == .UnGroup || moveModel.type == .Group {
                if let parentIdToAdd = moveModel.shouldRemoveParentID  {
                    
                    // check if its alredy avaiable in dictionary ,
                    if let mParent = mChildHandler.childDict[parentIdToAdd] as? MParent {
                        mParent.setMSoftDelete(true)
                        logger.logInfo("Group/Ungroup Parent \(parentIdToAdd) Deleted -SM")
                    }
                    
                    
                }
            }
                
            redraw()
            
        }.store(in: &actionStateCancellables)
            
           
        templateHandler.currentTemplateInfo?.$outputType.dropFirst().sink {   [weak self] type in
            guard let self = self else { return }
            
            if type == .Image {
                currentScene?._shouldOverrideCurrentTime = true
                currentScene?._renderingMode = .Edit
            
            }else {
                currentScene?._shouldOverrideCurrentTime = false
                currentScene?._renderingMode = .Animating
            }
            
            redraw()
            
        }.store(in: &actionStateCancellables)
            
       
        
    }
}
