//
//  Type.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 18/01/23.
//

import MetalKit
import UIKit




struct Vertex : Sizable{
    var position: float3
    var color: float4
    var textCoords: float2
}

struct ModalConstant : Sizable  {
    var modalMatrix:matrix_float4x4 = matrix_identity_float4x4
    var parentProjectionMatrix:matrix_float4x4 = matrix_identity_float4x4
    var animatedMatrix :matrix_float4x4 = matrix_identity_float4x4
    var rotationMatrix :matrix_float4x4 = matrix_identity_float4x4

}




protocol Sizable  {}
extension Sizable  {
    // return self size
    static var size1 : Int {
        return MemoryLayout<Self>.size
    }
    
    static var stride : Int {
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count : Int) -> Int {
        return size1 * count
    }
    
    static func stride(_ count: Int) -> Int {
        return stride * count
    }
}

//
//struct GradientInfo:Sizable{
//    var firstColor:float4 = float4(0.0)
//    var secondColor:float4 = float4(0.0)
//    var gradientType:Float = 0.0
//    var radius:Float = 0.0
//}

extension float4 : Sizable {}
extension float3 : Sizable {}
extension float2 : Sizable {}
extension UInt16 : Sizable {}
extension Float : Sizable {}
//extension ContentInfo : Sizable {}



protocol BindableToEncoder {
    func bind(_ enconder : MTLRenderCommandEncoder)
}
