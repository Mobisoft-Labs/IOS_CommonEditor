//
//  MediaInfo.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation


public struct MusicInfo{
    var musicID: Int = 0
    var musicType: String = ""
    public var name: String = ""
    public var musicPath: String = ""
    var parentID: Int = 0
    var parentType: Int = 0
    var startTimeOfAudio: Float = 0.0
    var endTimeOfAudio: Float = 0.0
    var startTime: Float = 0.0
    var duration: Float = 0.0
    var templateID : Int = 0 //Updated by Neeshu
}
