//
//  MRotationY.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import simd

struct RotationY {
    private var angle: Float
    private var anchorX: Float
    private var anchorY: Float
    private var relativeTo: RelativeTo
    
    init(_ angle: Float, _ anchorX: Float, _ anchorY: Float, _ relativeTo: RelativeTo) {
        self.angle = angle
        self.anchorX = anchorX
        self.anchorY = anchorY
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
    
    func getAngle_In_Radians() -> Float {
        return angle * (22/(7*180))
    }
    
    func getRelative_to() -> RelativeTo {
        return relativeTo
    }
    
    func clone() -> RotationY {
        return RotationY(angle, anchorX, anchorY, relativeTo)
    }
    
    mutating func interpolate(with previous: RotationY,  input: Float,  root: AnimationRectInfo,  parent: AnimationRectInfo,  selfRect: AnimationRectInfo) {
        angle = previous.getAngle() + (input * (angle - previous.getAngle()))
    }
    
    static func identity() -> RotationY {
        return RotationY(0, 0.5, 0.5, .selfRect)
    }
    
    func applyTransformation(_ selfRect: AnimationRectInfo, _ parent: AnimationRectInfo, _ root: AnimationRectInfo, _ transformation: inout matrix_float4x4) -> Bool {
        var centerX: Float = 0.0
        var centerY: Float = 0.0
        
        switch relativeTo {
        case .selfRect:
            centerX = selfRect.calculateCenterX(anchorX)
            centerY = selfRect.calculateCenterY(anchorY)
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
        
        // TODO: ROTATION Y Oending

        
//        var translation = matrix_identity_float4x4
//        translation.columns.3.x = centerX
//        translation.columns.3.y = centerY
//
//        let rotation = simd_float4x4(SCNMatrix4MakeRotation(getAngle_In_Radians(), 0, 1, 0))
//
//        var inverseTranslation = matrix_identity_float4x4
//        inverseTranslation.columns.3.x = -centerX
//        inverseTranslation.columns.3.y = -centerY
//
//        transformation = matrix_multiply(translation, transformation)
//        transformation = matrix_multiply(rotation, transformation)
//        transformation = matrix_multiply(inverseTranslation, transformation)
        transformation.rotate(angle: angle, axis: Y_AXIS)

        return true
    }
}
