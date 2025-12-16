//
//  AudioPlayer.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 20/03/24.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayer: ObservableObject{
    static let shared = AudioPlayer()
    
    var audioPlayer: AVAudioPlayer?
    
    func playAudio(with music: MusicModel) {
        guard let url = Bundle.main.url(forResource: music.localPath, withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
}

class AudioPlayerForMusicView: NSObject, ObservableObject, AVAudioPlayerDelegate , PlayerControlsReadObservableProtocol  , ActionStateObserversProtocol {
    
    var logger: PackageLogger?
    var engineConfig: EngineConfiguration?
    
    deinit {
        logger?.printLog("de-init \(self)")
    }
    
    func setPackageLogger(logger: PackageLogger, engineConfig: EngineConfiguration){
        self.logger = logger
        self.engineConfig = engineConfig
    }
    
    public var actionStateCancellables: Set<AnyCancellable> = []
    
    public func observeCurrentActions() {
        
        guard let templateHandler = self.templateHandler else {
            logger?.printLog("template handler nil")
            return }
        
        actionStateCancellables.removeAll()
        
        templateHandler.currentActionState.$currentMusic.dropFirst().sink { [weak self]
            newMusicInfo in
            guard let self = self else { return }
            guard let playerControls = templateHandler.playerControls else {
                logger?.logError("template handler nil")
                return }
            if newMusicInfo == nil{
                self.audioPlayer = nil
            }else{
                playerControls.renderState = .Paused
            }
        }.store(in: &actionStateCancellables)
    }
    
   
    public var playerControlsCancellables: Set<AnyCancellable> = []

    func setTemplateHandler(templateHandler:TemplateHandler) {
        self.templateHandler = templateHandler
        observePlayerControls()
    }
    
    
    var audioPlayer: AVAudioPlayer?
//    var looper: TimeLoopHnadler?
//    var currentMusic: MusicInfo?
    weak var templateHandler: TemplateHandler?
    
    var playbackPosition: TimeInterval = 0.0
    var timelineTime: TimeInterval = 16.0
    
    func playAudio(with music: MusicInfo?) {
        if music != nil{
            // Try to play audio from the file URL
            if music?.musicType == "APP"{
                let musicPath = music?.musicPath
                    .replacingOccurrences(of: "music/", with: "")  // Remove the prefix
                    .replacingOccurrences(of: ".mp3", with: "")
                guard let bundleUrl = Bundle.main.url(forResource: musicPath, withExtension: "mp3") else {
                    print("Error: \(music?.musicPath ?? "unknown").mp3 not found in Bundle.")
                    return
                }
                
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: bundleUrl)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.currentTime = playbackPosition
                    audioPlayer?.play()
                    audioPlayer?.numberOfLoops = -1
                    if templateHandler?.currentActionState.isMute == true{
                        muteAudio()
                    }else{
                        unMuteAudio()
                    }
                    print("Playing audio from Bundle")
                } catch {
                    print("Error playing audio from Bundle: \(error.localizedDescription)")
                }
            }else{
                if let filePath = music?.musicPath, let decodedFileName = filePath.removingPercentEncoding, let fileURL = engineConfig?.getMuicPath()?.appending(component: decodedFileName), FileManager.default.fileExists(atPath: fileURL.path){
                    // Play audio from the file URL
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                        audioPlayer?.delegate = self
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.currentTime = playbackPosition
                        audioPlayer?.play()
                        audioPlayer?.numberOfLoops = -1
                        if templateHandler?.currentActionState.isMute == true{
                            muteAudio()
                        }else{
                            unMuteAudio()
                        }
                        print("Playing audio from file URL")
                    } catch {
                        print("Error playing audio from file URL: \(error.localizedDescription)")
                    }
                }else if let localPath = music?.musicPath, let decodedFileName = localPath.removingPercentEncoding, let localFileURL =  engineConfig?.getLocalMusicPath()?.appending(component: decodedFileName), FileManager.default.fileExists(atPath: localFileURL.path){
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: localFileURL)
                        audioPlayer?.delegate = self
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.currentTime = playbackPosition
                        audioPlayer?.play()
                        audioPlayer?.numberOfLoops = -1
                        if templateHandler?.currentActionState.isMute == true{
                            muteAudio()
                        }else{
                            unMuteAudio()
                        }
                        print("Playing audio from file URL")
                    } catch {
                        print("Error playing audio from file URL: \(error.localizedDescription)")
                    }
                }
            }
        }

    }
    
    
    private func calculateLoopCount() -> Int {
        let loopsNeeded = Int(ceil(Float(timelineTime) / templateHandler!.currentActionState.currentMusic!.duration))
        return loopsNeeded
    }
    
    func seek(to time: TimeInterval) {
        playbackPosition = time
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        playbackPosition = audioPlayer?.currentTime ?? 0.0
    }
    
    // AVAudioPlayerDelegate method - called when audio playback finishes
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        player.play()
        print("Audio playback finished successfully!")
//        audioPlayer?.pause()
//        audioPlayer?.currentTime = 0.0
//        playAudio(with: templateHandler!.currentActionState.currentMusic!)
        playbackPosition = 0.0
        player.currentTime = 0
        player.play()
    }
    
    func muteAudio(){
        audioPlayer?.volume = 0.0
    }
    
    func unMuteAudio(){
        audioPlayer?.volume = 1.0
    }
    
    public func observePlayerControls() {
        
        guard let templateHandler = self.templateHandler else {
            logger?.printLog("template handler nil")
            return }
        
        playerControlsCancellables.removeAll()
        logger?.logVerbose("AudioPlayer + PlayerControls listeners ON \(playerControlsCancellables.count)")
        
        templateHandler.playerControls?.$currentTime.dropFirst().sink { [weak self] currentTime in
            guard let self = self else { return }
            self.playbackPosition = TimeInterval(currentTime)
        }.store(in: &playerControlsCancellables)
        
        templateHandler.playerControls?.$renderState.dropFirst().sink { [weak self] state in
            guard let self = self else { return }
            
            switch state{
            case .Prepared:
                break
            case .Playing:
                playAudio(with: templateHandler.currentActionState.currentMusic)
            case .Paused:
                pauseAudio()
            case .Stopped:
                audioPlayer?.stop()
                playbackPosition = 0.0
            case .Completed:
                audioPlayer?.pause()
                break
            }
        }.store(in: &playerControlsCancellables)
        
    }

}
