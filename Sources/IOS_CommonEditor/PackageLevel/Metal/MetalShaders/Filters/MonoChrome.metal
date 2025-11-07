//
//  GrayFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

//#include <metal_stdlib>
//using namespace metal;
//
//kernel void GrayFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
//                       texture2d<float, access::write> outputTexture [[ texture(1) ]],
//                       uint2 grid [[ thread_position_in_grid ]]) {
//    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
//        return;
//    }
//
//    // Read the input color
//    float4 inColor = inputTexture.read(grid);
//
//    // Calculate the grayscale intensity using luminance
//    float luminance = dot(inColor.rgb, float3(0.299, 0.587, 0.114));
//    
//    // Create a grayscale color
//    float4 grayColor = float4(luminance, luminance, luminance, inColor.a);
//
//    // Write the grayscale color to the output texture
//    outputTexture.write(grayColor, grid);
//}


#include <metal_stdlib>
using namespace metal;

kernel void MonoChromeFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                           texture2d<float, access::write> outputTexture [[ texture(1) ]],
                           uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Read the input color at the current grid position
    float4 inColor = inputTexture.read(grid);

    // Increase exposure by multiplying RGB values with an exposure factor
    float exposureFactor = 1.25; // Adjust this value for stronger or weaker exposure
    float3 exposedColor = inColor.rgb * exposureFactor;

    // Clamp the color values to ensure they remain within [0, 1] range
    exposedColor = clamp(exposedColor, 0.0, 1.0);

    // Write the exposed color to the output texture
    outputTexture.write(float4(exposedColor, inColor.a), grid);
}

