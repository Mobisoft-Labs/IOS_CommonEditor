//
//  ContrastAdjustment.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

import Foundation
import MetalKit

final class ContrastAdjustment {
    var contrastIntensity: Float = 0.0

    private var deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState

    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFeatureSet(.iOS_GPUFamily4_v1)
        let constantValues = MTLFunctionConstantValues()
        constantValues.setConstantValue(&self.deviceSupportsNonuniformThreadgroups,
                                        type: .bool,
                                        index: 0)
        let function = try library.makeFunction(name: "ContrastAdjustment",
                                                constantValues: constantValues)
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
    }

    func encode(source: MTLTexture,
                destination: MTLTexture,
                in encoder: MTLComputeCommandEncoder) {

        encoder.label = "ContrastAdjustment"
        encoder.setTexture(source, index: 0)
        encoder.setTexture(destination, index: 1)
        encoder.setBytes(&self.contrastIntensity,
                         length: MemoryLayout<Float>.stride,
                         index: 0)

        let gridSize = MTLSize(width: source.width, height: source.height, depth: 1)
        let threadGroupWidth = self.pipelineState.threadExecutionWidth
        let threadGroupHeight = self.pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth
        let threadGroupSize = MTLSize(width: threadGroupWidth, height: threadGroupHeight, depth: 1)

        encoder.setComputePipelineState(self.pipelineState)

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


