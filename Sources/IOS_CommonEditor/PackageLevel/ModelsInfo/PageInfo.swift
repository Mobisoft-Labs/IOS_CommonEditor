//
//  PageInfo.swift
//  MetalEngine
//
//  Created by HKBeast on 28/07/23.
//

import Foundation
import UIKit
import SwiftUI
public protocol AnyBGContent{
  //  var type : ImageSourceType {get}

}
public struct LockUnlockModel{
    let id:Int
    let lockStatus:Bool
}


//struct GradientColorInfo : AnyBGContent{
//    var firstColor: UIColor = .black
//    var secondColor: UIColor = .white
//    var endRadius: Float = 1
//    var gradientType: GradientType = .Linear
//}

//struct :AnyBGContent{
//    var type : ImageSourceType = .COLOR
//    var bgGradient: String
//    
//    var gradientInfo : GradientInfo?
//    
//    
//    init( bgGradient: String) {
//        self.bgGradient = bgGradient
//    }
//    
//    var dbValue : String {
//        return bgGradient
//    }
//    
//}

public struct BGWallpaper:AnyBGContent{
    public var type: ImageSourceType = .WALLPAPER
    
    public var content:ImageModel
    
    public init(content: ImageModel) {
        self.content = content
    }
}

public struct BGTexture:AnyBGContent{
    public var content:ImageModel
    
    public init(content: ImageModel) {
        self.content = content
    }
}

public struct BGUserImage:AnyBGContent{
    public var content:ImageModel
    
    public init(content: ImageModel) {
        self.content = content
    }
}

public struct BGColor:AnyBGContent{
    public var type : ImageSourceType = .COLOR
   // var bgColor_str: String
    public var bgColor : UIColor
    
    public init( bgColor: String) {
        self.bgColor = bgColor.convertIOSColorStringToUIColor()
    }
    
    public init( bgColor: UIColor) {
        self.bgColor = bgColor
    }
    
    public var stringValue : String {
        return bgColor.toUIntString()
    }
}

public struct TextColor:AnyBGContent{
    public var type : ImageSourceType = .COLOR
   // var bgColor_str: String
    public var textColor : UIColor
    
    public init( textColor: String) {
        self.textColor = textColor.convertIOSColorStringToUIColor()
    }
    
    public init( textColor: UIColor) {
        self.textColor = textColor
    }
    
    public var stringValue : String {
        return textColor.toUIntString()
    }
}

public struct BGOverlay:AnyBGContent{
    public var content:ImageModel
    
    public init(content: ImageModel) {
        self.content = content
    }
}
//struct UserImageCropped{
//    var image: UIImage
//}

public struct TextureSize{
    public var tileSize: Float
}

public struct BGBlur{
    public var blur: Float
}

//struct BGOverlay{
//    var overlayImage: String
//}
//
//struct BGOverlayOpacity{
//    var overlayOpacity: Float
//}








//protocol AnyBGType{
//    var userImage: UserImage { get }
//    var wallpaper: Wallpaper { get }
//    var texture: BGTexture { get }
//    var textureSize: TextureSize { get }
//    var bgColor: BGColor { get }
//    var gradient: GradientColorInfo { get }
//    var bgBlur: BGBlur { get }
//}

public enum GradientType{
    case Linear
    case Radial
}

public enum ColorInfoType{
    case Color
    case Gradient
}

public class PageInfo:ParentModel,ImageProtocol, Equatable  {
    public var changeOrReplaceImage: ReplaceModel?
    
    
    public static func == (lhs: PageInfo, rhs: PageInfo) -> Bool {
        return lhs.modelId == rhs.modelId
    }
    
    @Published var lockUnlockState = [LockUnlockModel]()

    var unlockedModel = [LockUnlockModel]()
    public var sourceType: SOURCETYPE = .BUNDLE
   
    
    override init() {
        super.init()
        identity = "Page"
        editState = true
    }
    // Page Tile Multiple
    @Published public var beginTileMultiple: Float = 1
    @Published public var endTileMultiple: Float = 1
    
    // Page BlurProgress
    @Published public var beginBlur: Float = 0
    @Published public var endBlur: Float = 0
    
//    @Published var oldGradientInfo: GradientColorInfo = GradientColorInfo(firstColor: .black, secondColor: .white, endRadius: 1, gradientType: .Linear)
//    @Published var newGradientInfo: GradientColorInfo = GradientColorInfo(firstColor: .black, secondColor: .white, endRadius: 1, gradientType: .Linear)
    @Published public var endOverlayOpacity: Float = 1
    @Published public var beginOverlayOpacity: Float = 1

    // Page Gradient Info
//    @Published var oldGradientInfo: GradientColorInfo = GradientColorInfo(firstColor: .red, secondColor: .red, endRadius: 2.0, gradientType: .Linear)
//    @Published var newGradientInfo: GradientColorInfo = GradientColorInfo(firstColor: .red, secondColor: .red, endRadius: 2.0, gradientType: .Linear)

    //override the model type.
    override public var modelType: ContentType {
            get { return .Page }
            set { }
        }
    
//    var imageType: ImageSourceType = .Bundle
    
    public var isEncrypted: Bool = false
    
    
    //image model
    public var imageID: Int = -1
    public var imageType: ImageSourceType = .COLOR
    public var serverPath: String = ""
    public var localPath: String = ""
    @Published public var resID: String = ""
    //var isEncrypted: Bool = false
    var cropX: Float = 0.0
    var cropY: Float = 0.0
    var cropW: Float = 1.0
    var cropH: Float = 1.0
    public var cropRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    public var cropStyle: ImageCropperType = .ratios
    @Published public var tileMultiple: Float = 1.0
    public var colorInfo: String = "-15592942"
    @Published public var color: UIColor = .clear
//    @Published var gradient: GradientColorInfo = GradientColorInfo(firstColor: .red, secondColor: .red, endRadius: 2.0, gradientType: .Linear)
    @Published var colorInfoType: ColorInfoType = .Color
    public var imageWidth: Double = 300
    public var imageHeight: Double = 300
    @Published public var bgContent:AnyBGContent?
    public var beginBgContent:AnyBGContent?
    @Published public var endBgContent:AnyBGContent?
    @Published public var bgOverlayContent:AnyBGContent?
//    @Published var beginOverlayContent:AnyBGContent?
    @Published public var endOverlayContent:AnyBGContent?
    
    //overlay model

    var overlayID: Int = -1
    
    public var overlayType: ImageSourceType = .OVERLAY
    
    var overlayServerPath: String = " "
    
    var overlayLocalPath: String = " "
    
    @Published var overlayResID: String = " "
    
    var overlayIsEncrypted: Bool = false
    
    var overlayCropX: Float = 0.0
    
    var overlayCropY: Float = 0.0
    
    var overlayCropW: Float = 0.0
    
    var overlayCropH: Float = 0.0
    
    var overlayCropStyle: Int = 0
    
    var overlayTileMultiple: Float = 0.0
    
    var overlayColorInfo: String = " "
//    var children = [ BaseModel]()
    var overlayWidth: Double = 300
    
    var overlayHeight: Double = 300
    var overlaySourceType:SOURCETYPE = .BUNDLE


    func setBaseModel(baseModel:DBBaseModel,refSize: CGSize){
      
        modelId = baseModel.modelId
        parentId = baseModel.parentId
        modelType = ContentType(rawValue: baseModel.modelType) ?? .Text
        dataId = baseModel.dataId
        posX = (baseModel.posX).toFloat() * Float(refSize.width)
        posY = (baseModel.posY).toFloat() * Float(refSize.height)
        width = (baseModel.width).toFloat() * Float(refSize.width)
        height = (baseModel.height).toFloat() * Float(refSize.height)
        prevAvailableWidth = width
        prevAvailableHeight = height
        rotation = (baseModel.rotation).toFloat()
        modelOpacity = (baseModel.modelOpacity).toFloat()/255.0
        modelFlipHorizontal = baseModel.modelFlipHorizontal.toBool()
        modelFlipVertical = baseModel.modelFlipVertical.toBool()
        lockStatus = baseModel.lockStatus.toBool()
        orderInParent = baseModel.orderInParent
        bgBlurProgress = baseModel.bgBlurProgress.toFloat()/255.0
        overlayDataId = baseModel.overlayDataId
        overlayOpacity = baseModel.overlayOpacity.toFloat()/255.0
        startTime = (baseModel.startTime).toFloat()
        duration = (baseModel.duration).toFloat()
        softDelete = baseModel.softDelete.toBool()
        isHidden = baseModel.isHidden
        templateID = baseModel.templateID
        hasMask = baseModel.hasMask.toBool()
        maskShape = baseModel.maskShape
        baseFrame = Frame(size: CGSize(width: Double(baseModel.width * Double(refSize.width)), height: Double(baseModel.height * Double(refSize.height))), center: CGPoint(x: Double(baseModel.posX * Double(refSize.width)), y: Double(baseModel.posY * Double(refSize.height))), rotation: self.rotation)
        beginOverlayOpacity = overlayOpacity
        beginBlur = bgBlurProgress
        baseTimeline = StartDuration(startTime: (baseModel.startTime).toFloat(), duration: (baseModel.duration).toFloat())
        
        //Changes for filter done by NK.
        filterType = getFilter(filterNumber: baseModel.filterType)
        brightnessIntensity = baseModel.brightnessIntensity
        contrastIntensity = baseModel.contrastIntensity
        highlightIntensity = baseModel.highlightIntensity
        shadowsIntensity = baseModel.shadowsIntensity
        saturationIntensity = baseModel.saturationIntensity
        vibranceIntensity = baseModel.vibranceIntensity
        sharpnessIntensity = baseModel.sharpnessIntensity
        warmthIntensity = baseModel.warmthIntensity
        tintIntensity = baseModel.tintIntensity
      
    }
    func setImageModel(image: DBImageModel) {
        self.imageID = image.imageID
        self.imageType = ImageSourceType(rawValue: image.imageType) ?? .COLOR
        self.serverPath = image.serverPath
        self.localPath = image.localPath
        self.resID = image.resID
        self.isEncrypted = image.isEncrypted.toBool()
        //        self.cropX = (image.cropX).toFloat()
        //        self.cropY = (image.cropY).toFloat()
        //        self.cropW = (image.cropW).toFloat()
        //        self.cropH = (image.cropH).toFloat()
        self.cropRect.origin.x = image.cropX
        self.cropRect.origin.y = image.cropY
        if image.cropW == 0.0{
            self.cropRect.size.width = 1
            self.cropRect.size.height = 1
        }else{
            self.cropRect.size.width = image.cropW
            self.cropRect.size.height = image.cropH
        }
        //        self.cropStyle = image.cropStyle
        self.cropStyle = ImageCropperType(rawValue: image.cropStyle) ?? .ratios// image.cropStyle
        self.tileMultiple = (image.tileMultiple).toFloat()
        self.colorInfo = image.colorInfo
        self.imageWidth = image.imageWidth
        
        
        self.templateID = image.templateID
        self.sourceType = SOURCETYPE(rawValue: image.sourceTYPE) ?? .BUNDLE
        
        if imageType == .COLOR{
            bgContent = BGColor(bgColor: colorInfo)
            endBgContent = bgContent
        }else if imageType == .GRADIENT{
            if let gradient = parseGradient(from: colorInfo){
                
                bgContent = gradient
                endBgContent = bgContent
                imageWidth = 300
                imageHeight = 300
            }
        }
        else if imageType == .WALLPAPER{
            // get image from local path / server path
            
            bgContent = BGWallpaper(content: ImageModel(imageType: self.imageType, serverPath: image.serverPath, localPath: image.localPath, cropRect: self.cropRect, sourceType: self.sourceType, tileMultiple: image.tileMultiple, cropType: self.cropStyle,imageWidth: 300,imageHeight: 300))
            endBgContent = bgContent
            
        }
        else if imageType == .TEXTURE{
            
            bgContent = BGTexture(content: ImageModel(imageType: self.imageType, serverPath: image.serverPath, localPath: image.localPath, cropRect: self.cropRect, sourceType: self.sourceType, tileMultiple: image.tileMultiple, cropType: self.cropStyle,imageWidth: 300,imageHeight: 300))
            endBgContent = bgContent
            
        }else if imageType == .IMAGE{
            
            bgContent = BGUserImage(content: ImageModel(imageType: self.imageType, serverPath: image.serverPath, localPath: image.localPath, cropRect: self.cropRect, sourceType: self.sourceType, tileMultiple: image.tileMultiple, cropType: self.cropStyle,imageWidth: 300,imageHeight: 300))
            endBgContent = bgContent
        }else if imageType == .STORAGEIMAGE{
            bgContent = BGUserImage(content: ImageModel(imageType: self.imageType, serverPath: image.serverPath, localPath: image.localPath, cropRect: self.cropRect, sourceType: self.sourceType, tileMultiple: image.tileMultiple, cropType: self.cropStyle,imageWidth: 300,imageHeight: 300))
            endBgContent = bgContent
        }
        beginTileMultiple = tileMultiple
    }
    
    func setOverlayModel(image: DBImageModel) {
        self.overlayID = image.imageID
        self.overlayType = ImageSourceType(rawValue: image.imageType) ?? .COLOR
        self.overlayServerPath = image.serverPath
        self.overlayLocalPath = image.localPath
        self.overlayResID = image.resID
        self.overlayIsEncrypted = image.isEncrypted.toBool()
        self.overlayCropX = (image.cropX).toFloat()
        self.overlayCropY = (image.cropY).toFloat()
        self.overlayCropW = (image.cropW).toFloat()
        self.overlayCropH = (image.cropH).toFloat()
        self.overlayCropStyle = image.cropStyle
        self.overlayTileMultiple = (image.tileMultiple).toFloat()
        self.overlayColorInfo = image.colorInfo//colorFromRGB(Int(image.colorInfo)!)
        self.overlayWidth = image.imageWidth
        self.overlayHeight = image.imageHeight
        self.templateID = templateID
        self.overlaySourceType = SOURCETYPE(rawValue: image.sourceTYPE) ?? .BUNDLE
        
        if overlayDataId > 0 {
            
            bgOverlayContent = BGOverlay(content: ImageModel(imageType: self.overlayType, serverPath: image.serverPath, localPath: image.localPath, cropRect: self.cropRect, sourceType: overlaySourceType, tileMultiple: Double(overlayTileMultiple), cropType: self.cropStyle,imageWidth: image.imageWidth,imageHeight: image.imageHeight))
            
//            beginOverlayContent = bgOverlayContent
        }
        endOverlayContent = bgOverlayContent
    }
   // func addChild(child:BaseModel){
     //   self.children.append(child)
    //}
  //  func addChild(child:BaseModelProtocol){
//    func addChild(child:BaseModel){
//        self.children.append(child)
//    }
     func getBaseModel(refSize:CGSize) -> DBBaseModel {
        return DBBaseModel(
            filterType: filterType.rawValue,
            brightnessIntensity: brightnessIntensity,
            contrastIntensity: contrastIntensity,
            highlightIntensity: highlightIntensity,
            shadowsIntensity: shadowsIntensity,
            saturationIntensity: saturationIntensity,
            vibranceIntensity: vibranceIntensity,
            sharpnessIntensity: sharpnessIntensity,
            warmthIntensity: warmthIntensity,
            tintIntensity: tintIntensity,
            
                        hasMask: hasMask.toInt(),
                        maskShape: maskShape,
            parentId: parentId,
            modelId: modelId,
            modelType: modelType.rawValue,
            dataId: dataId,
            posX: modelType == .Page ? 0.5 : (baseFrame.center.x).toDouble()/refSize.width,
            posY: modelType == .Page ? 0.5 : (baseFrame.center.y).toDouble()/refSize.height,
            width: modelType == .Page ? 1.0 :(baseFrame.size.width).toDouble()/refSize.width,
            height: modelType == .Page ? 1.0 :(baseFrame.size.height).toDouble()/refSize.height,
            prevAvailableWidth: (prevAvailableWidth).toDouble()/refSize.width,
            prevAvailableHeight: (prevAvailableHeight).toDouble()/refSize.height,
            rotation: (baseFrame.rotation).toDouble(),
            modelOpacity: (modelOpacity).toDouble()*255,
            modelFlipHorizontal: modelFlipHorizontal.toInt(),
            modelFlipVertical: modelFlipVertical.toInt(),
            lockStatus: lockStatus.toString(),
            orderInParent: orderInParent,
            bgBlurProgress: bgBlurProgress.toInt()*255,
            overlayDataId: overlayDataId,
            overlayOpacity: overlayOpacity.toInt()*255,
//            startTime: (startTime).toDouble(),
//            duration: (duration).toDouble(),
            startTime: (baseTimeline.startTime).toDouble(),
            duration: (baseTimeline.duration).toDouble(),
            softDelete: softDelete.toInt(),
            isHidden: isHidden,
            templateID: templateID
        )
        // HK ** make this 360 , 255 Standard variable Global 
    }
    func getOverlayModel() -> DBImageModel {
          var imageModel = DBImageModel()
        imageModel.imageID = self.overlayDataId
//        imageModel.imageType = self.overlayType.rawValue
//          imageModel.serverPath = self.overlayServerPath
//          imageModel.localPath = self.overlayLocalPath
//          imageModel.resID = self.overlayResID
//        imageModel.isEncrypted = self.overlayIsEncrypted.toInt()
//        imageModel.cropX = (self.overlayCropX).toDouble()
//        imageModel.cropY = (self.overlayCropY).toDouble()
//        imageModel.cropW = (self.overlayCropW).toDouble()
//        imageModel.cropH = (self.overlayCropH).toDouble()
//          imageModel.cropStyle = self.overlayCropStyle
//        imageModel.tileMultiple = (self.overlayTileMultiple).toDouble()
//        imageModel.colorInfo = self.overlayColorInfo
//          imageModel.imageWidth = self.overlayWidth
//          imageModel.imageHeight = self.overlayHeight
//        imageModel.templateID = self.templateID
//        imageModel.sourceTYPE = self.sourceType.rawValue
        if overlayDataId > 0 {
            if let bgOverlay = bgOverlayContent as? BGOverlay{
                imageModel.imageType = bgOverlay.content.imageType.rawValue
                imageModel.serverPath = bgOverlay.content.serverPath
                imageModel.localPath = bgOverlay.content.localPath
//                imageModel.resID = bgOverlay.resID
//                imageModel.isEncrypted = bgOverlay.isEncrypted.toInt()
                //         imageModel.cropX = (self.cropX).toDouble()
                //         imageModel.cropY = (self.cropY).toDouble()
                //         imageModel.cropW = (self.cropW).toDouble()
                //         imageModel.cropH = (self.cropH).toDouble()
                imageModel.cropX = bgOverlay.content.cropRect.origin.x
                imageModel.cropY = bgOverlay.content.cropRect.origin.y
                imageModel.cropW = bgOverlay.content.cropRect.size.width
                imageModel.cropH = bgOverlay.content.cropRect.size.height
                //imageModel.cropStyle = bgOverlay.content.cropStyle.rawValue
                imageModel.tileMultiple = (bgOverlay.content.tileMultiple)
                //imageModel.colorInfo = self.colorInfo
                imageModel.imageWidth = bgOverlay.content.imageWidth
                imageModel.imageHeight = bgOverlay.content.imageHeight
                imageModel.templateID = self.templateID
                imageModel.sourceTYPE = bgOverlay.content.sourceType.rawValue
            }
        }
        
        
          return imageModel
      }
    
    

    
    func getDBImageModel() -> DBImageModel {
        // bgContent typcase
        endBgContent = bgContent
        
          var imageDBModel = DBImageModel()
        imageDBModel.imageID = self.dataId
        var imageModel:ImageModel?
        if bgContent == nil{
            imageDBModel.imageType = ImageSourceType.COLOR.rawValue
            imageDBModel.colorInfo = "4294967295"
        }
        if let color = bgContent as? BGColor{
            imageDBModel.imageType = ImageSourceType.COLOR.rawValue
            imageDBModel.colorInfo = color.stringValue
            
        }
        if let gradient = bgContent as? GradientInfo{
            imageDBModel.imageType = ImageSourceType.GRADIENT.rawValue
            imageDBModel.colorInfo = convertGradientToJSONString(bgContent as! GradientInfo)!
        }
            
//        }else{
           
            if let wallpaper = bgContent as? BGWallpaper{
                imageModel = wallpaper.content
                
            }
            if let texture = bgContent as? BGTexture{
                imageModel = texture.content
            }
            
            if let image = bgContent as? BGUserImage{
                imageModel = image.content
            }
            
//            let model = (bgContent as! BGWallpaper).content
            if let newImageModel = imageModel{
                imageDBModel.imageType = newImageModel.imageType.rawValue
                imageDBModel.serverPath = newImageModel.serverPath
                imageDBModel.localPath = newImageModel.localPath
//                imageDBModel.resID = self.resID
//                imageDBModel.isEncrypted = self.isEncrypted.toInt()
            //         imageModel.cropX = (self.cropX).toDouble()
            //         imageModel.cropY = (self.cropY).toDouble()
            //         imageModel.cropW = (self.cropW).toDouble()
            //         imageModel.cropH = (self.cropH).toDouble()
                imageDBModel.cropX = newImageModel.cropRect.origin.x
                imageDBModel.cropY = newImageModel.cropRect.origin.y
                imageDBModel.cropW = newImageModel.cropRect.size.width
                imageDBModel.cropH = newImageModel.cropRect.size.height
//                imageDBModel.cropStyle = newImageModel.cropStyle.rawValue
//                imageDBModel.tileMultiple = (model.tileMultiple)
            //imageModel.colorInfo = self.colorInfo
                imageDBModel.imageWidth = newImageModel.imageWidth
                imageDBModel.imageHeight = newImageModel.imageHeight
                imageDBModel.templateID = self.templateID
                imageDBModel.sourceTYPE = newImageModel.sourceType.rawValue
        }
          return imageDBModel
    }
//    func getImageProtocolo()->ImageProtocol{
//        let img = ImageProtocol()
//        
//        return ImageProtocol
//    }
//     
//    func setPageFromServer(page:DBPage){
////        self.
//    }
    
    static  func createDefaultPage(bgType:AnyBGContent,baseSize:CGSize?)->PageInfo{
        var page = PageInfo()
        if baseSize != nil{
            page.baseFrame = Frame(size: baseSize!, center: CGPoint(x: baseSize!.width/2, y: baseSize!.height/2), rotation: 0)
        }
       
            page.baseTimeline.duration = 5.0
        
            page.bgContent = bgType
         
            return page
        
      
    }
    
//    func decreaseOrderOFChildren(at order:Int)->Set<Int>{
//        var updatedID = Set<Int>()
//        for child in children.suffix(from: order){
//            child.orderInParent -= 1
//            updatedID.insert(child.modelId)
//        }
//        return updatedID
//    }
//    
//    func increaseOrderOFChildren(at order:Int)->Set<Int>{
//        var updatedID = Set<Int>()
//        for child in children.suffix(from: order){
//            child.orderInParent += 1
//            updatedID.insert(child.modelId)
//        }
//        return updatedID
//    }
//    
   
    
}
