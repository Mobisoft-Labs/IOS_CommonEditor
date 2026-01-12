//
//  SM+PageObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

import simd

extension SceneManager {
    public func observeAsCurrentPage(_ pageModel: PageInfo) {
            
            guard let cPage = templateHandler?.currentPageModel,
                  let page = currentPage as? MPage,
                  let metalDisplay = self.metalDisplay else {
                logger.logError("Issue In Observing page")
                return
            }
            
            cPage.$bgBlurProgress.dropFirst().sink { [weak self] blurProgress in
                guard let self = self else { return }
    //            print("blur progress",blurProgress)
                page.backgroundChild?.setBlur(blurProgress*10)
                redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$tileMultiple.dropFirst().sink { [weak self] multiple in
                guard let self = self else { return }
                page.backgroundChild?.mTileCount = multiple * 2
                redraw()
            }.store(in: &modelPropertiesCancellables)
            
            
            cPage.$overlayOpacity.dropFirst().sink { [weak self] value in
                guard let self = self else { return }
                page.backgroundChild?.setOverlayBlur(value)
                redraw()
            }.store(in: &modelPropertiesCancellables)
            
        
            
            cPage.$bgContent.dropFirst().sink { [weak self] bgContent in
                guard let self = self else { return }
                if let color = bgContent as? BGColor{
                   
                        page.backgroundChild?.mContentType = 0.0
                    page.backgroundChild?.tileTexture = nil
    //                page.backgroundChild?.mTileCount = 0
                        page.backgroundChild?.setColor(color:Conversion.setColorForMetalView(uicolor : color.bgColor))
    //                page.bgChild?.setEmptyTexture()
                    redraw()
                    
                }
                if let gradient = bgContent as? GradientInfo{
                    page.backgroundChild?.mContentType = 1.0
                    page.backgroundChild?.mcolor = float3(0.0,0.0,0.0)
                    page.backgroundChild?.tileTexture = nil
    //                page.backgroundChild?.mTileCount = 0
                    
    //                page.bgChild?.setGradientInfo(gradientInfo:)
                    page.backgroundChild?.setGradientInfo(gradientInfo: GradientInfoMetal(startColor: Conversion.setColorForMetalView(color: "\(gradient.StartColor)"), endColor: Conversion.setColorForMetalView(color: "\(gradient.EndColor)"), gradientType: Float(gradient.GradientType), radius: gradient.Radius, angleInDegree: gradient.AngleInDegrees))
    //                page.bgChild?.setEmptyTexture()
                    redraw()
                }
                if let wallpaper = bgContent as? BGWallpaper{
                    print("Wallpaper \(wallpaper.content.localPath)")
                    page.backgroundChild?.mContentType = 2.0
                    page.backgroundChild?.mcolor = float3(0.0,0.0,0.0)
                    page.backgroundChild?.tileTexture = nil
    //                page.backgroundChild?.mTileCount = 0
                    Task{
                        
                        if let texture =  await self.textureCache.getTextureBGFromBundle(imageName: wallpaper.content.localPath, id: page.id,crop: wallpaper.content.cropRect, flip: false,isCropped: true, size: page.size){
                            
                          
                            page.backgroundChild?.setTexture(texture: texture)
                            self.redraw()
                        }
                    }
                }

                if let texture = bgContent as? BGTexture{
                    page.backgroundChild?.mContentType = 8.0
    //                page.bgChild?.mcolor = float3(0.0,0.0,0.0)
                    if page.backgroundChild!.mTileCount<1{
                        page.backgroundChild?.mTileCount = 1
                    }
                   
                    Task{
                        if let texture1 =  await self.textureCache.getTextureBGFromBundle(imageName: texture.content.localPath, id: page.id,crop: texture.content.cropRect, flip: false,size: page.size){
                            page.backgroundChild?.setTileTexture(texture: texture1)
                            page.backgroundChild?.setGradientInfo(gradientInfo: GradientInfoMetal(startColor: SIMD3(1.0, 1.0, 1.0), endColor: SIMD3(1.0, 1.0, 1.0), gradientType: 1.0, radius: 1.0, angleInDegree: 1.0))

                            //page.bgChild?.setTexture(texture: texture1)
                            self.redraw()
                        }
                    }
                }

                if let image = bgContent as? BGUserImage{
                    page.backgroundChild?.mContentType = 2.0
                    page.backgroundChild?.mcolor = float3(0.0,0.0,0.0)
                    page.backgroundChild?.tileTexture = nil
    //                page.backgroundChild?.mTileCount = 0
                    Task{
                        if let texture =  await self.textureCache.getTextureBGFromServer(imageName: image.content.localPath, id: page.id, crop: image.content.cropRect, flip: false, isCropped: true, size: page.size)/*getTexture(imageName: image.content.localPath, id: page.id, flip: false)*/{
                            
                            page.backgroundChild?.setTexture(texture: texture)
                            self.redraw()
                        }
                    }
                    
                }
            }.store(in: &modelPropertiesCancellables)
                    
            cPage.$bgOverlayContent.dropFirst().sink { [weak self] bgContent in
                guard let self = self else { return }
                if let overlay = bgContent as? BGOverlay{
    //                page.bgChild?.mContentType = 2.0
                    if overlay.content.localPath == ""{
                        page.backgroundChild?.mOverlayTexture = nil
                        redraw()
                        
                    }else{
                       
                        Task{
                            if let texture =  await self.textureCache.getTextureFromBundle(imageName: overlay.content.localPath, id: page.id,crop: overlay.content.cropRect, flip: false){
                                page.backgroundChild?.setOverlay(texture)
                                self.redraw()
                            }
                        }
                    }
                }else{
                    page.backgroundChild?.mOverlayTexture = nil
                    redraw()
                }
    //            redraw()

            }.store(in: &modelPropertiesCancellables)
            
            //For Filter and Adjustment Changes by NK.
            cPage.$filterType.dropFirst().sink { [weak self] filterType in
                guard let self = self else { return }
                page.backgroundChild?.setmFilterType(filterType: filterType)
                redraw()
            }.store(in: &modelPropertiesCancellables)
        
        cPage.$maskShape.dropFirst().sink { [weak self] newShape in
            guard let self = self else { return }
          
            Task {
               
                if newShape == "shape_0" {
                    page.backgroundChild?.setmMaskShape(maskTexture: nil, hasMask: false)
                    
                    self.redraw()

                    return
                } else {
                    
                    if let maskTexture = await self.textureCache.getTextureFromBundle(imageName: newShape, id: 0, flip: false) {
                        page.backgroundChild?.setmMaskShape(maskTexture: maskTexture, hasMask: true)
                        self.redraw()
                    } else {
                        self.logger.logError("Error Generating Mask Texture \(newShape)")
                    }
                }
            }
          // page.backgroundChild?.setmFilterType(filterType: filterType)
           
        }.store(in: &modelPropertiesCancellables)
            
            cPage.$brightnessIntensity.dropFirst().sink { [weak self] brightness in
                guard let self = self else { return }
                page.backgroundChild?.setmBrightnessIntensity(brightnessIntensity: brightness)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$contrastIntensity.dropFirst().sink { [weak self] contrastIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmContrastIntensity(contrastIntensity: contrastIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$highlightIntensity.dropFirst().sink { [weak self] highlightIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmHighlightsIntensity(highlightsIntensity: highlightIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$shadowsIntensity.dropFirst().sink { [weak self] shadowIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmShadowsIntensity(shadowsIntensity: shadowIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$saturationIntensity.dropFirst().sink { [weak self] saturationIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmSaturationIntensity(saturationIntensity: saturationIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$vibranceIntensity.dropFirst().sink { [weak self] vibranceIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmVibranceIntensity(vibranceIntensity: vibranceIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$sharpnessIntensity.dropFirst().sink { [weak self] sahrpnessIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmSharpnessIntensity(sharpnessIntensity: sahrpnessIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$warmthIntensity.dropFirst().sink { [weak self] warmthIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmWarmthIntensity(warmthIntensity: warmthIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            cPage.$tintIntensity.dropFirst().sink { [weak self] tintIntensity in
                guard let self = self else { return }
                page.backgroundChild?.setmTintIntensity(tintIntensity: tintIntensity)
                    redraw()
            }.store(in: &modelPropertiesCancellables)
            
            
            
        }
    
}
