//
//  MPageInfo.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import MetalKit

class MScene  : MParent {
       
    var _animCurrentTime : Float = 0 {
        didSet {
            logger?.printLog("animCTime: \(_animCurrentTime)")
        }
    }
    
   
    override var renderingMode: MetalEngine.RenderingState {
        return _renderingMode
    }
    
    override var currentTime: Float {
       return _currentTime
    }
    
    override var shouldOverrideCurrentTime: Bool{
        return _shouldOverrideCurrentTime
    }
    
    override var canRenderWatermark: Bool {
        return  _canRenderWatermark
    }
    
    
    override var animCurrentTime: Float {
       return _animCurrentTime
    }
    override var context: MContext {
        didSet {
//            if !doneOnce {
                self.setmSize(width: context.rootSize.width, height: context.rootSize.height)
                self.setmCenter(centerX: context.rootSize.width/2, centerY: context.rootSize.height/2)
//                doneOnce = true
//            }
            super.context = context
        }
    }
    
    
//    var doneOnce : Bool = false
    
    init(templateInfo:TemplateInfo) {
    
        let parentInfo = ParentInfo()
        parentInfo.modelId = templateInfo.templateId
        parentInfo.baseFrame.size = templateInfo.ratioSize
        parentInfo.width = Float(templateInfo.ratioSize.width)
        parentInfo.height = Float(templateInfo.ratioSize.height)
        parentInfo.baseTimeline.duration = templateInfo.totalDuration
        super.init(model: parentInfo)
        self.name = "MScene"
        switchTo(type: .SceneRender)
        //self.setModel(model: pageInfo)
        
       // self.size = templateInfo.ratioSize
       // self.center = CGPoint(x: templateInfo.ratioSize.width/2, y: templateInfo.ratioSize.width/2)
        
    }
    
   
    func renderPages(commandbuffer:MTLCommandBuffer) {

        onPrepareMyPages()
        onRenderPages(commandBuffer: commandbuffer)
    }
    
    private func onPrepareMyPages() {
       prepareMyChildern()
    }
    
   private func onRenderPages(commandBuffer: MTLCommandBuffer) {
        
     renderMyChildren(commandBuffer: commandBuffer)
    }
    
    
    func renderOn(metalDisplay:MTLRenderCommandEncoder) {
        renderOnParent(parentEncoder: metalDisplay)
    }
    
    
}



