//
//  SepiaFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 03/01/25.
//

#include <metal_stdlib>
using namespace metal;

// Sepia tone constants
constant float3 kSepiaRed = float3(0.393, 0.769, 0.189);
constant float3 kSepiaGreen = float3(0.349, 0.686, 0.168);
constant float3 kSepiaBlue = float3(0.272, 0.534, 0.131);

kernel void SepiaFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                        texture2d<float, access::write> outputTexture [[ texture(1) ]],
                        uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Read the input color
    float4 inColor = inputTexture.read(grid);

    // Apply sepia transformation
    float red = dot(inColor.rgb, kSepiaRed);
    float green = dot(inColor.rgb, kSepiaGreen);
    float blue = dot(inColor.rgb, kSepiaBlue);

    float4 sepiaColor = float4(red, green, blue, inColor.a);

    // Write the sepia-toned color to the output texture
    outputTexture.write(sepiaColor, grid);
}


