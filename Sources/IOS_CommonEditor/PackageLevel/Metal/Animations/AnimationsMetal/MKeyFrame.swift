//
//  MKeyFrame.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import Foundation

class KeyFrame {
    private var keyTime: Float
    private var keyValue: KeyFrameParameters
    private var easingFunction: MEasingFunction

    init(keyTime: Float, keyValue: KeyFrameParameters) {
        self.keyTime = keyTime
        self.keyValue = keyValue
        self.easingFunction = EFCubicBezier(x1: 0, y1: 0, x2: 1, y2: 1)
    }

    init(keyTime: Float, keyValue: KeyFrameParameters, easingFunction: EFCubicBezier) {
        self.keyTime = keyTime
        self.keyValue = keyValue
        self.easingFunction = easingFunction
    }

//    deinit {
//        print("KeyFrame Deleted")
//    }

    func getKeyTime() -> Float {
        return keyTime
    }

    func getKeyValue() -> KeyFrameParameters {
        return keyValue
    }

    func getEasingFunction() -> MEasingFunction {
        return easingFunction
    }

    func calculate(lastFrame: KeyFrame?, newValue: KeyFrameParameters, time: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo) -> Bool {
        guard let lastFrame = lastFrame, time >= lastFrame.getKeyTime() else {
            return false
        }

        let duration = keyTime - lastFrame.getKeyTime()
        let actualTime = time - lastFrame.getKeyTime()
        var kTime: Float = time
        if time > getKeyTime() || duration == 0 {
            kTime = 1
        } else {
            let newTime = actualTime / duration
            kTime = newTime
        }
        let newTime = easingFunction.interpolate(kTime)
        let didSucceed = keyValue.interpolate(previousValue: lastFrame.getKeyValue(), outValue: newValue, input: newTime, root: root, parent: parent, self: selfRect)
        return didSucceed
    }

    func calculate(lastValue: KeyFrameParameters, lastKeyTime: Float, newValue: inout KeyFrameParameters, time: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo) -> Bool {
        guard time >= lastKeyTime else {
            return false
        }

        let duration = keyTime - lastKeyTime
        let actualTime = time - lastKeyTime
        var kTime: Float = time
        if time > getKeyTime() || duration == 0 {
            kTime = 1
        } else {
            let newTime = actualTime / duration
            kTime = newTime
        }
        let newTime = easingFunction.interpolate(kTime)
        let didSucceed = keyValue.interpolate(previousValue: lastValue, outValue: newValue, input: newTime, root: root, parent: parent, self: selfRect)
        return didSucceed
    }
}
