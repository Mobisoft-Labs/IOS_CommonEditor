//
//  FalseColorFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

// Define the first and second colors for false color mapping
constant float3 firstColor = float3(0.0, 0.0, 0.5); // Blue color for low intensity
constant float3 secondColor = float3(1.0, 0.0, 0.0); // Red color for high intensity

// Helper constant for luminance calculation (standard luminance weights)
constant float3 luminanceWeighting = float3(0.299, 0.587, 0.114);

kernel void FalseColorFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                             texture2d<float, access::write> outputTexture [[ texture(1) ]],
                             uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Read the input pixel color
    float4 inColor = inputTexture.read(grid);

    // Calculate luminance based on RGB components
    float luminance = dot(inColor.rgb, luminanceWeighting);

    // Interpolate between the two colors based on luminance
    // We map luminance to blend between firstColor and secondColor
    float3 falseColor = mix(firstColor, secondColor, luminance);

    // Write the false color result with the original alpha channel
    outputTexture.write(float4(falseColor, inColor.a), grid);
}
