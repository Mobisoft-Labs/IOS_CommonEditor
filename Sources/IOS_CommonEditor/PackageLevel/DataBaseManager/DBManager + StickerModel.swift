//
//  DBManager + StickerModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation

extension DBManager {

    // Insert query for STICKER_MODEL table
    func insertStickerInfo(stickerInfo: StickerInfo) -> Int {
        let query = "INSERT INTO STICKER_MODEL (STICKER_ID, IMAGE_ID, STICKER_TYPE, STICKER_FILTER_TYPE, STICKER_HUE, STICKER_COLOR, X_ROATATION_PROG, Y_ROATATION_PROG, Z_ROATATION_PROG, stickerType) VALUES ('\(stickerInfo.stickerId)', '\(stickerInfo.imageID)', '\(stickerInfo.stickerType)', '\(stickerInfo.stickerFilterType)', '\(stickerInfo.stickerHue)', '\(stickerInfo.stickerColor)', '\(stickerInfo.xRotationProg)', '\(stickerInfo.yRotationProg)', '\(stickerInfo.zRotationProg)', '\(stickerInfo.stickerModelType)')"
        return insertNewEntry(query: query)
    }

    // Delete query for STICKER_MODEL table
    func deleteStickerInfo() -> Bool {
        let query = "DELETE FROM STICKER_MODEL"
        return executeQuery(query: query)
    }

    // Delete query for individual column in STICKER_MODEL table
    func deleteStickerInfoByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM STICKER_MODEL WHERE \(columnName) = '\(columnValue)'"
        return executeQuery(query: query)
    }

    // Update query for all columns in STICKER_MODEL table
    func updateStickerInfo(stickerInfo: StickerInfo) -> Bool {
        let query = "UPDATE STICKER_MODEL SET IMAGE_ID = '\(stickerInfo.imageID)', STICKER_TYPE = '\(stickerInfo.stickerType)', STICKER_FILTER_TYPE = '\(stickerInfo.stickerFilterType)', STICKER_HUE = '\(stickerInfo.stickerHue)', STICKER_COLOR = '\(stickerInfo.stickerColor)', X_ROATATION_PROG = '\(stickerInfo.xRotationProg)', Y_ROATATION_PROG = '\(stickerInfo.yRotationProg)', Z_ROATATION_PROG = '\(stickerInfo.zRotationProg)' WHERE STICKER_ID = '\(stickerInfo.stickerId)'"
        return executeQuery(query: query)
    }

    // Update query for individual column in STICKER_MODEL table
    func updateStickerInfoColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE STICKER_MODEL SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}
