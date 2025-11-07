//
//  DBManager + BaseModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation

extension DBManager {

    // Insert query for MODEL table
    func insertModelInfo(modelInfo: BaseModel) -> Int {
        let query = "INSERT INTO MODEL (MODEL_ID, MODEL_TYPE, DATA_ID, POS_X, POS_Y, WIDTH, HEIGHT, PREV_AVAILABLE_WIDTH, PREV_AVAILABLE_HEIGHT, ROTATION, MODEL_OPACITY, MODEL_FLIP_HORIZONTAL, MODEL_FLIP_VERICAL, LOCK_STATUS, ORDER_IN_PARENT, PARENT_ID, BG_BLUR_PROGRESS, OVERLAY_DATA_ID, OVERLAY_OPACITY, START_TIME, DURATION, SOFT_DELETE, HAS_MASK, MASK_SHAPE) VALUES ('\(modelInfo.modelId)', '\(modelInfo.modelType)', '\(modelInfo.dataId)', '\(modelInfo.posX)', '\(modelInfo.posY)', '\(modelInfo.width)', '\(modelInfo.height)', '\(modelInfo.prevAvailableWidth)', '\(modelInfo.prevAvailableHeight)', '\(modelInfo.rotation)', '\(modelInfo.modelOpacity)', '\(modelInfo.modelFlipHorizontal)', '\(modelInfo.modelFlipVertical)', '\(modelInfo.lockStatus)', '\(modelInfo.orderInParent)', '\(modelInfo.parentId)', '\(modelInfo.bgBlurProgress)', '\(modelInfo.overlayDataId)', '\(modelInfo.overlayOpacity)', '\(modelInfo.startTime)', '\(modelInfo.duration)', '\(modelInfo.softDelete)', '\(modelInfo.hasMask ? 1 : 0)', '\(modelInfo.maskShape)')"
        return insertNewEntry(query: query)
    }

    // Delete query for MODEL table
    func deleteModelInfo() -> Bool {
        let query = "DELETE FROM MODEL"
        return executeQuery(query: query)
    }

    // Delete query for individual column in MODEL table
    func deleteModelInfoByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM MODEL WHERE \(columnName) = '\(columnValue)'"
        return executeQuery(query: query)
    }

    // Update query for all columns in MODEL table
    func updateModelInfo(modelInfo: BaseModel) -> Bool {
        let query = "UPDATE MODEL SET MODEL_TYPE = '\(modelInfo.modelType)', DATA_ID = '\(modelInfo.dataId)', POS_X = '\(modelInfo.posX)', POS_Y = '\(modelInfo.posY)', WIDTH = '\(modelInfo.width)', HEIGHT = '\(modelInfo.height)', PREV_AVAILABLE_WIDTH = '\(modelInfo.prevAvailableWidth)', PREV_AVAILABLE_HEIGHT = '\(modelInfo.prevAvailableHeight)', ROTATION = '\(modelInfo.rotation)', MODEL_OPACITY = '\(modelInfo.modelOpacity)', MODEL_FLIP_HORIZONTAL = '\(modelInfo.modelFlipHorizontal)', MODEL_FLIP_VERICAL = '\(modelInfo.modelFlipVertical)', LOCK_STATUS = '\(modelInfo.lockStatus)', ORDER_IN_PARENT = '\(modelInfo.orderInParent)', PARENT_ID = '\(modelInfo.parentId)', BG_BLUR_PROGRESS = '\(modelInfo.bgBlurProgress)', OVERLAY_DATA_ID = '\(modelInfo.overlayDataId)', OVERLAY_OPACITY = '\(modelInfo.overlayOpacity)', START_TIME = '\(modelInfo.startTime)', DURATION = '\(modelInfo.duration)', SOFT_DELETE = '\(modelInfo.softDelete)', HAS_MASK = '\(modelInfo.hasMask ? 1 : 0)', MASK_SHAPE = '\(modelInfo.maskShape)' WHERE MODEL_ID = '\(modelInfo.modelId)'"
        return executeQuery(query: query)
    }

    // Update query for individual column in MODEL table
    func updateModelInfoColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE MODEL SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}
