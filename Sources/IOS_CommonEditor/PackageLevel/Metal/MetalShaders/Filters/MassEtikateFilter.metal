//
//  AbaoFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//
//
//#include <metal_stdlib>
//using namespace metal;
//
//constant float3 tint = float3(0.5, 0.2, 0.8); // RGB tint values for the filter
//
//kernel void AbaoFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
//                       texture2d<float, access::write> outputTexture [[ texture(1) ]],
//                       uint2 grid [[ thread_position_in_grid ]]) {
//
//    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
//        return;
//    }
//
//    // Define local constants for quantization levels and threshold
//    const float quantizationLevels = 8.0f;  // Example value for quantization levels
//    const float threshold = 0.2f;           // Example value for threshold
//
//    // Define a default sampler (this could vary depending on your needs)
//    const sampler quadSampler = sampler(address::clamp_to_edge, filter::linear, mip_filter::linear);
//
//    // Read the input color
//    float4 inColor = inputTexture.read(grid);
//
//    // Convert grid position to integer coordinates
//    int2 gridInt = int2(grid.x, grid.y);
//
//    // Texture sampling for surrounding coordinates
//    float bottomLeftIntensity = inputTexture.read(uint2(gridInt + int2(-1, -1))).r;
//    float bottomRightIntensity = inputTexture.read(uint2(gridInt + int2(1, -1))).r;
//    float leftIntensity = inputTexture.read(uint2(gridInt + int2(-1, 0))).r;
//    float rightIntensity = inputTexture.read(uint2(gridInt + int2(1, 0))).r;
//    float bottomIntensity = inputTexture.read(uint2(gridInt + int2(0, -1))).r;
//    float topIntensity = inputTexture.read(uint2(gridInt + int2(0, 1))).r;
//    float topRightIntensity = inputTexture.read(uint2(gridInt + int2(1, 1))).r;
//    float topLeftIntensity = inputTexture.read(uint2(gridInt + int2(-1, 1))).r;
//
//    // Calculate horizontal and vertical gradients
//    float h = -topLeftIntensity - 2.0f * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0f * bottomIntensity + bottomRightIntensity;
//    float v = -bottomLeftIntensity - 2.0f * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0f * rightIntensity + topRightIntensity;
//
//    // Compute the gradient magnitude
//    float mag = length(float2(h, v));
//
//    // Posterize the color based on quantization levels
//    float3 posterizedImageColor = floor((inColor.rgb * quantizationLevels) + 0.5f) / quantizationLevels;
//
//    // Apply thresholding based on the gradient magnitude
//    float thresholdTest = 1.0f - step(threshold, mag);
//
//    // Apply the tint to the RGB components
//    float3 tintedColor = posterizedImageColor * tint;
//
//    // Clamp the result to ensure it's within [0, 1] range
//    tintedColor = clamp(tintedColor, 0.0f, 1.0f);
//
//    // Write the final color with the original alpha value to the output texture
//    float4 finalColor = float4(tintedColor * thresholdTest, inColor.a);
//    outputTexture.write(finalColor, grid);
//}
//


#include <metal_stdlib>
using namespace metal;


kernel void MassEtikateFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                              texture2d<float, access::write> outputTexture [[ texture(1) ]],
                              uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Read the input color
    float4 inColor = inputTexture.read(grid);
    
    // Get the pixel color from the source texture
    float4 color = inputTexture.read(grid);

    // Define the target colors for the effect
    float3 pinkColor = float3(1.0, 0.0, 1.0);  // Pinkish color (high red and blue, low green)
    float3 greenColor = float3(0.0, 1.0, 0.0); // Greenish color (high green, low red and blue)
    float3 yellowColor = float3(1.0, 1.0, 0.0);

    // and a negative warmth intensity will make the image more greenish
    color.rgb = mix(color.rgb, yellowColor, 0.2);

    // Write the modified color to the destination texture
    outputTexture.write(color, grid);
}

