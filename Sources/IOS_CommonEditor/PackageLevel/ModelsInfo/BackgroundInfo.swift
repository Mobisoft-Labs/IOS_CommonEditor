////
////  BackgroundInfo.swift
////  VideoInvitation
////
////  Created by HKBeast on 31/08/23.
////
//
//import Foundation
//import UIKit
//
//class BackgroundInfo:BaseModelProtocol,StickerModelProtocol,ImageProtocol {
//    var templateID: Int = -1
//    
//   
//    
//    //base model
//    var parentId: Int = 0
//    var modelId: Int = 0
//    var modelType: ContentType = .Sticker
//    var dataId: Int = 0
//    var posX: Float = 0.0
//    var posY: Float = 0.0
//    var width: Float = 0.0
//    var height: Float = 0.0
//    var prevAvailableWidth: Float = 0.0
//    var prevAvailableHeight: Float = 0.0
//    var rotation: Float = 0
//    var modelOpacity: Float = 100
//    var modelFlipHorizontal: Bool = false
//    var modelFlipVertical: Bool = false
//    var lockStatus: Bool = false
//    var orderInParent: Int = 0
//    var bgBlurProgress: Int = 0
//    var overlayDataId: Int = 0
//    var overlayOpacity: Int = 100
//    var startTime: Float = 0.0
//    var duration: Float = 0.0
//    var softDelete: Bool = false
//    var isHidden: Bool = false
//    
//    //sticker model
//    var stickerId: Int = 1
//    var imageId: Int = 1
//    var stickerType: String = "PAGE"
//    var stickerFilterType: Int = 0
//    var stickerHue: Int = 0
//    var stickerColor: UIColor = .clear
//    var xRotationProg: Int = 1
//    var yRotationProg: Int = 1
//    var zRotationProg: Int = 1
//    
//    //image model
//    var imageID: Int = 0
//    var imageType: ImageSourceType = .Color
//    var serverPath: String = ""
//    var localPath: String = ""
//    var resID: String = ""
//    var isEncrypted: Bool = false
//    var cropX: Float = 0.0
//    var cropY: Float = 0.0
//    var cropW: Float = 0.0
//    var cropH: Float = 0.0
//    var cropStyle: Int = 0
//    var tileMultiple: Float = 1.0
//    var colorInfo: String = ""
//    var imageWidth: Int = 0
//    var imageHeight: Int = 0
//
//    //overlay model
//
//    var overlayID: Int = 0
//    
//    var overlayType: ImageSourceType = .Overlay
//    
//    var overlayServerPath: String = " "
//    
//    var overlayLocalPath: String = " "
//    
//    var overlayResID: String = " "
//    
//    var overlayIsEncrypted: Bool = false
//    
//    var overlayCropX: Float = 0.0
//    
//    var overlayCropY: Float = 0.0
//    
//    var overlayCropW: Float = 0.0
//    
//    var overlayCropH: Float = 0.0
//    
//    var overlayCropStyle: Int = 0
//    
//    var overlayTileMultiple: Float = 0.0
//    
//    var overlayColorInfo: String = " "
//    
//    var overlayWidth: Int = 0
//    
//    var overlayHeight: Int = 0
//    
//    
//    func setBaseModel(baseModel:DBBaseModel,refSize: CGSize){
//      
//        modelId = baseModel.modelId
//        parentId = baseModel.parentId
//        modelType = ContentType(rawValue: baseModel.modelType) ?? .Text
//        dataId = baseModel.dataId
//        posX = (baseModel.posX).toFloat() * Float(refSize.width)
//        posY = (baseModel.posY).toFloat() * Float(refSize.height)
//        width = (baseModel.width).toFloat() * Float(refSize.width)
//        height = (baseModel.height).toFloat() * Float(refSize.height)
//        prevAvailableWidth = (baseModel.prevAvailableWidth).toFloat()
//        prevAvailableHeight = (baseModel.prevAvailableHeight).toFloat()
//        rotation = (baseModel.rotation).toFloat()
//        modelOpacity = (baseModel.modelOpacity).toFloat()
//        modelFlipHorizontal = baseModel.modelFlipHorizontal.toBool()
//        modelFlipVertical = baseModel.modelFlipVertical.toBool()
//        lockStatus = baseModel.lockStatus.toBool()
//        orderInParent = baseModel.orderInParent
//        bgBlurProgress = baseModel.bgBlurProgress
//        overlayDataId = baseModel.overlayDataId
//        overlayOpacity = baseModel.overlayOpacity
//        startTime = (baseModel.startTime).toFloat()
//        duration = (baseModel.duration).toFloat()
//        softDelete = baseModel.softDelete.toBool()
//        isHidden = baseModel.isHidden
//    }
//    
//    
//    func setStickerModel(stickerModel:DBStickerModel){
//        stickerId = stickerModel.stickerId
//        imageId = stickerModel.imageId
//        stickerType = stickerModel.stickerType
//        stickerFilterType = stickerModel.stickerFilterType
//        stickerHue = stickerModel.stickerHue
//        stickerColor = stickerModel.stickerColor.colorFromUIntString()
//        xRotationProg = stickerModel.xRotationProg
//        yRotationProg = stickerModel.yRotationProg
//        zRotationProg = stickerModel.zRotationProg
//        
//    }
//    
//    func setImageModel(image: DBImageModel) {
//        self.imageID = image.imageID
//        self.imageType = ImageSourceType(rawValue: image.imageType) ?? .Color
//        self.serverPath = image.serverPath
//        self.localPath = image.localPath
//        self.resID = image.resID
//        self.isEncrypted = image.isEncrypted.toBool()
//        self.cropX = (image.cropX).toFloat()
//        self.cropY = (image.cropY).toFloat()
//        self.cropW = (image.cropW).toFloat()
//        self.cropH = (image.cropH).toFloat()
//        self.cropStyle = image.cropStyle
//        self.tileMultiple = (image.tileMultiple).toFloat()
//        self.colorInfo = image.colorInfo
//        self.imageWidth = image.imageWidth
//        self.imageHeight = image.imageHeight
//    }
//    
//    func setOverlayModel(image: DBImageModel) {
//        self.overlayID = image.imageID
//        self.overlayType = ImageSourceType(rawValue: image.imageType) ?? .Color
//        self.overlayServerPath = image.serverPath
//        self.overlayLocalPath = image.localPath
//        self.overlayResID = image.resID
//        self.overlayIsEncrypted = image.isEncrypted.toBool()
//        self.overlayCropX = (image.cropX).toFloat()
//        self.overlayCropY = (image.cropY).toFloat()
//        self.overlayCropW = (image.cropW).toFloat()
//        self.overlayCropH = (image.cropH).toFloat()
//        self.overlayCropStyle = image.cropStyle
//        self.overlayTileMultiple = (image.tileMultiple).toFloat()
//        self.overlayColorInfo = image.colorInfo//colorFromRGB(Int(image.colorInfo)!)
//        self.overlayWidth = image.imageWidth
//        self.overlayHeight = image.imageHeight
//    }
//     func getBaseModel() -> DBBaseModel {
//        return DBBaseModel(
//            parentId: parentId,
//            modelId: modelId,
//            modelType: modelType.rawValue,
//            dataId: dataId,
//            posX: (posX).toDouble(),
//            posY: (posY).toDouble(),
//            width: (width).toDouble(),
//            height: (height).toDouble(),
//            prevAvailableWidth: (prevAvailableWidth).toDouble(),
//            prevAvailableHeight: (prevAvailableHeight).toDouble(),
//            rotation: (rotation).toDouble(),
//            modelOpacity: (modelOpacity).toDouble(),
//            modelFlipHorizontal: modelFlipHorizontal.toInt(),
//            modelFlipVertical: modelFlipVertical.toInt(),
//            lockStatus: lockStatus.toString(),
//            orderInParent: orderInParent,
//            bgBlurProgress: bgBlurProgress,
//            overlayDataId: overlayDataId,
//            overlayOpacity: overlayOpacity,
//            startTime: (startTime).toDouble(),
//            duration: (duration).toDouble(),
//            softDelete: softDelete.toInt(),
//            isHidden: isHidden
//        )
//    }
//    
//    func getStickerModel() -> DBStickerModel {
//       return DBStickerModel(
//           stickerId: stickerId,
//           imageId: imageId,
//           stickerType: stickerType,
//           stickerFilterType: stickerFilterType,
//           stickerHue: stickerHue,
//           stickerColor: stickerColor.hexString,
//           xRotationProg: xRotationProg,
//           yRotationProg: yRotationProg,
//           zRotationProg: zRotationProg
//       )
//   }
//    
//    func getOverlayModel() -> DBImageModel {
//          var imageModel = DBImageModel()
//          imageModel.imageID = self.overlayID
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
//
//          return imageModel
//      }
//    
//    
//
//     func getImageModel() -> DBImageModel {
//           var imageModel = DBImageModel()
//           imageModel.imageID = self.imageID
//         imageModel.imageType = self.imageType.rawValue
//           imageModel.serverPath = self.serverPath
//           imageModel.localPath = self.localPath
//           imageModel.resID = self.resID
//         imageModel.isEncrypted = self.isEncrypted.toInt()
//         imageModel.cropX = (self.cropX).toDouble()
//         imageModel.cropY = (self.cropY).toDouble()
//         imageModel.cropW = (self.cropW).toDouble()
//         imageModel.cropH = (self.cropH).toDouble()
//           imageModel.cropStyle = self.cropStyle
//         imageModel.tileMultiple = (self.tileMultiple).toDouble()
//           imageModel.colorInfo = self.colorInfo
//           imageModel.imageWidth = self.imageWidth
//           imageModel.imageHeight = self.imageHeight
//
//           return imageModel
//       }
//}
//
