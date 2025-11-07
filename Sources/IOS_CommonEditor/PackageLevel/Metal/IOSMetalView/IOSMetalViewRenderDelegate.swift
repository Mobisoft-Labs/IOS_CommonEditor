//
//  IOSMetalViewDelegate.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 19/01/23.
//

import Foundation
import Metal

protocol IOSMetalViewRenderDelegate : AnyObject {
    func IOSMetalView(_ metalView : IOSMetalView , didChangeSize: CGSize)
    func draw(in metalView: IOSMetalView,currentTime:Float, needThumbnail: Bool,completion: ((MTLTexture?) -> ())?)

}
protocol IOSMetalViewFeedbackDelegate : AnyObject {
    func didStopRendering()
    func didSuccessSaving()
    func didCancelledSaving()
    func didFailRendering()
    func showCurrentTime(currentTime:Float)
   func showGradientradial(currentTime: Float) 
    func showSavingProgress(percentage:Float)
}
