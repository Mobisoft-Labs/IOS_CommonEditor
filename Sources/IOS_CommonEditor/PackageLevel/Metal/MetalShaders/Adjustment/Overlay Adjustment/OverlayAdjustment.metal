//
//  OverlayAdjustment.metal
//  VideoInvitation
//
//  Created by HKBeast on 15/09/23.
//

#include <metal_stdlib>
using namespace metal;


kernel void OverlayAdjustment(texture2d<float, access::write> outputTexture [[texture(2)]],
                           texture2d<float, access::read> inputTexture [[texture(0)]],
                           texture2d<float, access::sample> inputTexture2 [[texture(1)]],
                           constant float *intensity [[buffer(0)]],
                           uint2 grid [[thread_position_in_grid]]) {
    //alpha blend
    const float4 inColor = inputTexture.read(grid);
    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    
    const float4 inColor2 = inputTexture2.sample(quadSampler, float2(float(grid.x) / outputTexture.get_width(), float(grid.y) / outputTexture.get_height()));
    
    const float4 outColor(mix(inColor.rgb, inColor2.rgb, inColor2.a * float(*intensity)), inColor.a);
    
    
    
    outputTexture.write(outColor, grid);
}
