//
//  BlackAndWhiteFilter.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//


import Foundation
import MetalKit


final class BlackAndWhiteFilter {
    var enabled: Bool = false
    private let pipelineState: MTLComputePipelineState
    private let deviceSupportsNonuniformThreadgroups: Bool

    init(library: MTLLibrary) throws {
        let function = library.makeFunction(name: "BlackAndWhiteFilter")!
        self.pipelineState = try library.device.makeComputePipelineState(function: function)
        self.deviceSupportsNonuniformThreadgroups = library.device.supportsFamily(.apple4) || library.device.supportsFamily(.mac2)
    }

    func encode(source: MTLTexture, destination: MTLTexture, in computeEncoder: MTLComputeCommandEncoder) {
        guard enabled else { return } // Skip encoding if disabled

        // Validate textures
        guard source.width == destination.width, source.height == destination.height else {
            print("Error: Source and destination textures must have the same dimensions.")
            return
        }

        computeEncoder.label = "BlackAndWhiteFilter"
        computeEncoder.setComputePipelineState(pipelineState)
        computeEncoder.setTexture(source, index: 0)
        computeEncoder.setTexture(destination, index: 1)

        let gridSize = MTLSize(width: source.width, height: source.height, depth: 1)
        let threadGroupWidth = pipelineState.threadExecutionWidth
        let threadGroupHeight = max(1, pipelineState.maxTotalThreadsPerThreadgroup / threadGroupWidth)
        let threadGroupSize = MTLSize(width: threadGroupWidth, height: threadGroupHeight, depth: 1)

        if deviceSupportsNonuniformThreadgroups {
            computeEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadGroupSize)
        } else {
            let threadGroupCount = MTLSize(
                width: (gridSize.width + threadGroupSize.width - 1) / threadGroupSize.width,
                height: (gridSize.height + threadGroupSize.height - 1) / threadGroupSize.height,
                depth: 1
            )
            computeEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadGroupSize)
        }
    }
}
