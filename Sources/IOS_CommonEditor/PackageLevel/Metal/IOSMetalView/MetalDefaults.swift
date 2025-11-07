//
//  MetalDefaults.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 07/02/23.
//

import MetalKit


struct MetalDefaults {
    public static var GPUDevice = MTLCreateSystemDefaultDevice()!
    public static var DepthPixelFormat = MTLPixelFormat.invalid
    public static var StencilPixelFormat = MTLPixelFormat.invalid
    public static var MainPixelFormat = MTLPixelFormat.bgra8Unorm
    public static var ClearColor = MetalClearColors.White
    public static var WhiteColor = MetalClearColors.White
    public static var blackColor = MetalClearColors.black
    public static var TransparentColor = MetalClearColors.transparent

    public static var PreferredFrameRate = 60
   // public static var RenderTotalTime : Double = 50
   // public public static var StartingSceneType: SceneTypes = SceneTypes.Sandbox

}

public enum MetalClearColors{
        static let White: MTLClearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let Green: MTLClearColor = MTLClearColor(red: 0.22, green: 0.55, blue: 0.34, alpha: 0.3)
        static let Grey: MTLClearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    static let Black: MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    static let transparent: MTLClearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    static let black: MTLClearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

}
