//
//  TintAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/01/25.
//


#include <metal_stdlib>
using namespace metal;

struct TintParams {
    float tintIntensity;
};


kernel void TintAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant TintParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }


    // Get the pixel color from the source texture
    float4 color = source.read(gid);

    // Define the target colors for the effect
    float3 pinkColor = float3(1.0, 0.0, 1.0);  // Pinkish color (high red and blue, low green)
    float3 greenColor = float3(0.0, 1.0, 0.0); // Greenish color (high green, low red and blue)

    // Interpolate between pink (warmth) and green (coolness) based on intensity (-1 to 1)
    // Positive intensity gives pinkish, negative gives greenish
    float3 warmthColor = mix(greenColor, pinkColor, (params.tintIntensity + 1.0) / 2.0);

    // Apply the warmth effect to the original color
    // A positive warmth intensity will make the image more pinkish,
    // and a negative warmth intensity will make the image more greenish
    color.rgb = mix(color.rgb, warmthColor, abs(params.tintIntensity * 0.5));

    // Write the modified color to the destination texture
    destination.write(color, gid);
}
