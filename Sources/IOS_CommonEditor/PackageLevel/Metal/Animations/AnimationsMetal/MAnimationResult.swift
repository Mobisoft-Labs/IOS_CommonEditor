//
//  MAnimationResult.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import simd

class AnimationResult {
    private var parameters: KeyFrameParameters
    private var result: Bool
    private var anchorX: Float
    private var anchorY: Float

    init(result: Bool) {
        self.parameters = KeyFrameParameters.identity()
        self.result = result
        self.anchorX = 0
        self.anchorY = 0
    }

    deinit {
        parameters = KeyFrameParameters.identity()
    }

    func getResult() -> Bool {
        return result
    }

    func getParameters() -> KeyFrameParameters {
        return parameters
    }

    func getAnchorX() -> Float {
        return anchorX
    }

    func getAnchorY() -> Float {
        return anchorY
    }

    func setResult(result: Bool) {
        self.result = result
    }

    func setKeyFrameParameters(parameters: KeyFrameParameters) {
        self.parameters = parameters
    }

    func setAnchor(x: Float, y: Float) {
        anchorX = x
        anchorY = y
    }
}
