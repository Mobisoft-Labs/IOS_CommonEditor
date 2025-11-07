//
//  AnimateAlpha.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
struct Alpha {
    var x: Float

    init(_ x: Float) {
        self.x = x
    }

    mutating func interpolate(with previous: Alpha, input: Float, root: AnimationRectInfo, parent: AnimationRectInfo, selfRect: AnimationRectInfo)  {
        let interpolatedX = previous.x + (input * (x - previous.x))
            x = interpolatedX
    }

    static func identity() -> Alpha {
        return Alpha(1)
    }
    
     func clone() -> Alpha {
        return Alpha(x)
    }
}


