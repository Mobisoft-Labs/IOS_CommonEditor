//
//  StickerInfo.swift
//  MetalEngine
//
//  Created by HKBeast on 24/07/23.
//

import Foundation
import UIKit

public protocol AnyColorFilter{
    
}
public struct ColorFilter:AnyColorFilter{
    public var filter:UIColor
    public init(filter: UIColor) {
        self.filter = filter
    }
}
public struct HueFilter:AnyColorFilter{
    public var filter:Float
    public init(filter: Float) {
        self.filter = filter
    }
}
public struct NoneFilter:AnyColorFilter{
    public var filter:Bool
    
    public init(filter: Bool) {
        self.filter = filter
    }
}

public class StickerInfo:BaseModel ,StickerModelProtocol,ImageProtocol{
    
    
    func getCopy() -> StickerInfo{
        var stickerInfo = StickerInfo()
        stickerInfo.changeOrReplaceImage = self.changeOrReplaceImage
        stickerInfo.cropStyle = self.cropStyle
        stickerInfo.cropRect = self.cropRect
        stickerInfo.imageID = self.imageID
        stickerInfo.stickerColor = self.stickerColor
        stickerInfo.stickerFilterType = self.stickerFilterType
        stickerInfo.imageType = self.imageType
        stickerInfo.localPath = self.localPath
        stickerInfo.serverPath = self.serverPath
        stickerInfo.sourceType = self.sourceType
        stickerInfo.stickerHue = self.stickerHue
        stickerInfo.tileMultiple = self.tileMultiple
        stickerInfo.colorInfo = self.colorInfo
        stickerInfo.imageHeight = self.imageHeight
        stickerInfo.imageWidth = self.imageWidth
        stickerInfo.isEncrypted = self.isEncrypted
        stickerInfo.resID = self.resID
        stickerInfo.stickerFilter = self.stickerFilter
        stickerInfo.stickerId = self.stickerId
        stickerInfo.stickerImageContent = self.stickerImageContent
        stickerInfo.stickerType = self.stickerType
        stickerInfo.stickerModelType = self.stickerModelType
        stickerInfo.xRotationProg = self.xRotationProg
        stickerInfo.yRotationProg = self.yRotationProg
        stickerInfo.zRotationProg = self.zRotationProg
        stickerInfo.baseFrame = self.baseFrame
        stickerInfo.baseTimeline = self.baseTimeline
        stickerInfo.modelType = self.modelType
        stickerInfo.modelFlipHorizontal = self.modelFlipHorizontal
        stickerInfo.modelFlipVertical = self.modelFlipVertical
        stickerInfo.orderInParent = self.orderInParent
        stickerInfo.prevAvailableWidth = self.prevAvailableWidth
        stickerInfo.prevAvailableHeight = self.prevAvailableHeight
        stickerInfo.beginHighlightIntensity = self.beginHighlightIntensity
        stickerInfo.beginOpacity = self.beginOpacity
        stickerInfo.filterType = self.filterType
        stickerInfo.lockStatus = self.lockStatus
        stickerInfo.parentId = self.parentId
        stickerInfo.templateID = self.templateID
        stickerInfo.bgBlurProgress = self.bgBlurProgress
        stickerInfo.brightnessIntensity = self.brightnessIntensity
        stickerInfo.colorAdjustmentType = self.colorAdjustmentType
        stickerInfo.contrastIntensity = self.contrastIntensity
        stickerInfo.highlightIntensity = self.highlightIntensity
        stickerInfo.inAnimation = self.inAnimation
        stickerInfo.outAnimation = self.outAnimation
        stickerInfo.loopAnimation = self.loopAnimation
        stickerInfo.modelOpacity = self.modelOpacity
        stickerInfo.saturationIntensity = self.saturationIntensity
        stickerInfo.shadowsIntensity = self.shadowsIntensity
        stickerInfo.sharpnessIntensity = self.sharpnessIntensity
        stickerInfo.softDelete = self.softDelete
        stickerInfo.thumbImage = self.thumbImage
        stickerInfo.tintIntensity = self.tintIntensity
        stickerInfo.warmthIntensity = self.warmthIntensity
        stickerInfo.vibranceIntensity = self.vibranceIntensity
        stickerInfo.hasMask = self.hasMask
        stickerInfo.maskShape = self.maskShape
        stickerInfo.bgContent = self.bgContent
        stickerInfo.imageID = self.imageID
        stickerInfo.dataId = self.dataId
        stickerInfo.depthLevel = self.depthLevel
        stickerInfo.center = self.center
        stickerInfo.duration = self.duration
        stickerInfo.height = self.height
        stickerInfo.identity = self.identity
        stickerInfo.inAnimationDuration = self.inAnimationDuration
        stickerInfo.outAnimationDuration = self.outAnimationDuration
        stickerInfo.loopAnimationDuration = self.loopAnimationDuration
        stickerInfo.isHidden = self.isHidden
        stickerInfo.isActive = self.isActive
        stickerInfo.isSelectedForMultiSelect = self.isSelectedForMultiSelect
        stickerInfo.overlayOpacity = self.overlayOpacity
        stickerInfo.overlayDataId  = self.overlayDataId
        stickerInfo.posX = self.posX
        stickerInfo.posY =  self.posY
        stickerInfo.rotation = self.rotation
        stickerInfo.width = self.width
        stickerInfo.startTime = self.startTime
        stickerInfo.size = self.size
        return stickerInfo
    }
    
    var bgContent: ImageModel?
    
    
    public var sourceType: SOURCETYPE = .BUNDLE
    init() {
        super.init()
        identity = "Stckr"
    }
    
    
    // Color
    @Published var beginHue: Float = 0
    @Published var endHue: Float = 0
    
    
    
    //override the model type.
    public override var modelType: ContentType {
            get { return .Sticker }
            set { }
        }
    
    //sticker model
    var stickerId: Int = 1
    var imageId: Int = 1
    var stickerType: String = "0"
    var stickerModelType : String = ""
    @Published var stickerFilterType: Int = 0
    @Published var stickerHue: Float = 0
    @Published var stickerColor: UIColor = .red
    @Published var xRotationProg: Int = 1
    @Published var yRotationProg: Int = 1
    @Published var zRotationProg: Int = 1
    
    //image model
    public var imageID: Int = 0
    public var imageType: ImageSourceType = .COLOR
    @Published public var serverPath: String = ""
    @Published public var localPath: String = ""
    @Published public var resID: String = ""
    @Published public var isEncrypted: Bool = false
//    @Published var cropX: Float = 0.0
//    @Published var cropY: Float = 0.0
//    @Published var cropW: Float = 0.0
//    @Published var cropH: Float = 0.0
    @Published public var cropRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    @Published public var cropStyle: ImageCropperType = .ratios
    @Published public var tileMultiple: Float = 1.0
    @Published public var colorInfo: String = ""
    @Published public var imageWidth: Double = 300
    @Published public var imageHeight: Double = 300

    @Published public var stickerFilter:AnyColorFilter?
    @Published public var beginStickerFilter:AnyColorFilter?
    @Published public var endStickerFilter:AnyColorFilter?
    
    @Published var stickerImageContent:ImageModel?
    @Published public var changeOrReplaceImage:ReplaceModel?
    
    
    public func getCropperImage(engineConfig: EngineConfiguration) -> UIImage{
        
        if changeOrReplaceImage?.imageModel.sourceType == .BUNDLE{
            if let localPath = changeOrReplaceImage?.imageModel.localPath{
                let imageName = localPath.components(separatedBy: "/").last!
                
                if let savedImage = UIImage(named: imageName) {
                    return savedImage
                }
                else{
                    print("Error loading image from documents directory")
                    //                    return nil
                }
            }else{
                let imageName = localPath.components(separatedBy: "/").last!
                
                if let savedImage = UIImage(named: imageName) {
                    return savedImage
                }
                else{
                    print("Error loading image from documents directory")
                    //                    return nil
                }
            }
            
        }else if changeOrReplaceImage?.imageModel.sourceType == .DOCUMENT{
            if let localPath = changeOrReplaceImage?.imageModel.localPath{
                let imageName = localPath.components(separatedBy: "/").last!
                do{
                    if let pngData = engineConfig.readDataFromFileFromAssets(fileName: imageName){
                        return UIImage(data: pngData) ?? UIImage(systemName: "xmark.octagon")!
                    }else if let pngDataLocal = engineConfig.readDataFromFileLocalAssets(fileName: imageName){
                        return UIImage(data: pngDataLocal) ?? UIImage(systemName: "xmark.octagon")!
                    }
                    
                    //                if let savedImage = try ImageDownloadManager.loadImageFromDocumentsDirectory(filename: "Assets/"+imageName+".png") {
                    //                    return savedImage
                    //                }
                }catch{
                    print("Error loading image from documents directory")
                    //                    return nil
                }
            }else{
                let imageName = localPath.components(separatedBy: "/").last!
                do{
                    if let pngData = engineConfig.readDataFromFileFromAssets(fileName: imageName+".png"){
                        return UIImage(data: pngData) ?? UIImage(systemName: "xmark.octagon")!
                    }else if let pngDataLocal = engineConfig.readDataFromFileLocalAssets(fileName: imageName+".png"){
                        return UIImage(data: pngDataLocal) ?? UIImage(systemName: "xmark.octagon")!
                    }
                    
                    //                if let savedImage = try ImageDownloadManager.loadImageFromDocumentsDirectory(filename: "Assets/"+imageName+".png") {
                    //                    return savedImage
                    //                }
                }catch{
                    print("Error loading image from documents directory")
                    //                    return nil
                }
            }
            
      
        }else{
            if let localPath = changeOrReplaceImage?.imageModel.serverPath{
                let imageName = localPath.components(separatedBy: "/").last!
                do{
                    if let savedImage = try engineConfig.loadImageFromDocumentsDirectory(filename: imageName, directory: engineConfig.getAssetsPath()!) {
                        return savedImage
                    }
                    
                    else {
                        Task{
                            do{
                                
                                let serverImage = try await engineConfig.fetchImage(imageURL: localPath)
                                
                                if let imageData = serverImage?.pngData() {
                                    try engineConfig.saveImageToDocumentsDirectory(imageData: imageData, filename: imageName, directory: engineConfig.getAssetsPath()!)
                                }
                                return serverImage
                            }
                            catch{
                                print("image is not downloaded for server Path")
                            }
                            return UIImage(systemName: "xmark.octagon")!
                        }
                    }
                }
                catch{
                    print("image not found on server")
                }
            }else{
                let imageName = serverPath.components(separatedBy: "/").last!
                do{
                    if let savedImage = try engineConfig.loadImageFromDocumentsDirectory(filename: imageName, directory: engineConfig.getAssetsPath()!) {
                        return savedImage
                    }
                    
                    else {
                        Task{
                            do{
                                
                                let serverImage = try await engineConfig.fetchImage(imageURL: serverPath)
                                
                                if let imageData = serverImage?.pngData() {
                                    try engineConfig.saveImageToDocumentsDirectory(imageData: imageData, filename: imageName, directory: engineConfig.getAssetsPath()!)
                                }
                                return serverImage
                            }
                            catch{
                                print("image is not downloaded for server Path")
                            }
                            return UIImage(systemName: "xmark.octagon")!
                        }
                    }
                }
                catch{
                    print("image not found on server")
                }
            }
        
        
        }
        return UIImage(systemName: "xmark.octagon")!
    }
    
//    func getImage() -> UIImage {
//        if sourceType == .SERVER{
//            
//            // get image from documents
////            return UIImage(named: serverPath)!
//            if let image = getImageFromDocumentsDirectory(named: serverPath) {
//                return image
//            }else {
//                // Return a placeholder image if the image is not found
//                return UIImage(systemName: "xmark.octagon")!
//            }
//        }else{
//            let filename = (localPath as NSString).lastPathComponent
//            let filenameWithoutExtension = (filename as NSString).deletingPathExtension
//                
//            // Return the UIImage using the extracted filename
//            return UIImage(named: filenameWithoutExtension)!
//        }
//    }
    
    func getImageFromDocumentsDirectory(named: String) -> UIImage? {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(named)
            if fileManager.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
            }
        }
        return nil
    }
  
    func setBaseModel(baseModel:DBBaseModel,refSize: CGSize){
      
        modelId = baseModel.modelId
        parentId = baseModel.parentId
        modelType = ContentType(rawValue: baseModel.modelType) ?? .Text
        dataId = baseModel.dataId
        posX = (baseModel.posX).toFloat() * Float(refSize.width)
        posY = (baseModel.posY).toFloat() * Float(refSize.height)
        width = (baseModel.width).toFloat() * Float(refSize.width)
        height = (baseModel.height).toFloat() * Float(refSize.height)
        prevAvailableWidth = (baseModel.prevAvailableWidth).toFloat() * Float(refSize.width)
        prevAvailableHeight = (baseModel.prevAvailableHeight).toFloat() * Float(refSize.height)
        rotation = (baseModel.rotation).toFloat()
        modelOpacity = (baseModel.modelOpacity).toFloat()/255.0
        modelFlipHorizontal = baseModel.modelFlipHorizontal.toBool()
        modelFlipVertical = baseModel.modelFlipVertical.toBool()
        lockStatus = baseModel.lockStatus.toBool()
        orderInParent = baseModel.orderInParent
        bgBlurProgress = baseModel.bgBlurProgress.toFloat()
        overlayDataId = baseModel.overlayDataId
        overlayOpacity = baseModel.overlayOpacity.toFloat()/255.0
        startTime = (baseModel.startTime).toFloat()
        duration = (baseModel.duration).toFloat()
        softDelete = baseModel.softDelete.toBool()
        isHidden = baseModel.isHidden
        templateID = baseModel.templateID
        baseFrame = Frame(size: CGSize(width: Double(baseModel.width * Double(refSize.width)), height: Double(baseModel.height * Double(refSize.height))), center: CGPoint(x: Double(baseModel.posX * Double(refSize.width)), y: Double(baseModel.posY * Double(refSize.height))), rotation: self.rotation)
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
        
        hasMask = baseModel.hasMask.toBool()
        maskShape = baseModel.maskShape

    }
    
   
    
//    func setBaseModel(baseModel:DBBaseModel){
//      
//        modelId = baseModel.modelId
//        parentId = baseModel.parentId
//        modelType = ContentType(rawValue: baseModel.modelType) ?? .Text
//        dataId = baseModel.dataId
//        posX = (baseModel.posX).toFloat() 
//        posY = (baseModel.posY).toFloat()
//        width = (baseModel.width).toFloat()
//        height = (baseModel.height).toFloat()
//        prevAvailableWidth = (baseModel.prevAvailableWidth).toFloat()
//        prevAvailableHeight = (baseModel.prevAvailableHeight).toFloat()
//        rotation = (baseModel.rotation).toFloat()
//        modelOpacity = (baseModel.modelOpacity).toFloat()/255.0
//        modelFlipHorizontal = baseModel.modelFlipHorizontal.toBool()
//        modelFlipVertical = baseModel.modelFlipVertical.toBool()
//        lockStatus = baseModel.lockStatus.toBool()
//        orderInParent = baseModel.orderInParent
//        bgBlurProgress = baseModel.bgBlurProgress.toFloat()
//        overlayDataId = baseModel.overlayDataId
//        overlayOpacity = baseModel.overlayOpacity.toFloat()/255.0
//        startTime = (baseModel.startTime).toFloat()
//        duration = (baseModel.duration).toFloat()
//        softDelete = baseModel.softDelete.toBool()
//        isHidden = baseModel.isHidden
//        templateID = baseModel.templateID
//        
//        //Changes for filter done by NK.
//        filterType = getFilter(filterNumber: baseModel.filterType)
//        brightnessIntensity = baseModel.brightnessIntensity
//        contrastIntensity = baseModel.contrastIntensity
//        highlightIntensity = baseModel.highlightIntensity
//        shadowsIntensity = baseModel.shadowsIntensity
//        saturationIntensity = baseModel.saturationIntensity
//        vibranceIntensity = baseModel.vibranceIntensity
//        sharpnessIntensity = baseModel.sharpnessIntensity
//        warmthIntensity = baseModel.warmthIntensity
//        tintIntensity = baseModel.tintIntensity
//        
//        hasMask = baseModel.hasMask.toBool()
//        maskShape = baseModel.maskShape
//
//        
//    }

    func setStickerModel(stickerModel:DBStickerModel){
        stickerId = stickerModel.stickerId
        imageId = stickerModel.imageId
        stickerType = stickerModel.stickerType
        stickerModelType = stickerModel.stickerModelType
        stickerFilterType = stickerModel.stickerFilterType
        stickerHue = stickerModel.stickerHue.toFloat()
        if stickerModel.stickerColor == "0"{
            stickerColor = .clear
        }else{
            stickerColor = stickerModel.stickerColor.convertIOSColorStringToUIColor()
        }
        xRotationProg = stickerModel.xRotationProg
        yRotationProg = stickerModel.yRotationProg
        zRotationProg = stickerModel.zRotationProg
        templateID = stickerModel.templateID
        if stickerFilterType == 2{
            stickerFilter = ColorFilter(filter: stickerColor)
        }else if stickerFilterType == 1{
            stickerFilter = HueFilter(filter: stickerHue)
        }else{
            stickerFilter = NoneFilter(filter: true)
        }
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
        self.cropRect.size.width = image.cropW
        self.cropRect.size.height = image.cropH
        self.cropStyle = ImageCropperType(rawValue: image.cropStyle) ?? .ratios// image.cropStyle
        self.tileMultiple = (image.tileMultiple).toFloat()
        self.colorInfo = image.colorInfo
        self.imageWidth = image.imageWidth
        self.imageHeight = image.imageHeight
        templateID = image.templateID
        sourceType = SOURCETYPE(rawValue: image.sourceTYPE) ?? .BUNDLE
        
//        stickerImageContent = ImageModel(imageType: self.imageType, serverPath: serverPath, localPath: localPath, cropRect: cropRect, sourceType: sourceType, tileMultiple: Double(tileMultiple))
        changeOrReplaceImage = ReplaceModel(modelID: modelId, imageModel: ImageModel(imageType: self.imageType, serverPath: serverPath, localPath: localPath, cropRect: cropRect, sourceType: sourceType, tileMultiple: Double(tileMultiple), cropType: ImageCropperType(rawValue: image.cropStyle) ?? .ratios/*cropStyle*/,imageWidth: image.imageWidth,imageHeight: image.imageHeight), baseFrame: baseFrame)
    }
    
    
    public func setImageModel(image: ImageModel) {
//        self.imageID = image.imageID
        self.imageType = image.imageType
        self.serverPath = image.serverPath
        self.localPath = image.localPath
//        self.resID = image.resID
//        self.isEncrypted = image.isEncrypted.toBool()
//        self.cropX = (image.cropX).toFloat()
//        self.cropY = (image.cropY).toFloat()
//        self.cropW = (image.cropW).toFloat()
////        self.cropH = (image.cropH).toFloat()
//        self.cropRect.origin.x = image.cropX
//        self.cropRect.origin.y = image.cropY
//        self.cropRect.size.width = image.cropW
//        self.cropRect.size.height = image.cropH
        
        self.cropRect = image.cropRect
        self.cropStyle = image.cropType
        self.tileMultiple = (image.tileMultiple).toFloat()
//        self.colorInfo = image.colorInfo
//        self.imageWidth = image.imageWidth
//        self.imageHeight = image.imageHeight
//        templateID = image.templateID
        sourceType = image.sourceType
    }
    
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
            posX: (baseFrame.center.x).toDouble()/refSize.width,
            posY: (baseFrame.center.y).toDouble()/refSize.height,
            width: (baseFrame.size.width).toDouble()/refSize.width,
            height: (baseFrame.size.height).toDouble()/refSize.height,
            prevAvailableWidth: (prevAvailableWidth).toDouble()/refSize.width,
            prevAvailableHeight: (prevAvailableHeight).toDouble()/refSize.height,
            rotation: (baseFrame.rotation).toDouble(),
            modelOpacity: (modelOpacity).toDouble()*255.0,
            modelFlipHorizontal: modelFlipHorizontal.toInt(),
            modelFlipVertical: modelFlipVertical.toInt(),
            lockStatus: lockStatus.toString(),
            orderInParent: orderInParent,
            bgBlurProgress: bgBlurProgress.toInt(),
            overlayDataId: overlayDataId,
            overlayOpacity: overlayOpacity.toInt(),
            startTime: (baseTimeline.startTime).toDouble(),
            duration: (baseTimeline.duration).toDouble(),
//            startTime: (startTime).toDouble(),
//            duration: (duration).toDouble(),
            softDelete: softDelete.toInt(),
            isHidden: isHidden,
            templateID: templateID
            
        )
    }

     func getStickerModel() -> DBStickerModel {
         
         if stickerFilterType == 2{
             if let color = stickerFilter as? ColorFilter{
                 stickerColor = color.filter
                 stickerHue = 0
             }
         }
         else if stickerFilterType == 1{
             if let hue = stickerFilter as? HueFilter{
                 stickerColor = .clear
                 stickerHue = hue.filter
             }
         }else{
             stickerColor = .clear
             stickerHue = 0
         }
        return DBStickerModel(
            stickerId: stickerId,
            imageId: imageID,
            stickerType: stickerType,
            stickerFilterType: stickerFilterType,
            stickerHue: stickerHue.toInt(),
            stickerColor: stickerColor.toUIntString(),
            xRotationProg: xRotationProg,
            yRotationProg: yRotationProg,
            zRotationProg: zRotationProg,
            templateID: templateID,
            stickerModelType: stickerModelType
        )
    }
     func getDBImageModel() -> DBImageModel {
           var imageModel = DBImageModel()
           imageModel.imageID = self.imageID
         imageModel.imageType = self.changeOrReplaceImage?.imageModel.imageType.rawValue ?? " "
         imageModel.serverPath = self.changeOrReplaceImage?.imageModel.serverPath ?? " "
           imageModel.localPath = self.changeOrReplaceImage?.imageModel.localPath ?? " "
           imageModel.resID = self.resID
         imageModel.isEncrypted = self.isEncrypted.toInt()
//         imageModel.cropX = (self.cropX).toDouble()
//         imageModel.cropY = (self.cropY).toDouble()
//         imageModel.cropW = (self.cropW).toDouble()
//         imageModel.cropH = (self.cropH).toDouble()
         imageModel.cropX = Double(self.changeOrReplaceImage?.imageModel.cropRect.origin.x ?? 0.0)
         imageModel.cropY = Double(self.changeOrReplaceImage?.imageModel.cropRect.origin.y ?? 0.0)
         imageModel.cropW = Double(self.changeOrReplaceImage?.imageModel.cropRect.size.width ?? 1.0)
         imageModel.cropH = Double(self.changeOrReplaceImage?.imageModel.cropRect.size.height ?? 1.0)
//           imageModel.cropStyle = self.cropStyle
         imageModel.cropStyle = self.changeOrReplaceImage?.imageModel.cropType.rawValue ?? 1 /*self.cropStyle.rawValue*/
         imageModel.tileMultiple = (self.changeOrReplaceImage?.imageModel.tileMultiple ?? 0.0)
         imageModel.colorInfo = self.colorInfo
           imageModel.imageWidth = self.imageWidth
           imageModel.imageHeight = self.imageHeight
         imageModel.templateID = self.templateID
         imageModel.sourceTYPE = self.changeOrReplaceImage?.imageModel.sourceType.rawValue ?? self.sourceType.rawValue
           return imageModel
       }
    
    public static func createDefaultStickerInfo(parentModel:ParentModel,startTime:Float,Order:Int)->StickerInfo{
           let stickerInfo = StickerInfo()
           stickerInfo.baseFrame.size.width = parentModel.baseFrame.size.width/2
           stickerInfo.baseFrame.size.height = parentModel.baseFrame.size.height/2
        // calculate Center
                
                stickerInfo.baseFrame.center.x = parentModel.baseFrame.size.width/2
                stickerInfo.baseFrame.center.y = parentModel.baseFrame.size.height/2
                // calculate Time
//                stickerInfo.startTime = startTime
//                stickerInfo.duration = parentModel.duration - startTime
//        stickerInfo.baseTimeline.startTime = startTime
//        stickerInfo.baseTimeline.duration = parentModel.baseTimeline.duration - startTime
        
        stickerInfo.baseTimeline.startTime = startTime - parentModel.baseTimeline.startTime
        stickerInfo.baseTimeline.duration = parentModel.baseTimeline.duration - (startTime - parentModel.baseTimeline.startTime)
                // calculate opacity
                
                
                // calculate rotation
                //model.rotation =
                
        
                stickerInfo.softDelete = true
                stickerInfo.parentId = parentModel.modelId
                stickerInfo.templateID = parentModel.templateID
              stickerInfo.orderInParent = parentModel.children.count
        stickerInfo.prevAvailableWidth = Float(stickerInfo.baseFrame.size.width)
        stickerInfo.prevAvailableHeight = Float(stickerInfo.baseFrame.size.height)
                
                return stickerInfo
            
    }
    override  func addDefaultModel(parentModel: BaseModelProtocol,baseModel:BaseModel) {
      
//
//        var stickerInfo = StickerInfo()
         baseModel.modelType =  .Sticker
//        stickerInfo.setBaseModel(baseModel: model)
//        stickerInfo.setStickerModel(stickerModel: <#T##DBStickerModel#>)
        super.addDefaultModel(parentModel: parentModel, baseModel: baseModel)
        
        
    }
}


