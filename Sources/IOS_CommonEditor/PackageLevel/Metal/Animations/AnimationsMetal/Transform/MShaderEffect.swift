//
//  MShaderEffect.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import simd

struct ShaderEffect {
    var x: Float
    
    init(x: Float) {
        self.x = x
    }
    
    func clone() -> ShaderEffect {
        return ShaderEffect(x: x)
    }
    
    mutating func interpolate(with previous: ShaderEffect, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfInfo: AnimationRectInfo) {
        x = previous.x + (input * (x - previous.x))
    }
    
    static func identity() -> ShaderEffect {
        return ShaderEffect(x: 1)
    }
}
