//
//  MetalEngine.swift
//  VideoInvitation
//
//  Created by HKBeast on 21/08/23.
//

import Foundation
import MetalKit
import UIKit
import Combine
import Network

public enum EditorUIStates {
    
    case SelectThumbnail
    case UseMe
    case Preview
    case Purchase
//    case ReelsPreview
//    case LoadingPreview
    case MultipleSelectMode
    case Personalised
}

//@MainActor
public class MetalEngine : ObservableObject, TemplateObserversProtocol , ActionStateObserversProtocol , PlayerControlsReadObservableProtocol  {
    
    enum FetchStatus {
        case Idle , InProgress , Success , Failed , NoInternet
    }
   @Published var isLoading : Bool = false
    
    @Published var fetchStatus : FetchStatus = .Idle
    @Published var progressUnit : CGFloat = 0
    @Published var baseSize : CGSize = .zero
    
    var isDBDisabled : Bool = false
    var shouldRenderOnScene : Bool = true  {
        didSet {
            sceneManager.shouldRenderOnScene = shouldRenderOnScene

        }
    }
    public var playerControlsCancellables: Set<AnyCancellable> = []
    
    public var modelPropertiesCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    public var actionStateCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
        
    var TURN_ON_RENDERING = true
    
    public var editorView : EditorView?
    
    public var templateHandler : TemplateHandler!
    
    public var editorUIState : EditorUIStates = .UseMe
    let minStartTime: Float = 3.0
    public var thumbManagar : ThumbManager?
    var logger: PackageLogger
    var sceneConfig: SceneConfiguration
    var resourceProvider: TextureResourceProvider
    var engineConfig: EngineConfiguration
    var layerConfig: LayersConfiguration
    var vmConfig: ViewManagerConfiguration
//    @Published var showDrop : Drop? = nil
    
    
    public func getEditorView(frame:CGRect) {
        let editorView = EditorView(frame: frame, logger: logger, vmConfig: vmConfig, sceneConfig: sceneConfig)
        // viewSceneManager.setEditorView(editorView) TODO: JD Pending
        self.editorView = editorView
        editorView.backgroundColor = .clear
    }
    func getLazyEditorView(frame:CGRect) -> EditorView {
        if let editorView = self.editorView {
            return editorView
        }
         getEditorView(frame: frame)
        return self.editorView!
    }
    
    var canvas : CanvasView {
        return editorView!.canvasView
    }
    
    
    
    public enum RenderingState {
        case Edit
        case Animating
        case SingleAnimation
    }
    
    
    //MARK: - VARIABLES
    // private var modelsTable = [Int:BaseModelProtocol]()
    
    
    var databaseManager: DBMediator {
        return DBMediator.shared
    }// Manager for database operations
    
    
    public var undoRedoManager: UndoRedoManager? // Manager for undo/redo functionality
    public var undoRedoExecutor : UndoRedoExecuter?
    public var sceneManager: SceneManager // Manager for scene operations
    public var drawCallManager : DrawCallManager?
    public var timeLoopHandler : TimeLoopHnadler?
    public var animTimeLoopHandler : AnimationTimeLoopHnadler?
    var canPlayScene:((Bool, Error? )->())?
    //save current template info
    //    var currentTemplateInfo:TemplateInfo?
    // var viewSceneManager = UISceneViewManager() // we are not using this
    public var viewManager : ViewManager?
    var currentModel: BaseModelProtocol?
    var audioPlayer: AudioPlayerForMusicView? //= AudioPlayerForMusicView()
    // var currentActionModel: ActionStates?
    
    
    
    
    public var layersManager : LayersViewModel2  {
        let layerManager = LayersViewModel2()
        layerManager.setTemplateHandler(th: templateHandler)
        layerManager.setPackageLogger(logger: logger, layersConfig: layerConfig)
        //        layerManager.engine = self
        return layerManager
    }
    //    var actionStates = ActionStates()
    //temp
    
    var oCenter:CGPoint = CGPoint(x: 209.077021792531, y: 500.8307629823685)
    
    //MARK: - Init
    
    public init(logger: PackageLogger, resourceProvider: TextureResourceProvider, engineConfig: EngineConfiguration, sceneConfig: SceneConfiguration, layerConfig: LayersConfiguration, vmConfig: ViewManagerConfiguration) {
        
        //        displayView = DisplayView(frame: .zero)
        self.logger = logger
        self.engineConfig = engineConfig
        self.resourceProvider = resourceProvider
        self.sceneConfig = sceneConfig
        self.layerConfig = layerConfig
        self.vmConfig = vmConfig
        self.undoRedoManager = UndoRedoManager(logger: logger)//UndoRedoManager.shared
        self.undoRedoExecutor = UndoRedoExecuter(logger: logger)
        self.sceneManager = SceneManager(resourceProvider: resourceProvider, logger: logger)
        // self.metalView.delegate = sceneManager
        //viewSceneManager.delegate = self
        drawCallManager = DrawCallManager(logger: logger)
        self.audioPlayer = AudioPlayerForMusicView()
        self.audioPlayer?.setPackageLogger(logger: logger, engineConfig: engineConfig)
        //        self.observedStates()
        //        undoRedoManager.observeStates(state: templateHandler.actionStates)
        logger.printLog("init \(self)")
        Conversion.setPackageLogger(logger: logger)
        DataSourceRepository.shared.setPackageLogger(logger: logger)
    }
    
    deinit{
      
        logger.printLog("de-init \(self)")
        playerControlsCancellables.removeAll()
        modelPropertiesCancellables.removeAll()
        actionStateCancellables.removeAll()
        drawCallManager?.stopNotifyingDrawCall()
    }
    
    func updateDBState(isDBDisabled : Bool){
        self.isDBDisabled = isDBDisabled
    }
    
    func start() {
        self.animTimeLoopHandler?.animLoopState = .Stop
        self.templateHandler.renderingState = .Animating
        // self.timeLoopHandler.renderState = .Prepared
        //  self.timeLoopHandler.renderState = .Playing
        
    }
    
    func stop() {
        self.animTimeLoopHandler?.animLoopState = .Stop
        self.templateHandler.renderingState = .Edit
        // self.timeLoopHandler.renderState = .Stopped
        
    }
    
    func pause() {
        self.animTimeLoopHandler?.animLoopState = .Stop
        self.templateHandler.renderingState = .Edit
        // self.timeLoopHandler.renderState = .Paused
        
    }
    
    func resume() {
        self.animTimeLoopHandler?.animLoopState = .Stop
        self.templateHandler.renderingState = .Animating
        // self.timeLoopHandler.renderState = .Playing
        
    }
    
    
    func setCurrentTemplate(templateInfo:TemplateInfo) {
        templateHandler.currentTemplateInfo = templateInfo
    }
    
    func errorOccured(msj:String) {
        
    }
    // TODO: JM Initialise ThumbManager By Check Only If Its Nil Alredy Otherwise call updateThumb Directly
    func captureThumbImage() async{
        if thumbManagar == nil{
            thumbManagar = ThumbManager(templateHandler: templateHandler, resourceProvider: resourceProvider, logger: logger, sceneConfig: sceneConfig)
        }
        thumbManagar?.textureCache.fetchIdealSize = CGSize(width: 500, height: 500)
        await thumbManagar?.updatePageThumb(pageModel: templateHandler.currentPageModel!, currentTime: templateHandler.currentTemplateInfo!.thumbTime, size: CGSize(width: 500, height: 500))
    }
    
    public func prepareSceneUIView() {
        guard let currentTemplateInfo = templateHandler.currentTemplateInfo else { return }
        prepareSceneView(refSize: currentTemplateInfo.ratioSize, tempId: currentTemplateInfo.templateId, tempalteName: currentTemplateInfo.templateName)
    }
    private  func prepareSceneView(refSize:CGSize , tempId : Int , tempalteName : String) {
        editorView?.prepareSceneUIView(size: refSize, tempId: tempId, tempName: tempalteName)
        viewManager?.rootView = canvas.touchView
        editorView?.gestureView.gestureHandler = viewManager
        canvas.touchView?.viewManager = viewManager
    }
    
    func prepareScene(templateID: Int,refSize:CGSize) {
//        UIStateManager.shared.progress = 0.0
        engineConfig.progress = 0.0
        editorView?.prepareCanvasView(size: refSize)
        editorView?.canvasView.backgroundColor = .clear
        editorView?.prepareMetalView(size: refSize)
        // viewSceneManager.rootView = canvas.touchView
        
        if TURN_ON_RENDERING {
            guard let metalView =  canvas.mtkScene else  { errorOccured(msj: "metal View not created") ; return   }
            
            
            //   drawCallManager.addListener(metalView.timeHandler)
            //
            sceneManager.setDisplay(metalView)
        }
        
        //   Fetch template info from the database using templateID
        guard let templateInfo = databaseManager.fetchTemplate(tempID: templateID, refSize: refSize)
        else { errorOccured(msj: "Template Error \(templateID)"); return  }
        
        /* Updated By Neeshu */
        if timeLoopHandler == nil || animTimeLoopHandler == nil{
            timeLoopHandler = TimeLoopHnadler( timeLengthDuration: TimeInterval(templateInfo.totalDuration), drawCallManager: drawCallManager)
            animTimeLoopHandler = AnimationTimeLoopHnadler(drawCallManager: drawCallManager!)
            animTimeLoopHandler?.setPackageLogger(logger: logger)
            self.sceneManager.setTimeLoopHandler(looper: timeLoopHandler!, animLooper: animTimeLoopHandler!)
        }
        
        
        
        // save template info for future use
        // setCurrentTemplate(templateInfo: templateInfo)
        //            setCurrentSticker()
        
        //            modelsTable = databaseManager.templateHandler.childDict
        /* Updated By Neeshu */
        templateHandler = TemplateHandler()//databaseManager.templateHandler
        templateHandler.setPackageLogger(logger: logger, engineConfig: engineConfig)
        templateHandler.childDict = databaseManager.childDict
        databaseManager.cleanUp()
        templateHandler.templateDuration = Double(templateInfo.totalDuration)
        templateHandler.playerControls = timeLoopHandler
        templateHandler.currentActionState.currentMusic = DBManager.shared.getMusicInfo(templateID: templateInfo.templateId)
        thumbManagar = ThumbManager(templateHandler:templateHandler, resourceProvider: resourceProvider, logger: logger, sceneConfig: sceneConfig)
        // save template info for future use
        setCurrentTemplate(templateInfo: templateInfo)

        self.audioPlayer?.setTemplateHandler(templateHandler: templateHandler)
//        timelineView.setTemplateHandler(templateHandler: templateHandler)
        if templateHandler.currentTemplateInfo?.isPremium == 1 && !engineConfig.isPremium && templateHandler.currentTemplateInfo?.category != "DRAFT"{
            editorUIState = .Purchase
        }
        else{
            editorUIState = .UseMe
        }
        
        self.sceneManager.sceneProgress = { [weak self] progress in
            print("Its Coming \(progress)")
            DispatchQueue.main.async {
//                UIStateManager.shared.progress += progress
                self?.engineConfig.progress += progress
            }
        }
        self.thumbManagar?.sceneProgress = { progress in
            DispatchQueue.main.async {
//                UIStateManager.shared.progress += progress
                self.engineConfig.progress += progress
            }
        }
        checkAndDownloadFontsForTemplateId(templateId: templateID){ [self] in
            Task {
                
                
                
                let didSucceed = await self.sceneManager.prepareSceneGraph(templateInfo: templateInfo, sceneConfig: sceneConfig)
                
                sceneManager.canRenderWatermark(!(engineConfig.isPremium || templateHandler.currentTemplateInfo?.isPremium == 1))
                if didSucceed {
                    observeCurrentActions()
                    observePlayerControls()
                }
                
                await thumbManagar?.updateThumbnail(id: 0)
                canPlayScene?(didSucceed, nil) // HK** canplay to retru
                
                
            }
            
        }
    
}
    
    

    
}

extension MetalEngine{
    func checkAndDownloadFontsForTemplateId(templateId: Int, completion: @escaping () -> Void) {
        var fontsForTemplateList = DBManager.shared.getFontsForTemplate(templateID: templateId)
        
        Task {
            let dispatchGroup = DispatchGroup()
            for font in fontsForTemplateList{
                if isFontInAssets(font: font){
                    print("Font already exist in assets: \(font)")
                }else if isFontInAppSpecificPath(font: font){
                    print("Font already exist in app specific folder: \(font)")
                }else{
                    dispatchGroup.enter()
                    await downloadFontFromServer(font: font) {
                        dispatchGroup.leave()
                    }
                }
            }
            // Wait for all font downloads to finish
            dispatchGroup.notify(queue: .main) {
                completion() // Notify that font processing is complete
            }
        }
    }
    
    func downloadFontFromServer(font: String, completion: @escaping () -> Void) async{
        do{
            let filePath = try await engineConfig.downloadFontFromServer(fontName: font)
            
            print("font downloaded from server path: \(filePath)")
        }catch{
            print("font not downloaded from server path")
        }
        completion()
    }
    
    func isFontInAssets(font: String) -> Bool{
        var actualFontName = font.components(separatedBy: ".").first
        return FontDM.appFontArray.contains(where: { $0 == actualFontName})
    }
    
    func isFontInAppSpecificPath(font: String) -> Bool{
        if let fontInFile = engineConfig.readDataFromFileFromFontAssets(fileName: font){
            return true
        }else{
            return false
        }
    }
    
    func isMusicInAppSpecificPath(music: String) -> Bool{
        let musicPath = (music as NSString).lastPathComponent
        if let musicInFile = engineConfig.readDataFromFileFromMusic(fileName: musicPath){
            return true
        }else if let localMusic = engineConfig.readDataFromFileLocalMusic(fileName: musicPath){
            return true
        }else{
            return false
        }
    }
}
extension MetalEngine {
    
    func prepareScene3(templateID: Int, refSize: CGSize , loadThumbnails:Bool ) async {
        
        if fetchStatus == .Success || fetchStatus == .InProgress {
            logger.printLog("MTK_returning")
            return
        }
        logger.printLog("MTK_Preparing")
        if let templateHandler = templateHandler ,  let templateid = templateHandler.currentTemplateInfo?.templateId , templateid == templateID {
            fetchStatus = .Failed
            return
        }
        
        await MainActor.run {
            fetchStatus = .InProgress
            progressUnit = .zero
        }
        
        await Task {
        let allFontsChecked =  await checkAndDownloadFontsForTemplateId(templateId: templateID)
            logger.printLog("allFontsCheck")
        }.value
        
        await Task {
        let allMusicChecked =  await checkAndDownloadMusicForTemplateId(templateId: templateID)
            logger.printLog("allMusicsCheck")
        }.value
        
        // 1️⃣ Fetch template info on main thread
        let templateInfo: TemplateInfo? = await MainActor.run {
            databaseManager.fetchTemplate(tempID: templateID, refSize: refSize)
        }
        
        guard let templateInfo = templateInfo else {
            await MainActor.run { errorOccured(msj: "Template Error \(templateID)") }
            fetchStatus = .Failed
            return
        }
        
        await MainActor.run {
            progressUnit = 0.1
        }
        // 2️⃣ Load Canvas on Main Thread
        await MainActor.run {
            loadCanvas(refSize: refSize)
        }
        
        // 3️⃣ Turn On Metal Display in Background (Sequential)
        await Task {
            turnOnMetalDisplay()
        }.value
        
        // 4️⃣ Initialize Time Loop Handlers in Background
        await Task {
            if timeLoopHandler == nil || animTimeLoopHandler == nil {
                timeLoopHandler = TimeLoopHnadler(timeLengthDuration: TimeInterval(templateInfo.totalDuration), drawCallManager: drawCallManager)
                timeLoopHandler?.setPackagelogger(logger: logger)
                animTimeLoopHandler = AnimationTimeLoopHnadler(drawCallManager: drawCallManager!)
                animTimeLoopHandler?.setPackageLogger(logger: logger)
                sceneManager.setTimeLoopHandler(looper: timeLoopHandler!, animLooper: animTimeLoopHandler!)
            }
        }.value
        
        // 5️⃣ Prepare TemplateHandler in Background
        let templateHandler = await Task { () -> TemplateHandler in
            let handler = TemplateHandler()
            handler.setPackageLogger(logger: logger, engineConfig: engineConfig)
            handler.childDict = await MainActor.run { databaseManager.childDict }
            await MainActor.run { databaseManager.cleanUp() }
           
            handler.templateDuration = Double(templateInfo.totalDuration)
            handler.playerControls = timeLoopHandler
            handler.currentActionState.currentMusic = DBManager.shared.getMusicInfo(templateID: templateInfo.templateId)
            self.templateHandler = handler
            setCurrentTemplate(templateInfo: templateInfo)

            return handler
        }.value
        
        await MainActor.run {
            
            self.audioPlayer?.setTemplateHandler(templateHandler: templateHandler)
            if templateHandler.currentTemplateInfo?.isPremium == 1 && !engineConfig.isPremium && templateHandler.currentTemplateInfo?.category != "DRAFT"{
                editorUIState = .Personalised
            }
            else{
                editorUIState = .Personalised
            }
        }
        
        // 6️⃣ Download Fonts in Parallel
        
            // 7️⃣ Prepare Scene Graph (Background Task)
            let didSucceed = await Task {
                sceneManager.sceneProgress = { [weak self] progress in
                    guard let self = self else { return }
                        let currentProgress = progressUnit
                        progressUnit = currentProgress + (CGFloat(progress) * ( loadThumbnails ? 0.45 : 0.9))
                    DispatchQueue.main.async {
//                        UIStateManager.shared.progress += (progress * ( loadThumbnails ? 0.45 : 1.0))
                        self.engineConfig.progress += (progress * ( loadThumbnails ? 0.45 : 1.0))
                    }
                    
                }
                
                let loaded = await sceneManager.prepareSceneGraph(templateInfo: templateInfo, sceneConfig: sceneConfig)
                if loaded {
                    sceneManager.canRenderWatermark(!(engineConfig.isPremium || templateInfo.isThisTemplateBought))

                    observeCurrentActions()
                    observePlayerControls()
                    
                    if loadThumbnails  {
                        //                    if thumbManagar == nil {
                        thumbManagar = ThumbManager(templateHandler: templateHandler, resourceProvider: resourceProvider, logger: logger, sceneConfig: sceneConfig)
                        //                    }
                        
                        thumbManagar?.sceneProgress = { [weak self]  progress in
                            guard let self = self else { return }
                                let currentProgress = progressUnit
                            progressUnit = currentProgress + (CGFloat(progress) * ( 0.45))

                            DispatchQueue.main.async {
//                                UIStateManager.shared.progress += (progress * 0.45)
                                self.engineConfig.progress += (progress * 0.45)
                            }
                        }
                        await thumbManagar?.updateThumbnail(id: 0)
                    }
                }
                return loaded
            }.value
      
        sceneManager.sceneProgress = nil
        thumbManagar?.sceneProgress = nil
        if didSucceed {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                fetchStatus = .Success
//                UIStateManager.shared.progress = 0
                engineConfig.progress = 0
            }
            return
        }
       
    }
    func prepareScene4(templateID: Int, refSize: CGSize , loadThumbnails:Bool , shouldCheckTempalteWaterrmark: Bool = false ) async {
        
        if fetchStatus == .Success || fetchStatus == .InProgress {
            logger.printLog("MTK_returning")
            return
        }
        logger.printLog("MTK_Preparing")
        if let templateHandler = templateHandler ,  let templateid = templateHandler.currentTemplateInfo?.templateId , templateid == templateID {
            fetchStatus = .Failed
            return
        }
        
        await MainActor.run {
            fetchStatus = .InProgress
            progressUnit = .zero
        }
        
        await Task {
        let allFontsChecked =  await checkAndDownloadFontsForTemplateId(templateId: templateID)
            logger.printLog("allFontsCheck")
        }.value
        
        await Task {
        let allMusicChecked =  await checkAndDownloadMusicForTemplateId(templateId: templateID)
            logger.printLog("allMusicsCheck")
        }.value
        
        // 1️⃣ Fetch template info on main thread
        let templateInfo: TemplateInfo? = await MainActor.run {
            databaseManager.fetchTemplate(tempID: templateID, refSize: refSize)
        }
        
        guard let templateInfo = templateInfo else {
            await MainActor.run { errorOccured(msj: "Template Error \(templateID)") }
            await MainActor.run {
                fetchStatus = .Failed
            }
            return
        }
        
        await MainActor.run {
            progressUnit = 0.1
        }
        // 2️⃣ Load Canvas on Main Thread
        await MainActor.run {
            loadCanvas(refSize: refSize)
        }
        
        // 3️⃣ Turn On Metal Display in Background (Sequential)
        await Task {
            turnOnMetalDisplay()
        }.value
        
        // 4️⃣ Initialize Time Loop Handlers in Background
        await Task {
            if timeLoopHandler == nil || animTimeLoopHandler == nil {
                timeLoopHandler = TimeLoopHnadler(timeLengthDuration: TimeInterval(templateInfo.totalDuration), drawCallManager: drawCallManager)
                timeLoopHandler?.setPackagelogger(logger: logger)
                animTimeLoopHandler = AnimationTimeLoopHnadler(drawCallManager: drawCallManager!)
                animTimeLoopHandler?.setPackageLogger(logger: logger)
                sceneManager.setTimeLoopHandler(looper: timeLoopHandler!, animLooper: animTimeLoopHandler!)
            }
        }.value
        
        // 5️⃣ Prepare TemplateHandler in Background
        let templateHandler = await Task { () -> TemplateHandler in
            let handler = TemplateHandler()
            handler.setPackageLogger(logger: logger, engineConfig: engineConfig)
            handler.childDict = await MainActor.run { databaseManager.childDict }
            await MainActor.run { databaseManager.cleanUp() }
           
            handler.templateDuration = Double(templateInfo.totalDuration)
            handler.playerControls = timeLoopHandler
            handler.currentActionState.currentMusic = DBManager.shared.getMusicInfo(templateID: templateInfo.templateId)
            self.templateHandler = handler
            setCurrentTemplate(templateInfo: templateInfo)

            return handler
        }.value
        
        await MainActor.run {
            
            self.audioPlayer?.setTemplateHandler(templateHandler: templateHandler)
//            if templateHandler.currentTemplateInfo?.isPremium == 1 && !UIStateManager.shared.isPremium && templateHandler.currentTemplateInfo?.category != "DRAFT"{
//                editorUIState = .Personalised
//            }
//            else{
//                editorUIState = .Personalised
//            }
        }
        
        // 6️⃣ Download Fonts in Parallel
        
            // 7️⃣ Prepare Scene Graph (Background Task)
            let didSucceed = await Task {
                sceneManager.sceneProgress = { [weak self] progress in
                    guard let self = self else { return }
                        let currentProgress = progressUnit
                        progressUnit = currentProgress + (CGFloat(progress) * ( loadThumbnails ? 0.45 : 0.9))
                    DispatchQueue.main.async {
//                        UIStateManager.shared.progress += (progress * ( loadThumbnails ? 0.45 : 1.0))
                        self.engineConfig.progress += (progress * ( loadThumbnails ? 0.45 : 1.0))
                    }
                    
                }
                
                let loaded = await sceneManager.prepareSceneGraph(templateInfo: templateInfo, sceneConfig: sceneConfig)
                if loaded {
                    
                    var canRenderWatermark : Bool = false
                    canRenderWatermark = !(engineConfig.isPremium || templateInfo.isThisTemplateBought)
                    if shouldCheckTempalteWaterrmark {
                        canRenderWatermark = !(engineConfig.isPremium || !templateInfo.showWatermark.toBool())
                    }
                    sceneManager.canRenderWatermark(canRenderWatermark)


                    observeCurrentActions()
                    observePlayerControls()
                    
                    if loadThumbnails  {
                        //                    if thumbManagar == nil {
                        thumbManagar = ThumbManager(templateHandler: templateHandler, resourceProvider: resourceProvider, logger: logger, sceneConfig: sceneConfig)
                        //                    }
                        
                        thumbManagar?.sceneProgress = { [weak self]  progress in
                            guard let self = self else { return }
                                let currentProgress = progressUnit
                            progressUnit = currentProgress + (CGFloat(progress) * ( 0.45))

                            DispatchQueue.main.async {
//                                UIStateManager.shared.progress += (progress * 0.45)
                                self.engineConfig.progress += (progress * 0.45)
                            }
                        }
                        await thumbManagar?.updateThumbnail(id: 0)
                    }
                }
                return loaded
            }.value
      
        sceneManager.sceneProgress = nil
        thumbManagar?.sceneProgress = nil
        if didSucceed {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                fetchStatus = .Success
//                UIStateManager.shared.progress = 0
                engineConfig.progress = 0
            }
            return
        }
       
    }
    // var _enableUndoRedo : Bool = false
    // var _enableDBUpdate : Bool = false
    // var _enableViewManager : Bool = false
    //
    func loadCanvas(refSize:CGSize) {
        guard let editorView = editorView else { return }
        editorView.prepareCanvasView(size: refSize)
        editorView.canvasView.backgroundColor = .systemBackground
        editorView.prepareMetalView(size: refSize)
    }
    func turnOnMetalDisplay() {
        guard let metalView = canvas.mtkScene else { errorOccured(msj: "metal View not created") ; return  }
        sceneManager.setDisplay(metalView)
    }
    public func prepareScene2(templateID: Int, refSize: CGSize , loadThumbnails:Bool ) async -> Bool {
        await MainActor.run {
//            UIStateManager.shared.progress = 0.0
            engineConfig.progress = 0.0
        }
        await Task {
        let allFontsChecked =  await checkAndDownloadFontsForTemplateId(templateId: templateID)
            logger.printLog("allFontsCheck")
        }.value
        
        // 1️⃣ Fetch template info on main thread
        let templateInfo: TemplateInfo? = await MainActor.run {
            databaseManager.fetchTemplate(tempID: templateID, refSize: refSize)
        }
        
        guard let templateInfo = templateInfo else {
            await MainActor.run { errorOccured(msj: "Template Error \(templateID)") }
            return false
        }
        
        await MainActor.run {
//            UIStateManager.shared.progress = 0.1
            engineConfig.progress = 0.1
        }
        // 2️⃣ Load Canvas on Main Thread
        await MainActor.run {
            loadCanvas(refSize: refSize)
        }
        
        // 3️⃣ Turn On Metal Display in Background (Sequential)
        await Task {
            turnOnMetalDisplay()
        }.value
        
        // 4️⃣ Initialize Time Loop Handlers in Background
        await Task {
            if timeLoopHandler == nil || animTimeLoopHandler == nil {
                timeLoopHandler = TimeLoopHnadler(timeLengthDuration: TimeInterval(templateInfo.totalDuration), drawCallManager: drawCallManager)
                timeLoopHandler?.setPackagelogger(logger: logger)
                animTimeLoopHandler = AnimationTimeLoopHnadler(drawCallManager: drawCallManager!)
                animTimeLoopHandler?.setPackageLogger(logger: logger)
                sceneManager.setTimeLoopHandler(looper: timeLoopHandler!, animLooper: animTimeLoopHandler!)
            }
        }.value
        
        // 5️⃣ Prepare TemplateHandler in Background
        let templateHandler = await Task { () -> TemplateHandler in
            let handler = TemplateHandler()
            handler.setPackageLogger(logger: logger, engineConfig: engineConfig)
            handler.childDict = await MainActor.run { databaseManager.childDict }
            await MainActor.run { databaseManager.cleanUp() }
           
            handler.templateDuration = Double(templateInfo.totalDuration)
            handler.playerControls = timeLoopHandler
            handler.currentActionState.currentMusic = DBManager.shared.getMusicInfo(templateID: templateInfo.templateId)
            self.templateHandler = handler
            setCurrentTemplate(templateInfo: templateInfo)

            return handler
        }.value
        
        await MainActor.run {
            
            self.audioPlayer?.setTemplateHandler(templateHandler: templateHandler)
            if templateHandler.currentTemplateInfo?.isPremium == 1 && !engineConfig.isPremium && templateHandler.currentTemplateInfo?.category != "DRAFT"{
                editorUIState = .Personalised
            }
            else{
                editorUIState = .Personalised
            }
        }
        
        // 6️⃣ Download Fonts in Parallel
        
            // 7️⃣ Prepare Scene Graph (Background Task)
            let didSucceed = await Task {
                sceneManager.sceneProgress = { progress in
                    DispatchQueue.main.async {
//                        UIStateManager.shared.progress += (progress * ( loadThumbnails ? 0.45 : 0.9))
                        self.engineConfig.progress += (progress * ( loadThumbnails ? 0.45 : 0.9))
                    }
                }
                
                
                
                let loaded = await sceneManager.prepareSceneGraph(templateInfo: templateInfo, sceneConfig: sceneConfig)
                if loaded {
                    sceneManager.canRenderWatermark(!(engineConfig.isPremium || templateInfo.isThisTemplateBought))

                    observeCurrentActions()
                    observePlayerControls()
                    
                    if loadThumbnails  {
                        //                    if thumbManagar == nil {
                        thumbManagar = ThumbManager(templateHandler: templateHandler, resourceProvider: resourceProvider, logger: logger, sceneConfig: sceneConfig)
                        //                    }
                        
                        thumbManagar?.sceneProgress = { progress in
                            DispatchQueue.main.async {
//                                UIStateManager.shared.progress += (progress * 0.45)
                                self.engineConfig.progress += (progress * 0.45)
                            }
                        }
                        await thumbManagar?.updateThumbnail(id: 0)
                    }
                }
                return loaded
            }.value
      
        sceneManager.sceneProgress = nil
        thumbManagar?.sceneProgress = nil
        return true
    }
    func checkAndDownloadFontsForTemplateId(templateId: Int) async -> Bool {
        
        if await !isInternetAvailable()  {
            return true
        }
        
        let fontsForTemplateList = await MainActor.run {
            DBManager.shared.getFontsForTemplate(templateID: templateId)
        }
        var allResults: [Bool] = []
        await withTaskGroup(of: Bool.self) { group in
            for font in fontsForTemplateList {
                group.addTask { [weak self] in
                    guard let self = self else { return false}
                    if await isFontInAssets(font: font) {
                        print("Font already exists in assets: \(font)")
                        return true
                    } else if await isFontInAppSpecificPath(font: font) {
                        print("Font already exists in app-specific folder: \(font)")
                        return true
                    } else {
                        return  await downloadFontFromServer2(font: font)
                        
                    }
                }
            }
            
            for await result in group {
                allResults.append(result)
            }
        }
        logger.printLog("All Fonts Satisfied")
        return fontsForTemplateList.count == allResults.count
    }
    
    func checkAndDownloadMusicForTemplateId(templateId: Int) async -> Bool {
        
        if await !isInternetAvailable()  {
            return true
        }
        
        let musicsForTemplateList = await MainActor.run {
            DBManager.shared.getMusicInfo(templateID: templateId)
        }
        var allResults: [Bool] = []
        await withTaskGroup(of: Bool.self) { group in
            group.addTask { [weak self] in
                guard let self = self else { return false}
                if await isMusicInAppSpecificPath(music: musicsForTemplateList?.musicPath ?? "") {
                    print("Music already exists in app-specific folder: \(musicsForTemplateList?.musicPath ?? "")")
                    return true
                } else {
                    return await downloadMusicFromServer2(musicPath: musicsForTemplateList?.musicPath ?? "")
                    
                }
            }
            
            for await result in group {
                allResults.append(result)
            }
        }
        logger.printLog("All Fonts Satisfied")
        return allResults.first ?? true
    }
    
    func downloadFontFromServer2(font: String) async -> Bool {
        do{
            let filePath = try await engineConfig.downloadFontFromServer(fontName: font)
            print("font downloaded from server path: \(filePath)")
            return true
        }catch{
            print("font not downloaded from server path")
            return false
        }
    }
    
    func downloadMusicFromServer2(musicPath: String) async -> Bool {
        do{
            let filePath = try await engineConfig.downloadMusicFromServer(musicPath: musicPath)
            print("music downloaded from server path: \(filePath)")
            return true
        }catch{
            print("music not downloaded from server path")
            return false
        }
    }
    
    func isInternetAvailable() async -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetCheck")
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        monitor.start(queue: queue)
        semaphore.wait() // Wait for the path update handler to execute
        monitor.cancel() // Cancel immediately to release resources
        
        return isConnected
    }
}
