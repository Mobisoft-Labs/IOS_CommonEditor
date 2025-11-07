//
//  MAnimation.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import Foundation

class MAnimationTemplate {
    var start: Float
    var duration: Float
    var counter: Float
    var anchorX: Float
    var anchorY: Float
    var loopEnabled: Bool
    var autoReverse: Bool
    var keyFrames: KeyFrameCollection
    
    init(start: Float, duration: Float, counter: Float, anchorX: Float, anchorY: Float, loopEnabled: Bool, autoReverse: Bool, keyFrames: KeyFrameCollection) {
        self.start = start
        self.duration = duration
        self.counter = counter
        self.anchorX = anchorX
        self.anchorY = anchorY
        self.loopEnabled = loopEnabled
        self.autoReverse = autoReverse
        self.keyFrames = keyFrames
    }
    
    
    
    deinit {
       // print("Animation Deleted Successfully")
    }
    
    func canRun(time: Float, count: Int) -> Bool {
        if count == 0 {
            return false
        }
        
        if time < start {
            return false
        }
        
        return true
    }
    
    func animate(animateResult: inout AnimationResult, time: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo) -> Bool {
        animateResult.setAnchor(x: anchorX, y: anchorY)
        let end = start + duration
        let count = keyFrames.getCount()
        
        if !canRun(time: time, count: count) {
            return false
        }
        
        let actualTime = (time - start) / duration
        var animationTime = actualTime
        
        if loopEnabled {
            animationTime = fmod(actualTime, counter)
        }
        
        if autoReverse {
            if animationTime > 1.0 {
                animationTime = 2.0 - animationTime
            }
        }
        
        if animationTime > end {
            animationTime = 1.0
        }
        
        let idleFrameParams = animateResult.getParameters().clone()
        var lastFrameParams = idleFrameParams
        var lastKeyTime: Float = 0.0
        
        for i in 0..<count {
            var newValue = keyFrames.collection[i].getKeyValue().clone()
            let result = keyFrames.collection[i].calculate(lastValue: lastFrameParams, lastKeyTime: lastKeyTime, newValue: &newValue, time: animationTime, root: root, parent: parent, selfRect: selfRect)
            
            if result {
                animateResult.setResult(result: true)
                animateResult.setKeyFrameParameters(parameters: newValue)
            }
            
            lastFrameParams = keyFrames.collection[i].getKeyValue()
            lastKeyTime = keyFrames.collection[i].getKeyTime()
        }
        
      
        
        return true
    }
}
