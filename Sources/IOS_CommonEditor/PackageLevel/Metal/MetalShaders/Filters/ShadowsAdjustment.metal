//
//  ShadowsAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct ShadowsParams {
    float shadows; 
};

kernel void ShadowsAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant ShadowsParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }

    float4 color = source.read(gid);
    
    // Luminance calculation using standard weighting
    const float3 luminanceWeighting = float3(0.2126, 0.7152, 0.0722);
    float luminance = dot(color.rgb, luminanceWeighting);

    // Shadow adjustment
    float shadow = clamp(
        pow(luminance, 1.0f / (params.shadows + 1.0f)) +
        (-0.76f) * pow(luminance, 2.0f / (params.shadows + 1.0f)) -
        luminance,
        0.0f,
        1.0f
    );

    // Adjust the color based on shadows and highlights
    float3 adjustedColor = (luminance + shadow) *
        ((color.rgb - float3(0.0f)) / max(luminance, 0.001f));

    // Write the adjusted color to the destination
    destination.write(float4(adjustedColor, color.a), gid);
}
