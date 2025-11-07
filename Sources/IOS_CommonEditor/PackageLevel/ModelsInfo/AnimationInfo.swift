//
//  AnimationInfo.swift
//  MetalEngine
//
//  Created by HKBeast on 25/07/23.
//

import Foundation
struct KeyFrameInfo : AnimKeyframeModelProtocol, Hashable {
    var keyframeId: Int = 0
    
    var animationTemplateId: Int = 0
    
    var keytime: Float = 0
    
    var translationX: Float = 0
    
    var translationY: Float = 0
    
    var scaleX: Float = 0
    
    var scaleY: Float = 0
    
    var rotationX: Float = 0
    
    var rotationY: Float = 0
    
    var rotationZ: Float = 0
    
    var skewX: Float = 0
    
    var skewY: Float = 0
    
    var opacity: Float = 1
    
    var effectProgress: Float = 0
    
    var easingFunction: String = ""
    
    var translationRelativeTo: Int = 0
    
    var scaleAnchorX: Float = 0
    
    var scaleAnchorY: Float = 0
    
    var scaleAnchorRelativeTo: Int = 0
    
    var rotationXAnchorX: Float = 0
    
    var rotationXAnchorY: Float = 0
    
    var rotationXAnchorRelativeTo: Int = 0
    
    var rotationYAnchorX: Float = 0
    
    var rotationYAnchorY: Float = 0
    
    var rotationYAnchorRelativeTo: Int = 0
    
    var rotationZAnchorX: Float = 0
    
    var rotationZAnchorY: Float = 0
    
    var rotationZAnchorRelativeTo: Int = 0
    
    var skewAnchorX: Float = 0
    
    var skewAnchorY: Float = 0
    
    var skewAnchorRelativeTo: Int = 0
     
    var shader: String = ""
    
    
}
public struct AnimTemplateInfo:AnimationTemplateProtocol,AnimationCategoriesModelProtocol, Hashable{
    
    //Animation category
    public var animationCategoriesId: Int = 1
    public var animationName: String = "none"
    public var animationIcon: String = "None.png"
    public var order: Int = 0
    public var enabled: Int = 0
    

    
    //animation Template
    public var animationTemplateId: Int = 1
    public var name: String = ""
    public var type: String = ""
  
    public var category: Int = 1
    public var duration: Float = 1
    public var isLoopEnabled: Int = 0
    public var isAutoReverse: Int = 0
    public var icon: String = "None.png"
    
    
  var keyFramesInfos = [KeyFrameInfo]()
    
   
    mutating func setAnimationTemplate(animationTemplate: DBAnimationTemplateModel) {
        animationTemplateId = animationTemplate.animationTemplateId
        name = animationTemplate.name
        type = animationTemplate.type
        category = animationTemplate.category
        duration = animationTemplate.duration
        isLoopEnabled = animationTemplate.isLoopEnabled
        isAutoReverse = animationTemplate.isAutoReverse
        icon = animationTemplate.icon
      }

      mutating func setAnimationCategory(animationCategory: DBAnimationCategoriesModel) {
          animationCategoriesId = animationCategory.animationCategoriesId
          animationName = animationCategory.animationName
          animationIcon = animationCategory.animationIcon
          order = animationCategory.order
          enabled = animationCategory.enabled
      }
    
    // Method to set properties from the provided AnimKeyframeModel
     mutating func setKeyFrame(keyFrames: [DBAnimKeyframeModel]) {
         for keyFrame in keyFrames {
             
             var keyFrameInfo = KeyFrameInfo()
             keyFrameInfo.keyframeId = keyFrame.keyframeId
             keyFrameInfo.animationTemplateId = keyFrame.animationTemplateId
             keyFrameInfo.keytime = keyFrame.keytime
             keyFrameInfo.translationX = keyFrame.translationX
             keyFrameInfo.translationY = keyFrame.translationY
             keyFrameInfo.scaleX = keyFrame.scaleX
             keyFrameInfo.scaleY = keyFrame.scaleY
             keyFrameInfo.rotationX = keyFrame.rotationX
             keyFrameInfo.rotationY = keyFrame.rotationY
             keyFrameInfo.rotationZ = keyFrame.rotationZ
             keyFrameInfo.skewX = keyFrame.skewX
             keyFrameInfo.skewY = keyFrame.skewY
             keyFrameInfo.opacity = keyFrame.opacity
             keyFrameInfo.effectProgress = keyFrame.effectProgress
             keyFrameInfo.easingFunction = keyFrame.easingFunction
             keyFrameInfo.translationRelativeTo = keyFrame.translationRelativeTo
             keyFrameInfo.scaleAnchorX = keyFrame.scaleAnchorX
             keyFrameInfo.scaleAnchorY = keyFrame.scaleAnchorY
             keyFrameInfo.scaleAnchorRelativeTo = keyFrame.scaleAnchorRelativeTo
             keyFrameInfo.rotationXAnchorX = keyFrame.rotationXAnchorX
             keyFrameInfo.rotationXAnchorY = keyFrame.rotationXAnchorY
             keyFrameInfo.rotationXAnchorRelativeTo = keyFrame.rotationXAnchorRelativeTo
             keyFrameInfo.rotationYAnchorX = keyFrame.rotationYAnchorX
             keyFrameInfo.rotationYAnchorY = keyFrame.rotationYAnchorY
             keyFrameInfo.rotationYAnchorRelativeTo = keyFrame.rotationYAnchorRelativeTo
             keyFrameInfo.rotationZAnchorX = keyFrame.rotationZAnchorX
             keyFrameInfo.rotationZAnchorY = keyFrame.rotationZAnchorY
             keyFrameInfo.rotationZAnchorRelativeTo = keyFrame.rotationZAnchorRelativeTo
             keyFrameInfo.skewAnchorX = keyFrame.skewAnchorX
             keyFrameInfo.skewAnchorY = keyFrame.skewAnchorY
             keyFrameInfo.skewAnchorRelativeTo = keyFrame.skewAnchorRelativeTo
             keyFrameInfo.shader = keyFrame.shader
             
             keyFramesInfos.append(keyFrameInfo)
         }
     }
    


    func getAnimationTemplate() -> DBAnimationTemplateModel {
        return DBAnimationTemplateModel(
            animationTemplateId: animationTemplateId,
            name: name,
            type: type,
            category: category,
            duration: duration,
            isLoopEnabled: isLoopEnabled,
            isAutoReverse: isAutoReverse,
            icon: icon
        )
    }

    func getAnimationCategory() -> DBAnimationCategoriesModel {
        return DBAnimationCategoriesModel(
            animationCategoriesId: animationCategoriesId,
            animationName: animationName,
            animationIcon: animationIcon,
            order: order,
            enabled: enabled
        )
    }
    
//    // Method to get a copy of the current AnimKeyframeModel
//    func getKeyFrame() -> DBAnimKeyframeModel {
//        return DBAnimKeyframeModel
//        DBAnimKeyframeModel(
//            keyframeId: keyframeId,
//            animationTemplateId: animationTemplateId,
//            keytime: keytime,
//            translationX: translationX,
//            translationY: translationY,
//            scaleX: scaleX,
//            scaleY: scaleY,
//            rotationX: rotationX,
//            rotationY: rotationY,
//            rotationZ: rotationZ,
//            skewX: skewX,
//            skewY: skewY,
//            opacity: opacity,
//            effectProgress: effectProgress,
//            easingFunction: easingFunction,
//            translationRelativeTo: translationRelativeTo,
//            scaleAnchorX: scaleAnchorX,
//            scaleAnchorY: scaleAnchorY,
//            scaleAnchorRelativeTo: scaleAnchorRelativeTo,
//            rotationXAnchorX: rotationXAnchorX,
//            rotationXAnchorY: rotationXAnchorY,
//            rotationXAnchorRelativeTo: rotationXAnchorRelativeTo,
//            rotationYAnchorX: rotationYAnchorX,
//            rotationYAnchorY: rotationYAnchorY,
//            rotationYAnchorRelativeTo: rotationYAnchorRelativeTo,
//            rotationZAnchorX: rotationZAnchorX,
//            rotationZAnchorY: rotationZAnchorY,
//            rotationZAnchorRelativeTo: rotationZAnchorRelativeTo,
//            skewAnchorX: skewAnchorX,
//            skewAnchorY: skewAnchorY,
//            skewAnchorRelativeTo: skewAnchorRelativeTo,
//            shader: shader
//        )
//    }
}



////Animation Model




struct AnimationInfo:AnimationModelProtocol{
    var animationId: Int = 0
     var modelId: Int = 0 // Exception
     var inAnimationTemplateId: Int = 1
     var inAnimationDuration: Float = 1.0
    var animTemplateInfoForIN:AnimTemplateInfo
     var loopAnimationTemplateId: Int = 1
      var loopAnimationDuration: Float = 1.0
    var animTemplateInfoForLOOP:AnimTemplateInfo
      var outAnimationTemplateId: Int = 1
     var  outAnimationDuration: Float = 1.0
    var animTemplateInfoForOUT:AnimTemplateInfo
    
    mutating func setAnimationModel(animationModel: DBAnimationModel) {
          animationId = animationModel.animationId
          modelId = animationModel.modelId
          inAnimationTemplateId = animationModel.inAnimationTemplateId
          inAnimationDuration = animationModel.inAnimationDuration
          loopAnimationTemplateId = animationModel.loopAnimationTemplateId
          loopAnimationDuration = animationModel.loopAnimationDuration
          outAnimationTemplateId = animationModel.outAnimationTemplateId
          outAnimationDuration = animationModel.outAnimationDuration
      }
    
    mutating func setInAnimTemplate(animTemplateInfo:AnimTemplateInfo){
        animTemplateInfoForIN = animTemplateInfo
    }
    mutating func setLoopAnimTemplate(animTemplateInfo:AnimTemplateInfo){
        animTemplateInfoForLOOP = animTemplateInfo
    }
    mutating func setOutAnimTemplate(animTemplateInfo:AnimTemplateInfo){
        animTemplateInfoForOUT = animTemplateInfo
    }
    // Get methods for the properties set by the respective set methods
    func getAnimationModel() -> DBAnimationModel {
        return DBAnimationModel(
            animationId: animationId,
            modelId: modelId,
            inAnimationTemplateId: inAnimationTemplateId,
            inAnimationDuration: inAnimationDuration,
            loopAnimationTemplateId: loopAnimationTemplateId,
            loopAnimationDuration: loopAnimationDuration,
            outAnimationTemplateId: outAnimationTemplateId,
            outAnimationDuration: outAnimationDuration
        )
    }
    func getInAnimTemplateModel()-> AnimTemplateInfo{
        return animTemplateInfoForIN
    }
    func getLoopAnimTemplateModel()-> AnimTemplateInfo{
        return animTemplateInfoForLOOP
    }
    func getOutAnimTemplateModel()-> AnimTemplateInfo{
        return animTemplateInfoForOUT
    }
}
