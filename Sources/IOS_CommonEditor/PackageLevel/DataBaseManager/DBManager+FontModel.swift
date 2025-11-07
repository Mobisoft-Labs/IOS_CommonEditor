//
//  DBManager+FontModel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 15/03/24.
//

import Foundation
import FMDB

extension DBManager{
    
    func createFontTableIFNeeded()->Bool{
        var created = false
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
            
            logger?.printLog("db local path:- \(db_local_path)")
            //create animation table
    
            
            
             let query =
             """
              CREATE TABLE IF NOT EXISTS \(TABLE_FONTMODEL) (
              \(Font_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
              \(Font_fontName) TEXT,
              \(Font_fontDisplayName) TEXT,
              \(Font_fontFamily) TEXT,
              \(Font_fontRealName) TEXT,
              \(Font_fontCategory) TEXT,
              \(Font_fontSource) TEXT,
              \(Font_fontLocalPath) TEXT,
              \(Font_fontServerPath) TEXT,
              \(Font_isPremium) INTEGER,
              \(Font_isTrending) INTEGER,
              \(Font_isFavourite) INTEGER,
              \(Font_futureField1) TEXT,
              \(Font_futureField2) TEXT,
              \(Font_futureField3) TEXT,
              \(Font_futureField4) TEXT
              );
              """
    
            
            do {
                //        for query in querys{
                try updateQuery(query, values: nil)
                //        }
                
                logger?.printLog("true")
                created = true
            }
            catch {  logger?.printLog("Could not create table.")
                logger?.printLog(error.localizedDescription)
                
            }
        }
        
        return created
    }
    
}

extension DBManager{
    
    
    func insertFontModel(model: FontModel) -> Int {
        var insertedRowId: Int = -1
        
        let query = "REPLACE INTO \(TABLE_FONTMODEL) (\(Font_fontName), \(Font_fontDisplayName), \(Font_fontFamily), \(Font_fontRealName), \(Font_fontCategory), \(Font_fontSource), \(Font_fontLocalPath), \(Font_fontServerPath), \(Font_isPremium), \(Font_isTrending), \(Font_isFavourite)) VALUES ('\(model.fontName)', '\(model.fontDisplayName)', '\(model.fontFamily)', '\(model.fontRealName)', '\(model.fontCategory)', '\(model.fontSource)', '\(model.fontLocalPath)', '\(model.fontServerPath)', \(model.isPremium ? 1 : 0), \(model.isTrending ? 1 : 0), \(model.isFavourite ? 1 : 0))"

        insertedRowId = insertNewEntry(query: query)

        return Int(insertedRowId)
    }
    
    func fetchFontModel(fontSource: String) -> [FontModel] {
        var fonts: [FontModel] = []

            let query = "SELECT * FROM \(TABLE_FONTMODEL) WHERE \(Font_fontSource) = '\(fontSource)'"
//            print(query)
            guard let resultSet = try? runQuery(query, values: []) else {
                return []
            }
            
            if resultSet.next() {
                var font = FontModel()
                font.ID = Int(resultSet.int(forColumn: Font_ID))
                font.fontName = resultSet.string(forColumn: Font_fontName) ?? ""
                font.fontDisplayName = resultSet.string(forColumn: Font_fontDisplayName) ?? ""
                font.fontFamily = resultSet.string(forColumn: Font_fontFamily) ?? ""
                font.fontRealName = resultSet.string(forColumn: Font_fontRealName) ?? ""
                font.fontCategory = resultSet.string(forColumn: Font_fontCategory) ?? ""
                font.fontSource = resultSet.string(forColumn: Font_fontSource) ?? ""
                font.fontLocalPath = resultSet.string(forColumn: Font_fontLocalPath) ?? ""
                font.fontServerPath = resultSet.string(forColumn: Font_fontServerPath) ?? ""
                font.isPremium = Int(resultSet.int(forColumn: Font_isPremium)) == 1
                font.isTrending = Int(resultSet.int(forColumn: Font_isTrending)) == 1
                font.isFavourite = Int(resultSet.int(forColumn: Font_isFavourite)) == 1
              
                fonts.append(font)
            }
        
        
        return fonts
    }
    
    func fetchAllFontModel() -> [FontModel] {
        var fonts: [FontModel] = []

            let query = "SELECT * FROM \(TABLE_FONTMODEL)"
//            print(query)
            guard let resultSet = try? runQuery(query, values: []) else {
                return []
            }
            
            while resultSet.next() {
                var font = FontModel()
                font.ID = Int(resultSet.int(forColumn: Font_ID))
                font.fontName = resultSet.string(forColumn: Font_fontName) ?? ""
                font.fontDisplayName = resultSet.string(forColumn: Font_fontDisplayName) ?? ""
                font.fontFamily = resultSet.string(forColumn: Font_fontFamily) ?? ""
                font.fontRealName = resultSet.string(forColumn: Font_fontRealName) ?? ""
                font.fontCategory = resultSet.string(forColumn: Font_fontCategory) ?? ""
                font.fontSource = resultSet.string(forColumn: Font_fontSource) ?? ""
                font.fontLocalPath = resultSet.string(forColumn: Font_fontLocalPath) ?? ""
                font.fontServerPath = resultSet.string(forColumn: Font_fontServerPath) ?? ""
                font.isPremium = Int(resultSet.int(forColumn: Font_isPremium)) == 1
                font.isTrending = Int(resultSet.int(forColumn: Font_isTrending)) == 1
                font.isFavourite = Int(resultSet.int(forColumn: Font_isFavourite)) == 1
              
                fonts.append(font)
            }
        
        
        return fonts
    }

    
    func deleteFontModelByFontSource(fontSource: String) {

            let query = "DELETE FROM \(TABLE_FONTMODEL) WHERE \(Font_fontSource) = ?"
            
            do {
                try updateQuery(query, values: [fontSource])
            } catch {
                print("Error deleting FontModel records: \(error)")
            }
        
    }
    
    
    
    
}
