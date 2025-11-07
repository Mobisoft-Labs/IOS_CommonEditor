//
//  UR+TextObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension UndoRedoManager {
    public func observeAsCurrentText(_ textModel: TextInfo) {
 
        textModel.$endOpacity.dropFirst().sink {[weak self]  value in
            guard let self = self else { return }
            if !undoState {
                addOperation(.OpacityChanged(OpacityUndoModel(oldOpacity: textModel.beginOpacity, newOpacity: value, id: textModel.modelId)))
            }
            logger.printLog("undo Registered new value: \(textModel.endOpacity) old opacity: \(textModel.beginOpacity)")
        }.store(in: &modelPropertiesCancellables)

        textModel.$endTextContentColor.dropFirst().sink {[weak self] newColor in
            guard let self = self else { return }
            if let newColor = newColor,let oldColor = textModel.beginTextContentColor{
                if !undoState{
                    addOperation(.textColorChanged(TextColorChanged(oldTextColor: oldColor, newTextColor: newColor, id: textModel.modelId)))
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endTextShadowColorFilter.dropFirst().sink {[weak self] newShadowColor in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textShadowColorChanged(TextShadowColorChanged(oldShadowColor: ColorFilter(filter: textModel.shadowColor), newShadowColor: newShadowColor!, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endShadowOpacity.dropFirst().sink {[weak self] newShadowOpacity in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textShadowRadiusChanged(TextShadowRadiusChanged(oldShadowRadius: textModel.beginShadowOpacity, newShadowRadius: newShadowOpacity, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endDx.dropFirst().sink {[weak self] newShadowDx in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textShadowDxChanged(TextShadowDxChanged(oldShadowDx: textModel.beginDx, newShadowDx: newShadowDx, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endDy.dropFirst().sink {[weak self] newShadowDy in
            guard let self = self else { return }
            if !undoState{
               addOperation(.textShadowDyChanged(TextShadowDyChanged(oldShadowDy: textModel.beginDy, newShadowDy: newShadowDy, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
//        textModel.$e
        textModel.$fontName.dropFirst().sink {[weak self] newFont in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textFontChanged(TextFontChanged(oldFont: textModel.fontName, newFont: newFont, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)

        textModel.$textModelChnaged.dropFirst().sink {[weak self] textModelChnaged in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textModelChanged(TextModelChangedForUndoRedo(id: textModel.modelId, textModel: textModelChnaged!)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$newText.dropFirst().sink {[weak self] newText in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textChanged(TextChanged(oldText: textModel.oldText, newText: newText, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)

        textModel.$endTextBGContent.dropFirst().sink {[weak self] newBgColor in
            guard let self = self else { return }
            if let newColor = newBgColor,let oldColor = textModel.beginTextBGContent{
                if !undoState{
                    addOperation(.textBgColorChanged(TextBgColorChanged(oldBgColor: textModel.textBGContent!, newBGColor: newBgColor!, id: textModel.modelId)))
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endBGAlpha.dropFirst().sink {[weak self] newBgAlpha in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textBgAlphaChanged(TextBgAlphaChanged(oldBgAlpha: textModel.beginBGAlpha, newBgAlpha: newBgAlpha, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$textGravity.dropFirst().sink {[weak self] newAlignment in
            guard let self = self else { return }
            if !undoState{
               addOperation(.textAlignmentChanged(TextAlignmentChanged(oldAlignment: textModel.textGravity, newAlignment: newAlignment, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endLetterSpacing.dropFirst().sink {[weak self] newLetterSpacing in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textLetterSpacingChanged(TextLetterSpacingChanged(oldLetterSpacing: textModel.beginLetterSpacing, newLetterSpacing: newLetterSpacing, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endLineSpacing.dropFirst().sink {[weak self] newLineSpacing in
            guard let self = self else { return }
            if !undoState{
                addOperation(.textLineSpacingChanged(TextLineSpacingChanged(oldLineSpacing: textModel.beginLineSpacing, newLineSpacing: newLineSpacing, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$modelFlipHorizontal.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState{
                addOperation(.flipHorizontalChanged(FlipHorizontalAction(oldvalue: textModel.modelFlipHorizontal, newValue: newValue, id: textModel.modelId)))
            }
            logger.printLog("undo Registered new flipH value: \(newValue) old flipH value: \(textModel.modelFlipHorizontal)")
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$modelFlipVertical.dropFirst().sink { [weak self] newValue in
            guard let self = self else { return }
            if !undoState {
                addOperation(.flipVeticalChanged(FlipVerticalAction(oldvalue: textModel.modelFlipVertical, newValue: newValue, id: textModel.modelId)))
            }
            logger.printLog("undo Registered new flipV value: \(newValue) old flipV value: \(textModel.modelFlipVertical)")
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$lockStatus.dropFirst().sink {[weak self] newValue in
            guard let self = self else { return }
            if !undoState {
                addOperation(.lockChanged(LockUnlockAction(oldStatus: !newValue, newStatus: newValue, id: textModel.modelId)))
            }
            logger.printLog("undo Registered new lock value: \(newValue) old lock value: \(textModel.lockStatus)")
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$softDelete.dropFirst().sink{[weak self] softDelete in
            guard let self = self else { return }
            if !undoState {
                addOperation(.deleteAction(DeleteAction(oldValue: !softDelete, newValue: softDelete, id: textModel.modelId, oldShouldSelectID: textModel.modelId, newShouldSelectID: textModel.parentId)))
            }
        }.store(in: &modelPropertiesCancellables)

        textModel.$endFrame.dropFirst().sink{[weak self] newFrame in
            guard let self = self else { return }
            if !undoState {
                addOperation(.frameChanged(FrameChanged(oldValue: textModel.beginFrame, newValue: newFrame, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endBaseTimeline.dropFirst().sink{[weak self] newTimeline in
            guard let self = self else { return }
            if !undoState {
                addOperation(.timeChanged(TimeChanged(oldValue: textModel.beginBaseTimeline, newValue: newTimeline, id: textModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)
                
        textModel.$inAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.inAnimationDurationChange(InAnimationDurationChange(id: textModel.modelId, newValue: duration, oldValue: textModel.inAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$outAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.outAnimationDurationChange(OutAnimationDurationChange(id: textModel.modelId, newValue: duration, oldValue: textModel.outAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$loopAnimationEndDuration.dropFirst().sink {[weak self] duration in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.outAnimationDurationChange(OutAnimationDurationChange(id: textModel.modelId, newValue: duration, oldValue: textModel.loopAnimationBeginDuration)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$inAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: textModel.modelId, newValue: newAnimation, oldValue: textModel.inAnimation)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$outAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: textModel.modelId, newValue: newAnimation, oldValue: textModel.outAnimation)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$loopAnimation.dropFirst().sink {[weak self] newAnimation in
            guard let self = self else { return }
             if !undoState {
                 addOperation(.animationChanged(AnimationActiom(id: textModel.modelId, newValue: newAnimation, oldValue: textModel.loopAnimation)))
            }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$filterType.dropFirst().sink{[weak self] filterType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.filterTypeModel(FilterTypeModel(id: textModel.modelId, oldValue: textModel.filterType, newValue: filterType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$maskShape.dropFirst().sink{[weak self] filterType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.maskShapeModel(MaskShapeModel(id: textModel.modelId, oldValue: textModel.maskShape, newValue: filterType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$colorAdjustmentType.dropFirst().sink{[weak self] colorAdjustmentType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.colorAdjustmentTypeModel(ColorAdjustmentTypeModel(id: textModel.modelId, oldValue: textModel.colorAdjustmentType, newValue: colorAdjustmentType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endBrightnessIntensity.dropFirst().sink{[weak self] brightness in
            guard let self = self else { return }
            if !undoState {
                addOperation(.brightnessAdjustmentModel(BrightnessAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginBrightnessIntensity, newValue: brightness)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endContrastIntensity.dropFirst().sink{[weak self] contrast in
            guard let self = self else { return }
            if !undoState {
                addOperation(.contrastAdjustmentModel(ContrastAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginContrastIntensity, newValue: contrast)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endHighlightIntensity.dropFirst().sink{[weak self] highlights in
            guard let self = self else { return }
            if !undoState {
                addOperation(.highlightAdjustmentModel(HighlightAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginHighlightIntensity, newValue: highlights)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endShadowsIntensity.dropFirst().sink{[weak self] shadows in
            guard let self = self else { return }
            if !undoState {
                addOperation(.shadowsAdjustmentModel(ShadowsAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginShadowsIntensity, newValue: shadows)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endSaturationIntensity.dropFirst().sink{[weak self] saturation in
            guard let self = self else { return }
            if !undoState {
                addOperation(.saturationAdjustmentModel(SaturationAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginSaturationIntensity, newValue: saturation)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endVibranceIntensity.dropFirst().sink{[weak self] vibrance in
            guard let self = self else { return }
            if !undoState {
                addOperation(.vibranceAdjustmentModel(VibranceAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginVibranceIntensity, newValue: vibrance)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        
        textModel.$endSharpnessIntensity.dropFirst().sink{[weak self] sharpness in
            guard let self = self else { return }
            if !undoState {
                addOperation(.sharpnessAdjustmentModel(SharpnessAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginSharpnessIntensity, newValue: sharpness)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endWarmthIntensity.dropFirst().sink{[weak self] warmth in
            guard let self = self else { return }
            if !undoState {
                addOperation(.warmthAdjustmentModel(WarmthAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginWarmthIntensity, newValue: warmth)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        textModel.$endTintIntensity.dropFirst().sink{[weak self] tint in
            guard let self = self else { return }
            if !undoState {
                addOperation(.tintAdjustmentModel(TintAdjustmentModel(id: textModel.modelId, oldValue: textModel.beginTintIntensity, newValue: tint)))
           }
        }.store(in: &modelPropertiesCancellables)
        
    }
}
