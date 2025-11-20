//
//  SceneSupreme.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/04/24.
//

import Foundation
import UIKit

public class AISceneOfflineRenderer : SceneComposable {
    var sceneConfig: (any SceneConfiguration)?
    
    var logger: any PackageLogger
    
    var resourceProvider: any TextureResourceProvider
    
    var cancelPreparing: Bool = false

    var sceneProgress: ((Float) -> Void)?
    
    var updateThumb: Bool = false
    
    var textureCache : TextureCache//= TextureCache(maxSize: CGSize(width: 100, height: 100))
    
    var isUserSubscribed: Bool = true
    
    var metalThread: MetalThread = MetalThread(label: "")

    var commandQueue: MTLCommandQueue!
    
    var canCacheMchild: Bool = false
    
    func cacheChild(key: Int, value: MChild) { }
        
    var context : CIContext!
    
    public init(logger: PackageLogger, resourceProvider: TextureResourceProvider, sceneConfig: SceneConfiguration){
        self.logger = logger
        self.resourceProvider = resourceProvider
        self.sceneConfig = sceneConfig
        textureCache = TextureCache(maxSize: CGSize(width: 100, height: 100), resourceProvider: resourceProvider, logger: logger)
        context = CIContext()
//        ShaderLibrary.initialise()
//        MVertexDescriptorLibrary.initialise()
//        PipelineLibrary.initialise()
        commandQueue = MetalDefaults.GPUDevice.makeCommandQueue()!
    }
    
    private var personalizationValues: [String: String] = [:]

    public func setPersonalizationValues(_ values: [String: String]) {
        personalizationValues = values.reduce(into: [String: String]()) { partial, entry in
            partial[entry.key.uppercased()] = entry.value
        }
    }

//    func setMetaData(formDetails: CategoryMetaInfoPerCategory) {
//       //self.currentFormDetails = formDetails
//        var values: [String: String] = [:]
//        for field in formDetails.fields {
//            let key = field.templateValue?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//                ?? field.fieldDisplayName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//            switch key {
//            case "NAME":
//                values["NAME"] = field.userValue
//            case "SLOGAN":
//                values["SLOGAN"] = field.userValue
//            default:
//                continue
//            }
//        }
//        setPersonalizationValues(values)
//    }
    
    public func prepareAndRenderForThumbnail(templateInfo:TemplateInfo) async -> Result<UIImage,SceneOfflineRenderError> {
        
      
            
            //        return await withCheckedContinuation { continuation in
            if Task.isCancelled {
                logger.printLog("Cancelled")
                return .failure(.CouldNotCreateMPage)
            }
            var currentScene = MScene(templateInfo: templateInfo)
            guard let firstPage = templateInfo.pageInfo.first else {
                logger.printLog("No Page To Render")
                // continuation.resume(returning:.failure(.noPageAvailableIndB))
                return .failure(.noPageAvailableIndB)
            }
            if Task.isCancelled {
                logger.printLog("Cancelled")
                return .failure(.CouldNotCreateMPage)
            }
            guard let mpage = await createPage(firstPage) else {
                logger.printLog("Could Not Create MPage")
                //                continuation.resume(returning:.failure(.CouldNotCreateMPage))
                return .failure(.CouldNotCreateMPage)
            }
            
            currentScene.addChild(mpage)
            
            currentScene.context = MContext(drawableSize: templateInfo.ratioSize)
            currentScene.context.rootSize = templateInfo.ratioSize
            currentScene._currentTime = templateInfo.thumbTime
            
            
            guard let buffer = commandQueue.makeCommandBuffer() else {
                logger.printLog("Could Not Create MTLBuffer")
                //continuation.resume(returning:.failure(.MTLBufferCreationError))
                return .failure(.MTLBufferCreationError)
            }
            if Task.isCancelled {
                logger.printLog("Cancelled")
                return .failure(.CouldNotCreateMPage)
            }
            mpage.prepareMyChildern()
            mpage.renderMyChildren(commandBuffer: buffer)
            
            buffer.commit()
            buffer.waitUntilCompleted()
            
            let texture = mpage.myFBOTexture!
            guard  let image = Conversion.getUIImage(texture: texture) else {
                logger.printLog("Could Not Convert MTLtexture To Thumbnail")
                // continuation.resume(returning:.failure(.MTLTextureToImageError))
                return .failure(.MTLTextureToImageError)
            }
            
            
        
            
        logger.printLog("Texture:-> \(image.scale)")
        return .success(image)
//            continuation.resume(returning:.success(image))
            
     //   }
        
    }
    
    
    func createText(_ textInfo: TextInfo) -> TextChild {
        let myTextInfo = textInfo

        let wasUppercased = textInfo.text == textInfo.text.uppercased()
        if let replacement = replacementValue(for: textInfo) {
            textInfo.text = wasUppercased ? replacement.uppercased() : replacement
        }
        
        myTextInfo.width = textInfo.width+textInfo.internalWidthMargin
        var properties = textInfo.textProperty

        
        let textChild = TextChild(model: myTextInfo)
        textChild.setmFilterType(filterType: textInfo.filterType)
        
        
        textChild.setAdjustmentIntensity(brightnessIntensity: textInfo.brightnessIntensity, contrastIntensity: textInfo.contrastIntensity, highlightsIntensity: textInfo.highlightIntensity, shadowsIntensity: textInfo.shadowsIntensity, saturationIntensity: textInfo.saturationIntensity, vibranceIntensity: textInfo.vibranceIntensity, sharpnessIntensity: textInfo.sharpnessIntensity, warmthIntensity: textInfo.warmthIntensity, tintIntensity: textInfo.tintIntensity)
        
        if let image = textInfo.createImage(thumbUpdate : true, keepSameFont : false, text: textInfo.text, properties: properties, refSize: textInfo.baseFrame.size, maxWidth: textInfo.baseFrame.size.width, maxHeight: .infinity, contentScaleFactor: 1, logger: logger) {
            
            let texture = Conversion.loadTexture(image: image, flip: false )
            textChild.mContentType = 2
            textChild.setTexture(texture: texture!)
            
            textChild.setmOpacity(opacity: Conversion.setOpacityForMetalView(value: (textInfo.modelOpacity)))
            // textChild.set
        }
        
       
        
        return textChild
    }

    private func replacementValue(for textInfo: TextInfo) -> String? {
        let key = textInfo.textType.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !key.isEmpty else { return nil }

        if let value = personalizationValues[key], !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return value
        }

        return nil
    }
    
}
