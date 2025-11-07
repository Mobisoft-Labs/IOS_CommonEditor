//
//  BrightnessFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 03/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct FilterParams {
    float brightnessIntensity;
};

kernel void BrightnessAdjustment(
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

    // Apply brightness intensity (increase or decrease brightness)
    color.rgb += (params.brightnessIntensity * 0.2);

    // Write the modified color to the destination texture
    destination.write(color, gid);
}
