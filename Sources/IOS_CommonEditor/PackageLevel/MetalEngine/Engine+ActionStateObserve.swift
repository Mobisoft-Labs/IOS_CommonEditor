//
//  Engine+ActionStateObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//

import Foundation

extension MetalEngine {
    public func observeCurrentActions(){
        
       
        
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
        actionStateCancellables.removeAll()
        logger.logVerbose("Engine + CurrentActions listeners ON \(actionStateCancellables.count)")
        
        templateHandler.$setSelectedModelChanged.dropFirst().sink { [weak self] model in
            
            guard var self = self else { return }
            logger.logVerbose("Engine + modelChange to \(model?.modelType.rawValue)")
            
            

            observeModel(templateHandler: templateHandler)

        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$isMute.dropFirst().sink { [weak self] newValue in
            guard let self = self else { return }
            
            if newValue == true{
                audioPlayer?.muteAudio()
            }else{
                audioPlayer?.unMuteAudio()
            }
        }.store(in: &actionStateCancellables)
        
       
        
        templateHandler.currentActionState.$pasteModel.dropFirst().sink { [weak self] pasteModel in
            guard let self = self else { return }
            logger.printLog("pasteModel")
            
            // copied model -> paste process
            // print " nothing to copy "
            
            if let currentModel = templateHandler.getModel(modelId: templateHandler.currentActionState.copyModel){
                if currentModel.modelType == .Page{
                    
                }
                else if  currentModel.modelType == .Parent{
                    duplicateParent(parentInfo: currentModel, isDuplicate: false, isAdded: false)
                }
                else if currentModel.modelType == .Sticker{
                    
                    duplicateSticker(stickerInfo: currentModel as! StickerInfo,isDuplicate: false, isAdded: false)
                }
                else if currentModel.modelType == .Text{
                    duplicateText(textInfo: currentModel as! TextInfo,isDuplicate: false, isAdded: false)
                }
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$isCurrentModelDeleted.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            
            if value == true {
                templateHandler.deepSetCurrentModel(id: templateHandler.currentModel!.parentId , smartSelect: false)

            } else {
                 
                templateHandler.currentActionState.exportPageTapped = false
                
                var id = templateHandler.lastSelectedId ?? templateHandler.currentModel?.modelId ?? templateHandler.currentTemplateInfo?.pageInfo.first?.modelId ?? -1
                
                templateHandler.deepSetCurrentModel(id: id, smartSelect: true)
                logger.logError("This Means Export Dismissed")
            }

        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$duplicateModel.dropFirst().sink { [weak self] duplicateModel in
            guard let self = self else { return }
            logger.printLog("duplicateModel")
            if let currentModel = templateHandler.currentModel{
                if currentModel.modelId == duplicateModel{
                    if currentModel.modelType == .Page{
                        duplicatePage(pageInfo: currentModel as! PageInfo)
                    }
                    else if  currentModel.modelType == .Parent{
                        duplicateParent(parentInfo: currentModel as! ParentInfo, isAdded: false)
                    }
                    else if currentModel.modelType == .Sticker{
                        duplicateSticker(stickerInfo: currentModel as! StickerInfo, isAdded: false)
                    }
                    else if currentModel.modelType == .Text{
                        duplicateText(textInfo: currentModel as! TextInfo, isAdded: false)
                    }
                }
                else{
                    if let selectedModel = templateHandler.getModel(modelId: duplicateModel){
                        if selectedModel.modelType == .Page{
                            duplicatePage(pageInfo: selectedModel as! PageInfo)
                        }
                        else if  selectedModel.modelType == .Parent{
                            duplicateParent(parentInfo: selectedModel as! ParentInfo, isAdded: false)
                        }
                        else if selectedModel.modelType == .Sticker{
                            duplicateSticker(stickerInfo: selectedModel as! StickerInfo, isAdded: false)
                        }
                        else if selectedModel.modelType == .Text{
                            duplicateText(textInfo: selectedModel as! TextInfo, isAdded: false)
                        }
                    }
                }
         
            }
            
            
        }.store(in: &actionStateCancellables)
        
        
        templateHandler.currentActionState.$deletedPageID.dropFirst().sink { [weak self] deletedPageID in
            guard let self = self else { return }
            templateHandler.currentModel?.softDelete = true
            var pageInfoArray = templateHandler.currentTemplateInfo!.pageInfo
            
            if let index = pageInfoArray.firstIndex(where: { $0.modelId == deletedPageID }) {
                print("Found model at index \(index)")
                updateStartTimeOfTheModel(index: index)
                var pageInfoArr = templateHandler.currentTemplateInfo!.pageInfo
                let newIndex = updateModelDeletionStatus(models: pageInfoArr, currentIndex: index)
                let modelId = pageInfoArr[newIndex!].modelId
                templateHandler.currentTemplateInfo?.thumbTime -= templateHandler.currentPageModel?.duration ?? 0.0
                templateHandler.deepSetCurrentModel(id: modelId)
                
            } else {
                print("Model with ID \(deletedPageID) not found")
            }
            templateHandler.currentActionState.updatePageArray = true
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$selectedPageID.dropFirst().sink {  [weak self] selectedPageID in
            guard let self = self else { return }
            templateHandler.deepSetCurrentModel(id: selectedPageID)
            templateHandler.currentActionState.updatePageArray = true
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$updatePageArray.dropFirst().sink {[weak self] updatePageArray in
            guard let self = self else { return }
            templateHandler.currentActionState.pageModelArray = templateHandler.getPageModelFromPageInfo()
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$addNewText.dropFirst().sink { [weak self] addNewText in
            guard let self = self else { return }
            logger.printLog("addNewText")
            Task{
                await self.addNewText(text: addNewText, model: self.templateHandler.currentModel!, currentTime: Float(self.timeLoopHandler!.currentTime), isDuplicate: false)
//                self.analyticsLogger.logEditorInteraction(action: .addText)
                self.engineConfig.logAddText()
            }
        }.store(in: &actionStateCancellables)
        
        
        templateHandler.currentActionState.$addImage.dropFirst().sink {[weak self] addImage in
            guard let self = self else { return }
            logger.printLog("addImage")
            
            if let parentModel = templateHandler.currentModel as? ParentModel{
                if let addImageModel = addImage{
                    
                    
                    Task{
                        var time:Float = 0
                        var currentTD: Float = 0
                        if let currentIndex = templateHandler.currentActionState.pageModelArray.firstIndex(where: { $0.id == templateHandler.currentPageModel?.modelId }) {
                            for i in stride(from: currentIndex, through: 0, by: -1) {
                                print("current index \(i)")
                                let newModel = templateHandler.getModel(modelId: templateHandler.currentActionState.pageModelArray[i].id)
                                currentTD += newModel?.baseTimeline.duration ?? 0
                                print("current TD \(currentTD)")
                            }
                        }
                        if ((self.timeLoopHandler?.currentTime ?? 0) + self.minStartTime) >= currentTD{
                            time = currentTD - self.minStartTime
                        }else{
                            time = self.timeLoopHandler?.currentTime ?? 0
                        }
                            
//                        if (timeLoopHandler?.currentTime ?? 0) + minStartTime >= templateHandler.currentPageModel?.baseTimeline.duration ?? 0{
//                            time = (templateHandler.currentPageModel?.baseTimeline.duration ?? 0) - minStartTime
//                        }else{
//                            time = timeLoopHandler?.currentTime ?? 0
//                        }
                        let newTime: Float
                        if parentModel.modelType == .Parent{
                            newTime = templateHandler.getNewStartTimeForNewComponent(childStartTime: time, newParentID: parentModel.modelId)
                        }else{
                            newTime = time
                        }
                        var stickerInfo = StickerInfo.createDefaultStickerInfo(parentModel: parentModel, startTime: newTime, Order: parentModel.children.count)
                        stickerInfo.sourceType = addImageModel.sourceType
                        stickerInfo.imageType = addImageModel.imageType
                        stickerInfo.localPath = addImageModel.localPath
                        
                        var newSize:CGSize = .zero
                        if stickerInfo.prevAvailableWidth>stickerInfo.prevAvailableHeight{
                            newSize = CGSize(width: CGFloat(stickerInfo.prevAvailableWidth),height: CGFloat(stickerInfo.prevAvailableWidth))
                            
                        }else{
                            newSize = CGSize(width: CGFloat(stickerInfo.prevAvailableHeight),height: CGFloat(stickerInfo.prevAvailableHeight))
                        }
                        
                        if let image = await addImage?.getImage(engineConfig: self.engineConfig) {
                            let imageSize = image.mySize
                            
                            // Get proportionally sized image based on the target size
                            let tsize = getProportionalSize(currentSize: imageSize, newSize: newSize)
                            
                            // Calculate cropped dimensions based on the crop rectangle
                            let cropWidth = tsize.width * addImage!.cropRect.width
                            let cropHeight = tsize.height * addImage!.cropRect.height
                            
                            // Calculate the dimensions to fit the image within the container
                            // while maintaining the aspect ratio of the crop
                            let cropAspectRatio = cropWidth / cropHeight
                            let containerAspectRatio = CGFloat(stickerInfo.prevAvailableWidth) / CGFloat(stickerInfo.prevAvailableHeight)
                            
                            var finalWidth: CGFloat
                            var finalHeight: CGFloat
                            
                            if cropAspectRatio > containerAspectRatio {
                                // Crop is wider than container - constrain by width
                                finalWidth = CGFloat(stickerInfo.prevAvailableWidth)
                                finalHeight = finalWidth / cropAspectRatio
                            } else {
                                // Crop is taller than container - constrain by height
                                finalHeight = CGFloat(stickerInfo.prevAvailableHeight)
                                finalWidth = finalHeight * cropAspectRatio
                            }
                            
                            // Apply a safety check to ensure dimensions aren't too large
                            let maxDimension = max(CGFloat(stickerInfo.prevAvailableWidth), CGFloat(stickerInfo.prevAvailableHeight))
                            if finalWidth > maxDimension || finalHeight > maxDimension {
                                if cropAspectRatio > 1 {
                                    finalWidth = maxDimension
                                    finalHeight = finalWidth / cropAspectRatio
                                } else {
                                    finalHeight = maxDimension
                                    finalWidth = finalHeight * cropAspectRatio
                                }
                            }
                            
                            newSize = CGSize(width: finalWidth, height: finalHeight)
                            
                            let newFrame = Frame(size: newSize, center: stickerInfo.baseFrame.center, rotation: stickerInfo.baseFrame.rotation)
                            stickerInfo.baseFrame = newFrame
                            stickerInfo.changeOrReplaceImage = ReplaceModel(modelID: stickerInfo.modelId, imageModel: addImageModel, baseFrame: newFrame)
                            
                            let stickerID = DBMediator.shared.insertStickerInfo(stickerInfoModel: stickerInfo, parentID: parentModel.modelId, templateID: parentModel.templateID, refSize: templateHandler.currentTemplateInfo!.ratioSize, newOrder: parentModel.children.count)
                            
                            self.addNewStickerInfo(StickerInfoId: stickerID, refSize: self.templateHandler!.currentTemplateInfo!.ratioSize, isDuplicate: false, isAdded: true)
                            
//                            self.analyticsLogger.logEditorInteraction(action: .addSticker)
                            self.engineConfig.logAddSticker()
                        }
                    }
                    
                }
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$replaceSticker.dropFirst().sink { [weak self] replaceSticker in
            guard let self = self else { return }
            logger.printLog("replaceSticker")
       
            if let currentModel = templateHandler.currentModel as? StickerInfo {
                // check if current model's baseSize width is greater or height
                // larger value become the new Size
                //                currentModel.stickerImageContent = replaceSticker
            
                // calcute New Size with newSize and crop points
                Task{
                    var newSize:CGSize = .zero
                    if currentModel.prevAvailableWidth>currentModel.prevAvailableHeight{
                        newSize = CGSize(width: CGFloat(currentModel.prevAvailableWidth),height: CGFloat(currentModel.prevAvailableWidth))
                        
                    }else{
                        newSize = CGSize(width: CGFloat(currentModel.prevAvailableHeight),height: CGFloat(currentModel.prevAvailableHeight))
                    }
                    if let prevImage = await currentModel.changeOrReplaceImage?.imageModel.getImage(engineConfig: self.engineConfig){
                        let prevCropRect = (currentModel.changeOrReplaceImage?.imageModel.cropRect)!
                        let prevImageSize = prevImage.mySize
                        let prevCropSize = CGSize(width: prevImageSize.width * prevCropRect.size.width, height: prevImageSize.height * prevCropRect.size.height)
                        let prevImageRatio = prevCropSize.width / prevCropSize.height
                        
                        if let image = await replaceSticker?.getImage(engineConfig: self.engineConfig) {
                            let imageSize = image.mySize
                            let tsize = getProportionalSize(currentSize: imageSize, newSize: newSize)
                            
                            let newCropRect = replaceSticker!.cropRect
                            let newCropSize = CGSize(width: imageSize.width * newCropRect.size.width, height: imageSize.height * newCropRect.size.height)
                            let newImageRatio = newCropSize.width / newCropSize.height
                            
                            var newSize: CGSize
                            
                            if roundToOneDecimalPlace(newImageRatio) == roundToOneDecimalPlace(prevImageRatio) {
                                // If aspect ratios match, keep the current frame size
                                newSize = currentModel.baseFrame.size
                            } else {
                                // Calculate the dimensions to fit the image within the container
                                // while maintaining the aspect ratio of the crop
                                let cropWidth = tsize.width * replaceSticker!.cropRect.width
                                let cropHeight = tsize.height * replaceSticker!.cropRect.height
                                let cropAspectRatio = cropWidth / cropHeight
                                
                                // Use the previous frame's dimensions as a reference for the container
                                let containerWidth = currentModel.baseFrame.size.width
                                let containerHeight = currentModel.baseFrame.size.height
                                let containerAspectRatio = containerWidth / containerHeight
                                
                                if cropAspectRatio > containerAspectRatio {
                                    // Crop is wider than container - constrain by width
                                    newSize = CGSize(width: containerWidth, height: containerWidth / cropAspectRatio)
                                } else {
                                    // Crop is taller than container - constrain by height
                                    newSize = CGSize(width: containerHeight * cropAspectRatio, height: containerHeight)
                                }
                                
                                // Apply a safety check to ensure dimensions aren't too large
                                let maxWidth = currentModel.prevAvailableWidth
                                let maxHeight = currentModel.prevAvailableHeight
                                let maxDimension = max(CGFloat(maxWidth), CGFloat(maxHeight))
                                if newSize.width > maxDimension || newSize.height > maxDimension {
                                    if cropAspectRatio > 1 {
                                        newSize = CGSize(width: maxDimension, height: maxDimension / cropAspectRatio)
                                    } else {
                                        newSize = CGSize(width: maxDimension * cropAspectRatio, height: maxDimension)
                                    }
                                }
                            }
                            
                            let newFrame = Frame(size: newSize, center: currentModel.baseFrame.center, rotation: currentModel.baseFrame.rotation)
                            
                            DispatchQueue.main.async {
                                currentModel.beginFrame = currentModel.baseFrame
                                currentModel.baseFrame = newFrame
                                currentModel.stickerImageContent = replaceSticker
                                currentModel.changeOrReplaceImage = ReplaceModel(modelID: currentModel.modelId, imageModel: replaceSticker!, baseFrame: newFrame)
                                self.templateHandler!.currentActionState.updateThumb = true
                            }
                            
//                            self.analyticsLogger.logEditorInteraction(action: .replaceSticker)
                            self.engineConfig.logReplaceSticker()
                        }
                    }
                    
                }
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$currentThumbTime.dropFirst().sink { [weak self] time in
            guard let self = self else { return }
            if !isDBDisabled{
                _ = DBManager.shared.updateTemplateThumbTime(templateId: templateHandler.currentTemplateInfo!.templateId, newValue: time)
            }
            templateHandler.currentTemplateInfo?.thumbTime = time
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentTemplateInfo?.$outputType.dropFirst().sink { [weak self] type in
            guard let self = self else { return }
            if !isDBDisabled{
                _ = DBManager.shared.updateTemplateOutputType(templateId: templateHandler.currentTemplateInfo!.templateId, outputType: type.rawValue)
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$addNewpage.dropFirst().sink { [weak self] addNewPage in
            guard let self = self else { return }
            logger.printLog("addNewPage")
            let page = PageInfo.createDefaultPage(bgType: (templateHandler.currentPageModel?.bgContent)!,baseSize: templateHandler.currentTemplateInfo?.ratioSize)
            page.orderInParent = templateHandler.currentPageModel!.orderInParent + 1
            page.imageType = templateHandler.currentPageModel!.imageType
            self.addNewPage(pageInfo: page, templateInfo: templateHandler.currentTemplateInfo!)
            
        }.store(in: &actionStateCancellables)
        
        
       
        
        templateHandler.currentActionState.$moveModel.dropFirst().sink {[weak self] value in
            guard let self = self else { return }
            
            guard let moveModel = value else {return}
                        
            
            // we are checking if any parent needs to be unDelete
            
            if moveModel.type == .UnGroup || moveModel.type == .Group {
                if let parentIdToAdd = moveModel.shouldAddParentID  {
                    
                    // check if its alredy avaiable in dictionary ,
                    if let parent = templateHandler.getModel(modelId: parentIdToAdd) as? ParentInfo {
                        parent.softDelete = false
                        if !isDBDisabled{
                            _ = DBManager.shared.updateSoftDelete(modelId: parentIdToAdd, newValue: false.toInt())
                        }

                        logger.logInfo("Group/Ungroup Parent \(parentIdToAdd) Added -DB")

                    }
                    
                    
                }
            }
            
            
            
                if moveModel.oldMM.count<1{
                    logger.printLog("move model is empty")
                    return
                }
                
                for index in 0...moveModel.oldMM.count-1{
                    
                    
                    let oldChildValue = moveModel.oldMM[index]
                    
                    
                    let newChildValue = moveModel.newMM[index]
                    
                    // for each value in moveModel
                    // get oldParent
                    //  newParent
                    // existing Child
                    
                    if let oldParent = templateHandler.getModel(modelId: oldChildValue.parentID) as? ParentModel,
                       let newParent = templateHandler.getModel(modelId: newChildValue.parentID) as? ParentModel,
                       let childModel = templateHandler.getModel(modelId: oldChildValue.modelID){
                        
                        // updateDB
                        let size =  newParent.baseFrame.size
                        // update parentID,order and basemodel in DB
                        let bool = DBManager.shared.updateMoveModelChild(moveModelData: newChildValue, parentSize: size)
                        
                        if let page = templateHandler.currentPageModel{
                            for index in 0..<newChildValue.arrayOFParents.count{
                                if index == 0{
                                    DBManager.shared.updateForParentArray(parentArray: newChildValue.arrayOFParents[index], parentSize: page.baseFrame.size)
                                }else{
                                    DBManager.shared.updateForParentArray(parentArray: newChildValue.arrayOFParents[index], parentSize: newChildValue.arrayOFParents[index-1].BaseFrame.size)
                                }
                                for childArray in newChildValue.arrayOFParents[index].Child{
                                    DBManager.shared.updateForChild(childValue: childArray, parentSize: newChildValue.arrayOFParents[index].BaseFrame.size)
                                }
                                
                            }
                        }
                        
                        if oldParent.modelId == newParent.modelId{
                            logger.printLog("NKG Old Parent Id is Same as New Parent Id \(newParent.modelId)");
                           
                            oldParent.changeOrder(child: childModel, oldOrder: oldChildValue.orderInParent - 1, newOrder: newChildValue.orderInParent)
                            
                            logger.printLog("order In change done")
                        }// end oldParent and newParent is same
                        
                        else{
                            
                            // Remove Old Child From Parent
                            
                            if let index = oldParent.children.firstIndex(where: {$0.modelId == oldChildValue.modelID}){
                                logger.printLog("NKG remove child from the previous parent \(newParent.modelId)");
                                oldParent.children.remove(at: index)
                                oldParent.decreaseOrderFromIndex(oldChildValue.orderInParent)
                            }
                            
                            childModel.modelFlipHorizontal = newChildValue.hFlip
                            
                            childModel.modelFlipVertical = newChildValue.vFlip
                            
                            
                            childModel.baseFrame = newChildValue.baseFrame
                            childModel.parentId = newChildValue.parentID
                            childModel.orderInParent = newChildValue.orderInParent
                            childModel.baseTimeline = newChildValue.baseTime
                            
                            childModel.depthLevel = newChildValue.depthLevel
                            if let parent = childModel as? ParentModel{
                                parent.updateDepthLevelForChildren()
                            }
                            
                            for parent in newChildValue.arrayOFParents{
                                if let parentInModel = templateHandler.getModel(modelId: parent.modelID){
                                    
                                    parentInModel.baseFrame = parent.BaseFrame
                                    parentInModel.baseTimeline = parent.BaseTime
                                    for child in parent.Child{
                                        if let childInParent = templateHandler.getModel(modelId: child.modelID){
                                            childInParent.baseFrame = child.BaseFrame
                                            childInParent.baseTimeline = child.BaseTime
                                        }
                                        
                                        
                                    } // end of child
                                    
                                    
                                    
                                }// end of parent
                                
                                
                            }// end of for loop of each parent which is change
                            
                            if !newParent.children.contains(where: {$0.modelId == newChildValue.modelID}){

                                newParent.children.insert(childModel, at: min(newParent.children.count,newChildValue.orderInParent))
                                newParent.increaseOrderFromIndex(newChildValue.orderInParent+1 )
                            }
                            
                        }// if old and new parent is not same
                        
                        
                        
                    }// end of get old new and child from model
                    
                }
            
            if moveModel.type == .UnGroup || moveModel.type == .Group {
                if let parentIdToAdd = moveModel.shouldRemoveParentID  {
                    
                    // check if its alredy avaiable in dictionary ,
                    if let parent = templateHandler.getModel(modelId: parentIdToAdd) as? ParentInfo {
                        if !isDBDisabled{
                            _ = DBManager.shared.updateSoftDelete(modelId: parentIdToAdd, newValue: true.toInt())
                        }

                        parent.softDelete = true
                        logger.logInfo("Group/Ungroup Parent \(parentIdToAdd) Deleted -DB")

                    }
                    
                    
                }
            }
        }.store(in: &actionStateCancellables)
        
        
        
        
    
    

        
        // Editor VC ratio selected
        templateHandler.currentActionState.$updateThumb.dropFirst().sink { [weak self] shouldUpdate in
            guard let self = self else { return }
            if  let currentModel = templateHandler.currentModel {
                print("Thumb Update Call")
                Task {
                    await self.thumbManagar?.updateThumbnail(id: currentModel.modelId)
                }
                
               // sceneManager.updateThumbnail(id: currentModel.modelId)
            }
            
        }.store(in: &actionStateCancellables)
        
        // Editor VC ratio selected
        templateHandler.currentActionState.$updatePageAndParentThumb.dropFirst().sink { [weak self] shouldUpdate in
            guard let self = self else { return }
            if  let currentModel = templateHandler.currentPageModel {
                print("Thumb Update Call")
//                Task {
                     self.thumbManagar?.updateParentAndPage(currentTime: self.timeLoopHandler?.currentTime ?? 0.0)
//                }
                
//                sceneManager.updateThumbnail(id: currentModel.modelId)
            }
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$didRatioSelected.dropFirst().sink { [weak self] ratioModel in
            guard let self = self else { return }
            templateHandler.selectCurrentPage()
            print("Ratio selected: \(ratioModel)")
            templateHandler.currentTemplateInfo?.ratioId = ratioModel.id
            
            let ratioModel = DBManager.shared.getRatioDbModel(ratioId: ratioModel.id)
            if !isDBDisabled{
                _ = DBManager.shared.updateTemplateRatioId(templateId: templateHandler.currentTemplateInfo!.templateId, newValue: ratioModel!.id)
            }
            if let ratio = templateHandler.currentTemplateInfo?.ratioInfo.getRatioInfo(ratioInfo: ratioModel!, refSize: engineConfig.getBaseSize(), logger: logger){
                templateHandler.currentTemplateInfo?.ratioInfo = ratio
            }
      
//            self.analyticsLogger.logEditorInteraction(action: .resizeTapped)
            engineConfig.logResizeTapped()

            
        }.store(in: &actionStateCancellables)
        
        // Editor VC menu actions
        templateHandler.currentActionState.$exportPageTapped.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == true{
                templateHandler.lastSelectedId = templateHandler.currentModel?.modelId
                if timeLoopHandler?.renderState == .Playing{
                    timeLoopHandler?.renderState = .Paused
                }
                editorUIState = .SelectThumbnail
                templateHandler.deepSetCurrentModel(id: -1)
//                templateHandler.currentActionState.exportPageTapped = false
//                templateHandler.currentActionState.showThumbnailNavItems = true
            }
        }.store(in: &actionStateCancellables)
       
 
        templateHandler.currentActionState.$snappingMode.dropFirst().sink {[weak self] mode in
            guard let self = self else { return }
            viewManager?.gridManager?.snappingMode = mode
        }.store(in: &actionStateCancellables)

        
        templateHandler.currentActionState.$musicAdded.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == true{
                templateHandler.deepSetCurrentModel(id: -1)
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$addNewMusicModel.dropFirst().sink { [weak self] newMusicModel in
            guard let self = self else { return }
            // Insert Into DB
            print("Selcted Music \(newMusicModel)")
            print("duration: \(newMusicModel.duration)")
            // update th.currentMusic = musicModel
            var musicInfo = MusicInfo()
            musicInfo.name = newMusicModel.displayName
            musicInfo.musicPath = newMusicModel.localPath
            musicInfo.duration = newMusicModel.duration
            musicInfo.musicType = newMusicModel.musicType
            musicInfo.templateID = templateHandler.currentTemplateInfo?.templateId ?? 0
            musicInfo.parentID = templateHandler.currentTemplateInfo?.serverTemplateID ?? 0
//            _ = DBManager.shared.updateMusicInfoForTemplateID(templateID: templateHandler.currentTemplateInfo?.templateId ?? 0, musicInfo: musicInfo)
            
            if templateHandler.currentActionState.currentMusic == nil{
                if !isDBDisabled{
                    _ = DBManager.shared.replaceMusicInfoRowIfNeeded(musicDbModel: musicInfo)
                }
                templateHandler.currentActionState.currentMusic = musicInfo
    //            timeLoopHandler.renderState = .Playing
                
                
            }else{
                if !isDBDisabled{
                    _ = DBManager.shared.updateMusicInfoForTemplateID(templateID: templateHandler.currentTemplateInfo?.templateId ?? 0, musicInfo: musicInfo)
                }
                
                audioPlayer?.audioPlayer = nil
                
                templateHandler.currentActionState.currentMusic = musicInfo
            }
            
            audioPlayer?.templateHandler = templateHandler
            
//            self.analyticsLogger.logEditorInteraction(action: .addMusic)
            engineConfig.logAddMusic()

        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$deleteMusic.dropFirst().sink {[weak self]  musicInfo in
            guard let self = self else { return }
            // remove music Info
            
            // th.currentMusic = nil
            self.templateHandler.currentActionState.currentMusic = nil
            if !isDBDisabled{
                _ = DBManager.shared.deleteMusicInfo(musicId: musicInfo.musicID)
            }
//            self.audioPlayer?.currentMusic = nil
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$replaceMusic.dropFirst().sink {[weak self] musicModel in
            guard let self = self else { return }
            // Insert Into DB
            
            // update th.currentMusic = musicModel
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$didUngroupTapped.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == true{
                ungroupParent(parentID: templateHandler.currentParentModel!.modelId)
            }
        }.store(in: &actionStateCancellables)
       
        
//        templateHandler.currentActionState.$didCloseTabbarTapped.dropFirst().sink { [weak self] value in
//            guard let self = self else { return }
//            if value == true{
//               // templateHandler.deepSetCurrentModel(id: templateHandler.currentModel!.parentId)
//                templateHandler.setCurrentModel(id: templateHandler.currentModel!.parentId)
//            }
//        }.store(in: &actionStateCancellables)
        
        guard let templateHandler = self.templateHandler else {
            logger.logError("template handler nil")
            return }

        templateHandler.currentTemplateInfo?.$ratioInfo.dropFirst().sink(receiveValue: {[weak self] newRatioModel in
            guard let self = self else { return }
            
//            self.canvas.resizeCanvas(size: newRatioModel.ratioSize)
            let newRefSize = newRatioModel.ratioSize
            let oldSize = templateHandler.currentTemplateInfo?.ratioSize
            updateRatioOFPage(newPageSize: newRefSize)
 
      
//            editorView.canvasView.touchView?.frame.size = newRefSize
            editorView?.updateCenter()
            
            Task { [weak self] in
                guard let self = self else { return }
                
                await sceneManager.changeRatio(ratio: newRefSize, refSize: engineConfig.getBaseSize())
                await MainActor.run {
//                    guard let self = self else { return }
                    self.viewManager?.ratioDidChange(page: templateHandler.currentPageModel!)
                    
                    templateHandler.selectCurrentPage()
                    
                    
                    self.templateHandler.currentActionState.updatePageAndParentThumb = true

                }
            }
            
            

        }).store(in: &actionStateCancellables)
        
        
        
        templateHandler.currentActionState.$didGroupTapped.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == true{
               
                templateHandler.currentActionState.multiSelectedItems.forEach { model in
                    if let model = templateHandler.getModel(modelId: model.modelId) {
                        model.isSelectedForMultiSelect = false
                    }
                }
                
               

                
                addParent()
                //templateHandler.currentActionState.multiSelectedItems.removeAll()

                templateHandler.currentActionState.multiModeSelected = false
                templateHandler.currentActionState.timelineShow = true
                templateHandler.currentActionState.showNavgiationItems = true
//                self.analyticsLogger.logEditorInteraction(action: .group)
                engineConfig.logGroup()

                
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$didCancelTapped.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == true{
                
                templateHandler.currentActionState.multiSelectedItems.forEach { model in
                    if let model = templateHandler.getModel(modelId: model.modelId) {
                        model.isSelectedForMultiSelect = false
                    }
                }
                
                templateHandler.currentActionState.multiSelectedItems.removeAll()

                templateHandler.currentActionState.multiModeSelected = false
                templateHandler.currentActionState.showNavgiationItems = true
                templateHandler.currentActionState.timelineShow = true
                
                templateHandler.deepSetCurrentModel(id: templateHandler.lastSelectedId!)

            }
        }.store(in: &actionStateCancellables)
        templateHandler.currentActionState.$multiModeSelected.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            
            viewManager?.groupingDidStart(value)
            
            if templateHandler.currentActionState.multiModeSelected != value {
                templateHandler.currentActionState.showMusicPickerRoundButton = !value
                templateHandler.currentActionState.showPlayPauseButton = !value
                templateHandler.currentActionState.ShowMusicSlider = !value
            }
            if value == true{
                
                if timeLoopHandler?.renderState == .Playing{
                    timeLoopHandler?.renderState = .Paused
                }
                
                
                guard let currentModel = templateHandler.currentModel else { return }
                
                var currentModelID = currentModel.modelId
                var currentModelType = currentModel.modelType
                templateHandler.lastSelectedId = currentModel.modelId
                
                //                if currentModel is PageInfo{
                //                    unSelectedIds = templateHandler.getChildrenMultiselectObject(parentID: currentModel.modelId)
                templateHandler.layers = templateHandler.currentPageModel?.activeChildren ?? []
                templateHandler.currentActionState.multiSelectedItems.removeAll()
                templateHandler.layers.first?.depthLevel = 0
                for child in templateHandler.layers{
                    child.depthLevel = 0
                }
                templateHandler.updateFlatternTree()
                
                if let parentModel = currentModel as? ParentModel{
                    if parentModel.editState{
                        templateHandler.expandNode(parentModel, expand: parentModel.editState)
                    }
                }
                
                templateHandler.currentActionState.multiUnSelectItems = templateHandler.flatternTree
                
                var selectedId : Int = 0
                
                
                if !(currentModel is PageInfo) {
                    if let parentModel = currentModel as? ParentInfo {
                        
                        // is parent edited
                        
                        
                        // is parent itself selected or its child is selected
                        
                        // is parent selected but not edited
                        if  parentModel.editState {
                            
                            viewManager!.observeEditStateListener(model : parentModel)
                            
                            
                            
                        } else {
                            // parent is editeded
                            //                            templateHandler.currentActionState.addItemToMultiSelect = currentModel.modelId
                            selectedId = currentModel.modelId
                        }
                        
                        
                        
                    }else{
                        let parentModel = templateHandler.getModel(modelId: currentModel.parentId)
                        if let parentModel = parentModel as? ParentModel, parentModel.modelType == .Parent{
                            if parentModel.editState{
                                viewManager!.observeEditStateListener(model : parentModel)
                                selectedId = currentModel.modelId
                            }else{
                                selectedId = currentModel.modelId
                            }
                        }else{
                            selectedId = currentModel.modelId
                        }
                        //                        templateHandler.currentActionState.addItemToMultiSelect = currentModel.modelId
                    }
                    
                }
                
                
                editorUIState = .MultipleSelectMode
                templateHandler.deepSetCurrentModel(id: -1,smartSelect: false,  deepSmartSelect : false )
                
                if selectedId != 0 {
                    templateHandler.currentActionState.addItemToMultiSelect = selectedId
                }
                
                templateHandler.currentActionState.showMultiSelectNavItems = true
                templateHandler.currentActionState.timelineShow = false
                
            } else {
                
            }
            
            
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$addItemToMultiSelect.dropFirst().sink { [weak self] addItemID in
            guard let self = self else { return }
            logger.printLog("item added")
            let model = templateHandler.getModel(modelId: addItemID)
            
           // let multiSelectModel = MultiSelectedArrayObject(id: addItemID, thumbImage: (model?.thumbImage ?? UIImage(named: "b0"))!)
            if model is ParentInfo{
                viewManager?.observeEditStateListener(model: model!)
            }
            viewManager?.hideEditButton(id: addItemID)
            model?.isSelectedForMultiSelect = true
            
            // conflicr check for neeshu merge
            if model is ParentInfo {
                if let parentModel = model as? ParentInfo, parentModel.editState != true{
                    templateHandler.currentActionState.multiSelectedItems.append(model!)//addItemID)
                    templateHandler.currentActionState.multiUnSelectItems.removeAll(where: {$0.modelId == addItemID})
                }
            }
            else{
                templateHandler.currentActionState.multiSelectedItems.append(model!)//addItemID)
                templateHandler.currentActionState.multiUnSelectItems.removeAll(where: {$0.modelId == addItemID})
            }
         
            if templateHandler.currentActionState.multiSelectedItems.count <= 1{
                templateHandler.currentActionState.showGroupButton = false
            }else{
                templateHandler.currentActionState.showGroupButton = true
            }
        }.store(in: &actionStateCancellables)
        
        templateHandler.currentActionState.$removeItemFromMultiSelect.dropFirst().sink { [weak self] addItemID in
            guard let self = self else { return }
            let model = templateHandler.getModel(modelId: addItemID)
        
           // let multiSelectModel = MultiSelectedArrayObject(id: addItemID, thumbImage: (model?.thumbImage ?? UIImage(named: "b0"))!)
            // neeshu
            viewManager?.removeEditStateListener(for: model!)
            model?.isSelectedForMultiSelect = false
           // templateHandler.currentActionState.multiUnSelectItems.append(multiSelectModel)//addItemID)
            
            if let index = templateHandler.flatternTree.firstIndex(where: { $0.modelId == model?.modelId}){
//                if !templateHandler.currentActionState.multiUnSelectItems.contains(where: { $0.modelId == model!.modelId }) {
//                    templateHandler.currentActionState.multiUnSelectItems.append(model!)
//
//                }
                if !templateHandler.currentActionState.multiUnSelectItems.contains(where: { $0.modelId == model!.modelId }) {
//                    templateHandler.currentActionState.multiUnSelectItems.insert(model!, at: index)
                    templateHandler.currentActionState.multiUnSelectItems.insert(model!, at: min(index, templateHandler.currentActionState.multiUnSelectItems.count))
                }
            }
            
            templateHandler.currentActionState.multiUnSelectItems.sort { first, second in
                guard
                    let firstIndex = templateHandler.flatternTree.firstIndex(where: { $0.modelId == first.modelId }),
                    let secondIndex = templateHandler.flatternTree.firstIndex(where: { $0.modelId == second.modelId })
                else {
                    return false
                }
                return firstIndex < secondIndex
            }
            
//            templateHandler.currentActionState.multiSelectedItems.removeAll(where: {$0.modelId == addItemID})
//            viewManager.unhideEditButton(id : addItemID)
//            }
            templateHandler.currentActionState.multiSelectedItems.removeAll(where: {$0.modelId == addItemID})
            viewManager?.unhideEditButton(id : addItemID)
            if templateHandler.currentActionState.multiSelectedItems.count <= 1{
                templateHandler.currentActionState.showGroupButton = false
            }else{
                templateHandler.currentActionState.showGroupButton = true
            }

        }.store(in: &actionStateCancellables)
                
    }
}




func roundToOneDecimalPlace(_ value: Double) -> Double {
    return (value * 10).rounded() / 10
}

func getScaledCropSizeToFit(containerSize: CGSize, cropWidthRatio: CGFloat, cropHeightRatio: CGFloat) -> CGSize {
    let cropAspectRatio = cropWidthRatio / cropHeightRatio
    let containerAspectRatio = containerSize.width / containerSize.height

    var finalWidth: CGFloat
    var finalHeight: CGFloat

    if cropAspectRatio > containerAspectRatio {
        // Wider: match width, scale height
        finalWidth = containerSize.width
        finalHeight = containerSize.width / cropAspectRatio
    } else {
        // Taller or square: match height, scale width
        finalHeight = containerSize.height
        finalWidth = containerSize.height * cropAspectRatio
    }

    return CGSize(width: finalWidth, height: finalHeight)
}
