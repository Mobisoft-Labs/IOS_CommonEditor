#include <metal_stdlib>
using namespace metal;

//kernel void TileAdjustment(texture2d<float, access::sample> source [[ texture(0) ]],
//                           texture2d<float, access::write> destination [[ texture(1) ]],
//                           constant float& tileFrequency [[ buffer(0) ]],
//                           uint2 position [[ thread_position_in_grid ]]) {
//    // Get the size of the destination texture
//    const auto destWidth = destination.get_width();
//    const auto destHeight = destination.get_height();
//    
//    // Get the size of the source texture
////    const auto srcWidth = source.get_width();
////    const auto srcHeight = source.get_height();
//    
//    // Calculate the normalized texture coordinates (0.0 to 1.0)
//    const float x = float(position.x) / float(destWidth/4);
//    const float y = float(position.y) / float(destHeight/4);
//    const float2 textureCoordinate = float2(x, y);
//    
//    // Calculate the UV coordinates for tiling
//    const float2 uv = textureCoordinate * float2(tileFrequency);
//    
//    // Sampler configuration with linear filtering and repeat addressing
//    constexpr sampler quadSampler(coord::normalized, address::repeat, filter::linear);
//    
//    // Sample the source texture with the calculated UV coordinates
//    const float4 outColor = source.sample(quadSampler, uv);
//    
//    // Write the sampled color to the destination texture
//    destination.write(outColor, position);
//}
//kernel void TileAdjustment(texture2d<float, access::sample> source [[ texture(0) ]],
//                           texture2d<float, access::write> destination [[ texture(1) ]],
//                           texture2d<float, access::write> tileImage [[ texture(2) ]],
//                           constant float& tileFrequency [[ buffer(0) ]],
//                           uint2 position [[ thread_position_in_grid ]]) {
//    // Get the size of the destination texture
//    const auto destWidth = destination.get_width();
//    const auto destHeight = destination.get_height();
//    
//    // Calculate the normalized texture coordinates (0.0 to 1.0)
//    const float x = float(position.x) / float(destWidth);
//    const float y = float(position.y) / float(destHeight);
//    const float2 textureCoordinate = float2(x, y);
//    
//    // Calculate the UV coordinates for tiling
//    const float2 uv = textureCoordinate * float2(tileFrequency);
//    
//    // Sampler configuration with nearest filtering and repeat addressing
//    constexpr sampler quadSampler(coord::normalized, address::repeat, filter::nearest);
//    
//    // Sample the source texture with the calculated UV coordinates
//    const float4 outColor = tileImage.sample(quadSampler, uv);
//    
//    // Write the sampled color to the destination texture
//    destination.write(outColor, position);
//}
kernel void TileAdjustment(texture2d<float, access::sample> source [[ texture(0) ]],
                           texture2d<float, access::write> destination [[ texture(1) ]],
                           texture2d<float, access::sample> tileImageTexture [[ texture(2) ]],
                           constant float& tileFrequency [[ buffer(0) ]],
                           uint2 position [[ thread_position_in_grid ]]) {
    // Get the size of the destination texture
    const auto destWidth = destination.get_width();
    const auto destHeight = destination.get_height();

    // Get the size of the tile image texture
    const auto tileWidth = tileImageTexture.get_width();
    const auto tileHeight = tileImageTexture.get_height();

    // Calculate the normalized texture coordinates (0.0 to 1.0) for the destination texture
    const float x = float(position.x) / float(destWidth);
    const float y = float(position.y) / float(destHeight);
    const float2 textureCoordinate = float2(x, y);

    // Calculate the UV coordinates for tiling
    const float2 uv = textureCoordinate * float2(tileFrequency);

    // Wrap UV coordinates to stay within the bounds of the tile image texture
    const float2 wrappedUV = fract(uv);

    // Sampler configuration with linear filtering and repeat addressing
    constexpr sampler quadSampler(coord::normalized, address::repeat, filter::linear);

    // Sample the tile image texture with the wrapped UV coordinates
    const float4 tileColor = tileImageTexture.sample(quadSampler, wrappedUV);

    // Write the sampled color to the destination texture
    destination.write(tileColor, position);
}
