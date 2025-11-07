//
//  Engine+StickerObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension MetalEngine {
    public  func observeAsCurrentSticker(_ stickerModel: StickerInfo) {
        if let stickerModel = templateHandler.currentStickerModel,let currentParent = templateHandler.getParentFor(childId: stickerModel.modelId){
            
         
            stickerModel.$endStickerFilter.dropFirst().sink { [weak self] value in
                guard let self = self else { return }
                if let colorFilter = value as? ColorFilter{
                    stickerModel.stickerFilterType = 2
                    stickerModel.stickerColor = colorFilter.filter
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateStickerColorWithFilterType(modelId: stickerModel.stickerId, newColor: colorFilter.filter.toUIntString(), newFilterType:2)
                    }
                   
                }
                if let hueFilter = value as? HueFilter{
                    stickerModel.stickerFilterType = 1
                    stickerModel.stickerHue = hueFilter.filter
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateStickerHueNFilterType(modelId: stickerModel.stickerId, newHue: Int(hueFilter.filter), newFilterType: 1)
                    }
                }
                if let none = value as? NoneFilter{
                    stickerModel.stickerFilterType = 0
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateStickerFilterType(modelId: stickerModel.stickerId, newValue: 0)
                    }
                }
//                templateHandler.currentActionState.updateThumb = true
                
            }.store(in: &modelPropertiesCancellables)
            
        
            
            stickerModel.$changeOrReplaceImage.dropFirst().sink {[weak self] value in
                guard let self = self else { return }
                if let imageContent = value, let parent = templateHandler.getModel(modelId: stickerModel.parentId) as? ParentModel{
               
                    stickerModel.baseFrame = imageContent.baseFrame
                    
                    stickerModel.stickerImageContent = imageContent.imageModel
                    
                    
//                    stickerModel.changeOrReplaceImage = imageContent
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateImageModel(from: imageContent.imageModel, imageID: stickerModel.imageID)
                        _ = DBManager.shared.updateBaseFrame(modelId: stickerModel.modelId, newValue: imageContent.baseFrame, parentFrame: parent.baseFrame.size)
                    }
                }
            }.store(in: &modelPropertiesCancellables)
            
        }
    }
}
