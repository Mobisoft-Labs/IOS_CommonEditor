//
//  MScaleXY.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import simd

struct ScaleXY {
    var x: Float
    var y: Float
    var anchorX: Float
    var anchorY: Float
    var relativeTo: RelativeTo
    
    init(x: Float, y: Float, anchorX: Float, anchorY: Float, relativeTo: RelativeTo) {
        self.x = x
        self.y = y
        self.anchorX = anchorX
        self.anchorY = anchorY
        self.relativeTo = relativeTo
    }
    
    func clone() -> ScaleXY {
        return ScaleXY(x: x, y: y, anchorX: anchorX, anchorY: anchorY, relativeTo: relativeTo)
    }
    
    mutating func interpolate(with previous: ScaleXY, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfInfo: AnimationRectInfo) {
        x = previous.x + (input * (x - previous.x))
        y = previous.y + (input * (y - previous.y))
    }
    
    static func identity() -> ScaleXY {
        return ScaleXY(x: 1, y: 1, anchorX: 0.5, anchorY: 0.5, relativeTo: .selfRect)
    }
    
    func applyTransformation(selfInfo: AnimationRectInfo, parent: AnimationRectInfo, root: AnimationRectInfo, transformation: inout matrix_float4x4, logger: PackageLogger?) -> Bool {
        var centerX: Float
        var centerY: Float

        switch relativeTo {
        case .selfRect:
            centerX = selfInfo.calculateCenterX( anchorX)
            centerY = selfInfo.calculateCenterY( anchorY)
        case .parentRect:
            centerX = parent.calculateCenterX( anchorX)
            centerY = parent.calculateCenterY( anchorY)
        case .rootRect:
            centerX = root.calculateCenterX( anchorX)
            centerY = root.calculateCenterY( anchorY)
        case .pixel:
            centerX = anchorX
            centerY = anchorY
        }

        // TODO: SCALE XY PENDING

     //   transformation.translate(direction: float3(-centerX,-centerY,0))
        logger?.printLog("SCALE: X: \(x) Y: \(y)")
        transformation.scale(x, y: y, z: 1.0)

        return true
    }
}


