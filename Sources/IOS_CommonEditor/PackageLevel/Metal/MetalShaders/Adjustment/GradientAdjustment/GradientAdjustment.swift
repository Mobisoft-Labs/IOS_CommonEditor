//
//  ColorAdjustment.swift
//  VideoInvitation
//
//  Created by HKBeast on 11/09/23.
//


import Foundation

import MetalKit



final class GradientAdjustment {
    
    var startColor:SIMD3<Float> = simd_float3(1.0, 1.0, 1.0)
    var endColor:SIMD3<Float> = simd_float3(1.0, 1.0, 1.0)
    var gradientType:Float = 0.0
    var radius:Float = 0.0
    var angleInDegree:Float = 0.0
    
    
    var contentType : Float = 2
    var tileTexture : MTLTexture?
    var tileFrequency : Float = 1
    
    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    
    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "GradientAdjustment",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }
    
    func encode(source: MTLTexture,
                destination: MTLTexture,
                in commandBuffer: MTLCommandBuffer) {
        guard let encoder = commandBuffer.makeComputeCommandEncoder()
        else { return }
        encoder.label = "GradientAdjustment"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setTexture(tileTexture,
                           index: 2)

        encoder.setBytes(&self.gradientType,
                         length: MemoryLayout<Float>.stride,
                         index: 0)
        encoder.setBytes(&self.startColor,
                         length: MemoryLayout<SIMD3<Float>>.stride,
                         index: 1)
        encoder.setBytes(&self.endColor,
                         length: MemoryLayout<SIMD3<Float>>.stride,
                         index: 2)
        encoder.setBytes(&self.radius,
                         length: MemoryLayout<Float>.stride,
                         index: 3)
        encoder.setBytes(&self.angleInDegree,
                         length: MemoryLayout<Float>.stride,
                         index: 4)
        
        encoder.setBytes(&self.contentType,
                         length: MemoryLayout<Float>.stride,
                         index: 5)
        encoder.setBytes(&self.tileFrequency,
                         length: MemoryLayout<Float>.stride,
                         index: 6)
        

        
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
        encoder.label = "GradientAdjustment"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setTexture(tileTexture,
                           index: 2)

        encoder.setBytes(&self.gradientType,
                         length: MemoryLayout<Float>.stride,
                         index: 0)
        encoder.setBytes(&self.endColor,
                         length: MemoryLayout<SIMD3<Float>>.stride,
                         index: 1)
        encoder.setBytes(&self.startColor,
                         length: MemoryLayout<SIMD3<Float>>.stride,
                         index: 2)
        encoder.setBytes(&self.radius,
                         length: MemoryLayout<Float>.stride,
                         index: 3)
        encoder.setBytes(&self.angleInDegree,
                         length: MemoryLayout<Float>.stride,
                         index: 4)
        encoder.setBytes(&self.contentType,
                         length: MemoryLayout<Float>.stride,
                         index: 5)
        encoder.setBytes(&self.tileFrequency,
                         length: MemoryLayout<Float>.stride,
                         index: 6)
        
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

