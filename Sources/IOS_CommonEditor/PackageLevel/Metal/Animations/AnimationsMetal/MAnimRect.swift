//
//  MAnimRect.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import CoreGraphics

struct AnimationRectInfo {
    var x: Float
    var y: Float
    var width: Float
    var height: Float

    init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    func calculateCenterX(_ percent: Float) -> Float {
        return (x - (width / 2)) + (width * percent)
    }

    func calculateCenterY(_ percent: Float) -> Float {
        return (y - (height / 2)) + (height * percent)
    }
}
