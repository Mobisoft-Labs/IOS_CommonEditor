//
//  DBmanager+Update.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 21/07/23.
//

import Foundation


extension DBManager{
    
    
    //NK*
    func updateTemplateThumbTime(templateId : Int , thumbTime : Double){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(THUMB_TIME) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [thumbTime, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateOutputType(templateId : Int , outputType : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(OUTPUT_TYPE) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [outputType, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    public func updateTemplateValues(templateId : Int , thumbTime : Double , totalDuration : Double , createdAt: String , updatedAt : String ){
//        let query = "UPDATE \(TABLE_TEMPLATE) SET \(UPDATED_AT) = ? WHERE \(TEMPLATE_ID) = ?"

        let query = "UPDATE \(TABLE_TEMPLATE) SET \(TOTAL_DURATION) = ? , \(THUMB_TIME) = ? , \(CREATED_AT) = ?, \(UPDATED_AT) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [ totalDuration,thumbTime,createdAt,updatedAt, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            DBManager.logger?.logError("Failed to update thumb time in db.")
        }
    }
    
    public func updateTemplateRatio(templateId: Int, templateRatioId: Int) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_TEMPLATE) SET \(RATIO_ID) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [templateRatioId, templateId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    
    func updateTemplateCategoryAndThumbPath(templateId: Int, category: String?, thumbPath: String?, sequence: Int) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_TEMPLATE) SET \(CATEGORY) = ?, \(THUMB_LOCAL_PATH) = ?, \(SEQUENCE) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [category as Any, thumbPath as Any, sequence, templateId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    
    
   

    func updateTemplateThumbPath(templateId: Int, thumbPath: String) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_TEMPLATE) SET \(THUMB_LOCAL_PATH) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [thumbPath, templateId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }

    func updateImageLocalPath(currentPath: String, newPath: String) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_IMAGE) SET \(LOCAL_PATH) = ? WHERE \(LOCAL_PATH) = ?"
        let values: [Any] = [newPath, currentPath]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    
    func updateImageLocalPath(imageId: Int, newPath: String) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_IMAGE) SET \(LOCAL_PATH) = ? WHERE \(IMAGE_ID) = ?"
        let values: [Any] = [newPath, imageId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
        
       
        
    }

    
    func updateImageModel(from imageModel:ImageModel,imageID:Int){
        // hk todo
        let query = "UPDATE \(TABLE_IMAGE) SET \(LOCAL_PATH) = ?,\(CROP_X) = ?,\(CROP_Y) = ?,\(CROP_W) = ?,\(CROP_H) = ?,\(SERVER_PATH) = ?,\(IMAGE_TYPE) = ?,\(SOURCE_TYPE) = ?,\(TILE_MULTIPLE) = ?, \(CROP_STYLE) = ? WHERE \(IMAGE_ID) = ?"
        let values: [Any] = [imageModel.localPath,imageModel.cropRect.minX,imageModel.cropRect.minY,imageModel.cropRect.width,imageModel.cropRect.height,imageModel.serverPath,imageModel.imageType.rawValue,imageModel.sourceType.rawValue,imageModel.tileMultiple, imageModel.cropType.rawValue,imageID]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
        
        
    }
    
    func updateMusicLocalPath(currentPath: String, newPath: String) throws {

        let query = "UPDATE \(TABLE_MUSICINFO) SET \(MUSIC_PATH) = ? WHERE \(MUSIC_PATH) = ?"
        let values: [Any] = [newPath, currentPath]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    
    func updateAnimationName(modelId: Int, animationType: AnimeType, animationTemplateId: Int) throws {
        let animationTemplateColumnName: String
        switch animationType {
        case .In:
            animationTemplateColumnName = IN_ANIMATION_TEMPLATE_ID
        case .Out:
            animationTemplateColumnName = OUT_ANIMATION_TEMPLATE_ID
        case .Loop:
            animationTemplateColumnName = LOOP_ANIMATION_TEMPLATE_ID
        }

        let query = "UPDATE TABLE_ANIMATION SET \(animationTemplateColumnName) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [animationTemplateId, modelId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }

    func updateAnimationDuration(modelId: Int, animationType: AnimeType, animationDuration: Float) throws {
        let animationDurationColumnName: String
        switch animationType {
        case .In:
            animationDurationColumnName = IN_ANIMATION_DURATION
        case .Out:
            animationDurationColumnName = OUT_ANIMATION_DURATION
        case .Loop:
            animationDurationColumnName = LOOP_ANIMATION_DURATION
        }

        let query = "UPDATE TABLE_ANIMATION SET \(animationDurationColumnName) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [animationDuration, modelId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }

    func changeChildIndex(parentId: Int, modelIndex: Int, isIncreasing: Bool) throws -> Bool {
        return try updateChildIndex(parentId: parentId, modelIndex: modelIndex, isIncreasing: isIncreasing, isPage: false)
    }

    func changePageIndex(parentId: Int, modelIndex: Int, isIncreasing: Bool) throws -> Bool {
        return try updateChildIndex(parentId: parentId, modelIndex: modelIndex, isIncreasing: isIncreasing, isPage: true)
    }

    func changeChildIndexInRange(parentId: Int, startIndex: Int, endIndex: Int, isIncreasing: Bool) throws -> Bool {
        return try updateChildIndexInRange(parentId: parentId, startIndex: startIndex, endIndex: endIndex, isIncreasing: isIncreasing, isPage: false)
    }

    func changePageIndexInRange(parentId: Int, startIndex: Int, endIndex: Int, isIncreasing: Bool) throws -> Bool {
        return try updateChildIndexInRange(parentId: parentId, startIndex: startIndex, endIndex: endIndex, isIncreasing: isIncreasing, isPage: true)
    }

    func setModelIndex(modelId: Int, modelIndex: Int) throws {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(ORDER_IN_PARENT) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [modelIndex, modelId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    
    func updateChildIndex(parentId: Int, modelIndex: Int, isIncreasing: Bool, isPage: Bool) throws -> Bool {
        let orderDeltaStr = isIncreasing ? "+1" : "-1"
        let pageComparison = isPage ? "==" : "!="

        let query = "UPDATE \(TABLE_BASEMODEL) SET \(ORDER_IN_PARENT) = \(ORDER_IN_PARENT) \(orderDeltaStr) WHERE \(ORDER_IN_PARENT) > ? AND \(SOFT_DELETE) = 0 AND \(PARENT_ID) = ? AND \(MODEL_TYPE) \(pageComparison) 'PAGE';"
        let values: [Any] = [modelIndex, parentId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }

        return true
    }

    
    func updateChildIndexInRange(parentId: Int, startIndex: Int, endIndex: Int, isIncreasing: Bool, isPage: Bool) throws -> Bool {
        let orderDeltaStr = isIncreasing ? "+1" : "-1"
        let pageComparison = isPage ? "==" : "!="

        let query = "UPDATE \(TABLE_BASEMODEL) SET \(ORDER_IN_PARENT) = \(ORDER_IN_PARENT) \(orderDeltaStr) WHERE \(ORDER_IN_PARENT) > ? AND \(ORDER_IN_PARENT) < ? AND \(SOFT_DELETE) = 0 AND \(PARENT_ID) = ? AND \(MODEL_TYPE) \(pageComparison) 'PAGE';"
        let values: [Any] = [startIndex, endIndex, parentId]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }

        return true
    }

    func updateUserValueInCategoryMetaModel(fieldId: Int, userValue: String) throws {
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(USER_VALUE) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [userValue, fieldId]

        do {
            try updateQuery(query, values: values)
            print("Successfully updated user Value")
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    func updateTemplateIsHeaderDownload(bool: Int, categoryID:Int) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_CATEGORY) SET \(IS_HEADER_DOWNLOADED) = ? WHERE \(CATEGORY_ID) = ?"
        let values: [Any] = [bool, categoryID]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
    
    public func updateTemplateIsDetailDownload(bool: Int, templateID:Int) throws {
        DBManager.logger?.printLog("In DesignDbHelper updateTemplateRow")

        let query = "UPDATE \(TABLE_TEMPLATE) SET \(IS_DETAILS_DOWNLOAD) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [bool, templateID]

        do {
            try updateQuery(query, values: values)
        } catch {
//            throw SwiftError.toast("Update Query Failed - \(error)")
        }
    }
}

//Update methods for updating the MODEL Table.
extension DBManager {
    func updateModelType(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(MODEL_TYPE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    

    func updateDataId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(DATA_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updatePosX(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(POS_X) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    func updateBaseFrame(modelId: Int, newValue: Frame,parentFrame:CGSize) -> Bool {
        
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(POS_X) = ? , \(POS_Y) = ?, \(WIDTH) = ?, \(HEIGHT) = ?, \(ROTATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue.center.x/parentFrame.width,newValue.center.y/parentFrame.height,newValue.size.width/parentFrame.width,newValue.size.height/parentFrame.height,newValue.rotation, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    func updateBaseFrame(modelId: Int, newValue: Frame,parentFrame:CGSize, newCenter : CGPoint) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(POS_X) = ? , \(POS_Y) = ?, \(WIDTH) = ?, \(HEIGHT) = ?, \(ROTATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newCenter.x,newCenter.y,newValue.size.width/parentFrame.width,newValue.size.height/parentFrame.height,newValue.rotation, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    func updateBaseFrameWithPrevious(modelId: Int, newValue: Frame,parentFrame:CGSize,previousWidth:CGFloat,previousHeight:CGFloat) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(POS_X) = ? , \(POS_Y) = ?, \(WIDTH) = ?, \(HEIGHT) = ?, \(PREV_AVAILABLE_WIDTH) = ?, \(PREV_AVAILABLE_HEIGHT) = ?, \(ROTATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue.center.x/parentFrame.width,newValue.center.y/parentFrame.height,newValue.size.width/parentFrame.width,newValue.size.height/parentFrame.height,previousWidth/parentFrame.width,previousHeight/parentFrame.height,newValue.rotation, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updatePosY(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(POS_Y) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateWidth(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(WIDTH) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateHeight(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(HEIGHT) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updatePrevAvailableWidth(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(PREV_AVAILABLE_WIDTH) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updatePrevAvailableHeight(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(PREV_AVAILABLE_HEIGHT) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateRotation(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(ROTATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateModelOpacity(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(MODEL_OPACITY) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateModelFlipHorizontal(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(MODEL_FLIP_HORIZONTAL) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateModelFlipVertical(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(MODEL_FLIP_VERTICAL) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateLockStatus(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(LOCK_STATUS) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateOrderInParent(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(ORDER_IN_PARENT) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    func updatePageStartTime(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(START_TIME) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateParentId(modelId: Int, newValue: Int?) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(PARENT_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue ?? "", modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMoveModelChild(moveModelData:MoveModelData, parentSize: CGSize)->Bool{
        // query to update the model
        // width and height must be calculated with respect to parentSize
        let width = moveModelData.baseFrame.size.width / parentSize.width
        let height = moveModelData.baseFrame.size.height / parentSize.height

        // posX and posY must be calculated with respect to parentSize
        let posX = moveModelData.baseFrame.center.x / parentSize.width
        let posY = moveModelData.baseFrame.center.y / parentSize.height

        // rotation should be directly taken from moveModelData
        let rotation = moveModelData.baseFrame.rotation

        
        let query = """
                UPDATE \(TABLE_BASEMODEL) SET
                \(PARENT_ID) = ?,
                \(ORDER_IN_PARENT) = ?,
                \(POS_X) = ?,
                \(POS_Y) = ?,
                \(WIDTH) = ?,
                \(HEIGHT) = ?,
                \(ROTATION) = ?,
                \(MODEL_FLIP_HORIZONTAL) = ?,
                \(MODEL_FLIP_VERTICAL) = ?,
                \(START_TIME) = ?,
                \(DURATION) = ?
                WHERE \(MODEL_ID) = ?
                """
        let values: [Any] = [moveModelData.parentID,moveModelData.orderInParent,posX,posY,width,height,rotation,moveModelData.hFlip,moveModelData.vFlip,moveModelData.baseTime.startTime,moveModelData.baseTime.duration,moveModelData.modelID]

        do {
            try updateQuery(query, values: values)
            DBManager.logger?.printLog("moveModel Data update")
            return true
        } catch {
            return false
        }
    }
    
    
    func updateForChild(childValue:ChildBaseFrameAndTime,parentSize:CGSize){
        // width and height must be calculated with respect to parentSize
        let width = childValue.BaseFrame.size.width / parentSize.width
        let height = childValue.BaseFrame.size.height / parentSize.height

        // posX and posY must be calculated with respect to parentSize
        let posX = childValue.BaseFrame.center.x / parentSize.width
        let posY = childValue.BaseFrame.center.y / parentSize.height
        let query = """
                UPDATE \(TABLE_BASEMODEL) SET
                \(POS_X) = ?,
                \(POS_Y) = ?,
                \(WIDTH) = ?,
                \(HEIGHT) = ?,
                \(START_TIME) = ?,
                \(DURATION) = ?
                WHERE \(MODEL_ID) = ?
               """
        let values: [Any] = [posX,posY,width,height,childValue.BaseTime.startTime,childValue.BaseTime.duration,childValue.modelID]
        do {
            try updateQuery(query, values:values)
            return
        } catch {
            return
        }
        
        
    }
    func updateForParentArray(parentArray:ParentAndChildBaseFrameAndTime,parentSize:CGSize){
        // width and height must be calculated with respect to parentSize
        let width = parentArray.BaseFrame.size.width / parentSize.width
        let height = parentArray.BaseFrame.size.height / parentSize.height

        // posX and posY must be calculated with respect to parentSize
        let posX = parentArray.BaseFrame.center.x / parentSize.width
        let posY = parentArray.BaseFrame.center.y / parentSize.height

        // rotation should be directly taken from moveModelData
        let rotation = parentArray.BaseFrame.rotation
        
        
        let query = """
                UPDATE \(TABLE_BASEMODEL) SET
                \(POS_X) = ?,
                \(POS_Y) = ?,
                \(WIDTH) = ?,
                \(HEIGHT) = ?,
                \(ROTATION) = ?,
                \(START_TIME) = ?,
                \(DURATION) = ?
                WHERE \(MODEL_ID) = ?
               """
        let values: [Any] = [posX,posY,width,height,rotation,parentArray.BaseTime.startTime,parentArray.BaseTime.duration,parentArray.modelID]
        
        do {
            try updateQuery(query, values: values)
            return
        } catch {
            return
        }
    }
    
//    func updateMoveModel(moveModelData: MoveModelData, parentSize: CGSize) -> Bool {
//        
//        
//        
//        
//        // width and height must be calculated with respect to parentSize
//        let width = moveModelData.baseFrame.size.width / parentSize.width
//        let height = moveModelData.baseFrame.size.height / parentSize.height
//
//        // posX and posY must be calculated with respect to parentSize
//        let posX = moveModelData.baseFrame.center.x / parentSize.width
//        let posY = moveModelData.baseFrame.center.y / parentSize.height
//
//        // rotation should be directly taken from moveModelData
//        let rotation = moveModelData.baseFrame.rotation
//
//        // query to update the model
//        let query = """
//        UPDATE \(TABLE_BASEMODEL) SET
//        \(PARENT_ID) = ?,
//        \(ORDER_IN_PARENT) = ?,
//        \(POS_X) = ?,
//        \(POS_Y) = ?,
//        \(WIDTH) = ?,
//        \(HEIGHT) = ?,
//        \(ROTATION) = ?
//        
//        
//        WHERE \(MODEL_ID) = ?
//        """
//
//        // assuming the values required to update
//        let values: [Any] = [moveModelData.parentID, moveModelData.orderInParent, posX, posY, width, height, rotation, moveModelData.modelID]
//
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
    
    
    //NK*
    func updateStartTimeForPage(with values: [Int: Float]) -> Bool{
        // Start the SQL transaction
        var query = "BEGIN TRANSACTION; "
        // Append each update statement
        for (modelId, newValue) in values {
            query += "UPDATE \(TABLE_BASEMODEL) SET \(START_TIME) = \(newValue) WHERE \(MODEL_ID) = \(modelId); "
        }
        
        // End the SQL transaction
        query += "COMMIT;"
        
        do {
            // Execute the combined query
            try updateQuery(query, values: nil)
            return true
        } catch {
            // Rollback in case of any error
            do {
                try updateQuery("ROLLBACK;",values: nil)
            } catch {
                print("Rollback failed: \(error)")
            }
            print("Update failed: \(error)")
            return false
        }

        
    }

    
    func updateOrderInParent(with values: [Int: Int]) -> Bool {
        // Start the SQL transaction
        var query = "BEGIN TRANSACTION; "
        
        // Append each update statement
        for (modelId, newValue) in values {
            query += "UPDATE \(TABLE_BASEMODEL) SET \(ORDER_IN_PARENT) = \(newValue) WHERE \(MODEL_ID) = \(modelId); "
        }
        
        // End the SQL transaction
        query += "COMMIT;"

        do {
            // Execute the combined query
            try updateQuery(query, values: nil)
            return true
        } catch {
            // Rollback in case of any error
            do {
                try updateQuery("ROLLBACK;",values: nil)
            } catch {
                print("Rollback failed: \(error)")
            }
            print("Update failed: \(error)")
            return false
        }
    }

   
    func updateParentIdAndOrder(modelId: Int, parentID: Int,orderInParent:Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(PARENT_ID) = ?,\(ORDER_IN_PARENT) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [parentID,orderInParent, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
  
    func updateBgBlurProgress(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(BG_BLUR_PROGRESS) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateOverlayDataId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(OVERLAY_DATA_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateOverlayOpacity(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(OVERLAY_OPACITY) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStartTime(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(START_TIME) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateDuration(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(DURATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTimeNDuration(modelId: Int, newStartTime: Double? = nil, newDuration: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_BASEMODEL) SET"
        var values: [Any] = []
        
        if let newStartTime = newStartTime {
            query += " \(START_TIME) = ?,"
            values.append(newStartTime)
        }
        
        if let newDuration = newDuration {
            query += " \(DURATION) = ?,"
            values.append(newDuration)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateSoftDelete(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(SOFT_DELETE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(TEMPLATE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateFrameInModel(modelId: Int, posX: Double? = nil, posY: Double? = nil, width: Double? = nil, height: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_BASEMODEL) SET"
        var values: [Any] = []
        
        if let posX = posX {
            query += " \(POS_X) = ?,"
            values.append(posX)
        }
        
        if let posY = posY {
            query += " \(POS_Y) = ?,"
            values.append(posY)
        }
        
        if let width = width {
            query += " \(WIDTH) = ?,"
            values.append(width)
        }
        
        if let height = height {
            query += " \(HEIGHT) = ?,"
            values.append(height)
        }
        
        // Remove the trailing comma.
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateSizeInModel(modelId: Int, newWidth: Double? = nil, newHeight: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_BASEMODEL) SET"
        var values: [Any] = []
        
        if let newWidth = newWidth {
            query += " \(WIDTH) = ?,"
            values.append(newWidth)
        }
        
        if let newHeight = newHeight {
            query += " \(HEIGHT) = ?,"
            values.append(newHeight)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    func updateCenterInModel(modelId: Int, newPosX: Double? = nil, newPosY: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_BASEMODEL) SET"
        var values: [Any] = []
        
        if let newPosX = newPosX {
            query += " \(POS_X) = ?,"
            values.append(newPosX)
        }
        
        if let newPosY = newPosY {
            query += " \(POS_Y) = ?,"
            values.append(newPosY)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}


// Methods for updating the properties of Template Table.
extension DBManager {
    public func updateTemplateName(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(TEMPLATE_NAME) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    public func updateTemplateCategory(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(CATEGORY) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateCategoryMetaDataInTemplate(templateId: Int, date: String, time: String, venue: String, name1: String, name2: String, rsvp: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(EVENT_DATA) = ?, \(EVENT_TIME) = ?, \(VENUE) = ?, \(NAME1) = ?, \(NAME2) = ?, \(RSVP) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [date, time, venue, name1, name2, rsvp, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTemplateSoftDelete(templateId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(SOFT_DELETE) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateRatioId(templateId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(RATIO_ID) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTemplateCreatedDate(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(CREATED_AT) = ?,\(UPDATED_AT) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue,newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    public func updateTemplateUpdatedDate(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(UPDATED_AT) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateThumbServerPath(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(THUMB_SERVER_PATH) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateThumbLocalPath(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(THUMB_LOCAL_PATH) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    public func updateTemplateThumbTime(templateId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(THUMB_TIME) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateTotalDuration(templateId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(TOTAL_DURATION) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateSequence(templateId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(SEQUENCE) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateIsPremium(templateId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(IS_PREMIUM) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateCategoryTemp(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(CATEGORY_TEMP) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateDataPath(templateId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(DATA_PATH) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateServerTemplateId(templateId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(SERVER_TEMPLATE_ID) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [newValue, templateId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}

//Methods for update the properties of table TemplateMetaData.
extension DBManager {
    func updateTemplateMetaDataFieldId(fieldId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(FIELD_ID) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [newValue, fieldId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateMetaDataFieldDisplayName(fieldId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(FIELD_DISPLAY_NAME) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [newValue, fieldId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateMetaDataTemplateValue(fieldId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(TEMPLATE_VALUE) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [newValue, fieldId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateMetaDataCategoryName(fieldId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(CATEGORY_NAME) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [newValue, fieldId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateTemplateMetaDataSeq(fieldId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(SEQ) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [newValue, fieldId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}

//Methods for updating the properties of Image Table.
extension DBManager {
    func updateImageType(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(IMAGE_TYPE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageServerPath(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(SERVER_PATH) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageLocalPath(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(LOCAL_PATH) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageResID(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(RES_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageIsEncrypted(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(IS_ENCRYPTED) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageCropX(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(CROP_X) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageCropY(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(CROP_Y) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageCropW(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(CROP_W) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageCropH(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(CROP_H) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageCropPoints(modelId: Int, newX: Double? = nil, newY: Double? = nil, newW: Double? = nil, newH: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_IMAGE) SET"
        var values: [Any] = []
        var updatedFields: [String] = []
        
        if let newX = newX {
            query += " \(CROP_X) = ?,"
            values.append(newX)
            updatedFields.append(CROP_X)
        }
        
        if let newY = newY {
            query += " \(CROP_Y) = ?,"
            values.append(newY)
            updatedFields.append(CROP_Y)
        }
        
        if let newW = newW {
            query += " \(CROP_W) = ?,"
            values.append(newW)
            updatedFields.append(CROP_W)
        }
        
        if let newH = newH {
            query += " \(CROP_H) = ?,"
            values.append(newH)
            updatedFields.append(CROP_H)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageCropStyle(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(CROP_STYLE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageModel(imageModel:DBImageModel?)->Int{
        guard let  image = imageModel else {return -1}
        var insertedRowId:Int = -1
       
        NSLog("OpenGlTest In DesignDbHelper insertImageRow")

        let query = "REPLACE INTO \(TABLE_IMAGE) (\(IMAGE_ID), \(IMAGE_TYPE), \(SERVER_PATH), \(LOCAL_PATH), \(RES_ID), \(IS_ENCRYPTED), \(CROP_X), \(CROP_Y), \(CROP_W), \(CROP_H), \(CROP_STYLE), \(TILE_MULTIPLE), \(COLOR_INFO), \(IMAGE_WIDTH), \(IMAGE_HEIGHT),\(TEMPLATE_ID),\(SOURCE_TYPE)) VALUES ('\(image.imageID)', '\(image.imageType)', '\(image.serverPath)', '\(image.localPath)', '\(image.resID)', '\(image.isEncrypted)', '\(image.cropX)', '\(image.cropY)', '\(image.cropW)', '\(image.cropH)', '\(image.cropStyle)', '\(image.tileMultiple)', '\(image.colorInfo)', '\(image.imageWidth)', '\(image.imageHeight)','\(image.templateID )','\(image.sourceTYPE)')"

       
            //  print(query)
                    insertedRowId = insertNewEntry(query: query)
        return insertedRowId

    }
    
    func updateImageTileMultiple(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(TILE_MULTIPLE) = ? WHERE \(IMAGE_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageColorInfo(modelId: Int, newValue: String, type: String) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(COLOR_INFO) = ?, \(IMAGE_TYPE) = ? WHERE \(IMAGE_ID) = ?"
        let values: [Any] = [newValue, type, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageColorInfoAndSourceType(modelId: Int, newValue: String, sourceType: String) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(COLOR_INFO) = '\(newValue)', \(SOURCE_TYPE) = '\(sourceType)' WHERE \(IMAGE_ID) = \(modelId)"
        let values: [Any] = [newValue, sourceType, modelId]
        do {
            try updateQuery(query, values: [nil])
            return true
        } catch {
            return false
        }
    }
    
    func updateImageWidth(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(IMAGE_WIDTH) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageHeight(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(IMAGE_HEIGHT) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageSize(modelId: Int, newWidth: Double? = nil, newHeight: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_IMAGE) SET"
        var values: [Any] = []
        
        if let newWidth = newWidth {
            query += " \(IMAGE_WIDTH) = ?,"
            values.append(newWidth)
        }
        
        if let newHeight = newHeight {
            query += " \(IMAGE_HEIGHT) = ?,"
            values.append(newHeight)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateImageTemplateID(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_IMAGE) SET \(TEMPLATE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}

//Methods for updating the properties in Sticker Model.
extension DBManager {
    func updateStickerImageId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(IMAGE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerType(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(STICKER_TYPE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    func replaceCategoryMetaDataRowIfNeeded(categoryMetaData: ServerCategoryMetaData) {
        let query = """
            REPLACE INTO \(CATEGORY_META_DATA) (
                FIELD_ID,
                FIELD_DISPLAY_NAME,
                TEMPLATE_VALUE,
                CATEGORY_NAME,
                SEQ
            ) VALUES (?, ?, ?, ?, ?)
            """
            
        do {
            try database.executeUpdate(query, values: [
                categoryMetaData.fieldId,
                categoryMetaData.fieldDisplayName,
                categoryMetaData.templateValue,
                categoryMetaData.categoryName,
                categoryMetaData.seq
            ])
            print("CategoryMetaData inserted successfully")
        } catch {
            print("Failed to insert CategoryInfo: \(error.localizedDescription)")
        }
    }
    

    func updateStickerFilterType(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(STICKER_FILTER_TYPE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerHue(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(STICKER_HUE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateStickerHueNFilterType(modelId: Int, newHue: Int? , newFilterType: Int? ) -> Bool {
        var query = "UPDATE \(TABLE_STICKER) SET"
        var values: [Any] = []
        
        if let newHue = newHue {
            query += " \(STICKER_HUE) = ?,"
            values.append(newHue)
        }
        
        if let newFilterType = newFilterType {
            query += " \(STICKER_FILTER_TYPE) = ?,"
            values.append(newFilterType)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(STICKER_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerColor(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(STICKER_COLOR) = ? WHERE \(STICKER_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateStickerColorWithFilterType(modelId: Int, newColor: String? , newFilterType: Int? ) -> Bool {
        var query = "UPDATE \(TABLE_STICKER) SET"
        var values: [Any] = []
        
        if let newColor = newColor {
            query += " \(STICKER_COLOR) = ?,"
            values.append(newColor)
        }
        
        if let newFilterType = newFilterType {
            query += " \(STICKER_FILTER_TYPE) = ?"
            values.append(newFilterType)
        }
        
        // Remove the trailing comma
//        query.removeLast()
        
        query += " WHERE \(STICKER_ID) = ?;"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerXRotationProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(X_ROATATION_PROG) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerYRotationProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(Y_ROATATION_PROG) = ? WHERE \(STICKER_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerZRotationProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(Z_ROATATION_PROG) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateStickerRotationProg(modelId: Int, newXRotationProg: Int? = nil, newYRotationProg: Int? = nil, newZRotationProg: Int? = nil) -> Bool {
        var query = "UPDATE \(TABLE_STICKER) SET"
        var values: [Any] = []
        
        if let newXRotationProg = newXRotationProg {
            query += " \(X_ROATATION_PROG) = ?,"
            values.append(newXRotationProg)
        }
        
        if let newYRotationProg = newYRotationProg {
            query += " \(Y_ROATATION_PROG) = ?,"
            values.append(newYRotationProg)
        }
        
        if let newZRotationProg = newZRotationProg {
            query += " \(Z_ROATATION_PROG) = ?,"
            values.append(newZRotationProg)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MODEL_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateStickerTemplateID(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_STICKER) SET \(TEMPLATE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}



//Methods for updating the properties into the TEXT Table
extension DBManager {
    func updateText(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(TEXT) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextFont(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(TEXT_FONT) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextColor(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(TEXT_COLOR) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextGravity(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(TEXT_GRAVITY) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextLineSpacing(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(LINE_SPACING) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextLetterSpacing(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(LETTER_SPACING) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextShadowColor(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(SHADOW_COLOR) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextShadowOpacity(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(SHADOW_OPACITY) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextShadowRadius(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(SHADOW_RADIUS) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextShadowDx(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(SHADOW_Dx) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextShadowDy(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(SHADOW_Dy) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextShadow(modelId: Int, newShadowDx: Double? = nil, newShadowDy: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_TEXT_MODEL) SET"
        var values: [Any] = []
        
        if let newShadowDx = newShadowDx {
            query += " \(SHADOW_Dx) = ?,"
            values.append(newShadowDx)
        }
        
        if let newShadowDy = newShadowDy {
            query += " \(SHADOW_Dy) = ?,"
            values.append(newShadowDy)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(TEXT_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextBgType(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(BG_TYPE) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextBgDrawable(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(BG_DRAWABLE) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextBgColor(modelId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(BG_COLOR) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextBackground(modelId: Int, newBgType: String? = nil, newBgColor: String? = nil) -> Bool {
        var query = "UPDATE \(TABLE_TEXT_MODEL) SET"
        var values: [Any] = []
        
        if let newBgType = newBgType {
            query += " \(BG_TYPE) = ?,"
            values.append(newBgType)
        }
        
        if let newBgColor = newBgColor {
            query += " \(BG_COLOR) = ?,"
            values.append(newBgColor)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(TEXT_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextBgAlpha(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(BG_ALPHA) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextInternalHeightMargin(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(INTERNAL_HEIGHT_MARGIN) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextInternalWidthMargin(modelId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(INTERNAL_WIDTH_MARGIN) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextInternalMargin(modelId: Int, newHeightMargin: Double? = nil, newWidthMargin: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_TEXT_MODEL) SET"
        var values: [Any] = []
        
        if let newHeightMargin = newHeightMargin {
            query += " \(INTERNAL_HEIGHT_MARGIN) = ?,"
            values.append(newHeightMargin)
        }
        
        if let newWidthMargin = newWidthMargin {
            query += " \(INTERNAL_WIDTH_MARGIN) = ?,"
            values.append(newWidthMargin)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(TEXT_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextXRotationProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(X_ROATATION_PROG) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextYRotationProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(Y_ROATATION_PROG) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextZRotationProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(Z_ROATATION_PROG) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextRotationProg(modelId: Int, newXRotationProg: Int? = nil, newYRotationProg: Int? = nil, newZRotationProg: Int? = nil) -> Bool {
        var query = "UPDATE \(TABLE_TEXT_MODEL) SET"
        var values: [Any] = []
        
        if let newXRotationProg = newXRotationProg {
            query += " \(X_ROATATION_PROG) = ?,"
            values.append(newXRotationProg)
        }
        
        if let newYRotationProg = newYRotationProg {
            query += " \(Y_ROATATION_PROG) = ?,"
            values.append(newYRotationProg)
        }
        
        if let newZRotationProg = newZRotationProg {
            query += " \(Z_ROATATION_PROG) = ?,"
            values.append(newZRotationProg)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(TEXT_ID) = ?"
        values.append(modelId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextCurveProg(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(CURVE_PROG) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextTemplateID(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(TEMPLATE_ID) = ? WHERE \(TEXT_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateTextColorAndBGType(textId: Int, bgType: Int, color: String, bgColor: String, shadowColor: String) -> Bool{
        let query = "UPDATE \(TABLE_TEXT_MODEL) SET \(BG_TYPE) = '\(bgType)', \(TEXT_COLOR) = '\(color)', \(BG_COLOR) = '\(bgColor)', \(SHADOW_COLOR) = '\(shadowColor)' WHERE \(TEXT_ID) = \(textId)"
        let values: [Any] = [bgType, color, bgColor, shadowColor, textId]
        do {
            try updateQuery(query, values: [nil])
            return true
        } catch {
            return false
        }
    }
}

//Methods For updating the properties of Animation Model.
extension DBManager {
    func updateInAnimationTemplateId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_ANIMATION) SET \(IN_ANIMATION_TEMPLATE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateInAnimationDuration(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_ANIMATION) SET \(IN_ANIMATION_DURATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateLoopAnimationTemplateId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_ANIMATION) SET \(LOOP_ANIMATION_TEMPLATE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateLoopAnimationDuration(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_ANIMATION) SET \(LOOP_ANIMATION_DURATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateOutAnimationTemplateId(modelId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_ANIMATION) SET \(OUT_ANIMATION_TEMPLATE_ID) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateOutAnimationDuration(modelId: Int, newValue: Float) -> Bool {
        let query = "UPDATE \(TABLE_ANIMATION) SET \(OUT_ANIMATION_DURATION) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [newValue, modelId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}

// Methods used for updating the property of Music Table.
extension DBManager {
    func updateMusicName(musicId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(NAME) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicMusicPath(musicId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(MUSIC_PATH) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicParentID(musicId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(PARENT_ID) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicParentType(musicId: Int, newValue: Int) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(PARENT_TYPE) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicStartTimeOfAudio(musicId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(START_TIME) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicEndTimeOfAudio(musicId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(END_TIME_OF_AUDIO) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicDuration(musicId: Int, newValue: Double) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(DURATION) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateMusicTime(musicId: Int, newStartTime: Double? = nil, newEndTime: Double? = nil, newDuration: Double? = nil) -> Bool {
        var query = "UPDATE \(TABLE_MUSICINFO) SET"
        var values: [Any] = []
        
        if let newStartTime = newStartTime {
            query += " \(START_TIME) = ?,"
            values.append(newStartTime)
        }
        
        if let newEndTime = newEndTime {
            query += " \(END_TIME_OF_AUDIO) = ?,"
            values.append(newEndTime)
        }
        
        if let newDuration = newDuration {
            query += " \(DURATION) = ?,"
            values.append(newDuration)
        }
        
        // Remove the trailing comma
        query.removeLast()
        
        query += " WHERE \(MUSIC_ID) = ?"
        values.append(musicId)
        
        // Execute the update query
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }

    func updateMusicTemplateID(musicId: Int, newValue: String) -> Bool {
        let query = "UPDATE \(TABLE_MUSICINFO) SET \(TEMPLATE_ID) = ? WHERE \(MUSIC_ID) = ?"
        let values: [Any] = [newValue, musicId]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateMusicTableDuration(music: String, newValue: Float) -> Bool{
        let query = "UPDATE \(TABLE_MUSICMODEL) SET \(duration) = ? WHERE \(Music_localPath) = ?"
        let values: [Any] = [newValue, music]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
}

//Methods for updating the properties of Ratio Table.
//extension DBManager {
//    func updateRatioCategory(categoryId: Int, newValue: String) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET CATEGORY = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioCategoryDescription(categoryId: Int, newValue: String) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET CATEGORY_DESCRIPTION = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioImageResId(categoryId: Int, newValue: Int) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET IMAGE_RES_ID = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioRatioWidth(categoryId: Int, newValue: Double) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET RATIO_WIDTH = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioRatioHeight(categoryId: Int, newValue: Double) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET RATIO_HEIGHT = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioOutputWidth(categoryId: Int, newValue: Double) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET OUTPUT_WIDTH = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioOutputHeight(categoryId: Int, newValue: Double) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET OUTPUT_HEIGHT = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//
//    func updateRatioIsPremium(categoryId: Int, newValue: Int) -> Bool {
//        let query = "UPDATE RATIO_MODEL SET IS_PREMIUM = ? WHERE RATIO_ID = ?"
//        let values: [Any] = [newValue, categoryId]
//        do {
//            try updateQuery(query, values: values)
//            return true
//        } catch {
//            return false
//        }
//    }
//}



//extension DBManager {
//    // Method to call all update methods for the MODEL table with arbitrary values.
//    func updateModelsWithArbitraryValues(modelId: Int) throws {
//        // Call update methods for various properties of the model.
//        let res1 =  updateModelType(modelId: modelId, newValue: "Neeshu")
//        let res2 =  updateDataId(modelId: modelId, newValue: 23)
//        let res3 =  updatePosX(modelId: modelId, newValue: 3.0)
//        let res4 =  updatePosY(modelId: modelId, newValue: 4.0)
//        let res5 =  updateWidth(modelId: modelId, newValue: 200)
//        let res6 =  updateHeight(modelId: modelId, newValue: 300)
//        let res7 =  updatePrevAvailableWidth(modelId: modelId, newValue: 100)
//        let res8 =  updatePrevAvailableHeight(modelId: modelId, newValue: 100)
//        let res9 =  updateRotation(modelId: modelId, newValue: 90)
//        let res10 =  updateModelOpacity(modelId: modelId, newValue: 0.5)
//        let res11 =  updateModelFlipHorizontal(modelId: modelId, newValue: 1)
//        let res12 =  updateModelFlipVertical(modelId: modelId, newValue: 0)
//        let res13 =  updateLockStatus(modelId: modelId, newValue: "N")
//        let res14 =  updateOrderInParent(modelId: modelId, newValue: 2)
//        let res15 =  updateParentId(modelId: modelId, newValue: 232)
//        let res16 =  updateBgBlurProgress(modelId: modelId, newValue: 1)
//        let res17 =  updateOverlayDataId(modelId: modelId, newValue: 321)
//        let res18 =  updateOverlayOpacity(modelId: modelId, newValue: 1)
//        let res19 =  updateStartTime(modelId: modelId, newValue: 2)
//        let res20 =  updateDuration(modelId: modelId, newValue: 5)
//        let res21 =  updateTimeNDuration(modelId: modelId, newStartTime: 2, newDuration: 5)
//        let res22 =  updateSoftDelete(modelId: modelId, newValue: 1)
//        let res23 =  updateTemplateId(modelId: modelId, newValue: 123)
//    }
//}



// hk
extension DBManager{
    func updateDBTemplate(category:String,thumbLocalPath:String,thumbTime:Float,thumbDuration:Float,templateID:Int)->Bool{
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(CATEGORY) = ?,\(THUMB_LOCAL_PATH) = ?,\(THUMB_TIME) = ?,\(TOTAL_DURATION) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [category,thumbLocalPath,thumbTime,thumbDuration, templateID]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    
    //Created by Neeshu
    public func updateTemplateRow(template: DBTemplateModel, templateID : Int) -> Bool {
        let query = "UPDATE \(TABLE_TEMPLATE) " +
                    "SET \(TEMPLATE_NAME) = ?, " +
                    "\(CATEGORY) = ?, " +
                    "\(RATIO_ID) = ?, " +
                    "\(THUMB_SERVER_PATH) = ?, " +
                    "\(THUMB_LOCAL_PATH) = ?, " +
                    "\(THUMB_TIME) = ?, " +
                    "\(TOTAL_DURATION) = ?, " +
                    "\(SEQUENCE) = ?, " +
                    "\(IS_PREMIUM) = ?, " +
                    "\(CATEGORY_TEMP) = ?, " +
                    "\(DATA_PATH) = ? " +
                    "WHERE \(TEMPLATE_ID) = ?"
        
        
        // Parameters for the prepared statement
        let parameters: [Any] = [
            template.templateName,
            template.category,
            template.ratioId,
            template.thumbServerPath,
            template.thumbLocalPath,
            template.thumbTime,
            template.totalDuration,
            template.sequence_Temp,
            template.isPremium,
            template.categoryTemp,
            template.dataPath,
            templateID
        ]

        do {
            try updateQuery(query, values: parameters)
            return true
        } catch {
            return false
        }
    }

}

//extension DBManager{
//    func updateParentInfoGroup(parentInfo:ParentInfo,parentID:Int,templateID:Int){
//        // insertBaseModel
//        var baseModel = parentInfo.getBaseModel(refSize: globalRefSize)
//        baseModel.parentId = parentID
//        let baseModelID = replaceBaseModelIfNeeded(baseModel: parentInfo.getBaseModel(refSize: globalRefSize       ))
//        var animationModel = parentInfo.getAnimation()
//        animationModel.modelId = baseModelID
//        // insertAnimation
//        var animationID = replaceAnimationRowIfNeeded(animation: animationModel)
//        for child in parentInfo.children{
//            
//            if child.modelType == .Parent{
//                if var parent = child as? ParentInfo{
//                    parent.posX = parent.posX/parentInfo.posX
//                    parent.posY = parent.posY/parentInfo.posY
//                    parent.width = parent.width/parentInfo.width
//                    parent.height = parent.height/parentInfo.height
//                }
////                let
//            }else if child.modelType == .Sticker{
//                // get Sticker Model
////              _ =  insertStickerInfo(stickerInfoModel: child as! StickerInfo, parentID: baseModelID, templateID: templateID)
//                // changeStickerModel.parentID
//                // insert it in DB
//            }else if child.modelType == .Text{
////                insertTextInfo(textInfoModel: child as!TextInfo, parentID: baseModelID, templateID: templateID)
//            }
//        }
//    }
//}



//extension DBManager{
//    func addNewColumnInImage(){
//        let query = "ALTER TABLE IMAGE ADD COLUMN" + " SOURCE_TYPE"
//        do {
//            try updateQuery(query, values: [])
//            
//        } catch {
//            
//        }
//    }
//}
//
