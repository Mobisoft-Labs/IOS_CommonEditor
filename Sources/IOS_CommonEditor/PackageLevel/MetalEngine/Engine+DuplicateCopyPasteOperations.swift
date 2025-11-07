//
//  Engine+StickerOperations.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//


/// Functionality for Duplicate Parent, page  or child
///
import Foundation

extension MetalEngine {
    
    
    // Method to duplicate a parent model and adjust the order of subsequent children
    func duplicateParent(parentInfo: BaseModel,isDuplicate:Bool = true, isAdded:Bool) {
        
        var parentOrder = parentInfo.orderInParent
        
        if !isDuplicate{
            parentOrder = getTheOrderForTheDuplicatdChild()
        }
        else{
            parentOrder = parentInfo.orderInParent
        }
        
        var startTime = parentInfo.startTime
        var duration = parentInfo.duration
        
        // Insert the duplicated parent info into the database
        var parentId = isDuplicate ? parentInfo.parentId : templateHandler.currentSuperModel?.modelId
        if parentId == parentInfo.modelId && isDuplicate == false{
            parentId = templateHandler.currentSuperModel?.parentId
        }
        if !isDuplicate{
            let parentStartTime = templateHandler.getNewStartTimeForNewComponent(childStartTime: templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0, newParentID: templateHandler.currentSuperModel!.parentId)
            let parentDuration = templateHandler.currentSuperModel?.baseTimeline.duration
            let childDuration = parentInfo.baseTimeline.duration
            let diffOfParentDurAndCurTime = templateHandler.playerControls?.currentTime ?? 0.0 - parentStartTime
            if childDuration > parentDuration! - diffOfParentDurAndCurTime{
                let diff = parentDuration! - diffOfParentDurAndCurTime
                if diff > 3{
                    startTime = parentDuration! - diff
                    duration = diff
                }
                else{
                    startTime = parentDuration! - 3.0
                    duration = 3.0
                }
            }
            else{
                if templateHandler.currentSuperModel?.modelType == .Page{
                    startTime = templateHandler.playerControls?.currentTime ?? 0.0  - (templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0)
                }else{
                    var newTime =  templateHandler.getNewStartTimeForNewComponent(childStartTime: templateHandler.playerControls?.currentTime ?? 0.0, newParentID: templateHandler.currentSuperModel!.modelId)
                    startTime = newTime - (templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0)
                }
            }
        }
        
        if !isDuplicate{
            if let parent = DBManager.shared.duplicateSingleParent(modelID:  parentInfo.modelId, parentId: parentId!, order: parentOrder, startTime: Double(startTime), duration: Double(duration)){
                let parentModel = templateHandler.getModel(modelId: parentId!) as? ParentModel
//                if parentModel?.modelType == .Parent{
                    if let parentInfo  = DBMediator.shared.createParentInfo(pageInfo: parent, refSize: (parentModel?.baseFrame.size)!){
                        //                    changeDurationAndStartTime(model: parentInfo, newStartTime: startTime, newDuration: duration, oldDuration: parentInfo.duration)
                        // Add the Parent Info into the Child Dictionary. NK**
                        templateHandler.childDict[parentInfo.modelId] = parentInfo
                        addParentToChildDictRecursively(parentInfo: parentInfo)
                        // parent info is enter in engine
                        let order = parentModel?.children.count
                        parentModel?.children.append(parentInfo)
                        parentModel?.increaseOrderFromIndex(order! + 1)
                        viewManager?.addChild(info: parentInfo, toParenID: parentInfo.parentId)

                        Task{
                            await sceneManager.addParent(parentInfo: parentInfo)
                            DispatchQueue.main.async { [ weak self] in
                                guard let self = self else { return }
                                let thumbImage = templateHandler.currentModel?.thumbImage
                                parentInfo.softDelete = true
                                templateHandler.deepSetCurrentModel(id: parentInfo.modelId)
                                templateHandler?.currentModel?.softDelete = false
                                if isAdded{
                                    Task { [weak self] in
                                        guard let self = self else { return }
                                        
                                        await self.thumbManagar?.updateParentThumb(parentModel: parentInfo,completion: { _success in
                                            DispatchQueue.main.async { [weak self] in
                                                guard let self = self else { return }
                                                templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                            }
                                        })
                                    }
                                }
                                else{
                                    parentInfo.thumbImage = thumbImage
                                    templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                    Task{
                                        await self.updateParentsChildThumbRecursively(parentInfo: parentInfo)
                                        DispatchQueue.main.async{
                                            self.templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                        }
                                    }
                            
                                }
                                
                                
                            }
                        }
                    }
            }
        }
        else{
            // Calculate the new order for the duplicated parent
            if let parent = DBManager.shared.duplicateSingleParent(modelID: parentInfo.modelId){
                if let page = templateHandler.currentPageModel{
                    if let parentInfo  = DBMediator.shared.createParentInfo(pageInfo: parent, refSize: page.baseFrame.size){
                        
                        // Add the Parent Info into the Child Dictionary. NK**
                        templateHandler.childDict[parentInfo.modelId] = parentInfo
                        addParentToChildDictRecursively(parentInfo: parentInfo)
                        page.children.append(parentInfo)
                        page.increaseOrderFromIndex(parentInfo.orderInParent+1)
                        Task{
                            
                            DispatchQueue.main.async { [self] in
                                viewManager?.addChild(info: parentInfo, toParenID: parentInfo.parentId)
                            }
                            
                            await sceneManager.addParent(parentInfo: parentInfo)
                            DispatchQueue.main.async { [ self] in
                                let thumbImage = templateHandler.currentModel?.thumbImage
                                parentInfo.softDelete = true
                                templateHandler.deepSetCurrentModel(id: parentInfo.modelId)
                                templateHandler?.currentModel?.softDelete = false
                                parentInfo.thumbImage = thumbImage
                                templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                Task {
                                    await updateParentsChildThumbRecursively(parentInfo: parentInfo)
                                    templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func addParentToChildDictRecursively(parentInfo: ParentModel){
        var children = parentInfo.children
        logger.printLog("children in parent: \(children)")
        
        for child in children{
            if child.modelType == .Parent{
                templateHandler.childDict[child.modelId] = child
                addParentToChildDictRecursively(parentInfo: child as! ParentModel)
            }else{
                templateHandler.childDict[child.modelId] = child
            }
        }
    }
    
        func updateParentsChildThumbRecursively(parentInfo: ParentModel) async{
        var children = parentInfo.children
        for child in children{
           
            await thumbManagar?.updateThumbnail(id: child.modelId)
            }
        
    }


    // Method to duplicate a sticker model and adjust the order of subsequent stickers
    func duplicateSticker(stickerInfo: StickerInfo,isDuplicate:Bool = true, isAdded:Bool) {
        var stickerInfo_ = stickerInfo.getCopy()
        /*
         Requirement (Copy/Paste):
         - Insert the sticker in the last of parent if selected otherwise in page.
         - Provide the orderInParent to the duplicated child based on the last index + 1.
         
         Requirement (Duplicate):
         - Insert the child on next order of the duplicated child.
         - Insert it into the duplicated sticker parent.
         */
        
        
        // Calculate the new order for the duplicated sticker
        var newOrder = 0
        if isDuplicate{
            newOrder = stickerInfo_.orderInParent + 1
            
        }else{
            newOrder = getTheOrderForTheDuplicatdChild()
        }
        
        
        // Update the order of the original sticker model
//        stickerInfo.orderInParent = newOrder
        
        // Increase the order of the remaining children from the new order index
        templateHandler?.currentSuperModel?.increaseOrderFromIndex(newOrder)
        
        
        // Check if the current parent model's base frame size is available
        if let refSize = templateHandler.currentSuperModel?.baseFrame.size {
            
            // Insert the duplicated sticker info into the database
            let parentId = isDuplicate ? stickerInfo_.parentId : templateHandler.currentSuperModel?.modelId
            
            // Paste Work Here
            if !isDuplicate{
                let parentStartTime = templateHandler.getNewStartTimeForNewComponent(childStartTime: templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0, newParentID: templateHandler.currentSuperModel!.parentId)
//                let parentStartTime = templateHandler.currentParentModel?.baseTimeline.startTime
                let parentDuration = templateHandler.currentSuperModel?.baseTimeline.duration
                let childDuration = stickerInfo_.baseTimeline.duration
                let diffOfParentDurAndCurTime = templateHandler.playerControls?.currentTime ?? 0.0 - parentStartTime
                if childDuration > parentDuration! - diffOfParentDurAndCurTime{
                    let diff = parentDuration! - diffOfParentDurAndCurTime
                    if diff > 3{
                        stickerInfo_.baseTimeline.startTime = parentDuration! - diff
                        stickerInfo_.baseTimeline.duration = diff
                    }
                    else{
                        stickerInfo_.baseTimeline.startTime = parentDuration! - 3.0
                        stickerInfo_.baseTimeline.duration = 3.0
                    }
                }
                else{
                    if templateHandler.currentSuperModel?.modelType == .Page{
                        stickerInfo_.baseTimeline.startTime = templateHandler.playerControls?.currentTime ?? 0.0 - (templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0)
                    }else{
                        var newTime =  templateHandler.getNewStartTimeForNewComponent(childStartTime: templateHandler.playerControls?.currentTime ?? 0.0, newParentID: templateHandler.currentSuperModel!.modelId)
                        stickerInfo_.baseTimeline.startTime = newTime - (templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0)
                    }
                }
                let parentModel = templateHandler.getModel(modelId: stickerInfo_.parentId )
                if let size = parentModel?.baseFrame.size{
                    stickerInfo_.baseFrame.center = CGPoint(x: (size.width)/2, y: (size.height)/2)
                }
            }
            else{
                stickerInfo_.baseFrame.center.x += 4
                stickerInfo_.baseFrame.center.y += 4
            }
            
            // Insert the duplicated sticker info into the database
            let stickerID = DBMediator.shared.insertStickerInfo(stickerInfoModel: stickerInfo_, parentID: parentId!, templateID: stickerInfo_.templateID, refSize: refSize, newOrder: newOrder)
//            Task{
            addNewStickerInfo(StickerInfoId: stickerID, refSize: refSize, isDuplicate: isDuplicate, isAdded: isAdded)
//            }
        }
    }
    
    
   

    // Method to duplicate a text model
    func duplicateText(textInfo: TextInfo,isDuplicate:Bool = true, isAdded : Bool) {
        // Calculate the new order for the duplicated sticker
        var textInfo_ = textInfo.getCopy()
        
        /*
         Requirement (Copy/Paste):
         - Insert the text in the last of parent if selected otherwise in page.
         - Provide the orderInParent to the duplicated child based on the last index + 1.
         
         Requirement (Duplicate):
         - Insert the child on next order of the duplicated child.
         - Insert it into the duplicated text parent.
         */
        
        var newOrder = 0
        if isDuplicate{
             newOrder = textInfo_.orderInParent + 1
            
        }else{
            newOrder = getTheOrderForTheDuplicatdChild()
        }
        
        // Check if the current parent model's base frame size is available
        if let refSize = templateHandler.currentSuperModel?.baseFrame.size {
            // Insert the duplicated text info into the database
            let parentId = isDuplicate ? textInfo_.parentId : templateHandler.currentSuperModel?.modelId
            // if duplicate same parent id as currentText if paste then currentSuperModel id
           
            if !isDuplicate{
                logger.logError("Start Time Issue ")
                let parentStartTime = templateHandler.getNewStartTimeForNewComponent(childStartTime: templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0, newParentID: templateHandler.currentSuperModel!.parentId)
//                let parentStartTime = templateHandler.currentParentModel?.baseTimeline.startTime
                let parentDuration = templateHandler.currentSuperModel?.baseTimeline.duration
                let childDuration = textInfo_.baseTimeline.duration
                let diffOfParentDurAndCurTime = templateHandler.playerControls?.currentTime ?? 0.0 - parentStartTime
                if childDuration > parentDuration! - diffOfParentDurAndCurTime{
                    let diff = parentDuration! - diffOfParentDurAndCurTime
                    if diff > 3{
                        textInfo_.baseTimeline.startTime = parentDuration! - diff
                        textInfo_.baseTimeline.duration = diff
                    }
                    else{
                        textInfo_.baseTimeline.startTime = parentDuration! - 3.0
                        textInfo_.baseTimeline.duration = 3.0
                    }
                }
                else{
                    if templateHandler.currentSuperModel?.modelType == .Page{
                        textInfo_.baseTimeline.startTime = templateHandler.playerControls?.currentTime ?? 0.0 - (templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0)
                    }else{
                        var newTime =  templateHandler.getNewStartTimeForNewComponent(childStartTime: templateHandler.playerControls?.currentTime ?? 0.0, newParentID: templateHandler.currentSuperModel!.modelId)
                        textInfo_.baseTimeline.startTime = newTime - (templateHandler.currentSuperModel?.baseTimeline.startTime ?? 0)
                    }
//                    textInfo.baseTimeline.startTime = templateHandler.playerControls.currentTime
                }
                let parentModel = templateHandler.getModel(modelId: textInfo_.parentId )
                if let size = parentModel?.baseFrame.size{
                    textInfo_.baseFrame.center = CGPoint(x: (size.width)/2, y: (size.height)/2)
                }
            }else {
               
                textInfo_.baseFrame.center.x += 4
                textInfo_.baseFrame.center.y += 4
                
            }
            let textID = DBMediator.shared.insertTextInfo(textInfoModel: textInfo_, parentID: parentId!, templateID: textInfo_.templateID, refSize: refSize, newOrder: newOrder)
            Task{
                await addNewTextInfo(textInfoId: textID, refSize: refSize, isDuplicate: isDuplicate, isAdded: isAdded)
            }
        }
    }

 

    // Method to duplicate a page and add it to the engine
    func duplicatePage(pageInfo: PageInfo) {
        // Duplicate the page in the database and get the new page ID
        let duplicatePageID = DBManager.shared.duplicatePage(
            page: pageInfo.getBaseModel(refSize: templateHandler.currentTemplateInfo!.ratioSize),
            newtempID: templateHandler.currentTemplateInfo?.templateId ?? 0,
            currentTime: templateHandler.currentTemplateInfo?.totalDuration ?? 0,
            order: pageInfo.orderInParent + 1
        )
        templateHandler.currentTemplateInfo?.thumbTime += pageInfo.duration
        
        
        // Add the duplicated page to the engine
        addPageinEngine(for: duplicatePageID, templateInfo: templateHandler.currentTemplateInfo!)
    }
}
