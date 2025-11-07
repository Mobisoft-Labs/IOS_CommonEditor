//
//  MetalView.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 13/01/23.
//

import MetalKit
import CoreMedia


//var DRAWABLE_SIZE = CGSize(width: 1179, height: 2096);
class IOSMetalView : UIView {

    
    
    var MyScreen : UIScreen!
    private(set) var device: MTLDevice!
    var depthPixelFormat: MTLPixelFormat = MetalDefaults.DepthPixelFormat
    var stencilPixelFormat: MTLPixelFormat = MetalDefaults.StencilPixelFormat
    var sampleCount = 0
    var drawableSize : CGSize = .zero
    
    private var _currentDrawable: CAMetalDrawable?
    private var _renderPassDescriptor: MTLRenderPassDescriptor?

    /*private*/ weak var _metalLayer: CAMetalLayer!
    private var _layerSizeDidUpdate: Bool = false

   // var timeHandler : TimeLoopHnadler!

    var recorder : IOSMetalRecorder!
    weak var delegate : IOSMetalViewRenderDelegate?
    weak var feedbackListner : IOSMetalViewFeedbackDelegate?
    
    var stopOfflineRecording = true
   // var renderDuration = MetalDefaults.RenderTotalTime
   
    var logger: PackageLogger?
    var sceneConfig: SceneConfiguration?
    
    #if os(iOS)
    override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    #endif
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tag = 100
       // self.timeHandler = TimeLoopHnadler(listener: self, timeLengthDuration: renderDuration)
          commonInit()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = 100
       // self.timeHandler = TimeLoopHnadler(listener: self, timeLengthDuration: renderDuration)
        commonInit()
    }
    func addDropShadow(color: UIColor = .black,
                       opacity: Float = 0.3,
                       offset: CGSize = CGSize(width: 0, height: -1),
                       radius: CGFloat = 3) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func setPackageLogger(logger: PackageLogger, sceneConfig: SceneConfiguration){
        self.logger = logger
        self.sceneConfig = sceneConfig
        self.sceneConfig?.contentScaleFactor = MyScreen!.nativeScale
    }
    
    func commonInit(){
        #if os(iOS)
            self.isOpaque = true
            self.backgroundColor = nil
            _metalLayer = (self.layer as! CAMetalLayer)
        MyScreen = self.window?.screen ?? UIScreen.main
        let screen = MyScreen!
//        UIStateManager.shared.contentscaleFactor = screen.nativeScale//UIStateManager.shared.getContentScaleFactor()
        drawableSize.width = frame.width * screen.nativeScale
        drawableSize.height *= frame.height * screen.nativeScale

        #else
            self.wantsLayer = true
            let metalLayer = CAMetalLayer()
            _metalLayer = metalLayer
            self.layer = _metalLayer
        MyScreen = self.window?.screen ?? NSScreen.main
        #endif
        
        device = MTLCreateSystemDefaultDevice()!
        
        _metalLayer.device          = device
        _metalLayer.pixelFormat     = .bgra8Unorm
        
        // this is the default but if we wanted to perform compute on the final rendering layer we could set this to no
        _metalLayer.framebufferOnly = false
      
//        self.renderer = FBORenderer(for: self)
//        self.delegate = renderer
        
     //   renderDuration = MetalDefaults.RenderTotalTime
       // self.timeHandler = TimeLoopHnadler(listener: self, timeLengthDuration: renderDuration)
        
       

    }
    
    #if os(iOS)
    override func didMoveToWindow() {
//        self.contentScaleFactor = self.window?.screen.nativeScale ?? 1
        
    }
    #endif
    
    override func didMoveToSuperview() {
        
#if os(iOS)
    let screen = MyScreen!
        drawableSize.width = self.bounds.width * screen.nativeScale
    drawableSize.height = self.bounds.height * screen.nativeScale
#else
    let screen = MyScreen!
        drawableSize.height = self.bounds.width * sceeen?.backingScaleFactor ?? 1.0
        drawableSize.height = self.bounds.height * screen?.backingScaleFactor ?? 1.0
#endif
        
       // DRAWABLE_SIZE = drawableSize
        _layerSizeDidUpdate = false
      //  renderer.prepareSticker(drawableSize: drawableSize)

    }
    //// the current drawable created within the view's CAMetalLayer
    var currentDrawable: CAMetalDrawable? {
        if _currentDrawable == nil {
            _currentDrawable = _metalLayer.nextDrawable()
        }
        
        return _currentDrawable!
    }
    
    // The current framebuffer can be read by delegate during -[MetalViewDelegate render:]
    // This call may block until the framebuffer is available.
    var renderPassDescriptor: MTLRenderPassDescriptor? {
        if let drawable = self.currentDrawable {
            if _renderPassDescriptor == nil {
                _renderPassDescriptor = MTLRenderPassDescriptor()
                setupRenderPassDescriptorForTexture(drawable.texture)
            }
            
        } else {
            logger?.printLog(">> ERROR: Failed to get a drawable!")
            _renderPassDescriptor = nil
        }
        
        return _renderPassDescriptor
    }
    
    private func setupRenderPassDescriptorForTexture(_ texture: MTLTexture) {
        // create lazily
        if _renderPassDescriptor == nil {
            _renderPassDescriptor = MTLRenderPassDescriptor()
        }
        
        // create a color attachment every frame since we have to recreate the texture every frame
        let colorAttachment = _renderPassDescriptor!.colorAttachments[0]
        colorAttachment?.texture = texture
        
        // make sure to clear every frame for best performance
        colorAttachment?.loadAction = .clear
        colorAttachment?.clearColor = MetalClearColors.transparent
        
        // if sample count is greater than 1, render into using MSAA, then resolve into our color texture
//        if sampleCount > 1 {
//            let  doUpdate =     ( _msaaTex?.width       != texture.width  )
//                ||  ( _msaaTex?.height      != texture.height )
//                ||  ( _msaaTex?.sampleCount != sampleCount   )
//
//            if _msaaTex == nil || (_msaaTex != nil && doUpdate) {
//                let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
//                    width: texture.width,
//                    height: texture.height,
//                    mipmapped: false)
//                desc.textureType = .type2DMultisample
//
//                // sample count was specified to the view by the renderer.
//                // this must match the sample count given to any pipeline state using this render pass descriptor
//                desc.sampleCount = sampleCount
//
//                _msaaTex = device?.makeTexture(descriptor: desc)
//            }
//
//            // When multisampling, perform rendering to _msaaTex, then resolve
//            // to 'texture' at the end of the scene
//            colorAttachment?.texture = _msaaTex
//            colorAttachment?.resolveTexture = texture
//
//            // set store action to resolve in this case
//            colorAttachment?.storeAction = MTLStoreAction.multisampleResolve
//        } else {
            // store only attachments that will be presented to the screen, as in this case
            colorAttachment?.storeAction = MTLStoreAction.store
       // }
        
        // Now create the depth and stencil attachments
        
//        if depthPixelFormat != .invalid {
//            let doUpdate =     ( _depthTex?.width       != texture.width  )
//                ||  ( _depthTex?.height      != texture.height )
//                ||  ( _depthTex?.sampleCount != sampleCount   )
//
//            if _depthTex == nil || doUpdate {
//                //  If we need a depth texture and don't have one, or if the depth texture we have is the wrong size
//                //  Then allocate one of the proper size
//                let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: depthPixelFormat,
//                    width: texture.width,
//                    height: texture.height,
//                    mipmapped: false)
//
//                desc.textureType = (sampleCount > 1) ? .type2DMultisample : .type2D
//                desc.sampleCount = sampleCount
//                desc.usage = MTLTextureUsage()
//                desc.storageMode = .private
//
//                _depthTex = device?.makeTexture(descriptor: desc)
//
//                if let depthAttachment = _renderPassDescriptor?.depthAttachment {
//                    depthAttachment.texture = _depthTex
//                    depthAttachment.loadAction = .clear
//                    depthAttachment.storeAction = .dontCare
//                    depthAttachment.clearDepth = 1.0
//                }
//            }
//        }
        
//        if stencilPixelFormat != .invalid {
//            let doUpdate  =    ( _stencilTex?.width       != texture.width  )
//                ||  ( _stencilTex?.height      != texture.height )
//                ||  ( _stencilTex?.sampleCount != sampleCount   )
//
//            if _stencilTex == nil || doUpdate {
//                //  If we need a stencil texture and don't have one, or if the depth texture we have is the wrong size
//                //  Then allocate one of the proper size
//                let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: stencilPixelFormat,
//                    width: texture.width,
//                    height: texture.height,
//                    mipmapped: false)
//
//                desc.textureType = (sampleCount > 1) ? .type2DMultisample : .type2D
//                desc.sampleCount = sampleCount
//
//                _stencilTex = device?.makeTexture(descriptor: desc)
//
//                if let stencilAttachment = _renderPassDescriptor?.stencilAttachment {
//                    stencilAttachment.texture = _stencilTex
//                    stencilAttachment.loadAction = .clear
//                    stencilAttachment.storeAction = .dontCare
//                    stencilAttachment.clearStencil = 0
//                }
//            }
//        }
    }
    
    
#if os(iOS)
override var contentScaleFactor: CGFloat {
    get {
        return super.contentScaleFactor
    }
    set {
        if contentScaleFactor != newValue{
            super.contentScaleFactor = newValue
            _layerSizeDidUpdate = true
        }
    }
}

override func layoutSubviews() {
    super.layoutSubviews()
    _layerSizeDidUpdate = true
    addDropShadow()
   // startRendering()
    drawableSize = self.bounds.size
}
#else
override func setFrameSize(_ newSize: NSSize) {
    super.setFrameSize(newSize)
    _layerSizeDidUpdate = true
}

override func setBoundsSize(_ newSize: NSSize) {
    super.setBoundsSize(newSize)
    _layerSizeDidUpdate = true
    drawableSize = self.bounds.size
}
override func viewDidChangeBackingProperties() {
    super.viewDidChangeBackingProperties()
    _layerSizeDidUpdate = true
}
#endif

}


// draw call render loop
extension IOSMetalView  {
//    func startRendering() {
//       // onMetalThread { [self] in
//            timeHandler.startRendering()
//       // }
//    }
//    
//    
//    func pauseRendering(){
//       // onMetalThread { [self] in
//            timeHandler.pauseRendering()
//       // }
//    }
//    
//    func resumeRendering(){
//        
//        // get current time and update this as global time
//       // onMetalThread { [self] in
//            timeHandler.resumeRendering()
//      //  }
//    }
//    
//    func stopRendering(){
//        
//       // onMetalThread {
//            self.timeHandler.stopRendering()
//       // }
//        
//    }
    
    func onDrawCallStop() {
        feedbackListner?.didStopRendering()
    }
    
    
    
    
//    func onDrawCall(currentTime: Float) {
//        
//        
//        
//        metalThread.async {
//            autoreleasepool{
//                self.callDrawMethodForNextFrame(currentTime: currentTime)
//            }
//        }
//    }
    
//    func setCurrentTime(currentTime:Float) {
//        metalThread.async { [self] in
//            autoreleasepool{
//                self.callDrawMethodForNextFrame(currentTime: currentTime)
//            }
//            timeHandler._LastPausedTime = TimeInterval(currentTime)
//            timeHandler.timeStatus = .Manual
//        }
//    }
    
    
//    func setRadialGradient(currentTime:Float){
//        metalThread.async{[self] in
//            self.feedbackListner?.showGradientradial(currentTime: currentTime)
//        }
//    }
    
     func callDrawMethodForNextFrame(currentTime:Float, needThumbnail: Bool,completion: ((MTLTexture?)->())? = nil) {
        // Create autorelease pool per frame to avoid possible deadlock situations
        
        feedbackListner?.showCurrentTime(currentTime: currentTime)
        // handle display changes here
        if _layerSizeDidUpdate {
            // set the metal layer to the drawable size in case orientation or size changes
            
            
            // scale drawableSize so that drawable is 1:1 width pixels not 1:1 to points
#if os(iOS)
            let screen = MyScreen!
            drawableSize.width *= screen.nativeScale
            drawableSize.height *= screen.nativeScale
#else
            let screen = MyScreen!
            drawableSize.width *= screen?.backingScaleFactor ?? 1.0
            drawableSize.height *= screen?.backingScaleFactor ?? 1.0
#endif
            
#if os(OSX)
            printLog("macOS")
#elseif os(watchOS)
            printLog("watchOS")
#elseif os(tvOS)
            printLog("tvOS")
#elseif os(iOS)
#if targetEnvironment(macCatalyst)
            logger?.printLog("macOS - Catalyst")
#else
            logger?.printLog("iOS")
#endif
#endif
            _metalLayer.drawableSize = drawableSize
            
            // renderer delegate method so renderer can resize anything if needed
            delegate?.IOSMetalView(self, didChangeSize: drawableSize)
            
            _layerSizeDidUpdate = false
        }
        
        
        // currentTimeUpdated?(currentTime)
        // rendering delegate method to ask renderer to draw this frame's content
         delegate?.draw(in: self,currentTime:currentTime, needThumbnail: needThumbnail, completion: completion)
        
        // do not retain current drawable beyond the frame.
        // There should be no strong references to this object outside of this view class
        _currentDrawable    = nil
        
        
        
        
        //}
        
    }

    
}
extension IOSMetalView {
    
    
    func startRenderingOffline(){
 
    }
    
    func stopOffline(){
        //onMetalThread { [self] in
            stopOfflineRecording = true
            recorder.isRecording = false
       // }
        
    }
}
