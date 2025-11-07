//
//  MRotationAnim.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import simd



struct RotationX {
    var angle: Float
    var anchorX: Float
    var anchorY: Float
    var relativeTo: RelativeTo

    init(angle: Float, anchorX: Float, anchorY: Float, relativeTo: RelativeTo) {
        self.angle = angle
        self.anchorX = anchorX
        self.anchorY = anchorY
        self.relativeTo = relativeTo
    }

    var angleInRadians: Float {
        return angle * 22.0 / (7.0 * 180.0)
    }

    mutating func interpolate(with previous: RotationX, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, self: AnimationRectInfo) {
        angle = previous.angle + (input * (angle - previous.angle))
    }

    static func identity() -> RotationX {
        return RotationX(angle: 0.0, anchorX: 0.5, anchorY: 0.5, relativeTo: .selfRect)
    }

     func applyTransformation(self:  AnimationRectInfo, parent:  AnimationRectInfo, root:  AnimationRectInfo, transformation: inout simd_float4x4) -> Bool {
        var centerX: Float = 0.0
        var centerY: Float = 0.0

        switch relativeTo {
        case .selfRect:
            centerX = self.calculateCenterX(anchorX)
            centerY = self.calculateCenterY(anchorY)

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

        
        // TODO: ROTATION PENDING

//        let toOrigin = simd_float4x4(translation: SIMD3<Float>(-centerX, -centerY, 0.0))
//        let toCenter = simd_float4x4(translation: SIMD3<Float>(centerX, centerY, 0.0))
//        let rotation = simd_float4x4(rotationX: angleInRadians)
//
//        transformation = toOrigin * rotation * toCenter
         transformation.rotate(angle: angle, axis: X_AXIS)

        return true
    }

    private func calculateCenterX(anchorX: Float) -> Float {
        // Implement the calculation of centerX
        return 0.0
    }

    private func calculateCenterY(anchorY: Float) -> Float {
        // Implement the calculation of centerY
        return 0.0
    }
}
