//
//  DisplayView.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/10/23.
//

import Foundation
import UIKit




/* MARK: DisplayView
 
 - it holds both metal sceneview and UI UISceneView
 - it will be exposed to appLvel to add as UI
 - Rendering Part , UIView and TOuch Part , Scenegraph , swipe animations all will be inside this view belonging to different child view for functionality
 - this view will not hold any accountibility for any logic it just a orchestrator and parent for everything inside it.
 - every new functionality respective children will be responsible
 
 //////////////////////////////////////////----------------->>>>>>>>
 */

class CanvasView : UIView
{
    
    var mtkScene: IOSMetalView?// Metal view for rendering
    var touchView : SceneView?
    
    var renderingState : MetalEngine.RenderingState = .Edit {
        didSet {
            touchView?.isHidden = renderingState == .Edit ? false : true
        }
    }
    
    
    /// this will automatically call metal view and sceneView layout subview method
    func resizeCanvas(size:CGSize) {
        self.frame.size = size.plus(0)
        self.center = CGPoint(x: self.superview!.frame.width/2, y: self.superview!.frame.height/2)

    }
    
}
