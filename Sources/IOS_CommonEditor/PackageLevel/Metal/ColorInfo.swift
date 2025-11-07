//
//  ColorInfo.swift
//  VideoInvitation
//
//  Created by HKBeast on 30/08/23.
//

import Foundation
import UIKit

public struct prespectiveRect {
    public   var topLeftPoint : CGPoint
    public   var topRightPoint : CGPoint
    public   var bottomRightPoint : CGPoint
    public   var bottomLeftPoint : CGPoint
    
}

public enum Orientation {
   case vertical
   case horizontal
   case square
   
    public static  func getOrientation(for Size : CGSize)->Orientation{
       if Size.width == Size.height {
           return .square
       }
       if Size.width > Size.height {
           return .horizontal
       }
       if Size.width < Size.height {
           return .vertical
       }
       return .square
   }
   
}

public enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}

public enum IOSGradientType : String{
    case Linear = "Linear"
    case Radial = "Radial"
}
public enum IOSLinearGradType : Int{
    case LeftRight = 0
    case UpDown = 1
    case TopLeftToBottomRight = 2
    case BottomLeftToTopRight = 3
}

public struct ColorInfoer67890 {
    
    public var solidColor : UIColor = UIColor.black
    public var grad_firstColor : UIColor = UIColor.green
    public var grad_secondColor : UIColor = .blue
    public var radiusForRadialGrad: CGFloat = 0.5
    public var typeOfGradient: IOSGradientType = IOSGradientType.Linear
    public var typeForLinearGrad : IOSLinearGradType = IOSLinearGradType.LeftRight

    public init() {
    }
    public init(solidColor : UIColor) {
        self.solidColor = solidColor
    }
    public init(firstColor : UIColor , secondColor : UIColor) {
        self.grad_firstColor = firstColor
        self.grad_secondColor = secondColor
    }
    public init(firstColor : UIColor , secondColor : UIColor , LinearGradientWith type: IOSLinearGradType) {
        self.grad_firstColor = firstColor
        self.grad_secondColor = secondColor
        self.typeOfGradient = .Linear
        self.typeForLinearGrad = type
    }
    public init(Radial firstColor : UIColor , secondColor : UIColor , RadialGradientWith radius: CGFloat) {
        self.grad_firstColor = firstColor
        self.grad_secondColor = secondColor
        self.typeOfGradient = .Radial
        self.radiusForRadialGrad = radius
    }
    
    private func getGradientLocations( forSize size:CGSize)->[CGPoint] {
        switch typeForLinearGrad {
        case .UpDown:
           return [valueFromPoint(xValue: size.width, yValue: 0), valueFromPoint(xValue: size.width, yValue: size.height)]
        case .LeftRight:
            return [ valueFromPoint(xValue: 0, yValue: 0),valueFromPoint(xValue: size.width, yValue: 0)]
        case .TopLeftToBottomRight:
            return [valueFromPoint(xValue: 0, yValue: 0),valueFromPoint(xValue: size.width, yValue: size.height)]
        case .BottomLeftToTopRight:
            return [valueFromPoint(xValue: size.width, yValue: 0),valueFromPoint(xValue: 0, yValue: size.height)]
       
        }
       
    }
    public func gradientImage(withReferenceSize size: CGSize)-> UIImage? {
        
        var image:UIImage? = UIImage()
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let uilContext = UIGraphicsGetCurrentContext()
        uilContext!.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let colors = [colorArray[0].cgColor, colorArray[1].cgColor]
        let startColor = self.grad_firstColor
        guard let startColorComponents = startColor.cgColor.components
            else { return image}
        
        let endColor = self.grad_secondColor
        guard let endColorComponents = endColor.cgColor.components else { return image}
        let colorComponents: [CGFloat]
            = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        
        // 6
        let locations:[CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents ,locations: locations,count: 2) else { return image }
        
        
        if self.typeOfGradient == .Linear {
            let drawLocation = self.getGradientLocations(forSize: size)
            uilContext?.drawLinearGradient(gradient, start: drawLocation[0], end: drawLocation[1], options: .drawsAfterEndLocation)
            uilContext?.restoreGState()
            
        } else {
            let radialRadius = size.width > size.height ? size.height : size.width

            let center: CGPoint = CGPoint(x: size.width / 2, y: size.height / 2)
                        
            uilContext?.drawRadialGradient(gradient, startCenter: center , startRadius: 0.0 , endCenter: center, endRadius: self.radiusForRadialGrad * radialRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        }
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
}


///  Returns FileManager.default (Singleton To Access all Directory Methods )

//public var IOSDirectory_Manager : FileManager = {
//    return FileManager.default
//}()
//public var HIGHLIGHT_ANIMATION_TIME = 0.15
//public var SHOW_ANIMATION_TIME = 0.35
//public var HIDE_ANIMATION_TIME = 0.25


public func getCurrentTime(timeFormat:String = "yyyy-MM-dd HH:mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    dateFormatter.dateFormat = timeFormat
    let dateString = dateFormatter.string(from: Date())
    return dateString
}


func valueFromPoint(xValue: CGFloat, yValue: CGFloat) -> CGPoint{
    return CGPoint(x: xValue, y: yValue)
}
