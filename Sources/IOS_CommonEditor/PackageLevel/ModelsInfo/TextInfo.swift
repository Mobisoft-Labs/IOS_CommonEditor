//
//  TextInfo.swift
//  MetalEngine
//
//  Created by HKBeast on 25/07/23.
//

import Foundation
import UIKit
import Combine

public enum ShadowType{
    case direction
    case opacity
    case color
}

public enum BGPanelType{
    case color
    case opacity
}

public struct TextModelChanged{
    var oldText : String
    var newText : String
    var oldSize : CGSize
    var newSize : CGSize
}

public class TextInfo:BaseModel,TextModelProtocol{
    
    func getCopy() -> TextInfo{
        var textInfo = TextInfo()
        
        textInfo.textId = self.textId
        textInfo.text = self.text
        textInfo.fontName = self.fontName
        textInfo.textFont = self.textFont
        textInfo.textType = self.textType
        textInfo.textColor = self.textColor
        textInfo.textGravity = self.textGravity
        textInfo.lineSpacing = self.lineSpacing
        textInfo.letterSpacing = self.letterSpacing
        textInfo.shadowColor = self.shadowColor
        textInfo.shadowOpacity = self.shadowOpacity
        textInfo.shadowRadius = self.shadowRadius
        textInfo.shadowDx = self.shadowDx
        textInfo.shadowDy = self.shadowDy
        textInfo.bgType = self.bgType
        textInfo.bgDrawable = self.bgDrawable
        textInfo.bgColor = self.bgColor
        textInfo.bgAlpha = self.bgAlpha
        textInfo.internalWidthMargin = self.internalWidthMargin
        textInfo.internalHeightMargin = self.internalHeightMargin
        textInfo.xRotationProg = self.xRotationProg
        textInfo.yRotationProg = self.yRotationProg
        textInfo.zRotationProg = self.zRotationProg
        textInfo.curveProg = self.curveProg
        
        
        textInfo.xRotationProg = self.xRotationProg
        textInfo.yRotationProg = self.yRotationProg
        textInfo.zRotationProg = self.zRotationProg
        textInfo.baseFrame = self.baseFrame
        textInfo.baseTimeline = self.baseTimeline
        textInfo.modelType = self.modelType
        textInfo.modelFlipHorizontal = self.modelFlipHorizontal
        textInfo.modelFlipVertical = self.modelFlipVertical
        textInfo.orderInParent = self.orderInParent
        textInfo.prevAvailableWidth = self.prevAvailableWidth
        textInfo.prevAvailableHeight = self.prevAvailableHeight
        textInfo.beginHighlightIntensity = self.beginHighlightIntensity
        textInfo.beginOpacity = self.beginOpacity
        textInfo.filterType = self.filterType
        textInfo.lockStatus = self.lockStatus
        textInfo.parentId = self.parentId
        textInfo.templateID = self.templateID
        textInfo.bgBlurProgress = self.bgBlurProgress
        textInfo.brightnessIntensity = self.brightnessIntensity
        textInfo.colorAdjustmentType = self.colorAdjustmentType
        textInfo.contrastIntensity = self.contrastIntensity
        textInfo.highlightIntensity = self.highlightIntensity
        textInfo.inAnimation = self.inAnimation
        textInfo.outAnimation = self.outAnimation
        textInfo.loopAnimation = self.loopAnimation
        textInfo.modelOpacity = self.modelOpacity
        textInfo.saturationIntensity = self.saturationIntensity
        textInfo.shadowsIntensity = self.shadowsIntensity
        textInfo.sharpnessIntensity = self.sharpnessIntensity
        textInfo.softDelete = self.softDelete
        textInfo.thumbImage = self.thumbImage
        textInfo.tintIntensity = self.tintIntensity
        textInfo.warmthIntensity = self.warmthIntensity
        textInfo.vibranceIntensity = self.vibranceIntensity
        textInfo.hasMask = self.hasMask
        textInfo.maskShape = self.maskShape
        textInfo.dataId = self.dataId
        textInfo.depthLevel = self.depthLevel
        textInfo.center = self.center
        textInfo.duration = self.duration
        textInfo.height = self.height
        textInfo.identity = self.identity
        textInfo.inAnimationDuration = self.inAnimationDuration
        textInfo.outAnimationDuration = self.outAnimationDuration
        textInfo.loopAnimationDuration = self.loopAnimationDuration
        textInfo.isHidden = self.isHidden
        textInfo.isActive = self.isActive
        textInfo.isSelectedForMultiSelect = self.isSelectedForMultiSelect
        textInfo.overlayOpacity = self.overlayOpacity
        textInfo.overlayDataId  = self.overlayDataId
        textInfo.posX = self.posX
        textInfo.posY =  self.posY
        textInfo.rotation = self.rotation
        textInfo.width = self.width
        textInfo.startTime = self.startTime
        textInfo.size = self.size
        return textInfo
    }
    
    
     init() {
        super.init()
         
        identity = "Text"
    }
    
    var typeCase : TypeCase = .Original
    
    // Text Spacing
    @Published public var beginLetterSpacing: Float = 0
    @Published public var endLetterSpacing: Float = 0
    @Published public var beginLineSpacing: Float = 0
    @Published public var endLineSpacing: Float = 0
    
//    // Text Shadow
    @Published public var beginDx: Float = 0
    @Published public var beginDy: Float = 0
    @Published public var endDx: Float = 0
    @Published public var endDy: Float = 0
    @Published public var beginShadowOpacity: Float = 0
    @Published public var endShadowOpacity: Float = 0
    
    // Text BG Aplha
    @Published public var beginBGAlpha: Float = 1
    @Published public var endBGAlpha: Float = 1
    
    // Text
    @Published var oldText: String = ""
    @Published var newText: String = ""
    
    // Text BG Color
    @Published public var beginTextBGContent: AnyBGContent?
    @Published public var endTextBGContent: AnyBGContent?
    
    //Text Color
    @Published public var beginTextContentColor: AnyBGContent?
    @Published public var endTextContentColor: AnyBGContent?

     var fontSize : CGFloat = 17
    
    //override the model type.
    override public var modelType: ContentType {
            get { return .Text }
            set { }
        }
    
    //text Model
    var textId: Int = 0
    @Published public var fontName: String = "defaultfont.ttf"  //UIFont.systemFont(ofSize: 17).fontName
    @Published public var text: String = "Enter the text."
    @Published public var textType: String = ""
    @Published public var textFont: UIFont =  .systemFont(ofSize: 14)
    @Published  var textColor: UIColor = .black
    @Published public var textGravity: HTextGravity = .Center
    @Published public var lineSpacing: Float = 1.0
    @Published public var letterSpacing: Float = 0.0
    @Published var shadowColor: UIColor = .white
    @Published var shadowOpacity: Float = 255
    @Published public var shadowRadius: Float = 0.0
    @Published public var shadowDx: Float = 0.0
    @Published public var shadowDy: Float = 0.0
    @Published public var bgType: Int = 0
    @Published  var bgDrawable: String = ""
    @Published var bgColor: UIColor = .clear
    @Published public var bgAlpha: Float = 0
    @Published var internalWidthMargin: Float = 5.0
    @Published var internalHeightMargin: Float = 5.0
    @Published var xRotationProg: Int = 0
    @Published var yRotationProg: Int = 0
    @Published var zRotationProg: Int = 0
    @Published var curveProg: Int = 0
    @Published var lastUpdatedSize:CGSize = .zero
    
    @Published public var textBGContent:AnyBGContent?
    @Published public var textContentColo:AnyBGContent?
    
    @Published public var textShadowColorFilter:AnyColorFilter?
    @Published public var beginTextShadowColorFilter:AnyColorFilter?
    @Published public var endTextShadowColorFilter:AnyColorFilter?
    @Published public var textModelChnaged : TextModelChanged?
    
    var originalText : String = ""
    var fieldValues : [String: String] = [:]
    
    func setPersonaliseTextValues(originalText:String) {
        self.originalText = originalText
    }
    
    func registerValue(templateValue: String, userValue: String) {
        fieldValues[templateValue] = userValue
        }
    
    
    func getFormattedText(templateValue: String, userValue: String) -> String {
      
        
            fieldValues[templateValue] = userValue
            var result = originalText
            for (key, value) in fieldValues {
                result = result.replacingOccurrences(of: key, with: value, options: [.caseInsensitive], range: nil)
            }
            return result
    }
    
    
    func setBaseModel(baseModel:DBBaseModel,refSize: CGSize){
      
        modelId = baseModel.modelId
        parentId = baseModel.parentId
        modelType = ContentType(rawValue: baseModel.modelType) ?? .Text
        dataId = baseModel.dataId
        posX = (baseModel.posX).toFloat() * Float(refSize.width)
        posY = (baseModel.posY).toFloat() * Float(refSize.height)
        width = (baseModel.width).toFloat() * Float(refSize.width)
        height = (baseModel.height).toFloat() * Float(refSize.height)
        prevAvailableWidth = width
        prevAvailableHeight = height
        rotation = (baseModel.rotation).toFloat()
        modelOpacity = (baseModel.modelOpacity).toFloat() / 255
        modelFlipHorizontal = baseModel.modelFlipHorizontal.toBool()
        modelFlipVertical = baseModel.modelFlipVertical.toBool()
        lockStatus = baseModel.lockStatus.toBool()
        orderInParent = baseModel.orderInParent
        bgBlurProgress = baseModel.bgBlurProgress.toFloat()
        overlayDataId = baseModel.overlayDataId
        overlayOpacity = baseModel.overlayOpacity.toFloat()
        startTime = (baseModel.startTime).toFloat()
        duration = (baseModel.duration).toFloat()
        softDelete = baseModel.softDelete.toBool()
        isHidden = baseModel.isHidden
        templateID = baseModel.templateID
        baseFrame = Frame(size: CGSize(width: Double(baseModel.width * Double(refSize.width)), height: Double(baseModel.height * Double(refSize.height))), center: CGPoint(x: Double(baseModel.posX * Double(refSize.width)), y: Double(baseModel.posY * Double(refSize.height))), rotation: self.rotation)
        baseTimeline = StartDuration(startTime: (baseModel.startTime).toFloat(), duration: (baseModel.duration).toFloat())
        
        //Changes for filter done by NK.
        filterType = getFilter(filterNumber: baseModel.filterType)
        brightnessIntensity = baseModel.brightnessIntensity
        contrastIntensity = baseModel.contrastIntensity
        highlightIntensity = baseModel.highlightIntensity
        shadowsIntensity = baseModel.shadowsIntensity
        saturationIntensity = baseModel.saturationIntensity
        vibranceIntensity = baseModel.vibranceIntensity
        sharpnessIntensity = baseModel.sharpnessIntensity
        warmthIntensity = baseModel.warmthIntensity
        tintIntensity = baseModel.tintIntensity
        
        hasMask = baseModel.hasMask.toBool()
        maskShape = baseModel.maskShape
    }
    


    func setTextModel(textModel: DBTextModel, engineConfig: EngineConfiguration?) {
           textId = textModel.textId
        text = textModel.text.fixBulletEncoding()
        textFont = UIFont(name: FontDM.getRealFont(nameOfFont: textModel.textFont, engineConfig: engineConfig) , size: fontSize) ?? .systemFont(ofSize: 14)
        textColor =  textModel.textColor.convertIOSColorStringToUIColor()
        textGravity = HTextGravity(rawValue:  textModel.textGravity) ?? .Center
        lineSpacing = (textModel.lineSpacing).toFloat()
        letterSpacing = (textModel.letterSpacing).toFloat()
        shadowColor = textModel.shadowColor.convertIOSColorStringToUIColor()
        shadowOpacity = textModel.shadowOpacity.toFloat()
        shadowRadius = (textModel.shadowRadius).toFloat()
        shadowDx = (textModel.shadowDx).toFloat()
        shadowDy = (textModel.shadowDy).toFloat()
           bgType = textModel.bgType
           bgDrawable = textModel.bgDrawable
        bgColor = textModel.bgColor.convertIOSColorStringToUIColor()
        bgAlpha = textModel.bgAlpha.toFloat()/255
        internalWidthMargin = (textModel.internalWidthMargin).toFloat()
        internalHeightMargin = (textModel.internalHeightMargin).toFloat()
           xRotationProg = textModel.xRotationProg
           yRotationProg = textModel.yRotationProg
           zRotationProg = textModel.zRotationProg
           curveProg = textModel.curveProg
         templateID = textModel.templateID
        fontName = textModel.textFont
        textType = textModel.textType
        beginShadowOpacity = Float(textModel.shadowOpacity / 255)
        beginTextContentColor = BGColor(bgColor: textModel.textColor.convertIOSColorStringToUIColor())
        if bgType == 2{
            textBGContent = BGColor(bgColor: textModel.bgColor)
            beginTextBGContent = BGColor(bgColor: textModel.bgColor)
        }
        else{
            bgType = 0
            textBGContent = BGColor(bgColor: UIColor.clear)
            beginTextBGContent = BGColor(bgColor: UIColor.clear)
        }
       
       }
  
    func getBaseModel(refSize:CGSize) -> DBBaseModel {
           return DBBaseModel(
            filterType: filterType.rawValue,
            brightnessIntensity: brightnessIntensity,
            contrastIntensity: contrastIntensity,
            highlightIntensity: highlightIntensity,
            shadowsIntensity: shadowsIntensity,
            saturationIntensity: saturationIntensity,
            vibranceIntensity: vibranceIntensity,
            sharpnessIntensity: sharpnessIntensity,
            warmthIntensity: warmthIntensity,
            tintIntensity: tintIntensity,
            hasMask: hasMask.toInt(), maskShape: maskShape, parentId: parentId,
            modelId: modelId,
            modelType: modelType.rawValue,
            dataId: dataId,
            posX: (baseFrame.center.x).toDouble()/refSize.width,
            posY: (baseFrame.center.y).toDouble()/refSize.height,
            width: (baseFrame.size.width).toDouble()/refSize.width,
            height: (baseFrame.size.height).toDouble()/refSize.height,
            prevAvailableWidth: (prevAvailableWidth).toDouble()/refSize.width,
            prevAvailableHeight: (prevAvailableHeight).toDouble()/refSize.height,
            rotation: (baseFrame.rotation).toDouble(),
            modelOpacity: (modelOpacity).toDouble() * 255,
            modelFlipHorizontal: modelFlipHorizontal.toInt(),
            modelFlipVertical: modelFlipVertical.toInt(),
            lockStatus: lockStatus.toString(),
            orderInParent: orderInParent,
            bgBlurProgress: bgBlurProgress.toInt(),
            overlayDataId: overlayDataId,
            overlayOpacity: overlayOpacity.toInt(),
            startTime: (baseTimeline.startTime).toDouble(),
            duration: (baseTimeline.duration).toDouble(),
            //               startTime: (startTime).toDouble(),
            //               duration: (duration).toDouble(),
            softDelete: softDelete.toInt(),
            isHidden: isHidden,
            templateID: templateID
           )
       }

       func getTextModel() -> DBTextModel {
           return DBTextModel(
               textId: textId,
               text: text,
               textFont: fontName/*textFont.fontName*/,
               textType: textType,
               textColor: textColor.toUIntString(),
               textGravity: textGravity.rawValue,
               lineSpacing: (lineSpacing).toDouble(),
               letterSpacing: (letterSpacing).toDouble(),
               shadowColor: shadowColor.toUIntString(),
               shadowOpacity: shadowOpacity.toInt(),
               shadowRadius: (shadowRadius).toDouble(),
               shadowDx: (shadowDx).toDouble(),
               shadowDy: (shadowDy).toDouble(),
               bgType: bgType,
               bgDrawable: bgDrawable,
               bgColor: bgColor.toUIntString(),
               bgAlpha: bgAlpha.toDouble() * 255,
               internalWidthMargin: (internalWidthMargin).toDouble(),
               internalHeightMargin: (internalHeightMargin).toDouble(),
               xRotationProg: xRotationProg,
               yRotationProg: yRotationProg,
               zRotationProg: zRotationProg,
               curveProg: curveProg,
               templateID: templateID
           )
       }
   
   

  
    
    var attrib: [NSAttributedString.Key: Any] {
        // Initialize attributes dictionary
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        // Set font and text color
        let font = textFont
            attributes[.font] = font
        
        attributes[.foregroundColor] = textColor
        
        // Add kerning (letter spacing)
         //let font = textFont
            let letterSpacing = self.letterSpacing * Float(fontSize)
            attributes[.kern] = NSNumber(value: letterSpacing)
        
        
        // Set line spacing and alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(Int(self.lineSpacing))
        paragraphStyle.alignment = textGravity.alignmentOfText() // Change to desired alignment
        attributes[.paragraphStyle] = paragraphStyle
        
        // Apply text curve logic (example: circular arc)
      //  if let font = textFont {
            var circularArcTransform = CGAffineTransform(rotationAngle: 0) // Adjust angle as needed
            let curvedFont = CTFontCreateCopyWithAttributes(font, CGFloat(self.fontSize), &circularArcTransform, nil)
            attributes[.font] = curvedFont
       // }
        
        // Add shadow attributes
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.green
        shadow.shadowOffset = CGSize(width: CGFloat(shadowDx), height: CGFloat(shadowDy))
        shadow.shadowBlurRadius = CGFloat(shadowRadius)
        attributes[.shadow] = shadow
        
        return attributes
    }

    override func addDefaultModel(parentModel: any BaseModelProtocol, baseModel: BaseModel) {
        baseModel.modelType = .Text
        super.addDefaultModel(parentModel: parentModel, baseModel: baseModel)
    }

}

func createTransparentImage(size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
    let format = UIGraphicsImageRendererFormat.default()
    format.scale = scale
    format.opaque = false

    let renderer = UIGraphicsImageRenderer(size: size, format: format)
    let image = renderer.image { _ in
        // No drawing → transparent by default
    }

    return image
}

extension TextInfo {
    /// Neeshu Use this method
    func createImage(thumbUpdate : Bool = false , keepSameFont:Bool = false , text:String,properties:TextProperties,refSize:CGSize,maxWidth: CGFloat,maxHeight:CGFloat, contentScaleFactor : CGFloat, logger: PackageLogger?) -> UIImage?{
        let userLanguage = Locale.userLanguageIdentifier
        
        if refSize.width == 0.0 || refSize.height == 0.0 {
            logger?.logErrorFirebaseWithBacktrace("[preAvailbaleSize changes] Text RefSize Zero \(text) , returning Empty Image")
            return createTransparentImage(size: CGSize(width: 10 , height: 10))
        }

        if refSize.width < 0.0 || refSize.height < 0.0 {
            logger?.logErrorFirebaseWithBacktrace("[preAvailbaleSize changes] Text RefSize Negative \(refSize) for text: \(text)")
            return createTransparentImage(size: CGSize(width: 10 , height: 10))
        }
        
        if text.isEmpty {
            logger?.logError("Text Is Empty , Returning Empty Image")
            return  createTransparentImage(size: CGSize(width: 10 , height: 10))
        }
        
        let newScaledWidth = refSize.width * contentScaleFactor
        let newScaledHeight = refSize.height * contentScaleFactor
        let scaledRefSize = CGSize(width: newScaledWidth, height: newScaledHeight)
        logger?.logInfo("Create Text Image Info Started : user language -> \(userLanguage), original Text -> \(text), ref width -> \(refSize.width), ref height -> \(refSize.height)")
       let values =  drawTextAsImage(keepFontSizeFix: keepSameFont, text: text, boundingBox: CGRect(origin: .zero, size: scaledRefSize), textProperties: properties, logger: logger)
        let image = values!.0!
        if !thumbUpdate{
            fontSize = values!.1
        }

        return image

    }
    
    
    var textProperty : TextProperties {
       
        return   TextProperties(fontName: textFont.fontName, forgroundColor: textColor, backgroundColor: bgColor,bgAlpha: bgAlpha,bgType: Float(bgType),  textColor: textColor, letterSpacing: letterSpacing, lineSpacing: lineSpacing, textGravity: textGravity, fontSize: fontSize, shadowColor: shadowColor, shadowDx: shadowDx, shadowDy: shadowDy, shadowRadius: shadowRadius, typeCase: typeCase,externalWidthMargin: CGFloat(internalWidthMargin) , externalHeightMargin: CGFloat(internalHeightMargin))

    }
    
    /// this one is deprecated
    func createImage(text: String? = nil, fontName: String = "Helvetica",
                     textColor: UIColor = .black,
                     textGravity: HTextGravity = .Center,
                     lineSpacing: Float = 0,
                     letterSpacing: Float = 1,
                     shadowColor: UIColor = .clear,
                     shadowOpacity: Int? = nil,
                     shadowRadius: Float? = nil,
                     shadowDx: Float? = nil,
                     shadowDy: Float? = nil,
                     bgColor: UIColor? = nil,
                     bgAlpha: Float? = nil,
                     internalWidthMargin: Float? = nil,
                     internalHeightMargin: Float? = nil,
                     xRotationProg: Int? = nil,
                     yRotationProg: Int? = nil,
                     zRotationProg: Int? = nil,
                     curveProg: Int? = nil,keepSameFont:Bool = false) -> UIImage? {
        
        
        
        // Define the maximum size of the text
        let maxTextSize = CGSize(width: CGFloat(self.width), height: CGFloat(self.height))
        var font = UIFont(name: fontName, size: fontSize)

        let attribute =  text?.createAttributes(textProperties: textProperty)//createAttributes(font: font,textColor: textColor,letterSpacing: letterSpacing, lineSpacing: lineSpacing, textGravity: textGravity, fontSize: fontSize, shadowColor: shadowColor, shadowDx: shadowDx,shadowDy: shadowDy,shadowRadius: shadowRadius)
        // Find the best font size for the given text and constraints
        if !keepSameFont{
             let returnInfo = findBestFontSizeForText(text: self.text, fontName: self.textFont.fontName, targetSize: maxTextSize, minFontSize: 1, maxFontSize: 1000)
                let fitSize = returnInfo.1
                fontSize = returnInfo.0
                self.lastUpdatedSize = fitSize
            
        }
         font = UIFont(name: fontName, size: fontSize)

        // Calculate the aspect size to maintain aspect ratio
        let aspectSize = getProportionalSize(currentSize: lastUpdatedSize, newSize: CGSize(width: CGFloat(self.width), height:  CGFloat(self.height)))
        
        // Create a rectangle with the specified width and height
        let rectSize = maxTextSize
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(rectSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Fill the background with the provided background color
        
        if bgColor != nil{
            self.bgType = 2
        }
        var BGcolor = bgColor?.cgColor ?? self.bgColor.cgColor
        if bgType == 2 {
           
            if  let colors = BGcolor.copy(alpha: CGFloat((bgAlpha ?? self.bgAlpha))) {
                context.setFillColor(colors)
            }
        }else{
            context.setFillColor(UIColor.clear.cgColor)
        }
        
        context.fill(CGRect(origin: .zero, size: rectSize))
        
        // Flip the context
        context.translateBy(x: 0, y: rectSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Calculate the position and size of the text within the rectangle
        let textRect = CGRect(x: rectSize.width/2 - lastUpdatedSize.width/2, y: rectSize.height/2 - lastUpdatedSize.height/2, width: lastUpdatedSize.width, height: lastUpdatedSize.height)
        
        
        text?.createAttributes(textProperties: textProperty)
//        createAttributes(font: font,textColor: textColor,letterSpacing: letterSpacing, lineSpacing: lineSpacing, textGravity: textGravity, fontSize: fontSize, shadowColor: shadowColor, shadowDx: shadowDx,shadowDy: shadowDy,shadowRadius: shadowRadius)
        
        // Create attributed string with the provided text and attributes
        let attributedString = NSAttributedString(string: text ?? self.text, attributes:text?.createAttributes(textProperties: textProperty))
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        
        // Create a path for the text
        let path = UIBezierPath(rect: textRect)
        
        // Create a frame and draw the text
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path.cgPath, nil)
        CTFrameDraw(frame, context)
        
        // Get the image from the current context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    func findBestFontSizeForText(text: String,
                                 fontName: String,
                                 targetSize: CGSize,
                                 minFontSize: CGFloat,
                                 maxFontSize: CGFloat,
                                 textColor: UIColor? = nil,
                                 letterSpacing: Float? = nil,
                                 lineSpacing: Float? = nil,
                                 textGravity: HTextGravity? = nil,
                                 fontSize: CGFloat? = nil,
                                 shadowColor: UIColor? = nil,
                                 shadowDx: Float? = nil,
                                 shadowDy: Float? = nil,
                                 shadowRadius: Float? = nil, isFixedFont:Bool = false) -> (CGFloat, CGSize) {
        var bestFontSize = minFontSize
        var lowerBound = minFontSize
        var upperBound = maxFontSize
        var bestFitSize = CGSize.zero
        
        var mAttributes = text.createAttributes(textProperties: textProperty)/*createAttributes(textColor: textColor, letterSpacing: letterSpacing, lineSpacing: lineSpacing, textGravity: textGravity, fontSize: fontSize, shadowColor: shadowColor, shadowDx: shadowDx, shadowDy: shadowDy, shadowRadius: shadowRadius)*/
        
        while lowerBound <= upperBound {
            let fontSize = (lowerBound + upperBound) / 2.0
            
            let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
            
            mAttributes[.font] = font
            self.fontSize = fontSize
//            createAttributes(textColor: textColor, letterSpacing: letterSpacing, lineSpacing: lineSpacing, textGravity: textGravity, fontSize: fontSize, shadowColor: shadowColor, shadowDx: shadowDx, shadowDy: shadowDy, shadowRadius: shadowRadius)
            
            let attributedText = NSAttributedString(string: text, attributes: text.createAttributes(textProperties: textProperty))
            let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
            
            // Calculate the constrained frame size for multiline text
            let sizeConstraints = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attributedText.length), nil, sizeConstraints, nil)
            
            let widthMargin = targetSize.width * (CGFloat(internalWidthMargin)/100)
            let heightMargin = targetSize.height * (CGFloat(internalHeightMargin)/100)
            if suggestedSize.width <= targetSize.width-widthMargin && suggestedSize.height <= targetSize.height-heightMargin  {
                bestFontSize = fontSize
                bestFitSize = suggestedSize
                lowerBound = fontSize + 1
            } else {
                upperBound = fontSize - 1
            }
        }
        
        return (bestFontSize, bestFitSize)
    }
    
    

}





// Helper extension to convert hex color string to UIColor
extension UIColor {
    public convenience init?(hexString: String) {
        let scanner = Scanner(string: hexString)
        var hexValue: UInt64 = 0

        if scanner.scanHexInt64(&hexValue) {
            let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(hexValue & 0x0000FF) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            return nil
        }
    }
    func intValue() -> UInt {
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
        }
        
        let r: UInt = UInt(red * 255)
        let g: UInt = UInt(green * 255)
        let b: UInt = UInt(blue * 255)
        let a: UInt = UInt(alpha * 255)
        
        let Color: UInt = (r << 16) | (g << 8) | (b) | (a << 24)
        
        return Color
        
    }
}



extension String {
    func hexToUIColor() -> UIColor? {
        var hexSanitized = self.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard hexSanitized.count == 6 else {
            return nil
        }

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: 1.0)
    }
}




/*
 
 Background Info
 Overlay Info
 Missing Enums
 
 
 
 
 
 */
extension TextInfo{
//    func createImage1() -> UIImage? {
//        let maxTextSize = CGSize(width: Double(self.width), height: Double(self.height))
//        
//        let returnInfo = findBestFontSizeForText(text: text, fontName: textFont.fontName, targetSize: maxTextSize, minFontSize: 1, maxFontSize: 1000, attribut: <#[NSAttributedString.Key : Any]#>)
//        var fitSize = returnInfo.1
//        // var fontSize: CGFloat = returnInfo.0
//        fontSize = returnInfo.0
//        
//        //        let textRect = CGRect(x: 0, y: 0, width: fitSize.width, height: fitSize.height)
//        //        let font = CTFontCreateWithName("Helvetica" as CFString, fontSize, nil)
//        //
//        //        var attributes: [NSAttributedString.Key: Any] = [
//        //            .font: font,
//        //            .foregroundColor: UIColor(hexString: self.textColor) ?? UIColor.black,
//        //            // Add other attributes as needed
//        //        ]
//        
//        // Adding padding to the text size
//        let padding: CGFloat = 10.0
//        //              fitSize.width += padding * 2
//        //              fitSize.height += padding * 2
//        
//        let attributedString = NSAttributedString(string: self.text, attributes: attrib)
//        var framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
//        
//        let aspectSize = getProportionalSize(currentSize: fitSize, newSize: CGSize(width: CGFloat(self.width), height:  CGFloat(self.width)))
//        let textRect = CGRect(x: aspectSize.width/2 - fitSize.width/2, y: aspectSize.height/2 - fitSize.height/2, width: fitSize.width, height: fitSize.height)
//        
//        UIGraphicsBeginImageContextWithOptions(aspectSize, false, 0.0)
//        let context = UIGraphicsGetCurrentContext()
//        var BGcolor = bgColor.cgColor
//        BGcolor.copy(alpha: CGFloat(bgAlpha))
//        context?.setFillColor(BGcolor)
//        context?.fill([CGRect(origin: .zero, size: aspectSize)])
//        context?.translateBy(x: 0, y: aspectSize.height)
//        context?.scaleBy(x: 1.0, y: -1.0)
//        
//        
//        let path = UIBezierPath(rect: textRect)
//        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path.cgPath, nil)
//        
//        CTFrameDraw(frame, context!)
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return image
//    }
//    

//    func createAttributes(font: UIFont? = nil,
//                          textColor: UIColor? = nil,
//                          letterSpacing: Float? = nil,
//                          lineSpacing: Float? = nil,
//                          textGravity: HTextGravity? = nil,
//                          fontSize: CGFloat? = nil,
//                          shadowColor: UIColor? = nil,
//                          shadowDx: Float? = nil,
//                          shadowDy: Float? = nil,
//                          shadowRadius: Float? = nil) -> [NSAttributedString.Key: Any] {
//        
//        // Initialize attributes dictionary
//        var attributes: [NSAttributedString.Key: Any] = [:]
//        
//        // Set font if provided, otherwise use the default textFont
//        let font = font ?? self.textFont
//            attributes[.font] = font
//        
//        
//        // Set text color if provided
//      
//            attributes[.foregroundColor] = textColor ?? self.textColor
//        
//        
//        // Add kerning (letter spacing) if provided
//     
//            let actualFontSize = fontSize ?? self.fontSize
//        let kernValue = (letterSpacing ?? self.letterSpacing) * Float(actualFontSize)
//        printLog("selected kern value",kernValue)
//            attributes[.kern] = NSNumber(value: kernValue)
//        
//        
//        // Set line spacing and alignment if provided
// 
//            let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = CGFloat(lineSpacing ?? self.lineSpacing)
//           
//            paragraphStyle.alignment = textGravity?.alignmentOfText() ?? self.textGravity.alignmentOfText()// Change to desired alignment
//            
//            attributes[.paragraphStyle] = paragraphStyle
//        
//        
//        // Apply text curve logic (example: circular arc) if provided
//         let fontL = font ?? textFont
//        let fontSize = fontSize ?? self.fontSize
//            var circularArcTransform = CGAffineTransform(rotationAngle: 0) // Adjust angle as needed
//            let curvedFont = CTFontCreateCopyWithAttributes(fontL, fontSize, &circularArcTransform, nil)
//            attributes[.font] = curvedFont
//        
//        
//        // Add shadow attributes if provided
////         let shadowColor = shadowColor
//            let shadow = NSShadow()
//        shadow.shadowColor = shadowColor ?? self.shadowColor
//        shadow.shadowOffset = CGSize(width: CGFloat(shadowDx ?? self.shadowDx), height: CGFloat(shadowDy ?? self.shadowDy))
//        shadow.shadowBlurRadius = CGFloat(shadowRadius ?? self.shadowRadius)
//            attributes[.shadow] = shadow
//        
//        
//        return attributes
//    }

 
}

//extension TextInfo{
//    func fontForRect(text: String,
//                     font: UIFont,
//                     width: CGFloat,
//                     height: CGFloat,
//                     textColor: UIColor? = nil,
//                     letterSpacing: Float? = nil,
//                     lineSpacing: Float? = nil,
//                     textGravity: HTextGravity? = nil,
//                     shadowColor: UIColor? = nil,
//                     shadowOpacity: Int? = nil,
//                     shadowRadius: Float? = nil,
//                     shadowDx: Float? = nil,
//                     shadowDy: Float? = nil) -> (CGFloat, CGSize)? {
//        
//        var fontSize = font.pointSize
//        var textAttributes: [NSAttributedString.Key: Any] = [
//            .font: font,
//            .foregroundColor: textColor ?? UIColor.black
//        ]
//        
//        // Adjust the font size to fit the text within the given width and height
//        while true {
//            // Create an attributed string with the current font size
//            let attributedText = NSAttributedString(string: text, attributes: textAttributes)
//            
//            // Create a text container with the specified width and height
//            let textContainer = NSTextContainer(size: CGSize(width: width, height: height))
//            textContainer.lineBreakMode = .byWordWrapping
//            textContainer.maximumNumberOfLines = 0
//            
//            // Create a layout manager and add the text container
//            let layoutManager = NSLayoutManager()
//            layoutManager.addTextContainer(textContainer)
//            
//            // Create a text storage and add the attributed string
//            let textStorage = NSTextStorage(attributedString: attributedText)
//            textStorage.addLayoutManager(layoutManager)
//            
//            // Calculate the bounding rect for the text
//            let boundingRect = layoutManager.usedRect(for: textContainer)
//            
//            // Check if the text fits within the width and height
//            if boundingRect.width <= width && boundingRect.height <= height {
//                return (fontSize, boundingRect.size)
//            } else {
//                // Reduce the font size and try again
//                fontSize -= 1
//                if fontSize <= 0 {
//                    // Font size cannot be further reduced
//                    return nil
//                }
//                // Update the font size in the text attributes
//                textAttributes[.font] = UIFont(descriptor: font.fontDescriptor, size: fontSize)
//            }
//        }
//    }

//}


//extension TextInfo{
    /*
     func getFontSize()->Size {
     
     get given width = self.width
     given height = self.height
     
     for given for and attribute
     for every word in array
     create text container with font and get width
     
     check if that width of text is less than given width
     then add next word in that line with space and check again if their total width is less then given width
     so on
     if total width > given width then try add word in new line and check also if both line and line spacing width is less then total height else reduce font size
     untill then all word is fit in width and height
     
     
     
     
     
     }
     */
    
//    func getFontSize(for text: String, withFont font: UIFont, maxWidth: CGFloat, maxHeight: CGFloat, lineSpacing: CGFloat) -> CGFloat {
//        var currentFontSize: CGFloat = font.pointSize
//        var currentHeight: CGFloat = 0
//        
//        // Split the text into words
//        let words = text.components(separatedBy: .whitespacesAndNewlines)
//        
//        // Initialize text container and attributes
//        let textContainer = NSTextContainer(size: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        var attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
//        
//        // Loop through each word
//        for word in words {
//            // Create attributed string with current font size and word
//            let attributedString = NSAttributedString(string: word, attributes: attributes)
//            
//            // Create layout manager and add text container
//            let layoutManager = NSLayoutManager()
//            layoutManager.addTextContainer(textContainer)
//            
//            // Add attributed string to text storage
//            let textStorage = NSTextStorage(attributedString: attributedString)
//            textStorage.addLayoutManager(layoutManager)
//            
//            // Calculate size required for text
//            let size = layoutManager.usedRect(for: textContainer).size
//            
//            // Check if text fits within the given width
//            if size.width <= maxWidth {
//                // Check if text fits within the given height
//                if currentHeight + size.height <= maxHeight {
//                    // Increment height
//                    currentHeight += size.height
//                } else {
//                    // Reduce font size until text fits within the given height
//                    currentFontSize -= 1
//                    break
//                }
//            } else {
//                // Reduce font size until text fits within the given width
//                currentFontSize -= 1
//            }
//            
//            // Update font size in attributes
//            let updatedFont = font.withSize(currentFontSize)
//            attributes[.font] = updatedFont
//        }
//        
//        return currentFontSize
//    }

//}



// step 1
// listing all changes of action state or publisher in excel
// add input and output what change in engine
// name of actions and publisher


// step 2
/*
 editorvcVM action state
 
 
 4. Add Sticker, Text,Page,Parent,Image
 Delete Above
 Copy ABove
 Paste Above
 
 
 */

//extension TextInfo{
//   
//}



/*
   
   create parent
   get size and update parentINfo
   get center and update parentInfo
   
   DB Insert
   DB Fetch
    parentInfo()
   // templateHander.addModel(parentInfo)
   
   for each selected Item {
       // parent Id chagne
      // order in parent change
      // center change
      // no need for size change
   
   // DB. update(Size,Center,ParentID,ORderID)
   
   eachChild.removeFromSuperview()
   parentInfo.addChild(eachChild)
   
   ViewManager.removeChild(id)

   SceneManager.remvoeChild(id)
// currentParent.children(remove)
   
   }
   
   ViewManager.createPArent(parentINfo)
   SceneManager.addMParent(parentInfo)
   
  NewParentID
   OldParentID
 
 
 ActionModel{
 oldParentID
 newParentID
 oldInt with sequence
 newInt with sequence
 
 }
 
 func newParentID, [Int:sequence]{
 
 get model from newParentID
 
 add child in ParentInfo
 
 for each selected Item {
     // parent Id chagne
    // order in parent change with corresponding order
 
    // center change
    // no need for size change
 
 // DB. update(Size,Center,ParentID,ORderID)
 
 eachChild.removeFromSuperview()
 parentInfo.addChild(eachChild)
 
 ViewManager.removeChild(id)

 SceneManager.remvoeChild(id)
// currentParent.children(remove)
 if oldParent is Parent then soft delete will be true

 
 }
 
 
 
 
 
   
   */


    
extension String {
    func fixBulletEncoding() -> String {
        return self.replacingOccurrences(of: "â€¢", with: "•")
            .replacingOccurrences(of: "â¢", with: "•") // some servers use this variant
    }
}
    
