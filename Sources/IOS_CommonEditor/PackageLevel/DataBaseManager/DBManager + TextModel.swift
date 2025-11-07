//
//  DBManager + TextModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation

extension DBManager {

    // Insert query for TEXT_MODEL table
    func insertTextInfo(textInfo: TextInfo) -> Int {
        let query = "INSERT INTO TEXT_MODEL (TEXT_ID, TEXT, TEXT_FONT, TEXT_COLOR, TEXT_GRAVITY, LINE_SPACING, LETTER_SPACING, SHADOW_COLOR, SHADOW_OPACITY, SHADOW_RADIUS, SHADOW_Dx, SHADOW_Dy, BG_TYPE, BG_DRAWABLE, BG_COLOR, BG_ALPHA, INTERNAL_HEIGHT_MARGIN, INTERNAL_WIDTH_MARGIN, X_ROATATION_PROG, Y_ROATATION_PROG, Z_ROATATION_PROG, CURVE_PROG) VALUES ('\(textInfo.textId)', '\(textInfo.text)', '\(textInfo.textFont)', '\(textInfo.textColor)', '\(textInfo.textGravity)', '\(textInfo.lineSpacing)', '\(textInfo.letterSpacing)', '\(textInfo.shadowColor)', '\(textInfo.shadowOpacity)', '\(textInfo.shadowRadius)', '\(textInfo.shadowDx)', '\(textInfo.shadowDy)', '\(textInfo.bgType)', '\(textInfo.bgDrawable)', '\(textInfo.bgColor)', '\(textInfo.bgAlpha)', '\(textInfo.internalHeightMargin)', '\(textInfo.internalWidthMargin)', '\(textInfo.xRotationProg)', '\(textInfo.yRotationProg)', '\(textInfo.zRotationProg)', '\(textInfo.curveProg)')"
        return insertNewEntry(query: query)
    }

    // Delete query for TEXT_MODEL table
    func deleteTextInfo() -> Bool {
        let query = "DELETE FROM TEXT_MODEL"
        return executeQuery(query: query)
    }

    // Delete query for individual column in TEXT_MODEL table
    func deleteTextInfoByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM TEXT_MODEL WHERE \(columnName) = '\(columnValue)'"
        return executeQuery(query: query)
    }

    // Update query for all columns in TEXT_MODEL table
    func updateTextInfo(textInfo: TextInfo) -> Bool {
        let query = "UPDATE TEXT_MODEL SET TEXT = '\(textInfo.text)', TEXT_FONT = '\(textInfo.textFont)', TEXT_COLOR = '\(textInfo.textColor)', TEXT_GRAVITY = '\(textInfo.textGravity)', LINE_SPACING = '\(textInfo.lineSpacing)', LETTER_SPACING = '\(textInfo.letterSpacing)', SHADOW_COLOR = '\(textInfo.shadowColor)', SHADOW_OPACITY = '\(textInfo.shadowOpacity)', SHADOW_RADIUS = '\(textInfo.shadowRadius)', SHADOW_Dx = '\(textInfo.shadowDx)', SHADOW_Dy = '\(textInfo.shadowDy)', BG_TYPE = '\(textInfo.bgType)', BG_DRAWABLE = '\(textInfo.bgDrawable)', BG_COLOR = '\(textInfo.bgColor)', BG_ALPHA = '\(textInfo.bgAlpha)', INTERNAL_HEIGHT_MARGIN = '\(textInfo.internalHeightMargin)', INTERNAL_WIDTH_MARGIN = '\(textInfo.internalWidthMargin)', X_ROATATION_PROG = '\(textInfo.xRotationProg)', Y_ROATATION_PROG = '\(textInfo.yRotationProg)', Z_ROATATION_PROG = '\(textInfo.zRotationProg)', CURVE_PROG = '\(textInfo.curveProg)' WHERE TEXT_ID = '\(textInfo.textId)'"
        return executeQuery(query: query)
    }

    // Update query for individual column in TEXT_MODEL table
    func updateTextInfoColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE TEXT_MODEL SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}
