//
//  SketchFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//
//
//#include <metal_stdlib>
//using namespace metal;
//
//kernel void SketchFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
//                         texture2d<float, access::write> outputTexture [[ texture(1) ]],
//                         uint2 grid [[ thread_position_in_grid ]]) {
//    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
//        return;
//    }
//
//    float4 color = inputTexture.read(grid);
//    float edge = step(0.7, color.r); // Basic thresholding
//    float4 sketchColor = float4(edge, edge, edge, color.a);
//    outputTexture.write(sketchColor, grid);
//}


#include <metal_stdlib>
using namespace metal;

// Helper function to compute luminance from color
float luminance(float4 color) {
    return dot(color.rgb, float3(0.299, 0.587, 0.114));
}

kernel void SketchFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                         texture2d<float, access::write> outputTexture [[ texture(1) ]],
                         uint2 grid [[ thread_position_in_grid ]]) {
    // Ensure we are within the texture bounds
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Get the current pixel color
    float4 color = inputTexture.read(grid);
    float lum = luminance(color);

    // Convert grid to int2 for texture sampling (we need signed ints for offsets)
    int2 gridInt = int2(grid);

    // Texture sampling for surrounding coordinates
    float bottomLeftIntensity = inputTexture.read(uint2(gridInt + int2(-1, -1))).r;
    float bottomRightIntensity = inputTexture.read(uint2(gridInt + int2(1, -1))).r;
    float leftIntensity = inputTexture.read(uint2(gridInt + int2(-1, 0))).r;
    float rightIntensity = inputTexture.read(uint2(gridInt + int2(1, 0))).r;
    float bottomIntensity = inputTexture.read(uint2(gridInt + int2(0, -1))).r;
    float topIntensity = inputTexture.read(uint2(gridInt + int2(0, 1))).r;
    float topRightIntensity = inputTexture.read(uint2(gridInt + int2(1, 1))).r;
    float topLeftIntensity = inputTexture.read(uint2(gridInt + int2(-1, 1))).r;

    // Compute horizontal and vertical gradients (edge strength with 0.5)
    float h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
    float v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;

    // Calculate the gradient magnitude (this is the strength of the edges)
    float gradMagnitude = 1.0 - (length(float2(h, v)) * 0.5); // Apply 0.5 edge strength

    // Brighten the non-edge regions by mixing with the original image luminance
    float finalBrightness = mix(lum, 1.0, 0.4); // Ensure brighter areas stay bright

    // Use the brightness and edge strength to create a sketch effect
    float4 sketchColor = float4(finalBrightness * gradMagnitude, finalBrightness * gradMagnitude, finalBrightness * gradMagnitude, color.a);

    // Write the result to the output texture
    outputTexture.write(sketchColor, grid);
}
