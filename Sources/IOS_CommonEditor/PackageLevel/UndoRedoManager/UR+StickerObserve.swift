//
//  UndoRedo+ObserveSticker.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension UndoRedoManager {
    public func observeAsCurrentSticker(_ stickerModel: StickerInfo) {
        
        stickerModel.$modelFlipHorizontal.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState{
                addOperation(.flipHorizontalChanged(FlipHorizontalAction(oldvalue: stickerModel.modelFlipHorizontal, newValue: newValue, id: stickerModel.modelId)))
            }
            logger.printLog("undo Registered new flipH value: \(newValue) old flipH value: \(stickerModel.modelFlipHorizontal)")
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$modelFlipVertical.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState {
               addOperation(.flipVeticalChanged(FlipVerticalAction(oldvalue: stickerModel.modelFlipVertical, newValue: newValue, id: stickerModel.modelId)))
            }
            logger.printLog("undo Registered new flipV value: \(newValue) old flipV value: \(stickerModel.modelFlipVertical)")
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$lockStatus.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState {
                addOperation(.lockChanged(LockUnlockAction(oldStatus: stickerModel.lockStatus, newStatus: newValue, id: stickerModel.modelId)))
            }
            logger.printLog("undo Registered new lock value: \(newValue) old lock value: \(stickerModel.lockStatus)")
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endOpacity.dropFirst().sink {[weak self]  value in
            guard let self = self else { return }
            if !undoState {
                addOperation(.OpacityChanged(OpacityUndoModel(oldOpacity: stickerModel.beginOpacity, newOpacity: value, id: stickerModel.modelId)))
            }
            logger.printLog("undo Registered new value: \(stickerModel.endOpacity) old opacity: \(stickerModel.beginOpacity)")
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$softDelete.dropFirst().sink{[weak self] softDelete in
            guard let self = self else { return }
            if !undoState {

                addOperation(.deleteAction(DeleteAction(oldValue: !softDelete, newValue: softDelete, id: stickerModel.modelId, oldShouldSelectID: stickerModel.modelId, newShouldSelectID: stickerModel.parentId)))

            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endFrame.dropFirst().sink{[weak self] newFrame in
            guard let self = self else { return }
            if !undoState {
                addOperation(.frameChanged(FrameChanged(oldValue: stickerModel.beginFrame, newValue: newFrame, id: stickerModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endBaseTimeline.dropFirst().sink{[weak self] newTimeline in
            guard let self = self else { return }
            if !undoState {
                addOperation(.timeChanged(TimeChanged(oldValue: stickerModel.beginBaseTimeline, newValue: newTimeline, id: stickerModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)

        stickerModel.$endHue.dropFirst().sink { [weak self] newHue in
            guard let self = self else { return }
            if !undoState{
                addOperation(.stickerHueChanged(StickerHueChanged(oldHue: stickerModel.beginHue, newHue: newHue, id: stickerModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
          
        
        stickerModel.$endStickerFilter.dropFirst().sink {[weak self] newStickerFilter in
            guard let self = self else { return }
            guard let beginFilter = stickerModel.beginStickerFilter else { return }
            guard let endFilter = newStickerFilter else { return }
            if !undoState{
                addOperation(.stikerFilterChanged(StickerFilterChanged(oldFilter: beginFilter, newFilter: endFilter, id: stickerModel.modelId)))
                logger.printLog("undo registered for stickerfilter value: \(stickerModel.stickerFilter!) new value: \(newStickerFilter!)")
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$changeOrReplaceImage.dropFirst().sink {[weak self] newStickerModel in
            guard let self = self else { return }
            if let newModel = newStickerModel{
                if !undoState{
                    var replaceModel =  stickerModel.changeOrReplaceImage
                    replaceModel?.baseFrame = stickerModel.beginFrame
                    addOperation(.stickerImageContent(StickerImageContentChanged(oldContent: replaceModel!, newContent: newModel, id: stickerModel.modelId)))
                    logger.printLog("undo registered for image Model old value: \(stickerModel.stickerImageContent!) new value: \(newModel)")
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        
        stickerModel.$inAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.inAnimationDurationChange(InAnimationDurationChange(id: stickerModel.modelId, newValue: duration, oldValue: stickerModel.inAnimationBeginDuration)))

            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$outAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.outAnimationDurationChange(OutAnimationDurationChange(id: stickerModel.modelId, newValue: duration, oldValue: stickerModel.outAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$loopAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.outAnimationDurationChange(OutAnimationDurationChange(id: stickerModel.modelId, newValue: duration, oldValue: stickerModel.loopAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$inAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: stickerModel.modelId, newValue: newAnimation, oldValue: stickerModel.inAnimation)))
                 logger.printLog("Animation undo redo IN  old Value: animation name \(stickerModel.inAnimation.animationName), type \(stickerModel.inAnimation.type), name \(stickerModel.inAnimation.name) , new Value: animation name \(newAnimation.animationName), type \(newAnimation.type), name \(newAnimation.name)")
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$outAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: stickerModel.modelId, newValue: newAnimation, oldValue: stickerModel.outAnimation)))
                 logger.printLog("Animation undo redo OUT  old Value: animation name \(stickerModel.outAnimation.animationName), type \(stickerModel.outAnimation.type), name \(stickerModel.outAnimation.name) , new Value: animation name \(newAnimation.animationName), type \(newAnimation.type), name \(newAnimation.name)")
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$loopAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: stickerModel.modelId, newValue: newAnimation, oldValue: stickerModel.loopAnimation)))
                 
                 logger.printLog("Animation undo redo LOOP  old Value: animation name \(stickerModel.loopAnimation.animationName), type \(stickerModel.loopAnimation.type), name \(stickerModel.loopAnimation.name) ,new Value: animation name \(newAnimation.animationName), type \(newAnimation.type), name \(newAnimation.name)")
            }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$filterType.dropFirst().sink{[weak self] filterType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.filterTypeModel(FilterTypeModel(id: stickerModel.modelId, oldValue: stickerModel.filterType, newValue: filterType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$maskShape.dropFirst().sink{[weak self] filterType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.maskShapeModel(MaskShapeModel(id: stickerModel.modelId, oldValue: stickerModel.maskShape, newValue: filterType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$colorAdjustmentType.dropFirst().sink{[weak self] colorAdjustmentType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.colorAdjustmentTypeModel(ColorAdjustmentTypeModel(id: stickerModel.modelId, oldValue: stickerModel.colorAdjustmentType, newValue: colorAdjustmentType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endBrightnessIntensity.dropFirst().sink{[weak self] brightness in
            guard let self = self else { return }
            if !undoState {
                addOperation(.brightnessAdjustmentModel(BrightnessAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginBrightnessIntensity, newValue: brightness)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endContrastIntensity.dropFirst().sink{[weak self] contrast in
            guard let self = self else { return }
            if !undoState {
                addOperation(.contrastAdjustmentModel(ContrastAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginHighlightIntensity, newValue: contrast)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endHighlightIntensity.dropFirst().sink{[weak self] highlights in
            guard let self = self else { return }
            if !undoState {
                addOperation(.highlightAdjustmentModel(HighlightAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginHighlightIntensity, newValue: highlights)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endShadowsIntensity.dropFirst().sink{[weak self] shadows in
            guard let self = self else { return }
            if !undoState {
                addOperation(.shadowsAdjustmentModel(ShadowsAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginShadowsIntensity, newValue: shadows)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endSaturationIntensity.dropFirst().sink{[weak self] saturation in
            guard let self = self else { return }
            if !undoState {
                addOperation(.saturationAdjustmentModel(SaturationAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginSaturationIntensity, newValue: saturation)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endVibranceIntensity.dropFirst().sink{[weak self] vibrance in
            guard let self = self else { return }
            if !undoState {
                addOperation(.vibranceAdjustmentModel(VibranceAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginVibranceIntensity, newValue: vibrance)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        
        stickerModel.$endSharpnessIntensity.dropFirst().sink{[weak self] sharpness in
            guard let self = self else { return }
            if !undoState {
                addOperation(.sharpnessAdjustmentModel(SharpnessAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginSharpnessIntensity, newValue: sharpness)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endWarmthIntensity.dropFirst().sink{[weak self] warmth in
            guard let self = self else { return }
            if !undoState {
                addOperation(.warmthAdjustmentModel(WarmthAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginWarmthIntensity, newValue: warmth)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        stickerModel.$endTintIntensity.dropFirst().sink{[weak self] tint in
            guard let self = self else { return }
            if !undoState {
                addOperation(.tintAdjustmentModel(TintAdjustmentModel(id: stickerModel.modelId, oldValue: stickerModel.beginTintIntensity, newValue: tint)))
           }
        }.store(in: &modelPropertiesCancellables)
        
    }
}
