//
//  MaskAdjustment.metal
//  VideoInvitation
//
//  Created by J D on 11/10/25.
//

#include <metal_stdlib>
using namespace metal;

struct Params {
    uint2 sourceSize;  // T1 size
    uint2 maskSize;    // T2 size
};

kernel void MaskAdjustment(
    texture2d<float, access::sample> sourceTexture [[texture(0)]], // T1
    texture2d<float, access::sample> maskTexture   [[texture(1)]], // T2
    texture2d<float, access::write> outputTexture [[texture(2)]],
    constant Params& params [[buffer(0)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= params.sourceSize.x || gid.y >= params.sourceSize.y)
        return;

    float4 sourceColor = sourceTexture.read(gid);

//    // Step 1: Compute where the mask should appear in T1
//    float t1Aspect = float(params.sourceSize.x) / float(params.sourceSize.y);
//    float t2Aspect = float(params.maskSize.x) / float(params.maskSize.y);

//    // We are assuming T2 is applied width-wise, and center-aligned vertically
//    uint maskDisplayHeight = uint(float(params.sourceSize.x) / t2Aspect);
//    int verticalOffset = (int(params.sourceSize.y) - int(maskDisplayHeight)) / 2;
//
    float maskAlpha = 0.0;

    // Check if this pixel lies in the vertical region where the mask is applied
//    if (int(gid.y) >= verticalOffset && int(gid.y) < verticalOffset + int(maskDisplayHeight)) {
//        // Map current gid to mask texture UV
//        float2 maskUV;
//        maskUV.x = float(gid.x) / float(params.sourceSize.x);
//        maskUV.y = float(gid.y - verticalOffset) / float(maskDisplayHeight);
//
//        float4 maskColor = maskTexture.sample(sampler(address::clamp_to_edge), maskUV);
//        maskAlpha = maskColor.r; // or .a depending on mask format
//    }
    // Compute mask placement based on orientation
    float2 maskDisplaySize;
    float2 offset;

    // Calculate aspect ratio
    float t2Aspect = float(params.maskSize.x) / float(params.maskSize.y);
    float t1Aspect = float(params.sourceSize.x) / float(params.sourceSize.y);

    if (params.sourceSize.x > params.sourceSize.y) {
        // Horizontal → match height
        maskDisplaySize.y = float(params.sourceSize.y);
        maskDisplaySize.x = maskDisplaySize.y * t2Aspect;
    } else {
        // Vertical → match width
        maskDisplaySize.x = float(params.sourceSize.x);
        maskDisplaySize.y = maskDisplaySize.x / t2Aspect;
    }

    // Calculate offset to center the mask
    offset.x = (float(params.sourceSize.x) - maskDisplaySize.x) * 0.5;
    offset.y = (float(params.sourceSize.y) - maskDisplaySize.y) * 0.5;

        uint maskDisplayHeight = uint(float(params.sourceSize.x) / t2Aspect);

    float2 pixel = float2(gid);
            float2 maskUV;
            maskUV.x = float(gid.x) / float(params.sourceSize.x);
            maskUV.y = float(gid.y) / float(maskDisplayHeight);
    
            float4 maskColor = maskTexture.sample(sampler(address::clamp_to_edge), maskUV);
    sourceColor.a =   maskColor.a; // or .a depending on mask format
    
//    // Check if pixel lies inside mask area
//    if (pixel.x >= offset.x && pixel.x < offset.x + maskDisplaySize.x &&
//        pixel.y >= offset.y && pixel.y < offset.y + maskDisplaySize.y) {
//        
//        // Normalize to [0,1] for mask sampling
//        float2 maskUV = (pixel - offset) / maskDisplaySize;
//        
//        constexpr sampler quadSampler(coord::normalized, address::clamp_to_edge, filter::linear);
//
//        // Sample the tile image texture with the wrapped UV coordinates
//        const float4 maskColor = maskTexture.sample(quadSampler,maskUV);
//
//        
////        constexpr sampler quadSampler(coord::normalized, address::repeat, filter::linear);
////        float4 maskColor =  maskTexture.sample(quadSampler, maskUV);
//// maskTexture.sampler(sampler(address::clamp_to_edge), maskUV);
//        maskAlpha = maskColor.r; // or .a depending on your mask format
//        sourceColor.r = 0.4;
//        sourceColor.g = 0.5;
//
//    } else {
//        sourceColor.b = 1.0;
//        maskAlpha = 0.0;
//       // sourceColor = float4(0.0, 0.0, 0.0, 0.0); // Fully transparent
//    }
  

    // Output final color
//    float4 outColor = sourceColor;
//    outColor.a *= maskAlpha;

    outputTexture.write(sourceColor, gid);
}
