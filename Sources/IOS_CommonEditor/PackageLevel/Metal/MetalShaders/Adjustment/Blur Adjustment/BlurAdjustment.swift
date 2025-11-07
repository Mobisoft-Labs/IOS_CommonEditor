//
//  ColorAdjustment.swift
//  VideoInvitation
//
//  Created by HKBeast on 11/09/23.
//


import Foundation

import MetalKit

import MetalPerformanceShaders


//final class BlurAdjustment {
//    
////    var color: SIMD3<Float> = simd_float3(0.0, 0.0, 0.0)
//    var blur: Float = 0.8
////    var brightness:Float = 0.0
////    var exposure:Float = 0.0
//    
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
//        let function = try library.makeFunction(name: "BlurAdjustment",
//                                                constantValues: constantValues)
//        self.pipelineState = try library.device.makeComputePipelineState(function: function)
//    }
//    
//    func encode(source: MTLTexture,
//                destination: MTLTexture,
//                in commandBuffer: MTLCommandBuffer) {
//        guard let encoder = commandBuffer.makeComputeCommandEncoder()
//        else { return }
//        encoder.label = "ColorAdjustment"
//        encoder.setTexture(source,
//                           index: 0)
//        encoder.setTexture(destination,
//                           index: 1)
//        encoder.setBytes(&self.blur,
//                         length: MemoryLayout<SIMD3<Float>>.stride,
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
//        encoder.label = "BlurAdjustment"
//        encoder.setTexture(source,
//                           index: 0)
//        encoder.setTexture(destination,
//                           index: 1)
//        encoder.setBytes(&self.blur,
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


final class BlurAdjustment {
    
    var blur: Float = 8
    
    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    
    init(library: MTLLibrary) throws {
        
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "BlurAdjustment",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
        
    }
    
//    var weights = [Float]()
//    var weightsBuffer : MTLBuffer!
//    
    func encode(source: MTLTexture,
                destination: MTLTexture,
                in encoder: MTLComputeCommandEncoder) {

        
        // Calculate texel size for width and height
//        var texelWidthSize = (5 * blur * 10) / (Float(source.width*100) ) //     float2(1.0 / Float(source.width), 1.0 / Float(source.height))
//        var texelHeightSize = (5 * blur * 10) / (Float(source.height*100) ) //float2(1.0 / Float(source.width), 1.0 / Float(source.height))
        let blurSize = Float(Double(source.width) * 0.005)
        var texelWidthSize = ( blurSize * blur * 10) / (Float(source.width*100) ) //     float2(1.0 / Float(source.width), 1.0 / Float(source.height))
        var texelHeightSize = (blurSize * blur * 10) / (Float(source.height*100) ) //float2(1.0 / Float(source.width), 1.0 / Float(source.height))
        
        encoder.label = "BlurAdjustment"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setBytes(&self.blur,
                         length: MemoryLayout<Float>.stride,
                         index: 3)
      // encoder.setBuffer(weightsBuffer, offset: 0, index: 0)
        encoder.setBytes(&texelWidthSize, length: MemoryLayout<Float>.stride, index: 1)
        encoder.setBytes(&texelHeightSize, length: MemoryLayout<Float>.stride, index: 2)

        
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
    
    
    func precomputeGaussianWeights(radius: Int) -> [Float] {
        let sigma = Float(radius) / 2.0
        let expScale = -1.0 / (2.0 * sigma * sigma)
        let size = 2 * radius + 1

        var weights = [Float](repeating: 0.0, count: size)
        var weightSum: Float = 0.0

        for i in 0..<size {
            let distance = Float(i - radius)
            let weight = exp(distance * distance * expScale)
            weights[i] = weight
            weightSum += weight
        }

        // Normalize weights
        for i in 0..<size {
            weights[i] /= weightSum
        }

        return weights
    }
}
final class BlurAdjustment1 {
    
//    var color: SIMD3<Float> = simd_float3(0.0, 0.0, 0.0)
    var blur: Float = 0.8 {
        didSet {
            sigma = blur
        }
    }
//    var brightness:Float = 0.0
//    var exposure:Float = 0.0
    
    
    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    
    init(library: MTLLibrary) throws {
        self.sigma = 0.8
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "BlurAdjustment",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }
    
    /// The standard deviation of the gaussian blur filter
    public var sigma: Float { didSet { _kernel = nil } }
    
    private var kernel: MPSImageGaussianBlur {
        if let k = _kernel { return k }
        let k = MPSImageGaussianBlur(device: MetalDefaults.GPUDevice, sigma: sigma)
        k.edgeMode = .clamp
        _kernel = k
        return k
    }
    private var _kernel: MPSImageGaussianBlur!
    
//    public init(sigma: Float) {
//        self.sigma = sigma
//       // super.init(kernelFunctionName: "", useMPSKernel: true)
//    }
    
//    public override func encodeMPSKernel(into commandBuffer: MTLCommandBuffer) {
//    }
//    
    func encode(source: MTLTexture,
                destination: MTLTexture,
                in commandBuffer: MTLCommandBuffer) {
        kernel.encode(commandBuffer: commandBuffer, sourceTexture: source, destinationTexture: destination)

//        guard let encoder = commandBuffer.makeComputeCommandEncoder()
//        else { return }
//        encoder.label = "ColorAdjustment"
//        encoder.setTexture(source,
//                           index: 0)
//        encoder.setTexture(destination,
//                           index: 1)
//        encoder.setBytes(&self.blur,
//                         length: MemoryLayout<SIMD3<Float>>.stride,
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
        commandBuffer.commit()
    }
    func encode(source: MTLTexture,
                destination: MTLTexture,
               in encoder: MTLComputeCommandEncoder) {
        
//        
       // guard let encoder = commandBuffer.makeComputeCommandEncoder()
       // else { return }
        encoder.label = "BlurAdjustment"
        encoder.setTexture(source,
                           index: 0)
        encoder.setTexture(destination,
                           index: 1)
        encoder.setBytes(&self.blur,
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
        
      //  encoder.endEncoding()
        
    }
    
}

///// A filter that convolves an image with a Gaussian blur of a given sigma in both the x and y directions
//public class BBMetalGaussianBlurFilter: BBMetalBaseFilter {
//    /// The standard deviation of the gaussian blur filter
//    public var sigma: Float { didSet { _kernel = nil } }
//    
//    private var kernel: MPSImageGaussianBlur {
//        if let k = _kernel { return k }
//        let k = MPSImageGaussianBlur(device: BBMetalDevice.sharedDevice, sigma: sigma)
//        k.edgeMode = .clamp
//        _kernel = k
//        return k
//    }
//    private var _kernel: MPSImageGaussianBlur!
//    
//    public init(sigma: Float) {
//        self.sigma = sigma
//        super.init(kernelFunctionName: "", useMPSKernel: true)
//    }
//    
//    public override func encodeMPSKernel(into commandBuffer: MTLCommandBuffer) {
//        kernel.encode(commandBuffer: commandBuffer, sourceTexture: sources.first!.texture!, destinationTexture: outputTexture!)
//    }
//}
