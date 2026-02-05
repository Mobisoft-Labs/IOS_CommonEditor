//
//  SceneManager.swift
//  VideoInvitation
//
//  Created by HKBeast on 22/08/23.
//

import Foundation
import Metal
import simd
import UIKit
import Combine

public let kInFlightCommandBuffers = 3


//var RESIZE = CGSize.zero

var commandQueueG: MTLCommandQueue!

public class SceneManager  : NSObject, SceneComposable , TemplateObserversProtocol , ActionStateObserversProtocol, PlayerControlsReadObservableProtocol  {
    var shouldRenderOnScene : Bool = true 
    
    var cancelPreparing: Bool = false

    var textureCache: TextureCache
    
    var sceneProgress : ((Float)->Void)?
    
    public var playerControlsCancellables: Set<AnyCancellable> = []
    
    var logger: PackageLogger
    
    var sceneConfig: SceneConfiguration?
    
    var resourceProvider: TextureResourceProvider
    
    public func observePlayerControls() {
       
        playerControlsCancellables.removeAll()
        guard let looper = self.looper else {
            logger.printLog("looper  nil")
            return }
        
        logger.logVerbose("SM + PlayerControls listeners ON \(playerControlsCancellables.count)")
        
        looper.$currentTime.dropFirst().sink { [weak self] currentTime in
            guard let self = self else { return }
            redraw(currentTime: currentTime)
        }.store(in: &playerControlsCancellables )
    }
    
  
    public func observeAsCurrentParent(_ parentModel: ParentInfo) {
        // No Need
       
        parentModel.$editState.dropFirst().sink { isEdit in
            if let currentChild = self.currentChild as? MParent ,parentModel.modelType == .Parent {
                currentChild.editState = isEdit
                self.redraw()
                
            }
        }.store(in: &modelPropertiesCancellables)
    }
    
    public var modelPropertiesCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    public var actionStateCancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    var updateThumb: Bool = false
    
    var isUserSubscribed: Bool {
        return true 
    }
    
//    var textureCache = TextureCache()
    
    var commandQueue: MTLCommandQueue!

    
    
    
 
    var mChildHandler = MChildHandler()
    var currentSceneSize: CGSize = .zero
    
    var canCacheMchild: Bool = true
    
     weak var looper : TimeLoopHnadler?
     weak var animLooper : AnimationTimeLoopHnadler?
    
    var metalThread : MetalThread =   MetalThread(label: "MetalThread") // DispatchQueue(label: "MetalThread",qos: .background, autoreleaseFrequency: .inherit,target: nil)

    
    func setTimeLoopHandler(looper:TimeLoopHnadler , animLooper : AnimationTimeLoopHnadler) {
        self.looper = looper
        self.animLooper = animLooper
        
        observePlayerControls()
        
        
        self.animLooper?.$currentAnimTime.dropFirst().sink { [weak self] animCurrentTime in
            guard let self = self else { return }
            currentScene?._animCurrentTime = animCurrentTime
            redraw()
        }.store(in: &animLooper.cancellables)
        
        self.animLooper?.$animLoopState.dropFirst().sink(receiveValue: { [weak self] state in
            guard let self = self else { return }
            switch state {
                
            case .Start(duration: let duration, startTim: let startTime, type: let type) :
               
                currentChild?.animPreviewMode = type
                currentChild?.isInPreviewAnimation = true
                templateHandler?.renderingState = .SingleAnimation
                print("onAnimationPreview Start  \(currentChild) ")


            case .Stop:
                print("onAnimationPreview Stop  \(currentChild?.identification) ")
                currentChild?.animPreviewMode = .None
                currentChild?.isInPreviewAnimation = false
                templateHandler?.renderingState = .Edit
                redraw()
            }
        }).store(in: &animLooper.cancellables)
        
    }
    
    func clearMetalThreadTask(){
        metalThread.clear()
    }
    
    private func onMetalThread(_ codeBlock:@escaping()->()){
        metalThread.async { [weak self] in
            guard let self = self else { return }
           // if looper?.renderState != .Playing {
                codeBlock()
           // }
        }
    }
//    private func onMetalThreadFunction(_ functionCall :@escaping ()->()){
//        metalThread.async {
//            functionCall()
//        }
//    }
//
//    private func onMetalThreadSync(_ codeBlock:@escaping()->()){
//        metalThread.async {
//            codeBlock()
//        }
//    }
//    private func onMetalThreadFunctionSync(_ functionCall :@escaping ()->()){
//        metalThread.async {
//            functionCall()
//        }
//    }
    
    
    
    func redraw(currentTime:Float?=nil) {
        guard shouldRenderOnScene else {
            logger.printLog("shouldRenderOnScene : \(shouldRenderOnScene) ")
            return }
        onDrawCall(currentTime: currentTime ?? looper?.currentTime ?? 0.0)
    }
    func redrawForThumbnail() {
//        renderForThumbnail(currentTime: thumbTime ) { texture in
//            guard let texture_ = texture else { printLog("Unable To Create Texture"); return ; }
//            guard let thumbnail = Conversion.getUIImage(texture: texture_, context: CIContext()) else { printLog("Unable To Convert Texture To Thumbail"); return ; }
//            printLog("Thumbnail Generated :",thumbnail.scale)
//        }
    }
   private func onDrawCall(currentTime: Float) {
       guard !metalThread.stopRendering else {
           return
       }
       
        metalThread.async { [weak self] in
            autoreleasepool{
                guard let self = self else { return }
                guard let metalDisplay = self.metalDisplay else { return }
                
               // currentScene?._currentTime = currentTime
                metalDisplay.callDrawMethodForNextFrame(currentTime: currentTime, needThumbnail: false)
            }
        }
    }
    private func renderForThumbnail(currentTime: Float ,  completion: ((MTLTexture?)->Void)? = nil) {
         
         metalThread.async { [weak self] in
             guard let self = self else { return }
             autoreleasepool{
                // currentScene?._currentTime = currentTime
                 self.metalDisplay?.callDrawMethodForNextFrame(currentTime: currentTime, needThumbnail: true,completion: completion)
             }
         }
     }
    
   
    
//    var childTable = [Int:MChild]()
    var currentScene : MScene?
    var currentWatermark : MWatermark?
    var currentPage:MChild?
    var currentParent:MChild?
    var currentChild:MChild?
    weak var templateHandler:TemplateHandler?
   // var cancellables = Set<AnyCancellable>()
    private var _inflight_semaphore = DispatchSemaphore(value: kInFlightCommandBuffers)

    var samplerState: MTLSamplerState!
    var sampleDescriptor : MTLSamplerDescriptor!

    public func setTemplateHandler(templateHandler : TemplateHandler) {
        self.templateHandler = templateHandler
        observeCurrentActions()
        
    }
    
  //MARK: - Methods

//    override init(resourceProvider: TextureResourceProvider, logger: PackageLogger) {
//        self.logger = logger
//        self.resourceProvider = resourceProvider
//        textureCache =  TextureCache(maxSize: CGSize(width: 3000, height: 3000), resourceProvider: resourceProvider, logger: logger)
//         super.init()
//        logger.printLog("init \(self)")
//       
//    }
    
    init(resourceProvider: TextureResourceProvider, logger: PackageLogger) {
        self.logger = logger
        self.resourceProvider = resourceProvider
        textureCache =  TextureCache(maxSize: CGSize(width: 3000, height: 3000), resourceProvider: resourceProvider, logger: logger)
         super.init()
        logger.printLog("init \(self)")
       
    }
    
    deinit {
//        metalThread.clear()
        mChildHandler.cleanUp()
//        ShaderLibrary.cleanUp()
//        PipelineLibrary.cleanUp()
//        MVertexDescriptorLibrary.cleanUp()
        logger.printLog("de-init \(self)")
    }
    
    
    weak var metalDisplay : IOSMetalView?
    
    func setDisplay(_ view: IOSMetalView) {
        metalDisplay = view
        createCommmandQueue()
        view.sampleCount = 1
        view.delegate = self
        buildSamplerState()
    }
    
    
    public func canRenderWatermark(_ canRender : Bool) {
        currentScene?._canRenderWatermark = canRender
        redraw()
    }
    
    /* Updated By Neeshu */
    func createCommmandQueue(){
        // If Command Queue is nil then create the command queue.
        if commandQueue == nil{
            commandQueue = MetalDefaults.GPUDevice.makeCommandQueue()!
            commandQueueG = commandQueue
        }
    }
    
    /* Updated By Neeshu */
    // SAMPLEr
    func buildSamplerState(){
        // If Sampler State is nil then create the sampler state.
        if samplerState == nil{
            sampleDescriptor = MTLSamplerDescriptor()
            sampleDescriptor.minFilter = .linear
            sampleDescriptor.magFilter = .linear
            samplerState = MetalDefaults.GPUDevice.makeSamplerState(descriptor: sampleDescriptor)
        }
    }
    
    
    func changeRatio(ratio:CGSize,refSize:CGSize) async  {

        logger.logInfo("OnChangeRatio Called ratio: \(ratio) size: \(refSize)")
        let oldParent = currentScene?.size
//        currentScene?.context.rootSize = ratio
//        currentScene?.setmSize(width: ratio.width, height: ratio.height)
        
        guard let scene = currentScene else {return}
        guard let templateHandler = templateHandler else {
            logger.logError("Template Handler Nil ")
            return
        }
        scene.context.rootSize = metalDisplay!.bounds.size

        for childPage in scene.childern{
            if let page = childPage as? MPage{
                let oldSize = page.size
                
                
//                let center = recalculateCenter(currentCenter: page.center, currentParentSize: oldParent!, newParentSize: ratio)
                if let pageModel = templateHandler.childDict[page.id] {
                    page.setmSize(width: pageModel.baseFrame.size.width, height: pageModel.baseFrame.size.height)

                    page.setmCenter(centerX: pageModel.baseFrame.center.x, centerY: pageModel.baseFrame.center.y)
                    
                    // change for watermark
                 
                    
                    recursiveBaseSizeAndCenter(parent: page, oldParentSize: oldSize)
//                    Task{
                        if let model = templateHandler.getModel(modelId: page.id) as? PageInfo{
                            if page.watermarkChild != nil{
                               
                                    let watermark = await createWatermark(page.size)
                                    page.watermarkChild = watermark
                                    watermark?.setMDuration(page.mDuration)
                                
                            }
                            if let image = model.bgContent as? BGUserImage{
                                
                                let cropPoints = image.content.cropRect
                                let key = image.content.localPath + cropPoints.toString()
                                textureCache.remove(textureFor: key)
                            }

                            await setBGSource(imageModel: model.bgContent!, info: page.backgroundChild as! TexturableChild,isRatioChanged: true,tileCount: model.tileMultiple)
                            
                            if let overlay2 = ((model.bgOverlayContent as? BGOverlay)?.content as? ImageModel) , let bgChild = page.backgroundChild as? TexturableChild  {
                                //        bgChild.setColor(color: Conversion.setColorForMetalView(color: _bgInfo.colorInfo))
                                if let lastPathComponent = overlay2.localPath.components(separatedBy: "/").last  {
                                    let cropPoints = overlay2.cropRect
                                    let key = overlay2.localPath + cropPoints.toString()
                                    textureCache.remove(textureFor: key)
                                  
                                    
                                    if let overlay =  await textureCache.getTextureFromBundle(imageName: lastPathComponent, id: model.overlayID, flip: false){
                                        
                                        bgChild.mOverlayTexture = overlay
                                        
                                    }
                                }else{
                                    if let lastPathComponent = model.overlayLocalPath.components(separatedBy: "/").last  {
                                        let cropPoints = overlay2.cropRect
                                        let key = overlay2.localPath + cropPoints.toString()
                                        textureCache.remove(textureFor: key)
                                        if let overlay =  await textureCache.getTextureFromBundle(imageName: lastPathComponent, id: model.overlayID, flip: false){
                                            
                                            bgChild.mOverlayTexture = overlay
                                            
                                        }
                                    }
                                }
                            }
                            redraw()
                            
                            
                        }
//                    }
                    
                    //                DispatchQueue.main.async { [self] in
                    ////                    metalDisplay?.frame.size = ratio
                    //
                    //                    metalDisplay?.layoutSubviews()
                    //                }
                    
                    
                    
                    
                }
            }
        }
//            redraw()
    }
    
    
    
    var child : StickerChild!
    var child2 : StickerChild!
//    var currentChild:MChild?
    func prepareSceneGraph(templateInfo:TemplateInfo, sceneConfig: SceneConfiguration, refSize: CGSize) async -> Bool  {
        print("LOL_5")
            // step 1 create scene
        self.sceneConfig = sceneConfig
            currentScene = MScene(templateInfo: templateInfo)
            currentSceneSize = refSize
            
            //  RESIZE =  metalDisplay!.bounds.size
            //        child = createSticker(sticker!)
            // create pages
            
            let pages = templateInfo.pageInfo
            
            // page.colorInfo = ""
            //        child = createSticker(sticker)!
            
            //
            for page in pages {
                
                if var mpage = await createPage(page){
                     //var mpage =    await createPage(pages)! // {
                    //                childTable[page.modelId] = mpage
                    //mpage.addChild(child)
                    currentPage = mpage
                    currentChild = mpage
                    currentParent = mpage
                    currentScene?.addChild(mpage)
//                    currentScene?.context.drawableSize = page.size //MContext(drawableSize: page.size )
                    
                    let watermark = await createWatermark(mpage.size)
                    mpage.watermarkChild = watermark
                    watermark?.setMDuration(mpage.mDuration)
                    
                }
               
                
            }
            
          
            
//            currentScene?.context = await MContext(drawableSize: metalDisplay?.drawableSize ?? .zero)
//            currentScene?.context.rootSize = await metalDisplay!.bounds.size
        
        
        currentScene?.context = await MContext(drawableSize: metalDisplay?.drawableSize ?? .zero)
        currentScene?.context.rootSize = await metalDisplay!.bounds.size
        
            print("At the time of Add \(currentScene?.context)")
            
            //        child.context = MContext(drawableSize: DRAWABLE_SIZE)
            //        child.context?.rootSize = metalDisplay!.bounds.size
            currentPage = currentScene!.childern.first
        currentScene?._currentTime = templateInfo.thumbTime
        if templateInfo.outputType == .Image{
            currentScene?._renderingMode = .Edit
            currentScene?._shouldOverrideCurrentTime = true
        }else{
            currentScene?._renderingMode = .Animating
            currentScene?._shouldOverrideCurrentTime = false
        }
           // thumbTime = templateInfo.thumbTime
            //redrawForThumbnail()
//        
//        if  let watermark = await createWatermark(currentPage!.size) {
//            currentScene?.addChild(watermark)
//            watermark.setMDuration(templateInfo.totalDuration)
//            currentWatermark = watermark
//        }
             redraw()
//        observeActionStates()
           // completion(true)
//        updateThumbnail()
       
        return true
        
    }
    
    func cacheChild(key: Int, value: MChild) {
        mChildHandler.addModel(model: value)
    }
    
    //var thumbTime : Float = 0
    
    func setSelectedView(id:Int){
        
        currentChild = mChildHandler.getModel(modelId: id)
        
    }
      
}

extension SceneManager {
    func syncOrderForParent(parentId: Int) {
        guard let templateHandler = templateHandler,
              let parentInfo = templateHandler.getModel(modelId: parentId) as? ParentInfo,
              let parentMChild = mChildHandler.childDict[parentId] as? MParent else { return }
        let orderedChildren = parentInfo.activeChildren.sorted { $0.orderInParent < $1.orderInParent }
        for child in orderedChildren {
            if let mChild = mChildHandler.childDict[child.modelId] {
                mChild.mOrder = child.orderInParent
            }
        }
        parentMChild.childern.sort { $0.mOrder < $1.mOrder }
        redraw()
    }

    func syncLockStatus(ids: [Int]) {
        for id in ids {
            if let childModel = mChildHandler.getModel(modelId: id) {
                if let baseModel = templateHandler?.getModel(modelId: id) {
                    childModel.setLockStatus(lock: baseModel.lockStatus)
                }
            }
        }
        redraw()
    }
}

extension SceneManager : IOSMetalViewRenderDelegate {
    func IOSMetalView(_ metalView: IOSMetalView, didChangeSize: CGSize) {
        logger.printLog("Size did Change \(didChangeSize)")
        currentSceneSize = didChangeSize
        guard let scene = currentScene else { return }
        
        if scene.context.drawableSize != didChangeSize {
            // update scene drawable size
            scene.context.drawableSize = metalView.drawableSize
        }
       // RESIZE = metalView.bounds.size

       // child.context = MContext(drawableSize: metalView.drawableSize)
    }
    
    func draw(in metalView: IOSMetalView, currentTime: Float,needThumbnail:Bool,  completion: ((MTLTexture?) -> Void)?) {

        _ = _inflight_semaphore.wait(timeout: DispatchTime.distantFuture)
        logger.printLog("currentTime : \(currentTime)")
        guard let drawable = metalView.currentDrawable else {
            logger.printLog("NO DRAWABLE")
            return
        }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
       
        renderPassDescriptor.colorAttachments[0].clearColor = MetalClearColors.transparent
  
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
    if  let commandBuffer = commandQueue.makeCommandBuffer(){

        
        guard let currentScene = currentScene else {
            logger.printLog("Scene Not Avaialble to render")
            return }
        
        currentScene._currentTime = currentTime

        currentScene.renderPages(commandbuffer: commandBuffer)
        let metalDisplayEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        metalDisplayEncoder.setFragmentSamplerState(samplerState, index: FRAGMENT_BUFFER_INDEX.SAMPLER_INDEX)
        
        
       currentScene.renderOn(metalDisplay: metalDisplayEncoder)
           
        metalDisplayEncoder.endEncoding()

        commandBuffer.present(drawable)
            // call the view's completion handler which is required by the view since it will signal its semaphore and set up the next buffer
            let block_sema = _inflight_semaphore

            commandBuffer.addCompletedHandler { [weak self]  _ in
                guard let self = self else { return }
                            // GPU has completed rendering the frame and is done using the contents of any buffers previously encoded on the CPU for that frame.
                            // Signal the semaphore and allow the CPU to proceed and construct the next frame.
                            block_sema.signal()
            
                            //self?.shouldRenderNextFrame = true
               // if metalView.timeHandler.currentMode == .Online {
                var texture : MTLTexture? = nil
                if needThumbnail {
                    texture = (currentPage as! MPage).myFBOTexture
                }
                completion?(texture)
               // }
            }
            
            commandBuffer.commit()

        }else{
            let block_sema = _inflight_semaphore
            block_sema.signal()

        }
    
    }
   
}




public class ThumbManager : SceneComposable {
    
    var sceneConfig: SceneConfiguration?
    
    var logger: PackageLogger
    
    var updateThumb: Bool = true
    
    
    var cancelPreparing: Bool = false

    
    var sceneProgress : ((Float)->Void)?
    
    var resourceProvider: TextureResourceProvider
    
//    var updateThumb: Bool = true
    
    public var textureCache: TextureCache
    
    var isUserSubscribed: Bool {
        get {
            return  true
        }
    }
    
    var currentSceneSize: CGSize = CGSize(width: 512, height: 512)
    var canCacheMchild: Bool = false
    
    var commandQueue: MTLCommandQueue!
    
    var metalThread: MetalThread = MetalThread(label: "MetalThread_Thumb")
    
    func cacheChild(key: Int, value: MChild) { }
    
    weak var templateHandler : TemplateHandler?
    init(templateHandler:TemplateHandler, resourceProvider: TextureResourceProvider, logger: PackageLogger, sceneConfig: SceneConfiguration) {
        self.templateHandler = templateHandler
        self.logger = logger
        self.resourceProvider = resourceProvider
        self.sceneConfig = sceneConfig
        self.textureCache = TextureCache(maxSize: CGSize(width: 150, height: 150), enhancePageSize: true, resourceProvider: resourceProvider, logger: logger)
        commandQueue = MetalDefaults.GPUDevice.makeCommandQueue()!
        
    }
    
    func updateThumbnail(id:Int = 0) async {
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
                var baseModels = [BaseModel]()
                
                if id == 0 {
                    baseModels = templateHandler.childDict.map({return $0.value})
                }else {
                    baseModels = templateHandler.getAllChildModels(pageID: id)
                    if baseModels.count == 1{
                        baseModels = templateHandler.getAllParentOfModels(childID: id)
                    }
                }
                if baseModels.isEmpty {
                    return 
                }
                for eachModel in 0...baseModels.count-1 {
                    
                    try await updateThum(model: baseModels[eachModel])
                }
               
        }
    
    
    
    
    func updateParentAndPage(currentTime:Float){
        
        guard let templateHandler = self.templateHandler else {
            logger.logError("template handler nil")
            return }
        
        
        if let page = templateHandler.currentPageModel{
            Task {
                await processUpdates(currentTime: currentTime, page: page)
            }
        }
    }
    
    func processUpdates(currentTime : Float, page: PageInfo) async {
        await updatePageThumb(pageModel: page, currentTime: currentTime)

        let basemodels = templateHandler!.childDict.values.compactMap { $0 as? ParentInfo }

         for child in basemodels {
             await updateParentThumb(parentModel: child, currentTime: currentTime)
         }
    }
    
    func updateThum(model:BaseModel) async {
        if let sticker = model as? StickerInfo, sticker.softDelete != true {
            
            await updateStickerThumb(stickerInfo: sticker)
            
        } else  if let text = model as? TextInfo, text.softDelete != true {
            await updateTextThumb(text: text)
            
        }else if let parentModel = model as? ParentInfo, parentModel.softDelete != true {
            await updateParentThumb(parentModel: parentModel)
        }  else if let pageModel = model as? PageInfo, pageModel.softDelete != true {
            await updatePageThumb(pageModel: pageModel)
            
        }
    }
 
    func updateStickerThumb(stickerInfo:StickerInfo , completion: ((Bool)->())? = nil )async{
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            completion?(true)
            return }
        
        if  let mSticker = await createSticker(stickerInfo) {
            mSticker.context = MContext(drawableSize: CGSize(width: 100, height: 100))
            mSticker._currentTime = mSticker.mStartTime
            mSticker._renderingMode = .Edit
            mSticker._canRenderWatermark = false
            if mSticker.canRender {
                let buffer = commandQueue.makeCommandBuffer()!
                let encoder = buffer.makeComputeCommandEncoder()!
                mSticker.precomuteData(computeEncoder: encoder)
                encoder.endEncoding()
                buffer.commit()
                buffer.waitUntilCompleted()
                
                //            var texture = mSticker?.sourceTexture
                //            if mSticker?.finaltexture != nil{
                let texture = mSticker.finaltexture
                //            }
                if let texture = texture{
                    let image = Conversion.getUIImage(texture: texture,flipX: !(stickerInfo.modelFlipHorizontal) , flipY: !(stickerInfo.modelFlipVertical))
                    // printLog(image)
                    DispatchQueue.main.async {
                        stickerInfo.thumbImage = image
                        templateHandler.currentActionState.updatePageArray = true
                        completion?(true)
                        return
                    }
                }else {
                    logger.logError("update thumb error texture nil\(mSticker.identification)")
                    completion?(true)
                }
            }else {
                logger.logError("update thumb error canRender\(mSticker.identification)")
                completion?(true)
            }
        }else{
            completion?(true)
        }
       
    }
  
    func updateTextThumb(text:TextInfo, completion: ((Bool)->())? = nil)async{
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            completion?(true)
            return }
        let mText =  createText(text)
         mText.context = MContext(drawableSize: CGSize(width: 100, height: 100))
         mText._currentTime = mText.mStartTime
        mText._renderingMode = .Edit
        mText._canRenderWatermark = false
        
         let properties = text.textProperty
        
        if mText.canRender {
        let contentScale = sceneConfig?.contentScaleFactor ?? 1
            let textImage = text.createImage(thumbUpdate : true,text: text.text, properties: properties, refSize: text.baseFrame.size , maxWidth: 512, maxHeight: 512, contentScaleFactor: contentScale, logger: logger)

            let textTexture = Conversion.loadTexture(image: textImage!, flip: false )!
            
            //let textTexture = Conversion.loadTexture(image: text.createImage(bgAlpha: 0.0)!, flip: false )!
            mText.setTexture(texture: textTexture)
            let buffer = commandQueue.makeCommandBuffer()!
            let encoder = buffer.makeComputeCommandEncoder()!
            mText.precomuteData(computeEncoder: encoder)
            encoder.endEncoding()
            buffer.commit()
            buffer.waitUntilCompleted()
            
            if  let texture = mText.finaltexture {
                let image = Conversion.getUIImage(texture: texture,flipX: !(text.modelFlipHorizontal) , flipY: !(text.modelFlipVertical))
                
                // printLog(image)
                DispatchQueue.main.async {
                    text.thumbImage = image
                    completion?(true)
                    return
                        templateHandler.currentActionState.updatePageArray = true
                }
            } else {
                logger.logError("update thumb error texture nil\(mText.identification)")
                completion?(true)

            }
        }else {
            logger.logError("update thumb error canRender\(mText.identification)")
            completion?(true)

        }
    }
    
    func updateParentThumb(parentModel:ParentInfo,currentTime:Float = 0.0, completion: ((Bool)->())? = nil)async{
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            completion?(true)
            return }
        
        let parent = await createMParent(parentModel: parentModel)
        parent.context = MContext(drawableSize: CGSize(width: 100, height: 100))
        if currentTime == 0.0{
            parent._currentTime = parent.startTime
        }
        else{
            let parentStartTimeForSacredTime = templateHandler.recursiveParentStartTime(model: parentModel)

            parent._currentTime = parent.mStartTime + ( currentTime - parentStartTimeForSacredTime )
        }
        parent._renderingMode = .Edit
        parent._canRenderWatermark = false

        let globalCurrentTime = templateHandler.playerControls?.currentTime ?? 0.0
//        parent._currentTime = smartCurrentTime // globalCurrentTime // - parent.mStartTime
     //   parent._currentTime = parent.mStartTime
        if parent.canRender {
            let buffer = commandQueue.makeCommandBuffer()!
            //  let encoder = buffer.makeComputeCommandEncoder()!
            parent.prepareMyChildern()
            parent.renderMyChildren(commandBuffer: buffer)
            
            //encoder.endEncoding()
            buffer.commit()
            buffer.waitUntilCompleted()
            
            if  let texture = parent.myFBOTexture {
                let image = Conversion.getUIImage(texture: texture,flipX: !(parentModel.modelFlipHorizontal) , flipY: (parentModel.modelFlipVertical))
                // printLog(image)
                DispatchQueue.main.async {
                    parentModel.thumbImage = image
                    templateHandler.currentActionState.thumbUpdateId = parentModel.modelId
                    completion?(true)
                }
            } else {
                logger.logError("update thumb error texture nil\(parent.identification)")
                completion?(true)
            }
        }else {
            logger.logError("Thumb Update Issue \(parent.identification)")
            completion?(true)
        }
    }
    
    public func updatePageThumb(pageModel:PageInfo,currentTime:Float = 0.0, size: CGSize = CGSize(width: 300, height: 300)) async{
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
        let page = await createPage(pageModel)!
        if currentTime == 0.0{
            page._currentTime = pageModel.startTime//templateHandler.currentTemplateInfo?.thumbTime ?? currentTime
        }else{
            page._currentTime = currentTime
        }
        page._renderingMode = .Edit
        page._canRenderWatermark = false
        
        
        page.context = MContext(drawableSize: CGSize(width: size.width, height: size.height))
        if page.canRender {
            
            let buffer = commandQueue.makeCommandBuffer()!
            //  let encoder = buffer.makeComputeCommandEncoder()!
            page.prepareMyChildern()
            page.renderMyChildren(commandBuffer: buffer)
            
            //encoder.endEncoding()
            buffer.commit()
            buffer.waitUntilCompleted()
            
            if let texture = page.myFBOTexture {
                let image = Conversion.getUIImage(texture: texture)
                // printLog(image)
                DispatchQueue.main.async {
                    pageModel.thumbImage = image
                    templateHandler.currentActionState.updatePageArray = true
                }
            } else {
                logger.logError("update thumb error texture nil\(page.identification)")
            }
            
        } else {
            logger.logError("update thumb error \(page.identification)")
        }
    
        
    }
}



public class TextureCache {
    
    /// This is responsible for Image Quality
    public var fetchIdealSize : CGSize
    var enhancePageSize : Bool = false
    public var checkInCache : Bool = true
    var resourceProvider: TextureResourceProvider
    var logger: PackageLogger
    
    var _fetchIdealSize: CGSize {
        return enhancePageSize ? fetchIdealSize.into(2) : fetchIdealSize
    }
    
    init(maxSize:CGSize, enhancePageSize:Bool = false, resourceProvider: TextureResourceProvider,
         logger: PackageLogger) {
        self.fetchIdealSize = maxSize
        self.enhancePageSize = enhancePageSize
        self.resourceProvider = resourceProvider
        self.logger = logger
    }
    
    private var cache = [String: MTLTexture]()
        private let cacheQueue = DispatchQueue(label: "com.partyza.TextureCacheQueue", attributes: .concurrent)

        // 🚀 Read: Sequential & Thread-Safe
        func getTextureFromCache(key: String) -> MTLTexture? {
            return cacheQueue.sync {
                return cache[key]
            }
        }

        // 🚀 Write: Asynchronous with `.barrier`
        func addToCache(texture: MTLTexture, key: String) {
            cacheQueue.async(flags: .barrier) {
                self.cache[key] = texture
            }
        }
    func remove(textureFor key: String) {
        cacheQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if let success = self.cache.removeValue(forKey: key) {
            logger.printLog("Removed In Cache \(key)")
        }
        }
    }
    func getTextureFromBundle(imageName:String,id:Int = 0,crop:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0),flip:Bool,isCropped:Bool = false) async -> MTLTexture? {
                
        if let texture = getTextureFromCache(key: imageName+crop.toString()) {
            logger.printLog("Found In Cache \(imageName+crop.toString())")
            return texture
        }
        
        if let url = Bundle.main.resourcePath {
            let imagePath = (url as NSString).appendingPathComponent("\(imageName).png")
            let imageURL = URL(fileURLWithPath: imagePath)
         
            var cGImage = await resourceProvider.loadImageUsingQL(fileURL: imageURL, maxSize: _fetchIdealSize)
        
        
        if cGImage == nil , let image =  UIImage(named:imageName) {
            logger.logInfo("Manual Resize \(imageName)")
            cGImage = resizeImage(image: image, targetSize: _fetchIdealSize)?.cgImage
        }
        
        guard let cGImage = cGImage else {
            logger.logError("Coundnt Find URL In Bundle \(imageName)")
            return nil
        }
        
       
                let width = cGImage.width.toCGFloat()
                let height = cGImage.height.toCGFloat()
                
                let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                let croppedCGImage: CGImage = cGImage.cropping(to: rect)!
            
                let img = UIImage(cgImage: croppedCGImage)
                if let newTexture = Conversion.loadTexture(image: img,flip:flip) {

                    logger.printLog("Adding In Cache \(imageName+crop.toString())")

                    addToCache(texture: newTexture, key: imageName+crop.toString())
                    return newTexture
                }
                
        }else{
            logger.logError("Coundnt Find URL In Bundle \(imageName)")
            if let image =  UIImage(named:imageName) {
                logger.logInfo("Manual Resize \(imageName)")
//                let resizedImage = resizeImage(image: image, targetSize: fetchIdealSize)?.cgImage
                if let cGImage = image.cgImage{
                    
                    let width = cGImage.width.toCGFloat()
                    let height = cGImage.height.toCGFloat()
                    
                    let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                    let croppedCGImage: CGImage = cGImage.cropping(to: rect)!
                    
                    let img = UIImage(cgImage: croppedCGImage)
                    if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                        
                        logger.printLog("Adding In Cache \(imageName+crop.toString())")
                        
                        addToCache(texture: newTexture, key: imageName+crop.toString())
                        return newTexture
                    }
                }
            }
        }
        return nil
    }
  
    
    func getTextureFromServer(imageName:String,id:Int,crop:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0),flip:Bool,isCropped:Bool = false,checkInCache: Bool = true) async -> MTLTexture? {
              
        do {

            if checkInCache{
                if let texture = getTextureFromCache(key: imageName+crop.toString()) {
                    logger.printLog("Found In Cache \(imageName)")
                    return texture
                }
            }

            if let cgImage = await resourceProvider.readDataFromFileQLFromDocument(fileName: imageName, maxSize: _fetchIdealSize) {
//                if let cgImage = image?.cgImage{
                    let width = cgImage.width.toCGFloat()
                    let height = cgImage.height.toCGFloat()
                    
                    let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                    let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                
                    let img = UIImage(cgImage: croppedCGImage)
                    if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
//                        Task{
//                            await addToCache(texture: newTexture, id: imageName+"\(id)")
//                        }
                        logger.printLog("Adding In Cache \(imageName+crop.toString())")

                        addToCache(texture: newTexture, key: imageName+crop.toString())
                        return newTexture
                    }
                    
//                }
            }
            
            else {
                do{
                    
                    if let serverImage = try await resourceProvider.fetchImage(imageURL: imageName) {
                        
                        if let imageData = serverImage.pngData() {
                            let imagePath = imageName.components(separatedBy: "/").last ?? ""
                            
                            
                           let maxSize = computeIdealMaxResizeDimension(for: serverImage, cropRect: crop)
                            let resizedImage = resizeImage(image: serverImage, targetSize: maxSize)
                            
                            if let cgImage = resizedImage?.cgImage{
                                let width = cgImage.width.toCGFloat()
                                let height = cgImage.height.toCGFloat()
                                
                                let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                                let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                                
                                let img = UIImage(cgImage: croppedCGImage)
                                if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                                    //                Task{
                                    addToCache(texture: newTexture, key: imageName+crop.toString())
                                    //                }
                                    try resourceProvider.saveImageToDocumentsDirectory(imageData: imageData, filename: imagePath, directory: resourceProvider.getAssetsPath()!)
                                    
                                    return newTexture
                                }
                                
                            }
                            
                            
                        }
                    }else{
                        logger.logError("Error fetching server image.")
                        let img = resourceProvider.getDefaultImage()
                        
                        if let img = img{
                            let resizedImage = resizeImage(image: img, targetSize: _fetchIdealSize)
                            if let cgImage = resizedImage?.cgImage{
                                let width = cgImage.width.toCGFloat()
                                let height = cgImage.height.toCGFloat()
                                
                                let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                                let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                                
                                let img = UIImage(cgImage: croppedCGImage)
                                if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                                    
                                    return newTexture
                                }
                                
                            }
                        }
                    }
                    
                    
                }
                catch{
                    logger.logError("Error fetching server image.")
                    let img = resourceProvider.getDefaultImage()
                    
                    if let img = img{
                        let resizedImage = resizeImage(image: img, targetSize: _fetchIdealSize)
                        if let cgImage = resizedImage?.cgImage{
                            let width = cgImage.width.toCGFloat()
                            let height = cgImage.height.toCGFloat()
                            
                            let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                            let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                            
                            let img = UIImage(cgImage: croppedCGImage)
                            if let newTexture = Conversion.loadTexture(image: img,flip:flip) {

                                return newTexture
                            }
                            
                        }
                    }
                    print("image is not downloaded for server Path")
                }
            }
        }
        return nil
    }
    
    func getTextureFromLocal(imageName:String,id:Int,crop:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0),flip:Bool,isCropped:Bool = false,checkInCache: Bool = true) async -> MTLTexture? {
        
  
            
        do {
            
            if checkInCache{
                if let texture = getTextureFromCache(key: imageName+crop.toString()) {
                    logger.printLog("Found In Cache \(imageName+crop.toString())")
                    return texture
                    
                }
            }
 
            if let cgImage = await resourceProvider.readDataFromFileQLFromAssets(fileName: imageName, maxSize: _fetchIdealSize) {
               
                
                    let width = cgImage.width.toCGFloat()
                    let height = cgImage.height.toCGFloat()
                    
                    let rect = CGRect(x: crop.origin.x*width, y: crop.origin.y*height, width: crop.width*width, height: crop.height*height)
                    let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                
                    let img = UIImage(cgImage: croppedCGImage)
                    if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                        
                        logger.printLog("Adding In Cache LOCAL \(imageName+crop.toString())")
                      
                        addToCache(texture: newTexture, key: imageName+crop.toString())
                        
                        return newTexture
                    }
                    
                
            } else if let cgImage = await resourceProvider.readDataFromFileQLFromLocalAssets(fileName: imageName, maxSize: _fetchIdealSize ) {
                
                
                    let width = cgImage.width.toCGFloat()
                    let height = cgImage.height.toCGFloat()
                    
                    let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                    let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                
                    let img = UIImage(cgImage: croppedCGImage)
                    if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                       
                        logger.printLog("Adding In Cache LOCAL \(imageName+crop.toString())")
                        addToCache(texture: newTexture, key: imageName+crop.toString())
                        
                        
                        return newTexture
                    }
                    
                
            }else{
                logger.logError("Error fetching image from documents.")
                let img = resourceProvider.getDefaultImage()
                
                if let img = img, let imageData = img.pngData(){
                    let resizedImage = resizeImage(image: img, targetSize: _fetchIdealSize)
                    if let cgImage = resizedImage?.cgImage{
                        let width = cgImage.width.toCGFloat()
                        let height = cgImage.height.toCGFloat()
                        
                        let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                        let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                        
                        let img = UIImage(cgImage: croppedCGImage)
                        if let newTexture = Conversion.loadTexture(image: img,flip:flip) {

                            return newTexture
                        }
                        
                    }
                }
            }
        }
           

      
       
        return nil
    }
    

    
    func cleanUp(){
        cache.removeAll()
    }
    

}

extension TextureCache {
    // BGTexture Fetching ....
    func getTextureBGFromBundle(imageName:String,id:Int,crop:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0),flip:Bool,isCropped:Bool = false,size:CGSize) async -> MTLTexture? {

        let name = imageName.components(separatedBy: "/").last
        let localpath = name?.replacingOccurrences(of: ".png", with: "") ?? ""
        
        if let texture = getTextureFromCache(key: localpath+crop.toString()) {
            logger.printLog("Found In Cache \(imageName+crop.toString())")
            return texture
        }
        
        if let url = Bundle.main.resourcePath {
            let imagePath = (url as NSString).appendingPathComponent("\(imageName).png")
            let imageURL = URL(fileURLWithPath: imagePath)
            
            
            var cGImage = await resourceProvider.loadImageUsingQL(fileURL: imageURL, maxSize: _fetchIdealSize)
            
            if cGImage == nil , let image =  UIImage(named:localpath) {
                logger.logInfo("Manual Resize \(localpath)")
                cGImage = resizeImage(image: image, targetSize: _fetchIdealSize)?.cgImage
            }
            
            guard let cGImage = cGImage else {
                logger.logError("Coundnt Find URL In Bundle \(localpath)")
                return nil
            }
            
            let width = cGImage.width.toCGFloat()
            let height = cGImage.height.toCGFloat()
            let aspectratio = CGSize(width: width, height:height)
            let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: size)
            
            let rect = CGRect(x: cropPoints.minX*width, y: cropPoints.minY*height, width: cropPoints.width*width, height: cropPoints.height*height)
            let croppedCGImage: CGImage = cGImage.cropping(to: rect)!
            
            let img = UIImage(cgImage: croppedCGImage)
            if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                logger.printLog("Adding In Cache \(localpath+crop.toString())")
                
                addToCache(texture: newTexture, key: localpath+crop.toString())
                return newTexture
            }
        }else{
            logger.logError("Coundnt Find URL In Bundle \(imageName)")
            
            if let image =  UIImage(named:localpath) {

                if let cGImage = image.cgImage{
                    let width = cGImage.width.toCGFloat()
                    let height = cGImage.height.toCGFloat()
                    let aspectratio = CGSize(width: width, height:height)
                    //           let siz =  getProportionalBGSize(currentRatio: ratioSize, oldSize: ratioSize )
                    let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: size)
                    
                    let rect = CGRect(x: cropPoints.minX*width, y: cropPoints.minY*height, width: cropPoints.width*width, height: cropPoints.height*height)
                    let croppedCGImage: CGImage = cGImage.cropping(to: rect)!
                    
                    let img = UIImage(cgImage: croppedCGImage)
                    if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                        logger.printLog("Adding In Cache \(localpath+crop.toString())")
                        
                        addToCache(texture: newTexture, key: localpath+crop.toString())
                        return newTexture
                    }
                }
            }
        }
//       }
        
       return nil
   }

func getTextureBGFromServer(imageName:String,id:Int,crop:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0),flip:Bool,isCropped:Bool = false,size:CGSize) async -> MTLTexture? {

       do {
           if let texture = getTextureFromCache(key: imageName+crop.toString()) , !isCropped {
               logger.printLog("Found In Cache \(imageName)")
               return texture
           }
           
           if let cgImage = await resourceProvider.readDataFromFileQLFromAssets(fileName: imageName, maxSize: _fetchIdealSize) {

//                    if let cgImage = image?.cgImage{
                   let width = cgImage.width.toCGFloat()
                   let height = cgImage.height.toCGFloat()
                   let aspectratio = CGSize(width: width, height:height)
                   var rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
                   rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                   let croppedCGImage1: CGImage = cgImage.cropping(to: rect)!
                   let width2 = croppedCGImage1.width.toCGFloat()
                   let height2 = croppedCGImage1.height.toCGFloat()
                   let aspectratio2 = CGSize(width: width2, height:height2)
                   let cropPoints = calculateCropPoint(imageSize: aspectratio2, cropSize: size)
                       rect = CGRect(x: cropPoints.minX*width2, y: cropPoints.minY*height2, width: cropPoints.width*width2, height: cropPoints.height*height2)

                   let croppedCGImage: CGImage = croppedCGImage1.cropping(to: rect)!

                   let img = UIImage(cgImage: croppedCGImage)
                   if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                       logger.printLog("Adding In Cache \(imageName+crop.toString())")

                       addToCache(texture: newTexture, key: imageName+crop.toString())
                       
                       return newTexture
                   }

               
           }else if let cgImage = await resourceProvider.readDataFromFileQLFromLocalAssets(fileName: imageName, maxSize: _fetchIdealSize){

                   let width = cgImage.width.toCGFloat()
                   let height = cgImage.height.toCGFloat()
                   let aspectratio = CGSize(width: width, height:height)
                   var rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
                   rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                   let croppedCGImage1: CGImage = cgImage.cropping(to: rect)!
                   let width2 = croppedCGImage1.width.toCGFloat()
                   let height2 = croppedCGImage1.height.toCGFloat()
                   let aspectratio2 = CGSize(width: width2, height:height2)
                   let cropPoints = calculateCropPoint(imageSize: aspectratio2, cropSize: size)
                       rect = CGRect(x: cropPoints.minX*width2, y: cropPoints.minY*height2, width: cropPoints.width*width2, height: cropPoints.height*height2)
               
                   let croppedCGImage: CGImage = croppedCGImage1.cropping(to: rect)!

                   let img = UIImage(cgImage: croppedCGImage)
                   if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                       logger.printLog("Adding In Cache  \(imageName+crop.toString())")

                       addToCache(texture: newTexture, key: imageName+crop.toString())
                       return newTexture
               }
           }

           else {
               do{
                   
                   if let serverImage = try await resourceProvider.fetchImage(imageURL: imageName){
                      
                       if let imageData = serverImage.pngData() {
                          let idealSize = computeIdealMaxResizeDimension(for: serverImage, cropRect: crop)
                           let resizedImage = resizeImage(image: serverImage, targetSize:idealSize )
                           if let cgImage = resizedImage?.cgImage{
                               let width = cgImage.width.toCGFloat()
                               let height = cgImage.height.toCGFloat()
                               
                               let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                               let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                               
                               let img = UIImage(cgImage: croppedCGImage)
                               if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                                   addToCache(texture: newTexture, key: imageName+crop.toString())
                                   
                                   try resourceProvider.saveImageToDocumentsDirectory(imageData: imageData, filename: imageName, directory: resourceProvider.getAssetsPath()!)
                                   
                                   return newTexture
                               }
                               
                           }
                           
                       }
                   }else{
                       logger.logError("Error fetching server BG image.")
                       let img = resourceProvider.getDefaultImage()
                       
                       if let img = img{
                           let resizedImage = resizeImage(image: img, targetSize: _fetchIdealSize)
                           if let cgImage = resizedImage?.cgImage{
                               let width = cgImage.width.toCGFloat()
                               let height = cgImage.height.toCGFloat()
                               
                               let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                               let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                               
                               let img = UIImage(cgImage: croppedCGImage)
                               if let newTexture = Conversion.loadTexture(image: img,flip:flip) {
                                   
                                   return newTexture
                               }
                               
                           }
                       }
                   }
                   
               }
               catch{
                   logger.logError("Error fetching server BG image.")
                   let img = resourceProvider.getDefaultImage()
                   
                   if let img = img{
                       let resizedImage = resizeImage(image: img, targetSize: _fetchIdealSize)
                       if let cgImage = resizedImage?.cgImage{
                           let width = cgImage.width.toCGFloat()
                           let height = cgImage.height.toCGFloat()
                           
                           let rect = CGRect(x: crop.minX*width, y: crop.minY*height, width: crop.width*width, height: crop.height*height)
                           let croppedCGImage: CGImage = cgImage.cropping(to: rect)!
                           
                           let img = UIImage(cgImage: croppedCGImage)
                           if let newTexture = Conversion.loadTexture(image: img,flip:flip) {

                               return newTexture
                           }
                           
                       }
                   }
                   print("image is not downloaded for server Path")
               }
           }
       }
           catch{
               print("image not found on server")
           }



       




       return nil
   }

}

extension TextureCache{
    
 
   /// get cropped image from image with help of crop points
    private func cropImage(_ image: UIImage, crop: CGRect) -> UIImage {
        guard let cgImage = image.cgImage else {
            return image
        }
        
        let width = cgImage.width.toCGFloat()
        let height = cgImage.height.toCGFloat()
        let rect = CGRect(x: crop.minX * width, y: crop.minY * height, width: crop.width * width, height: crop.height * height)
        
        guard let croppedCGImage = cgImage.cropping(to: rect) else {
            return image
        }
        
        return UIImage(cgImage: croppedCGImage)
    }// end of Crop Image Method
    
    
}
extension CGRect {
    func toString() -> String {
        return "_\(self.origin.x)_\(self.origin.y)_\(self.width)_\(self.height)"
    }
}
