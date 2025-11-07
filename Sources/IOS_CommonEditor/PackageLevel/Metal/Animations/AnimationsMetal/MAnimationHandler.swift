//
//  MAnimationManager.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//


import Foundation

class AnimationHandler {
    /*
     will create all three MAnimation for a component
     
     */
    
    init() {
       
        
    }
  
    
//    var isCleaned: Bool
    var inAnimation: MAnimationTemplate?
    var outAnimation: MAnimationTemplate? 
    var loopAnimation: MAnimationTemplate?
//
    var logger: PackageLogger?
    
    deinit {
        // Destructor code goes here (if needed)
    }
    
    func setPackageLogger(logger: PackageLogger){
        self.logger = logger
    }
    
    func set_In_Animation(animationInfo:AnimTemplateInfo) {
        
        let inTemplate = animationInfo //animationInfo.getInAnimTemplateModel()
      
        let keyFrameCollection_In = createKeyFrameCollection(inTemplate)
        let anim = MAnimationTemplate(start: 0 , duration: Float(inTemplate.duration), counter: 1.0, anchorX: 0.5, anchorY: 0.5, loopEnabled: (inTemplate.isLoopEnabled != 0), autoReverse: (inTemplate.isAutoReverse != 0), keyFrames: keyFrameCollection_In)
        inAnimation = anim

    }
    
    func set_Out_Animation(animationInfo:AnimTemplateInfo) {
        
        let inTemplate = animationInfo //animationInfo.getOutAnimTemplateModel()
        let keyFrameCollection_In = createKeyFrameCollection(inTemplate)
        let anim = MAnimationTemplate(start: 0 , duration: Float(inTemplate.duration), counter: 1.0, anchorX: 0.5, anchorY: 0.5, loopEnabled: (inTemplate.isLoopEnabled != 0), autoReverse: (inTemplate.isAutoReverse != 0), keyFrames: keyFrameCollection_In)
        outAnimation = anim

    }
    
    func set_Loop_Animation(animationInfo:AnimTemplateInfo) {
        
        let inTemplate = animationInfo //animationInfo.getLoopAnimTemplateModel()
        let keyFrameCollection_In = createKeyFrameCollection(inTemplate)
        let anim = MAnimationTemplate(start: 0 , duration: Float(inTemplate.duration), counter: 1.0, anchorX: 0.5, anchorY: 0.5, loopEnabled: (inTemplate.isLoopEnabled != 0), autoReverse: (inTemplate.isAutoReverse != 0), keyFrames: keyFrameCollection_In)
        loopAnimation = anim
    }
    
//    func setAnimationSwift(animationInfo:AnimationInfo) -> Bool {
//        var didSucceed = false
//        switch animatonTemplate.type {
//        case "IN":
//            inAnimation = set_In_Animation(animationInfo: anim)
//        case "OUT":
//            outAnimation = setAnimationParameters(animationTemplateId: animationTemplateId, animDuration: animDuration, loopEnabled: loopEnabled, autoReverse: autoReverse, keyFrames: keyFrames)
//        case "LOOP":
//            loopAnimation = setAnimationParameters(animationTemplateId: animationTemplateId, animDuration: animDuration, loopEnabled: loopEnabled, autoReverse: autoReverse, keyFrames: keyFrames)
//        default:
//            break
//        }
//        return didSucceed
//    }
    
    private func createKeyFrameCollection(_ animTemplate : AnimTemplateInfo ) -> KeyFrameCollection
    {
        var keyFrameCollection = KeyFrameCollection()

        for keyFrameInfo in animTemplate.keyFramesInfos {
            let components = keyFrameInfo.easingFunction.split(separator: ":")
            
            let easingFunction = EFCubicBezier(
                x1: Float(components[0])!,
                y1: Float(components[1])!,
                x2: Float(components[2])!,
                y2:  Float(components[3])!
            )
            
            let translation = Translation(
                x: keyFrameInfo.translationX,
                y: keyFrameInfo.translationY,
                relativeTo: RelativeTo(rawValue: keyFrameInfo.translationRelativeTo)!
            )
            
            let rotationX = RotationX(
                angle: keyFrameInfo.rotationX,
                anchorX: keyFrameInfo.rotationXAnchorX,
                anchorY: keyFrameInfo.rotationXAnchorY,
                relativeTo: RelativeTo(rawValue: keyFrameInfo.rotationXAnchorRelativeTo)!
            )
            
            let rotationY = RotationY(
                keyFrameInfo.rotationY,
                keyFrameInfo.rotationYAnchorX,
                keyFrameInfo.rotationYAnchorY,
                RelativeTo(rawValue: keyFrameInfo.rotationYAnchorRelativeTo)!
            )
            
            let rotationZ = RotationZ(
                angle: keyFrameInfo.rotationZ,
                anchorX: keyFrameInfo.rotationZAnchorX,
                anchorY: keyFrameInfo.rotationZAnchorY,
                relativeTo: RelativeTo(rawValue: keyFrameInfo.rotationZAnchorRelativeTo)!
            )
            
            let scale = ScaleXY(
                x: keyFrameInfo.scaleX,
                y: keyFrameInfo.scaleY,
                anchorX: keyFrameInfo.scaleAnchorX,
                anchorY: keyFrameInfo.scaleAnchorY,
                relativeTo: RelativeTo(rawValue: keyFrameInfo.scaleAnchorRelativeTo)!
            )
            
            let skew = Skew(
                x: keyFrameInfo.skewX,
                y: keyFrameInfo.skewY,
                anchorX: keyFrameInfo.skewAnchorX,
                anchorY: keyFrameInfo.skewAnchorY,
                relativeTo: RelativeTo(rawValue: keyFrameInfo.skewAnchorRelativeTo)!
            )
            
            let alpha = Alpha(keyFrameInfo.opacity)
            let shaderEffect = ShaderEffect(x: keyFrameInfo.effectProgress)
            
            let kFrame = KeyFrame(
                keyTime: keyFrameInfo.keytime/100,
                keyValue: KeyFrameParameters(
                    translation: translation,
                    scale: scale,
                    rotationX: rotationX,
                    rotationY: rotationY,
                    rotationZ: rotationZ,
                    skew: skew,
                    alpha: alpha,
                    shaderEffect: shaderEffect
                ),
                easingFunction: easingFunction
            )
            
            keyFrameCollection.add(component: kFrame)
        }
        return keyFrameCollection
       
    }
    
    
    
  
    
    
    func animate(result: inout AnimationResult, time: Float, duration: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfInfo: AnimationRectInfo) -> Bool {
        var remainingDuration = duration
        var runningTime = time
        var didSucceed = false

        
        // Check if there is an in_animation and animate it
        if let inAnimation = inAnimation {
            didSucceed = inAnimation.animate(animateResult: &result, time: runningTime, root: root, parent: parent, selfRect: selfInfo)
            runningTime -= inAnimation.duration
            remainingDuration = duration - inAnimation.duration
        }

        // Check if there is a loop_animation and animate it
        if runningTime >= 0 {
            let outDuration = outAnimation?.duration ?? 0.0
            let loopDuration = remainingDuration - outDuration

            if loopDuration > 0, let loopAnimation = loopAnimation {
                didSucceed = loopAnimation.animate(animateResult: &result, time: runningTime, root: root, parent: parent, selfRect: selfInfo)
                runningTime -= loopDuration
            }
        }

        // Check if there is an out_animation and animate it
        if runningTime >= 0, let outAnimation = outAnimation {
            #if PrintOutput
            print("time: \(time), outtime: \(runningTime)")
            #endif

            didSucceed = outAnimation.animate(animateResult: &result, time: runningTime, root: root, parent: parent, selfRect: selfInfo)
        }
        
        logger?.printLog("runnigTime: \(runningTime)")

        return didSucceed
    }

}
