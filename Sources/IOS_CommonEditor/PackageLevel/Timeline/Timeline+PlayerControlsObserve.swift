//
//  Timeline+PlayerControlsObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

extension TimelineView {
    
    public func observePlayerControls() {
        
        guard let looper = tlManager.looper, let _ = tlManager.templateHandler else {
            logger?.printLog("Looper nil")
            return }
        
        playerControlsCancellables.removeAll()
        logger?.logVerbose("EditorVC + PlayerControls listeners ON \(playerControlsCancellables.count)")
        
        looper.$renderState.dropFirst().sink(receiveValue: { [weak self] state in
            guard let self = self else { return }
            switch state {
                
            case .Prepared:
                self.scrollToCurrentTime(currentTime: .zero,animate: true)
                self.isManualScrolling = true

                break
            case .Playing:
                self.isManualScrolling = false
                break
            case .Paused:
                self.isManualScrolling = true
                self.scroller.collectionView.isResetThumbImagePosition = false
                break
            case .Stopped:
                self.scrollToCurrentTime(currentTime: .zero,animate: true)
                self.isManualScrolling = true
                self.scroller.collectionView.isResetThumbImagePosition = false

                break
            case .Completed:
                self.scrollToCurrentTime(currentTime: .zero,animate: true)
                self.isManualScrolling = true
                self.scroller.collectionView.isResetThumbImagePosition = false

                break
            }
        }).store(in: &playerControlsCancellables)
        
        looper.$currentTime.dropFirst().sink(receiveValue: { [weak self] currentTime in
            guard let self = self else { return }
            //DispatchQueue.main.async {
       
//                self.middleLineView.textToDisplay = "\(numberString)"
          

                if !isManualScrolling {
                    scrollToCurrentTime(currentTime: currentTime)
                     scroller.collectionView.isResetThumbImagePosition = true
                    
                    if let model = tlManager.templateHandler?.currentPageModel{
                        if (model.baseTimeline.startTime + model.baseTimeline.duration) < Float(currentTime){
                            
                            if let currentPageIndex = tlManager.templateHandler?.currentActionState.pageModelArray.firstIndex(where: { $0.id == model.modelId }) {
                                
                                if tlManager.templateHandler?.currentActionState.pageModelArray.count ?? 0 > currentPageIndex + 1 {
                                    tlManager.templateHandler?.deepSetCurrentModel(id: tlManager.templateHandler?.currentActionState.pageModelArray[currentPageIndex + 1].id ?? 0)
                                    
                                }
                            }
                            
                        }else {
                            if model.baseTimeline.startTime > Float(currentTime){
                                if let currentPageIndex = tlManager.templateHandler?.currentActionState.pageModelArray.firstIndex(where: { $0.id == model.modelId }) {
                                    
                                    
                                    tlManager.templateHandler?.deepSetCurrentModel(id: tlManager.templateHandler?.currentActionState.pageModelArray[currentPageIndex - 1].id ?? 0)

                                }
                            }
                        }
                    }
                } else {
                    
                    
//                    DispatchQueue.main.async {
                        
                        // logInfo("ManuallScrolling True")
                        if canScrollOutsideOfTimeline {
                            scrollToCurrentTime(currentTime: currentTime)
                        }
//                    }
                }
           // }
            
        }).store(in: &playerControlsCancellables)
        
       
        
        looper.$timeLengthDuration.dropFirst().sink(receiveValue: { [weak self] duration in
            guard let self = self else { return }
            //DispatchQueue.main.async {
           
            scroller.rulerView.duration = duration
            
           // let numberString = String(format: "%.2f", currentTime.roundToDecimal(2))
//            self.middleLineView.textToDisplay = "\(numberString)"
//            if !isManualScrolling {
//                scrollToCurrentTime(currentTime: currentTime)
//            }
           // }
            
        }).store(in: &playerControlsCancellables)
        
    }
}
