//
//  Renderable.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 20/01/23.
//

import MetalKit

protocol Renderable {

    var mStartTime:Float { get }
    var mDuration:Float { get set}
    var currentTime:Float {get}
    var canRender : Bool {get}
    var mIsSoftDeleted : Bool {get }
    var mIsVisible : Bool {get }
    var shouldOverrideCurrentTime: Bool { get }
   // init(pipelineInfo:MRenderPipelineInfo)
    
    var renderPipelineState : MTLRenderPipelineState! {get set}
//    var renderPipelineDescriptor : MTLRenderPipelineDescriptor! {get set}
//    var vertexDescriptor : MTLVertexDescriptor! {get}
    var geometry:MeshGeometry { get set }
    var logger: PackageLogger? { get }
    
//    func buildRenderPipeline(pipelineInfo:MRenderPipelineInfo)
    func preRenderCalculation()
    func renderOnParent(parentEncoder: MTLRenderCommandEncoder)
   // func renderOnParentLL(parentLLEncoder: MTLParallelRenderCommandEncoder,currentTime:Float, drawableSize:CGSize)
    func setVertexData(parentEncoder:MTLRenderCommandEncoder)
    func setFragmentData(parentEncoder:MTLRenderCommandEncoder)
    
}



extension Renderable {
    
    
    
    var canRender : Bool {
        if shouldOverrideCurrentTime{
            return true
        }else if (currentTime >= mStartTime && currentTime <= (mStartTime+mDuration))  && !mIsSoftDeleted && mIsVisible {
            if let parent = self as? MParent{
                if parent.allChild.count == 0{
//                    printLog("\((self as? MChild)?.identification) Dead")
                    return  false 
                }
            }
            
//            printLog("\((self as? MChild)?.identification) Alive")
           
            return true
        }
        
//        printLog("\((self as? MChild)?.identification) Dead")
        return false
    }
    
    func renderOnParent(parentEncoder: MTLRenderCommandEncoder) {
        guard let pipelineState = renderPipelineState else {
            logger?.logError("pipeline state is nil \(self)")
            return
        }
        if canRender {
            let offlineCommandEncoder = parentEncoder
            offlineCommandEncoder.label = "\(self) Offscreen Render Pass"
            
            offlineCommandEncoder.setRenderPipelineState(pipelineState)
            
            setVertexData(parentEncoder: parentEncoder)
            
            setFragmentData(parentEncoder: parentEncoder)
            
            offlineCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: geometry.indicesCount, indexType: .uint16, indexBuffer: geometry.indexBuffer, indexBufferOffset: 0)
           
            
        }
        
        // }
    }
    
    
    
   

    
}

/*
 VertexShader Buffer Indexing
 vertexbuffer = 0
 modalConstnat = 1
 cTime = 2
 */

/*
 smapler at sampler 0
 texture at texture 0
 FragmentShader Buffer Indexing
 resolution = buffer 0
 cTime = 1
 */


