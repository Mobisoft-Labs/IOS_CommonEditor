//
//  SharpnessAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/01/25.
//

#include <metal_stdlib>
using namespace metal;
//
//struct SharpnessParams {
//    float sharpness; // Range from -1 to 1 (negative for fading/softening, positive for sharpening)
//};
//
//kernel void SharpnessAdjustment(
//    texture2d<float, access::read> source [[ texture(0) ]],
//    texture2d<float, access::write> destination [[ texture(1) ]],
//    constant SharpnessParams &params [[ buffer(0) ]],
//    uint2 gid [[ thread_position_in_grid ]]
//) {
//    if (gid.x >= 1 && gid.x < source.get_width() - 1 &&
//        gid.y >= 1 && gid.y < source.get_height() - 1) {
//        
//        // Read the pixel color from the source texture
//        float4 color = source.read(gid);
//        
//        // Read neighboring pixels
//        float4 north = source.read(uint2(gid.x, gid.y - 1));
//        float4 south = source.read(uint2(gid.x, gid.y + 1));
//        float4 east = source.read(uint2(gid.x + 1, gid.y));
//        float4 west = source.read(uint2(gid.x - 1, gid.y));
//        
//        // Calculate the edge by comparing surrounding pixels to the center pixel
//        float4 edge = (north + south + east + west - 4.0 * color);
//        
//        // Normalize the sharpness value from [-1, 1] to [0, 1] range
//        float sharpnessFactor = -(params.sharpness + 1.0) * 0.5;  // Convert [-1, 1] -> [0, 1]
//        
//        // Sharpening: Apply stronger enhancement if sharpness is positive
//        if (params.sharpness > 0.0) {
//            color.rgb += edge.rgb * sharpnessFactor * 4.0; // Increase multiplier for stronger sharpness
//        }
//        // Fading/Softening: Reduce edges if sharpness is negative
//        else {
//            color.rgb -= edge.rgb * abs(sharpnessFactor) * 8.0; // Reduce multiplier for softening
//        }
//
//        // Ensure color stays within bounds (clamping)
//        color.rgb = clamp(color.rgb, 0.0f, 1.0f);
//        
//        // Write the modified color back to the destination texture
//        destination.write(color, gid);
//    }
//}


// Define the structure for the sharpness parameter
struct SharpnessParams {
    float sharpness; // Range from -1 to 1 (negative for fading/softening, positive for sharpening)
};

// Define the kernel function for sharpness adjustment
kernel void SharpnessAdjustment(
    texture2d<half, access::read> source [[ texture(0) ]],    // Input texture
    texture2d<half, access::write> destination [[ texture(1) ]], // Output texture
    constant SharpnessParams &params [[ buffer(0) ]],         // SharpnessParams structure passed as constant
    uint2 gid [[ thread_position_in_grid ]]                   // Global thread position
) {
    constexpr sampler quadSampler(coord::pixel); // Sampler to use for texture sampling

    // Get texture size
    uint textureWidth = source.get_width();
    uint textureHeight = source.get_height();
    uint2 textureSize = uint2(textureWidth, textureHeight);

    // Only process pixels within the bounds of the texture
    if (gid.x >= textureSize.x || gid.y >= textureSize.y) {
        return;
    }

    // Read the color of the center texel (current pixel)
    half4 centerColorWithAlpha = source.read(gid);
    half3 centerColor = centerColorWithAlpha.rgb;

    // Initialize neighboring texel colors with default values (center texel in case of out-of-bounds)
    half3 leftColor = centerColor;
    half3 rightColor = centerColor;
    half3 topColor = centerColor;
    half3 bottomColor = centerColor;

    // Get neighboring texels, ensuring we're within bounds
    if (gid.x > 0) {
        leftColor = source.read(gid - uint2(1, 0)).rgb;
    }
    if (gid.x < textureSize.x - 1) {
        rightColor = source.read(gid + uint2(1, 0)).rgb;
    }
    if (gid.y > 0) {
        topColor = source.read(gid - uint2(0, 1)).rgb;
    }
    if (gid.y < textureSize.y - 1) {
        bottomColor = source.read(gid + uint2(0, 1)).rgb;
    }

    // Apply the sharpening logic
    half edgeMultiplier = half(params.sharpness);
    half centerMultiplier = 1.0 + 4.0 * edgeMultiplier;

    // Perform sharpening based on neighboring texels
    half3 sharpenedColor = (centerColor * centerMultiplier
                            - (leftColor * edgeMultiplier + rightColor * edgeMultiplier
                               + topColor * edgeMultiplier + bottomColor * edgeMultiplier));

    // Write the sharpened color to the destination texture
    destination.write(half4(sharpenedColor, centerColorWithAlpha.a), gid);
}
