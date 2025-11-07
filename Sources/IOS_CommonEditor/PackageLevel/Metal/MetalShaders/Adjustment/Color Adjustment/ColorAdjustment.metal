//
//  ColorAdjustment.metal
//  VideoInvitation
//
//  Created by HKBeast on 11/09/23.
//

#include <metal_stdlib>
using namespace metal;
#import "ColorConversion.h"

constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

kernel void ColorAdjustment(texture2d<float, access::sample> source [[ texture(0) ]],
                        texture2d<float, access::write> destination [[ texture(1) ]],
                        constant float3& color [[ buffer(0) ]],
                        uint2 position [[thread_position_in_grid]]) {
    const auto textureSize = ushort2(destination.get_width(),
                                     destination.get_height());
    if (!deviceSupportsNonuniformThreadgroups) {
        if (position.x >= textureSize.x || position.y >= textureSize.y) {
            return;
        }
    }

     auto sourceValue = source.read(position);
    
    auto labValue = denormalizeLab(rgb2lab(sourceValue.rgb));
    // Apply the new color only if alpha > 0.0
//    if (sourceValue.a > 0.0) {
//        // Set RGB values to the new color (white or any other provided color)
//        sourceValue.r = color.x;  // Red channel (1.0 for white)
//        sourceValue.g = color.y;  // Green channel (1.0 for white)
//        sourceValue.b = color.z;  // Blue channel (1.0 for white)
//    }
    
    
//    //contrast
    sourceValue.r = color.x;
    sourceValue.g = color.y;
    sourceValue.b = color.z;
//    labValue.a = source.a
    
     float4 inColor = source.read(position);
//    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    
//    inColor = float4(labValue,1.0);
//    const float4 inColor2 = source.sample(quadSampler, float2(float(position.x)  destination.get_width(), float(position.y) / destination.get_height()));
//    const float4 outColor(mix(inColor.rgb, inColor2.rgb, inColor2.a * float(1.0)), inColor.a);

    const auto resultValue = float4(sourceValue.rgb,1.0);

    destination.write(resultValue, position); //write(labValue, position);
}

////constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];
//
//kernel void ColorFilterOnImage(texture2d<float, access::sample> source [[ texture(0) ]],
//                        texture2d<float, access::write> destination [[ texture(1) ]],
//                        constant float3& color [[ buffer(0) ]],
//                        uint2 position [[thread_position_in_grid]]) {
//    const auto textureSize = ushort2(destination.get_width(),
//                                     destination.get_height());
//    if (!deviceSupportsNonuniformThreadgroups) {
//        if (position.x >= textureSize.x || position.y >= textureSize.y) {
//            return;
//        }
//    }
//
//     auto sourceValue = source.read(position);
//  
//    
//    auto labValue = denormalizeLab(rgb2lab(sourceValue.rgb));
//
//    
//    //contrast
////    if sourceValue.r = 0
//    sourceValue.r = color.x;
//    sourceValue.g = color.y;
//    sourceValue.b = color.z;
////    /*labValue*/.a = source.a
//    
//     float4 inColor = source.read(position);
////    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
////    if (sourceValue.a) <= 0.0 {
////       
////    };
//////
//    inColor = float4(labValue,sourceValue.a);
////    const float4 inColor2 = source.sample(quadSampler, float2(float(position.x)  destination.get_width(), float(position.y) / destination.get_height()));
////    const float4 outColor(mix(inColor.rgb, inColor2.rgb, inColor2.a * float(1.0)), inColor.a);
//
//    const auto resultValue = float4(sourceValue.rgb,sourceValue.a);
//
//    destination.write(resultValue, position); //write(labValue, position);
//}
// Function constant for device support
//constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

//kernel void ColorFilterOnImage(texture2d<float, access::sample> source [[ texture(0) ]],
//                               texture2d<float, access::write> destination [[ texture(1) ]],
//                               constant float3& color [[ buffer(0) ]],
//                               uint2 position [[ thread_position_in_grid ]]) {
//    
//    const auto textureSize = ushort2(destination.get_width(), destination.get_height());
//    
//    // Handle out-of-bounds threads for devices that don't support non-uniform threadgroups
//    if (!deviceSupportsNonuniformThreadgroups) {
//        if (position.x >= textureSize.x || position.y >= textureSize.y) {
//            return;
//        }
//    }
//
//    // Read the source color at the current position
//    auto sourceValue = source.read(position);
//    
//    // Convert the RGB to LAB for further processing (optional step depending on your needs)
//    auto labValue = denormalizeLab(rgb2lab(sourceValue.rgb));
//
//    // Replace the RGB values with the new color, but keep the original alpha (sourceValue.a)
//    sourceValue.rgb = color;  // Apply new RGB color
//    // The alpha (a) component remains unchanged
//    // sourceValue.a remains as is
//
//    // Write the updated color (with new RGB and original alpha) to the destination texture
//    destination.write(float4(sourceValue.rgb, sourceValue.a), position);
//}

//constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

//kernel void ColorFilterOnImage(texture2d<float, access::sample> source [[ texture(0) ]],
//                               texture2d<float, access::write> destination [[ texture(1) ]],
//                               constant float3& color [[ buffer(0) ]],
//                               uint2 position [[ thread_position_in_grid ]]) {
//    
//    const auto textureSize = ushort2(destination.get_width(), destination.get_height());
//
//    // Handle out-of-bounds threads for devices that don't support non-uniform threadgroups
//    if (!deviceSupportsNonuniformThreadgroups) {
//        if (position.x >= textureSize.x || position.y >= textureSize.y) {
//            return;
//        }
//    }
//
//    // Read the source color at the current position
//    auto sourceValue = source.read(position);
//    
//    // Modify only the RGB values (without affecting alpha)
//    sourceValue.r *= color.x; // Apply the red component of the new color
//    sourceValue.g *= color.y; // Apply the green component of the new color
//    sourceValue.b *= color.z; // Apply the blue component of the new color
//
//    // Optionally: If color.a is meant to influence brightness/intensity, apply it like this:
//    // sourceValue.rgb *= color.a; // Modulate RGB based on alpha, if necessary
//
//    // Preserve the original alpha channel (sourceValue.a)
//    
//    // Write the result to the destination texture
//    destination.write(float4(sourceValue.rgb, sourceValue.a), position);
//}

//constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

kernel void ColorFilterOnImage(texture2d<float, access::sample> source [[ texture(0) ]],
                               texture2d<float, access::write> destination [[ texture(1) ]],
                               constant float3& color [[ buffer(0) ]],  // This color can be white: float3(1.0, 1.0, 1.0)
                               uint2 position [[ thread_position_in_grid ]]) {
    
    const auto textureSize = ushort2(destination.get_width(), destination.get_height());

    // Handle out-of-bounds threads for devices that don't support non-uniform threadgroups
    if (!deviceSupportsNonuniformThreadgroups) {
        if (position.x >= textureSize.x || position.y >= textureSize.y) {
            return;
        }
    }

    // Read the source color at the current position
    auto sourceValue = source.read(position);
    
    // Apply the new color only if alpha > 0.0
   // if (sourceValue.a > 0.0) {
        // Set RGB values to the new color (white or any other provided color)
    sourceValue.r = color.x;//*sourceValue.a;  // Red channel (1.0 for white)
    sourceValue.g = color.y;//*sourceValue.a;  // Green channel (1.0 for white)
    sourceValue.b = color.z;//*sourceValue.a;  // Blue channel (1.0 for white)
  //  }
    
    // Preserve the original alpha channel
    destination.write(float4(sourceValue.rgb, sourceValue.a), position);
}
