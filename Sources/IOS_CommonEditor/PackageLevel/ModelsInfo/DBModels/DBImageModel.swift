//
//  Image.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 18/07/23.
//

import Foundation
import UIKit

public enum SOURCETYPE:String{
    case BUNDLE = "BUNDLE"
    case SERVER = "SERVER"
    case DOCUMENT = "DOCUMENT"
    
}

public enum ImageCropperType: Int{
    case custom = 0
    case ratios = 1
    case circle = 2
}

public struct ReplaceModel :  Equatable{
    public static func == (lhs: ReplaceModel, rhs: ReplaceModel) -> Bool {
        if lhs.modelID != rhs.modelID {
            return true
        }
        if lhs.imageModel != rhs.imageModel {
            return true
        }
        
      
        return false
        
    }
    
    let modelID : Int
    public var imageModel : ImageModel
    var baseFrame : Frame
    
    public init(modelID: Int, imageModel: ImageModel, baseFrame: Frame) {
        self.modelID = modelID
        self.imageModel = imageModel
        self.baseFrame = baseFrame
    }
}
public struct DBImageModel:DBImageProtocol{
    public var imageID: Int = 0
    public var imageType: String = ""
    public var serverPath: String = ""
    public var localPath: String = ""
    public var resID: String = ""
    public var isEncrypted: Int = 0
    public var cropX: Double = 0.0
    public var cropY: Double = 0.0
    public var cropW: Double = 1.0
    public var cropH: Double = 1.0
    public var cropStyle: Int = 1
    public var tileMultiple: Double = 1.0
    public var colorInfo: String = ""
    public var imageWidth: Double = 300
    public var imageHeight: Double = 300
    public var templateID : Int = -1
    public var sourceTYPE : String = "BUNDLE"
    
    static func createDefaultOverlayModel(imageModel:ImageModel, templateID: Int)->DBImageModel{
        var model = DBImageModel()
        model.imageType = "OVERLAY"
        model.serverPath = imageModel.serverPath
        model.localPath = imageModel.localPath
        model.cropX = imageModel.cropRect.minX
        model.cropY = imageModel.cropRect.minY
        model.cropW = imageModel.cropRect.width
        model.cropH = imageModel.cropRect.height
        model.tileMultiple = imageModel.tileMultiple
        model.sourceTYPE = imageModel.sourceType.rawValue
        model.templateID = templateID
        return model
    }
    
    public init(imageID: Int = 0, imageType: String = "", serverPath: String = "", localPath: String = "", resID: String = "", isEncrypted: Int = 0, cropX: Double = 0.0, cropY: Double = 0.0, cropW: Double = 1.0, cropH: Double = 1.0, cropStyle: Int = 1, tileMultiple: Double = 1.0, colorInfo: String = "", imageWidth: Double = 300, imageHeight: Double = 300, templateID: Int = -1, sourceTYPE: String = "BUNDLE") {
        self.imageID = imageID
        self.imageType = imageType
        self.serverPath = serverPath
        self.localPath = localPath
        self.resID = resID
        self.isEncrypted = isEncrypted
        self.cropX = cropX
        self.cropY = cropY
        self.cropW = cropW
        self.cropH = cropH
        self.cropStyle = cropStyle
        self.tileMultiple = tileMultiple
        self.colorInfo = colorInfo
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.templateID = templateID
        self.sourceTYPE = sourceTYPE
    }
    
}
public struct ImageModel: Equatable{
    public var imageType : ImageSourceType
    public var serverPath: String
    public var localPath : String
    public var cropRect : CGRect
//    var cropStyle : Double
    public var sourceType : SOURCETYPE
    public var tileMultiple : Double
    public var cropType: ImageCropperType
    public var imageWidth : Double
    public var imageHeight : Double
    
    public init(imageType: ImageSourceType, serverPath: String, localPath: String, cropRect: CGRect, sourceType: SOURCETYPE, tileMultiple: Double, cropType: ImageCropperType, imageWidth: Double, imageHeight: Double) {
        self.imageType = imageType
        self.serverPath = serverPath
        self.localPath = localPath
        self.cropRect = cropRect
        self.sourceType = sourceType
        self.tileMultiple = tileMultiple
        self.cropType = cropType
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
    
    public func getImage(engineConfig: EngineConfiguration) async->UIImage?{
        if sourceType == .BUNDLE{
            let imageName = localPath.components(separatedBy: "/").last!
         
                if let savedImage = UIImage(named: imageName) {
                    return savedImage
                }
                else{
                    print("Error loading image from documents directory")
                    return nil
                }
            
        }else if sourceType == .DOCUMENT{
            
            let imageName = localPath.components(separatedBy: "/").last!
            do{
                if let pngData = engineConfig.readDataFromFileFromAssets(fileName: imageName){
                    return UIImage(data: pngData)
                }else if let pngDataLocal = engineConfig.readDataFromFileLocalAssets(fileName: imageName){
                    return UIImage(data: pngDataLocal)
                }
            }catch{
                print("Error loading image from documents directory")
                return nil
            }
            
      
        }else{
            let imageName = serverPath.components(separatedBy: "Assets/").last!
            do{
                if let savedImage = try engineConfig.loadImageFromDocumentsDirectory(filename: imageName, directory: engineConfig.getAssetsPath()!) {
                return savedImage
            }
            
            else {
                do{
                  
                    if let serverImage = try await engineConfig.fetchImage(imageURL: imageName){
                        let resizedImage = resizeImage(image: serverImage, targetSize: CGSize(width: 3000, height: 3000))
                        if let imageData = serverImage.pngData() {
                            try engineConfig.saveImageToDocumentsDirectory(imageData: imageData, filename: imageName, directory: engineConfig.getAssetsPath()!)
                        }
                        return resizedImage
                    }
                }
                catch{
                    print("image is not downloaded for server Path")
                }
            }
        }
            catch{
                print("image not found on server")
            }
        
        
        }
        return nil
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
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
}
