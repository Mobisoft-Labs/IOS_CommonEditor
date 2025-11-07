//
//  Conversion.swift
//  VideoInvitation
//
//  Created by HKBeast on 25/08/23.
//

import Foundation
import simd
import Metal
import MetalKit
import UIKit

public class Conversion{
    
//    public static var context = CIContext()
    public static let shared : Conversion = Conversion()
    static func mapValue(_ value: Float, fromRange: ClosedRange<Float>, toRange: ClosedRange<Float>) -> Float {
        if fromRange == toRange{
            return value
        }
        let normalizedValue = (value - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        let mappedValue = normalizedValue * (toRange.upperBound - toRange.lowerBound) + toRange.lowerBound
        return mappedValue
    }
    
    static var logger: PackageLogger?
    
    
    //    func getDBValueForX(x:Double)->CGFloat{
    //        return  mapValue(x, fromRange: 0...1, toRange: -1...1)
    //    }
    //
    //    func getDBValueForY(y:Double)->CGFloat{
    //        return  mapValue(y, fromRange: 0...1, toRange: -1...1)
    //    }
    //
    
    static func setPackageLogger(logger: PackageLogger){
        self.logger = logger
    }
    
    static func setPositionForMetal(centerX:Float , centerY : Float) -> SIMD3<Float> {
        let x = mapValue((centerX), fromRange: 0...1, toRange: -1...1)
        let y = mapValue((centerY), fromRange: 0...1, toRange: -1...1)
        
        return SIMD3<Float>(Float(x),Float(y),0.0)
    }
    
    
    static func setDBValueForWidth(ref:CGSize = CGSize(width: 1.0, height: 1.0),value:Float)->Float{
        return  (mapValue(value, fromRange: 0...Float(ref.width), toRange: -1...1))
    }
    static func setDBValueForHeight(ref:CGSize = CGSize(width: 1.0, height: 1.0),value:Float)->Float{
        return  (mapValue(value, fromRange: 0...Float(ref.height), toRange: -1...1))
    }
    
    static func getDBValueContentType(type:String)->ContentType{
        return ContentType(rawValue: type)!
    }
    
    
    
    static func getDBValueImageSourceType(type:String)->ImageSourceType{
        return ImageSourceType(rawValue: type)!
    }
    
    static func convertRadiansToDegrees(_ radians: Float) -> Float {
        return radians * 180.0 / .pi
    }
    
    static func convertDegreesToRadians(_ degrees: Float) -> Float {
        return degrees * .pi / 180.0
    }
    
    
    
    static func loadTexture(image: UIImage,flip:Bool) -> MTLTexture?{
        var texture: MTLTexture? = nil
        
        
        //           let textureLoader = MTKTextureLoader(device: MetalDefaults.GPUDevice)
        var textureManager = TextureManager(device: MetalDefaults.GPUDevice)
        // let url = Bundle.main.url(forResource: imageName, withExtension: "jpg")
        //       return
        
        let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
        let options = [MTKTextureLoader.Option.origin: origin]
        
        do{
//            let cg = image.cgImage!
            texture = try textureManager.textureN(from: image,flip: flip)
        }catch let error as NSError{
            logger?.printLog("\(error)")
        }
        
      //  let img  = Conversion.textureToUIImage(texture!)
      //  print(img)
        return texture
        
    }
    
    static func cropRect(cropX: Float, cropY: Float, cropW: Float, cropH: Float)->(topLeft: float2, topRight: float2, bottomLeft: float2, bottomRight: float2){
        
        let topLeft = SIMD2(cropX, cropY)
        let topRight = SIMD2(cropX+cropW, cropY)
        let bottomLeft = SIMD2(cropX, cropX+cropY)
        let bottomRight = SIMD2(cropX+cropW, cropH+cropY)
        
        
        return(topLeft,topRight,bottomLeft,bottomRight)
    }
    
    static func convertOpacityForMetal(value:Int)->Float{
        return  (mapValue(Float(value), fromRange: 0...255, toRange: 0...1))
    }
    
//    static func loadTexture( data: Data) -> MTLTexture?{
//       var texture: MTLTexture? = nil
//
//        let textureLoader = MTKTextureLoader(device: MetalDefaults.GPUDevice)
//
//           let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
//           let options = [MTKTextureLoader.Option.origin: origin]
//
//           do{
//               texture = try textureLoader.newTexture(data: data , options: options)
//           }catch let error as NSError{
//               printLog(error)
//           }
//
//
//       return texture
//
//   }
    

    
    static func textureToUIImage(_ texture: MTLTexture) -> UIImage? {
       
           let width = texture.width
           let height = texture.height
           let rowBytes = texture.width * 4
           let dataSize = width * height * 4
           var byteArray = [UInt8](repeating: 0, count: dataSize)
           
           texture.getBytes(&byteArray, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
           
           let colorSpace = CGColorSpaceCreateDeviceRGB()
           let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
           let context = CGContext(data: &byteArray, width: width, height: height, bitsPerComponent: 8, bytesPerRow: rowBytes, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
           
           guard let cgImage = context?.makeImage() else {
               return nil
           }
        logger?.printLog("MEMORY LEAK _ IF PRINTING IN CONTINUOUSLY OTHERWISE IGNORE ")
           return UIImage(cgImage: cgImage)
        
        
        
       }
    static func getUIImage(texture: MTLTexture ,flipX:Bool = true, flipY:Bool = false) -> UIImage?{
               let kciOptions = [CIImageOption.colorSpace: CGColorSpaceCreateDeviceRGB(),
                                 CIContextOption.outputPremultiplied: true,
                                 CIContextOption.useSoftwareRenderer: false] as! [CIImageOption : Any]
               
               if let ciImageFromTexture = CIImage(mtlTexture: texture, options: kciOptions) {
                   let flippedCIImage = ciImageFromTexture.transformed(by: CGAffineTransform(scaleX: flipX ? 1 : -1, y: flipY ? 1 : -1))

                   if let cgImage = CIContext().createCGImage(flippedCIImage, from: flippedCIImage.extent) {
                       let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
                       return uiImage
                   }else{
                       return nil
                   }
               }else{
                   return nil
               }
           }
       
    
    static func textureToData(_ texture: MTLTexture) -> Data? {
            let width = texture.width
            let height = texture.height
            let rowBytes = texture.width * 4
            let dataSize = width * height * 4
            var byteArray = [UInt8](repeating: 0, count: dataSize)
            
            texture.getBytes(&byteArray, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
            
            return Data(bytes: &byteArray, count: dataSize)
        }
    
   static func setRotationForMetal(degree:Float)->Float{
        return convertDegreesToRadians(degree)
    }
    static func setOpacityForMetalView(value:Float)->Float{
        return Float(value)
    }
    
    static func setColorForMetalView(color:String)->SIMD3<Float>{
        
        let uicolor = color.convertIOSColorStringToUIColor()
            let r:Float = Float(uicolor.rgbValue!.r)
            let g:Float = Float(uicolor.rgbValue!.g)
            let b:Float = Float(uicolor.rgbValue!.b)
            return simd_float3(r, g, b)
    }
    
    static func setColorForMetalView(uicolor:UIColor)->SIMD3<Float>{
        
//         let uicolor = color.colorFromUIntString()
            let r:Float = Float(uicolor.rgbValue!.r)
            let g:Float = Float(uicolor.rgbValue!.g)
            let b:Float = Float(uicolor.rgbValue!.b)
            return simd_float3(r, g, b)
    }
    
    
    
    static func convertColorForMetalView(color:String)->UIColor{
        let uicolor = color.convertIOSColorStringToUIColor()
        return uicolor
    }
}

