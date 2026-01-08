//
//  Engine+BaseObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//
import Foundation

extension MetalEngine {
    public func observeAsCurrentBaseModel(_ baseModel: BaseModel) {
           baseModel.$endOpacity.dropFirst().sink { [weak self]  opacity in
               guard let self = self else { return }
                
                let value = Int(opacity*255.0)
                print("new opacity",value)
                _ =  DBManager.shared.updateModelOpacity(modelId:baseModel.modelId, newValue: Double(value))
            }.store(in: &modelPropertiesCancellables)
            
          
            
           baseModel.$softDelete.dropFirst().sink { [weak self] softDelete in
               guard let self = self else { return }
                if let pm =  baseModel as? PageInfo{
                    //                    if softDelete{
                    // soft delete for page will true
                    if !isDBDisabled{
                        _ = DBManager.shared.updateSoftDelete(modelId: baseModel.modelId, newValue: softDelete.toInt())
                    }
                    // update in DB for
                    // update time in db for ttemplate
                    if let currentTemplate = templateHandler.currentTemplateInfo{
                        
                        var newDuration = 0.0
                        if softDelete{
                            newDuration = Double(currentTemplate.totalDuration - pm.baseTimeline.duration)
                            
                        }else{
                            newDuration = Double(currentTemplate.totalDuration + pm.baseTimeline.duration)
                        }
                        
                        currentTemplate.totalDuration = Float(newDuration)
                        if !isDBDisabled{
                            _ = DBManager.shared.updateTemplateTotalDuration(templateId: currentTemplate.templateId, newValue: newDuration)
                        }
                        
                        //                    let time  =
                        // SM.addNewPage(pageInfo)
                        
                        templateHandler.templateDuration = newDuration
                        templateHandler.playerControls?.timeLengthDuration = newDuration
                        
                        //                              templateHander.duration = newDuration
                        /// looper.currentTime = pageInfo.startTime
                        
                        logger.logError("Not Reqiured when deleting or adding atleast here")
                        templateHandler.setCurrentTime(pm.baseTimeline.startTime)
                        // Set Id
                        
                        
                    }
               
                }
                else{
                    // soft delete for page will true
                    if !isDBDisabled{
                        _ = DBManager.shared.updateSoftDelete(modelId: baseModel.modelId, newValue: softDelete.toInt())
                    }
                    templateHandler.normalizeActiveOrders(parentId: baseModel.parentId)
                    sceneManager.syncOrderForParent(parentId: baseModel.parentId)
                    viewManager?.syncOrderForParent(parentId: baseModel.parentId)
//                    templateHandler.setCurrentModel(id: templateHandler.lastSelectedId!)
                }
                
            }.store(in: &modelPropertiesCancellables)
            
            if let pModel = baseModel as? PageInfo{
                pModel.$tileMultiple.dropFirst().sink { multiple in
                    _ =  DBManager.shared.updateImageTileMultiple(modelId: pModel.dataId, newValue: Double(multiple))
                }.store(in: &modelPropertiesCancellables)
            }
            
            // Subscriber for inAnimation
           baseModel.$inAnimation.dropFirst().sink { [weak self] inAnimation in
               guard let self = self else { return }
                // Handle inAnimation change
               if !isDBDisabled{
                   _ = DBManager.shared.updateInAnimationTemplateId(modelId:baseModel.modelId, newValue: inAnimation.animationTemplateId)
               }
//               analyticsLogger.logEditorInteraction(action: .addAnimation)
               engineConfig.logAddAnimation()
            }.store(in: &modelPropertiesCancellables)
            
            // Subscriber for inAnimationDuration
           baseModel.$inAnimationEndDuration.dropFirst().sink { [weak self] inAnimationDuration in
               guard let self = self else { return }
               if !isDBDisabled{
                   // Handle inAnimationDuration change
                   _ = DBManager.shared.updateInAnimationDuration(modelId:baseModel.modelId, newValue: inAnimationDuration)
               }
                
                
            }.store(in: &modelPropertiesCancellables)
            
            // Subscriber for outAnimation
           baseModel.$outAnimation.dropFirst().sink {[weak self] outAnimation in
               guard let self = self else { return }
               if !isDBDisabled{
                   // Handle outAnimation change
                   _ = DBManager.shared.updateOutAnimationTemplateId(modelId:baseModel.modelId, newValue: outAnimation.animationTemplateId)
               }
//               analyticsLogger.logEditorInteraction(action: .addAnimation)
               engineConfig.logAddAnimation()
            }.store(in: &modelPropertiesCancellables)
            
            // Subscriber for outAnimationDuration
           baseModel.$outAnimationEndDuration.dropFirst().sink { [weak self] outAnimationDuration in
               guard let self = self else { return }
               if !isDBDisabled{
                   // Handle outAnimationDuration change
                   _ = DBManager.shared.updateOutAnimationDuration(modelId:baseModel.modelId, newValue: outAnimationDuration)
               }
                
            }.store(in: &modelPropertiesCancellables)
            
            // Subscriber for loopAnimation
           baseModel.$loopAnimation.dropFirst().sink {[weak self]  loopAnimation in
               guard let self = self else { return }
               if !isDBDisabled{
                   // Handle loopAnimation change
                   _ = DBManager.shared.updateLoopAnimationTemplateId(modelId:baseModel.modelId, newValue: loopAnimation.animationTemplateId)
               }
//               analyticsLogger.logEditorInteraction(action: .addAnimation)
               engineConfig.logAddAnimation()
            }.store(in: &modelPropertiesCancellables)
            
            // Subscriber for loopAnimationDuration
           baseModel.$loopAnimationEndDuration.dropFirst().sink {[weak self]  loopAnimationDuration in
               guard let self = self else { return }
               if !isDBDisabled{
                   // Handle loopAnimationDuration change
                   _ = DBManager.shared.updateLoopAnimationDuration(modelId:baseModel.modelId, newValue: loopAnimationDuration)
               }
            }.store(in: &modelPropertiesCancellables)
            
            
//           baseModel.$endStartTime.dropFirst().sink {[unowned self] value in
//
//                ifbaseModel.modelType == .Parent{
//                    changeStartTime(model: model, newStartTime: value)
//                }else{
//                    _ = DBManager.shared.updateStartTime(modelId:baseModel.modelId, newValue: value)
//                }
//                // changeStartTime(model: model, newStartTime: value)
//            }.store(in: &cancellables)
            
            // Subscriber for endDuration
           baseModel.$endDuration.dropFirst().sink {[weak self] endDuration in
               guard let self = self else { return }
                // Handle endDuration change
                print("inside endDuration: \(endDuration)")
                if baseModel.modelType == .Parent{
//                    changeDuration(model: model, newDuration: endDuration)
                    changeDurationAndStartTime(model: baseModel, newStartTime:baseModel.endStartTime, newDuration: endDuration, oldDuration:baseModel.beginDuration)
                }else{
                    if !isDBDisabled{
                        _ = DBManager.shared.updateDuration(modelId:baseModel.modelId, newValue: endDuration)
                        _ = DBManager.shared.updateStartTime(modelId:baseModel.modelId, newValue:baseModel.endStartTime)
                    }
                }
               
                //changeDuration(model: model, newDuration: endDuration)
                //                      _ = DBManager.shared.updateDuration(modelId:baseModel.modelId, newValue: Double(endDuration))
                
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endBaseTimeline.dropFirst().sink {[weak self] baseTimeline in
               guard let self = self else { return }
                // Handle endDuration change
//                print("inside endDuration: \(endDuration)")
                if baseModel.modelType == .Parent{
//                    changeDuration(model: model, newDuration: endDuration)
                    changeDurationAndStartTime(model: baseModel, newStartTime: baseTimeline.startTime, newDuration: baseTimeline.duration, oldDuration:baseModel.beginBaseTimeline.duration)
                } else if baseModel.modelType == .Page{
                    if baseModel.beginBaseTimeline.duration != baseTimeline.duration{
                        let changeInDuration = baseTimeline.duration - baseModel.beginBaseTimeline.duration
                        
                        if let currentIndex = templateHandler.currentActionState.pageModelArray.firstIndex(where: { $0.id == baseModel.modelId }) {
                            
                            // Update the start time of all pages after the current page index
                            for i in (currentIndex + 1)..<templateHandler.currentActionState.pageModelArray.count {
                                let newModel = templateHandler.getModel(modelId: templateHandler.currentActionState.pageModelArray[i].id)
                                
                                newModel?.baseTimeline.startTime += changeInDuration
                                if !isDBDisabled{
                                    _ = DBManager.shared.updateStartTime(modelId: newModel!.modelId, newValue: newModel!.baseTimeline.startTime)
                                }
                            }
                        }
                        if !isDBDisabled{
                            _ = DBManager.shared.updateDuration(modelId:baseModel.modelId, newValue: baseTimeline.duration)
                            _ = DBManager.shared.updateStartTime(modelId:baseModel.modelId, newValue: baseTimeline.startTime)
                            _ = DBManager.shared.updateTemplateTotalDuration(templateId:baseModel.templateID, newValue: templateHandler.currentTemplateInfo?.totalDuration.toDouble() ?? 0)
                        }
                    }
                }else{
                    if !isDBDisabled{
                        _ = DBManager.shared.updateDuration(modelId:baseModel.modelId, newValue: baseTimeline.duration)
                        _ = DBManager.shared.updateStartTime(modelId:baseModel.modelId, newValue: baseTimeline.startTime)
                    }
                }
                
                
               
                //changeDuration(model: model, newDuration: endDuration)
                //                      _ = DBManager.shared.updateDuration(modelId:baseModel.modelId, newValue: Double(endDuration))
                
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$lockStatus.dropFirst().sink { [weak self] lockStatus in
               guard let self = self else { return }
                if lockStatus{
                    templateHandler.currentPageModel?.unlockedModel.removeAll(where: {$0.id == baseModel.modelId})
                }else{
                    if templateHandler.currentPageModel!.unlockedModel.contains(where: {$0.id == baseModel.modelId}){
                     templateHandler.currentPageModel?.unlockedModel.append(LockUnlockModel(id:baseModel.modelId, lockStatus: true))
                    }
                }
               if !isDBDisabled{
                   _ = DBManager.shared.updateLockStatus(modelId:baseModel.modelId, newValue: lockStatus.toString())
               }
            }.store(in: &modelPropertiesCancellables)
       
           baseModel.$modelFlipHorizontal.dropFirst().sink { [weak self] filpH in
               guard let self = self else { return }
               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateModelFlipHorizontal(modelId:baseModel.modelId, newValue: filpH.toInt())
               }
                
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$bgBlurProgress.dropFirst().sink { [weak self] blurProgress in
               guard let self = self else { return }
               if !isDBDisabled{
                   //            print("blur progress",blurProgress)
                   _ = DBManager.shared.updateBgBlurProgress(modelId:baseModel.modelId, newValue: Int(blurProgress*255))
               }
            }.store(in: &modelPropertiesCancellables)
            
            
            
        baseModel.$modelFlipVertical.dropFirst().sink { [weak self] flipV in
            guard let self = self else { return }
            if !isDBDisabled{
                _ = DBManager.shared.updateModelFlipVertical(modelId:baseModel.modelId, newValue: flipV.toInt())
            }
            }.store(in: &modelPropertiesCancellables)
            
            
            //           baseModel.$orderInParent.dropFirst().sink { [self] orderInParent in
            //                if let page = model as? PageInfo{
            //                    swapPages(model: page, oldOrder:baseModel.orderInParent, newOrder: orderInParent)
            //
            //                }
            //
            //                _ = DBManager.shared.updateOrderInParent(modelId:baseModel.modelId, newValue: orderInParent)
            //            }.store(in: &cancellables)
            
            
          
            
           baseModel.$endFrame.dropFirst().sink { [weak self] frame in
               print("Neeshu From Engine")
               guard let self = self else { return }
                // get parent for calculate size and center with respect to parent
                let oldFrame = baseModel.beginFrame
//               if !(baseModel.modelType == .Text){
               let widthChange = frame.size.width  - oldFrame.size.width
               let heightChange = frame.size.height  - oldFrame.size.height
               baseModel.prevAvailableWidth += Float(widthChange)//Float(frame.size.width/*oldFrame.size.width*/)
               baseModel.prevAvailableHeight += Float(heightChange)//Float(frame.size.height/*oldFrame.size.height*/)
               
//               }
                if let parent = templateHandler.getModel(modelId:baseModel.parentId) {
//                    _ = DBManager.shared.updateBaseFrame(modelId:baseModel.modelId, newValue: frame, parentFrame: parent.baseFrame.size)
                    if !isDBDisabled{
                        _ = DBManager.shared.updateBaseFrameWithPrevious(modelId: baseModel.modelId, newValue: frame, parentFrame: parent.baseFrame.size, previousWidth:  CGFloat(baseModel.prevAvailableWidth), previousHeight:  CGFloat(baseModel.prevAvailableHeight))
                    }
                }
                
                if baseModel is ParentModel{
                    if !frame.isParentDragging{
                        recursiveChildBaseFrame(parent: baseModel as! ParentModel ,oldSize: oldFrame.size,newSize:frame.size)
                    }
                    else{
                        recursiveChildBaseFrameForDragging(parent: baseModel as! ParentModel,oldParentCenter: oldFrame.center,oldParentSize: oldFrame.size, newSize: frame.size, shouldRevert: frame.shouldRevert)
                    }
                }
                
                templateHandler.currentActionState.updatePageAndParentThumb = true
                
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$filterType.dropFirst().sink { [weak self] filterType in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateFiterType(modelID:baseModel.modelId, filterType: filterType.rawValue)
               }
            }.store(in: &modelPropertiesCancellables)
        baseModel.$maskShape.dropFirst().sink { [weak self] filterType in
            guard let self = self else { return }

            if !(self.isDBDisabled){
                _ = DBManager.shared.updateMaskShape(modelID: baseModel.modelId, maskShape: filterType) 
            }
         }.store(in: &modelPropertiesCancellables)
                        
           baseModel.$endBrightnessIntensity.dropFirst().sink { [weak self] brightness in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .brightness, adjustmentIntensity: brightness)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endContrastIntensity.dropFirst().sink { [weak self] contrast in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .contrast, adjustmentIntensity: contrast)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endHighlightIntensity.dropFirst().sink { [weak self] highlightIntensity in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .highlight, adjustmentIntensity: highlightIntensity)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endShadowsIntensity.dropFirst().sink { [weak self] shadows in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .shadows, adjustmentIntensity: shadows)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endSaturationIntensity.dropFirst().sink { [weak self]  saturation in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .saturation, adjustmentIntensity: saturation)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endVibranceIntensity.dropFirst().sink { [weak self] vibrance in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .vibrance, adjustmentIntensity: vibrance)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endSharpnessIntensity.dropFirst().sink { [weak self] sharpness in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .sharpness, adjustmentIntensity: sharpness)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endWarmthIntensity.dropFirst().sink { [weak self] warmth in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .warmth, adjustmentIntensity: warmth)
               }
            }.store(in: &modelPropertiesCancellables)
            
           baseModel.$endTintIntensity.dropFirst().sink { [weak self] tint in
               guard let self = self else { return }

               if !(self.isDBDisabled){
                   _ = DBManager.shared.updateAdjustment(modelID:baseModel.modelId, adjustmentType: .tint, adjustmentIntensity: tint)
               }
            }.store(in: &modelPropertiesCancellables)

            
        
        if let pageModel = baseModel as? PageInfo {
            baseModel.$orderInParent.dropFirst().sink { [weak self] order in
                guard let self = self else { return }
                if !templateHandler.currentActionState.hasOnce{
                    return
                }
                templateHandler.currentActionState.hasOnce = false
                templateHandler?.currentActionState.hasOnceForScene = true
                
                if let page = templateHandler.currentPageModel{
                    orderChange(newOrder: order)
                    templateHandler.setCurrentTime( templateHandler.currentPageModel!.startTime)
                    
                    
                }else{
                    //                    orderChangeInParent(newOrder: order)
                }
            }.store(in: &modelPropertiesCancellables)
        }
        
    }
}
