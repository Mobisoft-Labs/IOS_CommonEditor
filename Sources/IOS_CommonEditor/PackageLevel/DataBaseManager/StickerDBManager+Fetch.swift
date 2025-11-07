//
//  StickerDBManager+Fetch.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 13/03/24.
//

import Foundation

extension StickerDBManager{
    //MARK: - Fetch method
    
    func getStickerImages() -> [String]{
        var stickerInfo: [String] = [String]()
        
        let query = "SELECT Res_ID FROM \(TABLE_STICKER_MASTER)"
        
        guard let resultSet = try? runQuery(query, values: nil) else {
            return stickerInfo
        }
        
        while resultSet.next() {
            let resID = resultSet.string(forColumn: "Res_ID") ?? ""

            stickerInfo.append(resID)
        }
        
        return stickerInfo
    }
    
    func getStickerInfo(resID: [String]) -> [String: String]{
        var stickerInfo: [String: String] = [:]
        
        for rID in resID{
            let query = "SELECT CategoryName FROM \(TABLE_STICKER_MASTER) WHERE Res_ID = '\(rID)'"
            
            guard let resultSet = try? runQuery(query, values: nil) else {
                return stickerInfo
            }
            
            while resultSet.next() {
                let category = resultSet.string(forColumn: "CategoryName") ?? ""
                stickerInfo[rID] = category
            }
        }
        
        return stickerInfo
    }
    
    public func getAllStickerInfo() -> [StickerModel]{
        var stickerModels: [StickerModel] = []
        
        let query = "SELECT * FROM \(TABLE_STICKER_MASTER)"
        
        guard let resultSet = try? runQuery(query, values: []) else {
            return []
        }
        
        while resultSet.next() {
            var stickerModel = StickerModel()
            
            stickerModel.stickerID = Int(resultSet.int(forColumn: sticker_ID))
            stickerModel.categoryName = resultSet.string(forColumn: sticker_Category_Name) ?? ""
            stickerModel.resId = resultSet.string(forColumn: sticker_ResID) ?? ""
            stickerModel.resId = resultSet.string(forColumn: sticker_ResID) ?? ""
            stickerModel.isFree = resultSet.string(forColumn: isFree) ?? ""
            stickerModel.isLocal = resultSet.string(forColumn: isLocal) ?? ""
            stickerModel.lastUpdated = resultSet.string(forColumn: last_Updated) ?? ""
            stickerModel.tags = resultSet.string(forColumn: tags) ?? ""
            stickerModel.localPath = resultSet.string(forColumn: localPath) ?? ""
            stickerModel.serverPath = resultSet.string(forColumn: serverPath) ?? ""
            stickerModel.imageHeight = resultSet.string(forColumn: imageHeight) ?? ""
            stickerModel.imageWidth = resultSet.string(forColumn: imageWidth) ?? ""
            stickerModel.thumbImageServerPath = resultSet.string(forColumn: thumbnail_Server_Path) ?? ""
            stickerModel.futureField1 = resultSet.string(forColumn: sticker_futureField1) ?? ""
            
            stickerModels.append(stickerModel)
            
        }
        
        return stickerModels
    }
    
}
