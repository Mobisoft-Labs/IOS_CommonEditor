//
//  SceneComposable.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/04/24.
//

import Foundation
import Metal

protocol SceneComposable {
    var cancelPreparing : Bool {get set}
    var updateThumb : Bool {get}
    var isUserSubscribed : Bool {get}
    var textureCache : TextureCache {get set}
    var canCacheMchild : Bool { get set }
    var commandQueue: MTLCommandQueue! {get set}
    var metalThread : MetalThread {get set} 
    func createPage(_ pageInfo:PageInfo) async ->MPage?
    func createMParent(parentModel:ParentInfo) async ->MParent
    func createBackground(_bgInfo:PageInfo) async ->BGChild?
    func createText(_ textInfo: TextInfo) async -> TextChild
    func createSticker(_ stickerInfo:StickerInfo) async ->StickerChild?
    func cacheChild(key:Int , value : MChild)
    func createWatermark(_ rootSize : CGSize ) async -> MWatermark?
    var sceneProgress : ((Float)->Void)? { get set }
    var sceneConfig: SceneConfiguration? { get }
    var logger: PackageLogger { get }
    var resourceProvider: TextureResourceProvider { get }
}

extension SceneComposable {
    func createWatermark(_ rootSize : CGSize ) async -> MWatermark? {

        let text = TextInfo()
        text.modelId = -1
        text.text = "Flyer Maker"
        text.textColor = sceneConfig!.accentColor
        text.bgColor = .clear
        text.width = Float(rootSize.width) * 0.3
        text.height = Float(rootSize.width) * 0.1
//        text.posX = Float(rootSize.width)  - (Float(rootSize.width) * 0.21)
//        text.posY = Float(rootSize.height) - (Float(rootSize.width) * 0.06)
        text.posX = Float(rootSize.width)  - (text.width/2) // (Float(rootSize.width) * 0.21)
        text.posY = Float(rootSize.height) - (text.height/2) //(Float(rootSize.width) * 0.06)
        
           
        let textChild = MWatermark(model: text)
        var textProperties = text.textProperty
        textProperties.letterSpacing = 0
        let texture = Conversion.loadTexture(image: text.createImage( text: text.text, properties: textProperties, refSize: CGSize(width: CGFloat(text.width), height:  CGFloat(text.height)), maxWidth: CGFloat(text.width), maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false )
        textChild.mContentType = 2
        textChild.setTexture(texture: texture!)
        textChild.setmOpacity(opacity: Conversion.setOpacityForMetalView(value: (text.modelOpacity)))
        textChild.setmSize(width: CGFloat(text.width), height: CGFloat(text.height))
        textChild.setmCenter(centerX:  CGFloat(text.posX), centerY:  CGFloat(text.posY))
            // textChild.set
       
       
            
       return textChild
    }

}

class MChildHandler {
    
    var childDict : [Int : MChild] = [:]
    
    // Contains Reference of CurrentSticker Model.
    var currentStickerMChild : StickerChild?
    
    // Contains Reference of CurrentText Model.
    var currentTextModel : TextChild?
    
    // Contains Reference of CurrentText Model.
    var currentParentModel : MParent?
    
   
    
    
    // Contains Referance of Current Model Common Properties.
   var currentModel : MChild?
    
    // Contains Referance of Page Model Common Properties.
    var currentPageModel : MPage?
    
    func cleanUp() {
        childDict.removeAll()
    }
    
    func addModel(model: MChild) {
        childDict[model.id] = model
    }
    
    func removeModel(modelId:Int) {
        childDict.removeValue(forKey: modelId)
    }
    
    
    func getModel(modelId : Int) -> MChild? {
        return childDict[modelId]
    }
    
    func getParentsOfChild(childId:Int) -> MParent? {
        guard let child = childDict[childId] else { return nil }
        return childDict[child.parent!.id] as? MParent
    }
    
    func getChildrenFor(parentID : Int) -> [MChild] {
        let children = childDict.values.filter { $0.parent?.id == parentID }
        return Array(children)
    }
}


extension SceneComposable {
    
    mutating func createCommmandQueue(){
        commandQueue = MetalDefaults.GPUDevice.makeCommandQueue()!
    }
    func createPage(_ pageInfo:PageInfo) async->MPage?{
        DispatchQueue.main.async {
            sceneProgress?(Float(0.0))
        }
        var mPage = MPage(pageInfo: pageInfo)
        
        if canCacheMchild { cacheChild(key: pageInfo.modelId, value: mPage)}
        let bgChildInfo = pageInfo
        
//        bgChildInfo.startTime = 0.0
        if let mBg = await createBackground(_bgInfo: bgChildInfo) {
                //  childTable[pageInfo.dataId] = mBg
            let cent = CGPoint(x: mPage.size.width/2, y: mPage.size.height/2)
            mBg.center = cent
            mBg.startTime = 0.0
//            mPage.addChild(mBg)
//            mBg.size = mPage.size
           
            mPage.backgroundChild = mBg
            }
            for child in pageInfo.children{
                if cancelPreparing {
                    break
                }
                
                if child.modelType == .Parent{
                   // child.startTime += mPage.startTime
                    let parentInfo = await createMParent(parentModel: child as! ParentInfo)
//                    if canCacheMchild { cacheChild(key: child.modelId, value: parentInfo) }
                    mPage.addChild(parentInfo)
                    
                    DispatchQueue.main.async {
                        let progress = (Double(1.0)/Double(pageInfo.children.count))
                        sceneProgress?(Float(progress))
                    }
                }
                else if child.modelType == .Sticker{
                   // child.startTime += mPage.startTime
                    if let stickerInfo = await createSticker(child as! StickerInfo){
                        if canCacheMchild { cacheChild(key: child.modelId, value: stickerInfo) }
                        mPage.addChild(stickerInfo)
                        DispatchQueue.main.async {
                            let progress = (Double(1.0)/Double(pageInfo.children.count))
                            sceneProgress?(Float(progress))
                        }
                    }
                }
                else if child.modelType == .Text{
                    // child.startTime += mPage.startTime
                    let textChild = await createText(child as! TextInfo)
                    if canCacheMchild { cacheChild(key: child.modelId, value: textChild) }
                    mPage.addChild(textChild)
                    DispatchQueue.main.async {
                        let progress = (Double(1.0)/Double(pageInfo.children.count))
                        sceneProgress?(Float(progress))
                    }
                    
                  
                }
            }
        
        
            return mPage
        }
        
    func createMParent(parentModel:ParentInfo) async->MParent{
            var mParent = MParent(model: parentModel)
        if canCacheMchild { cacheChild(key: mParent.id, value: mParent) }
        
            for child in parentModel.children{
                if cancelPreparing {
                    break
                }
                
                if child.modelType == .Parent{
                    // child.startTime += parentModel.startTime
                    let parentInfo = await createMParent(parentModel: child as! ParentInfo)
                    
                    mParent.addChild(parentInfo)
                }
                else if child.modelType == .Sticker{
                   // child.startTime += parentModel.startTime
                    if  let stickerInfo = await createSticker(child as! StickerInfo){
                        if canCacheMchild { cacheChild(key: child.modelId, value: stickerInfo) }
                        mParent.addChild(stickerInfo)
                    }
                }
                else{
                    
                    
                   // child.startTime += parentModel.startTime
                    let textChild = await createText(child as! TextInfo)
                    if canCacheMchild { cacheChild(key: child.modelId, value: textChild) }
                    mParent.addChild(textChild)
    
                }
            }
            return mParent
        }
    
        
    func createBackground(_bgInfo:PageInfo) async -> BGChild?{
            var bgChild = BGChild(model: _bgInfo)

            bgChild.setmOpacity(opacity: _bgInfo.modelOpacity)
            bgChild.setmFilterType(filterType: _bgInfo.filterType)
            bgChild.setAdjustmentIntensity(brightnessIntensity: _bgInfo.brightnessIntensity, contrastIntensity: _bgInfo.contrastIntensity, highlightsIntensity: _bgInfo.highlightIntensity, shadowsIntensity: _bgInfo.shadowsIntensity, saturationIntensity: _bgInfo.saturationIntensity, vibranceIntensity: _bgInfo.vibranceIntensity, sharpnessIntensity: _bgInfo.sharpnessIntensity, warmthIntensity: _bgInfo.warmthIntensity, tintIntensity: _bgInfo.tintIntensity)
        
        // calculate new size with page aspect
        if let bgContent = _bgInfo.bgContent{
            bgChild = await setBGSource(imageModel: bgContent, info: bgChild as TexturableChild, tileCount: _bgInfo.tileMultiple) as! BGChild
            
        }

            
            //MARK: - Blur
        bgChild.setBlur(Conversion.setOpacityForMetalView(value: _bgInfo.bgBlurProgress * 10))
            
            //MARK: - Pattern
            
            //        bgChild.setTileCount(count: 5)
            
        
        if _bgInfo.hasMask,  _bgInfo.maskShape != "" {
            
            if let maskTexture = await textureCache.getTextureFromBundle(imageName: _bgInfo.maskShape, id: 0, flip: false) {
                bgChild.setmMaskShape(maskTexture: maskTexture, hasMask: true)
            } else {
                logger.logError("Error Generating Mask Texture \(_bgInfo.maskShape)")
            }
            
        }
        
            //MARK: - Overlay
        if let overlay2 = ((_bgInfo.bgOverlayContent as? BGOverlay)?.content as? ImageModel)  {
            //        bgChild.setColor(color: Conversion.setColorForMetalView(color: _bgInfo.colorInfo))
            if let lastPathComponent = overlay2.localPath.components(separatedBy: "/").last  {
                if let overlay =  await textureCache.getTextureFromBundle(imageName: lastPathComponent, id: _bgInfo.overlayID, flip: false){
                    
                    bgChild.mOverlayTexture = overlay
                    
                }
            }else{
                if let lastPathComponent = _bgInfo.overlayLocalPath.components(separatedBy: "/").last  {
                    if let overlay =  await textureCache.getTextureFromBundle(imageName: lastPathComponent, id: _bgInfo.overlayID, flip: false){
                        
                        bgChild.mOverlayTexture = overlay
                        
                    }
                }
            }
        }
              bgChild.setOverlayBlur(Float(_bgInfo.overlayOpacity))
            
            return bgChild
        }
        
        
    func createText(_ textInfo: TextInfo) -> TextChild {
            let textInfo_ = textInfo
            DispatchQueue.main.async{
                textInfo_.width = textInfo.width+textInfo.internalWidthMargin
            }
            
            let textChild = TextChild(model: textInfo_)
            textChild.setmFilterType(filterType: textInfo.filterType)
            textChild.setAdjustmentIntensity(brightnessIntensity: textInfo_.brightnessIntensity, contrastIntensity: textInfo_.contrastIntensity, highlightsIntensity: textInfo_.highlightIntensity, shadowsIntensity: textInfo_.shadowsIntensity, saturationIntensity: textInfo_.saturationIntensity, vibranceIntensity: textInfo_.vibranceIntensity, sharpnessIntensity: textInfo_.sharpnessIntensity, warmthIntensity: textInfo_.warmthIntensity, tintIntensity: textInfo_.tintIntensity)
            
            
            var properties = textInfo.textProperty
            
            if let image = textInfo.createImage(thumbUpdate : updateThumb, keepSameFont : false, text: textInfo.text, properties: properties, refSize: textInfo.baseFrame.size, maxWidth: textInfo.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger) {
                
                let texture = Conversion.loadTexture(image: image, flip: false )
                textChild.mContentType = 2
                textChild.setTexture(texture: texture!)
                
                textChild.setmOpacity(opacity: Conversion.setOpacityForMetalView(value: (textInfo.modelOpacity)))
                // textChild.set
            }
            return textChild
        }
        
        
    func createSticker(_ stickerInfo:StickerInfo) async->StickerChild?{
            
            var StickerChild = StickerChild(model: stickerInfo)
            StickerChild.setmOpacity(opacity: stickerInfo.modelOpacity)
            StickerChild.setBlur(Conversion.setOpacityForMetalView(value: stickerInfo.bgBlurProgress))
            StickerChild.setMCropStyle(cropStyle: stickerInfo.changeOrReplaceImage?.imageModel.cropType.rawValue ?? 1)
        
            StickerChild.setmFilterType(filterType: stickerInfo.filterType)
            StickerChild.setAdjustmentIntensity(brightnessIntensity: stickerInfo.brightnessIntensity, contrastIntensity: stickerInfo.contrastIntensity, highlightsIntensity: stickerInfo.highlightIntensity, shadowsIntensity: stickerInfo.shadowsIntensity, saturationIntensity: stickerInfo.saturationIntensity, vibranceIntensity: stickerInfo.vibranceIntensity, sharpnessIntensity: stickerInfo.sharpnessIntensity, warmthIntensity: stickerInfo.warmthIntensity, tintIntensity: stickerInfo.tintIntensity)
            // StickerChild.s
            StickerChild.setTileCount(count: stickerInfo.tileMultiple)
        if stickerInfo.stickerFilterType == 2 && stickerInfo.stickerColor != .clear{
                //            StickerChild.canColorApply = true
                StickerChild.mStickerType = 2.0
                StickerChild.setColor(color: Conversion.setColorForMetalView(uicolor: stickerInfo.stickerColor))
            }
            else if stickerInfo.stickerFilterType == 1{
                StickerChild.mStickerType = 1.0
                //            StickerChild.canColorApply = false
                StickerChild.setmHue(value: Float(Float(stickerInfo.stickerHue)*2*22/7)/360.0)
            }else{
                StickerChild.mStickerType = 0.0
            }
        
        StickerChild = await setImageAsSource(imageModel: stickerInfo, info: StickerChild as TexturableChild) as! StickerChild
            
            return StickerChild
        }
    func setImageAsSource(imageModel:ImageProtocol,info: TexturableChild,overlay:String = " ") async->TexturableChild{
        let localImageModel = imageModel.changeOrReplaceImage!
        let model = info
        model.setMCropRect(cropRect: (localImageModel.imageModel.cropRect))
        if localImageModel.imageModel.imageType == .COLOR{
            model.mContentType =  0.0
            
            model.setColor(color: Conversion.setColorForMetalView(color: imageModel.colorInfo))

        }
        else if localImageModel.imageModel.imageType == .GRADIENT{
            model.mContentType =  1.0

            if let gradintInfo = parseGradient(from: imageModel.colorInfo){
                model.setGradientInfo(gradientInfo: GradientInfoMetal(startColor: Conversion.setColorForMetalView(color: "\(gradintInfo.StartColor)"), endColor: Conversion.setColorForMetalView(color: "\(gradintInfo.EndColor)"), gradientType: Float(gradintInfo.GradientType), radius: gradintInfo.Radius, angleInDegree: gradintInfo.AngleInDegrees))
//                model.createEmptyTexture()
            }
            
            
        }else{
            model.mContentType =  2.0
               
            if  localImageModel.imageModel.sourceType == .SERVER{
                if let texture =  await textureCache.getTextureFromServer(imageName: localImageModel.imageModel.serverPath, id: imageModel.imageID,crop: CGRect(x: CGFloat(localImageModel.imageModel.cropRect.origin.x), y: CGFloat(localImageModel.imageModel.cropRect.origin.y), width: CGFloat(localImageModel.imageModel.cropRect.width), height: CGFloat(localImageModel.imageModel.cropRect.height)), flip: false, checkInCache: textureCache.checkInCache){
                    //8E0F20EA7ACB057A4B2EF33AA7579585
                        model.setTexture(texture: texture)
                        
                    
                }
            
                
        }
        else if localImageModel.imageModel.sourceType == .DOCUMENT{
            if let texture =  await textureCache.getTextureFromLocal(imageName: (localImageModel.imageModel.localPath), id: info.id,crop: CGRect(x: CGFloat(localImageModel.imageModel.cropRect.origin.x), y: CGFloat((localImageModel.imageModel.cropRect.origin.y)), width: CGFloat((localImageModel.imageModel.cropRect.width)), height: CGFloat((localImageModel.imageModel.cropRect.height))), flip: false, checkInCache: textureCache.checkInCache){
               
                    model.setTexture(texture: texture)
               
                }
        }
            else {
//                if imageModel.lo
                if let lastPathComponent = localImageModel.imageModel.localPath.components(separatedBy: "/").last  {
                    if let texture =  await textureCache.getTextureFromBundle(imageName: lastPathComponent, id: info.id,crop: CGRect(x: CGFloat(localImageModel.imageModel.cropRect.origin.x), y: CGFloat(localImageModel.imageModel.cropRect.origin.y), width: CGFloat(localImageModel.imageModel.cropRect.width), height: CGFloat(localImageModel.imageModel.cropRect.height)), flip: false){
                        
                        model.setTexture(texture: texture)
                        
                    }
                    
                }
                
            }
            
         
              
       
        }
        return model
    }
    
    
    
    
    func changedImageContent(model:  StickerChild,imageModel:ImageModel,isCropped:Bool) async{
        if  imageModel.sourceType == .SERVER{
            if let texture =  await textureCache.getTextureFromServer(imageName: imageModel.serverPath, id: model.id,crop: CGRect(x: CGFloat(imageModel.cropRect.origin.x), y: CGFloat(imageModel.cropRect.origin.y), width: CGFloat(imageModel.cropRect.width), height: CGFloat(imageModel.cropRect.height)), flip: false,isCropped: isCropped){
               
                    model.setTexture(texture: texture)
               
                }
        
            
    }
    else if imageModel.sourceType == .DOCUMENT{
        //
        
        if let texture =  await textureCache.getTextureFromLocal(imageName: imageModel.localPath, id: model.id,crop: CGRect(x: CGFloat(imageModel.cropRect.origin.x), y: CGFloat(imageModel.cropRect.origin.y), width: CGFloat(imageModel.cropRect.width), height: CGFloat(imageModel.cropRect.height)), flip: false,isCropped: isCropped){
           
                model.setTexture(texture: texture)
           
            }
    }
        else {
//                if imageModel.lo
            if let lastPathComponent = imageModel.localPath.components(separatedBy: "/").last  {
                
                
                if let texture =  await textureCache.getTextureFromBundle(imageName: lastPathComponent, id: model.id,crop: CGRect(x: CGFloat(imageModel.cropRect.origin.x), y: CGFloat(imageModel.cropRect.origin.y), width: CGFloat(imageModel.cropRect.width), height: CGFloat(imageModel.cropRect.height)), flip: false,isCropped: isCropped){
                    
                    model.setTexture(texture: texture)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    func setBGSource(imageModel:ImageProtocol,info: TexturableChild,overlay:String = " ",isRatioChanged:Bool = false) async->TexturableChild{
        let model = info
        model.setMCropRect(cropRect: imageModel.cropRect)
        if imageModel.imageType == .COLOR{
            model.mContentType =  0.0
            
            model.setColor(color: Conversion.setColorForMetalView(color: imageModel.colorInfo))

        }
        else if imageModel.imageType == .GRADIENT{
            model.mContentType =  1.0

            if let gradintInfo = parseGradient(from: imageModel.colorInfo){
                model.setGradientInfo(gradientInfo: GradientInfoMetal(startColor: Conversion.setColorForMetalView(color: "\(gradintInfo.StartColor)"), endColor: Conversion.setColorForMetalView(color: "\(gradintInfo.EndColor)"), gradientType: Float(gradintInfo.GradientType), radius: gradintInfo.Radius, angleInDegree: gradintInfo.AngleInDegrees))
//                model.createEmptyTexture()
            }
            
            
        }else{
            // get ratioSize
        
//                                        ratioSize = image.size
            let aspectratio = CGSize(width: imageModel.imageWidth, height: imageModel.imageHeight)
//           let siz =  getProportionalBGSize(currentRatio: ratioSize, oldSize: ratioSize )
            let cropPoints = CGRect(x: 0, y: 0, width: 1, height: 1)
            
            model.mContentType =  2.0
            // get image
            // new crop points with aspect crop
            // update crop points
            
            
//            await changedImageContent(model: &<#T##StickerChild#>, imageModel: <#T##ImageModel#>, isCropped: <#T##Bool#>)
   
            if  imageModel.sourceType == .SERVER{
                if let texture =  await textureCache.getTextureBGFromServer(imageName: imageModel.serverPath, id: imageModel.imageID,crop: cropPoints, flip: false,isCropped: isRatioChanged,size: info.size){
                   
                        model.setTexture(texture: texture)
                   
                    }
            
                
        }
        else if imageModel.sourceType == .DOCUMENT{
            
            if let texture =  await textureCache.getTextureBGFromServer(imageName: imageModel.localPath, id: info.id,crop: cropPoints, flip: false,isCropped: isRatioChanged,size: info._drawableSize){
               
                    model.setTexture(texture: texture)
               
                }
        }
            else {
//                if imageModel.lo
                if let lastPathComponent = imageModel.localPath.components(separatedBy: "/").last  {
                    
                    
                    if let texture =  await textureCache.getTextureBGFromBundle(imageName: lastPathComponent, id: info.id,crop: cropPoints, flip: false, isCropped: isRatioChanged, size: info.size){
                        
                        model.setTexture(texture: texture)
                        
                    }
                    
                }
                
            }
            
         
              
       
        }
        return model
    }
    
    func setBGSource(imageModel:AnyBGContent,info: TexturableChild,overlay:String = " ",isRatioChanged:Bool = false , tileCount : Float ) async->TexturableChild{
        let model = info
//        model.setMCropRect(cropRect: imageModel.cropRect)
        
        if let color = imageModel as? BGColor{
            model.mContentType =  0.0
            
            model.setColor(color: Conversion.setColorForMetalView(uicolor: color.bgColor))
        }
        
        else if  let gradient = imageModel as? GradientInfo{
            model.mContentType =  1.0
          
                model.setGradientInfo(gradientInfo: GradientInfoMetal(startColor: Conversion.setColorForMetalView(color: "\(gradient.StartColor)"), endColor: Conversion.setColorForMetalView(color: "\(gradient.EndColor)"), gradientType: Float(gradient.GradientType), radius: gradient.Radius, angleInDegree: gradient.AngleInDegrees))
        
        }
        
        else if let wallpaper = imageModel as? BGWallpaper{
            model.mContentType =  2.0
            let cropPoints = CGRect(x: 0, y: 0, width: 1, height: 1)
            if let texture =  await textureCache.getTextureBGFromBundle(imageName: wallpaper.content.localPath, id: info.id,crop: cropPoints, flip: false, size: info.size){
                
                model.setTexture(texture: texture)
                
            }
        }
        
        else if let bgTexture = imageModel as? BGTexture{
            
            model.mContentType = 8.0
            model.setTileCount(count: Float(tileCount) * 2)
            let cropPoints = CGRect(x: 0, y: 0, width: 1, height: 1)
            if let texture =  await textureCache.getTextureBGFromBundle(imageName: bgTexture.content.localPath, id: info.id,crop: cropPoints, flip: false, size: info.size){
                
                model.setTileTexture(texture: texture)
                
            }
            
          
            model.setGradientInfo(gradientInfo: GradientInfoMetal(startColor: SIMD3(1.0, 1.0, 1.0), endColor: SIMD3(1.0, 1.0, 1.0), gradientType: 1.0, radius: 1.0, angleInDegree: 1.0))
        
        }
        
        
       else if let image = imageModel as? BGUserImage{
            model.mContentType =  2.0
           
            let cropPoints = image.content.cropRect
           
            if image.content.sourceType == .DOCUMENT{
                if let texture =  await textureCache.getTextureBGFromServer(imageName: image.content.localPath, id: info.id,crop: cropPoints, flip: false,isCropped: isRatioChanged,size: info.size){
                    
                    model.setTexture(texture: texture)
                    
                }
            }else if image.content.sourceType == .SERVER{
                if let texture =  await textureCache.getTextureBGFromServer(imageName: image.content.serverPath, id: info.id,crop: cropPoints, flip: false,isCropped: isRatioChanged,size: info.size){
                    
                    model.setTexture(texture: texture)
                    
                }
            }else{
                if let texture =  await textureCache.getTextureBGFromBundle(imageName: image.content.localPath, id: info.id,crop: cropPoints, flip: false, size: info.size){
                    
                    model.setTexture(texture: texture)
                    
                }
            }
         
        }
        
        
        return model
    }
    
}
