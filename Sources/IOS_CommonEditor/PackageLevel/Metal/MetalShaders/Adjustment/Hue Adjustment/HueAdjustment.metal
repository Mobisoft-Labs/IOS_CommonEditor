//
//  HueAdjustment.metal
//  VideoInvitation
//
//  Created by HKBeast on 14/09/23.
//



#include <metal_stdlib>
//#import "ColorConversion.h"
using namespace metal;

constant float4 kRGBToYPrime = float4(0.299, 0.587, 0.114, 0.0);
constant float4 kRGBToI = float4(0.595716, -0.274453, -0.321263, 0.0);
constant float4 kRGBToQ = float4(0.211456, -0.522591, 0.31135, 0.0);
constant float4 kYIQToR = float4(1.0, 0.9563, 0.6210, 0.0);
constant float4 kYIQToG = float4(1.0, -0.2721, -0.6474, 0.0);
constant float4 kYIQToB = float4(1.0, -1.1070, 1.7046, 0.0);

constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

kernel void HueAdjustment(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                        texture2d<float, access::write> outputTexture [[ texture(1) ]],
                        constant float *hueAdjust [[ buffer(0) ]],
                        uint2 grid [[thread_position_in_grid]]) {
    
    const auto textureSize = ushort2(outputTexture.get_width(),
                                     outputTexture.get_height());
    
    if (grid.x >= outputTexture.get_width() || grid.y >= outputTexture.get_height()) {
            return;
        }
    
//    float2 uv = float2(grid) / float2(outputTexture.get_width(),outputTexture.get_height());
//        float2 dist = uv - float2(0.5);
//    float radius = *hueAdjust;
//    radius = radius/6.28;
//    
//    float mask = 1.0 - smoothstep(radius - (radius * 0.01),
//                                 radius + (radius * 0.01),
//                                 dot(dist, dist) * 4.0);
//
//    float4 color = inputTexture.read(grid);
//    color.a *= mask;
//
//    outputTexture.write(color, grid);
//
//    return ;
//    if (!deviceSupportsNonuniformThreadgroups) {
//        if (position.x >= textureSize.x || position.y >= textureSize.y) {
//            return;
//        }
//    }

//    const auto sourceValue = source.read(position);
//
//    auto color = denormalizeLab(rgb2lab(sourceValue.rgb));
//    // Convert the color to HSV
//        float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
//        float4 p = mix(float4(color.bg, K.wz), float4(color.gb, K.xy), step(color.b, color.g));
//        float4 q = mix(float4(p.xyw, color.r), float4(color.r, p.yzx), step(p.x, color.r));
//
//        // Adjust the hue
//        float d = q.x - min(q.w, q.y);
//        float e = 1.0e-10;
//        float4 hueShiftedColor = q + float4(d, d, d, 0.0) * (hue + e);
//
//        // Convert the color back to RGB
//        float4 k = float4(q.z, hueShiftedColor.yz, p.w);
//        float3 inColor = float3(k.r,k.g,k.b);
    
    // harbetrh
    const float4 inColor = inputTexture.read(grid);
    
    // Convert to YIQ
    const float YPrime = dot(inColor, kRGBToYPrime);
    half I = dot(inColor, kRGBToI);
    half Q = dot(inColor, kRGBToQ);
    
    // Calculate the hue and chroma
    float hue = atan2(Q, I);
    const float chroma = sqrt(I * I + Q * Q);
    
    // Make the user's adjustments
    hue += (- *hueAdjust);
    
    // Convert back to YIQ
    Q = chroma * sin(hue);
    I = chroma * cos(hue);
    
    // Convert back to RGB
    const float4 yIQ = float4(YPrime, I, Q, 0.0h);
    const float4 outColor = float4(dot(yIQ, kYIQToR), dot(yIQ, kYIQToG), dot(yIQ, kYIQToB), inColor.a);
    

    outputTexture.write(outColor, grid); //write(labValue, position);
}
