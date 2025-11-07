//
//  Engine+TextARD.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//


import Foundation

extension MetalEngine {
    
    func addNewStickerInfo(StickerInfoId:Int,refSize:CGSize, isDuplicate: Bool, isAdded: Bool){
        // fetch sticker info
        guard let baseModel = DBManager.shared.getBaseModelFromDB(modelId: StickerInfoId) else {return}
        if let stickerInfo = DBMediator.shared.createStickerInfo(baseModel: baseModel, refSize: refSize){
           
            
            Task{
                if  await sceneManager.addSticker(stickerInfo:stickerInfo){
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        templateHandler.addModel(model: stickerInfo)
//                        templateHandler.childDict[stickerInfo.modelId] = stickerInfo
//                        templateHandler.currentParentModel?.children.append(stickerInfo)
                        templateHandler.currentSuperModel?.increaseOrderFromIndex(stickerInfo.orderInParent+1)

                        viewManager?.addChild(info: stickerInfo, toParenID: stickerInfo.parentId)
                     
                        var thumbImage = templateHandler.currentModel?.thumbImage
                        //                    templateHandler.childDict[stickerInfo.modelId] = stickerInfo
//                        templateHandler?.currentModel?.softDelete = true
                        stickerInfo.softDelete = true
                       _ = templateHandler.deepSetCurrentModel(id: StickerInfoId)
                        templateHandler?.currentModel?.softDelete = false

                        if isDuplicate{
                            stickerInfo.thumbImage = thumbImage// templateHandler.currentModel?.thumbImage
                            templateHandler.currentActionState.shouldRefreshOnAddComponent = true

                        }else if isAdded{
                            // HK
                          
//                                await thumbManagar?.updateThumbnail(id: StickerInfoId)
                            Task { [weak self] in
                                guard let self = self else { return }
                                
                                await self.thumbManagar?.updateStickerThumb(stickerInfo: stickerInfo,completion: { _success in
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        
                                        templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                    }
                                })
                            }


                           // templateHandler.currentActionState.updateThumb = true
                        }else{
                            stickerInfo.thumbImage = thumbImage// templateHandler.currentModel?.thumbImage
                            templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                        }

                    }
                }
            }
            
        }
    }
    
    func addNewText(text:String,model:BaseModel,currentTime:Float,isDuplicate:Bool) async{
        var textInfo = TextInfo()
        textInfo.text = text
        
        if let page = model as? ParentModel{
            textInfo.addDefaultModel(parentModel: page, baseModel: textInfo)
            textInfo.templateID = templateHandler.currentTemplateInfo?.templateId ?? 0
            // if prevtext Model is existing then add that value into new Text
            if let prevText = templateHandler.currentTextModel{
                textInfo.fontSize = prevText.fontSize
                textInfo.bgColor = prevText.bgColor
                textInfo.textFont = prevText.textFont
                textInfo.textGravity = prevText.textGravity
                textInfo.fontName = prevText.fontName
                textInfo.textColor = prevText.textColor
                textInfo.internalWidthMargin = prevText.internalWidthMargin
                textInfo.bgAlpha = prevText.bgAlpha
                textInfo.bgType = prevText.bgType
                textInfo.letterSpacing = prevText.letterSpacing
                textInfo.lineSpacing = prevText.lineSpacing
                textInfo.shadowColor = prevText.shadowColor
                textInfo.bgDrawable = prevText.bgDrawable
                textInfo.internalHeightMargin = prevText.internalHeightMargin
                textInfo.shadowDx = prevText.shadowDx
                textInfo.shadowDy = prevText.shadowDy
                textInfo.shadowOpacity = prevText.shadowOpacity
                textInfo.shadowRadius = prevText.shadowRadius
                
            }
//            textInfo.startTime = currentTime - getParentStartTime(parentModel: page)
//            textInfo.duration = min(page.duration, 3.0)
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
            if ((timeLoopHandler?.currentTime ?? 0) + minStartTime) >= currentTD{
                time = currentTD - minStartTime
            }else{
                time = timeLoopHandler?.currentTime ?? 0
            }
//            if (timeLoopHandler?.currentTime ?? 0) + minStartTime >= templateHandler.currentPageModel?.baseTimeline.duration ?? 0{
//                time = (templateHandler.currentPageModel?.baseTimeline.duration ?? 0) - minStartTime
//            }else{
//                time = timeLoopHandler?.currentTime ?? 0
//            }
            
            let newTime: Float
            if page.modelType == .Parent{
                newTime = templateHandler.getNewStartTimeForNewComponent(childStartTime: time, newParentID: page.modelId)
            }else{
                newTime = time
            }
            
            textInfo.baseTimeline.startTime = newTime - page.baseTimeline.startTime
            textInfo.baseTimeline.duration = page.baseTimeline.duration - (newTime - page.baseTimeline.startTime)
//            textInfo.baseTimeline.startTime = time//currentTime - getParentStartTime(parentModel: page)
//            textInfo.baseTimeline.duration = page.baseTimeline.duration - time// min(page.duration, 3.0)
            
            textInfo.orderInParent = page.children.count
            
            await addTextInfo(textInfo: textInfo, refSize: CGSize(width: Double(page.baseFrame.size.width), height: Double(page.baseFrame.size.height)), isDuplicate: isDuplicate)
        }
        
        
        else if let parentModel = templateHandler.getParentFor(childId: model.modelId) {
            textInfo.addDefaultModel(parentModel: parentModel, baseModel: textInfo)
            await addTextInfo(textInfo: textInfo, refSize: CGSize(width: Double(parentModel.width), height: Double(parentModel.height)), isDuplicate: isDuplicate)
        }
    }
    
  
    
    
    func addTextInfo(textInfo: TextInfo,refSize:CGSize,isDuplicate:Bool) async{
        let s = textInfo
        let newTextID = DBMediator.shared.insertTextInfo(textInfoModel: s, parentID: s.parentId, templateID: s.templateID, refSize: refSize)
        s.modelId = newTextID
        await addNewTextInfo(textInfoId: newTextID,refSize: refSize, isDuplicate: isDuplicate, isAdded: true )
        
        //            let localStickerInfo = s
        //a local copy of 's'
    }
    
    
    
    func addNewTextInfo(textInfoId : Int , refSize : CGSize , isDuplicate:Bool, isAdded : Bool) async{
        // Fetch Text INfo
        guard let baseModel = DBManager.shared.getBaseModelFromDB(modelId: textInfoId) else {return}
        if let textInfo = DBMediator.shared.createTextInfo(model: baseModel, refSize: refSize){
            
                await sceneManager.addText(textInfo: textInfo)
                DispatchQueue.main.async { [ self] in
                    templateHandler.addModel(model: textInfo)
                    templateHandler.currentSuperModel?.increaseOrderFromIndex(textInfo.orderInParent+1)

                    
                    viewManager?.addChild(info: textInfo, toParenID: textInfo.parentId)
                    
//                    templateHandler.childDict[textInfo.modelId] = textInfo
//                    templateHandler.currentParentModel?.children.append(textInfo)
//                    templateHandler?.currentModel?.softDelete = true
                    let thumbImage = templateHandler.currentModel?.thumbImage
                    textInfo.softDelete = true
                    _ = templateHandler.deepSetCurrentModel(id: textInfoId)
                    templateHandler?.currentModel?.softDelete = false


                    if isDuplicate{
                        textInfo.thumbImage = thumbImage
                        templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                    }else if isAdded{
                        
                        Task { [weak self] in
                            guard let self = self else { return }
                            
                            await self.thumbManagar?.updateTextThumb(text: textInfo, completion: { _success in
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                                }
                            })
                        }
                    }
                    else{
                        textInfo.thumbImage = thumbImage
                        templateHandler.currentActionState.shouldRefreshOnAddComponent = true
                    }
                    
                }
            
        }
    }
    
    
    func addParent(){
        // create parent add in db
        // this method create a default parentInfo add into DB and give parentInfo with modelID
//            if templateHandler.currentActionState.multiSelectedItems.isEmpty{
//                return
//            }
        let parentInfo = ParentInfo()
        
        //         templateHandler.currentActionState.multiSelectedItems = [3463,3462]
        // insert parent in DB
        let frame = getParentFrame()
        
        parentInfo.baseFrame.size.width = frame.0.width
        parentInfo.baseFrame.size.height = frame.0.height
        parentInfo.baseFrame.center.x = frame.0.midX
        parentInfo.baseFrame.center.y = frame.0.midY
        parentInfo.prevAvailableWidth = Float(parentInfo.baseFrame.size.width)
        parentInfo.prevAvailableHeight = Float(parentInfo.baseFrame.size.height)
//            parentInfo.softDelete = true
        parentInfo.lockStatus = false
        parentInfo.orderInParent =  templateHandler.currentPageModel?.children.count ?? 0
        
        parentInfo.baseTimeline.duration = frame.1.duration//templateHandler.currentPageModel?.baseTimeline.duration ?? 15.0
        parentInfo.baseTimeline.startTime = frame.1.startTime//templateHandler.currentPageModel?.baseTimeline.startTime ?? 0.0
        parentInfo.orderInParent = (templateHandler.currentPageModel?.children.count ?? 0)
        parentInfo.templateID = templateHandler.currentPageModel?.templateID ?? 0
        parentInfo.parentId = templateHandler.currentPageModel?.modelId ?? 0
        parentInfo.modelType = .Parent
        parentInfo.beginFrame = parentInfo.baseFrame
        parentInfo.endFrame = parentInfo.baseFrame
        parentInfo.beginBaseTimeline = parentInfo.baseTimeline
        parentInfo.endBaseTimeline = parentInfo.baseTimeline
        // center calculations is wrong
        let parentID = DBManager.shared.replaceBaseModelIfNeeded(baseModel: parentInfo.getBaseModel(refSize: templateHandler.currentPageModel!.baseFrame.size))
        
        var animationModel = parentInfo.getAnimation()
        animationModel.modelId = parentID
        // insertAnimation
        var animationID = DBManager.shared.replaceAnimationRowIfNeeded(animation: animationModel)
        
        parentInfo.modelId = parentID
        
        
        
        
        // add in template handler
//        templateHandler.addModel(model: parentInfo)
        templateHandler.childDict[parentInfo.modelId] = parentInfo
        templateHandler.currentPageModel?.addChild(child: parentInfo) // forecibly adding to pageModel
        Task{
            
            
            // add in scene manager
            
            await sceneManager.addParent(parentInfo: parentInfo)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // JDChange
                self.viewManager?.addChild(info: parentInfo, toParenID: templateHandler.currentPageModel!.modelId)
                //EndChange
                //                self.addSelectedViewsInGroupView(parentID: parentID, parentInfo: parentInfo)
               // templateHandler.childDict[parentInfo.modelId] = parentInfo
                var moveModel = self.addSelectedViewsInGroupView(parentInfo: parentInfo)
               
                moveModel.oldlastSelectedId = templateHandler.currentActionState.multiSelectedItems.first!.modelId
                moveModel.newLastSelected = parentInfo.modelId
                
                moveModel.shouldAddParentID = parentInfo.modelId
                moveModel.shouldRemoveParentID = nil
                
                templateHandler?.performGroupAction(moveModel: moveModel)

            }
            
        }
        
    }
    
    
}
// create private functions for metal engine
extension MetalEngine{
    
    
    // Method to add a new page using the provided PageInfo and TemplateInfo
    internal func addNewPage(pageInfo: PageInfo, templateInfo: TemplateInfo) {
        // Add the new page in the database with the same templateID
        pageInfo.baseTimeline.startTime = templateInfo.totalDuration
        templateHandler.currentTemplateInfo?.thumbTime = templateInfo.totalDuration + pageInfo.duration
        
        // Insert the page information into the database and get the new page ID
        let id = DBMediator.shared.insertPageInfo(pageInfo: pageInfo, templateInfo: templateInfo)
        
        // Add the new page to the engine
        addPageinEngine(for: id, templateInfo: templateInfo)
    }

    
    // Method to add the page in the rendering engine using the model ID and TemplateInfo
    internal func addPageinEngine(for modelID: Int, templateInfo: TemplateInfo) {
        // Retrieve the base model from the database using the model ID
        if let pg = DBManager.shared.getBaseModelFromDB(modelId: modelID) {
            
            // Create a new PageInfo object from the base model and reference size
            if let page = DBMediator.shared.createPageInfo(pageModel: pg, refSize: templateInfo.ratioSize) {
                
              
                
                // templateHandler.addModel(model: page) // Uncomment if needed
                
                // Asynchronous task to handle adding the page information to the current template and scene manager
                Task {
                    // Add the page information to the current template
                    templateHandler.currentTemplateInfo?.addPageInfo(pageInfo: page)
                    /* Changes By NK */
                    // Add into the templateHandler Child Dictionary.
                    templateHandler.childDict[page.modelId] = page
                    
                    // Add the page to the scene manager asynchronously
                    await sceneManager.addPage(pm: page)
                    
                    // Update UI-related changes on the main thread
                    DispatchQueue.main.async { [self] in
                        templateHandler.deepSetCurrentModel(id: page.modelId)
                        templateHandler.currentModel?.softDelete = false
                        templateHandler.currentActionState.updateThumb = true
                    }
                }
            }
        }
    }

  
   

    
   
    
}
