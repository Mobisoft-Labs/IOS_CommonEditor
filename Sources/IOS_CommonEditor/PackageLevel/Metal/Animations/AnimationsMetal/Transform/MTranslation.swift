//
//  MTranslation.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import simd
import Foundation

struct Translation {
    var x: Float
    var y: Float
    var relativeTo: RelativeTo
    var deltaX: Float = 0
    var deltaY: Float = 0



    init(x: Float, y: Float,  relativeTo: RelativeTo) {
        self.x = x
        self.y = y
        self.relativeTo = relativeTo
    }

    func clone() -> Translation {
        return self
    }

    mutating func interpolate(with previous: Translation, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo) {
        let prevX = previous.getActualX(root: root, parent: parent, selfRect: selfRect)
        let prevY = previous.getActualY(root: root, parent: parent, selfRect: selfRect)

        let currentX = getActualX(root: root, parent: parent, selfRect: selfRect)
        let currentY = getActualY(root: root, parent: parent, selfRect: selfRect)

        deltaX = prevX + (input * (currentX - prevX))
        deltaY = prevY + (input * (currentY - prevY))
    }

    static func identity() -> Translation {
        return Translation(x: 0, y: 0, relativeTo: .selfRect)
    }

    private func getActualX(root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo) -> Float {
        var dx: Float = 0

        switch relativeTo {
        case .selfRect:
            dx = x * selfRect.width
        case .parentRect:
            dx = x * parent.width
        case .rootRect:
            dx = x * root.width
        case .pixel:
            dx = x
        }

        return dx
    }

    private func getActualY(root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo) -> Float {
        var dy: Float = 0

        switch relativeTo {
        case .selfRect:
            dy = y * selfRect.height
        case .parentRect:
            dy = y * parent.height
        case .rootRect:
            dy = y * root.height
        case .pixel:
            dy = y
        }

        return dy
    }

    func applyTransformation(selfRect: AnimationRectInfo, parent: AnimationRectInfo, root: AnimationRectInfo, transformation: inout matrix_float4x4, xBase: Float, yBase: Float, logger: PackageLogger?) {
        let dx = deltaX
        let dy = deltaY
       // matrix_identity_float4x4.translate(xBase+deltaX, y: yBase+deltaY, z: 0)
         let pt = CGPoint(x: CGFloat(xBase+deltaX), y: -1 * CGFloat(yBase+deltaY))
        // let xy = get_metal_point(point: pt)
         let direction = float3(Float(pt.x),  Float(pt.y),  0)

        transformation.translate(direction: direction)
        logger?.printLog("TRANSLATION: XY \(direction)")

//        GLKMatrix4.skew
       // transformation = simd_mul(transformation, translatedMatrix)
    }
}
