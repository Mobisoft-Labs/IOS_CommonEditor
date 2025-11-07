//
//  UR+PageObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension UndoRedoManager {
    // Observe the Page/ BG Model
    public func observeAsCurrentPage(_ pageModel: PageInfo) {
        
        pageModel.$endTileMultiple.dropFirst().sink {[weak self] newTileSize in
            guard let self = self else { return }
            if !undoState {
                addOperation(.pageTileAMultipleChanged(PageTileAMultipleChanged(oldTileMultiple: pageModel.beginTileMultiple, newTileMultiple: newTileSize, id: pageModel.modelId)))
            }
            logger.printLog("undo Registered new tile Size value: \(newTileSize) old tile Size value: \(pageModel.tileMultiple)")
        }.store(in: &modelPropertiesCancellables)

        pageModel.$endOpacity.dropFirst().sink {[weak self]  value in
            guard let self = self else { return }
            if !undoState {
                addOperation(.OpacityChanged(OpacityUndoModel(oldOpacity: pageModel.beginOpacity, newOpacity: value, id: pageModel.modelId)))
            }
            logger.printLog("undo Registered new value: \(pageModel.endOpacity) old opacity: \(pageModel.beginOpacity)")
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endBlur.dropFirst().sink {[weak self] newBlur in
            guard let self = self else { return }
            if !undoState {
                addOperation(.pageBGBlurChanged(PageBGBlurChanged(oldBgBlur: pageModel.beginBlur, newBgBlur: newBlur, id: pageModel.modelId)))
            }
            logger.printLog("undo Registered new blur value: \(newBlur) old blur value: \(pageModel.bgBlurProgress)")
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endOverlayOpacity.dropFirst().sink {[weak self] newOverlayOpacity in
            guard let self = self else { return }
            if !undoState {
               addOperation(.pageOverlayOpacityChanged(PageOverlayOpacityChanged(oldOverlayOpacity: pageModel.beginOverlayOpacity, newOverlayOpacity: newOverlayOpacity, id: pageModel.modelId)))
            }
        }.store(in: &modelPropertiesCancellables)

        pageModel.$endBgContent.dropFirst().sink {[weak self] bgContent in
            guard let self = self else { return }
            if let content = bgContent,let oldContent = pageModel.endBgContent{
                if !undoState {
                   addOperation(.pageBGContentChanged(PageBGContentChanged(oldBGContent: oldContent, newBGContent: content, id: pageModel.modelId)))
                    logger.printLog("undo Registered new value: \(oldContent) old opacity: \(content)")
                }
                
            }
           
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$bgOverlayContent.dropFirst().sink {[weak self] bgContent in
            guard let self = self else { return }
            if let content = bgContent{
                if !undoState {
                    addOperation(.pageBGOverlayContentChanged(PageBGOverlayContentChanged(oldBGContent: pageModel.bgOverlayContent, newBGContent: content, id: pageModel.modelId)))
                    logger.printLog("undo Registered new value: \(pageModel.bgOverlayContent) old opacity: \(content)")
                }
                
            }
           
        }.store(in: &modelPropertiesCancellables)

        pageModel.$maskShape.dropFirst().sink{[weak self] filterType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.maskShapeModel(MaskShapeModel(id: pageModel.modelId, oldValue: pageModel.maskShape, newValue: filterType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$filterType.dropFirst().sink{[weak self] filterType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.filterTypeModel(FilterTypeModel(id: pageModel.modelId, oldValue: pageModel.filterType, newValue: filterType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$colorAdjustmentType.dropFirst().sink{[weak self] colorAdjustmentType in
            guard let self = self else { return }
            if !undoState {
                addOperation(.colorAdjustmentTypeModel(ColorAdjustmentTypeModel(id: pageModel.modelId, oldValue: pageModel.colorAdjustmentType, newValue: colorAdjustmentType)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endBrightnessIntensity.dropFirst().sink{[weak self] brightness in
            guard let self = self else { return }
            if !undoState {
                addOperation(.brightnessAdjustmentModel(BrightnessAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginBrightnessIntensity, newValue: brightness)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endContrastIntensity.dropFirst().sink{[weak self] contrast in
            guard let self = self else { return }
            if !undoState {
                addOperation(.contrastAdjustmentModel(ContrastAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginContrastIntensity, newValue: contrast)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endHighlightIntensity.dropFirst().sink{[weak self] highlights in
            guard let self = self else { return }
            if !undoState {
                addOperation(.highlightAdjustmentModel(HighlightAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginHighlightIntensity, newValue: highlights)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endShadowsIntensity.dropFirst().sink{[weak self] shadows in
            guard let self = self else { return }
            if !undoState {
                addOperation(.shadowsAdjustmentModel(ShadowsAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginShadowsIntensity, newValue: shadows)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endSaturationIntensity.dropFirst().sink{[weak self] saturation in
            guard let self = self else { return }
            if !undoState {
                addOperation(.saturationAdjustmentModel(SaturationAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginSaturationIntensity, newValue: saturation)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endVibranceIntensity.dropFirst().sink{[weak self] vibrance in
            guard let self = self else { return }
            if !undoState {
                addOperation(.vibranceAdjustmentModel(VibranceAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginVibranceIntensity, newValue: vibrance)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        
        pageModel.$endSharpnessIntensity.dropFirst().sink{[weak self] sharpness in
            guard let self = self else { return }
            if !undoState {
                addOperation(.sharpnessAdjustmentModel(SharpnessAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginSharpnessIntensity, newValue: sharpness)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endWarmthIntensity.dropFirst().sink{[weak self] warmth in
            guard let self = self else { return }
            if !undoState {
                addOperation(.warmthAdjustmentModel(WarmthAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginWarmthIntensity, newValue: warmth)))
           }
        }.store(in: &modelPropertiesCancellables)
        
        pageModel.$endTintIntensity.dropFirst().sink{[weak self] tint in
            guard let self = self else { return }
            if !undoState {
                addOperation(.tintAdjustmentModel(TintAdjustmentModel(id: pageModel.modelId, oldValue: pageModel.beginTintIntensity, newValue: tint)))
           }
        }.store(in: &modelPropertiesCancellables)
    }
}
