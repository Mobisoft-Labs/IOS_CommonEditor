//
//  VM+ParentObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

extension ViewManager {
    
    public func observeAsCurrentParent(_ parentModel: ParentInfo) {
        
        parentModel.$editState.dropFirst().sink{[weak self] value in
            guard let self = self else { return }
            
            guard let templateHandler = self.templateHandler else {
                logger.printLog("template handler nil")
                return }
            
            templateHandler.currentSuperModel = value ? templateHandler.currentParentModel : templateHandler.getParentModel(for: parentModel.modelId)
            logger.logVerbose("Edit State Call With Value \(value)")
            currentActiveView?.vIS_EDIT = value
            value ?
            self.expandParent(parentID: parentModel.modelId)
            :
            self.collapseParent(parentId: parentModel.modelId)
          
        }.store(in: &modelPropertiesCancellables)
    }
}
