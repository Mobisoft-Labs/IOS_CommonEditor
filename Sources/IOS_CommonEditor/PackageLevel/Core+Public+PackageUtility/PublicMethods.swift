//
//  PublicMethods.swift
//  FlyerDemo
//
//  Created by HKBeast on 04/11/25.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    var floatValue: Float {
        return Float(self) ?? 0.0
    }
    var intValue: Int {
        return Int(self) ?? 0
    }
}

extension String{
    
    public func toFloat() -> CGFloat {
        return CGFloat(Double(self) ?? 0.0)
    }
    public func toInt()->Int{
        return Int(self) ?? Int(0.0)
    }
    func colorFromUIntString() -> UIColor{
        var color = self == "1.0" ? "-1.0" : self
        let intColor = Int(color.floatValue)
        //convert int color ios color Format
      let iosColorUInt = convertAndroidToIOSColor(PrimaryColorAndroid: intColor)
        //get UInt from String
        let UIIntColor = getUIntValue(string: iosColorUInt)
        
             let alpha = CGFloat((UIIntColor >> 24) & 0xFF) / 255.0
              let red = CGFloat((UIIntColor >> 16) & 0xFF) / 255.0
              let green = CGFloat((UIIntColor >> 8) & 0xFF) / 255.0
              let blue = CGFloat(UIIntColor & 0xFF) / 255.0
   
        return  UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    public func convertAndroidColorStringToIOSColorString()->String{
        var color = self == "1.0" ? "-1.0" : self
        let intColor = Int(color.floatValue)
        //convert int color ios color Format
     return convertAndroidToIOSColor(PrimaryColorAndroid: intColor)

    }
    
    
    func convertIOSColorStringToUIColor()->UIColor{
        let UIIntColor = getUIntValue(string: self)
        
             let alpha = CGFloat((UIIntColor >> 24) & 0xFF) / 255.0
              let red = CGFloat((UIIntColor >> 16) & 0xFF) / 255.0
              let green = CGFloat((UIIntColor >> 8) & 0xFF) / 255.0
              let blue = CGFloat(UIIntColor & 0xFF) / 255.0
   
        return  UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    func toBool()->Bool{
        if self == "Y" || self == "y" || self == "true" || self == "TRUE" || self == "1" {
            return true
        }else{
            return false
        }
    }
    
    
    
}

extension String{
    
    public func convertIOSToAndroidColor() -> String {
        guard let iOSColor = UInt32(self) else { return "0" }
        
        let R = (iOSColor >> 16) & 0xFF
        let G = (iOSColor >> 8) & 0xFF
        let B = iOSColor & 0xFF
        let A = (iOSColor >> 24) & 0xFF

        let androidARGB: UInt32 = (A << 24) | (R << 16) | (G << 8) | B
        let androidColor = Int32(bitPattern: androidARGB)
        
        return String(androidColor)
    }

}

extension Int{
    

    
    public func convertIOSColorIntToUIColor()->UIColor{
        if let UIIntColor = UInt(exactly: self){ //getUIntValue(string: self)
            
            
            let alpha = CGFloat((UIIntColor >> 24) & 0xFF) / 255.0
            let red = CGFloat((UIIntColor >> 16) & 0xFF) / 255.0
            let green = CGFloat((UIIntColor >> 8) & 0xFF) / 255.0
            let blue = CGFloat(UIIntColor & 0xFF) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return .clear
    }
    
    func toBool()->Bool{
        if self == 1{
            return true
        }else{
            return false
        }
    }
    
    func toCGFloat()->CGFloat{
        return CGFloat(self)
    }
    
    func toFloat()->Float{
        return Float(self)
    }
}

extension Bool{
    func toString()->String{
        if self == true {
            return "Y"
        }else{
            return "N"
        }
    }
    
    func toInt()->Int{
        if self == true {
            return 1
        }else{
            return 0
        }
    }
    func toFloat()->Float{
        if self == true {
            return 1.0
        }else{
            return 0.0
        }
    }
}

extension UIColor {
    
    public func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let rgb: Int = (Int)(r * 255)<<16 | (Int)(g * 255)<<8 | (Int)(b * 255)<<0
        
        return String(format: "#%06x", rgb)
    }
    
    func toARGBDecimalString() -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let argbValue =  Int32(alpha) |
                             (Int32(red ) << 24) |
                            (Int32(green ) << 16) |
                            (Int32(blue ) << 8)
                           
            
            return String(argbValue)
        }
        
        return "0"
    }
    
    
}

extension Double{
    func toFloat()->Float{
        return Float(self)
    }
}

extension Float{
    func toDouble()->Double{
        return Double(self)
    }
    func toInt()->Int{
      return Int(self)
        
    }
    
}
extension CGFloat{
    func toDouble()->Double{
        return Double(self)
    }
}

func loadImage(at path: String) -> UIImage? {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentPath = paths[0]
    let imagePath = documentPath.appending(path)
    guard fileExists(at: imagePath) else {
        return nil
    }
    guard let image = UIImage(contentsOfFile: imagePath) else {
        return nil
    }
    return image
}

func fileExists(at path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
}

func imageData(from image: ImageNName) -> Data? {
    guard let cgImage = image.image?.cgImage else {
          return nil
      }
      
      let width = cgImage.width
      let height = cgImage.height
      let bytesPerPixel = 4
      let bytesPerRow = bytesPerPixel * width
      let totalBytes = bytesPerRow * height
      
      var pixelData = [UInt8](repeating: 0, count: totalBytes)
      
      guard let context = CGContext(data: &pixelData,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: bytesPerRow,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
            let cgImageCopy = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else {
          return nil
      }
      
      context.draw(cgImageCopy, in: CGRect(x: 0, y: 0, width: width, height: height))
      
      return Data(bytes: pixelData, count: totalBytes)
  }
extension UIColor {
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return (red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // Default values
    }
    
    public func toInt() -> Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return 0
        }
        
        let redInt = Int(red * 255) << 16
        let greenInt = Int(green * 255) << 8
        let blueInt = Int(blue * 255)
        let alphaInt = Int(alpha * 255) << 24
        
        return alphaInt | redInt | greenInt | blueInt
    }
    
}

public func getProportionalSize(currentRatio:CGSize , oldSize:CGSize) -> CGSize {
    var newWidth = CGFloat.zero
    var newHeight = CGFloat.zero
    
    // calculate tempWidth and heights


// consider width as base
let tempWidth1 = oldSize.width
// what will be the proportional tempheight?
let tempHeight1 = tempWidth1*(currentRatio.height/currentRatio.width)

// consider height as base
let tempHeight2 = oldSize.height
// proprotional width would be...
let tempWidth2 = tempHeight2*(currentRatio.width/currentRatio.height)

// check which size lies within boundry wrt current Aspect of refSuze
if tempHeight1 <= oldSize.height {
    newWidth = tempWidth1
    newHeight = tempHeight1
}else{
    newWidth = tempWidth2
    newHeight = tempHeight2
}
    
    return CGSize(width: newWidth, height: newHeight)
}


public func getProportionalBGSize(currentRatio:CGSize , oldSize:CGSize) -> CGSize {
    var newWidth = CGFloat.zero
    var newHeight = CGFloat.zero
    
    // calculate tempWidth and heights

    if oldSize.width > oldSize.height{
                    if currentRatio.height > currentRatio.width{
                        newWidth = oldSize.width
                        newHeight = getMaxHeight(refWidth: oldSize.width, aspectRatio: currentRatio)
                    }else{
                        newHeight = oldSize.height
                        newWidth = getMaxWidth(refHeight: oldSize.height, aspectRatio: currentRatio)
                    }
                }else{
                    if currentRatio.height <= currentRatio.width{
                        newHeight = oldSize.height
                        newWidth = getMaxWidth(refHeight: oldSize.height, aspectRatio: currentRatio)
                    }else{
                        newWidth = oldSize.width
                        newHeight = getMaxHeight(refWidth: oldSize.width, aspectRatio: currentRatio)
                    }
                }


    return CGSize(width: newWidth, height: newHeight)
}


public func calculateCropPoint(imageSize: CGSize, cropSize: CGSize) -> CGRect {
    let originalWidth = imageSize.width
    let originalHeight = imageSize.height
    
    let cropWidth = cropSize.width
    let cropHeight = cropSize.height
    
    var scaleFactor: CGFloat
    var scaledWidth: CGFloat
    var scaledHeight: CGFloat
    
    // Determine the scale factor to maintain the aspect ratio
    if originalWidth / cropWidth > originalHeight / cropHeight {
        scaleFactor = originalHeight / cropHeight
        scaledWidth = cropWidth * scaleFactor
        scaledHeight = originalHeight
    } else {
        scaleFactor = originalWidth / cropWidth
        scaledWidth = originalWidth
        scaledHeight = cropHeight * scaleFactor
    }
    
    // Calculate the crop rectangle centered within the original image
    let x = (originalWidth - scaledWidth) / 2.0
    let y = (originalHeight - scaledHeight) / 2.0
    
    return CGRect(x: x/imageSize.width, y: y/imageSize.height, width: scaledWidth/imageSize.width, height: scaledHeight/imageSize.height)
}

// Example usage:
let imageSize = CGSize(width: 1920, height: 1080)
let cropSize = CGSize(width: 800, height: 800)

//let cropRect = calculateCropPoint(imageSize: imageSize, cropSize: cropSize)
//print("Crop Rectangle: \(cropRect)")

 func getMaxHeight(refWidth: CGFloat, aspectRatio: CGSize) -> CGFloat {
     return refWidth * (aspectRatio.height / aspectRatio.width)
 }
 
  func getMaxWidth(refHeight: CGFloat, aspectRatio: CGSize) -> CGFloat {
     return refHeight * (aspectRatio.width / aspectRatio.height)
 }
//color convert
public func convertAndroidToIOSColor(PrimaryColorAndroid: Int)-> String{
        
        let A:Int = ((PrimaryColorAndroid >> 24) & 0xFF)
        let R:Int = ((PrimaryColorAndroid >> 16) & 0xFF)
        let G:Int = ((PrimaryColorAndroid >> 8) & 0xFF)
        let B:Int = ((PrimaryColorAndroid ) & 0xFF)
        //
        let rIOS: UInt = UInt(R)
        let gIOS: UInt = UInt(G)
        let bIOS: UInt = UInt(B)
        let aIOS: UInt = UInt(A)
        
        var Color: UInt = (rIOS << 16) | (gIOS << 8) | (bIOS) | (aIOS << 24)
        var stringColor = String(Color)
        //var intVal = Int(Color)
        return stringColor
    }
func getUIntValue(string: String) -> UInt {
      var value:UInt = 0
      if(UInt(string) != nil)
      {
          value = UInt(string)!
      }
      return value
  }

extension UIColor {
    func toImage(size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(self.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


func stringToGradientInfo(_ jsonString: String) -> GradientInfo? {
    // Remove curly braces from the input string
    var cleanedString = jsonString.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
    cleanedString = cleanedString.replacingOccurrences(of: "\"", with: "")//.replacingOccurrences(of: "-", with: "")
    // Split the cleaned string by ","
    let keyValuePairs = cleanedString.components(separatedBy: ",")
    
    // Create variables to store extracted values
    var startColor: Float?
    var endColor: Float?
    var radius: Float?
    var gradientType: Float?
    var angle : Float?
    for pair in keyValuePairs {
        // Split each key-value pair by ":"
        let components = pair.components(separatedBy: ":")
        
        // Ensure there are two components (key and value)
        guard components.count == 2 else {
            return nil // Invalid format
        }
        
        // Trim whitespace from key and value
        let key = components[0].trimmingCharacters(in: .whitespaces)
        let valueString = components[1].trimmingCharacters(in: .whitespaces)
        
        // Convert the value to a Float
        if let value = Float(valueString) {
            switch key {
            case "StartColor":
                startColor = Float(String(value).convertAndroidColorStringToIOSColorString())
            case "EndColor":
                endColor = Float(String(value).convertAndroidColorStringToIOSColorString())
            case "Radius":
                radius = value
            case "GradientType":
                gradientType = value
            case "AngleInDegrees":
                angle = value
            default:
                break // Ignore unknown keys
            }
        } else {
            return nil // Invalid value format
        }
    }
    
    // Check if all required values are extracted
    if let startColor = startColor,
       let endColor = endColor,
       let radius = radius,
       let gradientType = gradientType,
    let angle = angle{
        return nil
    } else {
        return nil // Return nil if any required value is missing
    }
}

extension UIColor{
    func uIntStringFromColor() -> String {
        var alpha: CGFloat = 0
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let alphaUInt = UInt(alpha * 255.0) << 24
        let redUInt = UInt(red * 255.0) << 16
        let greenUInt = UInt(green * 255.0) << 8
        let blueUInt = UInt(blue * 255.0)
        
        let colorUInt = alphaUInt | redUInt | greenUInt | blueUInt
        
        return "\(colorUInt)"
    }
}

extension UIColor {
    
    func convertIOSToAndroidColor(iosColor: String) -> String? {
        guard let colorUInt = UInt(iosColor, radix: 16) else {
            return nil
        }
        
        // Extract ARGB components
        let aIOS = (colorUInt >> 24) & 0xFF
        let rIOS = (colorUInt >> 16) & 0xFF
        let gIOS = (colorUInt >> 8) & 0xFF
        let bIOS = colorUInt & 0xFF
        
        // Combine ARGB components in Android order (ARGB)
        let androidColor = (aIOS << 24) | (rIOS << 16) | (gIOS << 8) | bIOS
        
        // Convert integer to Android color string
        let androidColorString = String(androidColor)
        
        return androidColorString
    }
    func toAndroidColorString() -> String {
            // Convert UIColor to integer representation
            guard let components = cgColor.components else {
                return ""
            }
            
            let r = Int(components[0] * 255)
            let g = Int(components[1] * 255)
            let b = Int(components[2] * 255)
            let a = Int(components[3] * 255)
            
            // Combine ARGB components in Android order (ARGB)
            let androidColor = (a << 24) | (r << 16) | (g << 8) | b
            
            // Convert integer to iOS color string
            let iosColorString = String(format: "%08X", androidColor)
            
             return convertIOSToAndroidColor(iosColor: iosColorString) ?? " "
//            return iosColorString
        }

    public func toUIntString() -> String {
        // Get the RGBA components of the color
        guard let components = self.cgColor.components else {
            return "nil"
        }
        
        // Check the count of components to handle cases like grayscale colors
        let red: Int
        let green: Int
        let blue: Int
        let alpha: Int
        
        if components.count == 4 {
            // RGB color with alpha
            red = Int(components[0] * 255)
            green = Int(components[1] * 255)
            blue = Int(components[2] * 255)
            alpha = Int(components[3] * 255)
        } else if components.count == 2 {
            // Grayscale color with alpha
            red = Int(components[0] * 255)
            green = red
            blue = red
            alpha = Int(components[1] * 255)
        } else {
            return "nil" // Unsupported color format
        }
        
        // Concatenate the RGBA values into a UInt string
        let uintValue = (alpha << 24) | (red << 16) | (green << 8) | blue
        return "\(uintValue)"
    }
    
    
}

extension Color {
     
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)

}

func snapCurrent(rotationAngle:CGFloat)->CGFloat{
   var snappedRotationAngle = rotationAngle
   // tolerance of 2 degree
   let RadianOneDegree:CGFloat = 0.0174533
   let tolerance:CGFloat = RadianOneDegree * 5
   // @ Zero Degree
   var rightAngleVar:CGFloat = 0
   if(rotationAngle > (rightAngleVar - tolerance) && rotationAngle < (rightAngleVar + tolerance) )
   {
       snappedRotationAngle = rightAngleVar
   }
   // Anticlockwise - 1.5708
   rightAngleVar = -1.5708
   if(rotationAngle > (rightAngleVar - tolerance) && rotationAngle < (rightAngleVar + tolerance) )
   {
       snappedRotationAngle = rightAngleVar
   }
   // Anticlockwise - 1.5708
   rightAngleVar = 1.5708
   if(rotationAngle > (rightAngleVar - tolerance) && rotationAngle < (rightAngleVar + tolerance) )
   {
       snappedRotationAngle = rightAngleVar
   }
   
   rightAngleVar = -3.14159
   if(rotationAngle > (rightAngleVar - tolerance) && rotationAngle < (rightAngleVar + tolerance) )
   {
       snappedRotationAngle = rightAngleVar
   }
   return snappedRotationAngle
}
func rad2deg(_ number: Double) -> Double {
   return number * 180 / .pi
}
func deg2rad(_ number: Double) -> Double {
   return number * .pi / 180
}
extension CGSize {
       
   func into(_ value : CGFloat) -> CGSize {
      return  CGSize(width: self.width * value , height: self.height * value )
   }
    public func into(_ widthBy : CGFloat , _ heightBy : CGFloat) -> CGSize {
      return  CGSize(width: self.width * widthBy , height: self.height * heightBy )
   }
   public func plus(_ value : CGFloat) -> CGSize {
      return  CGSize(width: self.width + value , height: self.height + value )
   }
   func plus(_ refSize : CGPoint) -> CGSize {
       return  CGSize(width: self.width + refSize.x , height: self.height + refSize.y )
   }
   func divide(_ value : CGFloat) -> CGSize {
      return  CGSize(width: self.width / value , height: self.height / value )
   }
   func divide(_ refSize : CGSize) -> CGSize {
       return  CGSize(width: self.width / refSize.width , height: self.height / refSize.height )
   }
   
   func findMax()->CGFloat {
       return max(self.width, self.height)
   }
   func findMin()->CGFloat {
       return min(self.width, self.height)
   }

   func findScale(withRespectTo size : CGSize , keepAspectRatio : Bool = true) -> CGFloat {
       var comparableSide : CGFloat = size.findMin()
       if keepAspectRatio {
           comparableSide = size.findMin()
       }
       let maxSide = self.findMin()
       let scale = maxSide/comparableSide
       return scale.roundToDecimal(2)
   }
}
extension CGFloat {
       func roundToDecimal(_ fractionDigits: Int) -> Double {
           let multiplier = pow(10, Double(fractionDigits))
           return Darwin.round(self * multiplier) / multiplier
       }
   
}
extension Float {
       func roundToDecimal(_ fractionDigits: Int) -> Float {
           let multiplier = pow(10, Float(fractionDigits))
           return Darwin.round(self * multiplier) / multiplier
       }
   
}
extension Double {
   func roundToDecimal(_ fractionDigits: Int) -> Double {
       let multiplier = pow(10, Double(fractionDigits))
       return Darwin.round(self * multiplier) / multiplier
   }
}
extension CGPoint {
       
   func into(_ value : CGFloat) -> CGPoint {
      return  CGPoint(x: self.x * value , y: self.y * value )
   }
   func into(_ xBy : CGFloat , _ yBY : CGFloat) -> CGPoint {
       return  CGPoint(x: self.x * xBy , y: self.y * yBY )
   }
   func into(_ value : CGPoint) -> CGPoint {
       return  into(value.x, value.y)
   }
   func plus(_ value : CGPoint) -> CGPoint {
       return  CGPoint(x: self.x + value.x , y: self.y + value.y )
   }
   func divide(_ value : CGPoint) -> CGPoint {
       return  CGPoint(x: self.x / value.x , y: self.y / value.y )
   }
   func divide(_ xBy : CGFloat , _ yBY : CGFloat) -> CGPoint {
       return  CGPoint(x: self.x / xBy , y: self.y / yBY)
   }
}

/// tells what grid position watermark lies in respect to BGimage
enum WMGridPositions {
 case TOP_LEFT
 case TOP_MIDDLE
 case TOP_RIGHT
 case MIDDLE_LEFT
 case MIDDLE_MIDDLE
 case MIDDLE_RIGHT
 case BOTTOM_LEFT
 case BOTTOM_MIDDLE
 case BOTTOM_RIGHT
}

/**
recalculate new center for new size proportional to currentCenter and size

- parameter currentCenter: actual center
- parameter currentSize: actual size
- parameter newSize: size for which newcenter is required

- returns: New Center
- warning: -

*/
public func reCalculateCenter(_ currentCenter : CGPoint , currentSize : CGSize , newSize: CGSize)->CGPoint{
   
   /** find out new proprotional width height from current and newRef Size
    W1,H1 = considering newSize width calculate proportional Height ( aspect ratio Logic )
    W2,H2 = considering newSize height calculate proportional width ( aspect ratio Logic
    check if H1 is less than newRefSize
           w1 h1 new Size
    else w2h2 newSize
    */
  let newProportionalSize = getProportionalSize(currentSize: currentSize, newSize: newSize)
  
   let newWidth = newProportionalSize.width
   let newHeight = newProportionalSize.height
   
   // calculate what quadrant watermark lies
   var quadrant = WMGridPositions.MIDDLE_MIDDLE
   
   if(currentCenter.x <= currentSize.width/3)
   {
       // This is on Left Side
       // Check Where is Y
       if(currentCenter.y <= currentSize.height/3)
       {
           
           quadrant = .TOP_LEFT
       } else if( currentCenter.y > currentSize.height/3 && currentCenter.y <= currentSize.height * 2/3) {
                    // This is in Center
           
           quadrant = .MIDDLE_LEFT
       } else{
           
           quadrant = .BOTTOM_LEFT
       }
   } else  if(currentCenter.x > currentSize.width/3 && currentCenter.x <= currentSize.width * 2/3)
   {
       // This is in Center
       // Check Where is Y
       if(currentCenter.y <= currentSize.height/3)
       {
           
           quadrant = .TOP_MIDDLE
       } else if( currentCenter.y > currentSize.height/3 && currentCenter.y <= currentSize.height * 2/3) {
           // This is in Center
           
           quadrant = .MIDDLE_MIDDLE
       } else{
           
           quadrant = .BOTTOM_MIDDLE
       }
       
   } else {
       // This is on Right Side
       // Check Where is Y
       
       if(currentCenter.y <= currentSize.height/3)
       {
           
           quadrant = .TOP_RIGHT
       } else if( currentCenter.y > currentSize.height/3 && currentCenter.y <= currentSize.height * 2/3) {
           // This is in Center
           
           quadrant = .MIDDLE_RIGHT
       } else{
           
           quadrant = .BOTTOM_RIGHT
       }
       
   }
   
   
   // now lets calculate newCenter based on quadrant and newWidthHeight
   
   var newCenter = CGPoint.zero
   
   // if Quadrant is one then Reference is from TopLeft
   switch quadrant {
   case .TOP_LEFT:
       let centerX = currentCenter.x * (newWidth/currentSize.width)
       let centerY = currentCenter.y * (newHeight/currentSize.height)
       newCenter = CGPoint(x: centerX, y:centerY)
   case .TOP_MIDDLE:
       // Top Middle
       //  We going to shift from Right
       // Reference is Center X of ReferenceImage
       //
       let proportionateDistanceFromCenterX = (currentCenter.x - currentSize.width/2) * (newWidth/currentSize.width)
       let centerX = newSize.width/2  + proportionateDistanceFromCenterX
       let centerY = currentCenter.y * (newHeight/currentSize.height)
       newCenter = CGPoint(x: centerX, y:centerY)
   case .TOP_RIGHT:
       //  We going to shift from Right
       let centerX = newSize.width - ((currentSize.width - currentCenter.x) * (newWidth/currentSize.width))
       let centerY = currentCenter.y * (newHeight/currentSize.height)
       newCenter = CGPoint(x: centerX, y:centerY)
       
   case .MIDDLE_LEFT:
       let centerX = currentCenter.x * (newWidth/currentSize.width)
       let proportionateDistanceFromCenterY = (currentCenter.y - currentSize.height/2) * (newHeight/currentSize.height)
       let centerY = newSize.height/2  + proportionateDistanceFromCenterY
       newCenter = CGPoint(x: centerX, y:centerY)
   case .MIDDLE_MIDDLE:
       let proportionateDistanceFromCenterX = (currentCenter.x - currentSize.width/2) * (newWidth/currentSize.width)
       let centerX = newSize.width/2  + proportionateDistanceFromCenterX
       let proportionateDistanceFromCenterY = (currentCenter.y - currentSize.height/2) * (newHeight/currentSize.height)
       let centerY = newSize.height/2  + proportionateDistanceFromCenterY
       newCenter = CGPoint(x: centerX, y:centerY)
       
   case .MIDDLE_RIGHT:
       let centerX = newSize.width - ((currentSize.width - currentCenter.x) * (newWidth/currentSize.width))
       let proportionateDistanceFromCenterY = (currentCenter.y - currentSize.height/2) * (newHeight/currentSize.height)
       let centerY = newSize.height/2  + proportionateDistanceFromCenterY
       newCenter = CGPoint(x: centerX, y:centerY)
   case .BOTTOM_LEFT:
       //  We going to shift from left Bottom
       let centerX = currentCenter.x * (newWidth/currentSize.width)
       let centerY = newSize.height - ((currentSize.height - currentCenter.y) * (newHeight/currentSize.height))
       newCenter = CGPoint(x: centerX, y:centerY)
   case .BOTTOM_MIDDLE:
       //  We going to shift from left Bottom
       let proportionateDistanceFromCenterX = (currentCenter.x - currentSize.width/2) * (newWidth/currentSize.width)
       let centerX = newSize.width/2  + proportionateDistanceFromCenterX
       let centerY = newSize.height - ((currentSize.height - currentCenter.y) * (newHeight/currentSize.height))
       newCenter = CGPoint(x: centerX, y:centerY)
       
   case .BOTTOM_RIGHT:
       //  We going to shift from Right & Bottom
       let centerX = newSize.width - ((currentSize.width - currentCenter.x) * (newWidth/currentSize.width))
       let centerY = newSize.height - ((currentSize.height - currentCenter.y) * (newHeight/currentSize.height))
       newCenter = CGPoint(x: centerX, y:centerY)
       
       
   }
   
   // returning newly calculated center for newSize with proportion to currentSize and center
   return newCenter
}

public func recalculateCenter(currentCenter: CGPoint, currentParentSize: CGSize, newParentSize: CGSize) -> CGPoint {
   // Calculate the relative position of the current center
   let relativeX = currentCenter.x / currentParentSize.width
   let relativeY = currentCenter.y / currentParentSize.height
   
   // Calculate the new center based on the relative position and new parent size
   let newCenterX = relativeX * newParentSize.width
   let newCenterY = relativeY * newParentSize.height
   
   // Return the new center point
   return CGPoint(x: newCenterX, y: newCenterY)
}

/**
recalculate new size for new size proportional to currentCenter and size

- parameter currentChildSize: actual size of childView
- parameter currentParentSize: actual size of parentView
- parameter newParentSize: size for which new childNewSize  is required

- returns: child New size
- warning: -

*/
func reCalculateSize(currentChildSize : CGSize , currentParentSize : CGSize , newParentSize:CGSize , aspectRatio:Bool = true) -> CGSize {
  
   
   var newProportionalSize = getProportionalSize(currentSize: currentParentSize, newSize: newParentSize)

   if !aspectRatio {
       newProportionalSize = newParentSize
   }
   // Calculate proportional Width
   let waterMarkWidth = currentChildSize.width * (newProportionalSize.width/currentParentSize.width)
   
   // Calculate proportional Height
   
   let waterMarkHeight = currentChildSize.height * (newProportionalSize.height/currentParentSize.height)
  
   // returning newly calculated size for newParentSize with proportion to currentParentSize and childSize
   return CGSize(width: waterMarkWidth, height: waterMarkHeight)
}

func getAspectSize(newSize:CGSize , withRespectTo aspectRatio : CGSize)->CGSize {
  var aspectSize = newSize
  if(newSize.width<=newSize.height)
  {
      aspectSize.height = newSize.width * (aspectRatio.height / aspectRatio.width)
  }else
  {
      aspectSize.width = newSize.height * (aspectRatio.width / aspectRatio.height)
  }
  
  return aspectSize
}

// Calculates croprect with respect to base size
func fitImageToBaseNormalized(imageSize: CGSize, baseSize: CGSize) -> CGRect {
   let imageAspect = imageSize.width / imageSize.height
   let baseAspect = baseSize.width / baseSize.height
   
   var newSize: CGSize
   var xOffset: CGFloat
   var yOffset: CGFloat
   
   if imageSize.width > imageSize.height{
       newSize = CGSize(width: imageSize.height * baseAspect, height: imageSize.height)
       xOffset = (newSize.width - imageSize.width) / 2
       yOffset = 0
   }else{
       newSize = CGSize(width: imageSize.width, height: imageSize.width / baseAspect)
       xOffset = 0
       yOffset = (newSize.height - imageSize.height) / 2
   }
//        if imageAspect > baseAspect {
//            newSize = CGSize(width: baseSize.width, height: baseSize.width / imageAspect)
//        } else {
//            newSize = CGSize(width: baseSize.height * imageAspect, height: baseSize.height)
//        }
   
   
   
   // Normalize the coordinates and size to 0-1 range
   let normalizedX = xOffset
   let normalizedY = yOffset
   let normalizedWidth = newSize.width
   let normalizedHeight = newSize.height
   
   return CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
}

 /// calculates proportional size while maintaing same aspect ratio of oldSize
public func getProportionalSize(currentSize:CGSize , newSize:CGSize) -> CGSize {
   var newWidth = CGFloat.zero
   var newHeight = CGFloat.zero
   
   // calculate tempWidth and heights


// consider width as base
let tempWidth1 = newSize.width
// what will be the proportional tempheight?
let tempHeight1 = tempWidth1*(currentSize.height/currentSize.width)

// consider height as base
let tempHeight2 = newSize.height
// proprotional width would be...
let tempWidth2 = tempHeight2*(currentSize.width/currentSize.height)

// check which size lies within boundry wrt current Aspect of refSuze
if tempHeight1 <= newSize.height {
   newWidth = tempWidth1
   newHeight = tempHeight1
}else{
   newWidth = tempWidth2
   newHeight = tempHeight2
}
   
   return CGSize(width: newWidth, height: newHeight)
}

extension UIView {
 
 func offsetPointToParentCoordinates(point: CGPoint) -> CGPoint {
   return CGPointMake(point.x + self.center.x, point.y + self.center.y)
 }
 
 func pointInViewCenterTerms(point:CGPoint) -> CGPoint {
   return CGPointMake(point.x - self.center.x, point.y - self.center.y)
 }
 
 func pointInTransformedView(point: CGPoint) -> CGPoint {
     let offsetItem = self.pointInViewCenterTerms(point: point)
   let updatedItem = CGPointApplyAffineTransform(offsetItem, self.transform)
     let finalItem = self.offsetPointToParentCoordinates(point: updatedItem)
   return finalItem
 }
 
 func originalFrame() -> CGRect {
   let currentTransform = self.transform
   self.transform = CGAffineTransformIdentity
   let originalFrame = self.frame
   self.transform = currentTransform
   return originalFrame
 }
 
 //These four methods return the positions of view elements
 //with respect to the current transformation
 
   func transformedTextHandleTop() -> CGPoint{
       let frame = self.originalFrame()
       let point = CGPoint(x: (frame.origin.x + frame.width/2), y: frame.origin.y)
       return self.pointInTransformedView(point: point)
   }
   
   func transformedTextHandleBottom() -> CGPoint{
       let frame = self.originalFrame()
       let point = CGPoint(x: (frame.origin.x + frame.width/2), y: frame.maxY)
       return self.pointInTransformedView(point: point)
   }
   
   func transformedTextHandleLeft() -> CGPoint{
       let frame = self.originalFrame()
       let point = CGPoint(x: frame.origin.x, y: (frame.origin.y + frame.height/2))
       return self.pointInTransformedView(point: point)
   }
   
   func transformedTextHandleRight() -> CGPoint{
       let frame = self.originalFrame()
       let point = CGPoint(x: frame.maxX, y: (frame.origin.y + frame.height/2))
       return self.pointInTransformedView(point: point)
   }
   
   
 func transformedTopLeft() -> CGPoint {
   let frame = self.originalFrame()
   let point = frame.origin
     return self.pointInTransformedView(point: point)
 }
 
 func transformedTopRight() -> CGPoint {
   let frame = self.originalFrame()
   var point = frame.origin
   point.x += frame.size.width
     return self.pointInTransformedView(point: point)
 }
 
 func transformedBottomRight() -> CGPoint {
   let frame = self.originalFrame()
   var point = frame.origin
   point.x += frame.size.width
   point.y += frame.size.height
     return self.pointInTransformedView(point: point)
 }
 
 func transformedBottomLeft() -> CGPoint {
   let frame = self.originalFrame()
   var point = frame.origin
   point.y += frame.size.height
     return self.pointInTransformedView(point: point)
 }
 
 func transformedRotateHandleRight() -> CGPoint {
   let frame = self.originalFrame()
   var point = frame.origin
       point.x += frame.size.width + 40//25
       point.y += frame.size.height/2
   return self.pointInTransformedView(point: point)
 }
   //Neeshu
   func transformRotateHandleLeft() -> CGPoint{
       let frame = self.originalFrame()
       var point = frame.origin
           point.x -= 40//25
           point.y += frame.size.height/2
       return self.pointInTransformedView(point: point)
   }
   //Neeshu
   func transformRotateHandleTop() -> CGPoint{
       let frame = self.originalFrame()
       var point = frame.origin
       point.x += frame.size.width/2
       point.y -=  40 //25
       return self.pointInTransformedView(point: point)
   }
   
   //Neeshu
   func transformRotateHandleBottom() -> CGPoint{
       let frame = self.originalFrame()
       var point = frame.origin
       point.x += frame.size.width/2
       point.y += frame.size.height + 40 //25
       return self.pointInTransformedView(point: point)
   }
   
   func transformDeleteHandle()->CGPoint {
       let spacing : CGFloat = 5
       let frame = self.originalFrame()
       var point = frame.origin
           point.x += (frame.size.width/2)-(20+spacing)
           point.y += frame.size.height + 25
       return self.pointInTransformedView(point: point)
   }
   
   func transformEditHandle()->CGPoint {
       let spacing : CGFloat = 5
       let frame = self.originalFrame()
       var point = frame.origin
           point.x += (frame.size.width/2)-(spacing - 5)
           point.y += frame.size.height + 60
       return self.pointInTransformedView(point: point)
   }
   
   func transformLockHandle()->CGPoint {
       let spacing : CGFloat = 5
       let frame = self.originalFrame()
       var point = frame.origin
           point.x += (frame.size.width/2)+(20+spacing)
           point.y += frame.size.height + 25
       return self.pointInTransformedView(point: point)
   }
   
 func setAnchorPoint(anchorPoint:CGPoint) {
   var newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y)
   var oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y)
   
   newPoint = CGPointApplyAffineTransform(newPoint, self.transform)
   oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform)
   
   var position = self.layer.position
   position.x -= oldPoint.x
   position.x += newPoint.x
   position.y -= oldPoint.y
   position.y += newPoint.y
   
   self.layer.position = position
   self.layer.anchorPoint = anchorPoint
 }

}

protocol Transformable {
   
   var isTransformable : Bool {get}
    
   func setInitialCenter()
   
   func moveBy(distance:CGPoint)
   func scaleBy(newScale:CGFloat)
   func rotateBy(angleInDegree:CGFloat)

   func moveTo(newCenter:CGPoint)
   func scaleTo(newSize:CGSize)
   func rotateTo(angle:CGFloat)

   func resetToIdentity()
}


func selectionVibrate() {
 let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
 
   
}

extension UIColor {
    
    public var rgbValue: RGB? {
        
        guard let components = cgColor.components else {
            return nil
        }
        
        let numComponents = cgColor.numberOfComponents
        
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        if numComponents < 3 {
            r = components[0]
            g = components[0]
            b = components[0]
        } else {
            r = components[0]
            g = components[1]
            b = components[2]
        }
        
        return RGB(r: r, g: g, b: b)
    }
    
    public var hsvValue: HSV? {
        
        guard let rgb = rgbValue else {
            return nil
        }
        
        return rgb.toHSV(preserveHS: true)
    }
    
    public func hsvValue(preservingHue hue: CGFloat, preservingSat sat: CGFloat) -> HSV? {

        guard let rgb = rgbValue else {
            return nil
        }
        
        return rgb.toHSV(preserveHS: true, h: hue, s: sat)
    }
    
}

public struct RGB: Hashable {
    /// In range 0...1
    public var r: CGFloat
    
    /// In range 0...1
    public var g: CGFloat
    
    /// In range 0...1
    public var b: CGFloat
}

public extension RGB {
    
    func toHSV(preserveHS: Bool, h: CGFloat = 0, s: CGFloat = 0) -> HSV {
        
        var h = h
        var s = s
        var v: CGFloat = 0
        
        var max = r
        
        if max < g {
            max = g
        }
        
        if max < b {
            max = b
        }
        
        var min = r
        
        if min > g {
            min = g
        }
        
        if min > b {
            min = b
        }
        
        // Brightness (aka Value)
        
        v = max
        
        // Saturation
        
        var sat: CGFloat = 0.0
        
        if max != 0.0 {
            
            sat = (max - min) / max
            s = sat
            
        } else {
            
            sat = 0.0
            
            // Black, so sat is undefined, use 0
            if !preserveHS {
                s = 0.0
            }
        }
        
        // Hue
        
        var delta: CGFloat = 0
        
        if sat == 0.0 {
            
            // No color, so hue is undefined, use 0
            if !preserveHS {
                h = 0.0
            }
            
        } else {
            
            delta = max - min
            
            var hue: CGFloat = 0
            
            if r == max {
                hue = (g - b) / delta
            } else if g == max {
                hue = 2 + (b - r) / delta
            } else {
                hue = 4 + (r - g) / delta
            }
            
            hue /= 6.0
            
            if hue < 0.0 {
                hue += 1.0
            }
            
            // 0.0 and 1.0 hues are actually both the same (red)
            if !preserveHS || abs(hue - h) != 1.0 {
                h = hue
            }
        }
        
        return HSV(h: h, s: s, v: v)
    }
    
}

public struct HSV: Hashable {
    /// In degrees (range 0...360)
    public var h: CGFloat
    
    /// Percentage in range 0...1
    public var s: CGFloat
    
    /// Percentage in range 0...1
    /// Also known as "brightness" (B)
    public var v: CGFloat
}

extension HSV {
    
    /// These functions convert between an RGB value with components in the
    /// 0.0..1.0 range to HSV where Hue is 0 .. 360 and Saturation and
    /// Value (aka Brightness) are percentages expressed as 0.0..1.0.
    //
    /// Note that HSB (B = Brightness) and HSV (V = Value) are interchangeable
    /// names that mean the same thing. I use V here as it is unambiguous
    /// relative to the B in RGB, which is Blue.
    func toRGB() -> RGB {
        
        var rgb = self.hueToRGB()
        
        let c = v * s
        let m = v - c
        
        rgb.r = rgb.r * c + m
        rgb.g = rgb.g * c + m
        rgb.b = rgb.b * c + m
        
        return rgb
    }
    
    func hueToRGB() -> RGB {
        
        let hPrime = h / 60.0
        
        let x = 1.0 - abs(hPrime.truncatingRemainder(dividingBy: 2.0) - 1.0)
        
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        if hPrime < 1.0 {
            
            r = 1
            g = x
            b = 0
            
        } else if hPrime < 2.0 {
            
            r = x
            g = 1
            b = 0
            
        } else if hPrime < 3.0 {
            
            r = 0
            g = 1
            b = x
            
        } else if hPrime < 4.0 {
            
            r = 0
            g = x
            b = 1
            
        } else if hPrime < 5.0 {
            
            r = x
            g = 0
            b = 1
            
        } else {
            
            r = 1
            g = 0
            b = x
            
        }
        
        return RGB(r: r, g: g, b: b)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner , radius : CGFloat = 20) {
        DispatchQueue.main.async { [self] in
            
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

extension String{
    func addSpaceBeforeCapital() -> String {
        
        return self
            .replacingOccurrences(of: "([a-z])([A-Z](?=[A-Z])[a-z]*)", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "([A-Z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
    }
    
    func translate() -> String{
        
        var localizedString =  NSLocalizedString(self , comment: "")
        if(localizedString == self)||(localizedString.contains("_")){
            // print("Searching In POD Translation")
            // print("\(self) - translation not in MAIN")
            if let bundle = Resource.getPodBundle(for: "Localizable", ext: "strings") {
                localizedString = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
                
                if(localizedString == self)||(localizedString.contains("_")){
                    
                    print("\(self) - translation not in MAIN nor POD ")
                    
                }else{
                    // print("\(self) - translation FOUND IN POD ")
                }
                return localizedString;
            }
            
            
        }else{
            return localizedString
        }
        return self
        
    }
    /// -returns: array of total lines in string
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

public class Resource {
    
    static func getPodBundle(for name : String , ext : String , className : AnyClass = Resource.self) -> Bundle? {
        
        let appBundle = Bundle(for: className.self)
        if let bundleUrl = appBundle.url(forResource: "IOS_CommonEditor", withExtension: "bundle") {
            if let podBundle = Bundle(url: bundleUrl) {
                if podBundle.url(forResource: name, withExtension: ext) != nil {
                    return podBundle
                }
            }
        }else  if Bundle.main.path(forResource: name, ofType: ext) != nil {
            return  Bundle.main
        }
        return nil
    }
}
