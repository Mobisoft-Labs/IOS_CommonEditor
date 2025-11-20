//
//  DBManager + RatioInfo.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation

extension DBManager {

    // Insert query for RATIO_MODEL table
    public func insertRatioInfo(ratioInfo: RatioInfo) -> Int {
        let query = "INSERT INTO RATIO_MODEL (CATEGORY, CATEGORY_DESCRIPTION, IMAGE_RES_ID, RATIO_WIDTH, RATIO_HEIGHT, OUTPUT_WIDTH, OUTPUT_HEIGHT, IS_PREMIUM) VALUES ('\(ratioInfo.category)', '\(ratioInfo.categoryDescription)', '\(ratioInfo.imageResId)', '\(ratioInfo.ratioWidth)', '\(ratioInfo.ratioHeight)', '\(ratioInfo.outputWidth)', '\(ratioInfo.outputHeight)', '\(ratioInfo.isPremium)')"
        return insertNewEntry(query: query)
    }

    // Delete query for RATIO_MODEL table
    func deleteRatioInfo() -> Bool {
        let query = "DELETE FROM RATIO_MODEL"
        return executeQuery(query: query)
    }

    // Delete query for individual column in RATIO_MODEL table
    func deleteRatioInfoByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM RATIO_MODEL WHERE \(columnName) = '\(columnValue)'"
        return executeQuery(query: query)
    }

    // Update query for all columns in RATIO_MODEL table
    func updateRatioInfo(ratioInfo: RatioInfo) -> Bool {
        let query = "UPDATE RATIO_MODEL SET CATEGORY_DESCRIPTION = '\(ratioInfo.categoryDescription)', IMAGE_RES_ID = '\(ratioInfo.imageResId)', RATIO_WIDTH = '\(ratioInfo.ratioWidth)', RATIO_HEIGHT = '\(ratioInfo.ratioHeight)', OUTPUT_WIDTH = '\(ratioInfo.outputWidth)', OUTPUT_HEIGHT = '\(ratioInfo.outputHeight)', IS_PREMIUM = '\(ratioInfo.isPremium)' WHERE CATEGORY = '\(ratioInfo.category)'"
        return executeQuery(query: query)
    }

    // Update query for individual column in RATIO_MODEL table
    func updateRatioInfoColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE RATIO_MODEL SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}

