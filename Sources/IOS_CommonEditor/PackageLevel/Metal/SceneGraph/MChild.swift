//
//  MChild.swift
//  VideoInvitation
//
//  Created by HKBeast on 22/08/23.
//

import Foundation
import Metal
import simd
import UIKit
import SwiftUICore

struct GradientInfoMetal{
    var startColor:SIMD3<Float>
    var endColor:SIMD3<Float>
    var gradientType:Float
    var radius:Float
    var angleInDegree:Float
}


public enum PreviewAnimType {
    case InType
    case OutType
    case LoopType
    case None
}

class MChild :  Renderable{
    
    @Injected var shaderLibrary : ShaderLibrary
    
    var mOrder :Int = -1
    
    var _currentTime : Float = 0 {
        didSet {
//            print("CTime:",_currentTime)
        }
    }
    
 
    var _respectiveTime: Bool = true {
        didSet{
            
        }
    }
    
    var _canRenderWatermark : Bool = false{
        didSet {
            print("_canRenderWatermark:\(self)",_canRenderWatermark)
        }
    }
    
    var canRenderWatermark : Bool {
        return parent?.canRenderWatermark ?? _canRenderWatermark
    }
    
    var _renderingMode : MetalEngine.RenderingState = .Edit

    
    var _drawableSize : CGSize {
        return getProportionalSize(currentSize: size, newSize: context.drawableSize)
    }
    var animPreviewMode : PreviewAnimType =  .None{
        didSet {
           
               

                
             if animPreviewMode == .LoopType {
                inAnimation.duration = 0
                animation.set_In_Animation(animationInfo: inAnimation)
                outAnimation.duration = 0
                animation.set_Out_Animation(animationInfo: outAnimation)
                loopAnimation.duration = mLoopAnimationDuration
                animation.set_Loop_Animation(animationInfo: loopAnimation)
             

             }else{
                 inAnimation.duration = mInAnimationDuration
                 animation.set_In_Animation(animationInfo: inAnimation)
                 outAnimation.duration = mOutAnimationDuration
                 animation.set_Out_Animation(animationInfo: outAnimation)
                 loopAnimation.duration = mLoopAnimationDuration
                 animation.set_Loop_Animation(animationInfo: loopAnimation)
             }
            
            
        }
    }
    
    
    var previewAnimation : AnimTemplateInfo = AnimTemplateInfo()
    
     var animCurrentTime: Float {
         return parent?.animCurrentTime ?? .zero
    }
    
    var mIsSoftDeleted: Bool = false
    
    var respectiveTime: Bool {
        return parent?.respectiveTime ?? _respectiveTime
    }
    
    var mIsVisible: Bool = true
    
    var mLockStatus:Bool = false
    
    var currentTime: Float {
        return parent?.currentTime ?? _currentTime
    }
    
    var renderingMode : MetalEngine.RenderingState {
        return parent?.renderingMode ?? _renderingMode
    }

    
    var isInPreviewAnimation : Bool = false
    
    
    
    var id : Int = 0
    
    var name : String = "MChild"
    
    var identification : String {
        return "\(id) : \(name)"
    }
    
    var context : MContext = MContext(drawableSize: CGSize(width: 50, height: 50))
    
    weak var parent : MParent? {
        didSet {
            if parent != nil {
                _use_cached_matrix = false
                
               // self.center.y = parent?.size.height - center.y
            }
        }
    }
  
    var renderPipelineState: MTLRenderPipelineState!
    var pipelineType  : PipelineLibraryType = .None
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    
    var vertexDescriptor: MTLVertexDescriptor!

    var geometry: MeshGeometry = QuadMesh(color: MColor.BlueColor)
    
    var _use_cached_matrix : Bool = false
    
    var modalConstant = ModalConstant()
    
    //
    var mCropStyle:Int = 1
    var startTime : Float = 0.0
    
    var previousWidth:Float = 0.0
    var previousHeight:Float = 0.0
    
    internal var mStartTime : Float  {
        return startTime + (parent?.mStartTime ?? 0.0)
    }
    internal var mDuration : Float = 20.0
    
    func setMSoftDelete(_ delete: Bool) {
        mIsSoftDeleted = delete
    }
    
//    func setRespectiveTime(_ value: Bool){
//        respectiveTime = value
//    }
    
    
    func setMCropStyle(cropStyle:Int){
        mCropStyle = cropStyle
    }
    
    func setMIsVisible(_ visible: Bool) {
        mIsVisible = visible
      
    }
    func setmOrderInParent(order:Int){
        mOrder = order
    }
    
    func setMStartTime(_ startTime:Float) {
        self.startTime = startTime
    }
    
    func setMDuration(_ duration:Float) {
        mDuration = duration
    }
    
    var size : CGSize = .zero {
        didSet {
            _use_cached_matrix = false
        }
    }
    var center : CGPoint = .zero{
        didSet {
            _use_cached_matrix = false
        }
    }
    var zRotation : Float = .zero {
        didSet {
            _use_cached_matrix = false
        }
    }
    var xRotation : Float = .zero {
        didSet {
            _use_cached_matrix = false
        }
    }
    var yRotation : Float = .zero {
        didSet {
            _use_cached_matrix = false
        }
    }
    
    private var mPosition: float3  {
        var position = float3(0.0,0.0,1.0)
        if let parent1 = parent {
//            var center = Conversion.setPositionForMetal(centerX: Float(center.x/parent.size.width), centerY: 1.0-Float(center.y/parent.size.height))
            let fromXRange = Float(0)...Float(parent1.size.width)
            let toXRange = -Float(parent1.size.width)...Float(parent1.size.width)

            var centerX = Conversion.mapValue(Float(center.x), fromRange: fromXRange, toRange: toXRange)
            
            let fromYRange = Float(0)...Float(parent1.size.height)
            let toYRange = -Float(parent1.size.height)...Float(parent1.size.height)
            var centerY = Conversion.mapValue(Float(parent1.size.height-center.y), fromRange: fromYRange, toRange: toYRange)

            position = float3(Float(centerX), Float(centerY), 1.0)
        }
        
        return position
    }
    
   
   private var mScale: float3  {
        var scale = float3(1.0,1.0,0.0)
        
        if let parent = parent {
            let calcSize =   CGSize(width: 1.0/parent.size.width, height: 1.0/parent.size.height)
            scale.x = Float(calcSize.width)
            scale.y = Float(calcSize.height)

        }else{
            let calcSize =  CGSize(width: 1.0/context.rootSize.width, height: 1.0/context.rootSize.height)
             scale.x = Float(calcSize.width)
            scale.y = Float(calcSize.height)
        }
        return scale
    }
    
    
    var mRotation: float3  {
        var rotation = float3.zero
        
//        if let parent = parent  {
            rotation = float3(xRotation,yRotation,zRotation) //+ parent.mRotation
//        }
        
        return rotation
    }
    
    
    var mgradientInfo:GradientInfoMetal?{
        didSet{
          _use_cached_texture = false
        }
    }
// Adjustment filter
    var _use_cached_texture = false
    
    var mcolor : float3 = float3(1.0, 0.0, 0.0){
        didSet{
          _use_cached_texture = false
        }
    }
    
    
    
    var mOpacity : Float = 1.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mblur :Float = 0.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mContentType:Float = 0.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mStickerType:Float = 0.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mOverlayTexture:MTLTexture? = nil{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mOverlayBlur:Float = 0.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mTileCount:Float = 0.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    var mHue:Float = 0.0{
        didSet{
            _use_cached_texture = false
        }
    }
    
    
    var cached_model_matrix : matrix_float4x4 = matrix_identity_float4x4
    
    var logger: PackageLogger?
    
    var model_matrix : matrix_float4x4 {
        if _use_cached_matrix {
            return cached_model_matrix
        }
        var modelMatrix = matrix_identity_float4x4
        
        modelMatrix.translate(direction: mPosition)
//        modelMatrix.rotate(angle: mRotation.x, axis: X_AXIS)
//        modelMatrix.rotate(angle: mRotation.y, axis: Y_AXIS)
       // modelMatrix.scale(axis: mScale)
        
       
       
        modelMatrix.rotate(angle: mRotation.z, axis: Z_AXIS)

//        var parentMat = matrix_identity_float4x4
//        parentMat.scale(Float(self.size.width/BASE_SIZE.width), y: Float(self.size.height/BASE_SIZE.height) * Float(BASE_SIZE.width/BASE_SIZE.height), z: 1.0)
//        
       // modelMatrix = modelMatrix * parentMat
        
        cached_model_matrix = modelMatrix
        _use_cached_matrix = true
        return modelMatrix
    }
    
    init(model:BaseModelProtocol){
        self.id = model.modelId
        self.name = "\(self)"
       setModel(model: model)
    }
    
    func setPackageLogger(logger: PackageLogger){
        self.logger = logger
        animation.setPackageLogger(logger: logger)
    }
    
    func setModel(model:BaseModelProtocol) {
        
        if model is TextInfo {
            
            logger?.printLog("")
        }
        setmOrderInParent(order: model.orderInParent)
        setMStartTime(model.baseTimeline.startTime)
        setMDuration(model.baseTimeline.duration)
        setMSoftDelete(model.softDelete)
        setMIsVisible(true)
        setmOpacity(opacity: model.modelOpacity)
        setmCenter(centerX: CGFloat(model.baseFrame.center.x), centerY: CGFloat(model.baseFrame.center.y))
        setmZRotation(rotation: model.baseFrame.rotation)
        setmSize(width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
//        setColor(color: float3(1.0, 0.0, 0.0))
        mFlipType_vert = Float(model.modelFlipVertical.toInt())
        mFlipType_hori = Float(model.modelFlipHorizontal.toInt())
        previousWidth = Float(model.prevAvailableWidth)
        previousHeight  = Float(model.prevAvailableHeight)
        setLockStatus(lock: model.lockStatus)
       


//        var animationInfo = DBMediator.shared.fetchAnimationInfo(for: 1189 )//101 //185 // 161 // 3759 // 3758
//        let inTemplateModel = DBMediator.shared.fetchAnimTemplateInfo(templateID: 58) // JD HERE TEST
//        let outTemplateModel = DBMediator.shared.fetchAnimTemplateInfo(templateID: 59)
//        let loopTemplateModel = DBMediator.shared.fetchAnimTemplateInfo(templateID: 2)
        
      
        setInAnimationDuration(model.inAnimationDuration)
        setOutAnimationDuration(model.outAnimationDuration)
        setLoopAnimationDuration(model.loopAnimationDuration)
        
        setInAnimation(model.inAnimation)
        setOutAnimation(model.outAnimation)
        setLoopAnimation(model.loopAnimation)

//        if id == 3461 {
//            startTime = 0.1
//        }
        
//        animation.set_In_Animation(animationInfo: inTemplateModel)
//            animation.set_Out_Animation(animationInfo: outTemplateModel)
//            animation.set_Loop_Animation(animationInfo: loopTemplateModel)

    }
    
    
    func setInAnimation(_ inAnim : AnimTemplateInfo) {
        inAnimation = inAnim
        inAnimation.duration = mInAnimationDuration
        animation.set_In_Animation(animationInfo: inAnimation)
        previewAnimation = inAnim
        previewAnimation.duration = mInAnimationDuration

    }
    func setOutAnimation(_ outAnim : AnimTemplateInfo) {
        outAnimation = outAnim
        outAnimation.duration = mOutAnimationDuration
        animation.set_Out_Animation(animationInfo: outAnimation)
        previewAnimation = outAnim
        previewAnimation.duration = mOutAnimationDuration

    }
    func setLoopAnimation(_ loopAnim : AnimTemplateInfo) {
        loopAnimation = loopAnim
        loopAnimation.duration = mLoopAnimationDuration
        animation.set_Loop_Animation(animationInfo: loopAnimation)
        previewAnimation = loopAnim
        previewAnimation.duration = mLoopAnimationDuration * 2

    }
    func setInAnimationDuration(_ duration : Float) {
        mInAnimationDuration = duration
        inAnimation.duration = mInAnimationDuration
        animation.set_In_Animation(animationInfo: inAnimation)

    }
    func setOutAnimationDuration(_ duration : Float) {
        mOutAnimationDuration = duration
        outAnimation.duration = mOutAnimationDuration
        animation.set_Out_Animation(animationInfo: outAnimation)

    }
    func setLoopAnimationDuration(_ duration : Float) {
        mLoopAnimationDuration = duration
        loopAnimation.duration = mLoopAnimationDuration
        animation.set_Loop_Animation(animationInfo: loopAnimation)

    }
    
    var inAnimation : AnimTemplateInfo = AnimTemplateInfo()
    var outAnimation : AnimTemplateInfo = AnimTemplateInfo()
    var loopAnimation : AnimTemplateInfo = AnimTemplateInfo()
    
    var mInAnimationDuration : Float = 1
    var mOutAnimationDuration : Float = 1
    var mLoopAnimationDuration : Float = 1

    
    func updateAnimation(time:Float) {

       
        var newResult = AnimationResult(result: false)
        let _ = animation.animate(result: &newResult, time: time, duration: mDuration, root: getRootBounds(), parent: getParentBounds(), selfInfo: getSelfBounds())
        
        let parameters = newResult.getParameters()
        var tempTransform = matrix_identity_float4x4
      
        parameters.getScale().applyTransformation(selfInfo: getSelfBounds(), parent: getParentBounds(), root: getRootBounds(), transformation: &tempTransform, logger: logger)
        parameters.getTranslation().applyTransformation(selfRect: getSelfBounds(), parent: getParentBounds(), root: getRootBounds(), transformation: &tempTransform,xBase: 0,yBase: 0, logger: logger)
    

        parameters.getSkew().applyTransformation(self: getSelfBounds(), parent: getParentBounds(), root: getRootBounds(), transformation: &tempTransform)
        parameters.getRotationX().applyTransformation(self: getSelfBounds(), parent: getParentBounds(), root: getRootBounds(), transformation: &tempTransform)
       parameters.getRotationY().applyTransformation(getSelfBounds(), getParentBounds(), getRootBounds(), &tempTransform)
        parameters.getRotationZ().applyTransformation(startAngle: zRotation, selfInfo: getSelfBounds(), parent: getParentBounds(), root: getRootBounds(), transformation: &tempTransform, logger: logger)
        
        let opacity = parameters.getAlpha().x
        
        logger?.printLog("animOpacity : \(opacity)")
//        setmOpacity(opacity: opacity) //0.1 + ( time * 0.1 )
        self.mOpacity *= opacity
//        self.opacity *= Double(opacity)
    //   tempTransform.multiplyBy(parentMatrix: modalConstant.modalMatrix)
        modalConstant.animatedMatrix =  tempTransform //tempTransform
    }
    var animation = AnimationHandler()

    func setmHue(value:Float){
        mHue = value
    }
    
    var opacity = 1.0;
   
    func setColor(color:float3) {
//
//        if pipelineType != .ColorRender {
//            switchTo(type: .ColorRender)
//        }
        
        if pipelineType != .ImageRender {
            DispatchQueue.main.sync {
                switchTo(type: .ImageRender)
            }
        }
        mcolor = color
        
    }
    func setGradientInfo(gradientInfo:GradientInfoMetal){
        if pipelineType != .ImageRender {
            switchTo(type: .ImageRender)
        }
        mgradientInfo = gradientInfo
    }
    
    var mCropRect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    var needToUpdateVertexBuffer = false
    var needToUpdateSize = false
//    var needToUpdateCenter
    
    func setCropRect(topLeft: float2, topRight: float2, bottomLeft: float2, bottomRight: float2){
//        mCropRect = CGRect.zero
        geometry.updateCropRect(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        needToUpdateVertexBuffer = true
    }
    

    func setmCenter(centerX:CGFloat , centerY : CGFloat) {
//        if let parent = parent {
//            let parentHeight =  Float(parent.size.height) - Float(self.center.y)
//            self.center = CGPoint(x: centerX, y: CGFloat(parentHeight))
//        }
        self.center = CGPoint(x: centerX, y: centerY)

    }
    
    func setMCropRect(cropRect:CGRect){
        mCropRect = cropRect
        setCropRect(topLeft: float2(Float(cropRect.minX),Float(cropRect.minY)), topRight: float2(Float(cropRect.maxX),Float(cropRect.minY)), bottomLeft: float2(Float(cropRect.minX),Float(cropRect.maxY)), bottomRight: float2(Float(cropRect.maxX),Float(cropRect.maxY)))
        if let geo = geometry as? QuadMesh {
            
        }
    }
    func setmOpacity(opacity: Float) {
        self.mOpacity = opacity
        self.opacity = Double(opacity)
    }
    func setLockStatus(lock:Bool){
        mLockStatus = lock
    }
    
    func setmZRotation(rotation: Float) {
        self.zRotation =  -Float(deg2rad(Double(rotation)))
    }
    
    func setmSize(width:CGFloat , height:CGFloat) {
        self.size = CGSize(width: width, height: height)
        if let geo = geometry as? QuadMesh {
            geo.setVertices(size: size)
        }
    }
    func setBlur(_ blur:Float){
        self.mblur = blur
    }
    func setOverlay(_ overlay:MTLTexture){
        self.mOverlayTexture = overlay
    }
    func setOverlayBlur(_ overlayBlur:Float){
        self.mOverlayBlur = overlayBlur
    }
    func setTileCount(count:Float){
        self.mTileCount = count
    }
    
    func preRenderCalculation() {
       // zRotation += 0.01
        if needToUpdateVertexBuffer {
//            if let geo = geometry as? QuadMesh {
//                geo.updateCropRect(topLeft: float2(Float(mCropRect.minX),Float(mCropRect.minY)), topRight: float2(Float(mCropRect.maxX),Float(mCropRect.minY)), bottomLeft: float2(Float(mCropRect.minX),Float(mCropRect.maxY)), bottomRight: float2(Float(mCropRect.maxX),Float(mCropRect.maxY)))
//            }
        }
//        if self is TextChild     {
//            setmSize(width: self.size.width + CGFloat(currentTime), height: self.size.height + CGFloat(currentTime))
//        }
        var matrix = model_matrix
        
        var parentProjectionMatrix = matrix_identity_float4x4
        var parentScale = float3()
        if let parent = parent {
            let calcSize =   CGSize(width: 1.0/parent.size.width, height: 1.0/parent.size.height)
            parentScale.x = Float(calcSize.width)
            parentScale.y = Float(calcSize.height)

        }else{
            let calcSize =  CGSize(width: 1.0/context.rootSize.width, height: 1.0/context.rootSize.height)
            parentScale.x = Float(calcSize.width)
            parentScale.y = Float(calcSize.height)
        }
        
        parentProjectionMatrix.scale(axis: parentScale)
        modalConstant.parentProjectionMatrix = parentProjectionMatrix
//        if id == 3463 {
//            matrix.scale(currentTime*0.1, y: currentTime*0.1, z: 1)
//        }
//        var matrix3 = matrix_identity_float4x4
//        matrix3.translate(direction: float3(50,0,0))
//        matrix.multiplyBy(parentMatrix: matrix3)
        
        modalConstant.modalMatrix = matrix
        modalConstant.animatedMatrix = matrix_identity_float4x4

//        if renderingMode == .Animating {
//            updateAnimation(time: currentTime)
//        }
        setmOpacity(opacity: Float(opacity))
        if canRender {
            
            if renderingMode == .Animating {
                
                updateAnimation(time:  currentTime - mStartTime )
               // updateAnimation(time:  currentTime.roundToDecimal(2) - mStartTime )
            } else if renderingMode == .SingleAnimation {
                
                if animPreviewMode != .None && isInPreviewAnimation {
                    
                    logger?.printLog("prevAnim: \(animCurrentTime) \(identification)")
                    updateAnimation(time: animCurrentTime )
                }
                
                // updateAnimation(time:  currentTime.roundToDecimal(2) - mStartTime )
                
            }
        
            
//            if renderingMode == .SingleAnimation {
//                
//                 updateAnimation(time:  currentTime.roundToDecimal(2) - mStartTime )
//
//            }
           // else
           // if renderingMode == .SingleAnimation {
            
//
//                    if animPreviewMode != .None && isInPreviewAnimation {
//                        
//                        printLog("prevAnim:",animCurrentTime )
//                        updateAnimation(time: animCurrentTime )
//                    }
//                    
//                   // updateAnimation(time:  currentTime.roundToDecimal(2) - mStartTime )
//
//                }
                
//                if animPreviewMode != .None {
//                    
//                    printLog("prevAnim:",animCurrentTime )
//                    updateAnimation(time: animCurrentTime )
//                }else  {
////                    if inAnimation.type == "none" && outAnimation.type == "none" && loopAnimation.type == "none" {
////                        
////                    }else {
////                        
////                        if id == 3461 {
////                            printLog("cTime:",currentTime.roundToDecimal(2),"startTime:",startTime , "acSt",mStartTime,currentTime.roundToDecimal(2) - mStartTime)
////                        }
//                      updateAnimation(time:  currentTime.roundToDecimal(2) - mStartTime )
////                    }
//                }
          //  }
        }
     
        
        
    }
    
    
    func setFragmentData(parentEncoder: MTLRenderCommandEncoder) {
            setDefaultFragmentData(parentEncoder: parentEncoder)
    }
    
     private func setDefaultFragmentData(parentEncoder: MTLRenderCommandEncoder) {
         var cTime = currentTime
        var dSize = float2(Float(context.drawableSize.width),Float(context.drawableSize.height))
         parentEncoder.bind(resolution: &dSize)
         parentEncoder.bind(timeForFragment: &cTime)
         parentEncoder.bind(opacity: &mOpacity)
         parentEncoder.bind(rotation: &zRotation)
    }
    func setVertexData(parentEncoder:MTLRenderCommandEncoder) {
//        var mvp : Float = 1.0
//        parentEncoder.bindMVPEnable(&mvp)
        parentEncoder.bind(geometry: geometry)
        parentEncoder.bind(modalConstants: &modalConstant)
        var cTime = currentTime
        parentEncoder.bind(timeForVertex: &cTime)
        parentEncoder.bind(flipTypeHorizontal: &mFlipType_hori)
        parentEncoder.bind(flipTypeVertical: &mFlipType_vert)
//        parentEncoder.bind(flipTypeVertical: &mFlipType_vert)
        var isParent : Float = self is MParent ? 1.0 : 0.0
        
        parentEncoder.bind(isParent: &isParent)
        

    }
    var mFlipType_hori : Float = 0
    var mFlipType_vert : Float = 0
    
    
    
    
    func getSelfBounds() -> AnimationRectInfo {
        let x = Float(center.x) - (Float(self.size.width/2))
        let y = Float(center.y) - (Float(self.size.height/2))

        let rect = AnimationRectInfo(x: x, y: y, width: Float(self.size.width), height: Float(self.size.height))
        return rect
    }
    
    func getParentBounds() -> AnimationRectInfo {
        
        var parentSize = context.rootSize
        if let parent = parent {
            parentSize = parent.size
        }
        let x = Float(center.x) - (Float(parentSize.width/2))
        let y = Float(center.y) - (Float(parentSize.height/2))
            
            let rect = AnimationRectInfo(x: x, y: y, width: Float(parentSize.width), height: Float(parentSize.height))
            return rect
        
       
        
    }
    func getRootBounds() -> AnimationRectInfo {
            
        return AnimationRectInfo(x: 0, y: 0, width: Float(context.rootSize.width), height: Float(context.rootSize.height))
    }

}


extension MTLRenderCommandEncoder {
    func bind(geometry: MeshGeometry) {
        self.setVertexBuffer(geometry.vertexBuffer, offset: 0, index: VERTEX_BUFFER_INDEX.GEOMTERY)
    }
//    func bindMVPEnable(_ float: inout Float) {
//        self.setVertexBytes(&float, length: Float.size, index: VERTEX_BUFFER_INDEX.ENABLE_MVP)
//    }
    
    func bind(modalConstants: inout ModalConstant) {
        self.setVertexBytes(&modalConstants, length: ModalConstant.stride, index: VERTEX_BUFFER_INDEX.MODAL_CONNSTANT)
    }
    
    func bind(isParent : inout Float) {
        self.setVertexBytes(&isParent, length: Float.size1, index: VERTEX_BUFFER_INDEX.ISPARENT)
    }
    
    func bind(timeForVertex time : inout Float) {
        self.setVertexBytes(&time, length: Float.size1, index: VERTEX_BUFFER_INDEX.TIME)
    }
    
    func bind(flipTypeVertical  : inout Float) {
        self.setVertexBytes(&flipTypeVertical, length: Float.stride, index: VERTEX_BUFFER_INDEX.FlIPTYPE_VERT)
    }
    func bind(rotation  : inout Float) {
        self.setVertexBytes(&rotation, length: Float.stride, index: VERTEX_BUFFER_INDEX.ROTATION)
    }
    func bind(flipTypeHorizontal  : inout Float) {
        self.setVertexBytes(&flipTypeHorizontal, length: Float.stride, index: VERTEX_BUFFER_INDEX.FlIPTYPE_HOR)
    }
    func bind(timeForFragment time : inout Float) {
        self.setFragmentBytes(&time, length: Float.stride, index: FRAGMENT_BUFFER_INDEX.TIME)
    }
    
    func bind(color: inout float3) {
        self.setFragmentBytes(&color, length: float3.stride, index: FRAGMENT_BUFFER_INDEX.COLOR)
    }
    
    func bind(resolution: inout float2) {
        self.setFragmentBytes(&resolution, length: float2.stride, index: FRAGMENT_BUFFER_INDEX.RESOLUTION)
    }
    
    func bind(opacity: inout Float) {
        self.setFragmentBytes(&opacity, length: Float.stride, index: FRAGMENT_BUFFER_INDEX.OPACITY)
    }
    
    func bind(texture:  MTLTexture) {
        self.setFragmentTexture(texture, index: FRAGMENT_BUFFER_INDEX.IMAGE)

    }
    
}


struct VERTEX_BUFFER_INDEX {
    static var GEOMTERY = 0
    static var TIME = 3
    static var ISPARENT = 5
    static var MODAL_CONNSTANT = 1
    static var FlIPTYPE_HOR = 2
    static var FlIPTYPE_VERT = 4
static var ROTATION = 5
    //static var ENABLE_MVP = 4

    
}


struct FRAGMENT_BUFFER_INDEX {
    static var SAMPLER_INDEX = 0
    static var TIME = 0
    static var IMAGE = 0
    static var RESOLUTION = 1
    static var OPACITY = 2
    static var COLOR = 3
    static var GRADINET_INFO = 4
    
}

extension CGSize {
    func normalise(refSize:CGSize) -> CGSize {
        return CGSize(width: self.width/refSize.width, height: self.height/refSize.height)
    }
}
