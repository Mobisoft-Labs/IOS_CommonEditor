//
//  VM+ActionStateObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension ViewManager {
    public func observeCurrentActions() {
        
        observePlayerControls()
        
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
        actionStateCancellables.removeAll()
        logger.logVerbose("VM + CurrentActions listeners ON \(actionStateCancellables.count)")
        
        templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _model in
            
            guard var self = self else { return }
            
            guard let rootView = rootView , let model = _model else {
                logger.logError("RootView Or Model Is Nil")
                return
            }
            
            guard let currentActiveView = rootView.hasChild(id: model.modelId) else {
                logger.logError("Couldnt Set currentActiveView ")
                currentActiveView = nil
                return }
            
            self.currentActiveView = currentActiveView
            
            if currentParentView?.tag != model.parentId {
                
                guard let currentParentView = rootView.hasChild(id: model.parentId) as? ParentView else {
                    logger.logError("Couldnt Set currentParentView ")
                    currentParentView = nil
                    return }
                
                self.currentParentView = currentParentView
            }
            
            observeModel(templateHandler: templateHandler)
        }).store(in: &actionStateCancellables)
        
        
        templateHandler.$selectedNearestSnappingChildID.dropFirst().sink(receiveValue: { [weak self] id in
            self?.highlightedNearestSnappingView?.isHighLighted = false
            if let rootView = self?.rootView{
                self?.highlightedNearestSnappingView = rootView.viewWithTag(id) as? BaseView
                self?.highlightedNearestSnappingView?.isHighLighted = true
            }
        }).store(in: &actionStateCancellables)
        
        
        
        
        // Zoom Controller Hide UnHide Logic.
        templateHandler.currentActionState.$zoomEnable.dropFirst().sink {[weak self] isEnable in
            guard let self = self else { return }
            
            if isEnable{
                self.zoomHostingerController?.view.isHidden = false
            }
            else{
                self.zoomHostingerController?.view.isHidden = true
            }
        }.store(in: &actionStateCancellables)
        
        
        
        
        templateHandler.currentActionState.$isNudgeAllowed.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            
            if value == true{
                self.currentActiveView!.heartBeat(view: self.controlBarView?.view)
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$thumbUpdateId.sink{ [weak self] modelId in
            guard let self = self else { return }
            
            let model = templateHandler.getModel(modelId: modelId)
            if let thumbImage = model?.thumbImage{
                let view = self.rootView?.viewWithTag(modelId) as? BaseView
                if let view = view{
                    view.setThumbImage(thumbImage: thumbImage)
                }
                //                currentActiveView?.setThumbImage(thumbImage: thumbImage)
            }
        }.store(in: &actionStateCancellables)
        
        
        
        templateHandler.currentActionState.$moveModel
            .dropFirst()
            .sink(receiveValue: { [weak self] moveModel in
                
                guard let self = self else { return }
                guard let moveModel = moveModel else { return }
                
                
                if moveModel.type == .UnGroup || moveModel.type == .Group {
                    if let parentIdToAdd = moveModel.shouldAddParentID  {
                        
                        // check if its alredy avaiable in dictionary ,
                        if let parent = self.rootView?.hasChild(id: parentIdToAdd) as? ParentView {
                            parent.onUndeleteAction()
                            
                            logger.logInfo("Group/Ungroup Parent \(parentIdToAdd) Added -VM")
                            
                        }
                        
                        
                    }
                }
                
                
                
                for oldChild in moveModel.oldMM {
                    // Find the child to be moved
                    if let newChild = moveModel.newMM.first(where: { $0.modelID == oldChild.modelID }) {
                        // Remove child from old parent
                        self.moveChild(childId: oldChild.modelID, withProperties: newChild.baseFrame, orderInParent: newChild.orderInParent, flipH: newChild.hFlip, flipV: newChild.vFlip,to: newChild.parentID,from:oldChild.parentID)
                        
                        guard let currentPageView = self.rootView?.currentPage else {
                            logger.logError("No Current Page Found")
                            return
                        }
                        for destinationParentSize in newChild.arrayOFParents{
                            let destinationParentModel = templateHandler.getModel(modelId: destinationParentSize.modelID)
                            if destinationParentModel?.parentId == currentPageView.tag{
                                self.removeParentAndChildren(parentID: destinationParentSize.modelID)
                                
                                self.removeParentAndChildren(parentID: destinationParentSize.modelID)
                                
                                self.redrawParentAndChildren(parentID: destinationParentSize.modelID, parentSize: destinationParentSize.BaseFrame)
                                
                            }
                        }
                    }
                }
                
                if moveModel.type == .UnGroup || moveModel.type == .Group {
                    if let parentIdToAdd = moveModel.shouldRemoveParentID  {
                        
                        // check if its alredy avaiable in dictionary ,
                        if let parent = self.rootView?.hasChild(id: parentIdToAdd) as? ParentView {
                            parent.onDeleteAction()
                            
                            logger.logInfo("Group/Ungroup Parent \(parentIdToAdd) Deleted -VM")
                            
                        }
                        
                        
                    }
                }
            })
            .store(in: &actionStateCancellables)
        
        // This Listener works for adding or removing of Page.
        templateHandler.$currentPageModel.dropFirst().sink{ [weak self] currentModel in
            guard let currentModel = currentModel else { return }
            guard let currentPageModel = templateHandler.currentPageModel else { return }
            if currentPageModel.modelId == currentModel.modelId {
                self?.logger.logVerbose("Same Page No need To Switch.. In future use RemoveDuplicate Modifier To This Listener after  DropFirst() to avoid duplicate or same value calls")
                return
            } else {
                
                self?.replacePage(newPageInfo: currentModel)
                
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$addItemToMultiSelect.dropFirst().sink { [weak self] id in
            //            if  templateHandler.currentActionState.addItemToMultiSelect != id{
            let view = self?.rootView?.viewWithTag(id) as? BaseView
            self?.logger.logWarning("This is unNecessory Now fixed RootCause")
            if let view = view, view.canDisplay{
                view.isSelectedForMultiple = true
            }
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$removeItemFromMultiSelect.dropFirst().sink { [weak self] id in
            
            guard let view = self?.rootView?.viewWithTag(id) as? BaseView else {
                self?.logger.logError("MuliSelect Remove Issue")
                return
            }
            view.isSelectedForMultiple = false
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$zoomEditView.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == .scaleDown{
                self.zoomOut()
            }
            else{
                self.zoomIn()
            }
        }.store(in: &zoomCancellables)
        
    }
}
