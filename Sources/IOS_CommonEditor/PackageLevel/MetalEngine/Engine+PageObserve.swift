//
//  Engine+PageObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//
import Foundation

extension MetalEngine {
  public func observeAsCurrentPage(_ pageModel: PageInfo) {

//        cancellables.removeAll()
       if let pageModel = templateHandler.currentPageModel{
           // Manage ActionState
           pageModel.$endBlur.dropFirst().sink { [weak self] Blur in
               guard let self = self else { return }
               if !(isDBDisabled){
                   _ = DBManager.shared.updateBgBlurProgress(modelId: pageModel.modelId, newValue: Int(Blur * 255))
               }
           }.store(in: &modelPropertiesCancellables)
           
           pageModel.$endOverlayOpacity.dropFirst().sink { [weak self] newOpacity in
               guard let self = self else { return }
               if !(isDBDisabled){
                   _ = DBManager.shared.updateOverlayOpacity(modelId: pageModel.modelId, newValue: Int(newOpacity * 255))
               }
           }.store(in: &modelPropertiesCancellables)
           
           pageModel.$endTileMultiple.dropFirst().sink { [weak self] tileMultiple in
               guard let self = self else { return }
               if !(isDBDisabled){
                   _ = DBManager.shared.updateImageTileMultiple(modelId: pageModel.dataId, newValue: Double(tileMultiple))
               }
           }.store(in: &modelPropertiesCancellables)
           
           pageModel.$bgOverlayContent.dropFirst().sink { [weak self] bgContent in
               guard let self = self else { return }
               if let overlay = bgContent as? BGOverlay{
                   if pageModel.overlayID > 0{
                       // overlay exist
                       DBManager.shared.updateImageModel(from: overlay.content, imageID: pageModel.overlayID)
                   }else{
                       // entry for new overlay
                       let imageModel = DBImageModel.createDefaultOverlayModel(imageModel: overlay.content, templateID: pageModel.templateID)
                       do{
                           pageModel.setOverlayModel(image: imageModel)
                           
                           let id = try DBManager.shared.replaceImageRowIfNeeded(image: imageModel)
                           pageModel.overlayID = id
                           pageModel.overlayDataId = id
                           if !(isDBDisabled){
                               _ = DBManager.shared.updateOverlayDataId(modelId: pageModel.modelId, newValue: id)
                           }
                       }catch{
                           
                       }
                       
                   }
               }
               
           }.store(in: &modelPropertiesCancellables)
           pageModel.$lockUnlockState.dropFirst().sink { [weak self] lockUnlockArray in
               guard let self = self else { return }
               var lockAll = false
               
               for item in lockUnlockArray{
                   if let model = templateHandler.getModel(modelId: item.id){
                       lockAll = item.lockStatus
                       model.lockStatus = item.lockStatus
                       if !(isDBDisabled){
                           _ = DBManager.shared.updateLockStatus(modelId: item.id, newValue: item.lockStatus.toString())
                       }
                       if !lockAll{
                           pageModel.unlockedModel.append(LockUnlockModel(id: item.id, lockStatus: true))
                       }
                       
                   }else{
                       logger.printLog("model is not avilable for this item id")
                   }
                   
                 }
                   if lockAll{
                       pageModel.unlockedModel.removeAll()
                   }
                  
               
               
           }.store(in: &modelPropertiesCancellables)
           
//
//            pageModel.$endOverlayContent.dropFirst().sink { [unowned self] overlayContent in
//                if let overlay = overlayContent as? BGOverlay{
//                    pageModel.overlayType = .IMAGE
//                    pageModel.overlayLocalPath = overlay.content.localPath
//                    DBManager.shared.updateImageModel(from: overlay.content, imageID: pageModel.overlayDataId)
//                }
//            }.store(in: &cancellables)
           
           pageModel.$endBgContent.dropFirst().sink { [weak self] bgContent in
               guard let self = self else { return }
               // check bgcontent type
               // according to type db value is changed
       
               if let wallpaper = bgContent as? BGWallpaper{
                   print("wallpaper")
                   pageModel.imageType = .IMAGE
                   pageModel.localPath = wallpaper.content.localPath
                   DBManager.shared.updateImageModel(from: wallpaper.content, imageID: pageModel.dataId)
                   
                   
               }
               if let texture = bgContent as? BGTexture{
                   pageModel.imageType = .TEXTURE
                   if pageModel.tileMultiple == 0.0{
                       pageModel.tileMultiple = 1.0
                   }
                   pageModel.localPath = texture.content.localPath
                   DBManager.shared.updateImageModel(from: texture.content, imageID: pageModel.dataId)
                   
                   logger.printLog("texture")
               }
               if var userImage = bgContent as? BGUserImage{
                   pageModel.imageType = .STORAGEIMAGE
                   pageModel.localPath = userImage.content.localPath
                   DBManager.shared.updateImageModel(from: userImage.content, imageID: pageModel.dataId)
               }
               if let color = bgContent as? BGColor{
                   print("color")
                   pageModel.imageType = .COLOR
//                    pageModel.localPath = wallpaper.content.localPath
//                    pageModel.imageType = .IMAGE
                   _ =  DBManager.shared.updateImageColorInfo(modelId: pageModel.dataId, newValue: color.stringValue, type: pageModel.imageType.rawValue)
                   
                   
               }
               if let gradient = bgContent as? GradientInfo{
                   pageModel.imageType = .GRADIENT
//                    pageModel.localPath = wallpaper.content.localPath
                   _ =  DBManager.shared.updateImageColorInfo(modelId: pageModel.dataId, newValue: convertGradientToJSONString(gradient)!, type: pageModel.imageType.rawValue)
               }
               templateHandler.currentActionState.updatePageAndParentThumb = true 
//               analyticsLogger.logEditorInteraction(action: .addBackground)
               engineConfig.logAddBackground()
               
           }.store(in: &modelPropertiesCancellables)
       }
       
   }
}
