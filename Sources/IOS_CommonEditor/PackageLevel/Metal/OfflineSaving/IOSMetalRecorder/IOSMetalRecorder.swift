//
//  IOSMetalRecorder.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/01/23.
//

import UIKit
import AVFoundation
import Photos


//
//  Recorder.swift
//  PosterMaker - Metal
//
//  Created by SimplyEntertaining on 4/10/19.
//  Copyright © 2019 SimplyEntertainingLLC. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import simd


public struct PhotoLibraryError: Error {
    let reason: String
    var localizedDescription: String {
        return "No placeholder on Photo library change request...maybe missing permissions or disk space?\nReason: \(reason)"
    }
}


public protocol ExportFileHandler {
    func createNewURL(name:String,ext:String) -> URL?
    func deleteVideoURL()
    func createImageURL(name:String,ext:String) -> URL?
    func deleteImageURL()
}

class IOSMetalRecorder {
    
    var settings : ExportSettings = ExportSettings()
    // AUDIO
    var asset:AVAsset!
    var assetReaderAudioOutput:AVAssetReaderTrackOutput!
    var assetWriterAudioInput:AVAssetWriterInput!
    // VIDEO
    
    private var assetWriter: AVAssetWriter!
    private var assetWriterVideoInput: AVAssetWriterInput!
    private var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor!
    // LocalVar
    var assetReader : AVAssetReader!
    var rwAudioSerializationQueue: DispatchQueue!
    var inputURL:URL!
  // weak var metalRecorderDelegate : MetalRecorderDelegate!
    open var isAudioCompleted = false
    open var isVideoCompleted = false
    public var videoURL:URL!
    // Recording
    var isRecording = false
    var isAudioReady = false
    var recordingStartTime = TimeInterval(0)
    var TimeRanges = [CMTimeRange]()
    var logger: PackageLogger
/*
 
 1. Video Setup
2. Create Audio Reader  (Create Reader)
     3. Configure Reader with Track (Inside Create Reader)
     Audio WRiterSetup (Write Audio)
     func WriteAudio {
     -> create Reader
     ->Load Values simultaneously
     -> Start AssetReading
     -> reader Output
     
     ->
     
     }
 
 
 
 */
    var fileHandler : ExportFileHandler

    init(settings:ExportSettings ,  fileHandler : ExportFileHandler, logger: PackageLogger) {
        self.settings = settings
        self.fileHandler = fileHandler
        self.logger = logger
    }
    
    func configureAUDIO(_ completionHandler: @escaping (Bool) -> ()){
        if settings.isMute {
            self.isAudioReady = true
            completionHandler(true)
        }
        // var isSuccess = false
        let rwAudioSerializationQueueDescription = " rw audio serialization queue"
        
        // Create the serialization queue to use for reading and writing the audio data.
        rwAudioSerializationQueue = DispatchQueue(label: rwAudioSerializationQueueDescription)
        assert(rwAudioSerializationQueue != nil, "Failed to initialize Dispatch Queue")
        let filePath = settings.audioFileURL
        
        if let fileUrl = URL(string: filePath),
           FileManager.default.fileExists(atPath: filePath) {
            inputURL = fileUrl
        }else{
            var audioFileName = settings.audioFileURL.replacingOccurrences(of: "music/", with: "").replacingOccurrences(of: ".mp3", with: "")
            var url = Bundle.main.url(forResource: audioFileName, withExtension: settings.audioExt)
            if url == nil  || audioFileName == ""{
                logger.printLog("unable to add any audio tracks.adding silent audio file")
                url = Bundle.main.url(forResource: "silence", withExtension: "mp3")
            }
            inputURL = url
        }
       
        
        asset = AVAsset(url: inputURL)
        assert(asset != nil, "Error creating AVAsset from input URL")
        
      
        
        asset.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: {
            var success = false
            var localError:NSError?
            success = (self.asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded)
            self.logger.printLog("\(success)")
            if success  {
                self.isAudioReady = true
                self.logger.printLog("Audio Load Success ")
                completionHandler(true)
            }else{
              //  textroErrorStatus = .AudioWritingFailed
                self.logger.printLog("Audio Failed To Load")
                self.isAudioReady = true
                completionHandler(true)
            }
           
        }
        
        
        )
       
    }
    
    
    func setupAudioReadWriter( asset: AVAsset)->Bool{
       
        if asset.duration.seconds <= 0 {
            return true
        }
        
        var assetAudioTrack:AVAssetTrack? = nil
        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        
        if (audioTracks.count > 0) {
            assetAudioTrack = audioTracks[0]
        }
        
        
        if (assetAudioTrack != nil) {
            
            let decompressionAudioSettings:[String : Any] = [
                AVFormatIDKey:Int(kAudioFormatLinearPCM)
            ]
            
            assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack!, outputSettings: decompressionAudioSettings)
            assert(assetReaderAudioOutput != nil, "Failed to initialize AVAssetReaderTrackOutout")
            //assetReader.add(assetReaderAudioOutput)
            
            var channelLayout = AudioChannelLayout()
            memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size * 2);
            channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
            
            let outputSettings:[String : Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 96000,
                AVNumberOfChannelsKey: 2,
                AVChannelLayoutKey: NSData(bytes:&channelLayout, length:MemoryLayout<AudioChannelLayout>.size),]
            
            assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
            assert(rwAudioSerializationQueue != nil, "Failed to initialize AVAssetWriterInput")
            assetWriter.add(assetWriterAudioInput)
            
        }
        logger.printLog("Finsihed Setup of AVAssetReader and AVAssetWriter")
        return true
    }
    
    func setUpVideoReaderWriter(size:CGSize) -> Bool{
        let outputSettings: [String: Any] = [ AVVideoCodecKey : AVVideoCodecType.h264,
                                              AVVideoWidthKey : size.width,
                                              AVVideoHeightKey : size.height ]
        
        assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        
        let sourcePixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String : size.width,
            kCVPixelBufferHeightKey as String : size.height ]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput,
                                                                           sourcePixelBufferAttributes: sourcePixelBufferAttributes)
        
        assetWriter.add(assetWriterVideoInput)
        return true
        
    }
    func configureReaderAndWriters(){
        do {
            videoURL = fileHandler.createNewURL(name: settings.name, ext: settings.resolution.ext)
            assetWriter = try AVAssetWriter(outputURL: videoURL, fileType: AVFileType.mp4) // mp4 JD Update
        } catch {
            logger.printLog("error")
        }
    }
    
    
    // RECORDING // Initialising Recorder
    func startRecording (size: CGSize , Duration: Double)->Bool {
        
        var didSucced : Bool = false
     
        // Configure And initialise AudioVideo Writer
        configureReaderAndWriters()
        
        
        _ = setUpVideoReaderWriter(size: size)
        // AUDIO
        _ =  setupAudioReadWriter(asset: self.asset)
        
        
        
        assetWriter.shouldOptimizeForNetworkUse = true
        assetWriter.startWriting()
        
        // set CM time parameters
        var assetCMTime = asset.duration;
        var timeInSec = CMTimeMakeWithSeconds(1, preferredTimescale: assetCMTime.timescale);
        var currentCMTime = CMTimeMake(value: 0,timescale: assetCMTime.timescale);
        
      //  assetReader.startReading()
        logger.printLog("staaaaaart")
       // start()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        // startAssetReaderAndWriter()
        recordingStartTime = CACurrentMediaTime()
        isRecording = true
        didSucced = true
        
        return didSucced
    }
    
    func callBackFunc(){
        isAudioCompleted = true
        self.assetWriterAudioInput.markAsFinished()
       
    }
    
    
    func endRecording(completion : @escaping (()->Void)) {
        isRecording = false
        if isVideoCompleted && isAudioCompleted {
        assetWriterVideoInput.markAsFinished()
            assetWriter.finishWriting(completionHandler: completion)
        }
    }
    
   
    
   
    func writeFrame(forTexture texture: MTLTexture , framePresentationTime: CMTime) {
        if !isRecording {
            return
        }
        
        logger.printLog("\(framePresentationTime.seconds)")
        while !assetWriterVideoInput.isReadyForMoreMediaData   {} //
        
        guard let pixelBufferPool = assetWriterPixelBufferInput.pixelBufferPool else {
            logger.printLog("Pixel buffer asset writer input did not have a pixel buffer pool available; cannot retrieve frame")
            return
        }
        
        var maybePixelBuffer: CVPixelBuffer? = nil
        let status  = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &maybePixelBuffer)
        if status != kCVReturnSuccess {
            logger.printLog("Could not get pixel buffer from asset writer input; dropping frame...")
            return
        }
        
        guard let pixelBuffer = maybePixelBuffer else { return }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        let pixelBufferBytes = CVPixelBufferGetBaseAddress(pixelBuffer)!
        
        // Use the bytes per row value from the pixel buffer since its stride may be rounded up to be 16-byte aligned
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        
        texture.getBytes(pixelBufferBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        //writeAudio()
       
        let presentationTime = framePresentationTime
        assetWriterPixelBufferInput.append(pixelBuffer, withPresentationTime: presentationTime)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
    }
    
    func writeAudio(){
        if settings.isMute {
            isAudioCompleted = true
            return
        }
        
        while (self.assetWriterAudioInput.isReadyForMoreMediaData )  {
            var sampleBuffer = self.assetReaderAudioOutput.copyNextSampleBuffer()
            if(sampleBuffer != nil) {
                self.assetWriterAudioInput.append(sampleBuffer!)
                sampleBuffer = nil
                
            }
            
            logger.printLog("Audio Is Reached Duration")

        }
       isAudioCompleted = true
        
    }

  
    // TEST LOOP JD
    var readerVideoTrackOutput : AVAssetReaderTrackOutput!
    public func createReader() -> AVAssetReader
    {
        
        var assetRead:AVAssetReader!
        var assetAudioTrack:AVAssetTrack? = nil
        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        
        if (audioTracks.count > 0) {
            assetAudioTrack = audioTracks[0]
        }
        
        do{
            assetRead = try AVAssetReader(asset: self.asset)
        if (assetAudioTrack != nil) {
            
            let outputSettings:[String : Any] = [
                AVFormatIDKey:Int(kAudioFormatLinearPCM)
            ]
            
            readerVideoTrackOutput = AVAssetReaderTrackOutput(track: assetAudioTrack!, outputSettings: outputSettings)
            
            readerVideoTrackOutput.alwaysCopiesSampleData = false

            assetRead.add(readerVideoTrackOutput)

            
        }
        
      

         
            
        }catch{
            
        }
        
        return assetRead
    }
 
    func CreatetimeRanges(ManualDuration:Double? = nil) -> [CMTimeRange] {
        
        var TimeRanges = [CMTimeRange]()
        
        let TotalTime = ManualDuration ?? Double(settings.videoLength)
        let Audiotime = asset.duration.seconds
        let RangeInstances = Int((TotalTime/Audiotime).rounded(.awayFromZero))
        var remainingTime = TotalTime
        var currentTime = 0
        for count in 1...RangeInstances {
            if remainingTime > 0.0 {
                var startTime = CMTime(seconds: 0.0, preferredTimescale: asset.duration.timescale)
                
                if remainingTime > Audiotime {
                    let TimeRange =  CMTimeRange(start: startTime, duration: CMTime(seconds: Audiotime, preferredTimescale: asset.duration.timescale))
                    TimeRanges.append(TimeRange)
                     remainingTime = remainingTime - Audiotime
                }else{
                    let TimeRange =  CMTimeRange(start: startTime, duration: CMTime(seconds: remainingTime, preferredTimescale: asset.duration.timescale))
                     TimeRanges.append(TimeRange)
                    remainingTime = 0.0
                }
                
                
                
            }else{
               // endRecording((false,MyVideo?))
                break;
                
            }
        }
        
        return TimeRanges
    }
    
    /*
 
     for timeRanges {
     
     
     }
 
 */
    
    
    public func startWritingAudio(maxDuration:Double) {
        if settings.isMute {
            callBackFunc()
            return
        }
        
        if asset.duration.seconds <= 0 {
            callBackFunc()
            return
        }
        TimeRanges =  CreatetimeRanges(ManualDuration: maxDuration)
        for timeRange in 0...TimeRanges.count-1 {
        
        self.assetReader = createReader()
  
        
         //assetReader.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTime(seconds: VIDEO_DURATION, preferredTimescale: asset.duration.timescale))
            assetReader.timeRange = TimeRanges[timeRange]
                guard self.assetReader.startReading() else {
                    logger.printLog("Couldn't start reading")
                    return
                }
                
              //  var readerVideoTrackOutput:AVAssetReaderOutput? = nil;
                
//                for output in self.assetReader.outputs {
//                    if(output.mediaType == AVMediaType.video.rawValue) {
//                        readerVideoTrackOutput = output;
//                    }
//                }
        
                while (self.assetReader.status == .reading) {
                   // self.writeAudio()
                     while(self.assetWriterAudioInput.isReadyForMoreMediaData )  {
                    var sampleBuffer =  readerVideoTrackOutput!.copyNextSampleBuffer()
                    if(sampleBuffer != nil) {
                        self.assetWriterAudioInput.append(sampleBuffer!)
                        sampleBuffer = nil
                        
                    }else{
                        logger.printLog("audio reached")
                        break;
                        }
                    }
                }
                
                if (self.assetReader.status == .completed) {
                    self.assetReader.cancelReading()
                    
                    if timeRange == TimeRanges.count - 1 {
                        // TODO: Restart movie processing
                       // self.start()
                        //self.isDoneWithLoop = true
                        self.callBackFunc()
                        break;
                    }
                }
            
        }
        
    }
    

}


