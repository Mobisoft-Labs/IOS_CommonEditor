//
//  OilPaintingFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

//#include <metal_stdlib>
//using namespace metal;
//
//constant float3 tint = float3(0.5, 0.2, 0.8); // RGB tint values for the filter
//
//// Pseudo-random number generator using pixel coordinates
//float rand2D(uint2 coords) {
//    const float a = 12.9898;
//    const float b = 78.233;
//    const float c = 43758.5453;
//    float t = float(coords.x) * a + float(coords.y) * b;
//    float sinT = sin(t) * c;
//    return fract(sinT);
//}
//
//kernel void OilPaintingFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
//                              texture2d<float, access::write> outputTexture [[ texture(1) ]],
//                              uint2 grid [[ thread_position_in_grid ]]) {
//    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
//        return;
//    }
//
//    // Read the input color
//    float4 inColor = inputTexture.read(grid);
//
//    // Apply a subtle color shift to create an "oil painting" effect, similar to tinting
//    float3 oilTintedColor = inColor.rgb * tint;
//
//    // Add random noise to create more texture (this simulates the brushstroke effect)
//    float3 noise = float3(
//        (rand2D(grid) - 0.5) * 0.05, // Random noise in the range [-0.05, 0.05]
//        (rand2D(grid + uint2(1, 0)) - 0.5) * 0.05,
//        (rand2D(grid + uint2(0, 1)) - 0.5) * 0.05
//    );
//    oilTintedColor += noise;
//
//    // Ensure the color stays within the valid range [0, 1]
//    oilTintedColor = clamp(oilTintedColor, 0.0, 1.0);
//
//    // Write the final color with the original alpha value
//    float4 oilPaintColor = float4(oilTintedColor, inColor.a);
//    outputTexture.write(oilPaintColor, grid);
//}


#include <metal_stdlib>
using namespace metal;

constant float3 tint = float3(0.5, 0.2, 0.8); // RGB tint values for the filter

// Pseudo-random number generator using pixel coordinates
float rand2D(uint2 coords) {
    const float a = 12.9898;
    const float b = 78.233;
    const float c = 43758.5453;
    float t = float(coords.x) * a + float(coords.y) * b;
    float sinT = sin(t) * c;
    return fract(sinT);
}

kernel void SoftEleganceFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                              texture2d<float, access::write> outputTexture [[ texture(1) ]],
                              uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Read the input color
    float4 inColor = inputTexture.read(grid);

    // Apply a subtle color shift to create an "oil painting" effect, similar to tinting
    float3 oilTintedColor = inColor.rgb * tint;

    // Add random noise to create more texture (this simulates the brushstroke effect)
    float3 noise = float3(
        (rand2D(grid) - 0.5) * 0.05, // Random noise in the range [-0.05, 0.05]
        (rand2D(grid + uint2(1, 0)) - 0.5) * 0.05,
        (rand2D(grid + uint2(0, 1)) - 0.5) * 0.05
    );
    oilTintedColor += noise;

    // Ensure the color stays within the valid range [0, 1]
    oilTintedColor = clamp(oilTintedColor, 0.0, 1.0);

    // Write the final color with the original alpha value
    float4 oilPaintColor = float4(oilTintedColor, inColor.a);
    outputTexture.write(oilPaintColor, grid);
    
    
    
    
    // Get the pixel color from the source texture
    float4 color = inputTexture.read(grid);

    // Define the target colors for the effect
    float3 pinkColor = float3(1.0, 0.0, 1.0);  // Pinkish color (high red and blue, low green)
    float3 greenColor = float3(0.0, 1.0, 0.0); // Greenish color (high green, low red and blue)

    // and a negative warmth intensity will make the image more greenish
    color.rgb = mix(color.rgb, pinkColor, 0.2);

    // Write the modified color to the destination texture
    outputTexture.write(color, grid);
}

