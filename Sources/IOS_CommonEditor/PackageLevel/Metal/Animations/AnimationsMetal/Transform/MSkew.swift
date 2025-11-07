//
//  MSkew.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import simd

struct Skew {
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

   mutating func interpolate(with previous: Skew, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, self: AnimationRectInfo) {
        x = previous.x + (input * (x - previous.x))
        y = previous.y + (input * (y - previous.y))
    }

    static func identity() -> Skew {
        return Skew(x: 0, y: 0, anchorX: 0.5, anchorY: 0.5, relativeTo: .selfRect)
    }

      func applyTransformation(self: AnimationRectInfo, parent: AnimationRectInfo, root: AnimationRectInfo, transformation: inout matrix_float4x4) -> Bool {
        var centerX: Float
        var centerY: Float

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
        
        // TODO: SKEW TRANFORM PENDING

//        var skewTransform = GLKMatrix4Identity
//        skewTransform = GLKMatrix4Translate(skewTransform, Float(centerX), Float(centerY), 0)
//        skewTransform = GLKMatrix4Skew(skewTransform, Float(x), Float(y), 0, 0)
//        skewTransform = GLKMatrix4Translate(skewTransform, -Float(centerX), -Float(centerY), 0)
//        transformation = GLKMatrix4Multiply(transformation, skewTransform)

          if anchorX == 0.5 {
              centerX = 0.0
          }
          
          if anchorY == 0.5 {
              centerY = 0.0
          }
          
          
          let skewMatrix = matrix_float4x4([
              [1, x, 0, 0],
              [y, 1, 0, 0],
              [0, 0, 1, 0],
              [0, 0, 0, 1]
          ])
          
          //transformation.translate(direction: float3(centerX,centerY,0))
          transformation.skewTransform(angleInDegX: x, angleInDegY: y, pivotX: anchorX, pivotY: anchorY)
          //transformation.translate(direction: float3(-centerX,-centerY,0))


          
        return true
    }
}
