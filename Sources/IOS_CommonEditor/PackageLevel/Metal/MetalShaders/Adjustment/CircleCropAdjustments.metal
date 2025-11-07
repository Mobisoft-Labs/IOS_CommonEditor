#include <metal_stdlib>
using namespace metal;

kernel void CircleCropAdjustments(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                                  texture2d<float, access::write> outputTexture [[ texture(1) ]],
                                  uint2 grid [[thread_position_in_grid]]) {
    
    const auto textureSize = ushort2(outputTexture.get_width(), outputTexture.get_height());
    
    // Ensure we don't exceed the bounds of the texture
    if (grid.x >= outputTexture.get_width() || grid.y >= outputTexture.get_height()) {
        return;
    }
    
    // Calculate normalized UV coordinates
    float2 uv = float2(grid) / float2(textureSize);
    
    // Calculate distance from the center of the texture
    float2 dist = uv - float2(0.5);
    
    // Set the radius for the circular crop
    float radius = 6.28;
    radius = radius / 6.28;
    
    // Calculate the mask based on the distance from the center
    float mask = 1.0 - smoothstep(radius - (radius * 0.01),
                                  radius + (radius * 0.01),
                                  dot(dist, dist) * 4.0);
    
    // Read the color from the input texture
    float4 color = inputTexture.read(grid);
    
    // Apply the mask to the alpha channel, making outside of the circle fully transparent
    if (mask <= 0.0) {
        color = float4(0.0, 0.0, 0.0, 0.0); // Fully transparent
    } else {
        color.a *= mask;
    }
    
    // Write the modified color to the output texture
    outputTexture.write(color, grid);
}
