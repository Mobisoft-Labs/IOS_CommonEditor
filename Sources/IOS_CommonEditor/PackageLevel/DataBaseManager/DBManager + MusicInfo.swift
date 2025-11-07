//
//  DBManager + MusicInfo.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 10/04/24.
//

import Foundation

extension DBManager {

    // Insert query for all columns
    func insertMusicInfo(musicInfo: MusicInfo) -> Int { // REPLACE QUERY 
        let query = "INSERT INTO MUSIC_INFO (MUSIC_ID, MUSIC_TYPE, NAME, MUSIC_PATH, PARENT_ID, PARENT_TYPE, START_TIME_OF_AUDIO, END_TIME_OF_AUDIO, START_TIME, DURATION, TEMPLATE_ID) VALUES ('\(musicInfo.musicID)', '\(musicInfo.musicType)', '\(musicInfo.name)', '\(musicInfo.musicPath)', '\(musicInfo.parentID)', '\(musicInfo.parentType)', '\(musicInfo.startTimeOfAudio)', '\(musicInfo.endTimeOfAudio)', '\(musicInfo.startTime)', '\(musicInfo.duration)', '\(musicInfo.templateID)')"
        return insertNewEntry(query: query)
    }

    // Delete query for all columns
    func deleteMusicInfo() -> Bool {
        let query = "DELETE FROM MUSIC_INFO"
        return executeQuery(query: query)
    }

    // Delete query for individual column
    func deleteMusicInfoByColumn(columnName: String, columnValue: String) -> Bool {
        let query = "DELETE FROM MUSIC_INFO WHERE \(columnName) = '\(columnValue)'"
        return executeQuery(query: query)
    }

    func updateMusicInfo(musicInfo: MusicInfo) -> Bool { // ParentID - Music Info
        let query = "UPDATE MUSIC_INFO SET MUSIC_TYPE = '\(musicInfo.musicType)', NAME = '\(musicInfo.name)', MUSIC_PATH = '\(musicInfo.musicPath)', PARENT_ID = '\(musicInfo.parentID)', PARENT_TYPE = '\(musicInfo.parentType)', START_TIME_OF_AUDIO = '\(musicInfo.startTimeOfAudio)', END_TIME_OF_AUDIO = '\(musicInfo.endTimeOfAudio)', START_TIME = '\(musicInfo.startTime)', DURATION = '\(musicInfo.duration)', TEMPLATE_ID = '\(musicInfo.templateID)' WHERE MUSIC_ID = '\(musicInfo.musicID)'"
        return executeQuery(query: query)
    }
    
    func updateMusicInfoForTemplateID(templateID: Int, musicInfo: MusicInfo) -> Bool {
        let query = "UPDATE MUSIC_INFO SET NAME = '\(musicInfo.name)', MUSIC_TYPE = '\(musicInfo.musicType)', DURATION = '\(musicInfo.duration)', MUSIC_PATH = '\(musicInfo.musicPath)' WHERE TEMPLATE_ID = '\(templateID)'"
        return executeQuery(query: query)
    }

    // Update query for individual column
    func updateMusicInfoColumn(columnName: String, columnValue: String, conditionColumn: String, conditionValue: String) -> Bool {
        let query = "UPDATE MUSIC_INFO SET \(columnName) = '\(columnValue)' WHERE \(conditionColumn) = '\(conditionValue)'"
        return executeQuery(query: query)
    }
}
