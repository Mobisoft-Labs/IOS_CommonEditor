//
//  DBManager+FiltersNAdjustment.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//

extension DBManager{
    func updateFiterType(modelID : Int , filterType : Int) -> Bool{
        // Update FilterType in Model.
        let query = "UPDATE \(TABLE_BASEMODEL) SET \(FILTER_TYPE) = ? WHERE \(MODEL_ID) = ?"
        let values: [Any] = [filterType, modelID]
        do {
            try updateQuery(query, values: values)
            return true
        } catch {
            return false
        }
    }
    
    func updateAdjustment(modelID : Int , adjustmentType : AdjustmentsEnum, adjustmentIntensity : Float)  -> Bool{
        // Update Adjustement based on adjustmentType.
        switch adjustmentType{
        case .brightness:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(BRIGHTNESS) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .contrast:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(CONTRAST) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .highlight:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(HIGHLIGHT) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .shadows:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(SHADOWS) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .saturation:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(SATURATION) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .vibrance:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(VIBRANCE) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .sharpness:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(SHARPNESS) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .warmth:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(WARMTH) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        case .tint:
            // Update FilterType in Model.
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(TINT) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [adjustmentIntensity, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        }
        
    }
}
extension DBManager {
    func updateMaskStatus(modelID: Int, hasMask: Bool) -> Bool {
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(HAS_MASK) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [hasMask ? 1 : 0, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        }

        func updateMaskShape(modelID: Int, maskShape: String) -> Bool {
            let query = "UPDATE \(TABLE_BASEMODEL) SET \(MASK_SHAPE) = ?,SET \(HAS_MASK) = ? WHERE \(MODEL_ID) = ?"
            let values: [Any] = [maskShape,maskShape == "" ? 0 : 1, modelID]
            do {
                try updateQuery(query, values: values)
                return true
            } catch {
                return false
            }
        }
}

// Update the meta deta in template.
extension DBManager{
    func updateTemplateName1(templateId : Int , name1 : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(NAME1) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [name1, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateName2(templateId : Int , name2 : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(NAME2) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [name2, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateVenue(templateId : Int , venue : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(VENUE) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [venue, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateRSVP(templateId : Int , rsvp : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(RSVP) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [rsvp, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateEventTime(templateId : Int , eventTime : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(EVENT_TIME) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [eventTime, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateEventData(templateId : Int , eventData : String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(EVENT_DATA) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [eventData, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateEventIdAndJson(templateId : Int , eventId : Int, templateJson: String, eventStatus: String, userId: Int, eventStartDate: String){
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(EVENT_ID) = ?, \(EVENT_TEMPLATE_JSON) = ?, \(TEMPLATE_EVENT_STATUS) = ?, \(USER_ID) = ?, \(EVENT_START_DATE) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [eventId, templateJson, eventStatus, userId, eventStartDate, templateId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
    
    func updateTemplateWatermarkStatus(to showWatermark: Bool, for templateID: Int ) {
        let query = "UPDATE \(TABLE_TEMPLATE) SET \(SHOW_WATERMARK) = ? WHERE \(TEMPLATE_ID) = ?"
        let values: [Any] = [showWatermark , templateID]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
   

}

// Update the user field in Meta Data Table.
extension DBManager{
    func updateMetaDataUserValue(fieldId : Int , userValue : String){
        let query = "UPDATE \(TABLE_CATEGORY_METADATA) SET \(USER_VALUE) = ? WHERE \(FIELD_ID) = ?"
        let values: [Any] = [userValue, fieldId]
        do {
            try updateQuery(query, values: values)
        } catch {
            print("Failed to update thumb time in db.")
        }
    }
}

extension DBManager {
    
//    func syncCategoryModel(_ category: CategoryModel) {
//        do {
//            // Check if category exists
//            let checkQuery = "SELECT LAST_MODIFIED FROM \(TABLE_CATEGORY) WHERE ID = ?"
//            
//            let rows = try updateQuery(checkQuery, values: [category.id])
//
//            if rows.isEmpty {
//                // Insert new master record
//                let insertMaster = """
//                    INSERT INTO \(TABLE_CATEGORY_MASTER) 
//                    (ID, NAME, LAST_MODIFIED, THUMBNAIL_PATH, IS_RELEASED, CATEGORY_DATA_PATH)
//                    VALUES (?, ?, ?, ?, ?, ?)
//                """
//                let masterValues: [Any] = [
//                    category.id,
//                    category.name,
//                    category.lastModified,
//                    category.thumbnailPath ?? "",
//                    category.isReleased,
//                    category.categoryDataPath
//                ]
//                try updateQuery(insertMaster, values: masterValues)
//
//                // Insert form fields
//                try insertFormFields(category.formFields)
//
//            } else if let existing = rows.first,
//                      let currentLastModified = existing["LAST_MODIFIED"] as? String,
//                      currentLastModified != category.lastModified {
//
//                // Remove old metadata
//                let deleteMeta = "DELETE FROM \(TABLE_CATEGORY_METADATA) WHERE \(CATEGORY_NAME) = ?"
//                try updateQuery(deleteMeta, values: [category.name])
//
//                // Insert fresh
//                try insertFormFields(category.formFields)
//
//                // Update master
//                let updateMaster = """
//                    UPDATE \(TABLE_CATEGORY_MASTER)
//                    SET LAST_MODIFIED = ?
//                    WHERE ID = ?
//                """
//                try updateQuery(updateMaster, values: [category.lastModified, category.id])
//            }
//
//        } catch {
//            print("DB error in syncCategoryModel: \(error.localizedDescription)")
//        }
//    }

//    private func insertFormFields(_ fields: [CategoryFormField]) throws {
//        let insertMeta = """
//            INSERT INTO \(TABLE_CATEGORY_METADATA)
//            (FIELD_ID, FIELD_DISPLAY_NAME, TEMPLATE_VALUE, CATEGORY_NAME)
//            VALUES (?, ?, ?, ?)
//        """
//        for field in fields {
//            let values: [Any] = [
//                field.fieldID,
//                field.fieldDisplayName,
//                field.templateValue ?? "",
//                field.categoryName
//            ]
//            try updateQuery(insertMeta, values: values)
//        }
//    }
    

        /// Syncs a single `CategoryModel` with local DB: inserts or replaces as needed.
//        func replaceCategory(_ category: CategoryModel) throws {
//            logger.printLog("replaceCategory -  \(category.name) - newDate \(category.lastModified)")
//            
//            let categoryName = category.name
//            let lastModified = category.lastModified
//
//            // 1️⃣ Check if exists
//            let checkQuery = "SELECT \(LAST_MODIFIED) FROM \(TABLE_CATEGORY) WHERE \(CATEGORY_NAME) = ?"
//            let rs = try runQuery(checkQuery, values: [categoryName])
////            defer { rs.close() }
//            
//            var needsInsert = true
//            var localLastModified: String?
//            var hasMaster : Bool = false
//            
//            if rs.next() {
//                hasMaster = true
//                needsInsert = false
//                let localLastModified = rs.string(forColumn: "LAST_MODIFIED")
//                logger.printLog("replaceCategory -  \(category.name) - oldDate \(localLastModified)")
//
//               
//                if localLastModified == lastModified {
//                    // Same date, no update needed.
//                    logger.printLog("replaceCategory -  \(category.name) - sameDate")
//
//                    return
//                } else {
//                    // Dates differ: remove old metadata, update master later.
//                    let deleteQuery = "DELETE FROM \(TABLE_CATEGORY_METADATA) WHERE \(CATEGORY_NAME) = ?"
//                    _ = try updateQuery(deleteQuery, values: [category.name])
//                    logger.printLog("replaceCategory -  \(category.name) - deleted metaData ")
//
//
//                   
//                }
//            }
//            
//            if !hasMaster {
//                // cleanup rows if master is not avaiable ,
//                let deleteQuery = "DELETE FROM \(TABLE_CATEGORY_METADATA) WHERE \(CATEGORY_NAME) = ?"
//                _ = try updateQuery(deleteQuery, values: [category.name])
//                logger.printLog("replaceCategory -  \(category.name) - deleted metaData for missing master category ")
//            }
//            
//            // this means if rs.next() if category is not available there might be possibility that category doesnt event exist anymore.
//            
//
//            // 2️⃣ Insert new/replace metadata rows
//            for formField in category.formFields {
//                let insertMetaQuery = """
//                    INSERT INTO \(TABLE_CATEGORY_METADATA) ( \(FIELD_DISPLAY_NAME),  \(TEMPLATE_VALUE),  \(CATEGORY_NAME),  \(SEQ)
//                    ) VALUES ('\(formField.fieldDisplayName)','\(formField.templateValue ?? "")','\(formField.categoryName)','\(Int(formField.seq) ?? -1)')
//                """
//             
//                _ = insertNewEntry(query: insertMetaQuery)
//                logger.printLog("replaceCategory -  \(category.name) - new metada insterted ")
//
//            }
//
//            // 3️⃣ Insert or update master row
//            if needsInsert {
//                let insertMasterQuery = """
//                    INSERT INTO  \(TABLE_CATEGORY) (  \(CATEGORY_NAME),\(CATEGORY_THUMB_PATH),   \(LAST_MODIFIED) , \(CATEGORY_DATA_PATH) )
//                    VALUES ( '\(category.name)', '\(category.thumbnailPath ?? "")','\(lastModified)', '\(category.categoryDataPath)' )
//                """
//                _ = insertNewEntry(query: insertMasterQuery)
//                logger.printLog("replaceCategory -  \(category.name) - new category inserted ")
//
//            } else {
//                let updateMasterQuery = "UPDATE \(TABLE_CATEGORY) SET \(LAST_MODIFIED) = ? WHERE \(CATEGORY_NAME) = ?"
//                try updateQuery(updateMasterQuery, values: [lastModified, categoryName])
//                logger.printLog("replaceCategory -  \(category.name) - last modified date updated ")
//
//            }
//        }
}

