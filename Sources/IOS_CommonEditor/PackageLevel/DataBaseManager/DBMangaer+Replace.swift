//
//  DBMangaer+Replace.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 21/07/23.
//

import Foundation

extension DBManager{
    
    // MARK: - Insertion    
    func replaceTemplateRowIfNeeded(template: DBTemplateModel) -> Int {
        var insertedRowId: Int = -1
        logger?.printLog("OpenGlTest In DesignDbHelper insertTemplateRow")
        
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(TEMPLATE_NAME), \(CATEGORY), \(RATIO_ID), \(THUMB_SERVER_PATH), \(THUMB_LOCAL_PATH), \(THUMB_TIME), \(TOTAL_DURATION), \(SEQUENCE), \(IS_PREMIUM), \(CATEGORY_TEMP), \(DATA_PATH), \(SERVER_TEMPLATE_ID), \(IS_DETAILS_DOWNLOAD), \(IS_RELEASED), \(COLOR_PALLETE_ID), \(FONT_SET_ID), \(EVENT_DATA), \(EVENT_TIME), \(VENUE), \(NAME1), \(NAME2), \(RSVP), \(BASE_COLOR), \(LAYOUT_ID), \(EVENT_ID), \(TEMPLATE_STATUS), \(ORIGINAL_TEMPLATE), \(TEMPLATE_EVENT_STATUS), \(SOFT_DELETE), \(EVENT_TEMPLATE_JSON), \(USER_ID), \(EVENT_START_DATE), \(SHOW_WATERMARK)) VALUES ('\(template.templateName)', '\(template.category)', '\(template.ratioId)', '\(template.thumbServerPath)', '\(template.thumbLocalPath)', '\(template.thumbTime)', '\(template.totalDuration)', '\(template.sequence_Temp)', '\(template.isPremium)', '\(template.categoryTemp)', '\(template.dataPath)', '\(template.templateId)', '\(template.isDetailDownloaded)', '\(template.isRelease)', '\(template.colorPalleteId)', '\(template.fontSetId)', '\(template.eventData)', '\(template.eventTime)', '\(template.venue)', '\(template.name1)', '\(template.name2)', '\(template.rsvp)', '\(template.baseColor)', '\(template.layoutId)', '\(template.eventId)', '\(template.templateStatus)','\(template.originalTemplate)','\(template.templateEventStatus)','\(template.softDelete)','\(template.eventTemplateJson)', '\(template.userId)', '\(template.eventStartDate)', '\(template.showWatermark)' )"

                
                insertedRowId =  insertNewEntry(query: query)

        
        
        return Int(insertedRowId)
    }
    
    
    // MARK: - Insertion
    func replaceTemplateMetaDataRowIfNeeded(metaData: DBCategoryMetaModel) -> Int {
        var insertedRowId: Int = -1
        NSLog("OpenGlTest In DesignDbHelper insertTemplateRow")
        
        let query = "REPLACE INTO \(TABLE_CATEGORY_METADATA) (\(FIELD_ID), \(FIELD_DISPLAY_NAME), \(TEMPLATE_VALUE), \(CATEGORY_NAME), \(SEQ)) VALUES ('\(metaData.fieldId)', '\(metaData.fieldDisplayName)', '\(metaData.templateValue)', '\(metaData.categoryName)', '\(metaData.seq)')"
        
        insertedRowId = insertNewEntry(query: query)
        
        return Int(insertedRowId)
    }
    
    
    
    func replaceImageRowIfNeeded(image: DBImageModel) -> Int {
        var insertedRowId:Int = -1
       
        NSLog("OpenGlTest In DesignDbHelper insertImageRow")

        let query = "REPLACE INTO \(TABLE_IMAGE) (\(IMAGE_TYPE), \(SERVER_PATH), \(LOCAL_PATH), \(RES_ID), \(IS_ENCRYPTED), \(CROP_X), \(CROP_Y), \(CROP_W), \(CROP_H), \(CROP_STYLE), \(TILE_MULTIPLE), \(COLOR_INFO), \(IMAGE_WIDTH), \(IMAGE_HEIGHT),\(TEMPLATE_ID),\(SOURCE_TYPE)) VALUES ('\(image.imageType)', '\(image.serverPath)', '\(image.localPath)', '\(image.resID)', '\(image.isEncrypted)', '\(image.cropX)', '\(image.cropY)', '\(image.cropW)', '\(image.cropH)', '\(image.cropStyle)', '\(image.tileMultiple)', '\(image.colorInfo)', '\(image.imageWidth)', '\(image.imageHeight)','\(image.templateID )','\(image.sourceTYPE)')"

       
            //  print(query)
                    insertedRowId = insertNewEntry(query: query)
        

        return insertedRowId
     }
    
    func replaceBaseModelIfNeeded(baseModel: DBBaseModel) -> Int {
        var insertedRowId: Int = -1

   
//        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(MODEL_TYPE), \(DATA_ID), \(POS_X), \(POS_Y), \(WIDTH), \(HEIGHT), \(PREV_AVAILABLE_WIDTH), \(PREV_AVAILABLE_HEIGHT), \(ROTATION), \(MODEL_OPACITY), \(MODEL_FLIP_HORIZONTAL), \(MODEL_FLIP_VERTICAL), \(LOCK_STATUS), \(ORDER_IN_PARENT), \(PARENT_ID), \(BG_BLUR_PROGRESS), \(OVERLAY_DATA_ID), \(OVERLAY_OPACITY), \(START_TIME), \(DURATION), \(SOFT_DELETE), \(TEMPLATE_ID)) VALUES ('\(baseModel.modelType)', '\(baseModel.dataId)', '\(baseModel.posX)', '\(baseModel.posY)', '\(baseModel.width)', '\(baseModel.height)', '\(baseModel.prevAvailableWidth)', '\(baseModel.prevAvailableHeight)', '\(baseModel.rotation)', '\(baseModel.modelOpacity)', '\(baseModel.modelFlipHorizontal)', '\(baseModel.modelFlipVertical)', '\(baseModel.lockStatus)', '\(baseModel.orderInParent)', '\(String(describing: baseModel.parentId))', '\(baseModel.bgBlurProgress)', '\(baseModel.overlayDataId)', '\(baseModel.overlayOpacity)', '\(baseModel.startTime)', '\(baseModel.duration)', '\(baseModel.softDelete)', '\(baseModel.templateID)')"

        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(MODEL_TYPE), \(DATA_ID), \(POS_X), \(POS_Y), \(WIDTH), \(HEIGHT), \(PREV_AVAILABLE_WIDTH), \(PREV_AVAILABLE_HEIGHT), \(ROTATION), \(MODEL_OPACITY), \(MODEL_FLIP_HORIZONTAL), \(MODEL_FLIP_VERTICAL), \(LOCK_STATUS), \(ORDER_IN_PARENT), \(PARENT_ID), \(BG_BLUR_PROGRESS), \(OVERLAY_DATA_ID), \(OVERLAY_OPACITY), \(START_TIME), \(DURATION), \(SOFT_DELETE), \(TEMPLATE_ID), \(FILTER_TYPE), \(BRIGHTNESS), \(CONTRAST), \(HIGHLIGHT), \(SHADOWS), \(SATURATION), \(VIBRANCE), \(SHARPNESS), \(WARMTH), \(TINT), \(HAS_MASK), \(MASK_SHAPE)) VALUES ('\(baseModel.modelType)', '\(baseModel.dataId)', '\(baseModel.posX)', '\(baseModel.posY)', '\(baseModel.width)', '\(baseModel.height)', '\(baseModel.prevAvailableWidth)', '\(baseModel.prevAvailableHeight)', '\(baseModel.rotation)', '\(baseModel.modelOpacity)', '\(baseModel.modelFlipHorizontal)', '\(baseModel.modelFlipVertical)', '\(baseModel.lockStatus)', '\(baseModel.orderInParent)', '\(String(describing: baseModel.parentId))', '\(baseModel.bgBlurProgress)', '\(baseModel.overlayDataId)', '\(baseModel.overlayOpacity)', '\(baseModel.startTime)', '\(baseModel.duration)', '\(baseModel.softDelete)', '\(baseModel.templateID)', '\(baseModel.filterType)', '\(baseModel.brightnessIntensity)', '\(baseModel.contrastIntensity)', '\(baseModel.highlightIntensity)', '\(baseModel.shadowsIntensity)', '\(baseModel.saturationIntensity)', '\(baseModel.vibranceIntensity)', '\(baseModel.sharpnessIntensity)', '\(baseModel.warmthIntensity)', '\(baseModel.tintIntensity)', '\(baseModel.hasMask)', '\(baseModel.maskShape)' )"
        
            insertedRowId = insertNewEntry(query: query)
        print("query",query)


           return Int(insertedRowId)
       }
    
    
    
    func replaceStickerRowIfNeeded(stickerDbModel: DBStickerModel) -> Int {
        var insertedRowId: Int = -1
        
        
        let query = """
        REPLACE INTO \(TABLE_STICKER) (
            \(IMAGE_ID), 
            \(STICKER_TYPE), 
            \(STICKER_FILTER_TYPE), 
            \(STICKER_HUE), 
            \(STICKER_COLOR), 
            \(X_ROATATION_PROG), 
            \(Y_ROATATION_PROG), 
            \(Z_ROATATION_PROG),
            \(TEMPLATE_ID), 
            \(STICKER_MODEL_TYPE)
        ) VALUES (
            '\(stickerDbModel.imageId)', 
            '\(stickerDbModel.stickerType)', 
            '\(stickerDbModel.stickerFilterType)', 
            '\(stickerDbModel.stickerHue)', 
            '\(stickerDbModel.stickerColor)', 
            '\(stickerDbModel.xRotationProg)', 
            '\(stickerDbModel.yRotationProg)', 
            '\(stickerDbModel.zRotationProg)', 
            '\(stickerDbModel.templateID)', 
            '\(stickerDbModel.stickerModelType)'
        )
        """
     
            
            insertedRowId = insertNewEntry(query: query)
     
        return Int(insertedRowId)
    }
    

    func replaceTextModelIfNeeded(textDbModel: DBTextModel) -> Int {
        var insertedRowId: Int = -1
   
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(TEXT), \(TEXT_FONT), \(TEXT_COLOR), \(TEXT_GRAVITY), \(LINE_SPACING), \(LETTER_SPACING), \(SHADOW_COLOR), \(SHADOW_OPACITY), \(SHADOW_RADIUS), \(SHADOW_Dx), \(SHADOW_Dy), \(BG_TYPE), \(BG_DRAWABLE), \(BG_COLOR), \(BG_ALPHA), \(INTERNAL_HEIGHT_MARGIN), \(INTERNAL_WIDTH_MARGIN), \(X_ROATATION_PROG), \(Y_ROATATION_PROG), \(Z_ROATATION_PROG), \(CURVE_PROG),\(TEMPLATE_ID)) VALUES ('\(textDbModel.text)', '\(textDbModel.textFont)', '\(textDbModel.textColor)', '\(textDbModel.textGravity)', \(textDbModel.lineSpacing), \(textDbModel.letterSpacing), '\(textDbModel.shadowColor)', \(textDbModel.shadowOpacity), \(textDbModel.shadowRadius), \(textDbModel.shadowDx), \(textDbModel.shadowDy), '\(textDbModel.bgType)', '\(textDbModel.bgDrawable)', '\(textDbModel.bgColor)', \(textDbModel.bgAlpha), \(textDbModel.internalHeightMargin), \(textDbModel.internalWidthMargin), \(textDbModel.xRotationProg), \(textDbModel.yRotationProg), \(textDbModel.zRotationProg), \(textDbModel.curveProg),\(textDbModel.templateID))"
        
            insertedRowId = insertNewEntry(query: query)
               

        return Int(insertedRowId)
    }

    func replaceAnimationRowIfNeeded(animation: DBAnimationModel) -> Int {
        var insertedRowId: Int = -1
        
            let query = "REPLACE INTO \(TABLE_ANIMATION) (\(MODEL_ID), \(IN_ANIMATION_TEMPLATE_ID), \(IN_ANIMATION_DURATION), \(LOOP_ANIMATION_TEMPLATE_ID), \(LOOP_ANIMATION_DURATION), \(OUT_ANIMATION_TEMPLATE_ID), \(OUT_ANIMATION_DURATION),\(TEMPLATE_ID)) VALUES (\(animation.modelId), \(animation.inAnimationTemplateId), \(animation.inAnimationDuration), \(animation.loopAnimationTemplateId), \(animation.loopAnimationDuration), \(animation.outAnimationTemplateId), \(animation.outAnimationDuration),\(animation.templateID))"

           
                   
                    insertedRowId = insertNewEntry(query: query)
              

        return Int(insertedRowId)
    }

    func replaceMusicInfoRowIfNeeded(musicDbModel: MusicInfo) -> Int {
        var insertedRowId: Int = -1
        
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(MUSIC_TYPE), \(NAME), \(MUSIC_PATH), \(PARENT_ID), \(PARENT_TYPE), \(START_TIME), \(END_TIME_OF_AUDIO), \(DURATION),\(TEMPLATE_ID)) VALUES ('\(musicDbModel.musicType)', '\(musicDbModel.name)', '\(musicDbModel.musicPath)', \(musicDbModel.parentID), \(musicDbModel.parentType), \(musicDbModel.startTimeOfAudio), \(musicDbModel.endTimeOfAudio), \(musicDbModel.duration),\(musicDbModel.templateID))"
        insertedRowId = insertNewEntry(query: query)
            
        return Int(insertedRowId)
    }
    
    // Insert query for RATIO_MODEL table
    func replaceRatioModelIfNeeded(ratioDBModel: DBRatioTableModel) -> Int {
        let query = "INSERT INTO RATIO_MODEL (CATEGORY, CATEGORY_DESCRIPTION, IMAGE_RES_ID, RATIO_WIDTH, RATIO_HEIGHT, OUTPUT_WIDTH, OUTPUT_HEIGHT, IS_PREMIUM) VALUES ('\(ratioDBModel.category)', '\(ratioDBModel.categoryDescription)', '\(ratioDBModel.imageResId)', '\(ratioDBModel.ratioWidth)', '\(ratioDBModel.ratioHeight)', '\(ratioDBModel.outputWidth)', '\(ratioDBModel.outputHeight)', '\(ratioDBModel.isPremium)')"
        return insertNewEntry(query: query)
    }
    
    // Insert or Replace the Category into the CATEGORY_MASTER table.
    func replaceCategoryRowIfNeeded(categoryInfo: CategoryInfo) {
        let query = """
            REPLACE INTO \(TABLE_CATEGORY) (
                CATEGORY_ID,
                CATEGORY_NAME,
                CATEGORY_THUMB_PATH,
                LAST_MODIFIED,
                CATEGORY_DATA_PATH,
                CAN_DELETE,
                IS_HEADER_DOWNLOADED
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
            """
            
        do {
            try database.executeUpdate(query, values: [
                categoryInfo.categoryId,
                categoryInfo.categoryName,
                categoryInfo.categoryThumbPath,
                categoryInfo.lastModified,
                categoryInfo.categoryDataPath,
                categoryInfo.canDelete,
                categoryInfo.isHeaderDownloaded
            ])
            print("CategoryInfo inserted successfully")
        } catch {
            print("Failed to insert CategoryInfo: \(error.localizedDescription)")
        }
    }

    
    //end of insertion
    
}
//MARK: -
extension DBManager{
    public func duplicateTemplate(templateID: Int, templateType: String, isSavedDesignDuplicate: Bool) -> Int {
        var insertedRowId: Int = -1
        NSLog("OpenGlTest In DesignDbHelper duplicateTemplate")
        
        // Fetch the template based on the templateID from the database
        var originalTemplate = getTemplate(templateId: templateID)
        
        originalTemplate?.category = "DRAFT"
        originalTemplate?.templateEventStatus = "UNPUBLISHED"
//        originalTemplate?.categoryTemp = "DRAFT"
        
        if isSavedDesignDuplicate{
            originalTemplate?.originalTemplate = 0
            originalTemplate?.eventId = -1
            // TODO: JM Discuss With Sharma - Done
            originalTemplate?.userId = -1
        }else{
            originalTemplate?.originalTemplate = templateID
        }
        
//        originalTemplate?.isDetailDownloaded = 0
        guard let originalTemplate = originalTemplate else {
            // Handle error or return if template not found
            return -1
        }
        
        // copy original model to new model
         
        var newModel = originalTemplate

       let newtempID = replaceTemplateRowIfNeeded(template: newModel)
        
        let createdAtDate = Date()
        // Create a DateFormatter
        let dateFormatter = DateFormatter()

        // Set the desired date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert Date to String
        let createdAtString = dateFormatter.string(from: createdAtDate)

        // Print the value
        print("Created At: \(createdAtString)")
        
        _ = DBManager.shared.updateTemplateCreatedDate(templateId: newtempID, newValue: createdAtString)
        
        insertedRowId = newtempID
        
       var musicInfo = getMusicInfo(templateID: templateID)
        musicInfo?.templateID = newtempID
        if let musicInfo = musicInfo{
            let newMusicID = replaceMusicInfoRowIfNeeded(musicDbModel: musicInfo)
        }

        if templateType == "NonDraft"{
            let filename = "thumbnail_template_\(originalTemplate.serverTemplateId).png"
            
            let filenameLocal = "thumbnail_template_\(newtempID).png"
            do{
                let fileManager = FileManager.default
                
                guard let templateThumbnails = logger?.getThumnailPath() else{
                    throw logger!.documentsDirectoryNotFound()
                }
                
                guard let myDesignsPath = logger?.getMyDesignsPath() else{
                    throw logger!.documentsDirectoryNotFound()
                }
                
                let sourceURL = templateThumbnails.appendingPathComponent(filename)
                
                let destinationURL = myDesignsPath.appendingPathComponent(filenameLocal)
                
                if fileManager.fileExists(atPath: destinationURL.path) {
                    print("File already exists at the destination.")
                } else {
                    // Copy the file
                    try fileManager.copyItem(at: sourceURL, to: destinationURL)
                    print("File copied successfully to \(destinationURL.path).")
                }
                                
            }catch{
                print("Error copying file: \(error.localizedDescription)")
            }
        }else{
            let filename = "thumbnail_template_\(originalTemplate.templateId).png"
            
            let filenameLocal = "thumbnail_template_\(newtempID).png"
            do{
                let fileManager = FileManager.default
                
                guard let myDesignsPath = logger?.getMyDesignsPath() else{
                    throw logger!.documentsDirectoryNotFound()
                }
                
                
                let sourceURL = myDesignsPath.appendingPathComponent(filename)
                
                let destinationURL = myDesignsPath.appendingPathComponent(filenameLocal)
                
                if fileManager.fileExists(atPath: destinationURL.path) {
                    print("File already exists at the destination.")
                } else {
                    // Copy the file
                    try fileManager.copyItem(at: sourceURL, to: destinationURL)
                    print("File copied successfully to \(destinationURL.path).")
                }
                                
            }catch{
                print("Error copying file: \(error.localizedDescription)")
            }
            
        }
        
        
//        let filename1 = "thumbnail_template_\(originalTemplate.templateId).png" //ImageDownloadManager.getFilenameFromURL(urlString: originalTemplate.thumbServerPath)
////        if filename != nil{
//            do {
//                let fileManager = FileManager.default
//                
//                guard let documentsDirectory = AppFileManager.shared.myDesigns?.url/*FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first*/ else {
//                    throw SaveImageError.documentsDirectoryNotFound
//                }
//                // The source file URL (original file location)
//                let sourceURL = documentsDirectory.appendingPathComponent(filename) //URL(fileURLWithPath: originalTemplate.thumbServerPath)
//                
//                // The destination file URL (where you want to copy the file)
//                let destinationPath = sourceURL.deletingLastPathComponent().appendingPathComponent("thumbnail_template_\(newtempID).jpg").path
//                
//                let destinationURL = URL(fileURLWithPath: destinationPath)
//                
//                // Check if the file already exists at the destination
//                if fileManager.fileExists(atPath: destinationURL.path) {
//                    print("File already exists at the destination.")
//                } else {
//                    // Copy the file
//                    try fileManager.copyItem(at: sourceURL, to: destinationURL)
//                    print("File copied successfully to \(destinationURL.path).")
//                }
//            } catch {
//                // Handle any errors during the copy process
//                print("Error copying file: \(error.localizedDescription)")
//            }
                        
//        }
        
     print("newID",newtempID)
        
        // get all pages for template
        let pages = getActivePagesList(templateId: templateID)
        // extract page on by one and for every page
        for page in pages {
            // extract page from base model table and chnage its template and parent id from new id
         
            // if background exist and type is image
            // extract image model for temp id and chnage its parent ID with new temp ID
            // if overlay exist for baseModel then extrect imageModel for that tempID and replace its parentID with new Temp ID
            _ = duplicatePage(page: page, newtempID: newtempID)

        }
     
        
        return insertedRowId
    }
    
    
    func duplicateImage(imageID:Int,templateID:Int)->Int{
        if imageID == -1{
            return -1
        }
        // get originalImageModel
        if let originalImageModel = getImage(imageId: imageID){
            var newImageModel = originalImageModel
            newImageModel.templateID = templateID
           return replaceImageRowIfNeeded(image: newImageModel)
        }
        return -1
    }
    
    func duplicateText(textID:Int,templateID:Int,newModel:inout DBBaseModel,currentTime:Float = 0.0,order:Int = 0)->Int{
        if textID == -1{
            return -1
        }
        // get originalImageModel
        if let originalTextModel = getTextModel(textId: textID){
            var newTextModel = originalTextModel
            newTextModel.templateID = templateID
            newModel.dataId = replaceTextModelIfNeeded(textDbModel: newTextModel)
            newModel.startTime += Double(currentTime)
            return  replaceBaseModelIfNeeded(baseModel: newModel)
        }
        return -1
    }

    func duplicateSticker(stickerID:Int,templateID:Int,newModel:inout DBBaseModel,currentTime:Float = 0.0,order:Int = 0)->Int{
        if stickerID == -1{
            return -1
        }
        // get originalImageModel
        if let originalStickerModel = getStickerModel(stickerId: stickerID){
            var newStickerModel = originalStickerModel
            let imageModelID = duplicateImage(imageID: newStickerModel.imageId, templateID: templateID)
            newStickerModel.imageId = imageModelID
            newStickerModel.templateID = templateID
            let newStickerID = replaceStickerRowIfNeeded(stickerDbModel: newStickerModel)
            newModel.dataId = newStickerID
            newModel.startTime += Double(currentTime)
            
            
           return replaceBaseModelIfNeeded(baseModel: newModel)
        }
        return -1
    }

    func duplicateParent(parentID:Int,NewParentID:Int,newTemplateId:Int)->Int{
        let originalParentModels = getChildAndParentModelListOfParent(parentId: parentID)
        var animationModel = getAnimation(modelId: parentID)
        animationModel.modelId = NewParentID
        animationModel.templateID = newTemplateId
        _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
        
        
        for model in originalParentModels{
            
            var newModel = model
            newModel.parentId = NewParentID
            newModel.templateID = newTemplateId
//            newModel.startTime += Double(currentTime)
//            newModel.orderInParent = order ?? 0
            
            if model.modelType == "IMAGE"{
             
                let newStickerID = duplicateSticker(stickerID: newModel.dataId, templateID: newTemplateId, newModel: &newModel)
                var animationModel = getAnimation(modelId: model.modelId)
                animationModel.templateID = newTemplateId
                animationModel.modelId = newStickerID
                _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
             
                // animation in sticker
                
            }else if model.modelType == "TEXT"{
                // text Model added 1
                let newTextID = duplicateText(textID: model.dataId, templateID: newTemplateId, newModel: &newModel)
                var animationModel = getAnimation(modelId: model.modelId)
                animationModel.templateID = newTemplateId
                animationModel.modelId = newTextID
                _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
               
            }else if model.modelType == "PARENT"{
              
                let newParentId = replaceBaseModelIfNeeded(baseModel: newModel)
                let newParentID = duplicateParent(parentID: model.modelId, NewParentID: newParentId, newTemplateId:newTemplateId)
        
//                newModel.dataId = newParentID
//                 replaceBaseModelIfNeeded(baseModel: newModel)
               // duplicateAnimation(modelID: model.geta, templateID: <#T##Int#>)
                // animation Duplicate remain
                
            }
        }
        
        return -1
    }
    
    
    func duplicateSingleParent(modelID:Int)->DBBaseModel?{
        if var parent = getBaseModelFromDB(modelId: modelID){
            parent.orderInParent += 1
            parent.posX = parent.posX + 0.01
            parent.posY = parent.posY
            + 0.01
            let newParentID = replaceBaseModelIfNeeded(baseModel: parent)
            _ = duplicateParent(parentID: modelID, NewParentID: newParentID, newTemplateId: parent.templateID)
            parent.modelId = newParentID
            return parent
        }else{
            logger?.printLog("parent not found")
        }
        return nil
    }
    
    func duplicateSingleParent(modelID:Int, parentId : Int , order : Int,startTime: Double, duration: Double, isDuplicate : Bool = true)->DBBaseModel?{
        if var parent = getBaseModelFromDB(modelId: modelID){
            parent.orderInParent = order
            parent.parentId = parentId
            parent.startTime = startTime
            parent.duration = duration
            parent.posX = 0.5
            parent.posY = 0.5
            let newParentID = replaceBaseModelIfNeeded(baseModel: parent)
            _ = duplicateParent(parentID: modelID, NewParentID: newParentID, newTemplateId: parent.templateID)
            parent.modelId = newParentID
            return parent
        }else{
            logger?.printLog("parent not found")
        }
        return nil
    }
    
    
//    func duplicateParentInParent(parentID:Int,tempID:Int,baseModel:inout DBBaseModel){
    
    func duplicatePage(page:DBBaseModel,newtempID:Int,currentTime:Float = 0.0,order:Int = 0)->Int{
        
        var duplicatePage = page
        let oldTime = duplicatePage.startTime
        duplicatePage.parentId = newtempID
        duplicatePage.templateID = newtempID
        duplicatePage.startTime = Double(currentTime)
        duplicatePage.orderInParent = order
        let newbgImageID = duplicateImage(imageID: page.dataId, templateID: newtempID)
        // change bgImage ID
        duplicatePage.dataId = newbgImageID
        let newOverlayID = duplicateImage(imageID: page.overlayDataId, templateID: newtempID)
        // chnage overlayID
        duplicatePage.overlayDataId = newOverlayID
        
        let newPageID = replaceBaseModelIfNeeded(baseModel: duplicatePage)
        
//        var animationModel = getAnimation(modelId: page.modelId)
//        animationModel.templateID = newtempID
//        animationModel.modelId = newPageID
//        _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
        
        _ = duplicateParent(parentID: page.modelId, NewParentID: newPageID, newTemplateId: newtempID)
        
        
        return newPageID
    }
    
    func duplicateBaseModel(templateID:Int){
        
    }
    
    
    func duplicateAnimation(modelID:Int,templateID:Int){
        var animationModel = getAnimation(modelId: modelID)
        animationModel.templateID = templateID
        let animationID = replaceAnimationRowIfNeeded(animation: animationModel)
        
    }
    
    
    func duplicateMusicInfo(templateID:Int){
        
    }
    
    
}


//Method for replacing or inserting the values of columns in the Model Table.
extension DBManager{
    func replaceModelType(modelType: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(MODEL_TYPE)) VALUES ('\(modelType)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceDataId(dataId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(DATA_ID)) VALUES ('\(dataId)')"
        return insertNewEntry(query: query) != -1
    }

    func replacePosX(posX: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(POS_X)) VALUES ('\(posX)')"
        return insertNewEntry(query: query) != -1
    }

    func replacePosY(posY: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(POS_Y)) VALUES ('\(posY)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceWidth(width: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(WIDTH)) VALUES ('\(width)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceHeight(height: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(HEIGHT)) VALUES ('\(height)')"
        return insertNewEntry(query: query) != -1
    }

    func replacePrevAvailableWidth(prevAvailableWidth: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(PREV_AVAILABLE_WIDTH)) VALUES ('\(prevAvailableWidth)')"
        return insertNewEntry(query: query) != -1
    }

    func replacePrevAvailableHeight(prevAvailableHeight: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(PREV_AVAILABLE_HEIGHT)) VALUES ('\(prevAvailableHeight)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRotation(rotation: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(ROTATION)) VALUES ('\(rotation)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceModelOpacity(modelOpacity: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(MODEL_OPACITY)) VALUES ('\(modelOpacity)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceModelFlipHorizontal(modelFlipHorizontal: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(MODEL_FLIP_HORIZONTAL)) VALUES ('\(modelFlipHorizontal)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceModelFlipVertical(modelFlipVertical: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(MODEL_FLIP_VERTICAL)) VALUES ('\(modelFlipVertical)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceLockStatus(lockStatus: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(LOCK_STATUS)) VALUES ('\(lockStatus)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceOrderInParent(orderInParent: Int, modelID : Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(ORDER_IN_PARENT)) VALUES ('\(orderInParent)') WHERE (\(MODEL_ID) = (\(modelID)))"
        return insertNewEntry(query: query) != -1
    }

    func replaceParentId(parentId: String?) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(PARENT_ID)) VALUES ('\(parentId ?? "")')"
        return insertNewEntry(query: query) != -1
    }

    func replaceBgBlurProgress(bgBlurProgress: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(BG_BLUR_PROGRESS)) VALUES ('\(bgBlurProgress)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceOverlayDataId(overlayDataId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(OVERLAY_DATA_ID)) VALUES ('\(overlayDataId)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceOverlayOpacity(overlayOpacity: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(OVERLAY_OPACITY)) VALUES ('\(overlayOpacity)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStartTime(startTime: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(START_TIME)) VALUES ('\(startTime)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceDuration(duration: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(DURATION)) VALUES ('\(duration)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceSoftDelete(softDelete: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(SOFT_DELETE)) VALUES ('\(softDelete)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateId(templateId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_BASEMODEL) (\(TEMPLATE_ID)) VALUES ('\(templateId)')"
        return insertNewEntry(query: query) != -1
    }

}


//Method for replacing or inserting the values of columns in the Template Table.
extension DBManager{
    func replaceTemplateName(templateName: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(TEMPLATE_NAME)) VALUES ('\(templateName)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateCategory(category: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(CATEGORY)) VALUES ('\(category)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateRatioId(ratioId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(RATIO_ID)) VALUES ('\(ratioId)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateThumbServerPath(thumbServerPath: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(THUMB_SERVER_PATH)) VALUES ('\(thumbServerPath)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateThumbLocalPath(thumbLocalPath: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(THUMB_LOCAL_PATH)) VALUES ('\(thumbLocalPath)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateThumbTime(thumbTime: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(THUMB_TIME)) VALUES ('\(thumbTime)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateTotalDuration(totalDuration: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(TOTAL_DURATION)) VALUES ('\(totalDuration)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateSequence(sequence: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(SEQUENCE)) VALUES ('\(sequence)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateIsPremium(isPremium: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(IS_PREMIUM)) VALUES ('\(isPremium)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateCategoryTemp(categoryTemp: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(CATEGORY_TEMP)) VALUES ('\(categoryTemp)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateDataPath(dataPath: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(DATA_PATH)) VALUES ('\(dataPath)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateServerTemplateId(serverTemplateId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEMPLATE) (\(SERVER_TEMPLATE_ID)) VALUES ('\(serverTemplateId)')"
        return insertNewEntry(query: query) != -1
    }

}

//Method for replacing or inserting the values of columns in the Template Meta Data Table.
extension DBManager{
    func replaceTemplateMetaDataFieldId(fieldId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_CATEGORY_METADATA) (\(FIELD_ID)) VALUES ('\(fieldId)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateMetaDataFieldDisplayName(fieldDisplayName: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_CATEGORY_METADATA) (\(FIELD_DISPLAY_NAME)) VALUES ('\(fieldDisplayName)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateMetaDataTemplateValue(templateValue: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_CATEGORY_METADATA) (\(TEMPLATE_VALUE)) VALUES ('\(templateValue)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateMetaDataCategoryName(categoryName: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_CATEGORY_METADATA) (\(CATEGORY_NAME)) VALUES ('\(categoryName)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTemplateMetaDataSeq(seq: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_CATEGORY_METADATA) (\(SEQ)) VALUES ('\(seq)')"
        return insertNewEntry(query: query) != -1
    }

}


//Method for replacing or inserting the values of columns in the Image Table.
extension DBManager{
    func replaceImageType(imageType: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(IMAGE_TYPE)) VALUES ('\(imageType)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageServerPath(serverPath: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(SERVER_PATH)) VALUES ('\(serverPath)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageLocalPath(localPath: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(LOCAL_PATH)) VALUES ('\(localPath)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageResID(resID: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(RES_ID)) VALUES ('\(resID)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageIsEncrypted(isEncrypted: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(IS_ENCRYPTED)) VALUES ('\(isEncrypted)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageCropX(cropX: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(CROP_X)) VALUES ('\(cropX)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageCropY(cropY: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(CROP_Y)) VALUES ('\(cropY)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageCropW(cropW: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(CROP_W)) VALUES ('\(cropW)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageCropH(cropH: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(CROP_H)) VALUES ('\(cropH)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageCropStyle(cropStyle: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(CROP_STYLE)) VALUES ('\(cropStyle)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageTileMultiple(tileMultiple: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(TILE_MULTIPLE)) VALUES ('\(tileMultiple)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageColorInfo(colorInfo: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(COLOR_INFO)) VALUES ('\(colorInfo)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageWidth(imageWidth: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(IMAGE_WIDTH)) VALUES ('\(imageWidth)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageHeight(imageHeight: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(IMAGE_HEIGHT)) VALUES ('\(imageHeight)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceImageTemplateID(templateID: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_IMAGE) (\(TEMPLATE_ID)) VALUES ('\(templateID)')"
        return insertNewEntry(query: query) != -1
    }

}


//Method for replacing or inserting the values of columns in the Sticker Table.
extension DBManager{
    func replaceStickerImageId(imageId: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(IMAGE_ID)) VALUES ('\(imageId)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerStickerType(stickerType: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(STICKER_TYPE)) VALUES ('\(stickerType)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerFilterType(stickerFilterType: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(STICKER_FILTER_TYPE)) VALUES ('\(stickerFilterType)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerStickerHue(stickerHue: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(STICKER_HUE)) VALUES ('\(stickerHue)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerStickerColor(stickerColor: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(STICKER_COLOR)) VALUES ('\(stickerColor)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerXRotationProg(xRotationProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(X_ROATATION_PROG)) VALUES ('\(xRotationProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerYRotationProg(yRotationProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(Y_ROATATION_PROG)) VALUES ('\(yRotationProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerZRotationProg(zRotationProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(Z_ROATATION_PROG)) VALUES ('\(zRotationProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceStickerTemplateID(templateID: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_STICKER) (\(TEMPLATE_ID)) VALUES ('\(templateID)')"
        return insertNewEntry(query: query) != -1
    }

}

//Method for replacing or inserting the values of columns in the Text Table.
extension DBManager{
    func replaceTextText(text: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(TEXT)) VALUES ('\(text)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextTextFont(textFont: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(TEXT_FONT)) VALUES ('\(textFont)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextTextColor(textColor: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(TEXT_COLOR)) VALUES ('\(textColor)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextTextGravity(textGravity: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(TEXT_GRAVITY)) VALUES ('\(textGravity)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextLineSpacing(lineSpacing: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(LINE_SPACING)) VALUES ('\(lineSpacing)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextLetterSpacing(letterSpacing: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(LETTER_SPACING)) VALUES ('\(letterSpacing)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextShadowColor(shadowColor: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(SHADOW_COLOR)) VALUES ('\(shadowColor)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextShadowOpacity(shadowOpacity: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(SHADOW_OPACITY)) VALUES ('\(shadowOpacity)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextShadowRadius(shadowRadius: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(SHADOW_RADIUS)) VALUES ('\(shadowRadius)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextShadowDx(shadowDx: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(SHADOW_Dx)) VALUES ('\(shadowDx)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextShadowDy(shadowDy: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(SHADOW_Dy)) VALUES ('\(shadowDy)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextBgType(bgType: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(BG_TYPE)) VALUES ('\(bgType)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextBgDrawable(bgDrawable: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(BG_DRAWABLE)) VALUES ('\(bgDrawable)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextBgColor(bgColor: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(BG_COLOR)) VALUES ('\(bgColor)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextBgAlpha(bgAlpha: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(BG_ALPHA)) VALUES ('\(bgAlpha)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextInternalHeightMargin(internalHeightMargin: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(INTERNAL_HEIGHT_MARGIN)) VALUES ('\(internalHeightMargin)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextInternalWidthMargin(internalWidthMargin: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(INTERNAL_WIDTH_MARGIN)) VALUES ('\(internalWidthMargin)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextXRotationProg(xRotationProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(X_ROATATION_PROG)) VALUES ('\(xRotationProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextYRotationProg(yRotationProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(Y_ROATATION_PROG)) VALUES ('\(yRotationProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextZRotationProg(zRotationProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(Z_ROATATION_PROG)) VALUES ('\(zRotationProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextCurveProg(curveProg: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(CURVE_PROG)) VALUES ('\(curveProg)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceTextTemplateID(templateID: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_TEXT_MODEL) (\(TEMPLATE_ID)) VALUES ('\(templateID)')"
        return insertNewEntry(query: query) != -1
    }
}


//Method for replacing or inserting the values of columns in the Animation Table.
extension DBManager{
    func replaceAnimationModelId(modelId: Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(MODEL_ID)) VALUES (\(modelId))"
        return insertNewEntry(query: query) != -1
    }

    func replaceAnimationInAnimationTemplateId(inAnimationTemplateId: Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(IN_ANIMATION_TEMPLATE_ID)) VALUES (\(inAnimationTemplateId))"
        return insertNewEntry(query: query) != -1
    }

    func replaceAnimationInAnimationDuration(inAnimationDuration: Double) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(IN_ANIMATION_DURATION)) VALUES (\(inAnimationDuration))"
        return insertNewEntry(query: query) != -1
    }

    func replaceAnimationLoopAnimationTemplateId(loopAnimationTemplateId: Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(LOOP_ANIMATION_TEMPLATE_ID)) VALUES (\(loopAnimationTemplateId))"
        return insertNewEntry(query: query) != -1
    }

    func replaceAnimationLoopAnimationDuration(loopAnimationDuration: Double) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(LOOP_ANIMATION_DURATION)) VALUES (\(loopAnimationDuration))"
        return insertNewEntry(query: query) != -1
    }

    func replaceAnimationOutAnimationTemplateId(outAnimationTemplateId: Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(OUT_ANIMATION_TEMPLATE_ID)) VALUES (\(outAnimationTemplateId))"
        return insertNewEntry(query: query) != -1
    }

    func replaceAnimationOutAnimationDuration(outAnimationDuration: Double) -> Bool {
        let query = "REPLACE INTO \(TABLE_ANIMATION) (\(OUT_ANIMATION_DURATION)) VALUES (\(outAnimationDuration))"
        return insertNewEntry(query: query) != -1
    }
}


//Method for replacing or inserting the values of columns in the Music Table.
extension DBManager{
    func replaceMusicMusicType(musicType: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(MUSIC_TYPE)) VALUES ('\(musicType)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicName(name: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(NAME)) VALUES ('\(name)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicMusicPath(musicPath: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(MUSIC_PATH)) VALUES ('\(musicPath)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicParentID(parentID: Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(PARENT_ID)) VALUES (\(parentID))"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicParentType(parentType: Int) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(PARENT_TYPE)) VALUES (\(parentType))"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicStartTimeOfAudio(startTimeOfAudio: Double) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(START_TIME)) VALUES (\(startTimeOfAudio))"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicEndTimeOfAudio(endTimeOfAudio: Double) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(END_TIME_OF_AUDIO)) VALUES (\(endTimeOfAudio))"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicDuration(duration: Double) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(DURATION)) VALUES (\(duration))"
        return insertNewEntry(query: query) != -1
    }

    func replaceMusicTemplateID(templateID: String) -> Bool {
        let query = "REPLACE INTO \(TABLE_MUSICINFO) (\(TEMPLATE_ID)) VALUES ('\(templateID)')"
        return insertNewEntry(query: query) != -1
    }
}


//Method for replacing or inserting the values of columns in the Ratio Table.
extension DBManager{
    func replaceRatioCategory(category: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (CATEGORY) VALUES ('\(category)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioCategoryDescription(categoryDescription: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (CATEGORY_DESCRIPTION) VALUES ('\(categoryDescription)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioImageResId(imageResId: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (IMAGE_RES_ID) VALUES ('\(imageResId)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioRatioWidth(ratioWidth: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (RATIO_WIDTH) VALUES ('\(ratioWidth)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioRatioHeight(ratioHeight: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (RATIO_HEIGHT) VALUES ('\(ratioHeight)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioOutputWidth(outputWidth: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (OUTPUT_WIDTH) VALUES ('\(outputWidth)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioOutputHeight(outputHeight: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (OUTPUT_HEIGHT) VALUES ('\(outputHeight)')"
        return insertNewEntry(query: query) != -1
    }

    func replaceRatioIsPremium(isPremium: String) -> Bool {
        let query = "REPLACE INTO RATIO_MODEL (IS_PREMIUM) VALUES ('\(isPremium)')"
        return insertNewEntry(query: query) != -1
    }

}





//MARK: -
extension DBManager{
    func duplicateTemplate(templateInfo: TemplateInfo, templateType: String) -> Int {
        var insertedRowId: Int = -1
        NSLog("OpenGlTest In DesignDbHelper duplicateTemplate")
        
        // Fetch the template based on the templateID from the database
        var originalTemplate = templateInfo.getDBTemplateModel()//getTemplate(templateId: templateID)
        
        if templateType == "SAVED"{
            originalTemplate.category = "SAVED"
        }else{
            originalTemplate.category = "DRAFT"
        }
//        originalTemplate.categoryTemp = "DRAFT"
        
        originalTemplate.templateEventStatus = "UNPUBLISHED"
        
        let newModel = originalTemplate
        
        let newtempID = replaceTemplateRowIfNeeded(template: newModel)
        
        let createdAtDate = Date()
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        
        // Set the desired date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Convert Date to String
        let createdAtString = dateFormatter.string(from: createdAtDate)
        
        // Print the value
        print("Created At: \(createdAtString)")
        
        _ = DBManager.shared.updateTemplateCreatedDate(templateId: newtempID, newValue: createdAtString)
        
        insertedRowId = newtempID
        
        var musicInfo = getMusicInfo(templateID: originalTemplate.templateId)
        musicInfo?.templateID = newtempID
        if let musicInfo = musicInfo{
            let newMusicID = replaceMusicInfoRowIfNeeded(musicDbModel: musicInfo)
        }
        
        if templateType == "NonDraft"{
            let filename = "thumbnail_template_\(originalTemplate.serverTemplateId).png"
            
            let filenameLocal = "thumbnail_template_\(newtempID).png"
            do{
                let fileManager = FileManager.default
                
                guard let templateThumbnails = logger?.getThumnailPath() else{
                    throw logger!.documentsDirectoryNotFound()
                }
                
                guard let myDesignsPath = logger?.getMyDesignsPath() else{
                    throw logger!.documentsDirectoryNotFound()
                }
                
                let sourceURL = templateThumbnails.appendingPathComponent(filename)
                
                let destinationURL = myDesignsPath.appendingPathComponent(filenameLocal)
                
                if fileManager.fileExists(atPath: destinationURL.path) {
                    print("File already exists at the destination.")
                } else {
                    // Copy the file
                    try fileManager.copyItem(at: sourceURL, to: destinationURL)
                    print("File copied successfully to \(destinationURL.path).")
                }
            }catch{
                print("Error copying file: \(error.localizedDescription)")
            }
        }else{
            let filename = "thumbnail_template_\(originalTemplate.templateId).png"
            
            let filenameLocal = "thumbnail_template_\(newtempID).png"
            do{
                let fileManager = FileManager.default
                
                guard let myDesignsPath = logger?.getMyDesignsPath() else{
                    throw logger!.documentsDirectoryNotFound()
                }
                
                
                let sourceURL = myDesignsPath.appendingPathComponent(filename)
                
                let destinationURL = myDesignsPath.appendingPathComponent(filenameLocal)
                
                if fileManager.fileExists(atPath: destinationURL.path) {
                    print("File already exists at the destination.")
                } else {
                    // Copy the file
                    try fileManager.copyItem(at: sourceURL, to: destinationURL)
                    print("File copied successfully to \(destinationURL.path).")
                }
            }catch{
                print("Error copying file: \(error.localizedDescription)")
            }
        }
        print("newID",newtempID)
        
        // get all pages for template
        let pages = templateInfo.pageInfo
        // extract page on by one and for every page
        for page in pages {
            _ = duplicatePageTemplate(page: page, newtempID: newtempID)
            
        }
        
        
        return insertedRowId
    }
    
    
    func duplicatePageTemplate(page:PageInfo,newtempID:Int,currentTime:Float = 0.0,order:Int = 0)->Int{
        
        var duplicatePage = page.getBaseModel(refSize: logger!.getBaseSize())
        let oldTime = duplicatePage.startTime
        duplicatePage.parentId = newtempID
        duplicatePage.templateID = newtempID
        duplicatePage.startTime = Double(currentTime)
        duplicatePage.orderInParent = order
        let newbgImageID = duplicateImage(imageID: page.dataId, templateID: newtempID)
        // change bgImage ID
        duplicatePage.dataId = newbgImageID
        let newOverlayID = duplicateImage(imageID: page.overlayDataId, templateID: newtempID)
        // chnage overlayID
        duplicatePage.overlayDataId = newOverlayID
        
        let newPageID = replaceBaseModelIfNeeded(baseModel: duplicatePage)
        _ = duplicateParentTemplate(page: page, NewParentID: newPageID, newTemplateId: newtempID)
        
        
        return newPageID
    }
    
    func duplicateParentTemplate(page : PageInfo,NewParentID:Int,newTemplateId:Int)->Int{
        let originalParentModels = page.children
        var animationModel = page.getAnimation()
        animationModel.modelId = NewParentID
        animationModel.templateID = newTemplateId
        _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
        
        
        for model in originalParentModels{
            
            var newModel = model
            newModel.parentId = NewParentID
            newModel.templateID = newTemplateId
            if model.modelType.rawValue == "IMAGE"{
                let stickerModel = (newModel as? StickerInfo)!
                let dbImageModel = stickerModel.getDBImageModel()
                var dbBaseModel = stickerModel.getBaseModel(refSize: page.baseFrame.size)
                let newStickerID = duplicateStickerTemplate(dbStickerModel: stickerModel.getStickerModel(), templateID: newTemplateId, newModel: &dbBaseModel, dbImageModel: dbImageModel)
                var animationModel = getAnimation(modelId: model.modelId)
                animationModel.templateID = newTemplateId
                animationModel.modelId = newStickerID
                _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
            }else if model.modelType.rawValue == "TEXT"{
                let textModel = (newModel as? TextInfo)!
                let dbTextModel = textModel.getTextModel()
                var dbBaseModel = textModel.getBaseModel(refSize: page.baseFrame.size)
                let newTextID = duplicateTextTemplate(dbTextModel: dbTextModel, templateID: newTemplateId, newModel: &dbBaseModel)
                var animationModel = getAnimation(modelId: model.modelId)
                animationModel.templateID = newTemplateId
                animationModel.modelId = newTextID
                _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
               
            }else if model.modelType.rawValue == "PARENT"{
                let parentModel = (newModel as? ParentInfo)!
                var dbBaseModel = parentModel.getBaseModel(refSize: page.baseFrame.size)
                let newParentId = replaceBaseModelIfNeeded(baseModel: dbBaseModel)
                let newParentID = duplicateParentTemplate(dbParentModel: parentModel, NewParentID: newParentId, newTemplateId:newTemplateId)
            }
        }
        
        return -1
    }
    
    func duplicateImageTemplate(dbImageModel: DBImageModel,templateID:Int)->Int{
        // get originalImageModel
        let originalImageModel = dbImageModel
        var newImageModel = originalImageModel
        newImageModel.templateID = templateID
        return replaceImageRowIfNeeded(image: newImageModel)
    }
    
    
    func duplicateStickerTemplate(dbStickerModel:DBStickerModel,templateID:Int,newModel:inout DBBaseModel,currentTime:Float = 0.0,order:Int = 0, dbImageModel : DBImageModel)->Int{
        // get originalImageModel
         let originalStickerModel = dbStickerModel
        var newStickerModel = originalStickerModel
        let imageModelID = duplicateImageTemplate(dbImageModel: dbImageModel, templateID: templateID)
        newStickerModel.imageId = imageModelID
        newStickerModel.templateID = templateID
        let newStickerID = replaceStickerRowIfNeeded(stickerDbModel: newStickerModel)
        newModel.dataId = newStickerID
        newModel.startTime += Double(currentTime)
            
            
           return replaceBaseModelIfNeeded(baseModel: newModel)
        return -1
    }
    
    
    func duplicateTextTemplate(dbTextModel: DBTextModel,templateID:Int,newModel:inout DBBaseModel,currentTime:Float = 0.0,order:Int = 0)->Int{
        let originalTextModel = dbTextModel
        var newTextModel = originalTextModel
        newTextModel.templateID = templateID
        newModel.dataId = replaceTextModelIfNeeded(textDbModel: newTextModel)
        newModel.startTime += Double(currentTime)
        return  replaceBaseModelIfNeeded(baseModel: newModel)
    }
    
    func duplicateParentTemplate(dbParentModel : ParentInfo,NewParentID:Int,newTemplateId:Int)->Int{
        let originalParentModels = dbParentModel.children//getChildAndParentModelListOfParent(parentId: parentID)
        var animationModel = dbParentModel.getAnimation()//getAnimation(modelId: parentID)
        animationModel.modelId = NewParentID
        animationModel.templateID = newTemplateId
        _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
        
        
        for model in originalParentModels{
            
            var newModel = model
            newModel.parentId = NewParentID
            newModel.templateID = newTemplateId
//            newModel.startTime += Double(currentTime)
//            newModel.orderInParent = order ?? 0
            
            if model.modelType.rawValue == "IMAGE"{
                let stickerModel = (newModel as? StickerInfo)!
                let dbImageModel = stickerModel.getDBImageModel()
                var dbBaseModel = stickerModel.getBaseModel(refSize: dbParentModel.baseFrame.size)
                let newStickerID = duplicateStickerTemplate(dbStickerModel: stickerModel.getStickerModel(), templateID: newTemplateId, newModel: &dbBaseModel, dbImageModel: dbImageModel)
                var animationModel = getAnimation(modelId: model.modelId)
                animationModel.templateID = newTemplateId
                animationModel.modelId = newStickerID
                _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
             
                // animation in sticker
                
            }else if model.modelType.rawValue == "TEXT"{
                let textModel = (newModel as? TextInfo)!
                let dbTextModel = textModel.getTextModel()
                var dbBaseModel = textModel.getBaseModel(refSize: dbParentModel.baseFrame.size)
                let newTextID = duplicateTextTemplate(dbTextModel: dbTextModel, templateID: newTemplateId, newModel: &dbBaseModel)
                animationModel.templateID = newTemplateId
                animationModel.modelId = newTextID
                _ = DBMediator.shared.updateAnimationModel(animationModel: animationModel)
               
            }else if model.modelType.rawValue == "PARENT"{
                let parentModel = (newModel as? ParentInfo)!
                var dbBaseModel = parentModel.getBaseModel(refSize: dbParentModel.baseFrame.size)
                let newParentId = replaceBaseModelIfNeeded(baseModel: dbBaseModel)
                let newParentID = duplicateParentTemplate(dbParentModel: parentModel, NewParentID: newParentId, newTemplateId:newTemplateId)
        
//                newModel.dataId = newParentID
//                 replaceBaseModelIfNeeded(baseModel: newModel)
               // duplicateAnimation(modelID: model.geta, templateID: <#T##Int#>)
                // animation Duplicate remain
                
            }
        }
        
        return -1
    }

}
