//
//  DBManager.swift
//  CGDemo
//
//  Created by zmobile on 04/11/22.
//

import Foundation
import CoreGraphics
import FMDB
//import IOS_CommonUtil

//24210 images in photo mixer db

public class DBManager : DBInterface{
    
    static public let shared: DBManager = DBManager()
    
    // MARK: - Enum of Table
    
    // MARK: - Initializer
    override init() {
        super.init()
        dB_fileName = "DESIGN_DB.db"
        
        // Get the database directory path safely
        guard let documentsDirectory = DBManager.logger?.getDBPath() else {
            DBManager.logger?.printLog("Error: Database directory path is invalid.")
            return
        }
        
        // Construct the full database path
        self.db_local_path = documentsDirectory.appendingPathComponent("DESIGN_DB.db").path
        
        // Check if the database file exists
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
            DBManager.logger?.printLog("Design database initialized at: \(db_local_path)")
        } else {
            DBManager.logger?.printLog("Warning: Design database not found at \(db_local_path). Consider calling createCopyOfDatabaseIfNeeded().")
        }
    }
    
    // MARK: - Column OF Tables
    
    // Table Names
    let TABLE_TEMPLATE = "TEMPLATE"
    let TABLE_IMAGE = "IMAGE"
    let TABLE_BASEMODEL = "MODEL"
    let TABLE_STICKER = "STICKER_MODEL"
    let TABLE_TEXT_MODEL = "TEXT_MODEL"
    let TABLE_ANIMATION = "ANIMATION"
    let TABLE_MUSICINFO = "MUSIC_INFO"
    let TABLE_ANIMATION_CATEGORIES = "ANIMATION_CATEGORIES"
    let TABLE_ANIMATION_TEMPLATE = "ANIMATION_TEMPLATE"
    let TABLE_KEYFRAMES = "KEYFRAMES"
    let TABLE_MUSICS = "MUSICS"
    let TABLE_RATIOMODEL = "RATIO_MODEL"
    let TABLE_CATEGORY = "CATEGORY_MASTER"
    let TABLE_CATEGORY_METADATA = "CATEGORY_META_DATA"
    
    //Column Names for CATEGORY_MASTER
    let CATEGORY_ID = "CATEGORY_ID"
    let CATEGORY_NAME = "CATEGORY_NAME"
    let CATEGORY_THUMB_PATH = "CATEGORY_THUMB_PATH"
    let CATEGORY_DATA_PATH = "CATEGORY_DATA_PATH"
    let LAST_MODIFIED = "LAST_MODIFIED"
    let IS_HEADER_DOWNLOADED = "IS_HEADER_DOWNLOADED"
    let CAN_DELETE = "CAN_DELETE"
    let CATEGORY_THUMB_TYPE = "CATEGORY_THUMB_TYPE"
    let CATEGORY_DETAILS_PATH = "CATEGORY_DETAILS_PATH"
    let CATEGORY_META_DATA = "CATEGORY_META_DATA"
    
    
    //Column names for Category Meta Data
    let FIELD_ID = "FIELD_ID"
    let FIELD_DISPLAY_NAME = "FIELD_DISPLAY_NAME"
    let TEMPLATE_VALUE = "TEMPLATE_VALUE"
    // let CATEGORY_NAME = "CATEGORY_NAME"
    let USER_VALUE = "USER_VALUE"
    let SEQ = "SEQ"
    
    // Column Names for TABLE_TEMPLATE
    let TEMPLATE_ID = "TEMPLATE_ID"
    let TEMPLATE_NAME = "TEMPLATE_NAME"
    let CATEGORY = "CATEGORY"
    let RATIO_ID = "RATIO_ID"
    let RATIO_WIDTH = "RATIO_WIDTH"
    let RATIO_HEIGHT = "RATIO_HEIGHT"
    let THUMB_SERVER_PATH = "THUMB_SERVER_PATH"
    let THUMB_LOCAL_PATH = "THUMB_LOCAL_PATH"
    let THUMB_TIME = "THUMB_TIME"
    let TOTAL_DURATION = "TOTAL_DURATION"
    let SEQUENCE = "SEQUENCE"
    let IS_PREMIUM = "IS_PREMIUM"
    let CATEGORY_TEMP = "CATEGORY_TEMP"
    let DATA_PATH = "DATA_PATH"
    let SERVER_TEMPLATE_ID = "SERVER_TEMPLATE_ID"
    let IS_DETAILS_DOWNLOAD = "IS_DETAILS_DOWNLOADED"
    let IS_RELEASED = "IS_RELEASED"
    let COLOR_PALLETE_ID = "colorPalleteId"
    let FONT_SET_ID = "fontSetId"
    let EVENT_DATA = "eventData"
    let EVENT_TIME = "eventTime"
    let VENUE = "venue"
    let NAME1 = "name1"
    let NAME2 = "name2"
    let RSVP = "rsvp"
    let BASE_COLOR = "baseColor"
    let LAYOUT_ID = "layoutId"
    let EVENT_ID = "EVENT_ID"
    let TEMPLATE_STATUS = "TEMPLATE_STATUS"
    let ORIGINAL_TEMPLATE = "ORIGINAL_TEMPLATE"
    let TEMPLATE_EVENT_STATUS = "TEMPLATE_EVENT_STATUS"
    let EVENT_TEMPLATE_JSON = "EVENT_TEMPLATE_JSON"
    let USER_ID = "USER_ID"
    let EVENT_START_DATE = "EVENT_START_DATE"
    let SHOW_WATERMARK = "SHOW_WM_GUEST"
    let CREATED_AT = "CREATED_AT"
    let UPDATED_AT = "UPDATED_AT"
    let OUTPUT_TYPE = "OUTPUT_TYPE"
    
    // Column names for Image Table
    let IMAGE_TYPE = "IMAGE_TYPE"
    let SERVER_PATH = "SERVER_PATH"
    let LOCAL_PATH = "LOCAL_PATH"
    let RES_ID = "RES_ID"
    let IS_ENCRYPTED = "IS_ENCRYPTED"
    let CROP_X = "CROP_X"
    let CROP_Y = "CROP_Y"
    let CROP_W = "CROP_W"
    let CROP_H = "CROP_H"
    let CROP_STYLE = "CROP_STYLE"
    let TILE_MULTIPLE = "TILE_MULTIPLE"
    let COLOR_INFO = "COLOR_INFO"
    let IMAGE_WIDTH = "IMAGE_WIDTH"
    let IMAGE_HEIGHT = "IMAGE_HEIGHT"
    let SOURCE_TYPE = "SOURCE_TYPE"
    
    // Column names for base Model
    let MODEL_ID = "MODEL_ID"
    let MODEL_TYPE = "MODEL_TYPE"
    let DATA_ID = "DATA_ID"
    let POS_X = "POS_X"
    let POS_Y = "POS_Y"
    let WIDTH = "WIDTH"
    let HEIGHT = "HEIGHT"
    let PREV_AVAILABLE_WIDTH = "PREV_AVAILABLE_WIDTH"
    let PREV_AVAILABLE_HEIGHT = "PREV_AVAILABLE_HEIGHT"
    let ROTATION = "ROTATION"
    let MODEL_OPACITY = "MODEL_OPACITY"
    let MODEL_FLIP_HORIZONTAL = "MODEL_FLIP_HORIZONTAL"
    let MODEL_FLIP_VERTICAL = "MODEL_FLIP_VERTICAL"
    let LOCK_STATUS = "LOCK_STATUS"
    let ORDER_IN_PARENT = "ORDER_IN_PARENT"
    let PARENT_ID = "PARENT_ID"
    let BG_BLUR_PROGRESS = "BG_BLUR_PROGRESS"
    let OVERLAY_DATA_ID = "OVERLAY_DATA_ID"
    let OVERLAY_OPACITY = "OVERLAY_OPACITY"
    let START_TIME = "START_TIME"
    let DURATION = "DURATION"
    let SOFT_DELETE = "SOFT_DELETE"
    let FILTER_TYPE = "FILTER_TYPE"
    let BRIGHTNESS = "BRIGHTNESS"
    let CONTRAST = "CONTRAST"
    let HIGHLIGHT = "HIGHLIGHT"
    let SHADOWS = "SHADOWS"
    let SATURATION = "SATURATION"
    let VIBRANCE = "VIBRANCE"
    let SHARPNESS = "SHARPNESS"
    let WARMTH = "WARMTH"
    let TINT = "TINT"
    let HAS_MASK = "HAS_MASK"
    let MASK_SHAPE = "MASK_SHAPE"
    
    // Column names for Sticker table
    let STICKER_ID = "STICKER_ID"
    let IMAGE_ID = "IMAGE_ID"
    let STICKER_TYPE = "STICKER_TYPE"
    let STICKER_FILTER_TYPE = "STICKER_FILTER_TYPE"
    let STICKER_HUE = "STICKER_HUE"
    let STICKER_COLOR = "STICKER_COLOR"
    let X_ROATATION_PROG = "X_ROATATION_PROG"
    let Y_ROATATION_PROG = "Y_ROATATION_PROG"
    let Z_ROATATION_PROG = "Z_ROATATION_PROG"
    let STICKER_MODEL_TYPE = "stickerType"
    
    // Column names for Text table
    let TEXT_ID = "TEXT_ID"
    let TEXT = "TEXT"
    let TEXT_FONT = "TEXT_FONT"
    let TEXT_COLOR = "TEXT_COLOR"
    let TEXT_GRAVITY = "TEXT_GRAVITY"
    let LINE_SPACING = "LINE_SPACING"
    let LETTER_SPACING = "LETTER_SPACING"
    let SHADOW_COLOR = "SHADOW_COLOR"
    let SHADOW_OPACITY = "SHADOW_OPACITY"
    let SHADOW_RADIUS = "SHADOW_RADIUS"
    let SHADOW_Dx = "SHADOW_Dx"
    let SHADOW_Dy = "SHADOW_Dy"
    let BG_TYPE = "BG_TYPE"
    let BG_DRAWABLE = "BG_DRAWABLE"
    let BG_COLOR = "BG_COLOR"
    let BG_ALPHA = "BG_ALPHA"
    let INTERNAL_HEIGHT_MARGIN = "INTERNAL_HEIGHT_MARGIN"
    let INTERNAL_WIDTH_MARGIN = "INTERNAL_WIDTH_MARGIN"
//    let XRotationProg = "X_ROATATION_PROG"
//    let YRotationProg = "Y_ROATATION_PROG"
//    let ZRotationProg = "Z_ROATATION_PROG"
    let CURVE_PROG = "CURVE_PROG"
    
    //columns names for animation table
    let ANIMATION_ID = "ANIMATION_ID"
    //    let MODEL_ID = "MODEL_ID"
    let IN_ANIMATION_TEMPLATE_ID = "IN_ANIMATION_TEMPLATE_ID"
    let IN_ANIMATION_DURATION = "IN_ANIMATION_DURATION"
    let LOOP_ANIMATION_TEMPLATE_ID = "LOOP_ANIMATION_TEMPLATE_ID"
    let LOOP_ANIMATION_DURATION = "LOOP_ANIMATION_DURATION"
    let OUT_ANIMATION_TEMPLATE_ID = "OUT_ANIMATION_TEMPLATE_ID"
    let OUT_ANIMATION_DURATION = "OUT_ANIMATION_DURATION"
    
    let ORDER = "ORDER"
    
    //column for music info table
    let MUSIC_ID = "MUSIC_ID"
    let MUSIC_TYPE = "MUSIC_TYPE"
    let NAME = "NAME"
    let MUSIC_PATH = "MUSIC_PATH"
    let ParentID = "PARENT_ID"
    let PARENT_TYPE = "PARENT_TYPE"
    let START_TIME_OF_AUDIO = "START_TIME_OF_AUDIO"
    let END_TIME_OF_AUDIO = "END_TIME_OF_AUDIO"
    let StartTime = "START_TIME"
    let Duration = "DURATION"
    let TemplateID = "TEMPLATE_ID"
    
    let FILE_NAME = "FILE_NAME"
    let DISPLAY_NAME = "DISPLAY_NAME"
    
    //column of animation categories
    let ANIMATION_CATEGORIES_ID = "ANIMATION_CATEGORIES_ID"
    //     let name = "NAME"
    let ICON = "ICON"
    let ORDER_INDEX = "ORDER"
    let ENABLED = "ENABLED"
    
    
    //column of animation templates
    let ANIMATION_TEMPLATE_ID = "ANIMATION_TEMPLATE_ID"
    //    let name = "NAME"
    let TYPE = "TYPE"
    //    let CATEGORY = "CATEGORY"
    //    let duration = "DURATION"
    let IsLoopEnabled = "IS_LOOP_ENABLED"
    let IsAutoReverse = "IS_AUTO_REVERSE"
    //    let icon = "ICON"
    
    //column of keyframe
    let KEYFRAME_ID = "KEYFRAME_ID"
    //    let ANIMATION_TEMPLATE_ID = "ANIMATION_TEMPLATE_ID"
    let KEYTIME = "KEYTIME"
    let TRANSLATION_X = "TRANSLATION_X"
    let TRANSLATION_Y = "TRANSLATION_Y"
    let SCALE_X = "SCALE_X"
    let SCALE_Y = "SCALE_Y"
    let ROTATION_X = "ROTATION_X"
    let ROTATION_Y = "ROTATION_Y"
    let ROTATION_Z = "ROTATION_Z"
    let SKEW_X = "SKEW_X"
    let SKEW_Y = "SKEW_Y"
    let OPACITY = "OPACITY"
    let EFFECT_PROGRESS = "EFFECT_PROGRESS"
    let EASING_FUNCTION = "EASING_FUNCTION"
    let TRANSLATION_RELATIVE_TO = "TRANSLATION_RELATIVE_TO"
    let SCALE_ANCHOR_X = "SCALE_ANCHOR_X"
    let SCALE_ANCHOR_Y = "SCALE_ANCHOR_Y"
    let SCALE_ANCHOR_RELATIVE_TO = "SCALE_ANCHOR_RELATIVE_TO"
    let ROTATION_X_ANCHOR_X = "ROTATION_X_ANCHOR_X"
    let ROTATION_X_ANCHOR_Y = "ROTATION_X_ANCHOR_Y"
    let ROTATION_X_ANCHOR_RELATIVE_TO = "ROTATION_X_ANCHOR_RELATIVE_TO"
    let ROTATION_Y_ANCHOR_X = "ROTATION_Y_ANCHOR_X"
    let ROTATION_Y_ANCHOR_Y = "ROTATION_Y_ANCHOR_Y"
    let ROTATION_Y_ANCHOR_RELATIVE_TO = "ROTATION_Y_ANCHOR_RELATIVE_TO"
    let ROTATION_Z_ANCHOR_X = "ROTATION_Z_ANCHOR_X"
    let ROTATION_Z_ANCHOR_Y = "ROTATION_Z_ANCHOR_Y"
    let ROTATION_Z_ANCHOR_RELATIVE_TO = "ROTATION_Z_ANCHOR_RELATIVE_TO"
    let SKEW_ANCHOR_X = "SKEW_ANCHOR_X"
    let SKEW_ANCHOR_Y = "SKEW_ANCHOR_Y"
    let SKEW_ANCHOR_RELATIVE_TO = "SKEW_ANCHOR_RELATIVE_TO"
    let SHADER = "SHADER"
    
    //column of ratio table
    
    let ID = "ID"
    //    let CATEGORY = "CATEGORY"
    let CATEGORY_DESCRIPTION = "CATEGORY_DESCRIPTION"
    let IMAGE_RES_ID = "IMAGE_RES_ID"
    //    let RATIO_WIDTH = "RATIO_WIDTH"
    //    let RATIO_HEIGHT = "RATIO_HEIGHT"
    let OUTPUT_WIDTH = "OUTPUT_WIDTH"
    let OUTPUT_HEIGHT = "OUTPUT_HEIGHT"
    //    let IS_PREMIUM = "IS_PREMIUM"
    
    // Music Model
    let TABLE_MUSICMODEL = "MusicTable"
    let Music_ID = "musicID"
    let Music_musicName = "musicName"
    let Music_localPath = "localPath"
    let Music_displayName = "displayName"
    let Music_extension = "extension"
    let Music_serverPath = "serverPath"
    let Music_thumbImageServerPath = "thumbImageServerPath"
    let Music_thumbImageLocalPath = "thumbImageLocalPath"
    let Music_isFav = "isFav"
    let duration = "duration"
    
    // Font Model
    let TABLE_FONTMODEL = "FontTable"
    let Font_ID = "ID"
    let Font_fontName = "fontName"
    let Font_fontDisplayName = "fontDisplayName"
    let Font_fontFamily = "fontFamily"
    let Font_fontRealName = "fontRealName"
    let Font_fontCategory = "fontCategory"
    let Font_fontSource = "fontSource"
    let Font_fontLocalPath = "fontLocalPath"
    let Font_fontServerPath = "fontServerPath"
    let Font_isPremium = "isPremium"
    let Font_isTrending = "isTrending"
    let Font_isFavourite = "isFavourite"
    let Font_futureField1 = "futureField1"
    let Font_futureField2 = "futureField2"
    let Font_futureField3 = "futureField3"
    let Font_futureField4 = "futureField4"
    
}
  
// MARK: - Extension

extension DBManager {
    
    static public func createCopyOfDatabaseIfNeeded() {
        // Get the database file path from the app bundle
        guard let bundlePath = Bundle.main.url(forResource: "DESIGN_DB", withExtension: "db") else {
            DBManager.logger?.printLog("Error: DESIGN_DB.db not found in the app bundle.")
            return
        }
        
        // Get the destination directory (App's document directory)
        guard let destPath = DBManager.logger?.getDBPath() else {
            DBManager.logger?.printLog("Error: Destination database path is invalid.")
            return
        }
        
        // Create the full destination path
        let fullDestPath = destPath.appendingPathComponent(DBManager.logger?.getDBName() ?? "DESIGN_DB.db")
        
        // Check if the database already exists
        if FileManager.default.fileExists(atPath: fullDestPath.path) {
            DBManager.logger?.printLog("Database already exists at path: \(fullDestPath.path)")
        } else {
            do {
                // Copy database from bundle to documents directory
                try FileManager.default.copyItem(at: bundlePath, to: fullDestPath)
                DBManager.logger?.printLog("Database copied successfully to: \(fullDestPath.path)")
            } catch {
                DBManager.logger?.printLog("Error copying database: \(error.localizedDescription)")
            }
        }
    }
    static public func createCopyOfStickerDatabaseIfNeeded() {
        // Get the database file path from the app bundle
        guard let bundlePath = Bundle.main.url(forResource: "StickersDatabase", withExtension: "db") else {
            DBManager.logger?.printLog("Error: StickersDatabase.db not found in the app bundle.")
            return
        }
        
        // Get the destination directory (App's document directory)
        guard let destPath = DBManager.logger?.getDBPath() else {
            DBManager.logger?.printLog("Error: Destination database path is invalid.")
            return
        }
        
        // Create the full destination path
        let fullDestPath = destPath.appendingPathComponent("StickersDatabase.db")
        
        // Check if the database already exists
        if FileManager.default.fileExists(atPath: fullDestPath.path) {
            DBManager.logger?.printLog("Sticker database already exists at path: \(fullDestPath.path)")
        } else {
            do {
                // Copy database from bundle to documents directory
                try FileManager.default.copyItem(at: bundlePath, to: fullDestPath)
                DBManager.logger?.printLog("Sticker database copied successfully to: \(fullDestPath.path)")
//                StickerDBManager.shared?.seedLegacyStickersIfNeeded(force: true)
            } catch {
                DBManager.logger?.printLog("Error copying sticker database: \(error.localizedDescription)")
            }
        }
    }

    
}

extension DBManager{
    
    private func columnExists(tableName: String, columnName: String) -> Bool {
        guard dbIsOpen else { return false }
        let query = "PRAGMA table_info(\(tableName))"
        do {
            let results = try runQuery(query, values: nil)
            while results.next() {
                if results.string(forColumn: "name") == columnName {
                    return true
                }
            }
        } catch {
            print("Error checking column existence: \(error)")
        }
        return false
    }
    
    private func addColumnIfNeeded(tableName: String, column: String, type: String) {
        if !columnExists(tableName: tableName, columnName: column) {
            let alterQuery = "ALTER TABLE \(tableName) ADD COLUMN \(column) \(type)"
            do {
                try updateQuery(alterQuery, values: nil)
                print("Added column \(column)")
            } catch {
                print("Failed to add column \(column): \(error)")
            }
        } else {
            print("Column \(column) already exists")
        }
    }
    
    private func addColumnIfNeeded(tableName: String, column: String, type: String, defaultValue: Int? = nil) {
        if !columnExists(tableName: tableName, columnName: column) {
            var alterQuery = "ALTER TABLE \(tableName) ADD COLUMN \(column) \(type)"
            if let defaultValue = defaultValue {
                alterQuery += " DEFAULT \(defaultValue)"
            }
            do {
                try updateQuery(alterQuery, values: nil)
                print("Added column \(column)")

                // If defaultValue was given, also backfill existing rows
                if let defaultValue = defaultValue {
                    let updateQueryString = "UPDATE \(tableName) SET \(column) = \(defaultValue) WHERE \(column) IS NULL"
                    try updateQuery(updateQueryString, values: nil)
                    print("Backfilled \(column) with \(defaultValue)")
                }
            } catch {
                print("Failed to add column \(column): \(error)")
            }
        } else {
            print("Column \(column) already exists")
        }
    }
    
    public func manageDatabaseVersions() {
        if dBVersion < 3 {
            let tableName = TABLE_TEMPLATE
            DBManager.shared.deleteTemplateByColumnNew(columnValue: "TEMPLATE")
            // Add new columns
            addColumnIfNeeded(tableName: tableName, column: COLOR_PALLETE_ID, type: "INTEGER")
            addColumnIfNeeded(tableName: tableName, column: FONT_SET_ID, type: "INTEGER")
            addColumnIfNeeded(tableName: tableName, column: EVENT_DATA, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: EVENT_TIME, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: VENUE, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: NAME1, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: NAME2, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: RSVP, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: BASE_COLOR, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: LAYOUT_ID, type: "INTEGER")
            addColumnIfNeeded(tableName: tableName, column: EVENT_ID, type: "INTEGER",defaultValue: -1)
            addColumnIfNeeded(tableName: tableName, column: TEMPLATE_STATUS, type: "TEXT" )
            addColumnIfNeeded(tableName: tableName, column: ORIGINAL_TEMPLATE, type: "INTEGER", defaultValue: 0)
            addColumnIfNeeded(tableName: tableName, column: TEMPLATE_EVENT_STATUS, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: SOFT_DELETE, type: "INTEGER", defaultValue: 1) // Soft Delete Inversally
            addColumnIfNeeded(tableName: tableName, column: EVENT_TEMPLATE_JSON, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: USER_ID, type: "INTEGER", defaultValue: -1)
            addColumnIfNeeded(tableName: tableName, column: EVENT_START_DATE, type: "TEXT")
            addColumnIfNeeded(tableName: tableName, column: SHOW_WATERMARK, type: "INTEGER" , defaultValue: 0)

            addColumnIfNeeded(tableName: TABLE_STICKER, column: STICKER_MODEL_TYPE, type: "TEXT")


            // Update DB version
            dBVersion = 3
            DBManager.logger?.logInfo("Migration to version 3 complete")
        }
        if dBVersion < 4 {
            addColumnIfNeeded(tableName: TABLE_TEMPLATE, column: OUTPUT_TYPE, type: "INT", defaultValue: 0)

                addColumnIfNeeded(tableName: TABLE_BASEMODEL, column: HAS_MASK, type: "INTEGER", defaultValue: 0)
                addColumnIfNeeded(tableName: TABLE_BASEMODEL, column: MASK_SHAPE, type: "TEXT")
                do {
                    try updateQuery("UPDATE \(TABLE_BASEMODEL) SET \(MASK_SHAPE) = '' WHERE \(MASK_SHAPE) IS NULL", values: nil)
                    
                    
                    
                    dBVersion = 5
                } catch {
                    DBManager.logger?.logError("Failed to backfill \(MASK_SHAPE): \(error)")
                }
            
            
               
            DBManager.logger?.logInfo("Migration to version 4 complete")
        }
        
        
        
    }
}
//
//public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
//    if (newVersion > oldVersion) {
//        if (oldVersion < 3) {
//            // Upgrade logic from version 2 to 3
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + MAIN_CATEGORY + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + SUB_CATEGORY + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + SUB_SUB_CATEGORY + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + GENDER + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + THEME + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + SUB_THEME + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + DESIGN_THEME + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + OUTPUT_TYPE + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + WITH_PHOTO + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + COUNTRY + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + LANGUAGE + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + COLOR_PALLETE_ID + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + LAYOUT_ID + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + FONT_SET_ID + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + EVENT_DATA + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + EVENT_TIME + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + VENUE + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + USER_ID + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + CREATED_DATE_TIME + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + TYPE + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + BASE_COLOR + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + CONTENT_TAGS + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + NAME1 + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + NAME2 + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + RSVP + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + TEMPLATE_DISPLAY_NAME + " TEXT");
//
//            db.execSQL("ALTER TABLE " + TABLE_STICKER_MODEL + " ADD COLUMN " + STICKR_TYPE + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_IMAGE + " ADD COLUMN " + IS_MODEL_IMAGE + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEXT_MODEL + " ADD COLUMN " + TEXT_TYPE + " TEXT");
//        }
//        
//        if (oldVersion < 4) {
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + EVENT_ID + " INTEGER DEFAULT -1");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + TEMPLATE_STATUS + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + ORIGINAL_TEMPLATE + " INTEGER DEFAULT -1");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + TEMPLATE_EVENT_STATUS + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + TEMPLATE_SOFT_DELETE + " INTEGER DEFAULT 0");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + EVENT_TEMPLATE_JSON + " TEXT");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + RSVP_USER_ID + " INTEGER DEFAULT -1");
//            db.execSQL("ALTER TABLE " + TABLE_TEMPLATE + " ADD COLUMN " + EVENT_START_DATE + " TEXT");
//        }
//        
//        
//    }
//}
//
