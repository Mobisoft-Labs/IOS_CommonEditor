//
//  SM+TextObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

import Foundation

extension SceneManager {
    
    // Observe changes in Text
    public func observeAsCurrentText(_ textModel: TextInfo) {
        guard let text = templateHandler?.currentTextModel,
              let child = currentChild as? TextChild,
              let page = currentPage,
              let parent = currentParent,
              let metalDisplay = self.metalDisplay else {
            logger.logError("Issue In Observing Sticker")

            return
        }
        
        text.$baseFrame.dropFirst().sink { [weak self] value in
            // For Text
            child.setmSize(width: value.size.width, height: value.size.height)
            child.setmCenter(centerX: value.center.x, centerY: value.center.y)
            child.setmZRotation(rotation: value.rotation)
            if text.baseFrame.size != value.size && !(self!.templateHandler?.currentActionState.isTextInUpdateMode)!{
                let textProperties = text.textProperty
                if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont: false, text: text.text, properties: textProperties, refSize: value.size, maxWidth: value.size.width, maxHeight: .infinity, contentScaleFactor: self!.sceneConfig!.contentScaleFactor, logger: self!.logger)!, flip: false ){
                    // Set Texture
                    child.setTexture(texture: texture)
                    self!.redraw()
                }
            }
            else if text.baseFrame.center != value.center {
                let textProperties = text.textProperty
                if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont: false, text: text.text, properties: textProperties, refSize: value.size, maxWidth: value.size.width, maxHeight: .infinity, contentScaleFactor: self!.sceneConfig!.contentScaleFactor, logger: self!.logger)!, flip: false ){
                    // Set Texture
                    child.setTexture(texture: texture)
                    self!.redraw()
                }
            }
            else if  text.baseFrame.rotation != value.rotation{
                let textProperties = text.textProperty
                if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont: false, text: text.text, properties: textProperties, refSize: value.size, maxWidth: value.size.width, maxHeight: .infinity, contentScaleFactor: self!.sceneConfig!.contentScaleFactor, logger: self!.logger)!, flip: false ){
                    // Set Texture
                    child.setTexture(texture: texture)
                    self!.redraw()
                }
            }
        }.store(in: &modelPropertiesCancellables)
        

        text.$textModelChnaged.dropFirst().sink{  [weak self] textChangedModel in
            guard let self = self else { return }
            
            print("KLK1 \(textChangedModel!.newSize)")
//            let newMargin = getProptionalMargin(oldSize: text.baseFrame.size, newSize:  textChangedModel!.newSize, widthMargin: text.textProperty.externalWidthMargin, heightMargin: text.textProperty.externalHeightMargin)
            child.setmSize(width: CGFloat(textChangedModel!.newSize.width), height: CGFloat(textChangedModel!.newSize.height))
            var textProperty = text.textProperty
//            textProperty.externalWidthMargin = newMargin.widthMargin
//            textProperty.externalHeightMargin = newMargin.heightMargin
            let parentModel = templateHandler?.getModel(modelId: text.parentId)
            let isPersonalizeActive = (templateHandler?.isPersonalizeActive)!
            // create a new texture
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont: isPersonalizeActive ? false : true , text: textChangedModel!.newText, properties: textProperty, refSize: textChangedModel!.newSize, maxWidth: textChangedModel!.newSize.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        /* Neeshu Kumar */
        // Text Color Change
        text.$textContentColo.dropFirst().sink {  [weak self] textColor in
            guard let self = self else { return }
            if let color = textColor as? BGColor{
                if let bgColor = text.textBGContent as? BGColor{
                    if bgColor.bgColor != .clear{
                        text.bgType = 2
                    }
                    else{
                        text.bgType = 0
                    }
                }
                var textProperties = text.textProperty
                textProperties.textColor = color.bgColor
                textProperties.forgroundColor  = color.bgColor
                textProperties.bgType = Float(text.bgType)
                if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : true, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                    // set texture
                    child.setTexture(texture: texture)
                    self.redraw()
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        // Letter Spacing
        text.$letterSpacing.dropFirst().sink { [weak self] letterSpacing in
            guard let self = self else { return }
           //text.letterSpacing = letterSpacing
            var textProperties = text.textProperty
            
            textProperties.letterSpacing = letterSpacing
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont: false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        
        // Line Spacing
        text.$lineSpacing.dropFirst().sink { [weak self] lineSpacing in
            guard let self = self else { return }
//            text.lineSpacing = lineSpacing
            var textProperties = text.textProperty
            textProperties.lineSpacing = lineSpacing
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont: false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        // DirectionX
        text.$shadowDx.dropFirst().sink { [weak self] dx in
            guard let self = self else { return }
//            text.shadowDx = dx
            var textProperties = text.textProperty
            textProperties.shadowDx = dx
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        // DirectionY
        text.$shadowDy.dropFirst().sink { [weak self] dy in
            guard let self = self else { return }
//            text.shadowDy = dy
            var textProperties = text.textProperty
            textProperties.shadowDy = dy
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        // ShadowOpacity
        text.$shadowRadius.dropFirst().sink { [weak self] shadowOpacity in
            guard let self = self else { return }
            var textProperties = text.textProperty
            textProperties.shadowRadius = shadowOpacity
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        // Shadow Color
        text.$textShadowColorFilter.dropFirst().sink { [weak self] shadowColor in
            guard let self = self else { return }
            if let shadowColor = shadowColor as? ColorFilter{
                text.shadowColor = shadowColor.filter
                var textProperties = text.textProperty
                textProperties.shadowColor = shadowColor.filter
                if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : true, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                    // set texture
                    child.setTexture(texture: texture)
                    self.redraw()
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        // Text Background Color
        text.$textBGContent.dropFirst().sink { [weak self] textColor in
            guard let self = self else { return }
            if let color = textColor as? BGColor{
                if color.bgColor != .clear{
                    text.bgType = 2
                }
                else{
                    text.bgType = 0
                }
                var textProperties = text.textProperty
                textProperties.bgType = Float(text.bgType)
                textProperties.backgroundColor = color.bgColor
               
                if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : true, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                    // set texture
                    child.setTexture(texture: texture)
                    self.redraw()
                }
            }
        }.store(in: &modelPropertiesCancellables)
        
        // Text Gravity
        text.$textGravity.dropFirst().sink { [weak self] textGravity in
            guard let self = self else { return }
            var textProperties = text.textProperty
            textProperties.textGravity = textGravity
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        // Text Alpha
        text.$bgAlpha.dropFirst().sink { [weak self] alpha in
            guard let self = self else { return }
            var textProperties = text.textProperty
            textProperties.bgAlpha = alpha
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : true, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        // Text Font
        text.$textFont.dropFirst().sink { [weak self] font in
            guard let self = self else { return }
            var textProperties = text.textProperty
            textProperties.fontName = font.fontName
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)

        
      
        
        text.$shadowRadius.dropFirst().sink { [weak self] radius in
            guard let self = self else { return }
            var textProperties = text.textProperty
            textProperties.shadowRadius = radius
            if let texture =  Conversion.loadTexture(image: text.createImage(keepSameFont : false, text: text.text, properties: textProperties, refSize: text.baseFrame.size, maxWidth: text.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                // set texture
                child.setTexture(texture: texture)
                self.redraw()
            }
        }.store(in: &modelPropertiesCancellables)
        
        /* Neeshu Kumar : End*/
        //For Filter and Adjustment Changes by NK.
        text.$filterType.dropFirst().sink { [weak self] filterType in
            guard let self = self else { return }
            child.setmFilterType(filterType: filterType)
            redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$maskShape.dropFirst().sink { [weak self] filterType in
            guard let self = self else { return }
          //  child.setmFilterType(filterType: filterType)
            redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$brightnessIntensity.dropFirst().sink { [weak self] brightness in
            guard let self = self else { return }
                child.setmBrightnessIntensity(brightnessIntensity: brightness)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$contrastIntensity.dropFirst().sink { [weak self] contrastIntensity in
            guard let self = self else { return }
                child.setmBrightnessIntensity(brightnessIntensity: contrastIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$highlightIntensity.dropFirst().sink { [weak self] highlightIntensity in
            guard let self = self else { return }
                child.setmHighlightsIntensity(highlightsIntensity: highlightIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$shadowsIntensity.dropFirst().sink { [weak self] shadowIntensity in
            guard let self = self else { return }
                child.setmShadowsIntensity(shadowsIntensity: shadowIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$saturationIntensity.dropFirst().sink { [weak self] saturationIntensity in
            guard let self = self else { return }
                child.setmSaturationIntensity(saturationIntensity: saturationIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$vibranceIntensity.dropFirst().sink { [weak self] vibranceIntensity in
            guard let self = self else { return }
                child.setmVibranceIntensity(vibranceIntensity: vibranceIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$sharpnessIntensity.dropFirst().sink { [weak self] sahrpnessIntensity in
            guard let self = self else { return }
                child.setmSharpnessIntensity(sharpnessIntensity: sahrpnessIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$warmthIntensity.dropFirst().sink { [weak self] warmthIntensity in
            guard let self = self else { return }
                child.setmWarmthIntensity(warmthIntensity: warmthIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        text.$tintIntensity.dropFirst().sink { [weak self] tintIntensity in
            guard let self = self else { return }
                child.setmTintIntensity(tintIntensity: tintIntensity)
                redraw()
        }.store(in: &modelPropertiesCancellables)
        
        
        
    }
}
