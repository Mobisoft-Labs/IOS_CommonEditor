//
//  MediaInfo.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation


public struct MusicInfo{
    public var musicID: Int = 0
    public var musicType: String = ""
    public var name: String = ""
    public var musicPath: String = ""
    public var parentID: Int = 0
    public var parentType: Int = 0
    public var startTimeOfAudio: Float = 0.0
    public var endTimeOfAudio: Float = 0.0
    public var startTime: Float = 0.0
    public var duration: Float = 0.0
    public var templateID : Int = 0 //Updated by Neeshu
    
    public init(musicID: Int = 0, musicType: String = "", name: String = "", musicPath: String = "", parentID: Int = 0, parentType: Int = 0, startTimeOfAudio: Float = 0.0, endTimeOfAudio: Float = 0.0, startTime: Float = 0.0, duration: Float = 0.0, templateID: Int = 0) {
        self.musicID = musicID
        self.musicType = musicType
        self.name = name
        self.musicPath = musicPath
        self.parentID = parentID
        self.parentType = parentType
        self.startTimeOfAudio = startTimeOfAudio
        self.endTimeOfAudio = endTimeOfAudio
        self.startTime = startTime
        self.duration = duration
        self.templateID = templateID
    }
}
