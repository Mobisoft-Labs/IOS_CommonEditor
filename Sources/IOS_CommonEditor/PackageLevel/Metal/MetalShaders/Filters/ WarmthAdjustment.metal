//
//   WarmthAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct FilterParams {
    float warmthIntensity; // Intensity between -1 and 1
};

kernel void WarmthAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant FilterParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }

    // Get the pixel color from the source texture
    float4 color = source.read(gid);

    // Interpolate between blueish (cool) and yellowish (warm) based on warmthIntensity
    // -1 = cool (blueish), +1 = warm (yellowish)
    float3 coolColor = float3(0.0, 0.0, 1.0);  // Blueish color (cool)
    float3 warmColor = float3(1.0, 1.0, 0.0);  // Yellowish color (warm)

    // Interpolate between cool and warm based on intensity (-1 to 1)
    float3 warmthColor = mix(coolColor, warmColor, (params.warmthIntensity + 1.0) / 2.0);

    // Apply the warmth effect to the original color
    // A positive warmth intensity will make the image warmer (more yellow),
    // and a negative warmth intensity will make the image cooler (more blue)
    color.rgb = mix(color.rgb, warmthColor, abs(params.warmthIntensity * 0.5));

    // Write the modified color to the destination texture
    destination.write(color, gid);
}
