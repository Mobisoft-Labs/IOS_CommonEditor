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
        
 
        
        templateHandler.$setSelectedModelChanged.dropFirst().receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] tappedModel in
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
        
        templateHandler.currentActionState.$shouldRefreshOnAddComponent
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                guard value == true else { return }
                guard let templateHandler = self.tlManager.templateHandler,
                      let superModel = templateHandler.currentSuperModel
                else {
                    logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingSuperModel")
                    return
                }
                guard let scroller = self.scroller else {
                    logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingScroller")
                    return
                }
                let currentModelId = templateHandler.currentModel?.modelId ?? -1
                let rulingModelId = scroller.collectionView.rulingModel?.modelId ?? -1
                let activeCount = scroller.collectionView.rulingModel?.activeChildren.count ?? 0
                let itemCount = scroller.collectionView.numberOfItems(inSection: 0)
                logger?.logErrorFirebase("[TimelineTrace][shouldRefresh] begin currentModelId=\(currentModelId) rulingModelId=\(rulingModelId) activeCount=\(activeCount) itemCount=\(itemCount) isMainThread=\(Thread.isMainThread)", record: false)
                if currentModelId == -1 || rulingModelId == -1 {
                    logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModelId) rulingModelId=\(rulingModelId)")
                }
                updateRulingParentViewWithDurationAndStartTime(
                    duration: Double(superModel.baseTimeline.duration),
                    startTime: Double(superModel.baseTimeline.startTime)
                )
                if let parentModel = templateHandler.currentModel as? ParentModel, parentModel.editState {
                    baseTime = CGFloat(parentModel.baseTimeline.startTime + (templateHandler.currentPageModel?.baseTimeline.startTime ?? 0))
                    setCollectionView()
                }
                scroller.collectionView.updateFrames()
                if let currentModel = templateHandler.currentModel,
                   let index = scroller.collectionView.rulingModel?.activeChildren.firstIndex(where: { $0.modelId == currentModel.modelId }) {
                    let postItemCount = scroller.collectionView.numberOfItems(inSection: 0)
                    let postActiveCount = scroller.collectionView.rulingModel?.activeChildren.count ?? 0
                    let rulingModelId = scroller.collectionView.rulingModel?.modelId ?? -1
                    logger?.logErrorFirebase("[TimelineTrace][shouldRefresh] scroll index=\(index) currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId) activeCount=\(postActiveCount) itemCount=\(postItemCount) isMainThread=\(Thread.isMainThread)", record: false)
                    if currentModel.modelId == -1 || rulingModelId == -1 {
                        logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId)")
                    }
                    if index >= 0 && index < postItemCount {
                        scroller.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
                    } else {
                        let rulingModelId = scroller.collectionView.rulingModel?.modelId ?? -1
                        logger?.logErrorFirebase("[TimelineTrace][shouldRefresh][skip] currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId) index=\(index) itemCount=\(postItemCount) activeCount=\(postActiveCount) isMainThread=\(Thread.isMainThread)", record: false)
                        if currentModel.modelId == -1 || rulingModelId == -1 {
                            logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId)")
                        }
                    }
                }
            }.store(in: &actionStateCancellables)
        
        
    }
}
