//
//  SaturationAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct SaturationParams {
    float saturation; // Range: -1.0 to 1.0
};

// Function to calculate luminance of a color
float3 luminance(float3 color) {
    const float3 luminanceWeighting = float3(0.2126, 0.7152, 0.0722); // Standard RGB weights for luminance
    return float3(dot(color, luminanceWeighting));
}

kernel void SaturationAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant SaturationParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    // Ensure the thread is within the texture bounds
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }

    // Apply the transformation based on the saturation value
    float saturation;
    if (params.saturation == 0.0) {
        saturation = 1.0; // Treat 0.0 as 1.0
    } else if (params.saturation > 0.0) {
        saturation = 1.0 + params.saturation; // Positive saturation: 1.0 + saturation
    } else {
        saturation = -1.0 + params.saturation; // Negative saturation: -1.0 + saturation
    }

    // Read the source color
    float4 color = source.read(gid);

    // Calculate luminance (grayscale equivalent)
    float3 gray = luminance(color.rgb);

    // Adjust saturation
    if (saturation < 0.0) {
        // For negative saturation, blend towards grayscale
        color.rgb = mix(gray, color.rgb, 1.0 +  (saturation * 0.3));
    } else if (saturation > 0.0) {
        // For positive saturation, blend towards an over-saturated color
        float3 oversaturated = color.rgb + (color.rgb - gray) * (saturation * 0.3);
        color.rgb = mix(gray, oversaturated, saturation);
    }
    else {
        color.rgb = color.rgb; // No change if saturation is 0
    }

    // Write the adjusted color to the destination texture
    destination.write(color, gid);
}
