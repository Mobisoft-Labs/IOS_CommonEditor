//
//  SM+StickerObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension SceneManager {
    public func observeAsCurrentSticker(_ stickerModel: StickerInfo) {
        
        guard let sticker = templateHandler?.currentStickerModel,
                  var child = currentChild as? StickerChild,
                  let page = currentPage,
                  let parent = currentParent,
                  let metalDisplay = self.metalDisplay else {
            logger.logError("Issue In Observing Sticker")
                return
            }

            // HK** None Type Pending ...
            // Manage Sticker Filter
            sticker.$stickerFilter.dropFirst().sink { [weak self] value in
                guard let self = self else { return }
                if let hue = value as? HueFilter{
                    let huevalue = Float(Float(hue.filter)*2*22/7)/360.0
                    child.mStickerType = 1
                    child.setmHue(value: huevalue)
                    self.redraw()
                }
                if let color = value as? ColorFilter{
                    if color.filter == .clear{
                        child.mStickerType = 0
                    }else{
                        child.mStickerType = 2
                        child.mcolor = Conversion.setColorForMetalView(uicolor: color.filter)
                        
                    }
                    self.redraw()
                }
                // HK** None functionality
                if let none = value as? NoneFilter{
                    child.mStickerType = 0
                    self.redraw()
                }
            }.store(in: &modelPropertiesCancellables)
            
            
            
            sticker.$changeOrReplaceImage.dropFirst().sink { [weak self] replaceModel in
                guard let self = self else { return }
                if let model = replaceModel{
                    let newChild = child
                    Task{
                        var crop = false
                        if model.imageModel.cropRect != newChild.mCropRect{
                            crop = true
                        }
                        newChild.mCropStyle = replaceModel?.imageModel.cropType.rawValue ?? 1
                        await self.changedImageContent(model: newChild, imageModel: model.imageModel, isCropped: crop)
    //                    newChild.setmSize(width: model.baseFrame.size.width, height: model.baseFrame.size.height)
                        self.redraw()
                        
                    }
                }
            }.store(in: &modelPropertiesCancellables)
            
            
            //For Filter and Adjustment Changes by NK.
            sticker.$filterType.dropFirst().sink { [weak self] filterType in
                guard let self = self else { return }
                child.setmFilterType(filterType: filterType)
                redraw()
            }.store(in: &modelPropertiesCancellables)
        sticker.$maskShape.dropFirst().sink { [weak self] filterType in
            guard let self = self else { return }
           
            redraw()
        }.store(in: &modelPropertiesCancellables)
            
            sticker.$brightnessIntensity.dropFirst().sink { [weak self] brightness in
                guard let self = self else { return }
                    child.setmBrightnessIntensity(brightnessIntensity: brightness)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$contrastIntensity.dropFirst().sink { [weak self] contrastIntensity in
                guard let self = self else { return }
                    child.setmBrightnessIntensity(brightnessIntensity: contrastIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$highlightIntensity.dropFirst().sink { [weak self] highlightIntensity in
                guard let self = self else { return }
                    child.setmHighlightsIntensity(highlightsIntensity: highlightIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$shadowsIntensity.dropFirst().sink { [weak self] shadowIntensity in
                guard let self = self else { return }
                    child.setmShadowsIntensity(shadowsIntensity: shadowIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$saturationIntensity.dropFirst().sink { [weak self] saturationIntensity in
                guard let self = self else { return }
                    child.setmSaturationIntensity(saturationIntensity: saturationIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$vibranceIntensity.dropFirst().sink { [weak self] vibranceIntensity in
                guard let self = self else { return }
                    child.setmVibranceIntensity(vibranceIntensity: vibranceIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$sharpnessIntensity.dropFirst().sink { [weak self] sahrpnessIntensity in
                guard let self = self else { return }
                    child.setmSharpnessIntensity(sharpnessIntensity: sahrpnessIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$warmthIntensity.dropFirst().sink { [weak self] warmthIntensity in
                guard let self = self else { return }
                    child.setmWarmthIntensity(warmthIntensity: warmthIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            sticker.$tintIntensity.dropFirst().sink { [weak self] tintIntensity in
                guard let self = self else { return }
                    child.setmTintIntensity(tintIntensity: tintIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            
        }
    
}
