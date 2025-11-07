//
//  TintAdjustment.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/01/25.
//


import Foundation
import MetalKit
import simd

final class TintAdjustment {
    // Tint parameters
    // Create a custom tint color that combines pink and green
    var tintColor: SIMD3<Float> = SIMD3<Float>(1.0, 0.0, 1.0) // Pink (full red and blue)
    let greenTint: SIMD3<Float> = SIMD3<Float>(0.0, 1.0, 0.0) // Green (full green)
    var tintIntensity: Float = 0.0

    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState

    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "TintAdjustment",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }

    func encode(source: MTLTexture,
                destination: MTLTexture,
                in encoder: MTLComputeCommandEncoder) {
        // Set the textures and parameters
        encoder.label = "TintAdjustment"
        encoder.setTexture(source, index: 0)
        encoder.setTexture(destination, index: 1)
        encoder.setBytes(&self.tintIntensity, length: MemoryLayout<Float>.stride, index: 0)

        // Compute grid and thread group sizes
        let gridSize = MTLSize(width: source.width, height: source.height, depth: 1)
        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth, height: threadGroupHeight, depth: 1)

        // Set the compute pipeline state
        encoder.setComputePipelineState(self.pipelineState)

        // Dispatch threads
        if self.deviceSupportsNonuniformThreadgroups {
            encoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                                           height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                                           depth: 1)
            encoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadGroupSize)
        }
    }
}
