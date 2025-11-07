//
//  Shaders.metal
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 18/01/23.
//


#include <metal_stdlib>
//#import "CPUGPUModels.h"
#import "ColorConversion.h"


using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textCoords [[ attribute(2) ]];
};

struct VertexOut{
    float4 position [[ position ]];
    float4 color;
    float2 textCoords;
};

struct ModalConstants{
    float4x4 modalMatrix;
    float4x4 parentProjectionMatrix;
    float4x4 animatedMatrix;
};

struct ContentType{
    float type;
};

struct Color{
    float4 color;
};

struct GradientInfo{
    float4 firstColor;
    float4 secondColor;
    float gradientType;
    float radius;
    
};
struct ContentInfo{
//    texture2d<float> texture;
    float type;
    float4 color;
//    GradientInfo gradientType;
};


//vertex VertexOut passThrough_V_F(device VertexIn *vIn [[ buffer(0) ]],
//                                       constant ModalConstants &constants [[buffer(1)]],
//                                       constant float &deltaTime [[buffer(2)]],
//                                        uint vertexID [[vertex_id]]) {
//    VertexOut vOut;
//    VertexIn vert = vIn[vertexID];
//
//
//    if (vertexID == 1) {
//
//        vOut.position =  constants.modalMatrix * float4(vert.position, 1);
//    }else{
//        vOut.position = float4(vert.position, 1);
//    }
//    vOut.position.xy += cos(deltaTime);
////    vOut.position.y += sin(constants.animateBy);
//    vOut.color = vert.color;
//    vOut.textCoords = vert.textCoords;
//    return vOut;
//}
vertex VertexOut standardVertexShader(const VertexIn vIn [[ stage_in ]],
                                 constant float &time [[buffer(3)]],
                                 constant ModalConstants &constants [[buffer(1)]],
                                 constant float &flipType_H [[buffer(2)]],
                                 constant float &flipType_V [[buffer(4)]])
                                {
//                                      {
    VertexOut vOut;
   // if (enableMVP == 0) {
        vOut.position =   constants.parentProjectionMatrix *  constants.modalMatrix  * constants.animatedMatrix * float4(vIn.position, 1);
//        vOut.position.x /= 800.0;
//        vOut.position.y /= 800.0;

//    }else {
//
//        vOut.position =  constants.modalMatrix * float4(vIn.position, 1);
//
//    }
  // vOut.position.xy += cos(constants.animateBy);
  //  vOut.position.y = 1.0 - vIn.position.y;
    vOut.color = vIn.color;
    
    vOut.textCoords =  vIn.textCoords;
    
//
//    float2 rotatedPosition = float2(cos(rotation) * vOut.position.x - sin(rotation) * vOut.position.y,
//                                    sin(rotation) * vOut.position.x + cos(rotation) * vOut.position.y);
//
//    vOut.position.xy = rotatedPosition
    if (flipType_V == 1.0){

        vOut.textCoords.y = 1.0 - vOut.textCoords.y;
    }

    if (flipType_H == 1.0) {

        vOut.textCoords.x = 1.0 - vOut.textCoords.x;
    }

    
    return vOut;
}
vertex VertexOut passThrough_vertexShader(const VertexIn vIn [[ stage_in ]],
                                       constant ModalConstants &constants [[buffer(1)]],
                                       constant float &deltaTime [[buffer(3)]],
                                          constant float &flipV[[buffer(4)]],
                                          constant float &flipH[[buffer(2)]]
                                          ){
    VertexOut vOut;
    vOut.position =  constants.parentProjectionMatrix * constants.modalMatrix  * constants.animatedMatrix *  float4(vIn.position, 1);
  // vOut.position.xy += cos(constants.animateBy);
//    vOut.position.y = 1.0 - vIn.position.y;
    vOut.color = vIn.color;
    vOut.textCoords = vIn.textCoords;
    vOut.textCoords.y = 1.0 - vOut.textCoords.y;
//    vOut.textCoords.x = 1.0 - vOut.textCoords.x;
    if (flipV == 1.0){

        vOut.textCoords.y = 1.0 - vOut.textCoords.y;
    }

    if (flipH == 1.0) {

        vOut.textCoords.x = 1.0 - vOut.textCoords.x;
    }


    return vOut;
}



fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]],                                          constant float2 &resolution [[buffer(0)]]){
    return vIn.color;
}

float4 replaceBySpecialID(){
    float4 color = float4(0.0,0.2,0.4,1.0);
    return color;
}

float4 replaceByTexture(VertexOut vIn,sampler sampler2d,
                          texture2d<float> texture ){
    float4 color = texture.sample(sampler2d, vIn.textCoords);
    return color;
}

float4 replaceByColor(float4 myColor){
    float4 color = myColor;
    return color;
}


float2 getProportionalOrigin(float2 st,float2 u_resolution,float2 position ) {
    float2 position1 = st - position;
if(u_resolution.x>u_resolution.y)
position1.x *= u_resolution.x / u_resolution.y;
else
position1.y /= u_resolution.x / u_resolution.y;
 
    return position1;
}

float smoothedge(float v,float2 resolution,float radius) {
    return smoothstep(radius, 1.000 / resolution.y, v);
}


float4 replaceByGradient(VertexOut vIn,GradientInfo gradientInfo,float2 resolution,float time){
   
    if (gradientInfo.gradientType == 0.0){
        float gradValue = float(gradientInfo.radius);
        float2 st = vIn.position.xy/resolution.xy;
        float df = length(0.5-st) - 0.005;
        float mixer =  smoothedge(df, resolution, gradValue);
        float4 color = mix(float4(gradientInfo.firstColor),float4(gradientInfo.secondColor),mixer);
        
        return color;
        
    }
    else{
        float pi = 22.0/7.0;
        float angleInDegrees = gradientInfo.radius;

         float spread = 0.5;
           float2 center = float2(0.5,0.5);

         float angle = angleInDegrees * pi /180.;
        float sx = center.x + spread * cos(angle);
        float sy = center.y + spread * sin(angle);
          // sx = center.x + width/2.0 * cos(angle);
          // sy = center.y +  height/2.0 * sin(angle);

         float endAngle = (angleInDegrees + 180.) * pi /180.;
        float ex = center.x + spread * cos(endAngle);
        float ey = center.y + spread * sin(endAngle);
        // float ex = center.x + width/2.0 * cos(endAngle);
        // float ey = center.y + height/2.0 * sin(endAngle);

        float2 start = float2(sx ,sy);
        float2 end = float2(ex ,ey);
        
        
        
        //  vec2 start = vec2(.6,1.0);
        // vec2 end = vec2(.4,0.0);
        float2 uv = vIn.position.xy / resolution.xy;
        float2 ab = end - start;
        float2 ap = uv - start;
        float len = length(ab);

        float t = clamp(dot(ab, ap) / len / len, -1.476, 1.424);

        float4 gl_FragColor = pow(mix(float4(gradientInfo.firstColor), float4(gradientInfo.secondColor),t), float4(0.5/0.5));
        
        return gl_FragColor;
        
    }
    
}

fragment float4 passThrough_fragmentShader(VertexOut vIn [[ stage_in ]],
                                           sampler sampler2d [[ sampler(0) ]],
                                           texture2d<float> texture [[ texture(0) ]],
                                           constant float &opacity[[buffer(2)]]){
    // Sample the texture at the given texture coordinates
    float4 color = texture.sample(sampler2d, vIn.textCoords);
    
    float4 color2 = color ;
    // Blend the color with transparency
    color.rgba *= opacity;

    // Return the color with adjusted alpha (transparent texture)
    return float4(color.rgba);
}
fragment float4 passThrough_fragmentShader2(VertexOut vIn [[ stage_in ]],
                                           sampler sampler2d [[ sampler(0) ]],
                                           texture2d<float> texture [[ texture(0) ]],
                                           constant float &opacity[[buffer(2)]]){
    // Sample the texture at the given texture coordinates
    float4 color = texture.sample(sampler2d, vIn.textCoords);
    
    // Blend the color with transparency
   // color.rgba //*= opacity;

    // Return the color with adjusted alpha (transparent texture)
    return float4(color.rgba);
}

// COLOR SHADER
fragment float4 colorFragmentShader(VertexOut vIn [[ stage_in ]],sampler sampler2d [[ sampler(0) ]],
                                          constant float2 &resolution [[buffer(1)]],
                                          constant float &time[[buffer(0)]],
                                          constant float &opacity[[buffer(2)]],
                                          constant float3 &color [[buffer(3)]]){
    float4 returnColor = (0.0);
    returnColor.rgb = color;
    returnColor.a = opacity;

    return returnColor;
}

#include <metal_stdlib>
using namespace metal;

fragment float4 imageFragmentShader(VertexOut vIn [[ stage_in ]],
                                    sampler sampler2d [[ sampler(0) ]],
                                    constant float &time [[buffer(0)]],
                                    constant float2 &resolution [[buffer(1)]],
                                    constant float &opacity [[buffer(2)]],
                                    texture2d<float> texture [[ texture(0) ]]) {
    // Sample the texture at the given texture coordinates
    float4 color = texture.sample(sampler2d, vIn.textCoords);
    
    // Blend the color with transparency
    color.a *= opacity;

    // Return the color with adjusted alpha (transparent texture)
    return float4(color.rgba);
}


//MARK: - Adjustment
constant bool deviceSupportsNonuniformThreadgroups [[ function_constant(0) ]];

kernel void adjustments(texture2d<float, access::sample> source [[ texture(0) ]],
                        texture2d<float, access::write> destination [[ texture(1) ]],
                        constant float& temperature [[ buffer(0) ]],
                        constant float& tint [[ buffer(1) ]],
                        uint2 position [[thread_position_in_grid]]) {
    const auto textureSize = ushort2(destination.get_width(),
                                     destination.get_height());
    if (!deviceSupportsNonuniformThreadgroups) {
        if (position.x >= textureSize.x || position.y >= textureSize.y) {
            return;
        }
    }

    const auto sourceValue = source.read(position);
    
//    auto labValue = denormalizeLab(rgb2lab(sourceValue.rgb));
   // auto labValue2 = denormalizeLab(rgba8unorm<<#typename T#>>(sourceValue.bgra));

//    labValue += temperature;
//
//    labValue.g += tint * 10.0f;
    
    //contrast
//    labValue.r = ((labValue.r - float(0.5)) * tint + float(0.5));
//    labValue.g = ((labValue.g - float(0.5)) * tint + float(0.5));
//    labValue.b = ((labValue.b - float(0.5)) * tint + float(0.5));
    
//    color inverion
//    labValue.r = tint - labValue.r;
//    labValue.g = tint - labValue.g;
//    labValue.b = tint - labValue.b;
    
    
//    vibrance
//    labValue = dot(labValue.rgb, tint);

    //saturation
//       labValue = mix(float3(luminance), labValue.rgb, tint);
    
//    gamma
//    labValue = pow(labValue, float3(tint));
    
    //hue
    // Hue Constants
//     half4 kRGBToYPrime = half4(0.299, 0.587, 0.114, 0.0);
//     half4 kRGBToI = half4(0.595716, -0.274453, -0.321263, 0.0);
//     half4 kRGBToQ = half4(0.211456, -0.522591, 0.31135, 0.0);
//
//     half4 kYIQToR = half4(1.0, 0.9563, 0.6210, 0.0);
//     half4 kYIQToG = half4(1.0, -0.2721, -0.6474, 0.0);
//     half4 kYIQToB = half4(1.0, -1.1070, 1.7046, 0.0);
//
//    // Convert to YIQ
//       float YPrime = dot((labValue,sourceValue.a), kRGBToYPrime);
//       float I = dot ((labValue,sourceValue.a), kRGBToI);
//       float Q = dot ((labValue,sourceValue.a), kRGBToQ);
//
//       // Calculate the hue and chroma
//       float hue = atan2(Q, I);
//       float chroma = sqrt(I * I + Q * Q);
//
//       // Make the user's adjustments
//       hue += (-tint); //why negative rotation?
//
//       // Convert back to YIQ
//       Q = chroma * sin (hue);
//       I = chroma * cos (hue);
//
//       // Convert back to RGB
//       half4 yIQ = half4(YPrime, I, Q, 0.0);
//    labValue.r = dot(yIQ, kYIQToR);
//    labValue.g = dot(yIQ, kYIQToG);
//    labValue.b = dot(yIQ, kYIQToB);
//
    

    
    
    

    
//    float2 src_size = float2(1.0 / 768.0, 1.0 / 1024.0);
//    labValue = ((labValue * -tint) + (0.5)) / -tint;
    
//    labValue = clipLab(labValue);
//
//    labValue = normalizeLab(labValue);
////
//    const auto resultValue = float4(lab2rgb(labValue), sourceValue.a);
//    sourceValue.bgra = sourceValue.bgra * float(0.5)
//    destination.write(outColor, position); //write(labValue, position);
}




kernel void C7OverlayBlend(texture2d<float, access::write> outputTexture [[texture(2)]],
                           texture2d<float, access::read> inputTexture [[texture(0)]],
                           texture2d<float, access::sample> inputTexture2 [[texture(1)]],
                           constant float *intensity [[buffer(0)]],
                           uint2 grid [[thread_position_in_grid]]) {
    //alpha blend
    const float4 inColor = inputTexture.read(grid);
    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    
    const float4 inColor2 = inputTexture2.sample(quadSampler, float2(float(grid.x) / outputTexture.get_width(), float(grid.y) / outputTexture.get_height()));
    const float4 outColor(mix(inColor.rgb, inColor2.rgb, inColor2.a * float(*intensity)), inColor.a);
    
    
    
    
    
    
    
    
    
    
//    intensity =float(0.5)
//    const float4 inColor = inputTexture.read(grid);
//    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
//    float2 textureCoordinate = float2(float(grid.x) / outputTexture.get_width(), float(grid.y) / outputTexture.get_height());
//    const float4 overlay = inputTexture2.sample(quadSampler, textureCoordinate);
//
//    float ra;
//    if (2.0h * inColor.r < inColor.a) {
//        ra = 2.0h * overlay.r * inColor.r + overlay.r * (1.0h - inColor.a) + inColor.r * (1.0h - overlay.a);
//    } else {
//        ra = overlay.a * inColor.a - 2.0h * (inColor.a - inColor.r) * (overlay.a - overlay.r) + overlay.r * (1.0h - inColor.a) + inColor.r * (1.0h - overlay.a);
//    }
//
//    float ga;
//    if (2.0h * inColor.g < inColor.a) {
//        ga = 2.0h * overlay.g * inColor.g + overlay.g * (1.0h - inColor.a) + inColor.g * (1.0h - overlay.a);
//    } else {
//        ga = overlay.a * inColor.a - 2.0h * (inColor.a - inColor.g) * (overlay.a - overlay.g) + overlay.g * (1.0h - inColor.a) + inColor.g * (1.0h - overlay.a);
//    }
//
//    float ba;
//    if (2.0h * inColor.b < inColor.a) {
//        ba = 2.0h * overlay.b * inColor.b + overlay.b * (1.0h - inColor.a) + inColor.b * (1.0h - overlay.a);
//    } else {
//        ba = overlay.a * inColor.a - 2.0h * (inColor.a - inColor.b) * (overlay.a - overlay.b) + overlay.b * (1.0h - inColor.a) + inColor.b * (1.0h - overlay.a);
//    }
//
//
//
//    const float4 outColor = float4(ra, ga, ba, 1.0h);
//    const float4 output = mix(inColor, outColor, float(*intensity));
    
    outputTexture.write(outColor, grid);
}
