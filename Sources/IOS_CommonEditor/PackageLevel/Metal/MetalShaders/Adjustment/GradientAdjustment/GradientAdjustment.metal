#include <metal_stdlib>
#import "ColorConversion.h"
using namespace metal;

constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

kernel void GradientAdjustment(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                               texture2d<float, access::write> outputTexture [[ texture(1) ]],
                               texture2d<float, access::sample> tileTexture [[ texture(2) ]],

                               constant float *gradientType [[ buffer(0) ]],
                               constant float3 *startColor [[ buffer(1) ]],
                               constant float3 *endColor [[ buffer(2) ]],
                               constant float *radius [[ buffer(3) ]],
                               constant float *angleInDegree [[ buffer(4) ]],
                               constant float *contentType [[ buffer(5) ]],
                               constant float &tileFrequency [[ buffer(6) ]],
                               uint2 position [[thread_position_in_grid]]) {
    
    
    if (*contentType == 1.0) {
        // Define the center point of the radial gradient
        float2 center = float2(outputTexture.get_width() / 2.0, outputTexture.get_height() / 2.0);
        float spread = max(outputTexture.get_width() / 2.0, outputTexture.get_height() / 2.0);
        
        float4 result = float4(0.0);
        
        if (*gradientType == 0.0) { // Linear Gradient
            
            float pi = 3.14159265359;
            // Invert the angle calculation to make the rotation clockwise
            float angleInDegrees = -*angleInDegree * 360.0;  // Note the negative sign
            float angle = angleInDegrees * pi / 180.0;
            
            float sx = center.x + spread * cos(angle);
            float sy = center.y + spread * sin(angle);
            
            float endAngle = (angleInDegrees + 180.0) * pi / 180.0;
            float ex = center.x + spread * cos(endAngle);
            float ey = center.y + spread * sin(endAngle);
            
            float2 start = float2(sx, sy);
            float2 end = float2(ex, ey);
            
            float2 uv = float2(position);
            float2 ab = end - start;
            float2 ap = uv - start;
            float len = length(ab);
            
            float t = clamp(dot(ab, ap) / (len * len), 0.0, 1.0);
            
            result = float4(mix(*startColor, *endColor, t), 1.0);
            
        } else { // Radial Gradient
            float distance = length(float2(position) - center);
            float minSide = min(outputTexture.get_width(), outputTexture.get_height());
            float maxRadius = (minSide / 2.0);
            float myRadius = minSide * *radius;
            
            float gradientValue = 1.0 - smoothstep(0.0, myRadius, distance);
            float3 interpolatedColor = mix(*startColor, *endColor, gradientValue);
            
            result = float4(interpolatedColor, 1.0);
        }
        
        // Write the gradient color to the output texture
        outputTexture.write(result, position);
    } else {
        
//        // Get the size of the destination texture
//        const auto destWidth = outputTexture.get_width();
//        const auto destHeight = outputTexture.get_height();
//
//        // Get the size of the tile image texture
//        const auto tileWidth = tileTexture.get_width();
//        const auto tileHeight = tileTexture.get_height();
//
//        // Calculate the normalized texture coordinates (0.0 to 1.0) for the destination texture
//        const float x = float(position.x) / float(destWidth);
//        const float y = float(position.y) / float(destHeight);
//        const float2 textureCoordinate = float2(x, y);
//
//        // Calculate the UV coordinates for tiling
//        const float2 uv = textureCoordinate * float2(tileFrequency);
//
//        // Wrap UV coordinates to stay within the bounds of the tile image texture
//        const float2 wrappedUV = fract(uv);
//
//        // Sampler configuration with linear filtering and repeat addressing
//        constexpr sampler quadSampler(coord::normalized, address::repeat, filter::linear);
//
//        // Sample the tile image texture with the wrapped UV coordinates
//        const float4 tileColor = tileTexture.sample(quadSampler, wrappedUV);
//
//        // Write the sampled color to the destination texture
//        outputTexture.write(tileColor, position);
        
        float destWidth  = outputTexture.get_width();
        float destHeight = outputTexture.get_height();

        float tileWidth  = tileTexture.get_width();
        float tileHeight = tileTexture.get_height();

        // normalized uv
        float2 uv = float2(
            float(position.x) / destWidth,
            (float(position.y) / destHeight) - 1.0
        );

        // aspect ratios
        float outputAspect = destWidth / destHeight;     // >1 wide, <1 tall
        float tileAspect   = tileWidth / tileHeight;     // for square = 1.0

        float2 correctedUV = uv;

        // --------------------------------------------------
        // UNIVERSAL SQUARE-PRESERVE LOGIC
        // --------------------------------------------------
        if (outputAspect > 1.0) {
            // Wide output (16:9)
            correctedUV.x *= outputAspect;
        } else if (outputAspect < 1.0) {
            // Tall output (9:16)
            correctedUV.y /= outputAspect;  // or *= (1/outputAspect)
        }

        // frequency
        correctedUV *= tileFrequency;

        // wrap
        float2 wrappedUV = fract(correctedUV);

        // sample
        constexpr sampler quadSampler(coord::normalized, address::repeat, filter::linear);
        float4 tileColor = tileTexture.sample(quadSampler, wrappedUV);

        outputTexture.write(tileColor, position);
    }
}
