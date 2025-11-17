//
//  File.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 21/07/23.
//

import Foundation
import UIKit
import FMDB

extension DBManager{
    //MARK: - Fetch method
    // Fetch method
    
    func getTemplateIDs(ByCategoryName: String) -> [Int] {
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE CATEGORY = '\(ByCategoryName)';"
        var templatesIDs = [Int]()
        guard let resultSet = try? runQuery(query, values: nil) else {
            DBManager.logger?.logError("No Templates For Category Found")
            return templatesIDs
        }
        
        while resultSet.next() {
            
            var templateID = Int(resultSet.int(forColumn: TEMPLATE_ID))
            templatesIDs.append(templateID)
            
           
        }
        
        return templatesIDs
    }
    
    public func getTemplate(templateId: Int) -> DBTemplateModel? {
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(TEMPLATE_ID) = \(templateId);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }
        
        if resultSet.next() {
            
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.serverTemplateId = Int(resultSet.int(forColumn: SERVER_TEMPLATE_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.colorPalleteId = Int(resultSet.int(forColumn: COLOR_PALLETE_ID) )
            template.fontSetId = Int(resultSet.int(forColumn: FONT_SET_ID) )
            template.eventData = resultSet.string(forColumn: EVENT_DATA) ?? ""
            template.eventTime = resultSet.string(forColumn: EVENT_TIME) ?? ""
            template.venue =  resultSet.string(forColumn: VENUE) ?? ""
            template.name1 =  resultSet.string(forColumn: NAME1) ?? ""
            template.name2 =  resultSet.string(forColumn: NAME2) ?? ""
            template.rsvp =  resultSet.string(forColumn: RSVP) ?? ""
            template.baseColor =  resultSet.string(forColumn: BASE_COLOR) ?? ""
            template.layoutId = Int(resultSet.int(forColumn: LAYOUT_ID) )
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            return template
        }
        
        return nil
    }
    
    func getTemplateForEventId(eventId: Int, eventStatus: String) -> DBTemplateModel? {
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(EVENT_ID) = \(eventId) AND \(TEMPLATE_EVENT_STATUS) = '\(eventStatus)';"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }
        
        if resultSet.next() {
            
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.serverTemplateId = Int(resultSet.int(forColumn: SERVER_TEMPLATE_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.colorPalleteId = Int(resultSet.int(forColumn: COLOR_PALLETE_ID) )
            template.fontSetId = Int(resultSet.int(forColumn: FONT_SET_ID) )
            template.eventData = resultSet.string(forColumn: EVENT_DATA) ?? ""
            template.eventTime = resultSet.string(forColumn: EVENT_TIME) ?? ""
            template.venue =  resultSet.string(forColumn: VENUE) ?? ""
            template.name1 =  resultSet.string(forColumn: NAME1) ?? ""
            template.name2 =  resultSet.string(forColumn: NAME2) ?? ""
            template.rsvp =  resultSet.string(forColumn: RSVP) ?? ""
            template.baseColor =  resultSet.string(forColumn: BASE_COLOR) ?? ""
            template.layoutId = Int(resultSet.int(forColumn: LAYOUT_ID) )
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            
            return template
        }
        
        return nil
    }
    
    func getAllCatergoryMetaModel() ->[DBCategoryMetaModel]{
        var templateList = [DBCategoryMetaModel]()
        let query = "SELECT * FROM \(TABLE_CATEGORY_METADATA) ORDER BY \(SEQ);"

        guard let resultSet = try? runQuery(query, values: nil) else {
            return templateList
        }

        while resultSet.next() {
            //if resultSet.next() {
                var categoryMeta = DBCategoryMetaModel()
             
                    categoryMeta.fieldId = Int(resultSet.int(forColumn: FIELD_ID))
            categoryMeta.fieldDisplayName = resultSet.string(forColumn: FIELD_DISPLAY_NAME) ?? ""
            categoryMeta.templateValue = resultSet.string(forColumn: TEMPLATE_VALUE) ?? ""
            categoryMeta.categoryName = resultSet.string(forColumn: CATEGORY_NAME) ?? ""
            categoryMeta.seq = Int(resultSet.string(forColumn: SEQ) ?? "") ?? 0
                    categoryMeta.userValue = resultSet.string(forColumn: USER_VALUE)
                
//                let metaModel = DBCategoryMetaModel(from: categoryMeta)
                templateList.append(categoryMeta)
            //}
        }
        print("template list count: \(templateList.count)")
        return templateList
        
    }
    
    
    func getCategoryMetaModel(fieldID: Int) -> DBCategoryMetaModel? {
        let query = "SELECT * FROM \(TABLE_CATEGORY_METADATA) WHERE \(FIELD_ID) = \(fieldID);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }

        if resultSet.next() {
            let categoryMeta = ServerCategoryMetaData(
                fieldId: resultSet.string(forColumn: FIELD_ID) ?? "",
                fieldDisplayName: resultSet.string(forColumn: FIELD_DISPLAY_NAME) ?? "",
                templateValue: resultSet.string(forColumn: TEMPLATE_VALUE) ?? "",
                categoryName: resultSet.string(forColumn: CATEGORY_NAME) ?? "",
                seq: resultSet.string(forColumn: SEQ) ?? ""
            )
            
            let metaModel = DBCategoryMetaModel(from: categoryMeta)
            return metaModel
        }
        
        return nil
    }

    
    
    
    func getTemplateUsingServerID(serverID: Int) -> Int {
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(SERVER_TEMPLATE_ID) = \(serverID);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return -1
        }
        if resultSet.next() {
            let templateID = Int(resultSet.string(forColumn: TEMPLATE_ID) ?? "") ?? -1
           return templateID
        }
        
        return -1
    }
    
    func getTemplateListForCategoryDRAFTForUserId(category: String, userId: Int, withOriginalTemplate: Bool) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        
        let userFilter = "(\(USER_ID) = \(userId) OR \(USER_ID) = -1)"
        
        if !withOriginalTemplate{
            let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(SOFT_DELETE) = 1 AND \(ORIGINAL_TEMPLATE) = 0 AND \(userFilter) ORDER BY \(UPDATED_AT) DESC;"
            let values = [category]
            
            guard let resultSet = try? runQuery(query, values: values) else {
                return templateList
            }
            
            while resultSet.next() {
                var template = DBTemplateModel()
                template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
                template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
                template.category = resultSet.string(forColumn: CATEGORY) ?? ""
                template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
                template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
                template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
                template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
                template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
                template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
                template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
                template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
                template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
                template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
                template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
                template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
                template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
                template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
                template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
                template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
                template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
                template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
                template.userId = Int(resultSet.int(forColumn: USER_ID) )
                template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
                template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

                templateList.append(template)
            }
            
            return templateList
        }else{
            let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(SOFT_DELETE) = 1 AND \(ORIGINAL_TEMPLATE) != 0 AND \(userFilter) ORDER BY \(UPDATED_AT) DESC;"
            let values = [category]
            
            guard let resultSet = try? runQuery(query, values: values) else {
                return templateList
            }
            
            while resultSet.next() {
                var template = DBTemplateModel()
                template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
                template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
                template.category = resultSet.string(forColumn: CATEGORY) ?? ""
                template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
                template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
                template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
                template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
                template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
                template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
                template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
                template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
                template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
                template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
                template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
                template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
                template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
                template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
                template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
                template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
                template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
                template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
                template.userId = Int(resultSet.int(forColumn: USER_ID) )
                template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
                template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

                templateList.append(template)
            }
            
            return templateList
        }
    }
    
    func getTemplateListForCategoryDRAFT(category: String, withOriginalTemplate: Bool) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
                
        if !withOriginalTemplate{
            let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(SOFT_DELETE) = 1 AND \(ORIGINAL_TEMPLATE) = 0 ORDER BY \(UPDATED_AT) DESC;"
            let values = [category]
            
            guard let resultSet = try? runQuery(query, values: values) else {
                return templateList
            }
            
            while resultSet.next() {
                var template = DBTemplateModel()
                template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
                template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
                template.category = resultSet.string(forColumn: CATEGORY) ?? ""
                template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
                template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
                template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
                template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
                template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
                template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
                template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
                template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
                template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
                template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
                template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
                template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
                template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
                template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
                template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
                template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
                template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
                template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
                template.userId = Int(resultSet.int(forColumn: USER_ID) )
                template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
                template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

                templateList.append(template)
            }
            
            return templateList
        }else{
            let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(SOFT_DELETE) = 1 AND \(ORIGINAL_TEMPLATE) != 0 ORDER BY \(UPDATED_AT) DESC;"
            let values = [category]
            
            guard let resultSet = try? runQuery(query, values: values) else {
                return templateList
            }
            
            while resultSet.next() {
                var template = DBTemplateModel()
                template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
                template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
                template.category = resultSet.string(forColumn: CATEGORY) ?? ""
                template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
                template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
                template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
                template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
                template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
                template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
                template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
                template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
                template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
                template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
                template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
                template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
                template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
                template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
                template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
                template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
                template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
                template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
                template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
                template.userId = Int(resultSet.int(forColumn: USER_ID) )
                template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
                template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

                templateList.append(template)
            }
            
            return templateList
        }
    }
    
    func getTemplateListForCategorySAVEDForUserId(category: String, userId: Int) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        let userFilter = "(\(USER_ID) = \(userId) OR \(USER_ID) = -1)"
        
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(SOFT_DELETE) = 1 AND \(userFilter) ORDER BY \(UPDATED_AT) DESC;"
        let values = [category]
        
        guard let resultSet = try? runQuery(query, values: values) else {
            return templateList
        }
        
        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            templateList.append(template)
        }
        
        return templateList
        
    }
    
    func getTemplateListForCategorySAVED(category: String) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(SOFT_DELETE) = 1 ORDER BY \(UPDATED_AT) DESC;"
        let values = [category]
        
        guard let resultSet = try? runQuery(query, values: values) else {
            return templateList
        }
        
        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            templateList.append(template)
        }
        
        return templateList
        
    }
    
    func getTemplateListForCategorySAVEDAndNoEvent(category: String) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ? AND \(EVENT_ID) = -1 AND \(SOFT_DELETE) = 1 ORDER BY \(UPDATED_AT) DESC;"
        let values = [category]
        
        guard let resultSet = try? runQuery(query, values: values) else {
            return templateList
        }
        
        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            templateList.append(template)
        }
        
        return templateList
        
    }
    
    func getAllTemplateListUnpublished() -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(EVENT_ID) != -1 AND \(SOFT_DELETE) = 1 AND \(TEMPLATE_EVENT_STATUS) = 'UNPUBLISHED';"
//        let values = [category]
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return templateList
        }
        
        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            templateList.append(template)
        }
        
        return templateList
        
    }
    
    func getTemplateForUnpublished(eventId: Int, category: String) -> DBTemplateModel? {
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(EVENT_ID) = \(eventId) AND \(CATEGORY) = '\(category)' AND \(SOFT_DELETE) = 1 AND \(TEMPLATE_EVENT_STATUS) = 'UNPUBLISHED';"
//        let values = [category]
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }
        
        if resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            return template
        }
        
        return nil
        
    }
    
    func getTemplateListForCategoryDraftAndSaved(category1: String, category2: String) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) IN (?, ?) AND \(SOFT_DELETE) = 1 ORDER BY \(UPDATED_AT) DESC;"
        let values = [category1, category2]

        guard let resultSet = try? runQuery(query, values: values) else {
            return templateList
        }

        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: IS_PREMIUM) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE))
            template.eventId = Int(resultSet.int(forColumn: EVENT_ID) )
            template.templateStatus = resultSet.string(forColumn: TEMPLATE_STATUS) ?? ""
            template.originalTemplate = Int(resultSet.int(forColumn: ORIGINAL_TEMPLATE) )
            template.templateEventStatus = resultSet.string(forColumn: TEMPLATE_EVENT_STATUS) ?? ""
            template.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE) )
            template.eventTemplateJson = resultSet.string(forColumn: EVENT_TEMPLATE_JSON) ?? ""
            template.userId = Int(resultSet.int(forColumn: USER_ID) )
            template.eventStartDate = resultSet.string(forColumn: EVENT_START_DATE) ?? ""
            template.showWatermark = Int(resultSet.int(forColumn: SHOW_WATERMARK))

            templateList.append(template)
        }

        return templateList
    }

    func getTemplateList(category: String) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY_TEMP) = ?;"
        let values = [category]

        guard let resultSet = try? runQuery(query, values: values) else {
            return templateList
        }

        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: THUMB_SERVER_PATH) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""

            templateList.append(template)
        }

        return templateList
    }
    
    //Implement By Neeshu for getting the downloaded templates.
    func getDownloadeTemplateList(category: String) -> [DBTemplateModel] {
        var templateList = [DBTemplateModel]()
        let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY_TEMP) = ? AND \(IS_DETAILS_DOWNLOAD) = 1;"
        let values = [category]

        guard let resultSet = try? runQuery(query, values: values) else {
            return templateList
        }

        while resultSet.next() {
            var template = DBTemplateModel()
            template.templateId = Int(resultSet.int(forColumn: TEMPLATE_ID))
            template.thumbServerPath =  resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.categoryTemp = resultSet.string(forColumn: CATEGORY_TEMP) ?? ""
            template.category = resultSet.string(forColumn: CATEGORY) ?? ""
            template.templateName = resultSet.string(forColumn: TEMPLATE_NAME) ?? ""
            template.thumbServerPath = resultSet.string(forColumn: THUMB_SERVER_PATH) ?? ""
            template.thumbLocalPath = resultSet.string(forColumn: THUMB_LOCAL_PATH) ?? ""
            template.dataPath = resultSet.string(forColumn: DATA_PATH) ?? ""
            template.isPremium = Int(resultSet.int(forColumn: THUMB_SERVER_PATH) )
            template.ratioId = Int(resultSet.int(forColumn: RATIO_ID) )
            template.sequence_Temp = Int(resultSet.int(forColumn: SEQUENCE))
            template.thumbTime = (resultSet.double(forColumn: THUMB_TIME) )
            template.totalDuration = (resultSet.double(forColumn: TOTAL_DURATION) )
            template.isRelease = Int(resultSet.int(forColumn: IS_RELEASED) )
            template.isDetailDownloaded = Int(resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) )
            template.createdAt = resultSet.string(forColumn: CREATED_AT) ?? ""
            template.updatedAt = resultSet.string(forColumn: UPDATED_AT) ?? ""

            templateList.append(template)
        }

        return templateList
    }
    
    

    func getTemplateCategories() -> [String:String] {
        var templateCategories = [String:String]()
        let query = "SELECT DISTINCT \(CATEGORY_NAME), \(CATEGORY_THUMB_PATH) FROM \(TABLE_CATEGORY);"

        guard let resultSet = try? runQuery(query, values: nil) else {
            return templateCategories
        }

        while resultSet.next() {
//            if let category = resultSet.string(forColumn: CATEGORY_NAME) {
//                templateCategories.append(category)
//            }
            if let category = resultSet.string(forColumn: CATEGORY_NAME),
               let categoryThumbPath = resultSet.string(forColumn: CATEGORY_THUMB_PATH) {
                templateCategories[category] = categoryThumbPath
            }
        }

        return templateCategories
    }
    
    func getAllTemplateCategories() -> [CategoryInfo] {
        var localCategories = [CategoryInfo]()
        let query = "SELECT * FROM \(TABLE_CATEGORY);"

        guard let resultSet = try? runQuery(query, values: nil) else {
            return localCategories
        }

        while resultSet.next() {
            let categoryId = resultSet.string(forColumn: "CATEGORY_ID") ?? ""
            let categoryName = resultSet.string(forColumn: "CATEGORY_NAME") ?? ""
            let categoryThumbPath = resultSet.string(forColumn: "CATEGORY_THUMB_PATH")
            let lastModified = resultSet.string(forColumn: "LAST_MODIFIED") ?? ""
          
            let isHeaderDownloaded = resultSet.string(forColumn: "IS_HEADER_DOWNLOADED") ?? ""
            let canDelete = resultSet.string(forColumn: "CAN_DELETE") ?? ""
            let categoryThumbType = resultSet.string(forColumn: "CATEGORY_THUMB_TYPE") ?? ""
            let categoryDataPath = resultSet.string(forColumn: "CATEGORY_DATA_PATH") ?? ""
            
            // Fetch categoryMetaData
            let metaDataQuery = "SELECT * FROM \(CATEGORY_META_DATA) WHERE \(CATEGORY_NAME) = ?;"
            guard let metaDataResultSet = try? runQuery(metaDataQuery, values: [categoryName]) else {
                continue // Skip if there's an error fetching metadata
            }
            
            var categoryMetaData = [ServerCategoryMetaData]()
            while metaDataResultSet.next() {
                let fieldId = metaDataResultSet.string(forColumn: "FIELD_ID") ?? ""
                let fieldDisplayName = metaDataResultSet.string(forColumn: "FIELD_DISPLAY_NAME") ?? ""
                let templateValue = metaDataResultSet.string(forColumn: "TEMPLATE_VALUE") ?? ""
                let seq = metaDataResultSet.string(forColumn: "SEQ") ?? ""
                
                let metaData = ServerCategoryMetaData(fieldId: fieldId,
                                                fieldDisplayName: fieldDisplayName,
                                                templateValue: templateValue,
                                                categoryName: categoryName,
                                                seq: seq)
                categoryMetaData.append(metaData)
            }
            
            let category = ServerCategoryModel(categoryId: categoryId,
                                    categoryName: categoryName,
                                    categoryThumbPath: categoryThumbPath,
                                    lastModified: lastModified,
                                    isHeaderDownloaded: isHeaderDownloaded,
                                    canDelete: canDelete,
                                    categoryThumbType: categoryThumbType,
                                    categoryDataPath: categoryDataPath,
        
                                    categoryMetaData: categoryMetaData)
            
            // Create LocalCategory instance with default values for canDelete and isHeaderDownloaded
            let localCategory = CategoryInfo(form: category)
            localCategories.append(localCategory)
        }

        return localCategories
    }

    
    public func getRatioDbModel(ratioId: Int) -> DBRatioTableModel? {
        let query = "SELECT * FROM \(TABLE_RATIOMODEL) WHERE \(ID) = \(ratioId);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }
        
        if resultSet.next() {
            let ratioModel = DBRatioTableModel(
                id: Int(resultSet.int(forColumn: ID)),
                category: resultSet.string(forColumn: CATEGORY) ?? "",
                categoryDescription: resultSet.string(forColumn: CATEGORY_DESCRIPTION) ?? "",
                imageResId: resultSet.string(forColumn: IMAGE_RES_ID) ?? "",
                ratioWidth: resultSet.double(forColumn: RATIO_WIDTH),
                ratioHeight: resultSet.double(forColumn: RATIO_HEIGHT),
                outputWidth: resultSet.double(forColumn: OUTPUT_WIDTH),
                outputHeight: resultSet.double(forColumn: OUTPUT_HEIGHT),
                isPremium: Int(resultSet.int(forColumn: IS_PREMIUM))
            )
            return ratioModel
        }
        
        return nil
    }

    
    public func getRatioCategories() -> [String] {
        var ratioCategories = [String]()
        let category = "FREESTYLE"
        let query = "SELECT DISTINCT \(CATEGORY) FROM \(TABLE_RATIOMODEL) WHERE \(CATEGORY) != ?;"
        let values = [category]

        guard let resultSet = try? runQuery(query, values: values) else {
            return ratioCategories
        }

        while resultSet.next() {
            if let category = resultSet.string(forColumn: CATEGORY) {
                ratioCategories.append(category)
            }
        }

        return ratioCategories
    }

    
    public func getRatioModelList(category: String) -> [DBRatioTableModel] {
        var ratioModelList = [DBRatioTableModel]()
        let query = "SELECT * FROM \(TABLE_RATIOMODEL) WHERE \(CATEGORY) = ?;"
        let values = [category]

        guard let resultSet = try? runQuery(query, values: values) else {
            return ratioModelList
        }

        while resultSet.next() {
            let ratioModel = DBRatioTableModel(
                id: Int(resultSet.int(forColumn: ID)),
                category: resultSet.string(forColumn: CATEGORY) ?? "",
                categoryDescription: resultSet.string(forColumn: CATEGORY_DESCRIPTION) ?? "",
                imageResId: resultSet.string(forColumn: IMAGE_RES_ID) ?? "",
                ratioWidth: resultSet.double(forColumn: RATIO_WIDTH),
                ratioHeight: resultSet.double(forColumn: RATIO_HEIGHT),
                outputWidth: resultSet.double(forColumn: OUTPUT_WIDTH),
                outputHeight: resultSet.double(forColumn: OUTPUT_HEIGHT),
                isPremium: Int(resultSet.int(forColumn: IS_PREMIUM))
            )
            ratioModelList.append(ratioModel)
        }

        return ratioModelList
    }

    
    public func getRatioDbModelID(ratioWidth: Int, ratioHeight: Int) -> Int {
        let query = "SELECT \(ID) FROM \(TABLE_RATIOMODEL) WHERE \(RATIO_WIDTH) = \(ratioWidth) AND \(RATIO_HEIGHT) = \(ratioHeight);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return -1
        }

        if resultSet.next() {
            let id = Int(resultSet.int(forColumn: ID))
            return id
        }

        return -1
    }


//    func getCategoryFromTemplateIdentifier(templateId: Int) -> String {
//        let query = "SELECT \(CATEGORY) FROM \(TABLE_TEMPLATE_IDENTIFIER) WHERE \(TEMPLATE_ID) = \(templateId);"
//        guard let resultSet = try? runQuery(query, values: nil) else {
//            return ""
//        }
//
//        if resultSet.next() {
//            if let category = resultSet.string(forColumn: CATEGORY) {
//                return category
//            }
//        }
//
//        return ""
//    }

    func getDesignerTemplateCategories() -> [String] {
        var categories = [String]()
        let query = "SELECT DISTINCT CATEGORY_TEMP FROM TEMPLATE WHERE CATEGORY = 'TEMPLATE';"

        guard let resultSet = try? runQuery(query, values: nil) else {
            return categories
        }

        while resultSet.next() {
            if let categoryTemp = resultSet.string(forColumn: "CATEGORY_TEMP") {
                categories.append(categoryTemp)
            }
        }

        return categories
    }

    public func getMaxTemplateSequence(category: String) -> Int {
        let query = "SELECT MAX(\(SEQUENCE)) FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = ?;"
        var maxSequence = 0

        do {
            let resultSet = try runQuery(query, values: [category])
            while resultSet.next() {
                maxSequence = Int(resultSet.int(forColumnIndex: 0))
            }
        } catch let error {
            DBManager.logger?.printLog("Error getting max template sequence: \(error.localizedDescription)")
        }

        return maxSequence
    }

    func getMaxChildIndexOfTemplate(templateId: Int) -> Int {
        return getMaxChildIndex(templateId: templateId, forTemplate: true)
    }

    func getMaxChildIndexOfPageOrParent(pageOrParentId: Int) -> Int {
        return getMaxChildIndex(templateId: pageOrParentId, forTemplate: false)
    }

    private func getMaxChildIndex(templateId: Int, forTemplate: Bool) -> Int {
        let conditionStr = forTemplate ? " = \"" : " != \""
        let query = "SELECT MAX(\(ORDER_IN_PARENT)) FROM \(TABLE_BASEMODEL) WHERE \(PARENT_ID) = ? AND \(SOFT_DELETE) = 0 AND \(MODEL_TYPE) \(conditionStr)\("PAGE")\";"
        var maxChildIndex = -1

        do {
            let resultSet = try runQuery(query, values: [templateId])
            while resultSet.next() {
                if resultSet.columnIndexIsNull(0) {
                    maxChildIndex = -1
                } else {
                    maxChildIndex = Int(resultSet.int(forColumnIndex: 0))
                }
            }
        } catch let error {
            DBManager.logger?.printLog("Error getting max child index: \(error.localizedDescription)")
        }

        return maxChildIndex
    }

    func getActivePagesList(templateId: Int) -> [DBBaseModel] {
        let query = "SELECT * FROM \(TABLE_BASEMODEL) WHERE \(PARENT_ID) = ? AND \(SOFT_DELETE) = 0 AND \(MODEL_TYPE) = ? ORDER BY \(ORDER_IN_PARENT) ASC;"
        return getPageList(query: query, values: [templateId,"PAGE"])
    }

    func getSoftDeletedPagesList() -> [DBBaseModel] {
        let query = "SELECT * FROM \(TABLE_BASEMODEL) WHERE \(SOFT_DELETE) = 1 AND \(MODEL_TYPE) = ? ORDER BY \(MODEL_ID) ASC;"
        return getPageList(query: query, values: ["PAGE"])
    }

    private func getPageList(query: String, values: [Any]?) -> [DBBaseModel] {
        var pageArrayList: [DBBaseModel] = []

        do {
            let resultSet = try runQuery(query, values: values)
            while resultSet.next() {
                let modelId = Int(resultSet.int(forColumn: MODEL_ID))
                let modelType =  resultSet.string(forColumn: MODEL_TYPE)
                var values = DBBaseModel()

                values.modelId = modelId
                values.modelType = modelType!
                values.dataId = Int(resultSet.int(forColumn: DATA_ID))
                values.posX = Double(Float(resultSet.double(forColumn: POS_X)))
                values.posY = Double(Float(resultSet.double(forColumn: POS_Y)))
                values.width = Double(Float(resultSet.double(forColumn: WIDTH)))
                values.height = Double(Float(resultSet.double(forColumn: HEIGHT)))
                values.prevAvailableWidth = Double(Float(resultSet.double(forColumn: PREV_AVAILABLE_WIDTH)))
                values.prevAvailableHeight = Double(Float(resultSet.double(forColumn: PREV_AVAILABLE_HEIGHT)))
                values.rotation = (resultSet.double(forColumn: ROTATION))
                values.modelOpacity = (resultSet.double(forColumn: MODEL_OPACITY))
                values.modelFlipHorizontal = Int(resultSet.int(forColumn: MODEL_FLIP_HORIZONTAL))
                values.modelFlipVertical = Int(resultSet.int(forColumn: MODEL_FLIP_VERTICAL))
                values.lockStatus = resultSet.string(forColumn: LOCK_STATUS) ?? ""
                values.orderInParent = Int(resultSet.int(forColumn: ORDER_IN_PARENT))
                values.parentId = Int(resultSet.int(forColumn: PARENT_ID))
                values.bgBlurProgress = Int(resultSet.int(forColumn: BG_BLUR_PROGRESS))
                values.overlayDataId = Int(resultSet.int(forColumn: OVERLAY_DATA_ID))
                values.overlayOpacity = Int(resultSet.int(forColumn: OVERLAY_OPACITY))
                values.startTime = Double(Float(resultSet.double(forColumn: START_TIME)))
                values.duration = Double(Float(resultSet.double(forColumn: DURATION)))
                values.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE))
                values.templateID = Int(resultSet.int(forColumn: TEMPLATE_ID))
                values.filterType = Int(resultSet.int(forColumn: FILTER_TYPE))
                values.brightnessIntensity = Float(resultSet.floatValue(forColumn: BRIGHTNESS))
                values.contrastIntensity = Float(resultSet.floatValue(forColumn: CONTRAST))
                values.highlightIntensity = Float(resultSet.floatValue(forColumn: HIGHLIGHT))
                values.shadowsIntensity = Float(resultSet.floatValue(forColumn: SHADOWS))
                values.saturationIntensity = Float(resultSet.floatValue(forColumn: SATURATION))
                values.vibranceIntensity = Float(resultSet.floatValue(forColumn: VIBRANCE))
                values.sharpnessIntensity = Float(resultSet.floatValue(forColumn: SHARPNESS))
                values.warmthIntensity = Float(resultSet.floatValue(forColumn: WARMTH))
                values.tintIntensity = Float(resultSet.floatValue(forColumn: TINT))
                values.hasMask = Int(resultSet.int(forColumn: HAS_MASK))
                values.maskShape = resultSet.string(forColumn: MASK_SHAPE) ?? ""

                if values.parentId == nil {
                    fatalError("Model id :\(values.modelId) parent id is -1")
                }
                pageArrayList.append(values)
            }
        } catch let error {
            DBManager.logger?.printLog("Error getting page list: \(error.localizedDescription)")
        }

        return pageArrayList
    }

    func getPageImage(pageModelId: Int) -> DBImageModel? {
        let query = "SELECT * FROM  \(TABLE_IMAGE) WHERE \(IMAGE_ID) = ? ; "
        return getImageModel(query: query, values: [pageModelId])
    }

    func getStickerImage(stickerModelId: Int) -> DBImageModel? {
        let query = "SELECT * FROM \(TABLE_STICKER), \(TABLE_IMAGE) WHERE \(TABLE_IMAGE).\(IMAGE_ID) = \(TABLE_STICKER).\(IMAGE_ID) AND \(TABLE_STICKER).\(STICKER_ID) = ?;"
        return getImageModel(query: query, values: [stickerModelId])
    }

    
//    func getParentBgImage(parentModelId: Int) -> ImageModel? {
//        let query = "SELECT * FROM \(TABLE_PARENT_MODEL), \(TABLE_IMAGE) WHERE \(TABLE_IMAGE).\(IMAGE_ID) = \(TABLE_PARENT_MODEL).\(BG_IMAGE_ID) AND \(TABLE_PARENT_MODEL).\(ID) = ?;"
//        return getImageModel(query: query, values: [parentModelId])
//    }

    func getPageOverlayImage(pageModelId: Int) -> DBImageModel? {
        let query = "SELECT * FROM \(TABLE_BASEMODEL), \(TABLE_IMAGE) WHERE \(TABLE_IMAGE).\(IMAGE_ID) = \(TABLE_BASEMODEL).\(OVERLAY_DATA_ID) AND \(TABLE_BASEMODEL).\(MODEL_ID) = ?;"
        return getImageModel(query: query, values: [pageModelId])
    }

    func getAllDBImageModel() -> [DBImageModel]{
        var imageModelArray = [DBImageModel]()
        let query = "SELECT * FROM  \(TABLE_IMAGE);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return imageModelArray
        }
        
        while resultSet.next() {
            var imageModel = DBImageModel(
                imageID:Int(resultSet.int(forColumn: IMAGE_ID)),
                imageType:resultSet.string(forColumn: IMAGE_TYPE) ?? "",
                serverPath:resultSet.string(forColumn: SERVER_PATH) ?? "",
                localPath:resultSet.string(forColumn: LOCAL_PATH) ?? "",
                resID:resultSet.string(forColumn: RES_ID) ?? "",
                isEncrypted:Int(resultSet.int(forColumn: IS_ENCRYPTED)),
                cropX:(resultSet.double(forColumn: CROP_X)),
                cropY:(resultSet.double(forColumn: CROP_Y)),
                cropW:(resultSet.double(forColumn: CROP_W)),
                cropH:(resultSet.double(forColumn: CROP_H)),
                cropStyle:Int(resultSet.int(forColumn: CROP_STYLE)),
                tileMultiple:(resultSet.double(forColumn: TILE_MULTIPLE)),
                colorInfo:resultSet.string(forColumn: COLOR_INFO) ?? "",
                imageWidth:Double(resultSet.int(forColumn: IMAGE_WIDTH)),
                imageHeight:Double(resultSet.int(forColumn: IMAGE_HEIGHT)),
                sourceTYPE: resultSet.string(forColumn: SOURCE_TYPE) ?? ""
            )
            imageModelArray.append(imageModel)
         
        }
        return imageModelArray
        
    }
    
    private func getImageModel(query: String, values: [Any]?) -> DBImageModel? {
        var image: DBImageModel? = nil

        do {
            let resultSet = try runQuery(query, values: values)
            while resultSet.next() {
                image = DBImageModel(
                    imageID:Int(resultSet.int(forColumn: IMAGE_ID)),
                    imageType:resultSet.string(forColumn: IMAGE_TYPE) ?? "",
                    serverPath:resultSet.string(forColumn: SERVER_PATH) ?? "",
                    localPath:resultSet.string(forColumn: LOCAL_PATH) ?? "",
                    resID:resultSet.string(forColumn: RES_ID) ?? "",
                    isEncrypted:Int(resultSet.int(forColumn: IS_ENCRYPTED)),
                    cropX:(resultSet.double(forColumn: CROP_X)),
                    cropY:(resultSet.double(forColumn: CROP_Y)),
                    cropW:(resultSet.double(forColumn: CROP_W)),
                    cropH:(resultSet.double(forColumn: CROP_H)),
                    cropStyle:Int(resultSet.int(forColumn: CROP_STYLE)),
                    tileMultiple:(resultSet.double(forColumn: TILE_MULTIPLE)),
                    colorInfo:resultSet.string(forColumn: COLOR_INFO) ?? "",
                    imageWidth:Double(resultSet.int(forColumn: IMAGE_WIDTH)),
                    imageHeight:Double(resultSet.int(forColumn: IMAGE_HEIGHT)),
                    sourceTYPE: resultSet.string(forColumn: SOURCE_TYPE) ?? ""
                )
             
            }
        } catch let error {
            DBManager.logger?.printLog("Error getting image model: \(error.localizedDescription)")
        }

        return image
    }

    func getImage(imageId: Int) -> DBImageModel? {
        let query = "SELECT * FROM \(TABLE_IMAGE) WHERE \(IMAGE_ID) = \(imageId) ;"
        var image: DBImageModel? = nil

        do {
//            print(query)
            let resultSet = try runQuery(query, values: [imageId])
            while resultSet.next() {
                image = DBImageModel(
                    imageID:Int(resultSet.int(forColumn: IMAGE_ID)),
                    imageType:resultSet.string(forColumn: IMAGE_TYPE) ?? "",
                    serverPath:resultSet.string(forColumn: SERVER_PATH) ?? "",
                    localPath:resultSet.string(forColumn: LOCAL_PATH) ?? "",
                    resID:resultSet.string(forColumn: RES_ID) ?? "",
                    isEncrypted:Int(resultSet.int(forColumn: IS_ENCRYPTED)),
                    cropX:(resultSet.double(forColumn: CROP_X)),
                    cropY:(resultSet.double(forColumn: CROP_Y)),
                    cropW:(resultSet.double(forColumn: CROP_W)),
                    cropH:(resultSet.double(forColumn: CROP_H)),
                    cropStyle:Int(resultSet.int(forColumn: CROP_STYLE)),
                    tileMultiple:(resultSet.double(forColumn: TILE_MULTIPLE)),
                    colorInfo:resultSet.string(forColumn: COLOR_INFO) ?? "",
                    imageWidth:Double(Int(resultSet.int(forColumn: IMAGE_WIDTH))),
                    imageHeight:Double(resultSet.int(forColumn: IMAGE_HEIGHT)),
                    templateID: Int(resultSet.int(forColumn: TEMPLATE_ID)),
                    sourceTYPE: resultSet.string(forColumn: SOURCE_TYPE) ?? "BUNDLE"
                )
             
            }
        } catch let error {
            DBManager.logger?.printLog("Error getting image: \(error.localizedDescription)")
        }

        return image
    }

    func getImagePathCount(imageId: Int, imagePath: String) -> Int {
        let query = "SELECT COUNT(IMAGE_TYPE) FROM \(TABLE_IMAGE) WHERE \(LOCAL_PATH) LIKE '\(imagePath)%' AND \(IMAGE_ID) != \(imageId);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return 0
        }
        if resultSet.next() {
            return Int(resultSet.long(forColumnIndex: 0))
        }
        return 0
    }
    
    func checkIfEventIdAndTemplateJsonExist(eventId: Int, templateJsonPath: String) -> Bool{
        let query = "SELECT COUNT(*) FROM \(TABLE_TEMPLATE) WHERE \(EVENT_ID) = ? AND \(EVENT_TEMPLATE_JSON) = ?;"
        guard let resultSet = try? runQuery(query, values: [eventId, templateJsonPath]) else {
            return false
        }
        if resultSet.next() {
            return resultSet.long(forColumnIndex: 0) > 0
        }
        return false
    }
    
    func fetchTemplateIdFromEventId(eventId: Int) -> Int?{
        let query = "SELECT \(TEMPLATE_ID) FROM \(TABLE_TEMPLATE) WHERE \(EVENT_ID) = ?;"
        
        guard let resultSet = try? runQuery(query, values: [eventId]) else {
            return nil
        }
        
        if resultSet.next() {
            return Int(resultSet.int(forColumn: TEMPLATE_ID))
        }
        
        return nil
    }
    
    func isTemplatePublishedAndInAllowedCategory(templateId: Int) -> Bool {
        let query = "SELECT COUNT(*) FROM \(TABLE_TEMPLATE) WHERE \(TEMPLATE_ID) = ? AND \(TEMPLATE_EVENT_STATUS) = 'PUBLISHED' AND \(CATEGORY) IN ('SAVED', 'EVENT', 'TEMPLATE');"
        
        guard let resultSet = try? runQuery(query, values: [templateId]) else {
            return false
        }

        if resultSet.next() {
            return resultSet.long(forColumnIndex: 0) > 0
        }

        return false
    }
    
    func isTemplatePublishedAndInAllowedCategory(eventId: Int) -> Bool {
        let query = "SELECT COUNT(*) FROM \(TABLE_TEMPLATE) WHERE \(EVENT_ID) = ? AND \(TEMPLATE_EVENT_STATUS) = 'PUBLISHED' AND \(CATEGORY) IN ('SAVED', 'EVENT', 'TEMPLATE');"
        
        guard let resultSet = try? runQuery(query, values: [eventId]) else {
            return false
        }

        if resultSet.next() {
            return resultSet.long(forColumnIndex: 0) > 0
        }

        return false
    }
    
    func fetchTemplateIdsForSoftDelete() -> [Int]{
            var templateIds = [Int]()
        let query = "SELECT \(TEMPLATE_ID) FROM \(TABLE_TEMPLATE) WHERE \(SOFT_DELETE) = 0;"

        guard let resultSet = try? runQuery(query, values: nil) else {
                return templateIds
            }

            while resultSet.next() {
                var id: Int
                id = Int(resultSet.string(forColumn: TEMPLATE_ID) ?? "") ?? 0

                templateIds.append(id)
            }

            return templateIds
    }

    func checkIfFileUsed(fileName: String) -> Int{
        let query = "SELECT COUNT(LOCAL_PATH) FROM \(TABLE_IMAGE) WHERE \(LOCAL_PATH) = '\(fileName)';"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return 0
        }
        if resultSet.next() {
            return Int(resultSet.long(forColumnIndex: 0))
        }
        return 0
    }
    
    func checkIfMusicUsed(fileName: String) -> Int{
        let query = "SELECT COUNT(MUSIC_PATH) FROM \(TABLE_MUSICINFO) WHERE \(MUSIC_PATH) = '\(fileName)';"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return 0
        }
        if resultSet.next() {
            return Int(resultSet.long(forColumnIndex: 0))
        }
        return 0
    }
    func getMusicPathCount(musicId: Int, imagePath: String) -> Int {
        let query = "SELECT COUNT(MUSIC_TYPE) FROM \(TABLE_MUSICINFO) WHERE \(MUSIC_PATH) LIKE '\(imagePath)%' AND \(MUSIC_ID) != \(musicId);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return 0
        }
        if resultSet.next() {
            return Int(resultSet.long(forColumnIndex: 0))
        }
        return 0
    }

    func getPagesCountInTemplate(templateId: Int) -> Int {
        let query = "SELECT COUNT(\(MODEL_ID)) FROM \(TABLE_BASEMODEL) WHERE \(PARENT_ID) = \(templateId) AND \(SOFT_DELETE) = 0 AND \(MODEL_TYPE) = 'PAGE' GROUP BY \(PARENT_ID);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return 0
        }
        if resultSet.next() {
            return Int(resultSet.long(forColumnIndex: 0))
        }
        return 0
    }

    func getTemplateCountInCategory(categoryName: String) -> Int {
        let query = "SELECT COUNT(\(TEMPLATE_ID)) FROM \(TABLE_TEMPLATE) WHERE \(CATEGORY) = '\(categoryName)' GROUP BY \(TEMPLATE_ID);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return 0
        }
        if resultSet.next() {
            return Int(resultSet.long(forColumnIndex: 0))
        }
        return 0
    }
 

//    func getBaseModel(modelId: Int) -> BaseModel? {
//        let query = "SELECT * FROM \(TABLE_BASEMODEL) WHERE \(MODEL_ID) = \(modelId);"
//        guard let resultSet = try? runQuery(query, values: nil) else {
//            return nil
//        }
//        if resultSet.next() {
//            return createBaseModelFromResultSet(resultSet)
//        }
//        return nil
//    }
//
    func getChildAndParentModelListOfParent(parentId: Int) -> [DBBaseModel] {
        var baseModels = [DBBaseModel]()
        let query = "SELECT * FROM \(TABLE_BASEMODEL) WHERE \(PARENT_ID) = \(parentId) AND \(SOFT_DELETE) = 0 AND \(MODEL_TYPE) != 'PAGE' ORDER BY \(ORDER_IN_PARENT) ASC;"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return baseModels
        }
        while resultSet.next() {
            if let baseModel = createBaseModelFromResultSet(resultSet){
                baseModels.append(baseModel)
            }
        }
        return baseModels
    }
//
    func getSoftDeletedChildAndParentModelList() -> [DBBaseModel] {
        var baseModels = [DBBaseModel]()
        let query = "SELECT * FROM \(TABLE_BASEMODEL) WHERE \(SOFT_DELETE) = 1 AND \(MODEL_TYPE) != 'PAGE' ORDER BY \(MODEL_ID) ASC;"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return baseModels
        }
        while resultSet.next() {
            if let baseModel = createBaseModelFromResultSet(resultSet){
                baseModels.append(baseModel)
            }
        }
        return baseModels
    }
    
    

    private func createBaseModelFromResultSet(_ cursor: FMResultSet) -> DBBaseModel? {
        let modelId = cursor.int(forColumn: MODEL_ID)
//        guard let modelType = cursor.string(forColumn: MODEL_TYPE)else {
//            return nil
//        }
//        let dataId = cursor.int(forColumn: DATA_ID)
//
//        var baseModel: BaseModel?
//        if modelType == "IMAGE" {
//            if dataId != NO_DATA {
//                baseModel = getStickerModel(stickerId: Int(dataId))
//            }
//            if baseModel == nil {
//                baseModel = StickerModel()
//            }
//        } else if modelType == "TEXT" {
//            if dataId != NO_DATA {
//                baseModel = getTextModel(textId: Int(dataId))
//            }
//            if baseModel == nil {
//                baseModel = TextModel()
//            }
//        }
//
//        else {
//            baseModel = BaseModel()
//        }

       var baseModel = DBBaseModel()
        baseModel.modelId = Int(modelId)
        baseModel.modelType = cursor.string(forColumn: MODEL_TYPE) ?? ""
        baseModel.dataId = Int(cursor.int(forColumn: DATA_ID))
        baseModel.posX = cursor.double(forColumn: POS_X)
        baseModel.posY = cursor.double(forColumn: POS_Y)
        baseModel.width = cursor.double(forColumn: WIDTH)
        baseModel.height = cursor.double(forColumn: HEIGHT)
        baseModel.prevAvailableWidth = cursor.double(forColumn: PREV_AVAILABLE_WIDTH)
        baseModel.prevAvailableHeight = cursor.double(forColumn: PREV_AVAILABLE_HEIGHT)
        baseModel.rotation = cursor.double(forColumn: ROTATION)
        baseModel.modelOpacity = cursor.double(forColumn: MODEL_OPACITY)
        baseModel.modelFlipHorizontal = Int(cursor.int(forColumn: MODEL_FLIP_HORIZONTAL))
        baseModel.modelFlipVertical = Int(cursor.int(forColumn: MODEL_FLIP_VERTICAL))
        baseModel.lockStatus = cursor.string(forColumn: LOCK_STATUS) ?? ""
        baseModel.orderInParent = Int(cursor.int(forColumn: ORDER_IN_PARENT))
        baseModel.parentId = Int(cursor.int(forColumn: PARENT_ID))
        baseModel.bgBlurProgress = Int(cursor.int(forColumn: BG_BLUR_PROGRESS))
        baseModel.overlayDataId = Int(cursor.int(forColumn: OVERLAY_DATA_ID))
        baseModel.overlayOpacity = Int(cursor.int(forColumn: OVERLAY_OPACITY))
        baseModel.startTime = cursor.double(forColumn: START_TIME)
        baseModel.duration = cursor.double(forColumn: DURATION)
        baseModel.softDelete = Int(cursor.int(forColumn: SOFT_DELETE))
        baseModel.templateID = Int(cursor.int(forColumn: TEMPLATE_ID))
        baseModel.filterType =  Int(cursor.int(forColumn: FILTER_TYPE))
        baseModel.brightnessIntensity = Float(cursor.floatValue(forColumn: BRIGHTNESS))
        baseModel.contrastIntensity = Float(cursor.floatValue(forColumn: CONTRAST))
        baseModel.highlightIntensity = Float(cursor.floatValue(forColumn: HIGHLIGHT))
        baseModel.shadowsIntensity = Float(cursor.floatValue(forColumn: SHADOWS))
        baseModel.saturationIntensity = Float(cursor.floatValue(forColumn: SATURATION))
        baseModel.vibranceIntensity = Float(cursor.floatValue(forColumn: VIBRANCE))
        baseModel.sharpnessIntensity = Float(cursor.floatValue(forColumn: SHARPNESS))
        baseModel.warmthIntensity = Float(cursor.floatValue(forColumn: WARMTH))
        baseModel.tintIntensity = Float(cursor.floatValue(forColumn: TINT))
        baseModel.hasMask = Int(cursor.int(forColumn: HAS_MASK))
        baseModel.maskShape = cursor.string(forColumn: MASK_SHAPE) ?? ""

        
        if baseModel.width == 0 || baseModel.height == 0 {
            DBManager.logger?.logError("Model Size Not Right \(baseModel)")
            return nil
        }

        return baseModel
    }

    func getBaseModelFromDB(modelId:Int)->DBBaseModel?{
        let query = "SELECT * FROM \(TABLE_BASEMODEL) WHERE \(MODEL_ID) = ?"
        guard let resultSet = try? runQuery(query, values: [modelId]) else {
            return nil
        }

        var baseModel = DBBaseModel()
        if resultSet.next() {

            baseModel.modelId = Int(resultSet.int(forColumn: MODEL_ID))
            baseModel.modelType = resultSet.string(forColumn: MODEL_TYPE) ?? ""
            baseModel.dataId = Int(resultSet.int(forColumn: DATA_ID))
            baseModel.posX = resultSet.double(forColumn: POS_X)
            baseModel.posY = resultSet.double(forColumn: POS_Y)
            baseModel.width = resultSet.double(forColumn: WIDTH)
            baseModel.height = resultSet.double(forColumn: HEIGHT)
            baseModel.prevAvailableWidth = resultSet.double(forColumn: PREV_AVAILABLE_WIDTH)
            baseModel.prevAvailableHeight = resultSet.double(forColumn: PREV_AVAILABLE_HEIGHT)
            baseModel.rotation = (resultSet.double(forColumn: ROTATION))
            baseModel.modelOpacity = (resultSet.double(forColumn: MODEL_OPACITY))
            baseModel.modelFlipHorizontal = Int(resultSet.int(forColumn: MODEL_FLIP_HORIZONTAL))
            baseModel.modelFlipVertical = Int(resultSet.int(forColumn: MODEL_FLIP_VERTICAL))
            baseModel.lockStatus = resultSet.string(forColumn: LOCK_STATUS) ?? ""
            baseModel.orderInParent = Int(resultSet.int(forColumn: ORDER_IN_PARENT))
            baseModel.parentId = Int(resultSet.int(forColumn: PARENT_ID))
            baseModel.bgBlurProgress = Int(resultSet.int(forColumn: BG_BLUR_PROGRESS))
            baseModel.overlayDataId = Int(resultSet.int(forColumn: OVERLAY_DATA_ID))
            baseModel.overlayOpacity = Int(resultSet.int(forColumn: OVERLAY_OPACITY))
            baseModel.startTime = resultSet.double(forColumn: START_TIME)
            baseModel.duration = resultSet.double(forColumn: DURATION)
            baseModel.softDelete = Int(resultSet.int(forColumn: SOFT_DELETE))
            baseModel.templateID  = Int(resultSet.int(forColumn: TEMPLATE_ID))
            baseModel.filterType = Int(resultSet.int(forColumn: FILTER_TYPE))
            baseModel.brightnessIntensity = Float(resultSet.int(forColumn: BRIGHTNESS))
            baseModel.contrastIntensity = Float(resultSet.int(forColumn: CONTRAST))
            baseModel.highlightIntensity = Float(resultSet.int(forColumn: HIGHLIGHT))
            baseModel.shadowsIntensity = Float(resultSet.int(forColumn: SHADOWS))
            baseModel.saturationIntensity = Float(resultSet.int(forColumn: SATURATION))
            baseModel.vibranceIntensity = Float(resultSet.int(forColumn: VIBRANCE))
            baseModel.sharpnessIntensity = Float(resultSet.int(forColumn: SHARPNESS))
            baseModel.warmthIntensity = Float(resultSet.int(forColumn: WARMTH))
            baseModel.tintIntensity = Float(resultSet.int(forColumn: TINT))
            baseModel.hasMask = Int(resultSet.int(forColumn: HAS_MASK))
            baseModel.maskShape = resultSet.string(forColumn: MASK_SHAPE) ?? ""

        }
        return baseModel
    }
    
    func getStickerModel(stickerId: Int) -> DBStickerModel? {
        var stickerDbModel: DBStickerModel?

        let query = "SELECT * FROM \(TABLE_STICKER) WHERE \(STICKER_ID) = ?"
        guard let resultSet = try? runQuery(query, values: [stickerId]) else {
            return nil
        }
        if resultSet.next() {
            stickerDbModel = DBStickerModel()
            let imageId = resultSet.int(forColumn: IMAGE_ID)
            stickerDbModel?.stickerId = Int(resultSet.int(forColumn: STICKER_ID))
            stickerDbModel?.imageId = Int(imageId)
//             stickerDbModel?.FLIP_ANGLE = resultSet.int(forColumn: FLIP_ANGLE)
            stickerDbModel?.stickerType = resultSet.string(forColumn: STICKER_TYPE) ?? ""
            stickerDbModel?.stickerFilterType = Int(resultSet.int(forColumn: STICKER_FILTER_TYPE))
            stickerDbModel?.stickerHue = Int(resultSet.int(forColumn: STICKER_HUE))
            stickerDbModel?.stickerColor = resultSet.string(forColumn: STICKER_COLOR) ?? ""
            stickerDbModel?.xRotationProg = Int(resultSet.int(forColumn: X_ROATATION_PROG))
            stickerDbModel?.yRotationProg = Int(resultSet.int(forColumn: Y_ROATATION_PROG))
            stickerDbModel?.zRotationProg = Int(resultSet.int(forColumn: Z_ROATATION_PROG))
            stickerDbModel?.stickerModelType = resultSet.string(forColumn: STICKER_MODEL_TYPE) ?? ""
        }
        return stickerDbModel
    }
    
    func getAllStickerModel() -> [DBStickerModel]{
        var stickerModelArray = [DBStickerModel]()
        
        let query = "SELECT * FROM  \(TABLE_STICKER);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return stickerModelArray
        }
        
        while resultSet.next() {
            var stickerDbModel = DBStickerModel()
//            stickerDbModel = DBStickerModel()
            let imageId = resultSet.int(forColumn: IMAGE_ID)
            stickerDbModel.stickerId = Int(resultSet.int(forColumn: STICKER_ID))
            stickerDbModel.imageId = Int(imageId)
//             stickerDbModel?.FLIP_ANGLE = resultSet.int(forColumn: FLIP_ANGLE)
            stickerDbModel.stickerType = resultSet.string(forColumn: STICKER_TYPE) ?? ""
            stickerDbModel.stickerFilterType = Int(resultSet.int(forColumn: STICKER_FILTER_TYPE))
            stickerDbModel.stickerHue = Int(resultSet.int(forColumn: STICKER_HUE))
            stickerDbModel.stickerColor = resultSet.string(forColumn: STICKER_COLOR) ?? ""
            stickerDbModel.xRotationProg = Int(resultSet.int(forColumn: X_ROATATION_PROG))
            stickerDbModel.yRotationProg = Int(resultSet.int(forColumn: Y_ROATATION_PROG))
            stickerDbModel.zRotationProg = Int(resultSet.int(forColumn: Z_ROATATION_PROG))
            stickerDbModel.stickerModelType = resultSet.string(forColumn: STICKER_MODEL_TYPE) ?? ""
            stickerModelArray.append(stickerDbModel)
        }
        return stickerModelArray
    }


//    func getParentModel(id: Int) -> ParentDbModel? {
//        var parentDbModel: ParentDbModel?
//
//        let query = "SELECT * FROM \(TABLE_PARENT_MODEL) WHERE \(ID) = \(id);"
//        guard let resultSet = try? runQuery(query: query) else {
//            return nil
//        }
//        if resultSet.next() {
//            parentDbModel = ParentDbModel()
//            let imageId = resultSet.int(forColumn: BG_IMAGE_ID)
//            parentDbModel?.ID = Int(resultSet.int(forColumn: ID))
//            parentDbModel?.BG_IMAGE_ID = Int(imageId)
//            parentDbModel?.COLOR_TYPE = Int(resultSet.int(forColumn: COLOR_TYPE))
//            parentDbModel?.PARENT_HUE = Int(resultSet.int(forColumn: PARENT_HUE))
//            parentDbModel?.PARENT_COLOR = Int(resultSet.int(forColumn: PARENT_COLOR))
//        }
//        return parentDbModel
//    }
    
    func getAllTextModel() -> [DBTextModel]{
        var textModelArray = [DBTextModel]()
        
        let query = "SELECT * FROM  \(TABLE_TEXT_MODEL);"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return textModelArray
        }
        
        while resultSet.next() {
            var textDbModel = DBTextModel()
            textDbModel.textId = Int(resultSet.int(forColumn: TEXT_ID))
            textDbModel.text = resultSet.string(forColumn: TEXT) ?? ""
            textDbModel.textFont = resultSet.string(forColumn: TEXT_FONT) ?? ""
            textDbModel.textColor = resultSet.string(forColumn: TEXT_COLOR) ?? ""
            // textDbModel?.TEXT_OPACITY = Int(resultSet.int(forColumn: TEXT_OPACITY))
            textDbModel.textGravity = resultSet.string(forColumn: TEXT_GRAVITY) ?? ""
            textDbModel.lineSpacing = resultSet.double(forColumn: LINE_SPACING)
            textDbModel.letterSpacing = resultSet.double(forColumn: LETTER_SPACING)
            textDbModel.shadowColor = resultSet.string(forColumn: SHADOW_COLOR) ?? ""
            textDbModel.shadowOpacity = Int(resultSet.int(forColumn: SHADOW_OPACITY))
            textDbModel.shadowRadius = resultSet.double(forColumn: SHADOW_RADIUS)
            textDbModel.shadowDx = resultSet.double(forColumn: SHADOW_Dx)
            textDbModel.shadowDy = resultSet.double(forColumn: SHADOW_Dy)
            textDbModel.bgType = Int(resultSet.int(forColumn: BG_TYPE))
            textDbModel.bgDrawable = resultSet.string(forColumn: BG_DRAWABLE) ?? ""
            textDbModel.bgColor = resultSet.string(forColumn: BG_COLOR) ?? ""
            textDbModel.bgAlpha = resultSet.double(forColumn: BG_ALPHA)
            textDbModel.internalHeightMargin = resultSet.double(forColumn: INTERNAL_HEIGHT_MARGIN)
            textDbModel.internalWidthMargin = resultSet.double(forColumn: INTERNAL_WIDTH_MARGIN)
            textDbModel.xRotationProg = Int(resultSet.int(forColumn: X_ROATATION_PROG))
            textDbModel.yRotationProg = Int(resultSet.int(forColumn: Y_ROATATION_PROG))
            textDbModel.zRotationProg = Int(resultSet.int(forColumn: Z_ROATATION_PROG))
            textDbModel.curveProg = Int(resultSet.int(forColumn: CURVE_PROG))
            textDbModel.templateID = Int(resultSet.int(forColumn: TemplateID))
            
            textModelArray.append(textDbModel)
        }
        
        return textModelArray
    }

    func getTextModel(textId: Int) -> DBTextModel? {
        var textDbModel: DBTextModel?

        let query = "SELECT * FROM \(TABLE_TEXT_MODEL) WHERE \(TEXT_ID) = \(textId)"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }
        if resultSet.next() {
            textDbModel = DBTextModel()
            textDbModel?.textId = Int(resultSet.int(forColumn: TEXT_ID))
            textDbModel?.text = resultSet.string(forColumn: TEXT) ?? ""
            textDbModel?.textFont = resultSet.string(forColumn: TEXT_FONT) ?? ""
            textDbModel?.textColor = resultSet.string(forColumn: TEXT_COLOR) ?? ""
            // textDbModel?.TEXT_OPACITY = Int(resultSet.int(forColumn: TEXT_OPACITY))
            textDbModel?.textGravity = resultSet.string(forColumn: TEXT_GRAVITY) ?? ""
            textDbModel?.lineSpacing = resultSet.double(forColumn: LINE_SPACING)
            textDbModel?.letterSpacing = resultSet.double(forColumn: LETTER_SPACING)
            textDbModel?.shadowColor = resultSet.string(forColumn: SHADOW_COLOR) ?? ""
            textDbModel?.shadowOpacity = Int(resultSet.int(forColumn: SHADOW_OPACITY))
            textDbModel?.shadowRadius = resultSet.double(forColumn: SHADOW_RADIUS)
            textDbModel?.shadowDx = resultSet.double(forColumn: SHADOW_Dx)
            textDbModel?.shadowDy = resultSet.double(forColumn: SHADOW_Dy)
            textDbModel?.bgType = Int(resultSet.int(forColumn: BG_TYPE))
            textDbModel?.bgDrawable = resultSet.string(forColumn: BG_DRAWABLE) ?? ""
            textDbModel?.bgColor = resultSet.string(forColumn: BG_COLOR) ?? ""
            textDbModel?.bgAlpha = resultSet.double(forColumn: BG_ALPHA)
            textDbModel?.internalHeightMargin = resultSet.double(forColumn: INTERNAL_HEIGHT_MARGIN)
            textDbModel?.internalWidthMargin = resultSet.double(forColumn: INTERNAL_WIDTH_MARGIN)
            textDbModel?.xRotationProg = Int(resultSet.int(forColumn: X_ROATATION_PROG))
            textDbModel?.yRotationProg = Int(resultSet.int(forColumn: Y_ROATATION_PROG))
            textDbModel?.zRotationProg = Int(resultSet.int(forColumn: Z_ROATATION_PROG))
            textDbModel?.curveProg = Int(resultSet.int(forColumn: CURVE_PROG))
            textDbModel?.templateID = Int(resultSet.int(forColumn: TemplateID))
        }
        return textDbModel
    }
    
    func getFontsForTemplate(templateID : Int) -> [String] {
        var fontList = [String]()

        let query = "SELECT DISTINCT \(TEXT_FONT) FROM \(TABLE_TEXT_MODEL) WHERE \(TEMPLATE_ID) = \(templateID)"//
        guard let resultSet = try? runQuery(query, values: nil) else {
            return fontList
        }

        while resultSet.next() {
            var font: String
            font = resultSet.string(forColumn: TEXT_FONT) ?? ""
            fontList.append(font)
        }
        return fontList
    }
    

//    func getAnimationCategories(animationType: AnimeType) -> [AnimationCategoriesModel] {
//        var animationCategories = [AnimationCategoriesModel]()
//        let query = "SELECT ANIMATION_CATEGORIES_ID, ANIMATION_CATEGORIES.NAME AS CATEGORY_NAME, ANIMATION_CATEGORIES.ICON, " +
//                    "ANIMATION_TEMPLATE.ANIMATION_TEMPLATE_ID , ANIMATION_TEMPLATE.NAME , ANIMATION_TEMPLATE.ICON,ANIMATION_TEMPLATE.DURATION  " +
//                    "FROM ANIMATION_CATEGORIES , ANIMATION_TEMPLATE WHERE ANIMATION_TEMPLATE.CATEGORY = ANIMATION_CATEGORIES_ID AND ANIMATION_CATEGORIES.ENABLED = 1 AND (ANIMATION_TEMPLATE.TYPE = 'ANY' OR " +
//                    "ANIMATION_TEMPLATE.TYPE = '\(animationType)') " +
//                    "ORDER BY ANIMATION_CATEGORIES.ANIMATION_CATEGORIES_ID;"
//        guard let resultSet = try? runQuery(query, values: nil) else {
//            return animationCategories
//        }
//        var lastCategoryId = -1
//        var animationCategory: AnimationCategoriesModel?
//        while resultSet.next() {
//            animationCategory?.animationCategoriesId = Int(resultSet.int(forColumnIndex: 0))
//             animationCategory?.name = resultSet.string(forColumnIndex: 1) ?? ""
//            animationCategory?.icon = resultSet.string(forColumnIndex: 2) ?? ""
//             animationTemplateId = resultSet.int(forColumnIndex: 3)
//             animationTemplateName = resultSet.string(forColumnIndex: 4) ?? ""
//             animationTemplateIcon = resultSet.string(forColumnIndex: 5) ?? ""
//             defaultAnimDuration = resultSet.double(forColumnIndex: 6)
//
//            if lastCategoryId != categoryId {
//                guard let anmCat = animationCategory else{return}
//                animationCategories.append(anmCat)
//                lastCategoryId = categoryId
//            }
//            if animationCategory != nil {
//                animationCategory?.insertAnimationTemplateInCategory(animationTemplateId: animationTemplateId, animationTemplateName: animationTemplateName, animationTemplateIcon: animationTemplateIcon, defaultAnimDuration: defaultAnimDuration)
//            } else {
//                fatalError("HOW COME ANIMATION IS NULL")
//            }
//        }
//        return animationCategories
//    }
//
    
    /*
     func getAnmation(modelId)->AnimationModel
     func getAnimationCategory(id)->
     func getanimationmodel(id)->
     */
    
    
    /*
     DB>mediatir
     
     func getMyAnimation(modelID) -> AnimationModel
     func getAnmation(modelId)->AnimationModel
     func getAnmation(modelId)->AnimationModel
     func getAnmation(modelId)->AnimationModel
     
     */

//    func getAnimationDetailsForAnimationTemplateId(animationTemplateId: Int) -> AnimationTemplateModel? {
//        var animationDetails = AnimationTemplateModel()
//        let query = "SELECT ANIMATION_TEMPLATE_ID, NAME, TYPE, CATEGORY, DURATION, IS_LOOP_ENABLED, IS_AUTO_REVERSE, ICON " +
//                    "FROM ANIMATION_TEMPLATE WHERE ANIMATION_TEMPLATE_ID = \(animationTemplateId);"
//        guard let resultSet = try? runQuery(query, values: <#[Any]?#>) else {
//            return nil
//        }
//        if resultSet.next() {
//            animationDetails.ANIMATION_TEMPLATE_ID = resultSet.int(forColumn: 0)
//            animationDetails.NAME = resultSet.string(forColumn: 1) ?? ""
//            animationDetails.TYPE = resultSet.string(forColumn: 2) ?? ""
//            animationDetails.CATEGORY = resultSet.string(forColumn: 3) ?? ""
//            animationDetails.DURATION = resultSet.double(forColumn: 4)
//            animationDetails.IS_LOOP_ENABLED = Int(resultSet.int(forColumn: 5))
//            animationDetails.IS_AUTO_REVERSE = Int(resultSet.int(forColumn: 6))
//            animationDetails.ICON = resultSet.string(forColumn: 7) ?? ""
//
//            var keyFrames = [KeyFrame]()
//            let keyFramesQuery = "SELECT KEYFRAME_ID, ANIMATION_TEMPLATE_ID, KEYTIME, TRANSLATION_X, TRANSLATION_Y, SCALE_X, SCALE_Y, ROTATION_X, ROTATION_Y, ROTATION_Z, SKEW_X, SKEW_Y, " +
//                                "OPACITY, EFFECT_PROGRESS, EASING_FUNCTION, TRANSLATION_RELATIVE_TO, SCALE_ANCHOR_X, SCALE_ANCHOR_Y, SCALE_ANCHOR_RELATIVE_TO, ROTATION_X_ANCHOR_X, " +
//                                "ROTATION_X_ANCHOR_Y, ROTATION_X_ANCHOR_RELATIVE_TO, ROTATION_Y_ANCHOR_X, ROTATION_Y_ANCHOR_Y, ROTATION_Y_ANCHOR_RELATIVE_TO, " +
//                                "ROTATION_Z_ANCHOR_X, ROTATION_Z_ANCHOR_Y, ROTATION_Z_ANCHOR_RELATIVE_TO, SKEW_ANCHOR_X, SKEW_ANCHOR_Y, SKEW_ANCHOR_RELATIVE_TO, SHADER " +
//                                "FROM KEYFRAMES WHERE ANIMATION_TEMPLATE_ID = \(animationTemplateId);"
//            guard let keyFrameResultSet = try? runQuery(query: keyFramesQuery) else {
//                animationDetails.keyFrames = keyFrames
//                return animationDetails
//            }
//            while keyFrameResultSet.next() {
//                var keyFrame = AnimKeyframeModel()
//                keyFrame.KEYFRAME_ID = keyFrameResultSet.int(forColumn: 0)
//                keyFrame.ANIMATION_TEMPLATE_ID = keyFrameResultSet.int(forColumn: 1)
//                keyFrame.KEYTIME = keyFrameResultSet.double(forColumn: 2)
//                keyFrame.TRANSLATION_X = keyFrameResultSet.double(forColumn: 3)
//                keyFrame.TRANSLATION_Y = keyFrameResultSet.double(forColumn: 4)
//                keyFrame.SCALE_X = keyFrameResultSet.double(forColumn: 5)
//                keyFrame.SCALE_Y = keyFrameResultSet.double(forColumn: 6)
//                keyFrame.ROTATION_X = keyFrameResultSet.double(forColumn: 7)
//                keyFrame.ROTATION_Y = keyFrameResultSet.double(forColumn: 8)
//                keyFrame.ROTATION_Z = keyFrameResultSet.double(forColumn: 9)
//                keyFrame.SKEW_X = keyFrameResultSet.double(forColumn: 10)
//                keyFrame.SKEW_Y = keyFrameResultSet.double(forColumn: 11)
//                keyFrame.OPACITY = keyFrameResultSet.double(forColumn: 12)
//                keyFrame.EFFECT_PROGRESS = keyFrameResultSet.double(forColumn: 13)
//                keyFrame.EASING_FUNCTION = keyFrameResultSet.string(forColumn: 14) ?? ""
//                keyFrame.TRANSLATION_RELATIVE_TO = keyFrameResultSet.double(forColumn: 15)
//                keyFrame.SCALE_ANCHOR_X = keyFrameResultSet.double(forColumn: 16)
//                keyFrame.SCALE_ANCHOR_Y = keyFrameResultSet.double(forColumn: 17)
//                keyFrame.SCALE_ANCHOR_RELATIVE_TO = keyFrameResultSet.double(forColumn: 18)
//                keyFrame.ROTATION_X_ANCHOR_X = keyFrameResultSet.double(forColumn: 19)
//                keyFrame.ROTATION_X_ANCHOR_Y = keyFrameResultSet.double(forColumn: 20)
//                keyFrame.ROTATION_X_ANCHOR_RELATIVE_TO = keyFrameResultSet.double(forColumn: 21)
//                keyFrame.ROTATION_Y_ANCHOR_X = keyFrameResultSet.double(forColumn: 22)
//                keyFrame.ROTATION_Y_ANCHOR_Y = keyFrameResultSet.double(forColumn: 23)
//                keyFrame.ROTATION_Y_ANCHOR_RELATIVE_TO = keyFrameResultSet.double(forColumn: 24)
//                keyFrame.ROTATION_Z_ANCHOR_X = keyFrameResultSet.double(forColumn: 25)
//                keyFrame.ROTATION_Z_ANCHOR_Y = keyFrameResultSet.double(forColumn: 26)
//                keyFrame.ROTATION_Z_ANCHOR_RELATIVE_TO = keyFrameResultSet.double(forColumn: 27)
//                keyFrame.SKEW_ANCHOR_X = keyFrameResultSet.double(forColumn: 28)
//                keyFrame.SKEW_ANCHOR_Y = keyFrameResultSet.double(forColumn: 29)
//                keyFrame.SKEW_ANCHOR_RELATIVE_TO = keyFrameResultSet.double(forColumn: 30)
//                keyFrame.SHADER = keyFrameResultSet.string(forColumn: 31) ?? ""
//                keyFrames.append(keyFrame)
//            }
//            animationDetails.keyFrames = keyFrames
//        }
//        return animationDetails
//    }

    func getAnimation(modelId: Int) -> DBAnimationModel {
        var animation = DBAnimationModel()
        let query = "SELECT * FROM \(TABLE_ANIMATION) WHERE \(MODEL_ID) = \(modelId)"
        guard let resultSet = try? runQuery(query, values: nil) else {
            print("No Animation Found , return default")
            return  DBAnimationModel()
        }
        if resultSet.next() {
           
            animation.animationId = Int(resultSet.int(forColumn: ANIMATION_ID))
            animation.modelId = Int(resultSet.int(forColumn: MODEL_ID))
            animation.inAnimationTemplateId = Int(resultSet.int(forColumn: IN_ANIMATION_TEMPLATE_ID))
            animation.inAnimationDuration = Float(resultSet.floatValue(forColumn: IN_ANIMATION_DURATION))
            animation.loopAnimationTemplateId = Int(resultSet.int(forColumn: LOOP_ANIMATION_TEMPLATE_ID))
            animation.loopAnimationDuration = resultSet.floatValue(forColumn: LOOP_ANIMATION_DURATION)
            animation.outAnimationTemplateId = Int(resultSet.int(forColumn: OUT_ANIMATION_TEMPLATE_ID))
            animation.outAnimationDuration = resultSet.floatValue(forColumn: OUT_ANIMATION_DURATION)
            animation.templateID = Int(resultSet.floatValue(forColumn: TemplateID))

        }
        return animation
    }
    
    func getAllAnimationTemplate() -> [DBAnimationTemplateModel]{
        var animationTemplate = [DBAnimationTemplateModel]()
        let query = "SELECT * FROM \(TABLE_ANIMATION_TEMPLATE);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return animationTemplate
        }
         
        while resultSet.next() {
             
            var animation = DBAnimationTemplateModel()
            
            animation.animationTemplateId = Int(resultSet.int(forColumn: ANIMATION_TEMPLATE_ID))
            animation.name = resultSet.string(forColumn: NAME) ?? ""
            animation.type = resultSet.string(forColumn: TYPE) ?? ""
            animation.category = Int(resultSet.int(forColumn: CATEGORY))
            animation.duration = Float(Double(Int(resultSet.int(forColumn: DURATION))))
            animation.isLoopEnabled = Int(resultSet.int(forColumn: IsLoopEnabled))
            animation.isAutoReverse = Int(resultSet.int(forColumn: IsAutoReverse))
            animation.icon = resultSet.string(forColumn: ICON) ?? ""
            animationTemplate.append(animation)
        }
        
        return animationTemplate
    }
    
    func getAnimationCategory() -> [DBAnimationCategoriesModel]{
        var animationCategory = [DBAnimationCategoriesModel]()
        let query = "SELECT * FROM \(TABLE_ANIMATION_CATEGORIES) WHERE \(ENABLED)=1"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return animationCategory
        }
        
        while resultSet.next() {
            var animCategory = DBAnimationCategoriesModel()
            animCategory.animationCategoriesId = Int(resultSet.int(forColumn: ANIMATION_CATEGORIES_ID))
            animCategory.animationName = resultSet.string(forColumn: NAME) ?? ""
            animCategory.order = Int(resultSet.int(forColumn: ORDER_INDEX))
            animCategory.enabled = Int(resultSet.int(forColumn: ENABLED))
            
            animationCategory.append(animCategory)
        }
        return animationCategory
    }

    //Implement By Neeshu
    func getMusicInfo(templateID : Int) -> MusicInfo? {
        var musicInfoModel: MusicInfo?

        let query = "SELECT * FROM \(TABLE_MUSICINFO) WHERE \(TemplateID) = \(templateID)"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }

        if resultSet.next() {
            musicInfoModel = MusicInfo()
            musicInfoModel?.musicID = Int(resultSet.int(forColumn: MUSIC_ID))
            musicInfoModel?.musicType = resultSet.string(forColumn: MUSIC_TYPE) ?? ""
            musicInfoModel?.name = resultSet.string(forColumn: NAME) ?? ""
            musicInfoModel?.musicPath = resultSet.string(forColumn: MUSIC_PATH) ?? ""
            musicInfoModel?.parentID = Int(resultSet.int(forColumn: PARENT_ID))
            musicInfoModel?.parentType = Int(resultSet.int(forColumn: PARENT_TYPE))
            musicInfoModel?.startTimeOfAudio = resultSet.floatValue(forColumn: START_TIME_OF_AUDIO)
            musicInfoModel?.endTimeOfAudio = resultSet.floatValue(forColumn: END_TIME_OF_AUDIO)
            musicInfoModel?.startTime = resultSet.floatValue(forColumn: START_TIME)
            musicInfoModel?.duration = resultSet.floatValue(forColumn: DURATION)
        }
        return musicInfoModel
    }
    
    
    func getMusicInfo(musicID: Int) -> MusicInfo? {
        var musicInfoModel: MusicInfo?

        let query = "SELECT * FROM \(TABLE_MUSICINFO) WHERE \(MUSIC_ID) = \(musicID)"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }

        if resultSet.next() {
            musicInfoModel = MusicInfo()
            musicInfoModel?.musicID = Int(resultSet.int(forColumn: MUSIC_ID))
            musicInfoModel?.musicType = resultSet.string(forColumn: MUSIC_TYPE) ?? ""
            musicInfoModel?.name = resultSet.string(forColumn: NAME) ?? ""
            musicInfoModel?.musicPath = resultSet.string(forColumn: MUSIC_PATH) ?? ""
            musicInfoModel?.parentID = Int(resultSet.int(forColumn: PARENT_ID))
            musicInfoModel?.parentType = Int(resultSet.int(forColumn: PARENT_TYPE))
            musicInfoModel?.startTimeOfAudio = resultSet.floatValue(forColumn: START_TIME_OF_AUDIO)
            musicInfoModel?.endTimeOfAudio = resultSet.floatValue(forColumn: END_TIME_OF_AUDIO)
            musicInfoModel?.startTime = resultSet.floatValue(forColumn: START_TIME)
            musicInfoModel?.duration = resultSet.floatValue(forColumn: DURATION)
        }
        return musicInfoModel
    }
    
    func getAllMusicInfo() -> [MusicInfo]{
        var musicInfos = [MusicInfo]()
        
        let query = "SELECT * FROM \(TABLE_MUSICINFO)"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return musicInfos
        }
        
        while resultSet.next() {
            //if resultSet.next() {
            var musicInfo = MusicInfo()
             
            musicInfo.musicID = Int(resultSet.int(forColumn: MUSIC_ID))
            musicInfo.musicType = resultSet.string(forColumn: MUSIC_TYPE) ?? ""
            musicInfo.name = resultSet.string(forColumn: NAME) ?? ""
            musicInfo.musicPath = resultSet.string(forColumn: MUSIC_PATH) ?? ""
            musicInfo.parentID = Int(resultSet.int(forColumn: PARENT_ID))
            musicInfo.parentType = Int(resultSet.int(forColumn: PARENT_TYPE))
            musicInfo.startTimeOfAudio = resultSet.floatValue(forColumn: START_TIME_OF_AUDIO)
            musicInfo.endTimeOfAudio = resultSet.floatValue(forColumn: END_TIME_OF_AUDIO)
            musicInfo.startTime = resultSet.floatValue(forColumn: START_TIME)
            musicInfo.duration = resultSet.floatValue(forColumn: DURATION)
                
            musicInfos.append(musicInfo)
        }
        
        return musicInfos
    }

    func getMusicInfo(for parentID: Int, parentType: Int) -> MusicInfo? {
        var musicInfoModel: MusicInfo?

        let query = "SELECT * FROM \(TABLE_MUSICINFO) WHERE \(PARENT_ID) = \(parentID) AND \(PARENT_TYPE) = \(parentType)"
        guard let resultSet = try? runQuery(query, values: nil) else {
            return nil
        }

        if resultSet.next() {
            musicInfoModel = MusicInfo()
            musicInfoModel?.musicID = Int(resultSet.int(forColumn: MUSIC_ID))
            musicInfoModel?.musicType = resultSet.string(forColumn: MUSIC_TYPE) ?? ""
            musicInfoModel?.name = resultSet.string(forColumn: NAME) ?? ""
            musicInfoModel?.musicPath = resultSet.string(forColumn: MUSIC_PATH) ?? ""
            musicInfoModel?.parentID = Int(resultSet.int(forColumn: PARENT_ID))
            musicInfoModel?.parentType = Int(resultSet.int(forColumn: PARENT_TYPE))
            musicInfoModel?.startTimeOfAudio = resultSet.floatValue(forColumn: START_TIME_OF_AUDIO)
            musicInfoModel?.endTimeOfAudio = resultSet.floatValue(forColumn: END_TIME_OF_AUDIO)
            musicInfoModel?.startTime = resultSet.floatValue(forColumn: START_TIME)
            musicInfoModel?.duration = resultSet.floatValue(forColumn: DURATION)
        }
        return musicInfoModel
    }
    
    func getAllKEyFrameModel() -> [DBAnimKeyframeModel] {
        var keyframeModelArray = [DBAnimKeyframeModel]()

        let query = "SELECT * FROM \(TABLE_KEYFRAMES);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            DBManager.logger?.printLog("keyFrame Model not fetched")
            return keyframeModelArray
        }

        while resultSet.next() {
            var keyframeModel = DBAnimKeyframeModel()

            keyframeModel.keyframeId = Int(resultSet.int(forColumn: KEYFRAME_ID))
            keyframeModel.animationTemplateId = Int(resultSet.int(forColumn: ANIMATION_TEMPLATE_ID))
            keyframeModel.keytime = Float(resultSet.double(forColumn: KEYTIME))
            keyframeModel.translationX = Float(resultSet.double(forColumn: TRANSLATION_X))
            keyframeModel.translationY = Float(resultSet.double(forColumn: TRANSLATION_Y))
            keyframeModel.scaleX = Float(resultSet.double(forColumn: SCALE_X))
            keyframeModel.scaleY = Float(resultSet.double(forColumn: SCALE_Y))
            keyframeModel.rotationX = Float(resultSet.double(forColumn: ROTATION_X))
            keyframeModel.rotationY = Float(resultSet.double(forColumn: ROTATION_Y))
            keyframeModel.rotationZ = Float(resultSet.double(forColumn: ROTATION_Z))
            keyframeModel.skewX = Float(resultSet.double(forColumn: SKEW_X))
            keyframeModel.skewY = Float(resultSet.double(forColumn: SKEW_Y))
            keyframeModel.opacity = Float(resultSet.double(forColumn: OPACITY))
            keyframeModel.effectProgress = Float(resultSet.double(forColumn: EFFECT_PROGRESS))
            keyframeModel.easingFunction = resultSet.string(forColumn: EASING_FUNCTION) ?? ""
            keyframeModel.translationRelativeTo = Int(resultSet.int(forColumn: TRANSLATION_RELATIVE_TO))
            keyframeModel.scaleAnchorX = Float(resultSet.double(forColumn: SCALE_ANCHOR_X))
            keyframeModel.scaleAnchorY = Float(resultSet.double(forColumn: SCALE_ANCHOR_Y))
            keyframeModel.scaleAnchorRelativeTo = Int(resultSet.int(forColumn: SCALE_ANCHOR_RELATIVE_TO))
            keyframeModel.rotationXAnchorX = Float(resultSet.double(forColumn: ROTATION_X_ANCHOR_X))
            keyframeModel.rotationXAnchorY = Float(resultSet.double(forColumn: ROTATION_X_ANCHOR_Y))
            keyframeModel.rotationXAnchorRelativeTo = Int(resultSet.int(forColumn: ROTATION_X_ANCHOR_RELATIVE_TO))
            keyframeModel.rotationYAnchorX = Float(resultSet.double(forColumn: ROTATION_Y_ANCHOR_X))
            keyframeModel.rotationYAnchorY = Float(resultSet.double(forColumn: ROTATION_Y_ANCHOR_Y))
            keyframeModel.rotationYAnchorRelativeTo = Int(resultSet.int(forColumn: ROTATION_Y_ANCHOR_RELATIVE_TO))
            keyframeModel.rotationZAnchorX = Float(resultSet.double(forColumn: ROTATION_Z_ANCHOR_X))
            keyframeModel.rotationZAnchorY = Float(resultSet.double(forColumn: ROTATION_Z_ANCHOR_Y))
            keyframeModel.rotationZAnchorRelativeTo = Int(resultSet.int(forColumn: ROTATION_Z_ANCHOR_RELATIVE_TO))
            keyframeModel.skewAnchorX = Float(resultSet.double(forColumn: SKEW_ANCHOR_X))
            keyframeModel.skewAnchorY = Float(resultSet.double(forColumn: SKEW_ANCHOR_Y))
            keyframeModel.skewAnchorRelativeTo = Int(resultSet.int(forColumn: SKEW_ANCHOR_RELATIVE_TO))
            keyframeModel.shader = resultSet.string(forColumn: SHADER) ?? ""
            keyframeModelArray.append(keyframeModel)

        }
        return keyframeModelArray
    }

    func getKeyframeModel(for animationTemplateID: Int) -> [DBAnimKeyframeModel] {
        var keyframeModelArray = [DBAnimKeyframeModel]()

        let query = "SELECT * FROM \(TABLE_KEYFRAMES) WHERE \(ANIMATION_TEMPLATE_ID) = \(animationTemplateID);"
        guard let resultSet = try? runQuery(query, values: nil) else {
            DBManager.logger?.printLog("keyFrame Model not fetched")
            return keyframeModelArray
        }

        while resultSet.next() {
            var keyframeModel = DBAnimKeyframeModel()

            keyframeModel.keyframeId = Int(resultSet.int(forColumn: KEYFRAME_ID))
            keyframeModel.animationTemplateId = Int(resultSet.int(forColumn: ANIMATION_TEMPLATE_ID))
            keyframeModel.keytime = Float(resultSet.double(forColumn: KEYTIME))
            keyframeModel.translationX = Float(resultSet.double(forColumn: TRANSLATION_X))
            keyframeModel.translationY = Float(resultSet.double(forColumn: TRANSLATION_Y))
            keyframeModel.scaleX = Float(resultSet.double(forColumn: SCALE_X))
            keyframeModel.scaleY = Float(resultSet.double(forColumn: SCALE_Y))
            keyframeModel.rotationX = Float(resultSet.double(forColumn: ROTATION_X))
            keyframeModel.rotationY = Float(resultSet.double(forColumn: ROTATION_Y))
            keyframeModel.rotationZ = Float(resultSet.double(forColumn: ROTATION_Z))
            keyframeModel.skewX = Float(resultSet.double(forColumn: SKEW_X))
            keyframeModel.skewY = Float(resultSet.double(forColumn: SKEW_Y))
            keyframeModel.opacity = Float(resultSet.double(forColumn: OPACITY))
            keyframeModel.effectProgress = Float(resultSet.double(forColumn: EFFECT_PROGRESS))
            keyframeModel.easingFunction = resultSet.string(forColumn: EASING_FUNCTION) ?? ""
            keyframeModel.translationRelativeTo = Int(resultSet.int(forColumn: TRANSLATION_RELATIVE_TO))
            keyframeModel.scaleAnchorX = Float(resultSet.double(forColumn: SCALE_ANCHOR_X))
            keyframeModel.scaleAnchorY = Float(resultSet.double(forColumn: SCALE_ANCHOR_Y))
            keyframeModel.scaleAnchorRelativeTo = Int(resultSet.int(forColumn: SCALE_ANCHOR_RELATIVE_TO))
            keyframeModel.rotationXAnchorX = Float(resultSet.double(forColumn: ROTATION_X_ANCHOR_X))
            keyframeModel.rotationXAnchorY = Float(resultSet.double(forColumn: ROTATION_X_ANCHOR_Y))
            keyframeModel.rotationXAnchorRelativeTo = Int(resultSet.int(forColumn: ROTATION_X_ANCHOR_RELATIVE_TO))
            keyframeModel.rotationYAnchorX = Float(resultSet.double(forColumn: ROTATION_Y_ANCHOR_X))
            keyframeModel.rotationYAnchorY = Float(resultSet.double(forColumn: ROTATION_Y_ANCHOR_Y))
            keyframeModel.rotationYAnchorRelativeTo = Int(resultSet.int(forColumn: ROTATION_Y_ANCHOR_RELATIVE_TO))
            keyframeModel.rotationZAnchorX = Float(resultSet.double(forColumn: ROTATION_Z_ANCHOR_X))
            keyframeModel.rotationZAnchorY = Float(resultSet.double(forColumn: ROTATION_Z_ANCHOR_Y))
            keyframeModel.rotationZAnchorRelativeTo = Int(resultSet.int(forColumn: ROTATION_Z_ANCHOR_RELATIVE_TO))
            keyframeModel.skewAnchorX = Float(resultSet.double(forColumn: SKEW_ANCHOR_X))
            keyframeModel.skewAnchorY = Float(resultSet.double(forColumn: SKEW_ANCHOR_Y))
            keyframeModel.skewAnchorRelativeTo = Int(resultSet.int(forColumn: SKEW_ANCHOR_RELATIVE_TO))
            keyframeModel.shader = resultSet.string(forColumn: SHADER) ?? ""
            keyframeModelArray.append(keyframeModel)

        }
        return keyframeModelArray
    }

    func getAnimationCategories(for categoryId: Int) -> DBAnimationCategoriesModel {
        var animationCategoriesModel = DBAnimationCategoriesModel()
        // Prepare the query to retrieve the AnimationCategoriesModel based on the categoryId.
        let query = "SELECT * FROM \(TABLE_ANIMATION_CATEGORIES) WHERE \(ANIMATION_CATEGORIES_ID) = ?"
        let values: [Any] = [categoryId]

        // Execute the query using FMDatabase.
        do {
            let result = try runQuery(query, values: values)
            // Check if there is any result.
            if result.next(){
                // Extract the data from the row and create an `AnimationCategoriesModel` object.
                 animationCategoriesModel = DBAnimationCategoriesModel(
                    animationCategoriesId: Int(result.int(forColumn: ANIMATION_CATEGORIES_ID)),
                    animationName: result.string(forColumn: NAME) ?? "",
                    animationIcon: result.string(forColumn: ICON) ?? "",
                    order: Int(result.int(forColumn: ORDER)),
                    enabled: Int(result.int(forColumn: ENABLED))
                )
            }
            return animationCategoriesModel
        }catch{
            DBManager.logger?.printLog("Error in fetch Animation Category model")
        }

       

        return animationCategoriesModel
    }
  
    func getAnimationTemplates(for template: Int) -> DBAnimationTemplateModel {
        var animationTemplate = DBAnimationTemplateModel()

        // Prepare the query to retrieve the AnimationTemplateModels based on the template ID.
        let query = "SELECT * FROM \(TABLE_ANIMATION_TEMPLATE) WHERE \(ANIMATION_TEMPLATE_ID) = ?"
        let values: [Any] = [template]

        // Execute the query using FMDatabase.
        do {
            let result = try runQuery(query, values: values)

            // Iterate through the result and create AnimationTemplateModel objects.
            if result.next() {
                 animationTemplate = DBAnimationTemplateModel(
                    animationTemplateId: Int(result.int(forColumn: ANIMATION_TEMPLATE_ID)),
                    name: result.string(forColumn: NAME) ?? "",
                    type: result.string(forColumn: TYPE) ?? "",
                    category: Int(result.int(forColumn: CATEGORY)),
                    duration: result.floatValue(forColumn: DURATION),
                    isLoopEnabled: Int(result.int(forColumn: IsLoopEnabled)),
                    isAutoReverse: Int(result.int(forColumn: IsAutoReverse)),
                    icon: result.string(forColumn: ICON) ?? ""
                )

               return animationTemplate
            }
        } catch {
            DBManager.logger?.printLog("Error in fetch Animation Templates: \(error)")
        }

        return animationTemplate
    }



    
}




extension DBManager{
    func fetchTemplateCount()->Int{
        var query = " "
       
            query = "Select count(*) numberOfCategories from \(TABLE_TEMPLATE)"
        
       
        do {
           let results = try runQuery(query, values: nil)
                if results.next() {
                    let totalTemplatesCount = Int(results.int(forColumn: "numberOfCategories"))
                    if totalTemplatesCount > 0{
                        return totalTemplatesCount
                    }
                   
                }
        } catch {
            
        }
        return 0
    }
    
    func fetchTemplateColors(templateID: Int) -> [UIColor]{
        var colorArray: [UIColor] = []
        let query = "SELECT i.\(COLOR_INFO) AS value FROM \(TABLE_IMAGE) i WHERE i.\(IMAGE_TYPE) = 'COLOR' AND i.\(TEMPLATE_ID) = ? AND i.\(COLOR_INFO) IS NOT NULL UNION SELECT s.\(STICKER_COLOR) FROM \(TABLE_STICKER) s WHERE s.\(TEMPLATE_ID) = ? AND s.\(STICKER_COLOR) IS NOT NULL UNION SELECT t.\(BG_COLOR) FROM \(TABLE_TEXT_MODEL) t WHERE t.\(TEMPLATE_ID) = ? AND t.\(BG_COLOR) IS NOT NULL UNION SELECT t.\(SHADOW_COLOR) FROM \(TABLE_TEXT_MODEL) t WHERE t.\(TEMPLATE_ID) = ? AND t.\(SHADOW_COLOR) IS NOT NULL UNION SELECT t.\(TEXT_COLOR) FROM \(TABLE_TEXT_MODEL) t WHERE t.\(TEMPLATE_ID) = ? AND t.\(TEXT_COLOR) IS NOT NULL;"
        
        guard let resultSet = try? runQuery(query, values: [templateID, templateID, templateID, templateID, templateID]) else {
            return colorArray
        }
        while resultSet.next(){
            if let color = resultSet.string(forColumn: "value"){
                if color != "0"{
                    colorArray.append(color.convertIOSColorStringToUIColor())
                }
            }
        }
        return colorArray
        
    }
}

 extension DBManager{
     //Chnged By NK
     func isTemplateDownloaded(for templateId: Int) ->Bool {
         let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(TEMPLATE_ID) = \(templateId);"
         
         guard let resultSet = try? runQuery(query, values: nil) else {
             return false
         }
         

         if resultSet.next() {
             let value  = resultSet.int(forColumn: IS_DETAILS_DOWNLOAD)
             if value  == 1{
               return true
             }
         }
         
         return false
     }
     
     //Chnged By NK
     func isTemplateDownloaded(serverId: Int) -> (isPremium: Int, isDownloaded: Bool) {
         let query = "SELECT \(IS_PREMIUM), \(IS_DETAILS_DOWNLOAD) FROM \(TABLE_TEMPLATE) WHERE \(SERVER_TEMPLATE_ID) = ?;"
         
         guard let resultSet = try? runQuery(query, values: [serverId]), resultSet.next() else {
             return (0, false) // Default: Not downloaded, isPremium = 0
         }
         
         let isPremium = resultSet.int(forColumn: IS_PREMIUM)
         let isDownloaded = resultSet.int(forColumn: IS_DETAILS_DOWNLOAD) == 1
         
         return (Int(isPremium), isDownloaded)
     }
     
     
     func updateIsPremiumStatus(serverId: Int, isPremium: Int) -> Bool {
         let query = "UPDATE \(TABLE_TEMPLATE) SET \(IS_PREMIUM) = ? WHERE \(SERVER_TEMPLATE_ID) = ?;"
         
         do {
             try _ = runQuery(query, values: [isPremium, serverId])
             return true
         } catch {
             print("Failed to update premium status: \(error.localizedDescription)")
             return false
         }
     }
     
     //Implemented By NK
     func isAllTemplateDownloadedOrNot(category : String) -> Bool{
         let query = "SELECT * FROM \(TABLE_TEMPLATE) WHERE \(TEMPLATE_NAME) = '\(category)';"
         
         guard let resultSet = try? runQuery(query, values: nil) else {
             return false
         }
         
         while resultSet.next(){
             let value  = resultSet.int(forColumn: IS_DETAILS_DOWNLOAD)
             if value  == 0{
               return false
             }
         }
         
         return true
     }
}

extension FMResultSet {
    func floatValue(forColumn : String) -> Float {
        return Float(self.double(forColumn: forColumn))
    }
}

