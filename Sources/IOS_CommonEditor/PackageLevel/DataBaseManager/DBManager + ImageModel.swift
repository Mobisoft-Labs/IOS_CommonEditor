//
//  DBManager + ImageModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation

extension DBManager {

    // Insert query for IMAGE table
    func insertImageInfo(imageInfo: ServerImageModel) -> Int {
        let query = "INSERT INTO IMAGE (IMAGE_TYPE, SERVER_PATH, LOCAL_PATH, RES_ID, IS_ENCRYPTED, CROP_X, CROP_Y, CROP_W, CROP_H, CROP_STYLE, TILE_MULTIPLE, COLOR_INFO, IMAGE_WIDTH, IMAGE_HEIGHT) VALUES ('\(imageInfo.imageType)', '\(imageInfo.serverPath)', '\(imageInfo.localPath)', '\(imageInfo.resID)', '\(imageInfo.isEncrypted)', '\(imageInfo.cropX)', '\(imageInfo.cropY)', '\(imageInfo.cropW)', '\(imageInfo.cropH)', '\(imageInfo.cropStyle)', '\(imageInfo.tileMultiple)', '\(imageInfo.colorInfo)', '\(imageInfo.imageWidth)', '\(imageInfo.imageHeight)')"
        return insertNewEntry(query: query)
    }

    // Delete query for IMAGE table
    func deleteImageInfo() -> Bool {
        let query = "DELETE FROM IMAGE"
        return executeQuery(query: query)
    }

    // Delete query for individual column in IMAGE table
    func deleteImageInfoByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM IMAGE WHERE \(columnName) = '\(columnValue)'"
        return executeQuery(query: query)
    }

    // Update query for all columns in IMAGE table
    func updateImageInfo(imageInfo: PageInfo) -> Bool {
        let query = "UPDATE IMAGE SET SERVER_PATH = '\(imageInfo.serverPath)', LOCAL_PATH = '\(imageInfo.localPath)', RES_ID = '\(imageInfo.resID)', IS_ENCRYPTED = '\(imageInfo.isEncrypted)', CROP_X = '\(imageInfo.cropX)', CROP_Y = '\(imageInfo.cropY)', CROP_W = '\(imageInfo.cropW)', CROP_H = '\(imageInfo.cropH)', CROP_STYLE = '\(imageInfo.cropStyle)', TILE_MULTIPLE = '\(imageInfo.tileMultiple)', COLOR_INFO = '\(imageInfo.colorInfo)', IMAGE_WIDTH = '\(imageInfo.imageWidth)', IMAGE_HEIGHT = '\(imageInfo.imageHeight)' WHERE IMAGE_TYPE = '\(imageInfo.imageType)'"
        return executeQuery(query: query)
    }

    // Update query for individual column in IMAGE table
    func updateImageInfoColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE IMAGE SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}
