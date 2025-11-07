/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class MetalTexture: NSObject {

  var texture: MTLTexture!
  var target: MTLTextureType!
  var width: Int!
  var height: Int!
  var depth: Int!
  var format: MTLPixelFormat!
  var hasAlpha: Bool!
 // var path: String!
    var imageForTexture: UIImage!
  var isMipmaped: Bool!
  let bytesPerPixel:Int! = 4
  let bitsPerComponent:Int! = 8
  
  //MARK: - Creation
    init(image:UIImage, mipmaped:Bool){
    
    //path = Bundle.main.path(forResource: resourceName, ofType: ext)
    imageForTexture = image
    width    = 0
    height   = 0
    depth    = 1
    format   = MTLPixelFormat.rgba8Unorm
    target   = MTLTextureType.type2D
    texture  = nil
    isMipmaped = mipmaped
    
    super.init()
  }
    override init(){
        width    = 200
        height   = 200
        depth    = 1
        format   = MTLPixelFormat.rgba8Unorm
        target   = MTLTextureType.type2D
        super.init()
    }
    init(texture:MTLTexture){
    width    = 200
    height   = 200
    depth    = 1
    format   = MTLPixelFormat.rgba8Unorm
    target   = MTLTextureType.type2D
    self.texture  = texture
    isMipmaped = true
    super.init()
  }
    let maxTextureSize = 16384
    func clampedTextureSize(width: Int, height: Int, maxDimension: Int = 16384) -> (width: Int, height: Int) {
        let originalWidth = CGFloat(width)
        let originalHeight = CGFloat(height)
        
        let aspectRatio = originalWidth / originalHeight

        if originalWidth <= CGFloat(maxDimension) && originalHeight <= CGFloat(maxDimension) {
            return (width, height) // No clamping needed
        }
        
//        logError("Clampped Texture - OrigSize \(originalWidth):\(originalHeight)")
        
        if aspectRatio >= 1 {
            // Landscape or square
            let clampedWidth = CGFloat(maxDimension)
            let clampedHeight = clampedWidth / aspectRatio
            return (Int(clampedWidth.rounded()), Int(clampedHeight.rounded()))
        } else {
            // Portrait
            let clampedHeight = CGFloat(maxDimension)
            let clampedWidth = clampedHeight * aspectRatio
            return (Int(clampedWidth.rounded()), Int(clampedHeight.rounded()))
        }
    }
  func loadTexture(device: MTLDevice, commandQ: MTLCommandQueue? = nil, flip: Bool){
    
    let image = imageForTexture.cgImage! //(UIImage(contentsOfFile: path)?.cgImage)!
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
//      let clampedWidth = min(width, maxTextureSize)
//      let clampedHeight = min(height, maxTextureSize)
      let (safeWidth, safeHeight) = clampedTextureSize(width: image.width, height: image.height)

    width = Int(safeWidth)//.pointsToPixel())
    height = Int(safeHeight)//.pointsToPixel())
    
    let rowBytes = width * bytesPerPixel
    
      let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let bounds = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
    context.clear(bounds)
    
    if flip == false{
      context.translateBy(x: 0, y: CGFloat(self.height))
      context.scaleBy(x: 1.0, y: -1.0)
    }
    
    context.draw(image, in: bounds)
    
    let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: Int(width), height: Int(height), mipmapped: isMipmaped)
    
    target = texDescriptor.textureType
    texture = device.makeTexture(descriptor: texDescriptor)
    
    let pixelsData = context.data!
    let region = MTLRegionMake2D(0, 0, Int(width), Int(height))
    texture.replace(region: region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: Int(rowBytes))
    
    if (isMipmaped == true){
//      generateMipMapLayersUsingSystemFunc(texture: texture, device: device, commandQ: commandQ, block: { (buffer) -> Void in
//       // printLog("mips generated")
//      })
    }
    
   // printLog("mipCount:\(texture.mipmapLevelCount)")
  }
  
    func loadTextureForColor(device: MTLDevice, commandQ: MTLCommandQueue? = nil, flip: Bool){
      
      let image = imageForTexture.cgImage! //(UIImage(contentsOfFile: path)?.cgImage)!
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      
      
      
      width = Int(Float(image.width))//.pointsToPixel())
      height = Int(Float(image.height ))//.pointsToPixel())
      
      let rowBytes = width * bytesPerPixel
      
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
      let bounds = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
      context.clear(bounds)
      
      if flip == false{
        context.translateBy(x: 0, y: CGFloat(self.height))
        context.scaleBy(x: 1.0, y: -1.0)
      }
      
      context.draw(image, in: bounds)
      
      let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: Int(width), height: Int(height), mipmapped: isMipmaped)
      
      target = texDescriptor.textureType
      texture = device.makeTexture(descriptor: texDescriptor)
      
      let pixelsData = context.data!
      let region = MTLRegionMake2D(0, 0, Int(width), Int(height))
      texture.replace(region: region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: Int(rowBytes))
      
      if (isMipmaped == true){
  //      generateMipMapLayersUsingSystemFunc(texture: texture, device: device, commandQ: commandQ, block: { (buffer) -> Void in
  //       // printLog("mips generated")
  //      })
      }
      
     // printLog("mipCount:\(texture.mipmapLevelCount)")
    }
  
  class func textureCopy(source:MTLTexture,device: MTLDevice, mipmaped: Bool) -> MTLTexture {
    let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.bgra8Unorm, width: Int(source.width), height: Int(source.height), mipmapped: mipmaped)
    let copyTexture = device.makeTexture(descriptor: texDescriptor)
    
    
    let region = MTLRegionMake2D(0, 0, Int(source.width), Int(source.height))
    let pixelsData = malloc(source.width * source.height * 4)!
    source.getBytes(pixelsData, bytesPerRow: Int(source.width) * 4, from: region, mipmapLevel: 0)
    copyTexture!.replace(region: region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: Int(source.width) * 4)
    return copyTexture!
  }
  
  class func copyMipLayer(source:MTLTexture, destination:MTLTexture, mipLvl: Int){
    let q = Int(powf(2, Float(mipLvl)))
    let mipmapedWidth = max(Int(source.width)/q,1)
    let mipmapedHeight = max(Int(source.height)/q,1)
    
    let region = MTLRegionMake2D(0, 0, mipmapedWidth, mipmapedHeight)
    let pixelsData = malloc(mipmapedHeight * mipmapedWidth * 4)!
    source.getBytes(pixelsData, bytesPerRow: mipmapedWidth * 4, from: region, mipmapLevel: mipLvl)
    destination.replace(region: region, mipmapLevel: mipLvl, withBytes: pixelsData, bytesPerRow: mipmapedWidth * 4)
    free(pixelsData)
  }
  
  //MARK: - Generating UIImage from texture mip layers
  func image(mipLevel: Int) -> UIImage{
    
    let p = bytesForMipLevel(mipLevel: mipLevel)
    let q = Int(powf(2, Float(mipLevel)))
    let mipmapedWidth = max(width / q,1)
    let mipmapedHeight = max(height / q,1)
    let rowBytes = mipmapedWidth * 4
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    let context = CGContext(data: p, width: mipmapedWidth, height: mipmapedHeight, bitsPerComponent: 8, bytesPerRow: rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.last.rawValue)!
    let imgRef = context.makeImage()
    let image = UIImage(cgImage: imgRef!)
    return image
  }
  
  func image() -> UIImage{
    return image(mipLevel: 0)
  }
  
  //MARK: - Getting raw bytes from texture mip layers
  func bytesForMipLevel(mipLevel: Int) -> UnsafeMutableRawPointer{
    let q = Int(powf(2, Float(mipLevel)))
    let mipmapedWidth = max(Int(texture.width) / q,1)
    let mipmapedHeight = max(Int(texture.height) / q,1)
    
    let rowBytes = Int(mipmapedWidth * 4)
    
    let region = MTLRegionMake2D(0, 0, mipmapedWidth, mipmapedHeight)
    let pointer = malloc(rowBytes * mipmapedHeight)!
    texture.getBytes(pointer, bytesPerRow: rowBytes, from: region, mipmapLevel: mipLevel)
    return pointer
  }
  
  func bytes() -> UnsafeMutableRawPointer{
    return bytesForMipLevel(mipLevel: 0)
  }
  
  func generateMipMapLayersUsingSystemFunc(texture: MTLTexture, device: MTLDevice, commandQ: MTLCommandQueue,block: @escaping MTLCommandBufferHandler){
    
    let commandBuffer = commandQ.makeCommandBuffer()
    
    commandBuffer!.addCompletedHandler(block)
    
    let blitCommandEncoder = commandBuffer!.makeBlitCommandEncoder()!
    
    blitCommandEncoder.generateMipmaps(for: texture)
    blitCommandEncoder.endEncoding()
    
    commandBuffer!.commit()
  }
  
}
extension MTLTexture {
  
    func bytes() -> UnsafeMutableRawPointer {
    let width = self.width
    let height = self.height
    let rowBytes = self.width * 4
    let p = malloc(width * height * 4)!
    
        self.getBytes(p, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
    
    return p
  }
    func toImage() -> CGImage? {
       let p = bytes()
       
       let pColorSpace = CGColorSpaceCreateDeviceRGB()
       
        let rawBitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
       let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: rawBitmapInfo)
        let selftureSize = self.width * self.height * 4
        let rowBytes = self.width * 4
        let releaseMaskImagePixelData: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
            return
        }

        guard let provider = CGDataProvider(dataInfo: nil, data: p, size: selftureSize, releaseData: releaseMaskImagePixelData) else {
            return nil
            
        }
        let cgref = CGImage(width: self.width, height: self.height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: rowBytes, space: pColorSpace, bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        return cgref
        

}
}
