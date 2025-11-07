//
//  UR+ActionStateObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//




extension UndoRedoManager  {
  
    public func observeCurrentActions() {
        
        
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
        actionStateCancellables.removeAll()
        
        logger.logVerbose("UR + deepSelectionInProgress \(templateHandler.deepSelectionInProgress)")

        
        
        logger.logVerbose("UR + CurrentActions listeners ON \(actionStateCancellables.count)")
        
        templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _model in
            
            
            
            guard var self = self else { return }
            logger.logVerbose("UR+ modelChange to \(_model!.modelType.rawValue)")

            observeModel(templateHandler: templateHandler,shouldObserve: !templateHandler.deepSelectionInProgress)
        
            
        }).store(in:&actionStateCancellables)
        
        
        templateHandler.currentActionState.$moveModel.dropFirst().sink {[weak self] value in
            guard let self = self else { return }
            logger.printLog("moveModel Step  Undo Redo")
            if let moveModel = value {
                if moveModel.oldMM.count<1{
                    logger.printLog("move model is empty")
                    return
                }
                
                else if !undoState {
                    
                    addOperation(.MoveModelChanged(moveModel))
                }
            }
           
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentTemplateInfo?.$ratioInfo.dropFirst().sink {[weak self] ratioModel in
            guard let self = self else { return }
            if !undoState {
                guard let currentModel =  templateHandler.currentModel as? PageInfo else {
                    logger.logError("No Page Found")
                    return }
                 addOperation(.pageRatioChanged(PageRatioChange(id: currentModel.modelId, oldRatioModel: templateHandler.currentTemplateInfo!.ratioInfo, newRatioModel: ratioModel)))
           }
        }.store(in: &actionStateCancellables)
           
        templateHandler.currentActionState.$currentMusic.dropFirst().sink { [weak self] newMusic in
            guard let self = self else { return }
            if !undoState {
                guard let currentTemplateInfo =  templateHandler.currentTemplateInfo else {
                    logger.logError("No Music Found")
                    return }
                addOperation(.musicChanged(MusicChange(id: currentTemplateInfo.templateId, oldMusicModel: templateHandler.currentActionState.currentMusic, newMusicModel: newMusic)))
           }
        }.store(in: &actionStateCancellables)
     }
}
