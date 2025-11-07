//
//  SM+BaseObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

import Foundation

extension SceneManager {
    
    public func observeAsCurrentBaseModel(_ baseModel: BaseModel) {
        
        // Ensure all required properties are available
               guard let tempHandler = templateHandler,
                     let currentModel = templateHandler?.currentModel,
                     let child = currentChild,
                     let page = currentPage,
                     let parent = currentParent as? MParent,
                     let metalDisplay = self.metalDisplay else {
       
       
                   return
               }
        
        // Handle rotation changes
        baseModel.$baseFrame.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if baseModel is PageInfo{
            }
            else if baseModel is TextInfo{
               
            }
            else{
                let oldFrame = baseModel.baseFrame
                if oldFrame.size != value.size || oldFrame.center != value.center || oldFrame.rotation != value.rotation{
                    print("parent Size",value.size,value.center)
                    let oldSize = child.size
                    let oldParentCenter = child.center
                    child.setmSize(width: CGFloat(value.size.width), height: CGFloat(value.size.height))
                    child.setmCenter(centerX: CGFloat(value.center.x), centerY: CGFloat(value.center.y))
                    child.setmZRotation(rotation: Float(value.rotation))
                    if child is MParent{
                        if !value.isParentDragging{
                            recursiveChildBaseFrame(parent: child as! MParent, oldSize: oldSize)
                        }
                        else {
                            recursiveChildCenter(parent: child as! MParent, oldParentCenter : oldParentCenter, oldSize: oldSize, newParentSize: value.size, shouldRevert: value.shouldRevert)
                        }
                    }
                    self.redraw()
                }
            }
            
        }.store(in: &modelPropertiesCancellables)
        
        
        
        
        baseModel.$inAnimationDuration.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            logger.printLog("InAnimDuration: \(value)")
            child.setInAnimationDuration(value)
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$outAnimationDuration.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            logger.printLog("OutAnimDuration: \(value)")
            child.setOutAnimationDuration(value)
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$loopAnimationDuration.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            logger.printLog("LoopAnimDuration: \(value)")
            child.setLoopAnimationDuration(value)
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$inAnimation.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            logger.printLog("InAnim: \(value.animationName) , \(value.type)")
            child.setInAnimation(value)
            
            animLooper?.animLoopState = .Start(duration:child.mInAnimationDuration, startTim: 0, type: value.type == "NONE" ? .None : .InType)
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$outAnimation.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            logger.printLog("OutAnim: \(value.animationName) , \(value.type)")
            child.setOutAnimation(value)
            animLooper?.animLoopState = .Start(duration:  child.mDuration, startTim:  (  child.mDuration - child.mOutAnimationDuration ), type: value.type == "NONE" ? .None : .OutType)
            
        }.store(in: &modelPropertiesCancellables)
        baseModel.$loopAnimation.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            logger.printLog("LoopAnim: \(value.animationName) , \(value.type)")
            child.setLoopAnimation(value)
            animLooper?.animLoopState = .Start(duration: child.mInAnimationDuration + (child.mLoopAnimationDuration * 2), startTim: child.mInAnimationDuration, type: value.type == "NONE" ? .None : .LoopType)
            
        }.store(in: &modelPropertiesCancellables)
        
        
        //        baseModel.$posX.dropFirst().sink { [weak self] posY in
        //            guard let self = self else { return }
        //            child.setmCenter(centerX: CGFloat(baseModel.posX), centerY: CGFloat(posY))
        //            self.redraw()
        //        }.store(in: &modelPropertiesCancellables)
        //
        // Handle opacity changes
        baseModel.$modelOpacity.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if let page = child as? MPage {
                page.backgroundChild?.setmOpacity(opacity: value)
            } else {
                child.setmOpacity(opacity: value)
            }
            
            self.redraw()
        }.store(in: &modelPropertiesCancellables)
        
        // Handle flip changes
        baseModel.$modelFlipHorizontal.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            child.mFlipType_hori = Float(value.toInt())
            self.redraw()
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$modelFlipVertical.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            child.mFlipType_vert = Float(value.toInt())
            self.redraw()
        }.store(in: &modelPropertiesCancellables)
        
        
        baseModel.$baseTimeline.dropFirst().sink { [weak self] baseTimeline in
            guard let self = self else { return }
            logger.printLog("base time\(baseTimeline.startTime) \(baseTimeline.duration)")
            
            self.changeStartTimeAndDuration(model: child, newStartTime: baseTimeline.startTime, newDuration: baseTimeline.duration, oldDuration: child.mDuration)
            
            self.redraw()
        }.store(in: &modelPropertiesCancellables)
        
        // Handle soft delete
        baseModel.$softDelete.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            print("Selected soft delete", value)
            let pageArray = currentScene!.childern
            
            if baseModel.modelType == .Page{
                if value{
                    // remove the duration of current model from scene
                    //                    currentScene?.mDuration -= currentPage?.mDuration ?? 0
                    currentScene?.setMDuration((currentScene?.mDuration ?? 0) + (currentPage?.mDuration ?? 0))
                    if let index = pageArray!.firstIndex(where: { $0.id == baseModel.modelId }) {
                        updateStartTimeOfTheModel(index: index)
                    }
                }else{
                    currentScene?.setMDuration((currentScene?.mDuration ?? 0) + (currentPage?.mDuration ?? 0)) //+= currentPage?.mDuration ?? 0
                }
                currentPage?.setMSoftDelete(value)
                //                templateHandler.looper
            }
            else{
                currentChild?.setMSoftDelete(value)
            }
            redraw()
            
        }.store(in: &modelPropertiesCancellables)
        
        
        
        baseModel.$orderInParent.dropFirst().sink {  [weak self] order in
            guard let self = self else { return }
            if !(templateHandler?.currentActionState.hasOnceForScene)!{
                return
            }
            templateHandler?.currentActionState.hasOnceForScene = false
            
            if let page = baseModel as? PageInfo{
                orderChange(newOrder: order)
            }
        }.store(in: &modelPropertiesCancellables)
        
    }
}

