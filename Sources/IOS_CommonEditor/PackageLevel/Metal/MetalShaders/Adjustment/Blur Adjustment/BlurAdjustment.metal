//
//  ColorAdjustment.metal
//  VideoInvitation
//
//  Created by HKBeast on 11/09/23.
//

#include <metal_stdlib>
#import "ColorConversion.h"
using namespace metal;


constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];
constant float gaussianWeights[9] = {0.05, 0.09, 0.12, 0.15, 0.18, 0.15, 0.12, 0.09, 0.05};

kernel void BlurAdjustment(
    texture2d<float, access::read> inputTexture [[texture(0)]],
    texture2d<float, access::write> outputTexture [[texture(1)]],
   //
                           constant float *weights [[buffer(0)]],  // Gaussian weights
    constant float &texelWidthOffset [[buffer(1)]],  // Texel size for width and height
    constant float &texelHeightOffset [[buffer(2)]],    // Gaussian kernel radius
    constant int &blur [[buffer(3)]],    // Gaussian kernel radius

    uint2 gid [[thread_position_in_grid]]
                           ) {
                               
                               
                               if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) return;
                               
                               float2 texCoord = float2(gid.x, gid.y) / float2(outputTexture.get_width(), outputTexture.get_height());
                               float4 color = float4(0.0);
                               
                               // Horizontal and vertical offsets
                               for (int i = 0; i < 9; i++) {
                                   int offset = i - 4; // Center weight at index 4
                                   
                                   // Horizontal blur
                                   int sampleX = clamp(int(gid.x) + int(  texelWidthOffset * inputTexture.get_width()), 0, int(inputTexture.get_width()) - 1);
                                   
                                   
                                   int sampleY = clamp(int(gid.y) + int( offset * texelHeightOffset * inputTexture.get_height()), 0, int(inputTexture.get_height()) - 1);
                                   //int(gid.y) + int(offset * texelHeightOffset * inputTexture.get_height()); //int(gid.y); // Same row for horizontal blur
                                   if (sampleX >= 0 && sampleX < inputTexture.get_width() && sampleY >= 0 && sampleY < inputTexture.get_height()) { // Boundary check
                                       color += inputTexture.read(uint2(sampleX, sampleY)).rgba * gaussianWeights[i];
                                   }
                               }
                               
//                               for (int i = 0; i < 9; i++) {
//                                   int offset = i - 4; // Center weight at index 4
//
////                                   // Vertical blur
//                                   int sampleX = int(gid.x); // Same column for vertical blur
//                                   sampleY = int(gid.y) + int(offset * texelHeightOffset * inputTexture.get_height());
//                                   if (sampleY >= 0 && sampleY < inputTexture.get_height()) { // Boundary check
//                                       color +=  color.rgba* gaussianWeights[i];  //inputTexture.read(uint2(sampleX, sampleY)).rgb * gaussianWeights[i];
//                                   }
//                               }
                               
                               
                               // Write the final blurred color to the output texture
                               outputTexture.write(float4(color), gid);
                           }
    
    
//    int width = inputTexture.get_width();
//    int height = inputTexture.get_height();
//
//    if (gid.x >= width || gid.y >= height) return;
//
//    // Intermediate storage for the horizontal pass
//    float4 intermediateColor = float4(0.0);
//
//    // Horizontal blur (X-axis)
//    for (int i = -radius; i <= radius; ++i) {
//        int sampleX = clamp(int(gid.x) + i, 0, width - 1); // Clamp to avoid out-of-bounds access
//        float weight = 0.33;//weights[i + radius];
//        intermediateColor += inputTexture.read(uint2(sampleX, gid.y)) * weight;
//    }
//
//    // Final storage for the vertical pass
//    float4 finalColor = float4(1.0,1.0,0.0,1.0);
//
//    // Vertical blur (Y-axis)
//    for (int j = -radius; j <= radius; ++j) {
//        int sampleY = clamp(int(gid.y) + j, 0, height - 1); // Clamp to avoid out-of-bounds access
//        float weight = 0.66;  // weights[j + radius];
//        finalColor += intermediateColor * weight; // Apply weight to the intermediate result
//    }
//
//    // Write the final color to the output texture
//    outputTexture.write(intermediateColor, gid);
//}

//kernel void BlurAdjustment(metal::texture2d<float, metal::access::sample> inputTexture [[ texture(0) ]],
//                           metal::texture2d<float, metal::access::write> outputTexture [[ texture(1) ]],
//                        constant float& blur [[ buffer(0) ]],
//                           uint2 position [[thread_position_in_grid]]) {
//    
//    // Texture dimensions
//    int width = inputTexture.get_width();
//    int height = inputTexture.get_height();
//    
//    // Skip out-of-bounds pixels
//    if (position.x >= width || position.y >= height) {
//        return;
//    };
//    
//    
//       int radius = int(ceil( blur*5)); // Kernel radius
//
//
//       float4 result = float4(0.0);
//       float weightSum = 0.0;
//
//       for (int i = -radius; i <= radius; i += 8) { // Skip alternate pixels
//           for (int j = -radius; j <= radius; j += 8) { // Skip alternate pixels
//               int sampleX = clamp(int(position.x) + i, 0, width - 1);
//               int sampleY = clamp(int(position.y) + j, 0, height - 1);
//               float weight = exp(-float(i * i + j * j) / (2.0 * blur * blur));
//               result += inputTexture.read(uint2(sampleX, sampleY)) * weight;
//               weightSum += weight;
//           }
//       }
//
//       result /= weightSum;
//    outputTexture.write(result, position);
//    
//    
//    
//    
////
////    float sigma = blur;
////       // Define Gaussian kernel radius
////       int radius = int(ceil(3.0 * blur)); // Use 3-sigma rule for kernel size
////
////       // Initialize output color and normalization factor
////       float4 result = float4(0.0);
////       float weightSum = 0.0;
////
////       // 2D Gaussian blur computation
////       for (int y = -radius; y <= radius; ++y) {
////           for (int x = -radius; x <= radius; ++x) {
////               // Compute weight for the current offset
////               float distanceSquared = float(x * x + y * y);
////               float weight = exp(-distanceSquared / (2.0 * sigma * sigma));
////
////               // Compute texture sample coordinates
////               int sampleX = clamp(int(position.x) + x, 0, width - 1);
////               int sampleY = clamp(int(position.y) + y, 0, height - 1);
////
////               // Sample the input texture
////               float4 sampleColor = inputTexture.read(uint2(sampleX, sampleY));
////
////               // Accumulate weighted color
////               result += sampleColor * weight;
////               weightSum += weight;
////           }
////       }
////
////       // Normalize the result
////       result /= weightSum;
////
////       // Write the blurred result to the output texture
////       outputTexture.write(result, position);
//    
////    
////    // Constants
////        const float Pi = 6.28318530718; // Pi * 2
////        const float Directions = 8.0; // Number of blur directions
////        const float Quality = 10.0;     // Blur quality (steps per direction)
////        const float Size = 8.0;        // Blur size (radius)
////
////        // Texture dimensions
////        int width = inputTexture.get_width();
////        int height = inputTexture.get_height();
////
////        // Skip out-of-bounds pixels
////        if (position.x >= width || position.y >= height) return;
////
////        // Calculate normalized UV coordinates (0 to 1)
////        float2 uv =  float2(position) / float2(outputTexture.get_width(), outputTexture.get_height());
////
////        // Initial pixel color
////        float4 color = inputTexture.sample(sampler(coord::normalized), uv);
////
////        // Radius for blurring
////        float2 radius = blur/400.0 ; //Size / iResolution;
////
////        // Blur calculation
////        for (float d = 0.0; d < Pi; d += Pi / Directions) {
////            for (float i = 1.0 / Quality; i <= 1.0; i += 1.0 / Quality) {
////                float2 offset = float2(cos(d), sin(d)) * radius * i;
////                color += inputTexture.sample(sampler(coord::normalized), uv + offset);
////            }
////        }
////
////        // Normalize the final color
////        color /= (Quality * Directions);
////
////        // Write the result to the output texture
////    outputTexture.write(color, position);
//    
//    
//    
//    
//    
////    const auto textureSize = ushort2(destination.get_width(),
////                                     destination.get_height());
////    if (!deviceSupportsNonuniformThreadgroups) {
////        if (position.x >= textureSize.x || position.y >= textureSize.y) {
////            return;
////        }
////    }
////
////    const auto sourceValue = source.read(position);
////
////    auto labValue = denormalizeLab(rgb2lab(sourceValue.rgb));
//
//    //gaussian blur
//    
////    const int blurSize = blur;
////      int range = floor(blur/2.0);
////      
////      float4 colors = float4(0);
////      for (int x = -range; x <= range; x++) {
////          for (int y = -range; y <= range; y++) {
////              float4 color = texture.read(uint2(position.x+x,
////                                                  position.y+y));
////              colors += color;
////          }
////
////      }
////
////      float4 finalColor = colors/float(blur*blur);
////        destination.write(finalColor, position);
//
////    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
////     const float2 textureCoordinate = float2(position) / float2(outputTexture.get_width(), outputTexture.get_height());
////     const half radius = half(blur) / 100.0h;
////     const float x = textureCoordinate.x;
////     const float y = textureCoordinate.y;
////     
////     // 高斯模糊卷积核
////     const float3x3 matrix = float3x3({1.0, 2.0, 1.0}, {2.0, 4.0, 2.0}, {1.0, 2.0, 1.0});
////    float4 result = float4(0.0h);
////     for (int i = 0; i < 9; i++) {
////         int a = i % 3; int b = i / 3;
////         const float4 sample = inputTexture.sample(quadSampler, float2(x + (a-1) * radius, y + (b-1) * radius));
////         result += sample * matrix[a][b];
////     }
////     
////     const float4 outColor = result / 16.0h;
////     outputTexture.write(outColor, position);
//    
////    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
////       const float2 offset = float2(position) / float2(destination.get_width(), destination.get_height());
////       const half radius = half(blur);
////    
////    float width = texture.get_width();
////    float height = texture.get_width();
////    float xPixel = radius;
////    float yPixel = radius;
////    
////    
////    float3 sum = float3(0.0, 0.0, 0.0);
////
////    // 9 tap filter
////      sum += texture.sample(quadSampler, float2(offset.x - 4.0*xPixel, offset.y - 4.0*yPixel)).rgb * 0.05;
////      sum += texture.sample(quadSampler, float2(offset.x - 3.0*xPixel, offset.y - 3.0*yPixel)).rgb * 0.09;
////      sum += texture.sample(quadSampler, float2(offset.x - 2.0*xPixel, offset.y - 2.0*yPixel)).rgb * 0.12;
////      sum += texture.sample(quadSampler, float2(offset.x - 1.0*xPixel, offset.y - 1.0*yPixel)).rgb * 0.15;
////      
////      sum += texture.sample(quadSampler, offset).rgb * 0.18;
////      
////      sum += texture.sample(quadSampler, float2(offset.x + 1.0*xPixel, offset.y + 1.0*yPixel)).rgb * 0.15;
////      sum += texture.sample(quadSampler, float2(offset.x + 2.0*xPixel, offset.y + 2.0*yPixel)).rgb * 0.12;
////      sum += texture.sample(quadSampler, float2(offset.x + 3.0*xPixel, offset.y + 3.0*yPixel)).rgb * 0.09;
////      sum += texture.sample(quadSampler, float2(offset.x + 4.0*xPixel, offset.y + 4.0*yPixel)).rgb * 0.05;
////
////
////    float4 outColor;
////    outColor.rgb = sum;
////    outColor.a = 1.0;
////
////    destination.write(outColor, position); //write(labValue, position);
//}
