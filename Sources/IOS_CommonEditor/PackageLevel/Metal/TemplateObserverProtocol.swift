//
//  TemplateObserverProtocol.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

import Combine

public protocol ActionStateObserversProtocol {
    var actionStateCancellables : Set<AnyCancellable> { get set }
    func observeCurrentActions()
}
public protocol TemplateObserversProtocol  {
    
    
    var modelPropertiesCancellables : Set<AnyCancellable> { get set }
    
    func observeAsCurrentSticker(_ stickerModel : StickerInfo)
    func observeAsCurrentText(_ textModel: TextInfo)
    func observeAsCurrentPage(_ pageModel: PageInfo)
    func observeAsCurrentParent(_ parentModel : ParentInfo)
    func observeAsCurrentBaseModel(_ baseModel: BaseModel)

}


extension TemplateObserversProtocol {
    
    mutating func observeModel(templateHandler:TemplateHandler , shouldObserve:Bool = true ) {
        modelPropertiesCancellables.removeAll()
        
        if !shouldObserve {
            return 
        }
        if let stickerModel = templateHandler.currentModel as? StickerInfo {
            self.observeAsCurrentSticker(stickerModel)
        }
        else
        if let textModel = templateHandler.currentModel as? TextInfo {
            self.observeAsCurrentText(textModel)
        }
        else
        if let pageModel = templateHandler.currentModel as? PageInfo {
            self.observeAsCurrentPage( pageModel)
        }
        else
        if let parentModel = templateHandler.currentModel as? ParentInfo {
            self.observeAsCurrentParent(parentModel)
        }
        if let baseModel = templateHandler.currentModel {
            observeAsCurrentBaseModel(baseModel)
        }
           
    }
}
