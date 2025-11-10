//
//  PipelineLibrary.swift
//  VideoInvitation
//
//  Created by HKBeast on 24/08/23.
//

import Foundation
import Metal

enum PipelineLibraryType : Int {
    
    case ParentRender = 0
    case ColorRender = 1
    case ImageRender = 2
    case None = 3
    case SceneRender = 4
}

public class PipelineLibrary {
    @Injected var shaderLibrary : ShaderLibrary
    @Injected var mVertexDescriptorLibrary : MVertexDescriptorLibrary

    public  func cleanUp() {
        dict.removeAll()
    }
    private  var dict = [ Int : MTLRenderPipelineState]()
     let queue = DispatchQueue(label: "MyArrayQueue", attributes: .concurrent)
    
     func getPipelineState(type:PipelineLibraryType) -> MTLRenderPipelineState? {
        //        queue.async(flags: .barrier) {
        //            return PipelineLibrary.dict[type.rawValue]
        //        }
        var result: MTLRenderPipelineState?
        queue.sync {
            result = dict[type.rawValue]
        }
        return result
    }
    
    var logger: PackageLogger?
    
    public init() {
//        initialise()
    }
    
    public func initialise(logger: PackageLogger) {
       if dict.isEmpty{
           addColorRenderPipelineState()
           addImageRenderPipelineState()
           addParentRenderPipelineState()
           addSceneRenderPipelineState()
           setPackageLogger(logger: logger)
       }
    }
    
    func setPackageLogger(logger: PackageLogger){
        self.logger = logger
    }
    
     func addColorRenderPipelineState() {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
        renderPipelineDescriptor.vertexFunction = shaderLibrary.getVertexFunction(_byType:  .standard_Vertex_Shader)
        renderPipelineDescriptor.fragmentFunction = shaderLibrary.getFragment(_byType: .ColorFragmentShader)
        renderPipelineDescriptor.depthAttachmentPixelFormat = MetalDefaults.DepthPixelFormat
        renderPipelineDescriptor.vertexDescriptor = mVertexDescriptorLibrary.get(_vertexDescriptorBy: .PositionColorTexture)
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
        renderPipelineDescriptor.setblending()
        do {
            let renderPipelineState = try MetalDefaults.GPUDevice.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                
                dict[PipelineLibraryType.ColorRender.rawValue] = renderPipelineState
            }
        } catch let err_ as NSError {
            logger?.printLog("RENDER_PIPELINE_STATE : \(err_.localizedDescription)")
        }
    }
    
   
     func addImageRenderPipelineState() {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = shaderLibrary.getVertexFunction(_byType:  .standard_Vertex_Shader)
        renderPipelineDescriptor.fragmentFunction = shaderLibrary.getFragment(_byType: .ImageFragmentShader)
        renderPipelineDescriptor.depthAttachmentPixelFormat = MetalDefaults.DepthPixelFormat
        renderPipelineDescriptor.vertexDescriptor = mVertexDescriptorLibrary.get(_vertexDescriptorBy: .PositionColorTexture)
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
        renderPipelineDescriptor.setblending()
        do {
            let renderPipelineState = try MetalDefaults.GPUDevice.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                
                dict[PipelineLibraryType.ImageRender.rawValue] = renderPipelineState
            }
        } catch let err_ as NSError {
            logger?.printLog("RENDER_PIPELINE_STATE : \(err_.localizedDescription)")
        }
    }
    
     func addParentRenderPipelineState() {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
        renderPipelineDescriptor.vertexFunction = shaderLibrary.getVertexFunction(_byType:  .passThrough_vertexShader)
        
        renderPipelineDescriptor.fragmentFunction = shaderLibrary.getFragment(_byType: .passThrough_fragmentShader)
        renderPipelineDescriptor.depthAttachmentPixelFormat = MetalDefaults.DepthPixelFormat
        renderPipelineDescriptor.vertexDescriptor = mVertexDescriptorLibrary.get(_vertexDescriptorBy: .PositionColorTexture)
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
        renderPipelineDescriptor.setblending()
        do {
            let renderPipelineState = try MetalDefaults.GPUDevice.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                
                dict[PipelineLibraryType.ParentRender.rawValue] = renderPipelineState
                
            }
        } catch let error as NSError {
            logger?.printLog("RENDER_PIPELINE_STATE : \(error.localizedDescription)")
        }
    }
    func addSceneRenderPipelineState() {
       let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
       renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
       renderPipelineDescriptor.vertexFunction = shaderLibrary.getVertexFunction(_byType:  .passThrough_vertexShader)
       
       renderPipelineDescriptor.fragmentFunction = shaderLibrary.getFragment(_byType: .passThrough_fragmentShader2)
       renderPipelineDescriptor.depthAttachmentPixelFormat = MetalDefaults.DepthPixelFormat
       renderPipelineDescriptor.vertexDescriptor = mVertexDescriptorLibrary.get(_vertexDescriptorBy: .PositionColorTexture)
       renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
       renderPipelineDescriptor.setblending2()
       do {
           let renderPipelineState = try MetalDefaults.GPUDevice.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
           queue.async(flags: .barrier) { [weak self] in
               guard let self = self else { return }
               
               dict[PipelineLibraryType.SceneRender.rawValue] = renderPipelineState
               
           }
       } catch let error as NSError {
           logger?.printLog("RENDER_PIPELINE_STATE : \(error.localizedDescription)")
       }
   }
    
}


extension MChild {
    var pipelineLibrary: PipelineLibrary {
//        return Injection.shared.inject(type: PipelineLibrary.self)!
//        Injected<PipelineLibrary>().wrappedValue
        return (DependencyResolver.shared?.resolve(PipelineLibrary.self))!
    }
    func switchTo(type:PipelineLibraryType) {
        renderPipelineState = pipelineLibrary.getPipelineState(type: type)
        pipelineType = type
       
    }
}


extension MTLRenderPipelineDescriptor {
    func setblending(){
        self.colorAttachments[0].isBlendingEnabled = true
        self.colorAttachments[0].rgbBlendOperation = .add
        self.colorAttachments[0].alphaBlendOperation = .add
        
        self.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        self.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        self.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        self.colorAttachments[0].destinationAlphaBlendFactor = .one
    }
    func setblending2(){
        self.colorAttachments[0].isBlendingEnabled = true
        self.colorAttachments[0].rgbBlendOperation = .add
        self.colorAttachments[0].alphaBlendOperation = .add
        self.colorAttachments[0].sourceRGBBlendFactor = .one
        self.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        self.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        self.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha

    }
}
