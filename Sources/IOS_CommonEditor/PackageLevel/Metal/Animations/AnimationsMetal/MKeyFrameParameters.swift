//
//  MKeyFrameParameters.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation

class KeyFrameParameters {
    private var translation: Translation
    private var scale: ScaleXY
    private var rotationX: RotationX
    private var rotationY: RotationY
    private var rotationZ: RotationZ
    private var skew: Skew
    private var alpha: Alpha
    private var shaderEffect: ShaderEffect
    
    init(
        translation: Translation,
        scale: ScaleXY,
        rotationX: RotationX,
        rotationY: RotationY,
        rotationZ: RotationZ,
        skew: Skew,
        alpha: Alpha,
        shaderEffect: ShaderEffect
    ) {
        self.translation = translation
        self.scale = scale
        self.rotationX = rotationX
        self.rotationY = rotationY
        self.rotationZ = rotationZ
        self.skew = skew
        self.alpha = alpha
        self.shaderEffect = shaderEffect
    }
    
    func getTranslation() -> Translation {
        return translation
    }
    
    func getScale() -> ScaleXY {
        return scale
    }
    
    func getRotationX() -> RotationX {
        return rotationX
    }
    
    func getRotationY() -> RotationY {
        return rotationY
    }
    
    func getRotationZ() -> RotationZ {
        return rotationZ
    }
    
    func getSkew() -> Skew {
        return skew
    }
    
    func getAlpha() -> Alpha {
        return alpha
    }
    
    func getShaderEffect() -> ShaderEffect {
        return shaderEffect
    }
    
    func interpolate(previousValue: KeyFrameParameters, outValue: KeyFrameParameters, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, self: AnimationRectInfo) -> Bool {
        outValue.translation.interpolate(with: previousValue.translation, input: input, root: root, parent: parent, selfRect: self)
        outValue.scale.interpolate(with: previousValue.scale, input: input, root: root, parent: parent, selfInfo: self)
        outValue.rotationX.interpolate(with: previousValue.rotationX, input: input, root: root, parent: parent, self: self)
        outValue.rotationY.interpolate(with: previousValue.rotationY, input: input, root: root, parent: parent, selfRect: self)
        outValue.rotationZ.interpolate(with: previousValue.rotationZ, input: input, root: root, parent: parent, selfInfo: self)
        outValue.skew.interpolate(with: previousValue.skew, input: input, root: root, parent: parent, self: self)
        outValue.alpha.interpolate(with: previousValue.alpha, input: input, root: root, parent: parent, selfRect: self)
        outValue.shaderEffect.interpolate(with: previousValue.shaderEffect, input: input, root: root, parent: parent, selfInfo: self)
        return true
    }
    
    func clone() -> KeyFrameParameters {
        return KeyFrameParameters(
            translation: translation.clone(),
            scale: scale.clone(),
            rotationX: rotationX,
            rotationY: rotationY.clone(),
            rotationZ: rotationZ.clone(),
            skew: skew,
            alpha: alpha.clone(),
            shaderEffect: shaderEffect.clone()
        )
    }
    
    static func identity() -> KeyFrameParameters {
        return KeyFrameParameters(
            translation: Translation.identity(),
            scale: ScaleXY.identity(),
            rotationX: RotationX.identity(),
            rotationY: RotationY.identity(),
            rotationZ: RotationZ.identity(),
            skew: Skew.identity(),
            alpha: Alpha.identity(),
            shaderEffect: ShaderEffect.identity()
        )
    }
}
