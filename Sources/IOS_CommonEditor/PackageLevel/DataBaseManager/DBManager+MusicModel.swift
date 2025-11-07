//
//  DBManager+MusicModel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import Foundation
import FMDB

extension DBManager {

    func createMusicTableIfNeeded() -> Bool {
        var created = false
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)

            let query =
                """
              CREATE TABLE IF NOT EXISTS \(TABLE_MUSICMODEL) (
              \(Music_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
              \(Music_musicName) TEXT,
              \(Music_localPath) TEXT,
              \(Music_displayName) TEXT,
              \(Music_extension) TEXT,
              \(Music_serverPath) TEXT,
              \(Music_thumbImageServerPath) TEXT,
              \(Music_thumbImageLocalPath) TEXT,
              \(Music_isFav) INTEGER,
              \(duration) INTEGER
              );
              """

            do {
                try updateQuery(query, values: nil)
                logger?.printLog("true")
                print("music table")
                created = true
            } catch {
                logger?.printLog("Could not create table.")
                logger?.printLog(error.localizedDescription)
            }
        }

        return created
    }
}

extension DBManager {
    func insertMusicModel(model: MusicModel) -> Int {
        var insertedRowId: Int = -1

        let query = """
            REPLACE INTO \(TABLE_MUSICMODEL) (
                \(Music_musicName),
                \(Music_localPath),
                \(Music_displayName),
                \(Music_extension),
                \(Music_serverPath),
                \(Music_thumbImageServerPath),
                \(Music_thumbImageLocalPath),
                \(Music_isFav),
                \(duration)
            ) VALUES (
                '\(model.musicName)',
                '\(model.localPath)',
                '\(model.displayName)',
                '\(model.fileExtension)',
                '\(model.serverPath)',
                '\(model.thumbImageServerPath)',
                '\(model.thumbImageLocalPath)',
                \(model.isFav ? 1 : 0),
                \(model.duration)
        
            )
        """

        insertedRowId = insertNewEntry(query: query)

        return Int(insertedRowId)
    }

    func fetchMusicModel(musicName: String) -> [MusicModel] {
        var musicModels: [MusicModel] = []

        let query = "SELECT * FROM \(TABLE_MUSICMODEL) WHERE \(Music_musicName) = '\(musicName)'"

        guard let resultSet = try? runQuery(query, values: []) else {
            return []
        }

        while resultSet.next() {
            var musicModel = MusicModel()
            musicModel.musicID = Int(resultSet.int(forColumn: Music_ID))
            musicModel.musicName = resultSet.string(forColumn: Music_musicName) ?? ""
            musicModel.localPath = resultSet.string(forColumn: Music_localPath) ?? ""
            musicModel.displayName = resultSet.string(forColumn: Music_displayName) ?? ""
            musicModel.fileExtension = resultSet.string(forColumn: Music_extension) ?? ""
            musicModel.serverPath = resultSet.string(forColumn: Music_serverPath) ?? ""
            musicModel.thumbImageServerPath = resultSet.string(forColumn: Music_thumbImageServerPath) ?? ""
            musicModel.thumbImageLocalPath = resultSet.string(forColumn: Music_thumbImageLocalPath) ?? ""
            musicModel.isFav = Int(resultSet.int(forColumn: Music_isFav)) == 1
            musicModel.duration = Float(Int(resultSet.int(forColumn: duration)))

            musicModels.append(musicModel)
        }

        return musicModels
    }
    
    public func fetchAllMusicModel() -> [MusicModel] {
        var musicModels: [MusicModel] = []

        let query = "SELECT * FROM \(TABLE_MUSICMODEL)"

        guard let resultSet = try? runQuery(query, values: []) else {
            return []
        }

        while resultSet.next() {
            var musicModel = MusicModel()
            musicModel.musicID = Int(resultSet.int(forColumn: Music_ID))
            musicModel.musicName = resultSet.string(forColumn: Music_musicName) ?? ""
            musicModel.localPath = resultSet.string(forColumn: Music_localPath) ?? ""
            musicModel.displayName = resultSet.string(forColumn: Music_displayName) ?? ""
            musicModel.fileExtension = resultSet.string(forColumn: Music_extension) ?? ""
            musicModel.serverPath = resultSet.string(forColumn: Music_serverPath) ?? ""
            musicModel.thumbImageServerPath = resultSet.string(forColumn: Music_thumbImageServerPath) ?? ""
            musicModel.thumbImageLocalPath = resultSet.string(forColumn: Music_thumbImageLocalPath) ?? ""
            musicModel.isFav = Int(resultSet.int(forColumn: Music_isFav)) == 1
            musicModel.duration = Float(Int(resultSet.int(forColumn: duration)))

            musicModels.append(musicModel)
        }

        return musicModels
    }

    func deleteMusicModelByMusicName(musicName: String) {
        let query = "DELETE FROM \(TABLE_MUSICMODEL) WHERE \(Music_musicName) = ?"

        do {
            try updateQuery(query, values: [musicName])
        } catch {
            print("Error deleting MusicModel records: \(error)")
        }
    }
    
    func fetchFavoriteMusicModels() -> [MusicModel] {
           var favoriteMusicModels: [MusicModel] = []

           let query = "SELECT * FROM \(TABLE_MUSICMODEL) WHERE \(Music_isFav) = 0"

           guard let resultSet = try? runQuery(query, values: []) else {
               return []
           }

           while resultSet.next() {
               var musicModel = MusicModel()
               musicModel.musicID = Int(resultSet.int(forColumn: Music_ID))
               musicModel.musicName = resultSet.string(forColumn: Music_musicName) ?? ""
               musicModel.localPath = resultSet.string(forColumn: Music_localPath) ?? ""
               musicModel.displayName = resultSet.string(forColumn: Music_displayName) ?? ""
               musicModel.fileExtension = resultSet.string(forColumn: Music_extension) ?? ""
               musicModel.serverPath = resultSet.string(forColumn: Music_serverPath) ?? ""
               musicModel.thumbImageServerPath = resultSet.string(forColumn: Music_thumbImageServerPath) ?? ""
               musicModel.thumbImageLocalPath = resultSet.string(forColumn: Music_thumbImageLocalPath) ?? ""
               musicModel.isFav = Int(resultSet.int(forColumn: Music_isFav)) == 1
               favoriteMusicModels.append(musicModel)
           }

           return favoriteMusicModels
       }
}
