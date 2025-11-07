//
//  BlackAndWhiteFilter.metal
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

#include <metal_stdlib>
using namespace metal;

kernel void BlackAndWhiteFilter(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                                texture2d<float, access::write> outputTexture [[ texture(1) ]],
                                uint2 grid [[ thread_position_in_grid ]]) {
    if (grid.x >= inputTexture.get_width() || grid.y >= inputTexture.get_height()) {
        return;
    }

    // Read the input color
    float4 inColor = inputTexture.read(grid);

    // Calculate the grayscale intensity using luminance
    float luminance = dot(inColor.rgb, float3(0.299, 0.587, 0.114));

    // Define black, white, and gray detection thresholds
    const float blackThreshold = 0.05;  // Luminance threshold close to black
    const float whiteThreshold = 0.95;  // Luminance threshold close to white

    // Check if the luminance value is very close to black or white
    if (luminance < blackThreshold) {
        // Pixel is considered black
        float4 blackColor = float4(0.0, 0.0, 0.0, inColor.a);
        outputTexture.write(blackColor, grid);
    } else if (luminance > whiteThreshold) {
        // Pixel is considered white
        float4 whiteColor = float4(1.0, 1.0, 1.0, inColor.a);
        outputTexture.write(whiteColor, grid);
    } else {
        // Pixel is considered gray (intermediate luminance)
        float4 grayColor = float4(luminance, luminance, luminance, inColor.a);
        outputTexture.write(grayColor, grid);
    }
}
