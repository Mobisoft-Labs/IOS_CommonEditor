////
////  TileAdjustment.swift
////  VideoInvitation
////
////  Created by J D on 11/10/25.
////
//
//

import Metal

struct MaskAdjustmentParams {
    var sourceSize: SIMD2<UInt32>
    var maskSize: SIMD2<UInt32>
}

final class MaskAdjustment {

    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    private var maskTexture: MTLTexture?

    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        
        var supports = self.deviceSupportsNonuniformThreadgroups
        let constants = MTLFunctionConstantValues()
        constants.setConstantValue(&supports, type: .bool, index: 0)
        
        let function = try library.makeFunction(name: "MaskAdjustment", constantValues: constants)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }

    func setMaskTexture(_ texture: MTLTexture?) {
        self.maskTexture = texture
    }

    func encode(source: MTLTexture,
                destination: MTLTexture,
                in commandBuffer: MTLCommandBuffer) {
        guard let encoder = commandBuffer.makeComputeCommandEncoder(),
              let maskTexture = self.maskTexture else {
            return
        }

        self.encode(source: source,
                    mask: maskTexture,
                    destination: destination,
                    in: encoder)

        encoder.endEncoding()
    }

    func encode(source: MTLTexture,
                mask: MTLTexture,
                destination: MTLTexture,
                in encoder: MTLComputeCommandEncoder) {

        var params = MaskAdjustmentParams(
            sourceSize: SIMD2(UInt32(source.width), UInt32(source.height)),
            maskSize: SIMD2(UInt32(mask.width), UInt32(mask.height))
        )

        encoder.label = "MaskAdjustment"
        encoder.setComputePipelineState(self.pipelineState)

        encoder.setTexture(source, index: 0)
        encoder.setTexture(mask, index: 1)
        encoder.setTexture(destination, index: 2)
        encoder.setBytes(&params, length: MemoryLayout<MaskAdjustmentParams>.stride, index: 0)

        let gridSize = MTLSize(width: source.width,
                               height: source.height,
                               depth: 1)

        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth,
                                      height: threadGroupHeight,
                                      depth: 1)

        if deviceSupportsNonuniformThreadgroups {
            encoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(
                width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                depth: 1
            )
            encoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadGroupSize)
        }
    }
}
//final class MaskAdjustment {
// 
//    var maskTexture : MTLTexture?
//
//    private var deviceSupportsNonuniformThreadgroups: Bool
//    private let pipelineState: MTLComputePipelineState
//    
//    init(library: MTLLibrary) throws {
//        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
//        let constantValues = MTLFunctionConstantValues()
//        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
//                                        type: .bool,
//                                        index: 0)
//        let function = try library.makeFunction(name: "MaskAdjustment",
//                                                constantValues: constantValues)
//        self.pipelineState = try library.device.makeComputePipelineState(function: function)
//    }
//    
//    func encode(source: MTLTexture,
//                destination: MTLTexture,
//                in commandBuffer: MTLCommandBuffer) {
//        guard let encoder = commandBuffer.makeComputeCommandEncoder()
//        else { return }
//        encoder.label = "MaskAdjustment"
//        encoder.setTexture(source,
//                           index: 0)
//        encoder.setTexture(destination,
//                           index: 1)
//        encoder.setTexture(tileImageTexture,
//                           index: 2)
//        encoder.setBytes(&self.tile,
//                         length: MemoryLayout<Float>.stride,
//                         index: 0)
////        encoder.setBytes(&self.tint,
////                         length: MemoryLayout<Float>.stride,
////                         index: 1)
//        
//        let gridSize = MTLSize(width: source.width,
//                               height: source.height,
//                               depth: 1)
//        let threadGroupWidth = self.pipelineState.threadExecutionWidth
//        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
//        let threadGroupSize = MTLSize(width: threadGroupWidth,
//                                      height: threadGroupHeight,
//                                      depth: 1)
//        
//        encoder.setComputePipelineState(self.pipelineState)
//        if self.deviceSupportsNonuniformThreadgroups {
//            encoder.dispatchThreads(gridSize,
//                                    threadsPerThreadgroup: threadGroupSize)
//        } else {
//            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
//                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
//                                           depth: 1)
//            encoder.dispatchThreadgroups(threadGroupCount,
//                                         threadsPerThreadgroup: threadGroupSize)
//        }
//        
//        encoder.endEncoding()
//        
//    }
//    func encode(source: MTLTexture,
//                destination: MTLTexture,
//               in encoder: MTLComputeCommandEncoder) {
//        
//        
//       // guard let encoder = commandBuffer.makeComputeCommandEncoder()
//       // else { return }
//        encoder.label = "ColorAdjustment"
//        encoder.setTexture(source,
//                           index: 0)
//        encoder.setTexture(destination,
//                           index: 1)
//
//        encoder.setTexture(tileImageTexture,
//                           index: 2)
//        encoder.setBytes(&self.tile,
//                         length: MemoryLayout<Float>.stride,
//                         index: 0)
////        encoder.setBytes(&self.tint,
////                         length: MemoryLayout<Float>.stride,
////                         index: 1)
//        
//        let gridSize = MTLSize(width: source.width,
//                               height: source.height,
//                               depth: 1)
//        let threadGroupWidth = self.pipelineState.threadExecutionWidth
//        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
//        let threadGroupSize = MTLSize(width: threadGroupWidth,
//                                      height: threadGroupHeight,
//                                      depth: 1)
//        
//        encoder.setComputePipelineState(self.pipelineState)
//        if self.deviceSupportsNonuniformThreadgroups {
//            encoder.dispatchThreads(gridSize,
//                                    threadsPerThreadgroup: threadGroupSize)
//        } else {
//            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
//                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
//                                           depth: 1)
//            encoder.dispatchThreadgroups(threadGroupCount,
//                                         threadsPerThreadgroup: threadGroupSize)
//        }
//        
//      //  encoder.endEncoding()
//        
//    }
//    
//}
//
