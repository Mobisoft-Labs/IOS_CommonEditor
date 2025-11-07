//
//  Texturable.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import Foundation
import MetalKit

protocol Texturable {
    //texxture
    var sourceTexture : MTLTexture! { get set}
    var destinationTexture: MTLTexture! { get set }
    var finaltexture: MTLTexture! {get set}
    var originalTexture : MTLTexture?{get set}
    //Adjustment
    func setTexture(texture:MTLTexture)
   
}

protocol Maskable {
    var maskTexture: MTLTexture? { get set }
    var hasMask : Bool {get set}
    var maskAdjustment : MaskAdjustment? {get set}
    func precomuteData(computeEncoder: MTLComputeCommandEncoder)
    func setmMaskShape(maskTexture: MTLTexture?, hasMask: Bool)
    func applyMaskIfNeeded(_ computeEncoder: MTLComputeCommandEncoder)

}

protocol Computable {
    func precomuteData(computeEncoder: MTLComputeCommandEncoder)
    func setmFilterType(filterType : FiltersEnum)
    func setmBrightnessIntensity(brightnessIntensity : Float)
    func setmContrastIntensity(contrastIntensity : Float)
    func setmHighlightsIntensity(highlightsIntensity : Float)
    func setmShadowsIntensity(shadowsIntensity : Float)
    func setmSaturationIntensity(saturationIntensity : Float)
    func setmVibranceIntensity(vibranceIntensity : Float)
    func setmSharpnessIntensity(sharpnessIntensity : Float)
    func setmWarmthIntensity(warmthIntensity : Float)
    func setmTintIntensity(tintIntensity : Float)
//    var adjustments : Adjustments? {get set}
    var blurAdjustment:BlurAdjustment?{get set}
    var overlayAdjustments : OverlayAdjustment? {get set}
    var canColorApply:Bool {get set}
    var sepiaFilter: SepiaFilter? {get set}
    var brightnessAdjustment: BrightnessAdjustment? {get set}
    var warmthAdjustment : WarmthAdjustment? {get set}
    var highlightAdjustment : HighlightsAdjustment?  {get set}
    var shadowsAdjustment : ShadowsAdjustment? {get set}
    var saturationAdjustment : SaturationAdjustment?  {get set}
    var vibranceAdjustment : VibranceAdjustment?  {get set}
    var sharpnessAdjustment : SharpnessAdjustment?  {get set}
    var tintAdjustment : TintAdjustment?  {get set}
    var contrastAdjustment : ContrastAdjustment? {get set}
    var mBrightnessIntensity : Float? {get set}
    var mContrastIntensity : Float? {get set}
    var mHighlightsIntensity : Float? {get set}
    var mShadowsIntensity : Float? {get set}
    var mSaturationIntensity : Float? {get set}
    var mVibranceIntensity : Float? {get set}
    var mSharpnessIntensity : Float? {get set}
    var mWarmthIntensity : Float? {get set}
    var mTintIntensity : Float? {get set}
    var mFilterType : FiltersEnum {get set}
    var blackNWhiteFilter: BlackAndWhiteFilter? {get set}
    var fasleColorFilter: FalseColorFilter? {get set}
    var monoChromeFilter : MonoChromeFilter? {get set}
    var sketchFilter: SketchFilter? {get set}
    var softEleganceFilter : SoftEleganceFilter? {get set}
    var massEtikateFilter: MassEtikateFilter? {get set}
    var polkadotFilter: PolkadotFilter? {get set}
}


class TexturableChild : MChild,Texturable,Computable,Maskable{
    var hasMask: Bool = false
    
    func setmMaskShape(maskTexture: MTLTexture?, hasMask: Bool) {
        self.hasMask = hasMask
        self.maskTexture = maskTexture
    
    }
    
    func applyMaskIfNeeded(_ computeEncoder:  MTLComputeCommandEncoder) {
        
        if !hasMask { return }
        
        guard let maskTexture = maskTexture , let maskAdjustment = maskAdjustment  else { return }
        maskAdjustment.setMaskTexture(maskTexture)
        maskAdjustment.encode(source: finaltexture, mask: maskTexture, destination: destinationTexture, in: computeEncoder)
        finaltexture = destinationTexture
//        sourceTexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)

       
        
//        let image1 = Conversion.textureToUIImage(maskTexture)
//        let image2 = Conversion.textureToUIImage(sourceTexture)
//        let image3 = Conversion.textureToUIImage(finaltexture)

        if !hasMask { return }
    }
    
    var maskTexture:  MTLTexture?
    
    var maskAdjustment: MaskAdjustment?
    
   
    
    var highlightAdjustment: HighlightsAdjustment?
    
    var shadowsAdjustment: ShadowsAdjustment?
    
    var contrastAdjustment: ContrastAdjustment?
    
    var saturationAdjustment: SaturationAdjustment?
    
    var vibranceAdjustment: VibranceAdjustment?
    
    var sharpnessAdjustment: SharpnessAdjustment?
    
    var tintAdjustment: TintAdjustment?
    
    var blackNWhiteFilter: BlackAndWhiteFilter?
    
    var fasleColorFilter: FalseColorFilter?
    
    var monoChromeFilter: MonoChromeFilter?
    
    var sketchFilter: SketchFilter?
    
    var softEleganceFilter: SoftEleganceFilter?
    
    var massEtikateFilter: MassEtikateFilter?
    
    var polkadotFilter: PolkadotFilter?
    
    func setmBrightnessIntensity(brightnessIntensity: Float) {
        mBrightnessIntensity = brightnessIntensity
    }
    
    func setmContrastIntensity(contrastIntensity: Float) {
        mContrastIntensity = contrastIntensity
    }
    
    func setmHighlightsIntensity(highlightsIntensity: Float) {
        mHighlightsIntensity = highlightsIntensity
    }
    
    func setmShadowsIntensity(shadowsIntensity: Float) {
        mShadowsIntensity = shadowsIntensity
    }
    
    func setmSaturationIntensity(saturationIntensity: Float) {
        mSaturationIntensity = saturationIntensity
    }
    
    func setmVibranceIntensity(vibranceIntensity: Float) {
        mVibranceIntensity = vibranceIntensity
    }
    
    func setmSharpnessIntensity(sharpnessIntensity: Float) {
        mSharpnessIntensity = sharpnessIntensity
    }
    
    func setmWarmthIntensity(warmthIntensity: Float) {
        mWarmthIntensity = warmthIntensity
    }
    
    func setmTintIntensity(tintIntensity: Float) {
        mTintIntensity = tintIntensity
    }
    
    func setmFilterType(filterType: FiltersEnum) {
        mFilterType = filterType
    }
    
    func setAdjustmentIntensity(brightnessIntensity : Float , contrastIntensity : Float, highlightsIntensity : Float, shadowsIntensity : Float,
                                saturationIntensity : Float, vibranceIntensity : Float, sharpnessIntensity : Float, warmthIntensity : Float,
                                tintIntensity : Float){
        if brightnessIntensity != 0 {
            mBrightnessIntensity = brightnessIntensity
        }
        
        if contrastIntensity != 0 {
            mContrastIntensity = contrastIntensity
        }
        
        if highlightsIntensity != 0 {
            mHighlightsIntensity = highlightsIntensity
        }
        
        if shadowsIntensity != 0 {
            mShadowsIntensity = shadowsIntensity
        }
        
        if saturationIntensity != 0 {
            mSaturationIntensity = saturationIntensity
        }
        
        if vibranceIntensity != 0 {
            mVibranceIntensity = vibranceIntensity
        }
        
        if warmthIntensity != 0 {
            mWarmthIntensity = warmthIntensity
        }
        
        if tintIntensity != 0 {
            mTintIntensity = tintIntensity
        }
        
        if sharpnessIntensity != 0 {
            mSharpnessIntensity = sharpnessIntensity
        }
        
    }
    
    var mContrastIntensity:Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mHighlightsIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mShadowsIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mSaturationIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mVibranceIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mSharpnessIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mWarmthIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mTintIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mFilterType: FiltersEnum = .none{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var mBrightnessIntensity: Float?{
        didSet{
          _use_cached_texture = false
        }
    }
    
    var brightnessAdjustment: BrightnessAdjustment?
    
    var warmthAdjustment : WarmthAdjustment?
    
    var sepiaFilter: SepiaFilter?
    
    var blackNWhite : BlackAndWhiteFilter?
    
    var falseColor : FalseColorFilter?
    
    var originalTexture:  MTLTexture?
    
    var canColorApply: Bool = false
    var colorFilterOnImage:ColorFilterOnImage?
    var sourceTexture: MTLTexture!
    var destinationTexture: MTLTexture!
 //   var finalTexture: MTLTexture!
    var overlayAdjustments: OverlayAdjustment?
    var colorAdjustment: ColorAdjustment?
    var samplerState: MTLSamplerState!
    var blurAdjustment:BlurAdjustment?
    var tileAdjustment:TileAdjustment?
    var gradientAdjustment:GradientAdjustment?
    var hueAdjustment:HueAdjustment?
    var circleCropAdjustment:CircleCropAdjustments?
//    var adjustments : Adjustments?
    var textureManager = TextureManager(device: MetalDefaults.GPUDevice)
    //var sampleDescriptor: MTLSamplerDescriptor!
    var textureDescriptorOffline: MTLTextureDescriptor!
    
    override var context: MContext{
        
        willSet {
            if context.drawableSize != newValue.drawableSize {
                if mContentType == 0.0 || mContentType == 1.0 || mContentType == 8.0 {
                    let size = getProportionalSize(currentSize: size, newSize: newValue.drawableSize)

                    createEmptyTexture(size: size)
                }
            }
        }
        didSet{
            
           
        }
    }
    var tileTexture : MTLTexture? {
        didSet{
          _use_cached_texture = false
        }
    }
    
    func setTileTexture(texture:MTLTexture) {
        tileTexture = texture
        if pipelineType != .ImageRender {
            switchTo(type: .ImageRender)
        }
        
//        if canColorApply{
//            colorAdjustment = try! Adjustments(library: ShaderLibrary.DefaultLibrary)
//
//        }
//        adjustments = try? Adjustments(library: ShaderLibrary.DefaultLibrary)
//        blurAdjustment = try? BlurAdjustment(library: ShaderLibrary.DefaultLibrary)
//        hueAdjustment = try? HueAdjustment(library: ShaderLibrary.DefaultLibrary)
//        circleCropAdjustment = try? CircleCropAdjustments(library: ShaderLibrary.DefaultLibrary)
//        gradientAdjustment = try? GradientAdjustment(library: ShaderLibrary.DefaultLibrary)
//        tileAdjustment = try? TileAdjustment(library: ShaderLibrary.DefaultLibrary)
//        overlayAdjustments = try? OverlayAdjustment(library: ShaderLibrary.DefaultLibrary)
//       // self.sourceTexture = texture
//        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        
    //    createEmptyTexture(size: context.drawableSize)
    }
    
    func setTexture(texture: MTLTexture) {
        
        let cropWidth = CGFloat(texture.width)
        let cropHeight = CGFloat(texture.height)
        let aspectRatio = CGSize(width: cropWidth, height: cropHeight)
        
        if cropWidth/cropHeight != size.width/size.height{
            let newSize = getProportionalSize(currentRatio: aspectRatio, oldSize: size)
            
            if newSize != size {
//                print("NEEDED ASPECT CALC")
                setmSize(width: newSize.width, height: newSize.height)
            }
            
            
        }
        if pipelineType != .ImageRender {
            switchTo(type: .ImageRender)
        }
        
//        if canColorApply{
//            colorAdjustment = try! Adjustments(library: ShaderLibrary.DefaultLibrary)
//            
//        }
        // Initialize the SepiaFilter
        sepiaFilter = try? SepiaFilter(library: shaderLibrary.DefaultLibrary)
        blackNWhiteFilter = try? BlackAndWhiteFilter(library: shaderLibrary.DefaultLibrary)
        falseColor =  try? FalseColorFilter(library: shaderLibrary.DefaultLibrary)
        monoChromeFilter =  try? MonoChromeFilter(library: shaderLibrary.DefaultLibrary)
        sketchFilter =  try? SketchFilter(library: shaderLibrary.DefaultLibrary)
        softEleganceFilter =  try? SoftEleganceFilter(library: shaderLibrary.DefaultLibrary)
        massEtikateFilter =  try? MassEtikateFilter(library: shaderLibrary.DefaultLibrary)
        polkadotFilter = try? PolkadotFilter(library: shaderLibrary.DefaultLibrary)
        brightnessAdjustment = try? BrightnessAdjustment(library: shaderLibrary.DefaultLibrary)
        warmthAdjustment = try? WarmthAdjustment(library: shaderLibrary.DefaultLibrary)
        contrastAdjustment = try? ContrastAdjustment(library: shaderLibrary.DefaultLibrary)
        highlightAdjustment = try? HighlightsAdjustment(library: shaderLibrary.DefaultLibrary)
        shadowsAdjustment = try? ShadowsAdjustment(library: shaderLibrary.DefaultLibrary)
        saturationAdjustment = try? SaturationAdjustment(library: shaderLibrary.DefaultLibrary)
        vibranceAdjustment = try? VibranceAdjustment(library: shaderLibrary.DefaultLibrary)
        sharpnessAdjustment = try? SharpnessAdjustment(library: shaderLibrary.DefaultLibrary)
        tintAdjustment = try? TintAdjustment(library: shaderLibrary.DefaultLibrary)
//        adjustments = try? Adjustments(library: shaderLibrary.DefaultLibrary)
        blurAdjustment = try? BlurAdjustment(library: shaderLibrary.DefaultLibrary)
        hueAdjustment = try? HueAdjustment(library: shaderLibrary.DefaultLibrary)
        circleCropAdjustment = try? CircleCropAdjustments(library: shaderLibrary.DefaultLibrary)
        gradientAdjustment = try? GradientAdjustment(library: shaderLibrary.DefaultLibrary)
        tileAdjustment = try? TileAdjustment(library: shaderLibrary.DefaultLibrary)
        overlayAdjustments = try? OverlayAdjustment(library: shaderLibrary.DefaultLibrary)
        
        
        maskAdjustment = try? MaskAdjustment(library: shaderLibrary.DefaultLibrary)
        
        self.sourceTexture = texture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func setBGTexture(texture: MTLTexture) {
        
        let cropWidth = CGFloat(texture.width)
        let cropHeight = CGFloat(texture.height)
        let aspectRatio = CGSize(width: cropWidth, height: cropHeight)
        let newSize = getProportionalBGSize(currentRatio: aspectRatio, oldSize: size)
        // get ratioSize
//       /* let image:UIImage = UIImage(named: text*/ure) ?? <#default value#>
        //                                        ratioSize = image.size
        let aspectratio = CGSize(width: texture.width, height: texture.height)
//        let siz =  getProportionalBGSize(currentRatio: refSize, oldSize: refSize )
        let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: size)
        
        if newSize != size {
            print("NEEDED ASPECT CALC")
            setmSize(width: newSize.width, height: newSize.height)
        }
        
        
        if pipelineType != .ImageRender {
            switchTo(type: .ImageRender)
        }
        
//        if canColorApply{
//            colorAdjustment = try! Adjustments(library: shaderLibrary.DefaultLibrary)
//
//        }
        // Initialize the SepiaFilter
        sepiaFilter = try? SepiaFilter(library: shaderLibrary.DefaultLibrary)
        brightnessAdjustment = try? BrightnessAdjustment(library: shaderLibrary.DefaultLibrary)
        warmthAdjustment = try? WarmthAdjustment(library: shaderLibrary.DefaultLibrary)
        contrastAdjustment = try? ContrastAdjustment(library: shaderLibrary.DefaultLibrary)
        highlightAdjustment = try? HighlightsAdjustment(library: shaderLibrary.DefaultLibrary)
        shadowsAdjustment = try? ShadowsAdjustment(library: shaderLibrary.DefaultLibrary)
        saturationAdjustment = try? SaturationAdjustment(library: shaderLibrary.DefaultLibrary)
        vibranceAdjustment = try? VibranceAdjustment(library: shaderLibrary.DefaultLibrary)
        sharpnessAdjustment = try? SharpnessAdjustment(library: shaderLibrary.DefaultLibrary)
        tintAdjustment = try? TintAdjustment(library: shaderLibrary.DefaultLibrary)
//        adjustments = try? Adjustments(library: shaderLibrary.DefaultLibrary)
        blurAdjustment = try? BlurAdjustment(library: shaderLibrary.DefaultLibrary)
        hueAdjustment = try? HueAdjustment(library: shaderLibrary.DefaultLibrary)
        circleCropAdjustment = try? CircleCropAdjustments(library: shaderLibrary.DefaultLibrary)
        gradientAdjustment = try? GradientAdjustment(library: shaderLibrary.DefaultLibrary)
        tileAdjustment = try? TileAdjustment(library: shaderLibrary.DefaultLibrary)
        overlayAdjustments = try? OverlayAdjustment(library: shaderLibrary.DefaultLibrary)
        maskAdjustment = try? MaskAdjustment(library: shaderLibrary.DefaultLibrary)

        self.sourceTexture = texture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func setEmptyTexture(){
        if pipelineType != .ImageRender {
            switchTo(type: .ImageRender)
        }
        self.sourceTexture = originalTexture
        self.finaltexture = sourceTexture
        destinationTexture = try? textureManager.matchingTexture(to: sourceTexture)
        // Initialize the SepiaFilter
        sepiaFilter = try? SepiaFilter(library: shaderLibrary.DefaultLibrary)
        blackNWhiteFilter = try? BlackAndWhiteFilter(library: shaderLibrary.DefaultLibrary)
        falseColor =  try? FalseColorFilter(library: shaderLibrary.DefaultLibrary)
        monoChromeFilter =  try? MonoChromeFilter(library: shaderLibrary.DefaultLibrary)
        sketchFilter =  try? SketchFilter(library: shaderLibrary.DefaultLibrary)
        softEleganceFilter =  try? SoftEleganceFilter(library: shaderLibrary.DefaultLibrary)
        massEtikateFilter =  try? MassEtikateFilter(library: shaderLibrary.DefaultLibrary)
        brightnessAdjustment = try? BrightnessAdjustment(library: shaderLibrary.DefaultLibrary)
        warmthAdjustment = try? WarmthAdjustment(library: shaderLibrary.DefaultLibrary)
        contrastAdjustment = try? ContrastAdjustment(library: shaderLibrary.DefaultLibrary)
        highlightAdjustment = try? HighlightsAdjustment(library: shaderLibrary.DefaultLibrary)
        shadowsAdjustment = try? ShadowsAdjustment(library: shaderLibrary.DefaultLibrary)
        saturationAdjustment = try? SaturationAdjustment(library: shaderLibrary.DefaultLibrary)
        vibranceAdjustment = try? VibranceAdjustment(library: shaderLibrary.DefaultLibrary)
        sharpnessAdjustment = try? SharpnessAdjustment(library: shaderLibrary.DefaultLibrary)
        tintAdjustment = try? TintAdjustment(library: shaderLibrary.DefaultLibrary)
        blurAdjustment = try? BlurAdjustment(library: shaderLibrary.DefaultLibrary)
        hueAdjustment = try? HueAdjustment(library: shaderLibrary.DefaultLibrary)
        circleCropAdjustment = try? CircleCropAdjustments(library: shaderLibrary.DefaultLibrary)
        gradientAdjustment = try? GradientAdjustment(library: shaderLibrary.DefaultLibrary)
        tileAdjustment = try? TileAdjustment(library: shaderLibrary.DefaultLibrary)
        overlayAdjustments = try? OverlayAdjustment(library: shaderLibrary.DefaultLibrary)
        maskAdjustment = try? MaskAdjustment(library: shaderLibrary.DefaultLibrary)

    }
    func createEmptyTexture(size:CGSize) {
        if pipelineType != .ImageRender {
            switchTo(type: .ImageRender)
        }
//        colorAdjustment = try? ColorAdjustment(library: shaderLibrary.DefaultLibrary)
//            sampleDescriptor = MTLSamplerDescriptor()
//            sampleDescriptor.minFilter = .linear
//            sampleDescriptor.magFilter = .linear
//            samplerState = MetalDefaults.GPUDevice.makeSamplerState(descriptor: sampleDescriptor)
            
            textureDescriptorOffline = MTLTextureDescriptor()
            textureDescriptorOffline.textureType = .type2D
        textureDescriptorOffline.width = Int((size.width))
        textureDescriptorOffline.height = Int((size.height))
            textureDescriptorOffline.pixelFormat = MetalDefaults.MainPixelFormat
        textureDescriptorOffline.usage = [.renderTarget,.shaderRead,.shaderWrite,.renderTarget]
        originalTexture = MetalDefaults.GPUDevice.makeTexture(descriptor: textureDescriptorOffline)
        self.sourceTexture = originalTexture
        self.finaltexture = sourceTexture
        destinationTexture = try? textureManager.matchingTexture(to: sourceTexture)
        // Initialize the SepiaFilter
        sepiaFilter = try? SepiaFilter(library: shaderLibrary.DefaultLibrary)
        blackNWhiteFilter = try? BlackAndWhiteFilter(library: shaderLibrary.DefaultLibrary)
        falseColor =  try? FalseColorFilter(library: shaderLibrary.DefaultLibrary)
        monoChromeFilter =  try? MonoChromeFilter(library: shaderLibrary.DefaultLibrary)
        sketchFilter =  try? SketchFilter(library: shaderLibrary.DefaultLibrary)
        softEleganceFilter =  try? SoftEleganceFilter(library: shaderLibrary.DefaultLibrary)
        massEtikateFilter =  try? MassEtikateFilter(library: shaderLibrary.DefaultLibrary)
        brightnessAdjustment = try? BrightnessAdjustment(library: shaderLibrary.DefaultLibrary)
        warmthAdjustment = try? WarmthAdjustment(library: shaderLibrary.DefaultLibrary)
        contrastAdjustment = try? ContrastAdjustment(library: shaderLibrary.DefaultLibrary)
        highlightAdjustment = try? HighlightsAdjustment(library: shaderLibrary.DefaultLibrary)
        shadowsAdjustment = try? ShadowsAdjustment(library: shaderLibrary.DefaultLibrary)
        saturationAdjustment = try? SaturationAdjustment(library: shaderLibrary.DefaultLibrary)
        vibranceAdjustment = try? VibranceAdjustment(library: shaderLibrary.DefaultLibrary)
        sharpnessAdjustment = try? SharpnessAdjustment(library: shaderLibrary.DefaultLibrary)
        tintAdjustment = try? TintAdjustment(library: shaderLibrary.DefaultLibrary)
        blurAdjustment = try? BlurAdjustment(library: shaderLibrary.DefaultLibrary)
        hueAdjustment = try? HueAdjustment(library: shaderLibrary.DefaultLibrary)
        circleCropAdjustment = try? CircleCropAdjustments(library: shaderLibrary.DefaultLibrary)
        gradientAdjustment = try? GradientAdjustment(library: shaderLibrary.DefaultLibrary)
        tileAdjustment = try? TileAdjustment(library: shaderLibrary.DefaultLibrary)
        overlayAdjustments = try? OverlayAdjustment(library: shaderLibrary.DefaultLibrary)
        maskAdjustment = try? MaskAdjustment(library: shaderLibrary.DefaultLibrary)

     
    }


    

    
    override func setFragmentData(parentEncoder: MTLRenderCommandEncoder) {
        
        super.setFragmentData(parentEncoder: parentEncoder)
        
        if pipelineType == .ImageRender {
            if let texture = finaltexture {
                parentEncoder.bind(texture: finaltexture)
            } else {
                logger?.logError("Texture Not Found")
            }
         //  let image = Conversion.textureToUIImage(finaltexture)
         //   let img = Conversion.textureToUIImage(sourceTexture)
           // print(image?.size)
           // print(img?.size)
        } else if pipelineType == .ColorRender {
            parentEncoder.bind(color: &mcolor)
        }
    
      
    }
    
    var finaltexture : MTLTexture!
    func precomuteData(computeEncoder: MTLComputeCommandEncoder) {
        if !canRender { return ;}
        _use_cached_texture = false
        if _use_cached_texture{
            finaltexture = sourceTexture
            // return final texture
        }else{
            finaltexture = sourceTexture
            // empty texture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
            
           
            if mContentType == 0.0  {
           
                colorShaderIfNeeded(computeEncoder)
            }
            else if mContentType == 1.0 || mContentType == 8.0{
             
                gradientShaderIfNeeded(computeEncoder)
            }
//            overlayAdjustments?.overlayOpacity = mOverlayBlur
            else{
                if mStickerType == 2.0{
                    //                if canColorApply {
                    colorFilterOnImageIfNeeded(computeEncoder)
                    //                }
                }else if mStickerType == 1.0{
                    hueShaderIfNeeded(computeEncoder)
                }
            }
            
            if mCropStyle == 2{
                // circleCropIfNeeded()
                circleCropIfNeeded(computeEncoder)
           }
          
           // tileShaderIfNeeded(computeEncoder)

            
            if mContentType == 2 || mContentType == 8.0{
                blurShaderIfNeeded(computeEncoder)
            }
          
            applyMaskIfNeeded(computeEncoder)
            overlayShaderIfNeeded(computeEncoder)
            setFilter(computeEncoder)
            setAdjustment(computeEncoder)
            _use_cached_texture = false
        }
        

  
            
     
        
    }
    
    
    func gradientShaderIfNeeded(_ computeEncoder:MTLComputeCommandEncoder){
        guard let mgradientInfo = mgradientInfo else { return }
        if gradientAdjustment == nil{
            createEmptyTexture(size: size)
            gradientAdjustment = try? GradientAdjustment(library: shaderLibrary.DefaultLibrary)
        }
        
        gradientAdjustment?.gradientType = mgradientInfo.gradientType
        gradientAdjustment?.endColor = mgradientInfo.endColor
        gradientAdjustment?.startColor = mgradientInfo.startColor
        gradientAdjustment?.radius = mgradientInfo.radius
        gradientAdjustment?.angleInDegree = mgradientInfo.angleInDegree
        gradientAdjustment?.tileTexture = tileTexture
        gradientAdjustment?.tileFrequency = mTileCount
        gradientAdjustment?.contentType = mContentType

//        destinationTexture = try? textureManager.matchingTexture(to: sourceTexture)
        gradientAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
        finaltexture = destinationTexture
//        sourceTexture = destinationTexture
       
        destinationTexture = try? textureManager.matchingTexture(to: sourceTexture)
    }
    
    func colorShaderIfNeeded( _ computeEncoder:MTLComputeCommandEncoder){
        
        if colorAdjustment == nil{
          
            colorAdjustment = try? ColorAdjustment(library: shaderLibrary.DefaultLibrary)
        }
        
        colorAdjustment?.color = mcolor
        colorAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func blurShaderIfNeeded(_ computeEncoder:MTLComputeCommandEncoder){
        blurAdjustment?.blur = mblur
        if mblur > 0.0{
            blurAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    func overlayShaderIfNeeded(_ computeEncoder:MTLComputeCommandEncoder){
        if mOverlayTexture != nil{
        overlayAdjustments?.overlayOpacity = mOverlayBlur
            overlayAdjustments?.encode(input1: finaltexture, input2: mOverlayTexture!, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
   
    func tileShaderIfNeeded(_ computeEncoder:MTLComputeCommandEncoder){
        
//        setTileTexture(<#T##(any MTLTexture)?#>, index: <#T##Int#>)
//        setTileCount(count: 2)
        if tileTexture != nil{
            tileAdjustment?.tileImageTexture = tileTexture
            tileAdjustment?.tile = mTileCount
            if  mTileCount >= 1{
                tileAdjustment?.encode(source: sourceTexture, destination: destinationTexture, in: computeEncoder)
                finaltexture = destinationTexture
                sourceTexture = destinationTexture
                destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
            }
        }
    }
    
    func hueShaderIfNeeded(_ computeEncoder:MTLComputeCommandEncoder){
        hueAdjustment?.hue = mHue
        hueAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func circleCropIfNeeded(_ computeEncoder:MTLComputeCommandEncoder){
        circleCropAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func colorFilterOnImageIfNeeded( _ computeEncoder:MTLComputeCommandEncoder){
        
        if colorFilterOnImage == nil{

            colorFilterOnImage = try? ColorFilterOnImage(library: shaderLibrary.DefaultLibrary)
        }
        colorFilterOnImage?.color = mcolor
        colorFilterOnImage?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    // Adjust texture processing dynamically based on the state
    func applySepiaIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let sepiaFilter = sepiaFilter else { return }

        // Enable or disable the filter based on the logic
        sepiaFilter.enabled = true

        if sepiaFilter.enabled {
            sepiaFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    // Adjust texture processing dynamically based on the state
    func applyBlackNWhiteIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let blackNWhiteFilter = blackNWhiteFilter else { return }

        // Enable or disable the filter based on the logic
        blackNWhiteFilter.enabled = true

        if blackNWhiteFilter.enabled {
            blackNWhiteFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    // Adjust texture processing dynamically based on the state
    func applyFalseColorIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let falseColorFilter = falseColor else { return }

        // Enable or disable the filter based on the logic
        falseColorFilter.enabled = true

        if falseColorFilter.enabled {
            falseColorFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    // Adjust texture processing dynamically based on the state
    func applyMonoChromeIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let monoChromeFilter = monoChromeFilter else { return }

        // Enable or disable the filter based on the logic
        monoChromeFilter.enabled = true

        if monoChromeFilter.enabled {
            monoChromeFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    // Adjust texture processing dynamically based on the state
    func applySketchIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let sketchFilter = sketchFilter else { return }

        // Enable or disable the filter based on the logic
        sketchFilter.enabled = true

        if sketchFilter.enabled {
            sketchFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    // Adjust texture processing dynamically based on the state
    func applySoftEleganceIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let softEleganceFilter = softEleganceFilter else { return }

        // Enable or disable the filter based on the logic
        softEleganceFilter.enabled = true

        if softEleganceFilter.enabled {
            softEleganceFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    // Adjust texture processing dynamically based on the state
    func applyMassEtikateIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let massEtikateFilter = massEtikateFilter else { return }

        // Enable or disable the filter based on the logic
        massEtikateFilter.enabled = true

        if massEtikateFilter.enabled {
            massEtikateFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    
    // Adjust texture processing dynamically based on the state
    func applyPolkadotIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        guard let polkadotFilter = polkadotFilter else { return }

        // Enable or disable the filter based on the logic
        polkadotFilter.enabled = true

        if polkadotFilter.enabled {
            polkadotFilter.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)
            finaltexture = destinationTexture
            destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
        }
    }
    
    func warmthShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the warmth intensity and encode the shader
        warmthAdjustment?.warmthIntensity = mWarmthIntensity! // Adjust the warmth value as needed
        warmthAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
       // destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func brightnessShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        brightnessAdjustment?.brightnessIntensity = mBrightnessIntensity!
        brightnessAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    
    func contrastShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        contrastAdjustment?.contrastIntensity = mContrastIntensity!
        contrastAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }

    func highlightShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        highlightAdjustment?.highlightIntensity = mHighlightsIntensity!
        highlightAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func shadowsShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        shadowsAdjustment?.shadowIntensity = mShadowsIntensity!
        shadowsAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func saturationShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        saturationAdjustment?.saturationIntensity = mSaturationIntensity!
        saturationAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func vibranceShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        vibranceAdjustment?.vibranceIntensity = mVibranceIntensity!
        vibranceAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func sharpnessShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        sharpnessAdjustment?.sharpnessIntensity = mSharpnessIntensity!
        sharpnessAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    func tintShaderIfNeeded(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the brightness intensity and encode the shader
        tintAdjustment?.tintIntensity = mTintIntensity!
        tintAdjustment?.encode(source: finaltexture, destination: destinationTexture, in: computeEncoder)

        // Swap textures for the next processing step
        finaltexture = destinationTexture
        destinationTexture = try! textureManager.matchingTexture(to: sourceTexture)
    }
    
    
    
    func setFilter(_ computeEncoder: MTLComputeCommandEncoder) {
        // Set the filter alertnatively using the switch case.
        switch mFilterType {
            
        case .none:
            break 
        case .blackNWhite:
            applyBlackNWhiteIfNeeded(computeEncoder)
        case .sepia:
            applySepiaIfNeeded(computeEncoder)
        case .falseColor:
            applyFalseColorIfNeeded(computeEncoder)
        case .monoChrome:
            applyMonoChromeIfNeeded(computeEncoder)
        case .sketch:
            applySketchIfNeeded(computeEncoder)
        case .softElegance:
            applySoftEleganceIfNeeded(computeEncoder)
        case .massEtikate:
            applyMassEtikateIfNeeded(computeEncoder)
        case .poolkadot:
            applyPolkadotIfNeeded(computeEncoder)
        }
    }
    
    
    func setAdjustment(_ computeEncoder: MTLComputeCommandEncoder) {
        // Put the value of every time of adjustment one by one.
        
        // Put Brightness
        if mBrightnessIntensity != nil{
            brightnessShaderIfNeeded(computeEncoder)
        }
        
        // Put Contrast
        if mContrastIntensity != nil{
            contrastShaderIfNeeded(computeEncoder)
        }
        
        // Put Highlights
        if mHighlightsIntensity != nil{
            highlightShaderIfNeeded(computeEncoder)
        }
        
        // Put Shadows
        if mShadowsIntensity != nil{
            shadowsShaderIfNeeded(computeEncoder)
        }
        
        // Put Saturation
        if mSaturationIntensity != nil{
            saturationShaderIfNeeded(computeEncoder)
        }
        
        // Put Vibrance
        if mVibranceIntensity != nil{
            vibranceShaderIfNeeded(computeEncoder)
        }
        
        // Put Sharpness
        if mSharpnessIntensity != nil{
            sharpnessShaderIfNeeded(computeEncoder)
        }
        
        // Put Warmth
        if mWarmthIntensity != nil{
            warmthShaderIfNeeded(computeEncoder)
        }
        
        // Put Tint
        if mTintIntensity != nil{
            tintShaderIfNeeded(computeEncoder)
        }
        
    }
}
