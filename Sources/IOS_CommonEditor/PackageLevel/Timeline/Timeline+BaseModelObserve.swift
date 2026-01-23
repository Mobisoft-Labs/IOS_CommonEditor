//
//  Timeline+BaseModelObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

import Foundation
extension TimelineView {
    
    public func observeAsCurrentBaseModel(_ baseModel: BaseModel) {
        
       
        if let parentModel = tlManager.templateHandler?.currentModel as? ParentModel {
            parentModel.$editState.dropFirst().sink { [weak self] edited in
                guard let self = self else { return }

                if edited {
                    if self.scroller.rulingParent.model?.modelId != self.tlManager.templateHandler?.currentModel?.modelId{
                        self.changeModel(rulineModel: parentModel)
//                        tlManager.templateHandler?.setCurrentModel(id: parentModel.modelId)
                    }
                }else {
                    if let currentModel = self.tlManager.templateHandler?.currentModel{
                        if currentModel.modelId == self.scroller.rulingParent.model?.modelId{
                            let model = self.tlManager.templateHandler?.getModel(modelId: currentModel.parentId)
                            self.changeModel(rulineModel: model as! ParentModel)
                        }
                    }
 
                }
                //                }
            }.store(in: &modelPropertiesCancellables)
        }
        
      
        
        
        tlManager.templateHandler?.currentModel?.$isActive.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
           
            if value == true{
//                if self.tlManager.templateHandler?.currentActionState.isComponentTapped == true{
                    if let currentModel = self.tlManager.templateHandler?.currentModel{
                        if let index = self.scroller.collectionView.rulingModel?.activeChildren.firstIndex(where: { $0.modelId == currentModel.modelId }) {
                            let parent = tlManager.templateHandler?.getParentModel(for: currentModel.parentId)
                            let parentChildCount = parent?.activeChildren.count ?? 0
                            logger?.logError("GroupUndoCrash \(index) : \(self.scroller.collectionView.rulingModel!.activeChildren.count): \(parentChildCount) ")
                            let activeCount = self.scroller.collectionView.rulingModel?.activeChildren.count ?? 0
                            let itemCount = self.scroller.collectionView.numberOfItems(inSection: 0)
                            let rulingModelId = self.scroller.collectionView.rulingModel?.modelId ?? -1
                            logger?.logErrorFirebase("[TimelineTrace][isActive] currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId) index=\(index) activeCount=\(activeCount) itemCount=\(itemCount) parentChildCount=\(parentChildCount) isMainThread=\(Thread.isMainThread)", record: false)
                            if currentModel.modelId == -1 || rulingModelId == -1 {
                                logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId)")
                            }
                            if index >= 0 && index < itemCount,((self.scroller.collectionView.rulingModel!.activeChildren.count - 1) != 0) {
                                self.scroller.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
                            } else {
                                let rulingModelId = self.scroller.collectionView.rulingModel?.modelId ?? -1
                                logger?.logErrorFirebase("[TimelineTrace][isActive][skip] currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId) index=\(index) itemCount=\(itemCount) activeCount=\(activeCount) parentChildCount=\(parentChildCount) isMainThread=\(Thread.isMainThread)", record: false)
                                if currentModel.modelId == -1 || rulingModelId == -1 {
                                    logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModel.modelId) rulingModelId=\(rulingModelId)")
                                }
                            }
                        }
                    }

            }
            
            
            
        }.store(in: &modelPropertiesCancellables)
        
        
    }
}
