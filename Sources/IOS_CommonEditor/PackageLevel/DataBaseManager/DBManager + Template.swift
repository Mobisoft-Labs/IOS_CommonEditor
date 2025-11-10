//
//  DBManager + Template.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation


extension DBManager {
    
    func insertTemplate(templateInfo: TemplateInfo) -> Int {
        let query = "INSERT INTO TABLE_TEMPLATE (TEMPLATE_ID, TEMPLATE_NAME, CATEGORY, RATIO_ID, RATIO_WIDTH, RATIO_HEIGHT, THUMB_SERVER_PATH, THUMB_LOCAL_PATH, THUMB_TIME, TOTAL_DURATION, SEQUENCE, IS_PREMIUM, CATEGORY_TEMP, SERVER_TEMPLATE_ID) VALUES ('\(templateInfo.templateId)', '\(templateInfo.templateName)', '\(templateInfo.category)', '\(templateInfo.ratioId)', '\(templateInfo.ratioSize.width)', '\(templateInfo.ratioSize.height)', '\(templateInfo.thumbServerPath)', '\(templateInfo.thumbLocalPath)', '\(templateInfo.thumbTime)', '\(templateInfo.totalDuration)', '\(templateInfo.sequence_Temp)', '\(templateInfo.isPremium)', '\(templateInfo.categoryTemp)', '\(templateInfo.serverTemplateID)')"
        return insertNewEntry(query: query)
    }


    // Delete query for TEMPLATE table
    func deleteTemplate() -> Bool {
        let query = "DELETE FROM TABLE_TEMPLATE"
        return executeQuery(query: query)
    }

    // Delete query for individual column in TEMPLATE table
    func deleteTemplateByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM TABLE_TEMPLATE WHERE \(columnName) = '\(columnValue)'"
        DBManager.logger?.logInfo("Downloaded Templates Deleted")
        return executeQuery(query: query)
    }

    // Update query for all columns in TEMPLATE table
    func updateTemplate(templateInfo: TemplateInfo) -> Bool {
        let query = "UPDATE TABLE_TEMPLATE SET TEMPLATE_NAME = '\(templateInfo.templateName)', CATEGORY = '\(templateInfo.category)', RATIO_ID = '\(templateInfo.ratioId)', RATIO_WIDTH = '\(templateInfo.ratioSize.width)', RATIO_HEIGHT = '\(templateInfo.ratioSize.height)', THUMB_SERVER_PATH = '\(templateInfo.thumbServerPath)', THUMB_LOCAL_PATH = '\(templateInfo.thumbLocalPath)', THUMB_TIME = '\(templateInfo.thumbTime)', TOTAL_DURATION = '\(templateInfo.totalDuration)', SEQUENCE = '\(templateInfo.sequence_Temp)', IS_PREMIUM = '\(templateInfo.isPremium)', CATEGORY_TEMP = '\(templateInfo.categoryTemp)', SERVER_TEMPLATE_ID = '\(templateInfo.serverTemplateID)' WHERE TEMPLATE_ID = '\(templateInfo.templateId)'"
        return executeQuery(query: query)
    }


    // Update query for individual column in TEMPLATE table
    func updateTemplateColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE TABLE_TEMPLATE SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}
