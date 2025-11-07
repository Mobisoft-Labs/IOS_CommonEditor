//
//  VibranceAdjustment.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/01/25.
//

#include <metal_stdlib>
using namespace metal;

struct VibranceParams {
    float vibrance;
};

kernel void VibranceAdjustment(
    texture2d<float, access::read> source [[ texture(0) ]],
    texture2d<float, access::write> destination [[ texture(1) ]],
    constant VibranceParams &params [[ buffer(0) ]],
    uint2 gid [[ thread_position_in_grid ]]
) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }

    // Read the color value at the current pixel
    float4 color = source.read(gid);
    
    // Calculate the average and max channel values
    float average = (color.r + color.g + color.b) / 3.0;
    float maxChannel = max(color.r, max(color.g, color.b));
    
    // Reverse the effect based on the vibrance value sign
    // If vibrance is positive, we want a negative effect and vice versa
    float vibranceFactor = -params.vibrance * (1.0 - (maxChannel - average));
    
    // Apply the reversed vibrance effect to the color
    color.rgb = mix(color.rgb, float3(maxChannel), vibranceFactor);
    
    // Write the adjusted color back to the destination texture
    destination.write(color, gid);
}

