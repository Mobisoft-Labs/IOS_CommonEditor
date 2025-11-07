//
//  HighlightsShadowsParams.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct HighlightsParams {
    float highlights; // Value to increase or decrease highlights
};

kernel void HighlightsAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant HighlightsParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }

    float4 color = source.read(gid);
    // Luminance calculation using standard weighting
   const float3 luminanceWeighting = float3(0.2126, 0.7152, 0.0722);
   float luminance = dot(color.rgb, luminanceWeighting);

    // Highlight adjustment
    float highlight = clamp(
        1.0f - (
            pow(1.0f - luminance, 1.0f / (2.0f - params.highlights)) +
            (-0.8f) * pow(1.0f - luminance, 2.0f / (2.0f - params.highlights))
        ) - luminance,
        -1.0f,
        0.0f
    );

    // Adjust the color based on shadows and highlights
    float3 adjustedColor = (luminance + highlight) *
        ((color.rgb - float3(0.0f)) / max(luminance, 0.001f));

    // Write the adjusted color to the destination
    destination.write(float4(adjustedColor, color.a), gid);
}
