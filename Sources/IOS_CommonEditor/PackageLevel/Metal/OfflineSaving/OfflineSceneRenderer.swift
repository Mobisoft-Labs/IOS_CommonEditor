//
//  OfflineSceneRenderer.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 13/05/24.
//

import Foundation
import Metal
import CoreImage
import UIKit
import CoreMedia
import Combine


public enum SceneOfflineRenderError : Error {
    
    case noPageAvailableIndB
    case CouldNotCreateMPage
    case MTLBufferCreationError
    case MTLTextureToImageError
    case custom(message:String)

}

public class OfflineSceneRenderer : SceneComposable  {
    var sceneConfig: SceneConfiguration?
    
    var logger: PackageLogger
    
    var resourceProvider: TextureResourceProvider
    
    var cancelPreparing: Bool = false
    
    var sceneProgress: ((Float) -> Void)?
    
    var updateThumb: Bool = false
    
    var textureCache : TextureCache
    
    var isUserSubscribed: Bool = false
    
    var currentSceneSize: CGSize = .zero
    
    
    
    public enum OfflineRenderingState : Equatable {
        public static func == (lhs: OfflineSceneRenderer.OfflineRenderingState, rhs: OfflineSceneRenderer.OfflineRenderingState) -> Bool {
            lhs.value == rhs.value
        }
        
        
        case Preparing
        case InProgress(_ progress : Float)
        case Cancelling
        case Cancelled
        case Failed(error: SceneOfflineRenderError)
        case Complete
        
        var value : Int {
            switch self {
            case .Preparing:
                0
            case .InProgress( _):
                1
            case .Cancelling:
                2
            case .Cancelled:
                3
            case .Failed(let error):
                4
            case .Complete:
                5
            }
        }
        
        public var progress : Float {
            switch self {
            case .Preparing:
                return 0
            case .InProgress(let progress):
                return progress
           // default - 100
            default:
                return 100
            }
        }
        
        var message : String {
            switch self {
            case .Preparing:
                "PREP"
            case .InProgress(let progress):
                "IP \(progress)"

            case .Cancelled:
                "CAN"
            case .Cancelling:
                "CANNG"
            case .Failed(let error):
                "FAIL \(error)"
            case .Complete:
                "DONE"
            }
        }
    }
    
    var cancellables: Set<AnyCancellable> = []

    public var offlineRenderState : ((OfflineRenderingState)->())?
    
    
    var metalThread: MetalThread =   MetalThread(label: "MetalThreadOfflineSaving")

    
    var commandQueue: MTLCommandQueue!
    
    var canCacheMchild: Bool = false
    
    func cacheChild(key: Int, value: MChild) { }
        
    var context : CIContext!
    
    var fileHandler : ExportFileHandler
    
    public init(settings: ExportSettings , fileHandler : ExportFileHandler , isUserSubscribed : Bool, logger: PackageLogger, resourceProvider: TextureResourceProvider, sceneConfig: SceneConfiguration){
        self.logger = logger
        self.resourceProvider = resourceProvider
        self.sceneConfig = sceneConfig
        textureCache = TextureCache(maxSize: settings.maxSize, resourceProvider: resourceProvider, logger: logger)
        context = CIContext()
//        ShaderLibrary.initialise()
//        MVertexDescriptorLibrary.initialise()
//        PipelineLibrary.initialise()
        commandQueue = MetalDefaults.GPUDevice.makeCommandQueue()!
        self.exportSettings = settings
        self.fileHandler = fileHandler
        self.isUserSubscribed = isUserSubscribed
        recorder = IOSMetalRecorder(settings: settings, fileHandler: fileHandler, logger: logger)
                
    }
    
    var exportSettings = ExportSettings()
    var finalOutputSize : CGSize = .zero
    var currentScene : MScene?
    
    
    
    public func saveOffline(tempId:Int)  {
        cancellables.removeAll()
        task = Task(priority: .background, operation: {
            await prepareForSaving(tempId: tempId)
            logger.logError("finish preparing")
            if (cancelOfflineSaving)  {
                
                if cancelOfflineSaving {
                    fileHandler.deleteVideoURL()
                }
                offlineRenderState?(.Cancelled)
                cancelOfflineSaving = false
                logger.logError("return")
                return
            }else if let task2 = task, task2.isCancelled {
                if cancelOfflineSaving {
                    fileHandler.deleteVideoURL()
                }
                offlineRenderState?(.Cancelled)
                cancelOfflineSaving = false
                logger.logError("return")
                return
            }
            
            if exportSettings.exportType == .Video {
                // scene is ready to render
                logger.logError("Started Rendering...")
                await startRenderingOffline()
            } else {
                await saveAsImage()
            }
        })

        
        
    }
    
    func saveAsImage() async {
        currentScene?._renderingMode = .Edit
        offlineRenderState?(.InProgress(25))
        
        guard let texture = createTexture(forTime: exportSettings.thumbTime) else {
            logger.printLog("Unlable TO Create Texture")
            offlineRenderState?(.Failed(error: .custom(message: "Image Creation Failed")))
            return
        }

        guard let image = Conversion.getUIImage(texture: texture , flipX: true) else {
            logger.printLog("Unable To Convert To Image")
            offlineRenderState?(.Failed(error: .custom(message: "Image Creation Failed")))
            return
        }
        offlineRenderState?(.InProgress(50))

        fileHandler.deleteImageURL()
        let folderKey = exportSettings.folderKey
        guard let url = fileHandler.createImageURL(name: folderKey, ext: exportSettings.exportImageFormat.ext) else {
            logger.printLog("Unable To create Image URL")
            offlineRenderState?(.Failed(error: .custom(message: "Image Creation Failed")))
            return
        }
        offlineRenderState?(.InProgress(75))

        var data : Data?
        
        if exportSettings.exportImageFormat == .JPEG {
            data = image.jpegData(compressionQuality: 0.8)
        }else {
            data = image.pngData()
        }
        
        do {
            try data?.write(to: url, options: .atomic)
        } catch let error {
            logger.printLog("Unable To create Image URL")
            offlineRenderState?(.Failed(error: .custom(message: "Image Creation Failed")))
            return
        }

        offlineRenderState?(.Complete)
        
    }
    
    func prepareForSaving(tempId : Int) async  {
//        return await withCheckedContinuation { continuation in
        
        let resolutionSize =  exportSettings.maxSize  //exportSettings.exportType == .Photo ? exportSettings.exportImageFormat.size : exportSettings.resolution.size
        
        if cancelPreparing {
            logger.logError("return")
            return
        }
        guard let templateInfo = DBMediator.shared.fetchTemplate(tempID: tempId, refSize: resolutionSize , onlinePreview: false) else {
            logger.logError("Template Info failed To Fetch ")
            offlineRenderState?(.Failed(error: .custom(message: "Template Info failed To Fetch ")))
            return
        }
        DispatchQueue.main.async{ [self] in
            exportSettings.videoLength = templateInfo.totalDuration
        }
       currentScene = MScene(templateInfo: templateInfo)
       currentSceneSize = templateInfo.ratioSize
        currentScene?._canRenderWatermark = !isUserSubscribed
        if exportSettings.exportType == .Photo{
            currentScene?._shouldOverrideCurrentTime = true
        }else{
            currentScene?._shouldOverrideCurrentTime = false
        }
       
        for page in templateInfo.pageInfo {
            if cancelPreparing {
                return
            }
            guard let mPage = await createPage(page) else {
                logger.logError("Could Not Create MPage\(page.modelId)")
//                continuation.resume(returning:.failure(.CouldNotCreateMPage))
                offlineRenderState?(.Failed(error: .CouldNotCreateMPage))
                return
            }
            if  let watermark = await createWatermark(templateInfo.ratioSize) {
                mPage.watermarkChild = watermark
                watermark.setMDuration(templateInfo.totalDuration)
            }
            
            currentScene?.addChild(mPage)
        }
            currentScene?.context = MContext(drawableSize: templateInfo.ratioSize)
            currentScene?.context.rootSize = templateInfo.ratioSize

            finalOutputSize = templateInfo.ratioSize
        if cancelPreparing {
            
            return
        }
        currentScene?.createEmptyFBOTexture(drawableSize: finalOutputSize)
       
    }
    
    var recorder : IOSMetalRecorder!
    var cancelOfflineSaving = false

    
    

    var task : Task<Void, Never>?
    
    func startRenderingOffline() async  {
        
        //  metalThread.async { [unowned self] in
        
        //
        
        
            
            currentScene?._renderingMode = .Animating
            let  isRecording = true
           
            let FPS = exportSettings.FPS.frameRate
            let TotalTime : Double = Double(exportSettings.videoLength)
            let NumberOfFrames = Int(Double(FPS) * Double(TotalTime ))
            var frameDecodedCount = 0
        let interval : Float = Float( 1.0/Float(FPS) )
        logger.logError("interval:\(interval) , NumberOfFrames: \(NumberOfFrames) , TotalTime: \(TotalTime) , FPS: \(FPS)")
            var gupReadyToRender = true
            var startedReording = false
            if isRecording {
                
                var isAudioConfigDone = false
                recorder.configureAUDIO { (bool) in
                    isAudioConfigDone = bool
                    self.logger.logInfo("Audio Config \(bool) ")

                }
                logger.logError("Before entering While : \(frameDecodedCount) : \(NumberOfFrames) ")
                while frameDecodedCount <= NumberOfFrames{
//                    logError("\(frameDecodedCount) : \(NumberOfFrames) ")
                    if cancelOfflineSaving {
                        logger.logError("Cancel Pressed : \(cancelOfflineSaving)")
                        break
                    }
                    
                    if isAudioConfigDone {
                       
                        // var size = CGSize(width: drawableSize.width*contentScaleFactor, height: drawableSize.height*contentScaleFactor)
                        let width =  finalOutputSize.width //  drawableSize.width * MyScreen.nativeScale
                        let height =  finalOutputSize.height // drawableSize.height * MyScreen.nativeScale
                        let dSize = CGSize(width: width, height: height)
                        if !startedReording {
                            _ = recorder.startRecording(size: dSize, Duration: TotalTime)
                            startedReording = true
                            logger.logError("Recording Started")
                        }
                        
                       
                        if gupReadyToRender {
                            gupReadyToRender = false
                            
                            let presentationTime = Float(frameDecodedCount) * (interval)
                            
                            
                            autoreleasepool {
                                
                                let drawTime = frameDecodedCount == 0 ? exportSettings.thumbTime : presentationTime
                                
                                guard let texture = createTexture(forTime: drawTime) else {
                                    logger.logError("Texture Not Found Started")
                                    return
                                }
                                
                                if isRecording {
                                    
                                    if cancelOfflineSaving {
                                        logger.logError("Cancel Saving")
                                        return
                                    }
                                    
                                    let status = ((presentationTime/Float(TotalTime))*100).rounded()
                                    DispatchQueue.main.async { [ self] in
                                        offlineRenderState?(.InProgress(status))
//                                        logError("Progress \(status) ")
                                    }
                                    recorder.writeFrame(forTexture:texture, framePresentationTime: CMTime(seconds: Double(presentationTime), preferredTimescale: CMTimeScale(FPS)))
//                                    logError("Frame Did Write")
                                    frameDecodedCount = frameDecodedCount + 1
                                }
                                gupReadyToRender = true
                             
                            }
                        }
                    }
                }
                
            }
            recorder.isVideoCompleted = true
            let presentationTime = Float(frameDecodedCount) * (interval)
            if cancelOfflineSaving {
                recorder.isAudioCompleted = true
                
            }else {
                logger.logError("Writing Audio")
                recorder.startWritingAudio(maxDuration:  Double(exportSettings.videoLength))
            }
        if recorder == nil  {
            logger.logError("CANCEL ISSUE - recorder is nil \(cancelOfflineSaving)")
            //return
        }
            recorder.endRecording { [self] in
                if cancelOfflineSaving {
                    fileHandler.deleteVideoURL()
                }
                logger.logError("Video Export \(cancelOfflineSaving ? "Cancelled" : "Complete")")

                offlineRenderState?(cancelOfflineSaving ? .Cancelled : .Complete)
                cancelOfflineSaving = false
                
            }
        
    }
        
       // }
 //   }
//
    public func cancelSaving(){
        if cancelPreparing {
            logger.logError("Alredy Cancelling")
            return
        }
        //onMetalThread { [self] in
        DispatchQueue.main.async { [weak self] in
            self?.offlineRenderState?(.Cancelling)
        }
            cancelPreparing = true
            task?.cancel()
            cancelOfflineSaving = true
            recorder.isRecording = false
        logger.logError("Cancel Saving")
       // }
        
    }
    
    
  func  createTexture(forTime:Float) -> MTLTexture? {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            logger.logError("Could Not Create MTLBuffer")
            //continuation.resume(returning:.failure(.MTLBufferCreationError))
            return nil
        }

                guard let currentScene = currentScene else {
                    logger.logError("Scene Not Avaialble to render")
                    return nil }
                
                currentScene._currentTime = forTime

                currentScene.renderPages(commandbuffer: commandBuffer)
                
                commandBuffer.commit()
                
                commandBuffer.waitUntilCompleted()
                
                guard let texture = currentScene.myFBOTexture else {
                    logger.logError("texture not created FBO")
                    return  nil }
      
      return texture
    }
}
