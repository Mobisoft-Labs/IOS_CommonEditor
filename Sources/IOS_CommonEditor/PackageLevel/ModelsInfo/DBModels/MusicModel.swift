//
//  MusicModel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import Foundation
import MediaPlayer

public struct MusicModel {
    public var musicID: Int = 0
    public var musicName: String = ""
    public var localPath: String = ""
    public var displayName: String = ""
    var fileExtension: String = ""
    var serverPath: String = ""
    var thumbImageServerPath: String = ""
    var thumbImageLocalPath: String = ""
    var isFav: Bool = false  
    public var duration: Float = 0
    public var musicType: String = ""
    
    public init(musicID: Int = 0, musicName: String = "", localPath: String = "", displayName: String = "", fileExtension: String = "", serverPath: String = "", thumbImageServerPath: String = "", thumbImageLocalPath: String = "", isFav: Bool = false, duration: Float = 0, musicType: String = "") {
        self.musicID = musicID
        self.musicName = musicName
        self.localPath = localPath
        self.displayName = displayName
        self.fileExtension = fileExtension
        self.serverPath = serverPath
        self.thumbImageServerPath = thumbImageServerPath
        self.thumbImageLocalPath = thumbImageLocalPath
        self.isFav = isFav
        self.duration = duration
        self.musicType = musicType
    }
}

extension MusicModel{
    func getAVAsset()->AVURLAsset?{
        let path = Bundle.main.path(forResource: "\(localPath)", ofType:"mp3")
        let soundAsset = AVURLAsset(url: URL.init(fileURLWithPath: path ?? ""))
        return soundAsset
    }
}
