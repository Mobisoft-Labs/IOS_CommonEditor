//
//  PolkadotFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

constant float dotSize = 8.0;

kernel void PolkadotFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                           texture2d<float, access::write> outputTexture [[ texture(1) ]],
                           uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    float2 dotPosition = float2(floor(grid.x / dotSize) * dotSize, floor(grid.y / dotSize) * dotSize);
    float4 dotColor = inputTexture.read(uint2(dotPosition.x, dotPosition.y));
    outputTexture.write(dotColor, grid);
}
