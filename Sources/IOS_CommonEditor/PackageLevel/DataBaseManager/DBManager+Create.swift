//
//  DBManager+Create.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 21/07/23.
//

import Foundation
import FMDB

extension DBManager{
    //MARK: - Create table
    
    func createDataBaseIFNeeded()->Bool{
        var created = false
        if !FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
            
            DBManager.logger?.printLog("db local path:- \(db_local_path)")
            //create animation table
            let createAnimationTable = """
        CREATE TABLE IF NOT EXISTS \(TABLE_ANIMATION) (
            \(ANIMATION_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(MODEL_ID) INTEGER,
            \(IN_ANIMATION_TEMPLATE_ID) INTEGER,
            \(IN_ANIMATION_DURATION) NUMERIC,
            \(LOOP_ANIMATION_TEMPLATE_ID) INTEGER,
            \(LOOP_ANIMATION_DURATION) NUMERIC,
            \(OUT_ANIMATION_TEMPLATE_ID) INTEGER,
            \(OUT_ANIMATION_DURATION) NUMERIC
        );
    """
            //create animation categories table
            let createAnimationCategoryTable = """
                   CREATE TABLE IF NOT EXISTS \(TABLE_ANIMATION_CATEGORIES) (
                       \(ANIMATION_CATEGORIES_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                       \(NAME) TEXT,
                       \(ICON) TEXT,
                       \(ORDER_INDEX) INTEGER,
                       \(ENABLED) INTEGER
                   );
               """
            
            // createAnimationTemplateTable
            let createAnimationTemplateTable = """
                   CREATE TABLE IF NOT EXISTS \(TABLE_ANIMATION_TEMPLATE) (
                       \(ANIMATION_TEMPLATE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                       \(NAME) TEXT,
                       \(TYPE) TEXT,
                       \(CATEGORY) INTEGER,
                       \(DURATION) NUMERIC,
                       \(IS_ENCRYPTED) INTEGER,
                       \(IsAutoReverse) INTEGER,
                       \(ICON) TEXT
                   );
               """
            
            // createImageTable
            
            let createImageTable = """
                CREATE TABLE IF NOT EXISTS \(TABLE_IMAGE) (
                    \(IMAGE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                    \(IMAGE_TYPE) TEXT,
                    \(SERVER_PATH) TEXT,
                    \(LOCAL_PATH) TEXT,
                    \(RES_ID) TEXT,
                    \(IS_ENCRYPTED) INTEGER,
                    \(CROP_X) NUMERIC,
                    \(CROP_Y) NUMERIC,
                    \(CROP_W) NUMERIC,
                    \(CROP_H) NUMERIC,
                    \(CROP_STYLE) INTEGER DEFAULT 1,
                    \(TILE_MULTIPLE) NUMERIC,
                    \(COLOR_INFO) TEXT,
                    \(IMAGE_WIDTH) NUMERIC,
                    \(IMAGE_HEIGHT) NUMERIC
                );
            """
            
            //createKeyframesTable
            let createKeyframesTable = """
        CREATE TABLE IF NOT EXISTS \(TABLE_KEYFRAMES) (
            \(KEYFRAME_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(ANIMATION_TEMPLATE_ID) INTEGER,
            \(KEYTIME) NUMERIC,
            \(TRANSLATION_X) NUMERIC,
            \(TRANSLATION_Y) NUMERIC,
            \(SCALE_X) NUMERIC,
            \(SCALE_Y) NUMERIC,
            \(ROTATION_X) NUMERIC,
            \(ROTATION_Y) NUMERIC,
            \(ROTATION_Z) NUMERIC,
            \(SKEW_X) NUMERIC,
            \(SKEW_Y) NUMERIC,
            \(OPACITY) NUMERIC,
            \(EFFECT_PROGRESS) NUMERIC,
            \(EASING_FUNCTION) TEXT,
            \(TRANSLATION_RELATIVE_TO) INTEGER,
            \(SCALE_ANCHOR_X) NUMERIC,
            \(SCALE_ANCHOR_Y) NUMERIC,
            \(SCALE_ANCHOR_RELATIVE_TO) INTEGER,
            \(ROTATION_X_ANCHOR_X) NUMERIC,
            \(ROTATION_X_ANCHOR_Y) NUMERIC,
            \(ROTATION_X_ANCHOR_RELATIVE_TO) INTEGER,
            \(ROTATION_Y_ANCHOR_X) NUMERIC,
            \(ROTATION_Y_ANCHOR_Y) NUMERIC,
            \(ROTATION_Y_ANCHOR_RELATIVE_TO) INTEGER,
            \(ROTATION_Z_ANCHOR_X) NUMERIC,
            \(ROTATION_Z_ANCHOR_Y) NUMERIC,
            \(ROTATION_Z_ANCHOR_RELATIVE_TO) INTEGER,
            \(SKEW_ANCHOR_X) NUMERIC,
            \(SKEW_ANCHOR_Y) NUMERIC,
            \(SKEW_ANCHOR_RELATIVE_TO) INTEGER,
            \(SHADER) TEXT
        );
    """
            //create base model
            let createBaseModelTable = """
                  CREATE TABLE IF NOT EXISTS \(TABLE_BASEMODEL) (
                      \(MODEL_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                      \(MODEL_TYPE) TEXT,
                      \(DATA_ID) INTEGER,
                      \(POS_X) NUMERIC,
                      \(POS_Y) NUMERIC,
                      \(WIDTH) NUMERIC,
                      \(HEIGHT) NUMERIC,
                      \(PREV_AVAILABLE_WIDTH) NUMERIC,
                      \(PREV_AVAILABLE_HEIGHT) NUMERIC,
                      \(ROTATION) INTEGER,
                      \(MODEL_OPACITY) INTEGER,
                      \(MODEL_FLIP_HORIZONTAL) INTEGER DEFAULT 0,
                      \(MODEL_FLIP_VERTICAL) INTEGER DEFAULT 0,
                      \(LOCK_STATUS) TEXT,
                      \(ORDER_IN_PARENT) INTEGER,
                      \(PARENT_ID) INTEGER,
                      \(BG_BLUR_PROGRESS) INTEGER,
                      \(OVERLAY_DATA_ID) INTEGER,
                      \(OVERLAY_OPACITY) INTEGER,
                      \(START_TIME) NUMERIC,
                      \(DURATION) NUMERIC,
                      \(SOFT_DELETE) INTEGER DEFAULT 0
                      \(HAS_MASK) INTEGER DEFAULT 0,
                      \(MASK_SHAPE) TEXT
                  );
              """
            
            //create music info table
            let createMusicInfoTable = """
                CREATE TABLE IF NOT EXISTS \(TABLE_MUSICINFO) (
                    \(MUSIC_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                    \(MUSIC_TYPE) TEXT,
                    \(NAME) TEXT,
                    \(MUSIC_PATH) TEXT,
                    \(PARENT_ID) INTEGER,
                    \(PARENT_TYPE) INTEGER,
                    \(START_TIME_OF_AUDIO) NUMERIC,
                    \(END_TIME_OF_AUDIO) NUMERIC,
                    \(START_TIME) NUMERIC,
                    \(DURATION) NUMERIC
                );
            """
            
            //createMusicsTable
            let createMusicsTable = """
                   CREATE TABLE IF NOT EXISTS \(TABLE_MUSICS) (
                       \(MUSIC_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                       \(FILE_NAME) TEXT,
                       \(DISPLAY_NAME) TEXT
                   );
               """
            
            
            //createRatioModelTable
            let createRatioModelTable = """
                CREATE TABLE IF NOT EXISTS \(TABLE_RATIOMODEL) (
                    \(ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                    \(CATEGORY) TEXT,
                    \(CATEGORY_DESCRIPTION) TEXT,
                    \(IMAGE_RES_ID) TEXT,
                    \(RATIO_WIDTH) NUMERIC,
                    \(RATIO_HEIGHT) NUMERIC,
                    \(OUTPUT_WIDTH) NUMERIC,
                    \(OUTPUT_HEIGHT) NUMERIC,
                    \(IS_PREMIUM) INTEGER
                );
            """
            
            
            //createStickerModelTable
            let createStickerModelTable = """
                  CREATE TABLE IF NOT EXISTS \(TABLE_STICKER) (
                      \(STICKER_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                      \(IMAGE_ID) INTEGER,
                      \(STICKER_TYPE) TEXT,
                      \(STICKER_FILTER_TYPE) INTEGER,
                      \(STICKER_HUE) INTEGER,
                      \(STICKER_COLOR) TEXT,
                      \(X_ROATATION_PROG) INTEGER,
                      \(Y_ROATATION_PROG) INTEGER,
                      \(Z_ROATATION_PROG) INTEGER
                  );
              """
            
            //createTemplateTable
            
            let createTemplateTable = """
                CREATE TABLE IF NOT EXISTS \(TABLE_TEMPLATE) (
                    \(TEMPLATE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                    \(CATEGORY) TEXT,
                    \(TEMPLATE_NAME) TEXT,
                    \(RATIO_ID) INTEGER,
                    \(THUMB_SERVER_PATH) TEXT,
                    \(THUMB_LOCAL_PATH) TEXT,
                    \(THUMB_TIME) NUMERIC DEFAULT 0,
                    \(TOTAL_DURATION) NUMERIC,
                    \(SEQUENCE) INTEGER,
                    \(IS_PREMIUM) INTEGER,
                    \(CATEGORY_TEMP) TEXT
                );
            """
            
            //createTextModelTable
            let createTextModelTable = """
                   CREATE TABLE IF NOT EXISTS \(TABLE_TEXT_MODEL) (
                       \(TEXT_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                       \(TEXT) TEXT,
                       \(TEXT_FONT) TEXT,
                       \(TEXT_COLOR) TEXT,
                       \(TEXT_GRAVITY) TEXT,
                       \(LINE_SPACING) NUMERIC,
                       \(LETTER_SPACING) NUMERIC,
                       \(SHADOW_COLOR) TEXT,
                       \(SHADOW_OPACITY) INTEGER,
                       \(SHADOW_RADIUS) NUMERIC,
                       \(SHADOW_Dx) NUMERIC,
                       \(SHADOW_Dy) NUMERIC,
                       \(BG_TYPE) INTEGER,
                       \(BG_BLUR_PROGRESS) TEXT,
                       \(BG_COLOR) TEXT,
                       \(BG_ALPHA) INTEGER,
                       \(INTERNAL_WIDTH_MARGIN) NUMERIC,
                       \(INTERNAL_HEIGHT_MARGIN) NUMERIC,
                       \(X_ROATATION_PROG) INTEGER,
                       \(Y_ROATATION_PROG) INTEGER,
                       \(Z_ROATATION_PROG) INTEGER,
                       \(CURVE_PROG) INTEGER
                   );
               """
            let querys = [createAnimationTable,createAnimationCategoryTable,createAnimationTemplateTable,createImageTable + createKeyframesTable,createBaseModelTable,createMusicInfoTable,createMusicsTable,createRatioModelTable,createStickerModelTable,createTemplateTable,createTextModelTable]
            
            do {
                //        for query in querys{
                try updateMultipleQuery(querys, arrayOfValues: nil)
                //        }
                
                DBManager.logger?.printLog("true")
                created = true
            }
            catch {  DBManager.logger?.printLog("Could not create table.")
                DBManager.logger?.printLog(error.localizedDescription)
                
            }
        }
        
        return created
    }
    
    
}
