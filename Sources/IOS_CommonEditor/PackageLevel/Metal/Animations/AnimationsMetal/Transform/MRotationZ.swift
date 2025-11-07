//
//  MRotationZ.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import simd

struct RotationZ {
    var angle: Float
    var anchorX: Float
    var anchorY: Float
    var relativeTo: RelativeTo
    
    init(angle: Float, anchorX: Float, anchorY: Float, relativeTo: RelativeTo) {
        self.angle = angle
        self.anchorX = anchorX
        self.anchorY =  anchorY
        self.relativeTo = relativeTo
    }
    
    func getAngle() -> Float {
        return angle
    }
    
    func getAnchorX() -> Float {
        return anchorX
    }
    
    func getAnchorY() -> Float {
        return anchorY
    }
    
    func getAngleInRadians() -> Float {
        return angle * 22 / (7 * 180)
    }
    
    func getRelativeTo() -> RelativeTo {
        return relativeTo
    }
    
    func clone() -> RotationZ {
        return RotationZ(angle: angle, anchorX: anchorX, anchorY: anchorY, relativeTo: relativeTo)
    }
    
    mutating func interpolate(with previous: RotationZ, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfInfo: AnimationRectInfo) {
        angle = previous.angle + (input * (angle - previous.angle))
    }
    
    static func identity() -> RotationZ {
        return RotationZ(angle: 0, anchorX: 0.5, anchorY: 0.5, relativeTo: .selfRect)
    }
    
    func applyTransformation(startAngle: Float, selfInfo: AnimationRectInfo, parent: AnimationRectInfo, root: AnimationRectInfo, transformation: inout matrix_float4x4, logger: PackageLogger?) -> Bool {
        var centerX: Float
        var centerY: Float

        switch relativeTo {
        case .selfRect:
            centerX = selfInfo.calculateCenterX(anchorX)
            centerY = selfInfo.calculateCenterY(anchorY)
        case .parentRect:
            centerX = parent.calculateCenterX(anchorX)
            centerY = parent.calculateCenterY(anchorY)
        case .rootRect:
            centerX = root.calculateCenterX(anchorX)
            centerY = root.calculateCenterY(anchorY)
        case .pixel:
            centerX = anchorX
            centerY = anchorY
        }
        
        if anchorX == 0.5 {
            centerX = 0.0
        }
        
        if anchorY == 0.5 {
            centerY = 0.0
        }
        
//        centerY = -1 *  centerY
//        centerX = -1 *  centerX

//        let fromXRange = Float(0)...Float(selfInfo.width)
//        let toXRange = -Float(selfInfo.width)...Float(selfInfo.width)
//
//       var  centerX2 = Conversion.mapValue(Float(centerX), fromRange: fromXRange, toRange: toXRange)
//        
//        let fromYRange = Float(0)...Float(selfInfo.height)
//        let toYRange = -Float(selfInfo.height)...Float(selfInfo.height)
//       var  centerY2 = Conversion.mapValue(Float(selfInfo.height-centerY), fromRange: fromYRange, toRange: toYRange)

       

//        print("CenterX: ",centerX,"AX :", anchorX)
//        print("CenterY: ",centerY,"AY :", anchorY)

        // TODO: MRotationZ

//        let translationToOrigin = matrix_float4x4(translationX: -centerX, y: -centerY, z: 0)
//        let translationToCenter = matrix_float4x4(translationX: centerX, y: centerY, z: 0)
//        let rotation = matrix_float4x4(rotationAngle: getAngleInRadians() + startAngle, axis: SIMD3<Float>(0, 0, 1))
//
//        if anchorX == 0.5 && anchorY == 0.5 {
//            centerX = 0
//            centerY = 0
//        }
        
        transformation.translate(direction: float3(-centerX,-centerY,0))
        logger?.printLog("ROT: \(Float(deg2rad(Double(angle))))")
        transformation.rotate(angle: -1 * Float(deg2rad(Double(angle))), axis: Z_AXIS)
        transformation.translate(direction: float3(centerX,centerY,0))


        return true
    }
}
