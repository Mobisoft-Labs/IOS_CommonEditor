//
//  ColorAdjustment.swift
//  VideoInvitation
//
//  Created by HKBeast on 11/09/23.
//


import Foundation

import MetalKit



final class ColorAdjustment {
    
//    var color: SIMD3<Float> = simd_float3(0.0, 0.0, 0.0)
    var color:SIMD3<Float> = SIMD3<Float>(0.0,1.0,1.0) //float3(1.0, 0.0, 0.0)
//    var brightness:Float = 0.0
//    var exposure:Float = 0.0
    
    
    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    
    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "ColorAdjustment",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }
    
    func encode(source: MTLTexture,
                destination: MTLTexture,
                in commandBuffer: MTLCommandBuffer) {
        guard let encoder = commandBuffer.makeComputeCommandEncoder()
        else { return }
        encoder.label = "ColorAdjustment"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setBytes(&self.color,
                         length: MemoryLayout<Float>.stride,
                         index: 0)
//        encoder.setBytes(&self.tint,
//                         length: MemoryLayout<Float>.stride,
//                         index: 1)
        
        let gridSize = MTLSize(width: source.width,
                               height: source.height,
                               depth: 1)
        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth,
                                      height: threadGroupHeight,
                                      depth: 1)
        
        encoder.setComputePipelineState(self.pipelineState)
        if self.deviceSupportsNonuniformThreadgroups {
            encoder.dispatchThreads(gridSize,
                                    threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                                           depth: 1)
            encoder.dispatchThreadgroups(threadGroupCount,
                                         threadsPerThreadgroup: threadGroupSize)
        }
        
        encoder.endEncoding()
        
    }
    func encode(source: MTLTexture,
                destination: MTLTexture,
               in encoder: MTLComputeCommandEncoder) {
        
        
       // guard let encoder = commandBuffer.makeComputeCommandEncoder()
       // else { return }
        encoder.label = "ColorAdjustment"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setBytes(&self.color,
                         length: MemoryLayout<SIMD3<Float>>.stride,
                         index: 0)
//        encoder.setBytes(&self.tint,
//                         length: MemoryLayout<Float>.stride,
//                         index: 1)
        
        let gridSize = MTLSize(width: source.width,
                               height: source.height,
                               depth: 1)
        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth,
                                      height: threadGroupHeight,
                                      depth: 1)
        
        encoder.setComputePipelineState(self.pipelineState)
        if self.deviceSupportsNonuniformThreadgroups {
            encoder.dispatchThreads(gridSize,
                                    threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                                           depth: 1)
            encoder.dispatchThreadgroups(threadGroupCount,
                                         threadsPerThreadgroup: threadGroupSize)
        }
        
      //  encoder.endEncoding()
        
    }
    
}


final class ColorFilterOnImage {
    
//    var color: SIMD3<Float> = simd_float3(0.0, 0.0, 0.0)
    var color:SIMD3<Float> = SIMD3<Float>(0.0,1.0,1.0) //float3(1.0, 0.0, 0.0)
//    var brightness:Float = 0.0
//    var exposure:Float = 0.0
    
    
    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    
    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "ColorFilterOnImage",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }
    
    func encode(source: MTLTexture,
                destination: MTLTexture,
                in commandBuffer: MTLCommandBuffer) {
        guard let encoder = commandBuffer.makeComputeCommandEncoder()
        else { return }
        encoder.label = "ColorFilterOnImage"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setBytes(&self.color,
                         length: MemoryLayout<Float>.stride,
                         index: 0)
//        encoder.setBytes(&self.tint,
//                         length: MemoryLayout<Float>.stride,
//                         index: 1)
        
        let gridSize = MTLSize(width: source.width,
                               height: source.height,
                               depth: 1)
        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth,
                                      height: threadGroupHeight,
                                      depth: 1)
        
        encoder.setComputePipelineState(self.pipelineState)
        if self.deviceSupportsNonuniformThreadgroups {
            encoder.dispatchThreads(gridSize,
                                    threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                                           depth: 1)
            encoder.dispatchThreadgroups(threadGroupCount,
                                         threadsPerThreadgroup: threadGroupSize)
        }
        
        encoder.endEncoding()
        
    }
    func encode(source: MTLTexture,
                destination: MTLTexture,
               in encoder: MTLComputeCommandEncoder) {
        
        
       // guard let encoder = commandBuffer.makeComputeCommandEncoder()
       // else { return }
        encoder.label = "ColorFilterOnImage"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setBytes(&self.color,
                         length: MemoryLayout<SIMD3<Float>>.stride,
                         index: 0)
//        encoder.setBytes(&self.tint,
//                         length: MemoryLayout<Float>.stride,
//                         index: 1)
        
        let gridSize = MTLSize(width: source.width,
                               height: source.height,
                               depth: 1)
        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth,
                                      height: threadGroupHeight,
                                      depth: 1)
        
        encoder.setComputePipelineState(self.pipelineState)
        if self.deviceSupportsNonuniformThreadgroups {
            encoder.dispatchThreads(gridSize,
                                    threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                                           depth: 1)
            encoder.dispatchThreadgroups(threadGroupCount,
                                         threadsPerThreadgroup: threadGroupSize)
        }
        
      //  encoder.endEncoding()
        
    }
    
}

