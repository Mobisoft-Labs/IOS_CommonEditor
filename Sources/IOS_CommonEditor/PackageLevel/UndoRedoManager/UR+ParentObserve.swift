//
//  UR+ParentObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//


extension UndoRedoManager {
    // Observe the Parent Model.
    public func observeAsCurrentParent(_ parentModel: ParentInfo) {

        parentModel.$modelFlipHorizontal.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState{
              
                    
                let flipOperation = OperationAction.flipHorizontalChanged(FlipHorizontalAction(oldvalue: parentModel.modelFlipHorizontal, newValue: newValue, id: parentModel.modelId))
                    
                    var shouldAdd = true
 
                    self.addOperation(flipOperation,shouldAdd: shouldAdd)
                
            }
            logger.printLog("undo Registered new flipH value: \(newValue) old flipH value: \(parentModel.modelFlipHorizontal)")
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$modelFlipVertical.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState {
                
                let flipOperation = OperationAction.flipVeticalChanged(FlipVerticalAction(oldvalue: parentModel.modelFlipVertical, newValue: newValue, id: parentModel.modelId))
                
                var shouldAdd = true
                self.addOperation(flipOperation,shouldAdd: shouldAdd)
            }
            logger.printLog("undo Registered new flipV value: \(newValue) old flipV value: \(parentModel.modelFlipVertical)")
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$lockStatus.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState {
                let lockOperation = OperationAction.lockChanged(LockUnlockAction(oldStatus: parentModel.lockStatus, newStatus: newValue, id: parentModel.modelId))
                
                var shouldAdd = true
                self.addOperation(lockOperation,shouldAdd: shouldAdd)
                
               
            }
            logger.printLog("undo Registered new lock value: \(newValue) old lock value: \(parentModel.lockStatus)")
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$endOpacity.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if !undoState {
                addOperation(.OpacityChanged(OpacityUndoModel(oldOpacity: parentModel.beginOpacity, newOpacity: parentModel.endOpacity, id: parentModel.modelId)))
            }
            logger.printLog("undo Registered new value: \(parentModel.endOpacity) old opacity: \(parentModel.beginOpacity)")
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$softDelete.dropFirst().sink{ [weak self] softDelete in
            guard let self = self else { return }
            if !undoState {
                addOperation(.deleteAction(DeleteAction(oldValue: !softDelete, newValue: softDelete, id: parentModel.modelId, oldShouldSelectID: parentModel.modelId, newShouldSelectID: parentModel.parentId)))
            }
        }.store(in: &modelPropertiesCancellables)
 
        parentModel.$endFrame.dropFirst().sink{ [weak self] newFrame in
            guard let self = self else { return }
            if !undoState {
                guard let templateHandler = templateHandler else { return }
                if newFrame.isParentDragging == true{
                    addOperation(.frameChanged(FrameChanged(oldValue: parentModel.beginFrame, newValue: newFrame,shouldRevert: newFrame.shouldRevert, isParentDragging: newFrame.isParentDragging , id: parentModel.modelId)))
                }
                else{
                    addOperation(.frameChanged(FrameChanged(oldValue: parentModel.beginFrame, newValue: newFrame, id: parentModel.modelId)))
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$endBaseTimeline.dropFirst().sink{[weak self] newTimeline in
            guard let self = self else { return }
            if !undoState {
                addOperation(.timeChanged(TimeChanged(oldValue: parentModel.beginBaseTimeline, newValue: newTimeline, id: parentModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
                
        parentModel.$inAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.inAnimationDurationChange(InAnimationDurationChange(id: parentModel.modelId, newValue: duration, oldValue: parentModel.inAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$outAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.outAnimationDurationChange(OutAnimationDurationChange(id: parentModel.modelId, newValue: duration, oldValue: parentModel.outAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$loopAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.outAnimationDurationChange(OutAnimationDurationChange(id: parentModel.modelId, newValue: duration, oldValue: parentModel.loopAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$inAnimation.dropFirst().sink { [weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: parentModel.modelId, newValue: newAnimation, oldValue: parentModel.inAnimation)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$outAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: parentModel.modelId, newValue: newAnimation, oldValue: parentModel.outAnimation)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        parentModel.$loopAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: parentModel.modelId, newValue: newAnimation, oldValue: parentModel.loopAnimation)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        
        parentModel.$editState.dropFirst().sink { [weak self] isEdit in
            if !self!.undoState {
                guard let self = self else { return }
                
                let editStateOperation = OperationAction.editStateToggle(EditStateAction(oldvalue:   parentModel.editState, newValue: isEdit, id: parentModel.modelId))
                var shouldAdd = true
                      if isDuplicateAction(editStateOperation)  {
                          logger.logInfo("Duplicate \(editStateOperation), not adding to undo stack.")
                          shouldAdd = false
                         
                      }
                      
                
                self.addOperation(editStateOperation,shouldAdd: shouldAdd)
           }
        }.store(in: &modelPropertiesCancellables)
        
    }
    
    private func isDuplicateAction(_ action: OperationAction) -> Bool {
        guard let lastAction = undoStack.elements.last else {
            return false
        }
        
        switch (lastAction, action) {
        case (.editStateToggle(let lastEditStateAction), .editStateToggle(let currentEditStateAction)):
            return lastEditStateAction.id == currentEditStateAction.id

        case (.lockChanged(let lastLockUnlockAction), .lockChanged(let currentLockUnlockAction)):
            return lastLockUnlockAction.id == currentLockUnlockAction.id

        case (.flipHorizontalChanged(let lastFlipStateAction), .flipHorizontalChanged(let currentFlipStateAction)):
            return lastFlipStateAction.id == currentFlipStateAction.id
       
        case (.flipVeticalChanged(let lastFlipStateAction), .flipVeticalChanged(let currentFlipStateAction)):
            return lastFlipStateAction.id == currentFlipStateAction.id

        default:
            return false
        }

        
        
    }
    
}
