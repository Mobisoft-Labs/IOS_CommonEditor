//
//  ContrastAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct ContrastParams {
    float contrast; // Range: -1.0 to 1.0
};

kernel void ContrastAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant ContrastParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    // Ensure the thread is within the texture bounds
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }

    // Read the source color
    float4 color = source.read(gid);

    // Map the contrast range (-1.0 to 1.0) to a factor that works for contrast adjustment
    float contrastFactor = params.contrast * 0.5 + 1.0; // Map to [0.0, 2.0] range

    // Apply the contrast formula
    color.rgb = 0.5 + (color.rgb - 0.5) * contrastFactor;

    // Clamp to [0, 1] to ensure valid color values
    color.rgb = clamp(color.rgb, 0.0, 1.0);

    // Write the result to the destination
    destination.write(color, gid);
}
