//
//  BaseModelInterface.swift
//  MetalEngine
//
//  Created by HKBeast on 24/07/23.
//

import Foundation
import UIKit

public struct Frame{
    var size:CGSize
    public var center:CGPoint
    public var rotation:Float
    var shouldRevert : Bool = false
    var isParentDragging : Bool = false 
    
    public init(size: CGSize, center: CGPoint, rotation: Float, shouldRevert: Bool = false, isParentDragging: Bool = false) {
        self.size = size
        self.center = center
        self.rotation = rotation
        self.shouldRevert = shouldRevert
        self.isParentDragging = isParentDragging
    }
    
    var origin : CGPoint {
        return CGPoint(x: center.x - (size.width/2), y: center.y - (size.height/2))
    }
   
    
    func getRotatedFrame() -> (minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
           let centerX = center.x
           let centerY = center.y
           let width = size.width
           let height = size.height
           let rotationAngle = CGFloat(rotation) * .pi / 180 // Convert to radians

           // Calculate the corners of the original (non-rotated) frame
           let corners = [
               CGPoint(x: centerX - width / 2, y: centerY - height / 2), // top-left
               CGPoint(x: centerX + width / 2, y: centerY - height / 2), // top-right
               CGPoint(x: centerX - width / 2, y: centerY + height / 2), // bottom-left
               CGPoint(x: centerX + width / 2, y: centerY + height / 2)  // bottom-right
           ]

           // Apply the rotation to each corner
           let rotatedCorners = corners.map { point -> CGPoint in
               let translatedX = point.x - centerX
               let translatedY = point.y - centerY
               let rotatedX = translatedX * cos(rotationAngle) - translatedY * sin(rotationAngle)
               let rotatedY = translatedX * sin(rotationAngle) + translatedY * cos(rotationAngle)
               return CGPoint(x: rotatedX + centerX, y: rotatedY + centerY)
           }

           // Find the min and max bounds
           let minX = rotatedCorners.map { $0.x }.min() ?? 0
           let maxX = rotatedCorners.map { $0.x }.max() ?? 0
           let minY = rotatedCorners.map { $0.y }.min() ?? 0
           let maxY = rotatedCorners.map { $0.y }.max() ?? 0

           return (minX, maxX, minY, maxY)
       }
    
    func getRotatedCenter(childPoint:CGPoint)->CGPoint{
          let centerX = center.x
          let centerY = center.y
          
          let childOffSet = childPoint.x - centerX
          let childOffSetY = childPoint.y - centerY
          let rotationAngle = CGFloat(rotation) * .pi / 180 // Convert to radians
          
          let rotatedCenterX = centerX + (childOffSet * cos(rotationAngle) - childOffSetY * sin(rotationAngle))
          let rotatedCenterY = centerY + (childOffSet * sin(rotationAngle) + childOffSetY * cos(rotationAngle))
          
          return CGPoint(x:rotatedCenterX, y:rotatedCenterY)
      }

    
    func getRotatedFrameOriginXOriginY() -> (minX: CGFloat, minY: CGFloat) {
           let centerX = center.x
           let centerY = center.y
           let width = size.width
           let height = size.height
           let rotationAngle = CGFloat(rotation) * .pi / 180 // Convert to radians

           // Calculate the corners of the original (non-rotated) frame
           let corners = [
               CGPoint(x: centerX - width / 2, y: centerY - height / 2), // top-left
               CGPoint(x: centerX + width / 2, y: centerY - height / 2), // top-right
               CGPoint(x: centerX - width / 2, y: centerY + height / 2), // bottom-left
               CGPoint(x: centerX + width / 2, y: centerY + height / 2)  // bottom-right
           ]

           // Apply the rotation to each corner
           let rotatedCorners = corners.map { point -> CGPoint in
               let translatedX = point.x
               let translatedY = point.y
               let rotatedX = translatedX * cos(rotationAngle) - translatedY * sin(rotationAngle)
               let rotatedY = translatedX * sin(rotationAngle) + translatedY * cos(rotationAngle)
               return CGPoint(x: rotatedX + centerX, y: rotatedY + centerY)
           }

           // Find the min and max bounds
        let minX = rotatedCorners[0].x
           let minY = rotatedCorners[0].y
//           let minY = rotatedCorners.map { $0.y }.min() ?? 0
//           let maxY = rotatedCorners.map { $0.y }.max() ?? 0

           return (minX, minY)
       }
    
    func getRotatedFrame(parentFrame: Frame) -> (minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        // Parent frame's minX and minY
        let parentMinX = parentFrame.center.x - parentFrame.size.width / 2
        let parentMinY = parentFrame.center.y - parentFrame.size.height / 2

        let centerX = center.x
        let centerY = center.y
        let width = size.width
        let height = size.height
        let rotationAngle = CGFloat(rotation) * .pi / 180 // Convert rotation to radians

        // Calculate the corners of the original (non-rotated) frame
        let corners = [
            CGPoint(x: centerX - width / 2, y: centerY - height / 2), // top-left
            CGPoint(x: centerX + width / 2, y: centerY - height / 2), // top-right
            CGPoint(x: centerX - width / 2, y: centerY + height / 2), // bottom-left
            CGPoint(x: centerX + width / 2, y: centerY + height / 2)  // bottom-right
        ]

        // Apply the rotation to each corner and adjust with parent's minX and minY
        let rotatedCorners = corners.map { point -> CGPoint in
            let translatedX = point.x - centerX
            let translatedY = point.y - centerY
            let rotatedX = translatedX * cos(rotationAngle) - translatedY * sin(rotationAngle)
            let rotatedY = translatedX * sin(rotationAngle) + translatedY * cos(rotationAngle)
            return CGPoint(x: rotatedX + centerX + parentMinX, y: rotatedY + centerY + parentMinY)
        }

        // Find the min and max bounds
        let minX = rotatedCorners.map { $0.x }.min() ?? 0
        let maxX = rotatedCorners.map { $0.x }.max() ?? 0
        let minY = rotatedCorners.map { $0.y }.min() ?? 0
        let maxY = rotatedCorners.map { $0.y }.max() ?? 0

        return (minX, maxX, minY, maxY)
    }

       func getCombinedMinMaxFrame(with other: Frame) -> (minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
           let selfBounds = getRotatedFrame()
           let otherBounds = other.getRotatedFrame()

           // Combine the bounds by taking min and max of respective values
           let combinedMinX = min(selfBounds.minX, otherBounds.minX)
           let combinedMaxX = max(selfBounds.maxX, otherBounds.maxX)
           let combinedMinY = min(selfBounds.minY, otherBounds.minY)
           let combinedMaxY = max(selfBounds.maxY, otherBounds.maxY)

           return (combinedMinX, combinedMaxX, combinedMinY, combinedMaxY)
       }
    
    func isEqual(newFrame : Frame) -> Bool {
        return self.size.equalTo(newFrame.size) && self.center.equalTo(newFrame.center) && self.rotation.isEqual(to:newFrame.rotation)
    }
}

public struct StartDuration: Equatable{
    var startTime: Float
    var duration: Float
    
}

public protocol BaseModelProtocol {
    var identity : String {get set}

    var modelId: Int { get set }
    var modelType: ContentType { get set }
    var dataId: Int { get set }
    var posX: Float { get set }
    var posY: Float { get set }
    var width: Float { get set }
    var height: Float { get set }
    var prevAvailableWidth: Float { get set }
    var prevAvailableHeight: Float { get set }
    var rotation: Float { get set }
    var modelOpacity: Float { get set }
    var modelFlipHorizontal: Bool { get set }
    var modelFlipVertical: Bool { get set }
    var lockStatus: Bool { get set }
    var orderInParent: Int { get set }
    var parentId: Int { get set }
    var bgBlurProgress: Float { get set }
    var overlayDataId: Int { get set }
    var overlayOpacity: Float { get set }
    var startTime: Float { get set }
    var duration: Float { get set }
    var softDelete: Bool { get set }
    var isHidden: Bool { get set }
    var templateID:Int {get set}
    var size:CGSize {get set}
    var center:CGPoint {get set}
    var baseFrame:Frame {get set}
    var baseTimeline: StartDuration {get set}
    
    var inAnimation : AnimTemplateInfo {get set}
    var inAnimationDuration : Float {get set}
    
    var outAnimation : AnimTemplateInfo {get set}
    var outAnimationDuration : Float {get set}
    
    var loopAnimation : AnimTemplateInfo {get set}
    var loopAnimationDuration : Float {get set}
    
    // Filters and Adjustment related changes done by NK.
    var filterType : FiltersEnum {get set}
    var brightnessIntensity : Float {get set}
    var contrastIntensity : Float {get set}
    var highlightIntensity : Float {get set}
    var shadowsIntensity : Float {get set}
    var saturationIntensity : Float {get set}
    var vibranceIntensity : Float {get set}
    var sharpnessIntensity : Float {get set}
    var warmthIntensity : Float {get set}
    var tintIntensity : Float {get set}
    
    var hasMask: Bool { get set }
    var maskShape: String { get set }

}


extension BaseModelProtocol {
    
    var size : CGSize {
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
}

protocol StickerModelProtocol {
    var stickerId: Int { get set }
    var imageId: Int { get set }
    var stickerType: String { get set }
    var stickerFilterType: Int { get set }
    var stickerHue: Float { get set }
    var stickerColor: UIColor { get set }
    var xRotationProg: Int { get set }
    var yRotationProg: Int { get set }
    var zRotationProg: Int { get set }
    var stickerModelType : String { get set }
   
}


protocol TextModelProtocol {
    var textId: Int { get set }
    var text: String { get set }
    var textFont: UIFont { get set }
    var textColor: UIColor { get set }
    var textGravity: HTextGravity { get set }
    var lineSpacing: Float { get set }
    var letterSpacing: Float { get set }
    var shadowColor: UIColor { get set }
    var shadowOpacity: Float { get set }
    var shadowRadius: Float { get set }
    var shadowDx: Float { get set }
    var shadowDy: Float { get set }
    var bgType: Int { get set }
    var bgDrawable: String { get set }
    var bgColor: UIColor { get set }
    var bgAlpha: Float { get set }
    var internalWidthMargin: Float { get set }
    var internalHeightMargin: Float { get set }
    var xRotationProg: Int { get set }
    var yRotationProg: Int { get set }
    var zRotationProg: Int { get set }
    var curveProg: Int { get set }
}

public protocol ImageProtocol {
    var imageID: Int { get set }
    var imageType: ImageSourceType { get set }
    var serverPath: String { get set }
    var localPath: String { get set }
    var resID: String { get set }
    var isEncrypted: Bool { get set }
//    var cropX: Float { get set }
//    var cropY: Float { get set }
//    var cropW: Float { get set }
//    var cropH: Float { get set }
    var cropRect: CGRect { get set }
    var cropStyle: ImageCropperType { get set }
    var tileMultiple: Float { get set }
    var colorInfo: String { get set }
    var imageWidth: Double { get set }
    var imageHeight: Double { get set }
    //func getImage()->Image?
    var isTexurable : Bool { get }
    var sourceType : SOURCETYPE{get set}
    var changeOrReplaceImage : ReplaceModel?{get set}
    
  

}

protocol OverlayProtocol {
    var overlayID: Int { get set }
    var overlayType: ImageSourceType { get set }
    var overlayServerPath: String { get set }
    var overlayLocalPath: String { get set }
    var overlayResID: String { get set }
    var overlayIsEncrypted: Bool { get set }
    var overlayCropX: Float { get set }
    var overlayCropY: Float { get set }
    var overlayCropW: Float { get set }
    var overlayCropH: Float { get set }
    var overlayCropStyle: Int { get set }
    var overlayTileMultiple: Float { get set }
    var overlayColorInfo: String { get set }
    var overlayWidth: Double { get set }
    var overlayHeight: Double { get set }
    func getOverLay()->ImageNName?
}

protocol RatioModelProtocol {
    var id: Int { get set }
    var category: String { get set }
    var categoryDescription: String { get set }
    var imageResId: String { get set }
    var ratioWidth: Float { get set }
    var ratioHeight: Float { get set }
    var outputWidth: Float { get set }
    var outputHeight: Float { get set }
    var isPremium: Int { get set }
    
}

extension OverlayProtocol{
    func getOverLay()->Data?{
        if let image =  UIImage(named: overlayResID){
            let imgModel = ImageNName(image: image, imageName: nil)
            return imageData(from: imgModel)
        }
        return nil
    }
}

extension ImageProtocol{
    func getImage()->ImageNName?{
        if imageType == .COLOR || imageType == .GRADIENT{
            return nil
        }
        else if imageType == .STORAGEIMAGE{
            if let image = loadImage(at: serverPath){
                let imgModel = ImageNName(image: image, imageName: nil)
              return  imgModel
            }
        }else{
            if let image = UIImage(named: resID){
                let imgModel = ImageNName(image: image, imageName: nil)
               return imgModel
            }
        }
        return nil
    }
 
    public var isTexurable : Bool  {
        
        return  imageType != .GRADIENT && imageType != .COLOR
    }
}




/*
 
 struct Image
    image : UIImage
    name :
 
 
 please test image to texture and texture to image methods if they are working or not
 copy pasting methods doesnt mean your work is done , they should be running
 otherwise i have to do it
 make sure all assets are copy paste
 Text
 parent Child Graph
 Create Child Methods ( create Parent , ChildSticker ,text page )
 
 
 */
