//
//  StickerDBManager.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 13/03/24.
//

import Foundation
import CoreGraphics
import FMDB

public class StickerDBManager: DBInterface{
    
    static public let shared: StickerDBManager = StickerDBManager()
    
    // MARK: - Initializer
    override init() {
        super.init()
        dB_fileName = "StickersDatabase.db"
        
        // Get the database directory path safely
        guard let documentsDirectory = DBManager.logger?.getDBPath() else {
            DBManager.logger?.printLog("Error: Database directory path is invalid.")
            return
        }
        
        // Construct the full database path
        self.db_local_path = documentsDirectory.appendingPathComponent("StickersDatabase.db").path
        
        // Check if the database file exists
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
            DBManager.logger?.printLog("Sticker database initialized at: \(db_local_path)")
           
        } else {
            DBManager.logger?.printLog("Warning: Sticker database not found at \(db_local_path). Consider calling createCopyOfStickerDatabaseIfNeeded().")
        }
    }
    
    // Sticker Table
    let TABLE_STICKER_MASTER = "StickerMaster"
    let TABLE_STICKER_CATEGORY_MASTER = "StickerCategoryMaster"
    
    // Sticker Table Column Names
    let sticker_ID = "ID"
    let sticker_Category_Name = "CategoryName"
    let sticker_ResID = "Res_ID"
    let isFree = "isFree"
    let last_Updated = "Last_Updated"
    let tags = "Tags"
    let localPath = "LocalPath"
    let serverPath = "ServerPath"
    let isLocal = "isLocal"
    let imageHeight = "ImageHeight"
    let imageWidth = "ImageWidth"
    let thumbnail_Server_Path = "Thumbnail_Server_Path"
    let sticker_futureField1 = "FutureField1"
}
