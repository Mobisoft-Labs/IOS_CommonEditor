//
//  ImageUtility.swift
//  FlyerDemo
//
//  Created by HKBeast on 04/11/25.
//

import Foundation
import UIKit

struct ImageNName{
    let image:UIImage?
    let imageName:String?
}

extension UIImage {
    public var mySize : CGSize {
        return CGSize(width: self.cgImage!.width, height: self.cgImage!.height)
    }
}

public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    if image.mySize.findMax() <= targetSize.findMax() {
        return image
    }
    
    let size = image.mySize
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

func computeIdealMaxResizeDimension(
    for image: UIImage,
    cropRect: CGRect,
    minCropSide: CGFloat = 500
) -> CGSize {
    let originalWidth = image.mySize.width
    let originalHeight = image.mySize.height
    let maxOriginalSide = max(originalWidth, originalHeight)

    // Calculate how large the crop rect is in the original image
    let cropWidth = cropRect.width * originalWidth
    let cropHeight = cropRect.height * originalHeight

    // Calculate scale needed to make crop >= 500
    let scaleW = minCropSide / cropWidth
    let scaleH = minCropSide / cropHeight
    let requiredScale = max(scaleW, scaleH, 1)

    let scaledMaxSide = maxOriginalSide * requiredScale

    if scaledMaxSide >= maxOriginalSide {
        return CGSize(width: maxOriginalSide, height: maxOriginalSide)
    }
    
    // Clamp to original size if scaling up would cause blur
    return CGSize(width: scaledMaxSide, height: scaledMaxSide)
}

extension UIImage {
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        
        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        return imageColored
    }
}
