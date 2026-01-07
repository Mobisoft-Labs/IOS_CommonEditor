//
//  Timeline+ActionStateObserver.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//
import Foundation

extension TimelineView {
    
    public func observeCurrentActions() {
        
        
        
        guard  let templateHandler = tlManager.templateHandler else {
            logger?.printLog("template handler nil")
            return }
        
        actionStateCancellables.removeAll()
        logger?.logVerbose("TL + CurrentActions listeners ON \(actionStateCancellables.count)")
        
        
        templateHandler.$templateDuration.dropFirst().sink(receiveValue: {  [weak self] duration in
            guard let self = self else { return }
            print("Duration Updated In DB and UndoRedo")
            self.scroller.rulerView.duration = duration
            self.onPageDragEnd()
            
        }).store(in: &actionStateCancellables)
        
 
        
        templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] tappedModel in
            guard var self = self else { return }
            
//            cellCancellables.removeAll()
            if let rulingParentModel = rulingParentModel , rulingParentModel.modelId == tappedModel?.modelId {
//            cellCancellables.removeAll()
                logger?.printLog("same model, no need to setup again ")
//                scroller.collectionView.isResetThumbImagePosition = true
            }else {
                if let pageModel = tappedModel as? PageInfo {
                    changeModel(rulineModel: pageModel)
                } else if let parentModel = tappedModel as? ParentInfo , parentModel.editState {
                    changeModel(rulineModel: parentModel)
                }else{
//                    cellCancellables.removeAll()
//                    scroller.collectionView.isResetThumbImagePosition = true
                    logger?.printLog("model selected timeline \(String(describing: tappedModel))")
                }
            }
            self.observeModel(templateHandler: templateHandler)
            
        }).store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$shouldRefreshOnAddComponent.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
//            if value == true{
//                updateRulingParentViewWithDurationAndStartTime(duration: Double(templateHandler.currentSuperModel!.baseTimeline.duration), startTime: Double(templateHandler.currentSuperModel!.baseTimeline.startTime))
//                if let parentModel = tlManager.templateHandler?.currentModel as? ParentModel{
//                    if parentModel.editState{
//                        baseTime = CGFloat(parentModel.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
//                        setCollectionView()
//                    }
//                }
//                self.scroller.collectionView.updateFrames()
//                if let currentModel = self.tlManager.templateHandler?.currentModel{
//                    if let index = self.scroller.collectionView.rulingModel?.activeChildren.firstIndex(where: { $0.modelId == currentModel.modelId }) {
//                        self.scroller.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
//                        
//                    }
//                }
//            }
        }.store(in: &actionStateCancellables)
        
        
    }
}
