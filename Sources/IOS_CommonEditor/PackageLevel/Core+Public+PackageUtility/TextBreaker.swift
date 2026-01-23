//
//  TextBreaker.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 29/05/24.
//

import Foundation
import UIKit
import CoreText

enum TypeCase : String {
    case LowerCase = "SmallCase"
    case UpperCase = "UpperCase"
    case Original = "Original"
    case TitleCase = "TileCase"

    
}

public enum HTextGravity: String {
    case Left = "LEFT"
    case Right = "RIGHT"
    case Center = "CENTER"
    
    func alignmentOfText() -> NSTextAlignment {
        switch self {
        case .Left:
            return .left
        case .Right:
            return .right
        case .Center:
            return .center
        }
    }
}


struct TextProperties : Equatable {
    var fontName : String
    var forgroundColor : UIColor = .red
    var backgroundColor : UIColor = .purple
    var bgAlpha : Float = 0.0
    var bgType : Float = 0.0
    var textColor: UIColor = .red
    var letterSpacing: Float = 0
    var lineSpacing: Float = 0
    var textGravity: HTextGravity = .Center
    var fontSize: CGFloat = 17
    var shadowColor: UIColor = .green
    var shadowDx: Float = 0.0
    var shadowDy: Float = 0.0
    var shadowRadius: Float = 0.0
    var typeCase : TypeCase = .Original
    var externalWidthMargin : CGFloat = 0
    var externalHeightMargin : CGFloat = 0
   
    
    
}


extension CGFloat {
    func percentage(perc: CGFloat) -> CGFloat {
        return perc * ( self / 100)
    }
}

extension String {
    
        func toCamelCase() -> String {
            // Split the string into words using space, underscores, and hyphens as delimiters
            let words = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
            
            // Convert the first word to lowercase, and capitalize the first letter of each subsequent word
            let camelCaseString = words.enumerated().map { index, word in
                if index == 0 {
                    return word.lowercased()
                } else {
                    return word.capitalized
                }
            }.joined()
            
            return camelCaseString
        }
    
    
    func applyTypeCase(typeCase:TypeCase) -> String {
        let transformedText: String
            switch typeCase {
            case .Original:
                transformedText = self
            case .UpperCase:
                transformedText = self.uppercased()
            case .LowerCase:
                transformedText = self.lowercased()
            case .TitleCase:
                transformedText = self.lowercased().capitalized
            }
        return transformedText
    }
    
    func bestBoundingRect(properties: TextProperties, ignoreSpacing:Bool = false)->CGSize {
        let attributedText = self.getAtrributedString(textProperties:properties,ignoreSpacing: ignoreSpacing)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
        
        // Calculate the constrained frame size for multiline text
        let sizeConstraints = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attributedText.length), nil, sizeConstraints, nil)
        return suggestedSize
    }
//    func bestBoundingRect2(properties: TextProperties,refSize:CGSize, ignoreSpacing:Bool = false , isWidthConstraint:Bool = false, isHeightConstraint:Bool = false)->CGSize {
//        let attributedText = self.getAtrributedString(textProperties:properties,ignoreSpacing: ignoreSpacing)
//        let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
//        
//        // Calculate the constrained frame size for multiline text
//        let sizeConstraints = CGSize(width: isWidthConstraint ? refSize.width : CGFloat.infinity, height: isHeightConstraint ? CGFloat.infinity : .infinity)
//        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attributedText.length), nil, sizeConstraints, nil)
//        return suggestedSize
//    }
//    func toImage(properties:TextProperties , width:CGFloat , height:CGFloat ) -> UIImage? {
//        
//        
//        var properties = properties
//        
//        let lastUpdatedSize = self.bestBoundingRect(properties: properties)
//        let attributedString =  self.getAtrributedString(textProperties:properties)// NSAttributedString(string: self , attributes: attributes)
//
//        let ctCalc = CTCalculator()
//        
//        let imageTEMP =  ctCalc.convertTextToImageCT(attributedString: attributedString, refFrameSize: CGSize(width: width, height: height), userProperties: properties)// userProperties: properties) refFrameSize: CGSize(width: width, height: height), textBounds: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
//        
//        
//
//        // Create a rectangle with the specified width and height
//        let rectSize = CGSize(width: width, height: height)
//        
//        // Begin image context
//        UIGraphicsBeginImageContextWithOptions(rectSize, false, 0.0)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        
//        // Fill the background with the provided background color
//        
////        if bgColor != nil{
////            self.bgType = 2
////        }
////        var BGcolor = bgColor?.cgColor ?? self.bgColor.cgColor
////        if bgType == 2 {
////           
////            if  let colors = BGcolor.copy(alpha: CGFloat((bgAlpha ?? self.bgAlpha))) {
////                context.setFillColor(colors)
////            }
////        }else{
//            context.setFillColor(UIColor.purple.cgColor)
//     //   }
//        
//        context.fill(CGRect(origin: .zero, size: rectSize))
//        
//        // Flip the context
//        context.translateBy(x: 0, y: rectSize.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//        
//        // Calculate the position and size of the text within the rectangle
//        let textRect = CGRect(x: rectSize.width/2 - lastUpdatedSize.width/2, y: rectSize.height/2 - lastUpdatedSize.height/2, width: lastUpdatedSize.width, height: lastUpdatedSize.height)
//        //let textRect = CGRect(x: 0, y: 0, width: rectSize.width, height: lastUpdatedSize.height)
//
//        // Create attributed string with the provided text and attributes
//       // let attributedString =  self.getAtrributedString(textProperties:properties)// NSAttributedString(string: self , attributes: attributes)
//        let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
//        
//        // Create a path for the text
//        let path = UIBezierPath(rect: textRect)
//        
//        // Create a frame and draw the text
//        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path.cgPath, nil)
//        CTFrameDraw(frame, context)
//        
//       // attributedString.draw(at: .zero)
//        // Get the image from the current context
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return imageTEMP
//    }

  
    func getAtrributedString(textProperties:TextProperties, ignoreSpacing:Bool = false) -> NSMutableAttributedString {
        
        let text = self.applyTypeCase(typeCase: textProperties.typeCase)
        var textProperties = textProperties
       // let offset : Float = textProperties.letterSpacing != 0 ? 0.0472 : 0
       // textProperties.letterSpacing = textProperties.letterSpacing //* Float(textProperties.fontSize)
       // Float((0.0 - 0.0472/*textProperties.letterSpacing + offset*/)
        textProperties.lineSpacing = Float(textProperties.lineSpacing)
        let attributes = text.createAttributes(textProperties: textProperties)
        let attributedString = NSMutableAttributedString(string: text , attributes: attributes)
        if !ignoreSpacing {
            attributedString.addAttribute(.kern, value: (textProperties.letterSpacing - 0.02) * Float(textProperties.fontSize), range: NSRange(location: 0, length: attributedString.length - 1))
        }
        else {
            attributedString.addAttribute(.kern, value: (textProperties.letterSpacing - 0.02) * Float(textProperties.fontSize) , range: NSRange(location: 0, length: attributedString.length ))

        }
        return attributedString
    }

    func createAttributes(textProperties: TextProperties) -> [NSAttributedString.Key: Any] {
        
        return self.createAttributes(fontName: textProperties.fontName, textColor: textProperties.forgroundColor, letterSpacing: textProperties.letterSpacing, lineSpacing: textProperties.lineSpacing, textGravity: textProperties.textGravity, fontSize: textProperties.fontSize, shadowColor: textProperties.shadowColor, shadowDx: textProperties.shadowDx, shadowDy: textProperties.shadowDy, shadowRadius: textProperties.shadowRadius)
    }
    
    func createAttributes(fontName: String = "Helvetica",
                          textColor: UIColor = .red,
                          letterSpacing: Float = 0,
                          lineSpacing: Float = 0,
                          textGravity: HTextGravity = .Center,
                          fontSize: CGFloat = 17,
                          shadowColor: UIColor = .green,
                          shadowDx: Float = 2.0,
                          shadowDy: Float = 2.0,
                          shadowRadius: Float = 3) -> [NSAttributedString.Key: Any] {
        
        // Initialize attributes dictionary
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        // Set font if provided, otherwise use the default textFont
        let font = UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)
            attributes[.font] = font
        
        
        // Set text color if provided
      
            attributes[.foregroundColor] = textColor
        
        
        // Add kerning (letter spacing) if provided
     
        let actualFontSize = fontSize
        let kernValue = (letterSpacing) //* Float(actualFontSize)
        //printLog("selected kern value",kernValue)
      //  attributes[.kern] = NSNumber(value: kernValue)
        
        
        // Set line spacing and alignment if provided
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = CGFloat(lineSpacing)
            paragraphStyle.lineBreakMode = .byWordWrapping

            paragraphStyle.alignment = textGravity.alignmentOfText()// Change to desired alignment
       
            attributes[.paragraphStyle] = paragraphStyle
        
        
        // Apply text curve logic (example: circular arc) if provided
         let fontL = font
        let fontSize = fontSize
//            var circularArcTransform = CGAffineTransform(rotationAngle: 0) // Adjust angle as needed
//            let curvedFont = CTFontCreateCopyWithAttributes(fontL, fontSize, &circularArcTransform, nil)
//            attributes[.font] = curvedFont
        
        
        // Add shadow attributes if provided
//         let shadowColor = shadowColor
            let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: CGFloat(shadowDx ), height: CGFloat(shadowDy ))
        shadow.shadowBlurRadius = CGFloat(shadowRadius)
            attributes[.shadow] = shadow
        
        
        return attributes
    }
}

class CTCalculator {
    private let logger: PackageLogger?

    init(logger: PackageLogger? = nil) {
        self.logger = logger
    }
   
//    deinit {
//        printLog("de-init \(self)")
//    }
    
   
    
    
    
    enum CTAlignmentX {
        case left , right , center
    }
    
    enum CTAlignmentY {
        case top , bottom , center
    }
    func getTextBGImage(refSize: CGSize, boundingRect: CGRect, bgColor: UIColor = .clear) -> UIImage? {
        let activeLogger = logger
        guard refSize.width > 0, refSize.height > 0 else {
            activeLogger?.logErrorFirebaseWithBacktrace("[TextRenderGuard] reason=invalidRefSize ref=\(refSize.width)x\(refSize.height)")
            return nil
        }

        UIGraphicsBeginImageContext(refSize)
        guard let ctx = UIGraphicsGetCurrentContext() else {
          return nil
        }
        bgColor.setFill()
        ctx.fill(CGRect(origin: .zero, size: refSize))
        let textImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ctx
        return textImage
    }
    
//    func getMinimumHeight(userText:String,refSize:CGSize,font:UIFont) -> String
//
//    {
//        
//        /*
//         calculate bestEHgiht among all lines
//         */
//        
//        var highestLineNumber : Int = 0
//    var lineHeights = [CGFloat]()
//            var mainBound = CGRect.zero
//            var minX = CGFloat.zero
//            var maxX = CGFloat.zero
//            var minY = CGFloat.zero
//            var maxY = CGFloat.zero
//            
//            var rightMostX = CGFloat.zero
//            var topMostY = CGFloat.zero
//            
//            var lineBounds = [CGRect]()
//            var wordBounds = [CGRect]()
//            var letterBounds = [CGRect]()
//            
//            UIGraphicsBeginImageContext(refSize)
//            
//            guard let ctx = UIGraphicsGetCurrentContext() else {
//                return ""
//            }
//
//            // Flip Context From MacOS to iOS
//            ctx.textMatrix = .identity
//            ctx.translateBy(x: 0, y: refSize.height)
//            ctx.scaleBy(x: 1.0, y: -1.0)
//            
//            /* Note :- Current Context XY = (0,0) is At Left Bottom */
//            
//            // convert frame to CTFrame For further CoreText Based Calculation ( lines,run and glyphs )
//            let frame = getCTFrame(refSize: refSize, font: font, userText: userText )
//            frame.draw(in: ctx)
//            // get Origins Of Every Line
//            var lineOrigins = frame.lineOrigins()
//            
//            // get total Lines
//            var lines = frame.lines()
//            
//            
//            for loIndex in 0 ..< lineOrigins.count {
//                let line = lines[loIndex]
//                   
//                ctx.textPosition = .zero  // set Context Text Start Position To Zero ( Helps CT to return Glyph bounds with respect to zero origin )
//               
//                    
//                var lineBox = line.imageBounds(in: ctx) // get LineBox Of Current Line
//              
//                lineBox.origin = lineOrigins[loIndex]   // SomeTimes ImageBounds Returns Wrong Bounds ( Bug MayB ) So We re replacing with LineOrigins
//                lineHeights.append(lineBox.height)
//               // lineBounds.append(lineBox)
//                
//                    //  let totalGlyphRuns = line.glyphRuns() // Get Total GlyphRuns In Single Line
//                
////                for grIndex in 0...totalGlyphRuns.count - 1 {
////                    let run = totalGlyphRuns[grIndex] // Get Current Run
////                    let font = run.font // Get Run's Font
////
////                    let glyphs = run.glyphs() // All Glyps Inside Current Run
////                    let glyphPositions = run.glyphPositions() // All Glyph XY Inside Current Run
////
////                    let glyphsBoundingRects =  font.boundingRects(of: glyphs) // All Glyphs Exact Bounds Inside Current Run
////
////
////                    var leftMostOrigin : CGPoint = CGPoint.zero
////
////                    for gpIndex in 0 ..< glyphPositions.count { // iterating through every glyphs
////
////                        let glyphOrigin = glyphPositions[gpIndex] // Current Glyph XY
////                        let glyphBounds = glyphsBoundingRects [gpIndex] // Current Glyph Rect
////
////                        var glyphBox = glyphBounds // Update Glyph Box With Respect To Ref Size
////
////                        glyphBox.origin.x += lineOrigins[loIndex].x + glyphOrigin.x // LineOrigin X + Glyph Origin X
////                        glyphBox.origin.y +=   lineOrigins[loIndex].y + glyphOrigin.y  // LineOrigin Y + Glyph Origin Y
////
////                        let minXofGlyph = min(glyphBox.origin.x,leftMostOrigin.x) // get minimum X Value
////                        let maxXofGlyph = max(rightMostX,glyphBox.maxX) // get maximum X Value
////
////                        let minYofGlyph = min(leftMostOrigin.y,glyphBox.origin.y) // get minimum Y Value
////                        let maxYofGlyph = max(topMostY,glyphBox.maxY) // get minimum Y Value
////
////                        /* If Line And Character Are First Then Take Their Origins Else Use Above min max XY  */
////                        leftMostOrigin.x = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.x : minXofGlyph
////                        rightMostX = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxX : maxXofGlyph
////                        leftMostOrigin.y = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.y : minYofGlyph//-  box.height
////                        topMostY = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxY : maxYofGlyph
////    //
////    //                    print("Line X : ",leftMostOrigin.x , "Line Y : ",leftMostOrigin.y )
////    //                    print("Line Hright : " , line.typographicHeight())
////                      /*
////                        ctx.setStrokeColor(UIColor.black.cgColor)
////                        ctx.setLineWidth(1.0)
////                        ctx.stroke(glyphBox)
////                         */
////
////                    } // Total Glyphs Positions In One Run Ends Here
////
////                    /* UPdate Current Line Origins To Minimum XY After Every Run ( Its Posible That Second Or Third Or 4th Word X is minimum Than First Character Or Word In Line */
////
////                    lineBounds[loIndex].origin.x =  leftMostOrigin.x
////                    lineBounds[loIndex].origin.y =   leftMostOrigin.y
////
////                } // Total Runs In Line Ends here
//                    
//                
////                let minXofLine = min(lineBounds[loIndex].origin.x,mainBound.origin.x)
////                let maxXofLine = max(maxX,rightMostX)
////
////                let minYofLine = min(lineBounds[loIndex].origin.y,mainBound.origin.y)
////                let maxYofLine = max(maxY,topMostY)
////
////                /* If Line Is First Then Take Its  XY Else Use Above min max XY  */
////                mainBound.origin.x = loIndex == 0 ?  lineBounds[loIndex].origin.x : minXofLine // We Got Our Exact Origin X
////                mainBound.origin.y = loIndex == 0 ?  lineBounds[loIndex].origin.y : minYofLine // We Got Our Exact Origin Y
////
////                minX = mainBound.origin.x
////                maxX = maxX <= minX ? rightMostX : maxXofLine
////                mainBound.size.width = maxX - minX // We Got Our Exact Width
////                minY = mainBound.origin.y
////                maxY = maxY <= minY ? topMostY : maxYofLine
////                mainBound.size.height = maxY - minY // We Got Our Exact Height
//              
//               
//            } // Total Lines In CTFrame Ends Here
//            
//            // Add Margin ( 5 % of min of Width And Height )
//            //print("EXACT BOUNDS : ", mainBound)
//           /*
//            ctx.setStrokeColor(UIColor.white.cgColor)
//            ctx.setLineWidth(1.0)
//            ctx.stroke(mainBound)
//            */
////            if paddingInPerc != 0 {
////
////            let margin = ( paddingInPerc / 100 ) * min(mainBound.width,mainBound.height)
////            mainBound.origin.x -= margin
////            mainBound.origin.y -= margin
////            mainBound.size.width += 2*margin
////            mainBound.size.height += 2*margin
////
////
////           /*
////                 print("Marginal Bounds : " , mainBound)
////            ctx.setStrokeColor(UIColor.blue.cgColor)
////            ctx.setLineWidth(1.0)
////            ctx.stroke(mainBound)
////
////           */
////            }
//          /*  let image = UIGraphicsGetImageFromCurrentImageContext()
//            imageView.image = image */
//            UIGraphicsEndImageContext()
//        let maxHeight = lineHeights.max()
//        let index = lineHeights.firstIndex(of: maxHeight ?? 0)!
//        
//        return userText.lines[index]
//    }
//    func convertTextToImageCT(font: UIFont, userText : String , textColor : UIColor ,refFrameSize : CGSize , textBounds : CGRect ,xAlign : CTAlignmentX = .center, yAlign : CTAlignmentY = .center , bgColor : UIColor = .clear) -> UIImage?{
//    func convertTextToImageCT( attributedString : NSMutableAttributedString ,refFrameSize : CGSize , userProperties:TextProperties, maxWidth:CGFloat = .infinity,maxHeight:CGFloat = .infinity ) -> UIImage?{
//
//            let textBounds =  attributedString.string.bestBoundingRect(properties: userProperties, ignoreSpacing: false)
//            
//            let textBounds2 = CTCalculator().getExactBounds(refSize: refFrameSize,attributedString: attributedString,maxWidth: maxWidth,maxHeight: maxHeight)
//        
////        let paragraphStyle = NSMutableParagraphStyle()
////           paragraphStyle.alignment = .center
////           let attributes = [
////               NSAttributedString.Key.paragraphStyle: paragraphStyle,
////               NSAttributedString.Key.font: font,
////               NSAttributedString.Key.foregroundColor: textColor
////           ]
////        let attributedString = NSAttributedString(string: userText,attributes: attributes)
////        let frame = attributedString.framesetter().createFrame(CGRect(origin: .zero, size: refFrameSize))
//        let frmeSetter = attributedString.framesetter()
//        let frameSize = frmeSetter.frameSize(suggested: CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
//        let frame = attributedString.framesetter().createFrame(CGRect(origin: .zero, size: frameSize))
//            
//            var refFrameSize = refFrameSize
//            
//            if frameSize.height > refFrameSize.height {
//                refFrameSize.height = frameSize.height
//            }
//        
//        UIGraphicsBeginImageContext(refFrameSize)
//        
//        
//        
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//          return nil
//        }
//        if userProperties.bgType == 2{
//            userProperties.backgroundColor.setFill()
//        }else{
//            UIColor.clear.setFill()
//        }
//        ctx.fill(CGRect(origin: .zero, size: refFrameSize))
//          
////            UIColor.red.setFill()
////           // ctx.fill(CGRect(origin: .zero, size: textBounds2.size))
////            ctx.stroke(CGRect(origin: textBounds2.origin, size: textBounds2.size))
//        ctx.textMatrix = .identity
//        ctx.translateBy(x: 0, y: refFrameSize.height)
//        ctx.scaleBy(x: 1.0, y: -1.0)
//        
//       
//       
//        
//  
//
//        let x = frame.lineOrigins().map({$0.x}).min() ?? 0
//        let y = frame.lineOrigins().map({$0.y}).min() ?? 0
//        
//        var xOffset : CGFloat = 0
//        var yOffset : CGFloat = 0
//
//            xOffset = ((refFrameSize.width/2) - ( (frameSize.width/2)))
//          yOffset = ((refFrameSize.height/2) - ( (frameSize.height/2)))
//
////        /* By Default XY Alignment In Center*/
////
////            switch userProperties.textGravity.alignmentOfText() {
////        case .center:
////            xOffset = ((refFrameSize.width/2) - ((textBounds.width/2)))
////        case .left:
////            xOffset = -x
////        case .right:
////            xOffset = refFrameSize.width - ( (textBounds2.width));
////            case .justified:
////                xOffset = ((refFrameSize.width/2) - ( (textBounds2.width/2)))
////            case .natural:
////                xOffset = ((refFrameSize.width/2) - (x + (textBounds2.width/2)))
////            @unknown default:
////                xOffset = ((refFrameSize.width/2) - (x + (textBounds2.width/2)))
////            }
////            
//               yOffset = ((refFrameSize.height/2) - ( (textBounds2.height/2)))
//
////        switch yAlign {
////        case .center:
////        case .bottom:
////            yOffset = -textBounds.origin.y
////        case .top:
////            yOffset = refFrameSize.height - (textBounds.origin.y + (textBounds.height));
////        }
//
//       // ctx.translateBy(x:-textBounds.origin.x, y: 0)
//       // if userText != "" {
//            ctx.translateBy(x: xOffset , y: yOffset)
//            frame.draw(in: ctx)
//            ctx.translateBy(x: -xOffset , y: -yOffset)
//            ctx.setStrokeColor(UIColor.black.cgColor)
//
//            ctx.stroke(CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: textBounds))
//
//           
//            ctx.setStrokeColor(UIColor.green.cgColor)
//           // ctx.fill(CGRect(origin: .zero, size: textBounds2.size))
//            ctx.stroke(CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: textBounds2.size))
//
////        }else{
////            textColor.setFill()
////            ctx.fill(CGRect(origin: CGPoint.zero, size: textBounds.size))
////
////        }
//      //  ctx.translateBy(x: -xOffset , y: - yOffset)
//        let textImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return textImage
//        
//    }
//    func getCTFrame(refSize:CGSize ,  attributedString : NSAttributedString,  isWidthConstraint:Bool = false , isHeightConstraint : Bool = false) -> CTFrame {
//        
//       let frmeSetter = attributedString.framesetter()
//        let frameSize = frmeSetter.frameSize(suggested: CGSize(width: isWidthConstraint ? refSize.width : CGFloat.infinity, height: isHeightConstraint ? refSize.height : .infinity))
//        let frame = attributedString.framesetter().createFrame(CGRect(origin: .zero, size: frameSize))
//        return frame
//    }
    func getCTFrame(maxWidth: CGFloat = .infinity , maxHeight: CGFloat = .infinity, attributedString : NSAttributedString) -> CTFrame {
        
       let frmeSetter = attributedString.framesetter()
        let frameSize = frmeSetter.frameSize(suggested: CGSize(width: maxWidth, height: maxHeight))
        let frame = frmeSetter.createFrame(CGRect(origin: .zero, size: frameSize))
        return frame
    }
//    func getLineHeight(frame:CTFrame)->CGFloat{
//        var lines = frame.lines()
//        return lines.first?.typographicHeight() ?? 0.0
//    }
    
//    func getJDTextSize(refSize:CGSize , attributedString : NSMutableAttributedString, isWidthConstraint:Bool = true , isHeightConstraint : Bool = false,paddingInPerc : CGFloat = 15 ) -> CGRect  {
//        
//        
//       
//        // convert frame to CTFrame For further CoreText Based Calculation ( lines,run and glyphs )
////        let frame = getCTFrame(refSize: refSize, attributedString: attributedString ,isWidthConstraint: isWidthConstraint , isHeightConstraint: isHeightConstraint)
////
////         let frmeSetter = attributedString.framesetter()
////         let frameSize = frmeSetter.frameSize(suggested: CGSize(width: isWidthConstraint ? refSize.width : CGFloat.infinity, height: isHeightConstraint ? refSize.height : .infinity))
//        let containerSize = CGSize(width: refSize.width, height: CGFloat.greatestFiniteMagnitude)
//        let textRect = CGRect(origin: .zero, size: containerSize)
//        let path = CGMutablePath()
//        path.addRect(textRect)
//
//        
//        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
//        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path, nil)
//        let frameSize = framesetter.frameSize(suggested: CGSize(width: isWidthConstraint ? refSize.width : CGFloat.infinity, height: isHeightConstraint ? refSize.height : .infinity))
//
//        let string = extractStringFromCTFrame(frame: frame, attributedString: attributedString)
//        
//       // frame.draw(in: ctx)
//        // get Origins Of Every Line
//        var lineOrigins = frame.lineOrigins()
//        
//        // get total Lines
//        var lines = frame.lines()
//        var totalHeight = 0
//     
//        
//        print("Number Of Lines",lines.count)
//        print("Number Of Lines 2 ",lineOrigins.count)
//
//        let originX = lineOrigins.map({$0.x}).min()
//        let originY = lineOrigins.map({$0.y}).min()
//        let mainBounds = CGRect(origin: CGPoint(x: originX ?? 0, y: originY ?? 0), size: frameSize)
//        
//        return mainBounds
//        
//    }
//    func extractStringFromCTFrame(frame: CTFrame, attributedString: NSAttributedString) -> String {
//        // Get lines from the CTFrame
//        let lines = CTFrameGetLines(frame) as! [CTLine]
//        
//        // Create an NSMutableString to collect the extracted text
//        let extractedText = NSMutableString()
//        
//        // Prepare to iterate through lines
//        var lineOrigins = [CGPoint](repeating: .zero, count: lines.count)
//        CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &lineOrigins)
//        
//        // Iterate over lines and extract text
//        for (index, line) in lines.enumerated() {
//            // Get the range of characters for this line
//            let range = CTLineGetStringRange(line)
//            let startIndex = range.location
//            let endIndex = range.location + range.length
//            
//            // Extract the substring from the attributed string
//            let lineText = attributedString.string[attributedString.string.index(attributedString.string.startIndex, offsetBy: startIndex)..<attributedString.string.index(attributedString.string.startIndex, offsetBy: endIndex)]
//            
//            // Append the line text to the NSMutableString
//            extractedText.append(String(lineText))
//            
//            if index != lines.count - 1 {
//                // Optionally, add a newline character after each line (if desired)
//                extractedText.append("\n")
//            }
//        }
//        
//        return extractedText as String
//    }
    
    struct TextValues {
        var numberOflines : Int
        var width : CGFloat
        var height : CGFloat
        var boundingRect : CGRect
        
    }

    func getBoundsForCurrentFontSize(newText:String,textProperties:TextProperties, parentSize: CGSize) -> TextValues {
        
        if newText == "" {
            return TextValues(numberOflines: Int(1) , width: 10, height: 10, boundingRect: CGRect(x: 0, y: 0, width: 10, height: 10))
        }
        
        
        let attributedString = newText.getAtrributedString(textProperties: textProperties)
        
        // Step 1: Set up the text storage, layout manager, and text container
        let textStorage = NSTextStorage(attributedString: attributedString)
        let textContainer = NSTextContainer(size: CGSize(width: parentSize.width, height: parentSize.height))
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.lineFragmentPadding = 0
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        var textRect = CGRect.zero
        
        
        var isValidWrap = true
        let font = UIFont(name: textProperties.fontName,size:textProperties.fontSize)!
        
        let testFont =   CTFontCreateWithName(textProperties.fontName as CFString,CGFloat(textProperties.fontSize) , nil)
        let rect2 = attributedString.boundingRect(with: CGSize(width: parentSize.width, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        let boundingBox2 = CTFontGetBoundingBox(testFont)

            
        let newRect = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer)
       
        layoutManager.usesFontLeading = true
        var lines : CGFloat = 0
        layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(for: textContainer)) { (rect, usedRect, _, lineRange, glyphRange) in
            // Draw each line as a rectangle to visualize the layout
    //        context.stroke(rect)
    //        context.setStrokeColor(UIColor.yellow.cgColor)
    //        context.stroke(usedRect)
            textRect = textRect.union(rect)
            
            lines += 1
            
        }
        
        var adjustedHeight = boundingBox2.height * lines
        // Step 5: Calculate the total line height considering the line multiplier and bounding box height
          if lines > 1 {
              // If multiple lines, apply lineMultiplier to scale the line height
              adjustedHeight = (boundingBox2.height * CGFloat(lines)) + (font.lineHeight * CGFloat(textProperties.lineSpacing-1.0) * CGFloat(lines - 1))
          } else {
              // For a single line, use only the fontHeight (no multiplier needed)
              adjustedHeight = boundingBox2.height
          }
        
        
//        print("Bounding Box From Get Bound \(newRect)")
        textRect.size.height = adjustedHeight
        let textHeight = textRect.height
        let textWidth = newRect.width
       
        return TextValues(numberOflines: Int(lines) , width: textWidth, height: textHeight, boundingRect: newRect)
        
       
    }
    

    func getExactBounds(rootWidth: CGFloat, rootHeight: CGFloat, newText: String, textProperties: TextProperties) -> CGSize {
        let boundingWidth = rootWidth //* textProperties.width
        let boundingHeight = rootHeight //* textProperties.height
        
        var alignment: NSTextAlignment = .center
        if textProperties.textGravity.alignmentOfText() == .left {
            alignment = .left
        } else if textProperties.textGravity.alignmentOfText() == .right {
            alignment = .right
        }
        
        // Create a text attributes dictionary to apply to the text
        var textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: textProperties.fontName, size: textProperties.fontSize)!,
            .foregroundColor: textProperties.textColor
        ]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = CGFloat(textProperties.lineSpacing)
        textAttributes[.paragraphStyle] = paragraphStyle
        
        // Calculate margins
        let widthMargin = boundingWidth * textProperties.externalWidthMargin / 100
        let heightMargin = boundingHeight * textProperties.externalHeightMargin / 100
        
        let boundingRect = CGRect(x: 0, y: 0, width: boundingWidth - (4 * widthMargin), height: boundingHeight - (2 * heightMargin))
        
        // Create a bounding box for the text
        let textRect = newText.boundingRect(with: boundingRect.size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: textAttributes, context: nil)
        
        // Calculate the width and height for the text
        var newWidth = textRect.width
        var newHeight = textRect.height
        
        // Adjust for a single line of text
//        if textProperties.numberOfLines == 1 {
//            newWidth = min(newWidth, boundingWidth)
//        }
        
        // Calculate the actual size based on the text bounding box
        let realWidth = newWidth * (100 / (100 - textProperties.externalWidthMargin))
        let realHeight = newHeight * (100 / (100 - textProperties.externalHeightMargin))
        
        return CGSize(width: realWidth, height: realHeight)
    }
    
//    func getExactBounds(refSize:CGSize , attributedString : NSMutableAttributedString, maxWidth : CGFloat = .infinity, maxHeight:CGFloat = .infinity , isHeightConstraint : Bool = false,paddingInPerc : CGFloat = 0 ) -> CGRect {
//        
//        var mainBound = CGRect.zero
//        var minX = CGFloat.zero
//        var maxX = CGFloat.zero
//        var minY = CGFloat.zero
//        var maxY = CGFloat.zero
//        
//        var rightMostX = CGFloat.zero
//        var topMostY = CGFloat.zero
//        
//        var lineBounds = [CGRect]()
//        var wordBounds = [CGRect]()
//        var letterBounds = [CGRect]()
//        
//        UIGraphicsBeginImageContext(refSize)
//        
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//            return .zero
//        }
//
//        // Flip Context From MacOS to iOS
//        ctx.textMatrix = .identity
//        ctx.translateBy(x: 0, y: refSize.height)
//        ctx.scaleBy(x: 1.0, y: -1.0)
//        
//        /* Note :- Current Context XY = (0,0) is At Left Bottom */
//        
//        // convert frame to CTFrame For further CoreText Based Calculation ( lines,run and glyphs )
//        let frame = getCTFrame(maxWidth: maxWidth,maxHeight: maxHeight, attributedString: attributedString)
//        
//        let extractedString = extractText(from: frame, attributedString: attributedString)
////        if extractedString.isEmpty || extractedString == "" {
////            return .zero
////        }
////        let isValid = isValisWordWrap(text: extractedString)
////        printLog("ISVALID_",isValid)
////        if !isValid {
////         //   return .zero
////        }
//        
//        let font = attributedString.attribute(.font, at: 0, effectiveRange: nil) as! UIFont
//        let paraStyle = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as! NSParagraphStyle
//
//        let testFont =   CTFontCreateWithName( font.fontName as CFString,CGFloat(font.pointSize) , nil)
//        let rect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], context: nil)
//
//
//         
//         let boundingBox = CTFontGetBoundingBox(testFont)
//         let top = boundingBox.origin.y + boundingBox.size.height
//         let bottom = boundingBox.origin.y
//        // print("JDText_1.ExactBonuds:\(size.size),ASR:\(size.width/size.height),fontSize: \( properties1.fontSize)")
//      //   print("JDText_2.frameSize:\(frameSize),ASR2:\(frameSize.width/frameSize.height),fontSize: \( properties1.fontSize)")
//        print("JDText_1.boundingRect:\(rect.size),ASR2:\( rect.size.width/rect.size.height),fontSize: \( font.pointSize)")
//               print("JDText_2:top:",top , "bottom",bottom)
//         print("JDText_3:BoundingBox : \(boundingBox)")
//        var letHeight = CGFloat(extractedString.lines.count) * boundingBox.height + ((paraStyle.lineHeightMultiple - 1 ) * font.lineHeight)
//        
//        var boundingBoxHeight = rect.height
//
//         //print("JDText_4.typographicHeight:\(textHeight),fontSize: \( properties1.fontSize)")
//      //  let rect = att.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
//
//         var finalSize = CGSize(width: (rect.width), height: (letHeight))
//        var finalRect = CGRect(x: 0, y: 0, width: rect.width, height: letHeight)
//
//       // return finalRect
//        // print("TextMarginBounds",finalSize,"fontSize",mid)
//        
//       // frame.draw(in: ctx)
//        // get Origins Of Every Line
//        var lineOrigins = frame.lineOrigins()
//        
//        // get total Lines
//        var lines = frame.lines()
//        
//        var height : CGFloat = 0
//        for loIndex in 0 ..< lineOrigins.count {
//            let line = lines[loIndex]
//               
//            ctx.textPosition = .zero  // set Context Text Start Position To Zero ( Helps CT to return Glyph bounds with respect to zero origin )
//           
//            height = height +  line.typographicHeight()
//            if attributedString.string == "BIRTHDAY PARTY"{
//                print("NKk EXACT BOUNDS : \(height) , \(attributedString.string)"  )
//            }
//            var lineBox = line.imageBounds(in: ctx) // get LineBox Of Current Line
//          
//            lineBox.origin = lineOrigins[loIndex]   // SomeTimes ImageBounds Returns Wrong Bounds ( Bug MayB ) So We re replacing with LineOrigins
//            
//            lineBounds.append(lineBox)
//            
//            let totalGlyphRuns = line.glyphRuns() // Get Total GlyphRuns In Single Line
//            
//            for grIndex in 0...totalGlyphRuns.count - 1 {
//                let run = totalGlyphRuns[grIndex] // Get Current Run
//                let font = run.font // Get Run's Font
//                
//                let glyphs = run.glyphs() // All Glyps Inside Current Run
//                let glyphPositions = run.glyphPositions() // All Glyph XY Inside Current Run
//                              
//                let glyphsBoundingRects =  font.boundingRects(of: glyphs) // All Glyphs Exact Bounds Inside Current Run
//                
//                
//                var leftMostOrigin : CGPoint = lineBox.origin
//
//                for gpIndex in 0 ..< glyphPositions.count { // iterating through every glyphs
//                    
//                    let glyphOrigin = glyphPositions[gpIndex] // Current Glyph XY
//                    let glyphBounds = glyphsBoundingRects [gpIndex] // Current Glyph Rect
//            
//                    var glyphBox = glyphBounds // Update Glyph Box With Respect To Ref Size
//                    
//                    glyphBox.origin.x += lineOrigins[loIndex].x + glyphOrigin.x // LineOrigin X + Glyph Origin X
//                    glyphBox.origin.y +=   lineOrigins[loIndex].y + glyphOrigin.y  // LineOrigin Y + Glyph Origin Y
//                    
//                    let minXofGlyph = min(glyphBox.origin.x,leftMostOrigin.x) // get minimum X Value
//                    let maxXofGlyph = max(rightMostX,glyphBox.maxX) // get maximum X Value
//        
//                    let minYofGlyph = min(leftMostOrigin.y,glyphBox.origin.y) // get minimum Y Value
//                    let maxYofGlyph = max(topMostY,glyphBox.maxY) // get minimum Y Value
//                    
//                    /* If Line And Character Are First Then Take Their Origins Else Use Above min max XY  */
//                    leftMostOrigin.x = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.x : minXofGlyph
//                    rightMostX = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxX : maxXofGlyph
//                    leftMostOrigin.y = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.y : minYofGlyph//-  box.height
//                    topMostY = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxY : maxYofGlyph
////
////                    print("Line X : ",leftMostOrigin.x , "Line Y : ",leftMostOrigin.y )
////                    print("Line Hright : " , line.typographicHeight())
//                  
//                    ctx.setStrokeColor(UIColor.black.cgColor)
//                    ctx.setLineWidth(1.0)
//                  //  ctx.translateBy(x: glyphBox.minX , y: 0)
//
//                    ctx.stroke(glyphBox)
//                     
//                    
//                } // Total Glyphs Positions In One Run Ends Here
//                
//                /* UPdate Current Line Origins To Minimum XY After Every Run ( Its Posible That Second Or Third Or 4th Word X is minimum Than First Character Or Word In Line */
//                lineBounds[loIndex].origin.x =  min(lineBounds[loIndex].origin.x,leftMostOrigin.x)
//                lineBounds[loIndex].origin.y =   min(lineBounds[loIndex].origin.y,leftMostOrigin.y)
//                
//            } // Total Runs In Line Ends here
//                
//            
//            let minXofLine = min(lineBounds[loIndex].origin.x,mainBound.origin.x)
//            let maxXofLine = max(maxX,rightMostX)
//            
//            let minYofLine = min(lineBounds[loIndex].origin.y,mainBound.origin.y)
//            let maxYofLine = max(maxY,topMostY)
//          
//            /* If Line Is First Then Take Its  XY Else Use Above min max XY  */
//            mainBound.origin.x = loIndex == 0 ?  lineBounds[loIndex].origin.x : minXofLine // We Got Our Exact Origin X
//            mainBound.origin.y = loIndex == 0 ?  lineBounds[loIndex].origin.y : minYofLine // We Got Our Exact Origin Y
//            
//            minX = mainBound.origin.x
//            maxX = maxX <= minX ? rightMostX : maxXofLine
//            mainBound.size.width = maxX - minX // We Got Our Exact Width
//            minY = mainBound.origin.y
//            maxY = maxY <= minY ? topMostY : maxYofLine
//            mainBound.size.height =  maxY - minY // We Got Our Exact Height
////            mainBound.origin.y = (refSize.height - height) / 2
//          //  let testFont =   CTFontCreateWithName(properties.fontName as CFString,CGFloat(each) , nil)
//
//            
//          
//            
//           
//        } // Total Lines In CTFrame Ends Here
//        let frmeSetter = attributedString.framesetter()
//         let frameSize = frmeSetter.frameSize(suggested: CGSize(width: maxWidth, height: maxHeight))
//        
//        // Add Margin ( 5 % of min of Width And Height )
//        //print("EXACT BOUNDS : ", mainBound)
//        let oneMoreFrame = attributedString.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), context: nil)
//        print("NK EXACT BOUNDS : \(mainBound) , \(attributedString.string) Frame Size \(frameSize) First Height \(maxY - minY) OneMoreFrame \(oneMoreFrame)"  )
//       
//       
//        
//        /* By Default XY Alignment In Center*/
//        var xOffset : CGFloat = 0
//        var yOffset : CGFloat = 0
//
//        var xAlign = CTAlignmentX.center
//        var yAlign = CTAlignmentY.center
//        
//        switch xAlign {
//        case .center:
//            xOffset = ((refSize.width/2) - (mainBound.origin.x + (mainBound.width/2)))
//        case .left:
//            xOffset = -mainBound.origin.x
//        case .right:
//            xOffset = refSize.width - (mainBound.origin.x + (mainBound.width));
//        }
//        switch yAlign {
//        case .center:
//            yOffset = ((refSize.height/2) - (mainBound.origin.y + (mainBound.height/2)))
//        case .bottom:
//            yOffset = -mainBound.origin.y
//        case .top:
//            yOffset = refSize.height - (mainBound.origin.y + (mainBound.height));
//        }
//        
//        ctx.translateBy(x: xOffset , y: yOffset)
//
//        ctx.setStrokeColor(UIColor.white.cgColor)
//        ctx.setLineWidth(1.0)
//        ctx.stroke(mainBound)
//        frame.draw(in: ctx)
//        if paddingInPerc != 0 {
//            
//        let margin = ( paddingInPerc / 100 ) * min(mainBound.width,mainBound.height)
//       var b = mainBound
//            b.origin.x -= margin
//            b.origin.y -= margin
//            b.size.width += 2*margin
//            b.size.height += 2*margin
//        
//        
//       
//             print("Marginal Bounds : " , mainBound)
//        ctx.setStrokeColor(UIColor.blue.cgColor)
//        ctx.setLineWidth(1.0)
//        ctx.stroke(b)
//       
//       
//        }
//        
//        print("FinalRect:",finalRect)
//        print("boundingBoxHeight:",boundingBoxHeight)
//
//        
////       let image2 = convertTextToImageCTNew(attributedString: attributedString, refFrameSize: refSize, textBounds: mainBound)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//       print(image)
//        UIGraphicsEndImageContext()
//        
//        
//        return mainBound
//    }
    func drawImageCoreText(textProperties: TextProperties, refSize:CGSize , attributedString : NSMutableAttributedString, maxWidth : CGFloat = .infinity, maxHeight:CGFloat = .infinity , isHeightConstraint : Bool = false,paddingInPerc : CGFloat = 0, logger: PackageLogger?) -> UIImage? {
        let activeLogger = logger ?? self.logger
        
        var mainBound = CGRect.zero
        var minX = CGFloat.zero
        var maxX = CGFloat.zero
        var minY = CGFloat.zero
        var maxY = CGFloat.zero
        
        var rightMostX = CGFloat.zero
        var topMostY = CGFloat.zero
        
        var lineBounds = [CGRect]()
        var wordBounds = [CGRect]()
        var letterBounds = [CGRect]()
        
        guard refSize.width > 0, refSize.height > 0 else {
            activeLogger?.logErrorFirebaseWithBacktrace("[TextRenderGuard] reason=invalidRefSize ref=\(refSize.width)x\(refSize.height)")
            return nil
        }
        
        UIGraphicsBeginImageContext(refSize)
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }

        // Flip Context From MacOS to iOS
        ctx.textMatrix = .identity
        ctx.translateBy(x: 0, y: refSize.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        
        if attributedString.string != "" {
                 if textProperties.bgType == 2.0{
                     let bgColor = textProperties.backgroundColor.withAlphaComponent(CGFloat(textProperties.bgAlpha))
                     bgColor.setFill()
                 }else{
                     UIColor.clear.setFill()
                 }
            ctx.fill(CGRect(origin: CGPoint.zero, size: refSize))
        }
        
        /* Note :- Current Context XY = (0,0) is At Left Bottom */
        
        // convert frame to CTFrame For further CoreText Based Calculation ( lines,run and glyphs )
        let frame = getCTFrame(maxWidth: maxWidth,maxHeight: maxHeight, attributedString: attributedString)
        
        let extractedString = extractText(from: frame, attributedString: attributedString, logger: activeLogger)
//        if extractedString.isEmpty || extractedString == "" {
//            return .zero
//        }
//        let isValid = isValisWordWrap(text: extractedString)
//        printLog("ISVALID_",isValid)
//        if !isValid {
//         //   return .zero
//        }
        
        guard attributedString.length > 0,
              let font = attributedString.attribute(.font, at: 0, effectiveRange: nil) as? UIFont,
              let paraStyle = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle else {
            activeLogger?.logErrorFirebaseWithBacktrace("[TextRenderGuard] reason=missingAttributes length=\(attributedString.length)")
            return nil
        }

        let testFont =   CTFontCreateWithName( font.fontName as CFString,CGFloat(font.pointSize) , nil)
        let rect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], context: nil)


         
         let boundingBox = CTFontGetBoundingBox(testFont)
         let top = boundingBox.origin.y + boundingBox.size.height
         let bottom = boundingBox.origin.y
        // print("JDText_1.ExactBonuds:\(size.size),ASR:\(size.width/size.height),fontSize: \( properties1.fontSize)")
      //   print("JDText_2.frameSize:\(frameSize),ASR2:\(frameSize.width/frameSize.height),fontSize: \( properties1.fontSize)")
        print("JDText_1.boundingRect:\(rect.size),ASR2:\( rect.size.width/rect.size.height),fontSize: \( font.pointSize)")
               print("JDText_2:top:",top , "bottom",bottom)
         print("JDText_3:BoundingBox : \(boundingBox)")
       
        var letHeight = CGFloat(extractedString.lines.count) * boundingBox.height + ((paraStyle.lineHeightMultiple - 1 ) * font.lineHeight)
        
        var boundingBoxHeight = rect.height

         //print("JDText_4.typographicHeight:\(textHeight),fontSize: \( properties1.fontSize)")
      //  let rect = att.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)

         var finalSize = CGSize(width: (rect.width), height: (letHeight))
        var finalRect = CGRect(x: 0, y: 0, width: rect.width, height: letHeight)

       // return finalRect
        // print("TextMarginBounds",finalSize,"fontSize",mid)
        
       // frame.draw(in: ctx)
        // get Origins Of Every Line
        let lineOrigins = frame.lineOrigins()
        let lines = frame.lines()
        guard !lineOrigins.isEmpty, lineOrigins.count == lines.count else {
            activeLogger?.logErrorFirebaseWithBacktrace("[TextRenderGuard] reason=lineCountsMismatch origins=\(lineOrigins.count) lines=\(lines.count)")
            return nil
        }
        
        var height : CGFloat = 0
        for loIndex in 0 ..< lineOrigins.count {
            let line = lines[loIndex]
               
            ctx.textPosition = .zero  // set Context Text Start Position To Zero ( Helps CT to return Glyph bounds with respect to zero origin )
           
            height = height +  line.typographicHeight()
            if attributedString.string == "BIRTHDAY PARTY"{
                print("NKk EXACT BOUNDS : \(height) , \(attributedString.string)"  )
            }
            var lineBox = line.imageBounds(in: ctx) // get LineBox Of Current Line
          
            lineBox.origin = lineOrigins[loIndex]   // SomeTimes ImageBounds Returns Wrong Bounds ( Bug MayB ) So We re replacing with LineOrigins
            
            lineBounds.append(lineBox)
            
            let totalGlyphRuns = line.glyphRuns() // Get Total GlyphRuns In Single Line
            guard !totalGlyphRuns.isEmpty else {
                continue
            }
            for grIndex in 0..<totalGlyphRuns.count {
                let run = totalGlyphRuns[grIndex] // Get Current Run
                let font = run.font // Get Run's Font
                
                let glyphs = run.glyphs() // All Glyps Inside Current Run
                let glyphPositions = run.glyphPositions() // All Glyph XY Inside Current Run
                              
                let glyphsBoundingRects =  font.boundingRects(of: glyphs) // All Glyphs Exact Bounds Inside Current Run
                
                
                var leftMostOrigin : CGPoint = lineBox.origin

                let glyphCount = min(glyphPositions.count, glyphsBoundingRects.count)
                guard glyphCount > 0 else {
                    continue
                }
                for gpIndex in 0 ..< glyphCount { // iterating through every glyphs
                    
                    let glyphOrigin = glyphPositions[gpIndex] // Current Glyph XY
                    let glyphBounds = glyphsBoundingRects [gpIndex] // Current Glyph Rect
            
                    var glyphBox = glyphBounds // Update Glyph Box With Respect To Ref Size
                    
                    glyphBox.origin.x += lineOrigins[loIndex].x + glyphOrigin.x // LineOrigin X + Glyph Origin X
                    glyphBox.origin.y +=   lineOrigins[loIndex].y + glyphOrigin.y  // LineOrigin Y + Glyph Origin Y
                    
                    let minXofGlyph = min(glyphBox.origin.x,leftMostOrigin.x) // get minimum X Value
                    let maxXofGlyph = max(rightMostX,glyphBox.maxX) // get maximum X Value
        
                    let minYofGlyph = min(leftMostOrigin.y,glyphBox.origin.y) // get minimum Y Value
                    let maxYofGlyph = max(topMostY,glyphBox.maxY) // get minimum Y Value
                    
                    /* If Line And Character Are First Then Take Their Origins Else Use Above min max XY  */
                    leftMostOrigin.x = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.x : minXofGlyph
                    rightMostX = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxX : maxXofGlyph
                    leftMostOrigin.y = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.y : minYofGlyph//-  box.height
                    topMostY = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxY : maxYofGlyph
//
//                    print("Line X : ",leftMostOrigin.x , "Line Y : ",leftMostOrigin.y )
//                    print("Line Hright : " , line.typographicHeight())
                  
                    ctx.setStrokeColor(UIColor.black.cgColor)
                    ctx.setLineWidth(1.0)
                  //  ctx.translateBy(x: glyphBox.minX , y: 0)

                  //  ctx.stroke(glyphBox)
                     
                    
                } // Total Glyphs Positions In One Run Ends Here
                
                /* UPdate Current Line Origins To Minimum XY After Every Run ( Its Posible That Second Or Third Or 4th Word X is minimum Than First Character Or Word In Line */
                lineBounds[loIndex].origin.x =  min(lineBounds[loIndex].origin.x,leftMostOrigin.x)
                lineBounds[loIndex].origin.y =   min(lineBounds[loIndex].origin.y,leftMostOrigin.y)
                
            } // Total Runs In Line Ends here
                
            
            let minXofLine = min(lineBounds[loIndex].origin.x,mainBound.origin.x)
            let maxXofLine = max(maxX,rightMostX)
            
            let minYofLine = min(lineBounds[loIndex].origin.y,mainBound.origin.y)
            let maxYofLine = max(maxY,topMostY)
          
            /* If Line Is First Then Take Its  XY Else Use Above min max XY  */
            mainBound.origin.x = loIndex == 0 ?  lineBounds[loIndex].origin.x : minXofLine // We Got Our Exact Origin X
            mainBound.origin.y = loIndex == 0 ?  lineBounds[loIndex].origin.y : minYofLine // We Got Our Exact Origin Y
            
            minX = mainBound.origin.x
            maxX = maxX <= minX ? rightMostX : maxXofLine
            mainBound.size.width = maxX - minX // We Got Our Exact Width
            minY = mainBound.origin.y
            maxY = maxY <= minY ? topMostY : maxYofLine
            mainBound.size.height =  maxY - minY // We Got Our Exact Height
//            mainBound.origin.y = (refSize.height - height) / 2
          //  let testFont =   CTFontCreateWithName(properties.fontName as CFString,CGFloat(each) , nil)

            
          
            
           
        } // Total Lines In CTFrame Ends Here
        let frmeSetter = attributedString.framesetter()
         let frameSize = frmeSetter.frameSize(suggested: CGSize(width: maxWidth, height: maxHeight))
        
        // Add Margin ( 5 % of min of Width And Height )
        //print("EXACT BOUNDS : ", mainBound)
        let oneMoreFrame = attributedString.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), context: nil)
        print("NK EXACT BOUNDS : \(mainBound) , \(attributedString.string) Frame Size \(frameSize) First Height \(maxY - minY) OneMoreFrame \(oneMoreFrame)"  )
       
       
        
        /* By Default XY Alignment In Center*/
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0

        var xAlign = textProperties.textGravity
        var yAlign = CTAlignmentY.center
        
        switch xAlign {
        case .Center:
            xOffset = ((refSize.width/2) - (mainBound.origin.x + (mainBound.width/2)))
        case .Left:
            xOffset = -mainBound.origin.x
        case .Right:
            xOffset = refSize.width - (mainBound.origin.x + (mainBound.width));
        }
        
        switch yAlign {
        case .center:
            yOffset = ((refSize.height/2) - (mainBound.origin.y + (mainBound.height/2)))
        case .bottom:
            yOffset = -mainBound.origin.y
        case .top:
            yOffset = refSize.height - (mainBound.origin.y + (mainBound.height));
        }
        
        ctx.translateBy(x: xOffset , y: yOffset)

//        ctx.setStrokeColor(UIColor.white.cgColor)
//        ctx.setLineWidth(1.0)
//        ctx.stroke(mainBound)
        frame.draw(in: ctx)
        if paddingInPerc != 0 {
            
        let margin = ( paddingInPerc / 100 ) * min(mainBound.width,mainBound.height)
       var b = mainBound
            b.origin.x -= margin
            b.origin.y -= margin
            b.size.width += 2*margin
            b.size.height += 2*margin
        
        
       
             print("Marginal Bounds : " , mainBound)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        ctx.setLineWidth(1.0)
        ctx.stroke(b)
       
       
        }
        
        print("FinalRect:",finalRect)
        print("boundingBoxHeight:",boundingBoxHeight)

        
//       let image2 = convertTextToImageCTNew(attributedString: attributedString, refFrameSize: refSize, textBounds: mainBound)
        let image = UIGraphicsGetImageFromCurrentImageContext()
       print(image)
        UIGraphicsEndImageContext()
        
        
        return image ?? nil
    }
//    func jdTextMarginBounds(refSize:CGSize , attributedString : NSMutableAttributedString,properties:TextProperties, maxWidth : CGFloat = .infinity, maxHeight:CGFloat = .infinity , isHeightConstraint : Bool = false,paddingInPerc : CGFloat = 0 ) -> CGRect {
//        
//        var mainBound = CGRect.zero
//        var minX = CGFloat.zero
//        var maxX = CGFloat.zero
//        var minY = CGFloat.zero
//        var maxY = CGFloat.zero
//        
//        var rightMostX = CGFloat.zero
//        var topMostY = CGFloat.zero
//        
//        var lineBounds = [CGRect]()
//        var wordBounds = [CGRect]()
//        var letterBounds = [CGRect]()
//        
//        UIGraphicsBeginImageContext(refSize)
//        
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//            return .zero
//        }
//
//        // Flip Context From MacOS to iOS
//        ctx.textMatrix = .identity
//        ctx.translateBy(x: 0, y: refSize.height)
//        ctx.scaleBy(x: 1.0, y: -1.0)
//        
//        /* Note :- Current Context XY = (0,0) is At Left Bottom */
//        
//        // convert frame to CTFrame For further CoreText Based Calculation ( lines,run and glyphs )
//        let frame = getCTFrame(maxWidth: maxWidth,maxHeight: maxHeight, attributedString: attributedString)
//        
//        let extractedString = extractText(from: frame, attributedString: attributedString)
////        if extractedString.isEmpty || extractedString == "" {
////            return .zero
////        }
////        let isValid = isValisWordWrap(text: extractedString)
////        printLog("ISVALID_",isValid)
////        if !isValid {
////            return .zero
////        }
//        
//        let font = attributedString.attribute(.font, at: 0, effectiveRange: nil) as! UIFont
//        let paraStyle = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as! NSParagraphStyle
//
//        let testFont =   CTFontCreateWithName( font.fontName as CFString,CGFloat(font.pointSize) , nil)
//         let rect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], context: nil)
//
//
//         
//         let boundingBox = CTFontGetBoundingBox(testFont)
//         let top = boundingBox.origin.y + boundingBox.size.height
//         let bottom = boundingBox.origin.y
//        // print("JDText_1.ExactBonuds:\(size.size),ASR:\(size.width/size.height),fontSize: \( properties1.fontSize)")
//      //   print("JDText_2.frameSize:\(frameSize),ASR2:\(frameSize.width/frameSize.height),fontSize: \( properties1.fontSize)")
//        print("JDText_1.boundingRect:\(rect.size),ASR2:\( rect.size.width/rect.size.height),fontSize: \( font.pointSize)")
//               print("JDText_2:top:",top , "bottom",bottom)
//         print("JDText_3:BoundingBox : \(boundingBox)")
//        var letHeight = CGFloat(extractedString.lines.count) * boundingBox.height + ((paraStyle.lineHeightMultiple - 1 ) * font.lineHeight)
//        
//        var boundingBoxHeight = rect.height
//
//         //print("JDText_4.typographicHeight:\(textHeight),fontSize: \( properties1.fontSize)")
//      //  let rect = att.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
//
//         var finalSize = CGSize(width: (rect.width), height: (letHeight))
//        var  finalRect = CGRect(x: 0, y: 0, width: rect.width, height: letHeight)
//
//       // return finalRect
//        // print("TextMarginBounds",finalSize,"fontSize",mid)
//        
//       // frame.draw(in: ctx)
//        // get Origins Of Every Line
//        var lineOrigins = frame.lineOrigins()
//        
//        // get total Lines
//        var lines = frame.lines()
//        
//        var height : CGFloat = 0
//        for loIndex in 0 ..< lineOrigins.count {
//            let line = lines[loIndex]
//               
//            ctx.textPosition = .zero  // set Context Text Start Position To Zero ( Helps CT to return Glyph bounds with respect to zero origin )
//           
//            height = height +  line.typographicHeight()
//            if attributedString.string == "BIRTHDAY PARTY"{
//                print("NKk EXACT BOUNDS : \(height) , \(attributedString.string)"  )
//            }
//            var lineBox = line.imageBounds(in: ctx) // get LineBox Of Current Line
//          
//            lineBox.origin = lineOrigins[loIndex]   // SomeTimes ImageBounds Returns Wrong Bounds ( Bug MayB ) So We re replacing with LineOrigins
//            
//            lineBounds.append(lineBox)
//            
//            let totalGlyphRuns = line.glyphRuns() // Get Total GlyphRuns In Single Line
//            
//            for grIndex in 0...totalGlyphRuns.count - 1 {
//                let run = totalGlyphRuns[grIndex] // Get Current Run
//                let font = run.font // Get Run's Font
//                
//                let glyphs = run.glyphs() // All Glyps Inside Current Run
//                let glyphPositions = run.glyphPositions() // All Glyph XY Inside Current Run
//                              
//                let glyphsBoundingRects =  font.boundingRects(of: glyphs) // All Glyphs Exact Bounds Inside Current Run
//                
//                
//                var leftMostOrigin : CGPoint = lineBox.origin
//
//                for gpIndex in 0 ..< glyphPositions.count { // iterating through every glyphs
//                    
//                    let glyphOrigin = glyphPositions[gpIndex] // Current Glyph XY
//                    let glyphBounds = glyphsBoundingRects [gpIndex] // Current Glyph Rect
//            
//                    var glyphBox = glyphBounds // Update Glyph Box With Respect To Ref Size
//                    
//                    glyphBox.origin.x += lineOrigins[loIndex].x + glyphOrigin.x // LineOrigin X + Glyph Origin X
//                    glyphBox.origin.y +=   lineOrigins[loIndex].y + glyphOrigin.y  // LineOrigin Y + Glyph Origin Y
//                    
//                    let minXofGlyph = min(glyphBox.origin.x,leftMostOrigin.x) // get minimum X Value
//                    let maxXofGlyph = max(rightMostX,glyphBox.maxX) // get maximum X Value
//        
//                    let minYofGlyph = min(leftMostOrigin.y,glyphBox.origin.y) // get minimum Y Value
//                    let maxYofGlyph = max(topMostY,glyphBox.maxY) // get minimum Y Value
//                    
//                    /* If Line And Character Are First Then Take Their Origins Else Use Above min max XY  */
//                    leftMostOrigin.x = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.x : minXofGlyph
//                    rightMostX = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxX : maxXofGlyph
//                    leftMostOrigin.y = (grIndex == 0 && gpIndex == 0) ? glyphBox.origin.y : minYofGlyph//-  box.height
//                    topMostY = (grIndex == 0 && gpIndex == 0) ? glyphBox.maxY : maxYofGlyph
////
////                    print("Line X : ",leftMostOrigin.x , "Line Y : ",leftMostOrigin.y )
////                    print("Line Hright : " , line.typographicHeight())
//                  
//                    ctx.setStrokeColor(UIColor.black.cgColor)
//                    ctx.setLineWidth(1.0)
//                  //  ctx.translateBy(x: glyphBox.minX , y: 0)
//
//                    ctx.stroke(glyphBox)
//                     
//                    
//                } // Total Glyphs Positions In One Run Ends Here
//                
//                /* UPdate Current Line Origins To Minimum XY After Every Run ( Its Posible That Second Or Third Or 4th Word X is minimum Than First Character Or Word In Line */
//                lineBounds[loIndex].origin.x =  min(lineBounds[loIndex].origin.x,leftMostOrigin.x)
//                lineBounds[loIndex].origin.y =   min(lineBounds[loIndex].origin.y,leftMostOrigin.y)
//                
//            } // Total Runs In Line Ends here
//                
//            
//            let minXofLine = min(lineBounds[loIndex].origin.x,mainBound.origin.x)
//            let maxXofLine = max(maxX,rightMostX)
//            
//            let minYofLine = min(lineBounds[loIndex].origin.y,mainBound.origin.y)
//            let maxYofLine = max(maxY,topMostY)
//          
//            /* If Line Is First Then Take Its  XY Else Use Above min max XY  */
//            mainBound.origin.x = loIndex == 0 ?  lineBounds[loIndex].origin.x : minXofLine // We Got Our Exact Origin X
//            mainBound.origin.y = loIndex == 0 ?  lineBounds[loIndex].origin.y : minYofLine // We Got Our Exact Origin Y
//            
//            minX = mainBound.origin.x
//            maxX = maxX <= minX ? rightMostX : maxXofLine
//            mainBound.size.width = maxX - minX // We Got Our Exact Width
//            minY = mainBound.origin.y
//            maxY = maxY <= minY ? topMostY : maxYofLine
//            mainBound.size.height =  maxY - minY // We Got Our Exact Height
////            mainBound.origin.y = (refSize.height - height) / 2
//          //  let testFont =   CTFontCreateWithName(properties.fontName as CFString,CGFloat(each) , nil)
//
//            
//          
//            
//           
//        } // Total Lines In CTFrame Ends Here
//        let frmeSetter = attributedString.framesetter()
//         let frameSize = frmeSetter.frameSize(suggested: CGSize(width: maxWidth, height: maxHeight))
//        
//        // Add Margin ( 5 % of min of Width And Height )
//        //print("EXACT BOUNDS : ", mainBound)
//        let oneMoreFrame = attributedString.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), context: nil)
//        print("NK EXACT BOUNDS : \(mainBound) , \(attributedString.string) Frame Size \(frameSize) First Height \(maxY - minY) OneMoreFrame \(oneMoreFrame)"  )
//       
//       
//        
//        /* By Default XY Alignment In Center*/
//        var xOffset : CGFloat = 0
//        var yOffset : CGFloat = 0
//
//        var xAlign = CTAlignmentX.center
//        var yAlign = CTAlignmentY.center
//        
//        switch xAlign {
//        case .center:
//            xOffset = ((refSize.width/2) - (mainBound.origin.x + (mainBound.width/2)))
//        case .left:
//            xOffset = -mainBound.origin.x
//        case .right:
//            xOffset = refSize.width - (mainBound.origin.x + (mainBound.width));
//        }
//        switch yAlign {
//        case .center:
//            yOffset = ((refSize.height/2) - (mainBound.origin.y + (mainBound.height/2)))
//        case .bottom:
//            yOffset = -mainBound.origin.y
//        case .top:
//            yOffset = refSize.height - (mainBound.origin.y + (mainBound.height));
//        }
//        
//        ctx.translateBy(x: xOffset , y: yOffset)
//
//        ctx.setStrokeColor(UIColor.white.cgColor)
//        ctx.setLineWidth(1.0)
//        ctx.stroke(mainBound)
//        frame.draw(in: ctx)
//        if paddingInPerc != 0 {
//            
//        let margin = ( paddingInPerc / 100 ) * min(mainBound.width,mainBound.height)
//       var b = mainBound
//            b.origin.x -= margin
//            b.origin.y -= margin
//            b.size.width += 2*margin
//            b.size.height += 2*margin
//        
//        
//       
//        print("Marginal Bounds : " , mainBound)
//        ctx.setStrokeColor(UIColor.blue.cgColor)
//        ctx.setLineWidth(1.0)
//        ctx.stroke(b)
//       
//       
//        }
//        
//        print("FinalRect:",finalRect)
//        print("boundingBoxHeight:",boundingBoxHeight)
//
//        print("\(font.pointSize):MB:\(mainBound.origin.x):\(mainBound.origin.y):\(mainBound.width):\(mainBound.height):BR:\(finalRect.origin.x):\(finalRect.origin.y):\(finalRect.width):\(finalRect.height):MH:\(boundingBoxHeight):LH:\(font.lineHeight):NOL:\(extractedString.lines.count)")
//        
////       let image2 = convertTextToImageCTNew(attributedString: attributedString, refFrameSize: refSize, textBounds: mainBound)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//       print(image)
//        UIGraphicsEndImageContext()
//        
//        let image1 = convertTextToImageCTNew2(text: attributedString.string, properties: properties, refFrameSize: refSize, textBounds: mainBound, maxWidth: refSize.width)
//        
//        return mainBound
//    }
    func extractText(from frame: CTFrame, attributedString: NSAttributedString, logger: PackageLogger?) -> String {
        var extractedText = ""
        
        // Get the lines from the CTFrame
        let lines = CTFrameGetLines(frame) as! [CTLine]
        let lineOrigins = frame.lineOrigins()
        
        var currentLineY =  lineOrigins.first?.y ?? 0.0
    
        // Iterate over each line
        for (index,line) in lines.enumerated() {
            // Get the runs in the line
            let runs = CTLineGetGlyphRuns(line) as! [CTRun]
            
            for run in runs {
                
                // Get the range of the text in this run
                let range = CTRunGetStringRange(run)
                let nsRange = NSRange(location: range.location, length: range.length)
                
                // Extract the text for this run from the original attributed string
                let substring = attributedString.attributedSubstring(from: nsRange).string
                
                // Print debug information
                print("Run: \(substring), Range: \(range), nsRange: \(nsRange)")
               
                
                if currentLineY != lineOrigins[index].y {
                    currentLineY = lineOrigins[index].y
                     extractedText.append("\n")
                
                }
                 extractedText.append(substring)
            }
            
            // Optionally add a newline or space if you want to preserve the line structure
           // extractedText.append("\n")
        }
        logger?.printLog("TT_ \(extractedText)")
        
       return extractedText
    }

    
    func isValisWordWrap(text:String) -> Bool {
        let textLines = text.lines

        for (index,line) in textLines.enumerated() {
            
            let endCharacter = line.last
            if index < (textLines.count - 1) && line.count > 1 && endCharacter != " " {
                print("InValid Wrap")
                return false
            }
        }
        return true
    }
//    func convertTextToImageCTNew2(text:String , properties: TextProperties, refFrameSize:CGSize, textBounds : CGRect ,xAlign : HTextGravity = .Center, bgColor : UIColor = .clear, maxWidth: CGFloat , maxHeight:CGFloat = .infinity) -> UIImage?{
//        
//        let attributedString = text.getAtrributedString(textProperties: properties, ignoreSpacing: false)
//
////        var scaleFactor : CGFloat =  UIApplication.shared.cWindow?.screen.nativeScale ?? 1
////        print("Content Scale Factor : \(scaleFactor) ")
//        UIGraphicsBeginImageContext(refFrameSize)
//        
//        
//        
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//          return nil
//        }
//        
//        bgColor.setFill()
//        ctx.fill(CGRect(origin: .zero, size: refFrameSize))
//        ctx.textMatrix = .identity
//        ctx.translateBy(x: 0, y: refFrameSize.height)
//        ctx.scaleBy(x: 1.0, y: -1.0)
//        
//       
//       
////        let frame = attributedString.framesetter().createFrame(CGRect(origin: .zero, size: refFrameSize))
//        let frmeSetter = attributedString.framesetter()
//        let frameSize = frmeSetter.frameSize(suggested: CGSize(width: maxWidth, height: maxHeight))
//        let frame = attributedString.framesetter().createFrame(CGRect(origin: .zero, size: frameSize))
//
//      //  let string = extractText(from: frame, attributedString: attributedString)
//        
//        /* By Default XY Alignment In Center*/
//        var xOffset : CGFloat = 0
//        var yOffset : CGFloat = 0
//
//        switch xAlign {
//        case .Center:
//            xOffset = ((refFrameSize.width/2) - (textBounds.origin.x + (textBounds.width/2)))
//        case .Left:
//            xOffset = -textBounds.origin.x
//        case .Right:
//            xOffset = refFrameSize.width - (textBounds.origin.x + (textBounds.width));
//        }
//        switch CTAlignmentY.center {
//        case .center:
//            yOffset = ((refFrameSize.height/2) - (textBounds.origin.y + (textBounds.height/2)))
//        case .bottom:
//            yOffset = -textBounds.origin.y
//        case .top:
//            yOffset = refFrameSize.height - (textBounds.origin.y + (textBounds.height));
//        }
//
//        
//       
//       // ctx.translateBy(x:-textBounds.origin.x, y: 0)
//        if attributedString.string != "" {
//            if properties.bgType == 2.0{
//                let bgColor = properties.backgroundColor.withAlphaComponent(CGFloat(properties.bgAlpha))
//                bgColor.setFill()
//            }else{
//                UIColor.clear.setFill()
//            }
//            ctx.fill(CGRect(origin: CGPoint.zero, size: refFrameSize))
//
//            ctx.translateBy(x: xOffset , y: yOffset)
//           // attributedString.draw(in: textBounds)
//            frame.draw(in: ctx)
////            ctx.setStrokeColor(UIColor.white.cgColor)
////            ctx.stroke(textBounds)
//
//        }
//        
//        
//      //  ctx.translateBy(x: -xOffset , y: - yOffset)
//        let textImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return textImage
//        
//    }

//    func getExactFontSize3(widthMarginInPerc : CGFloat = 0,heightMarginInPerc : CGFloat = 0, userText : String , properties : TextProperties, refSize : CGSize, maxWidth:CGFloat,maxHeight:CGFloat) -> CGFloat {
////        let margin = ( marginInPerc / 100 ) * (min(refSize.width,refSize.height)) // extra padding to give fontSize breathing space
////        if userText == "Christmas Party" {
////           // var fSize = 0
////            for each in 20...200 {
////                //for each in stride(from: 0.01, to: 1.00, by: 0.01) {
////               
////                   // fSize = Int(each)
////                var properties1 = properties
////                properties1.fontSize = CGFloat(each)
////               // properties1.letterSpacing = Float(0.22)
////                //            autoreleasepool {
////                
////                // let exactBounds1 = CTCalculator().getJDTextSize(refSize: refSize, attributedString: userText.getAtrributedString(textProperties: properties1, ignoreSpacing: false))
////                
////              
////                //AdjustedWidth
////                //  let exactBounds1 = CTCalculator().getExactBounds(refSize: refSize, attributedString: userText.getAtrributedString(textProperties: properties1,ignoreSpacing: false),maxWidth: maxWidth , maxHeight: maxHeight)
////                let  attributedString = userText.getAtrributedString(textProperties: properties1,ignoreSpacing: false)
////                let frmeSetter = attributedString.framesetter()
////                let frameSize = frmeSetter.frameSize(suggested: CGSize(width: maxWidth, height: .infinity))
////                
////                let containerSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
////                let textRect = CGRect(origin: .zero, size: containerSize)
////                let path = CGMutablePath()
////                path.addRect(textRect)
////                
////                let frame = CTFramesetterCreateFrame(frmeSetter, CFRangeMake(0, attributedString.length), path, nil)
////                
////                var textHeight : CGFloat = 0
////                frame.lines().forEach { line in
////                    textHeight += line.typographicHeight()
////                }
////            
////                
////                let rect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
////            
////                let size2 = getJDTextSize(refSize: CGSize(width: maxWidth, height: textHeight), attributedString: attributedString)
////                let size = getExactBounds(refSize: refSize, attributedString: attributedString,maxWidth: maxWidth , maxHeight:maxHeight)
////                
////                let testFont =   CTFontCreateWithName(properties.fontName as CFString,CGFloat(each) , nil)
////
////               // attributedString.size()
////                let boundingBox = CTFontGetBoundingBox(testFont)
////                let top = boundingBox.origin.y + boundingBox.size.height
////                let bottom = boundingBox.origin.y
////                print("JDText_1.ExactBonuds:\(size.size),ASR:\(size.width/size.height),fontSize: \( properties1.fontSize)")
////                print("JDText_2.frameSize:\(frameSize),ASR2:\(frameSize.width/frameSize.height),fontSize: \( properties1.fontSize)")
////                print("TextMargin fontSize:  \( properties1.fontSize) width: \(rect.size.width), height: \(boundingBox.height), \( properties1.letterSpacing)" )
////                print("JDText_1.boundingRect:\(rect.size),ASR2:\( rect.size.width/rect.size.height),fontSize: \( properties1.fontSize)")
//////                     // print("JDText_2:top:",top , "bottom",bottom)
//////                print("JDText_3:BoundingBox : \(boundingBox)")
//////
//////                print("JDText_4.typographicHeight:\(textHeight),fontSize: \( properties1.fontSize)")
////                
//////                if boundingBox.size.height >= refSize.height  && rect.size.width >= refSize.height {
//////                    break
//////                }else{
//////                    continue;
//////
//////                }
////                
////            }
////           // return CGFloat(fSize)
////
////        }
//        
//        let widthMargin = ( 5 / 100 ) * ( maxWidth)
//        let heightMargin =  ( 5 / 100 ) * ( refSize.height)
//        let adjustedWidth = maxWidth - 2 * widthMargin
//        let adjustedHeight = refSize.height - 2 * heightMargin
//        var hi:Int = 1000
//        var lo: Int = 1
//        var mid:Int = (Int)(hi + lo)/2
//      
//        var b = CGSize.zero
//        repeat {
//           // autoreleasepool {
//            let middleFont = UIFont(name: properties.fontName, size: CGFloat(mid))!
//
//            var properties1 = properties
//            properties1.fontSize = CGFloat(mid)
////            autoreleasepool {
//                
//                // let exactBounds1 = CTCalculator().getJDTextSize(refSize: refSize, attributedString: userText.getAtrributedString(textProperties: properties1, ignoreSpacing: false))
//                
//                //AdjustedWidth
//            let exactBounds1 = CTCalculator().getExactBounds(refSize: CGSize(width: adjustedWidth, height: adjustedHeight), attributedString: userText.getAtrributedString(textProperties: properties1,ignoreSpacing: false),maxWidth: maxWidth , maxHeight: maxHeight)
//            let test = CTCalculator().jdTextMarginBounds(refSize:  CGSize(width: adjustedWidth, height: adjustedHeight), attributedString: userText.getAtrributedString(textProperties: properties1,ignoreSpacing: false), properties: properties1,maxWidth: maxWidth)
//            
//           let attributedSting = userText.getAtrributedString(textProperties: properties1,ignoreSpacing: false)
//            let testFont =   CTFontCreateWithName(properties.fontName as CFString,CGFloat(mid) , nil)
//            let rect = attributedSting.boundingRect(with: CGSize(width: maxWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], context: nil)
//
//
//            
//            let boundingBox = CTFontGetBoundingBox(testFont)
//            let top = boundingBox.origin.y + boundingBox.size.height
//            let bottom = boundingBox.origin.y
//           // print("JDText_1.ExactBonuds:\(size.size),ASR:\(size.width/size.height),fontSize: \( properties1.fontSize)")
//         //   print("JDText_2.frameSize:\(frameSize),ASR2:\(frameSize.width/frameSize.height),fontSize: \( properties1.fontSize)")
//            print("JDText_1.boundingRect:\(rect.size),ASR2:\( rect.size.width/rect.size.height),fontSize: \( properties1.fontSize)")
//                  print("JDText_2:top:",top , "bottom",bottom)
//            print("JDText_3:BoundingBox : \(boundingBox)")
//
//            //print("JDText_4.typographicHeight:\(textHeight),fontSize: \( properties1.fontSize)")
//            
//            var finalSize = CGSize(width: (rect.width), height: (rect.height))
//            print("TextMarginBounds",finalSize,"fontSize",mid)
//                //userText.bestBoundingRect(properties: properties1 , ignoreSpacing: false)
//            let exactBounds = exactBounds1.size
//                //  let exactBounds = getExactBounds(refSize: refSize, font: middleFont, userText: userText , isWidthConstraint: isWidthConstraint, isHeightConstraint: isHeightConstraint ,paddingInPerc: marginInPerc) // Get Exact Bounds With Current Font Size
//                
//                if exactBounds == CGSize.zero { // Font Size Too Large : reduce Font Size
//                    hi = mid - 1
//                } else
//                //        if !isWidthConstraint && isHeightConstraint{
//                //
//                //                            if exactBounds.height + margin <= refSize.height {
//                //                                    lo = mid + 1
//                //                            } else{
//                //                                    hi = mid - 1
//                //                            }
//                //        }else
//                //        if   isWidthConstraint && !isHeightConstraint{
//                //                            if exactBounds.width + margin <= refSize.width {
//                //                                    lo = mid + 1
//                //                            } else{
//                //                                hi = mid - 1
//                //                            }
//                //        }else
//                //AdjustedHegight and Width
//            if exactBounds.height <= ceil(adjustedHeight)  && exactBounds.width <= ceil(adjustedWidth){
//                    lo = mid + 1
//                } else{ // too big
//                    hi = mid - 1
//                }
//                
//                mid = (Int)(hi + lo)/2
//                b = exactBounds
////            }
//    } while lo <= hi // When Low Value Crosses High Value Thats Our BEst FOnt
//        
//        print("Bounds: ", b , mid)
//        return CGFloat(mid)
//    }
    
//    func getExactFontSize2(with marginInPerc : CGFloat = 15, attributedString : NSMutableAttributedString, textProperties: TextProperties , refSize : CGSize, isWidthConstraint : Bool = false , isHeightConstraint : Bool = false) -> CGFloat {
//        
//        let margin = ( marginInPerc / 100 ) * (min(refSize.width,refSize.height)) // extra padding to give fontSize breathing space
//        var hi:Int = 1000
//        var lo: Int = 1
//        var mid:Int = (Int)(hi + lo)/2
//      
//        var b = CGRect.zero
//        repeat {
//           // autoreleasepool {
//            let middleFont = UIFont(name: textProperties.fontName, size: CGFloat(mid))!
//            
////            let exactBounds = getExactBounds(refSize: refSize, font: middleFont, userText: userText , isWidthConstraint: isWidthConstraint, isHeightConstraint: isHeightConstraint ,paddingInPerc: marginInPerc) // Get Exact Bounds With Current Font Size
////
////            if exactBounds == CGRect.zero { // Font Size Too Large : reduce Font Size
////                hi = mid - 1
////            }
//////            else if !isWidthConstraint && isHeightConstraint{
//////
//////                    if exactBounds.height + margin <= refSize.height {
//////                            lo = mid + 1
//////                    } else{
//////                            hi = mid - 1
//////                    }
//////            }else if   isWidthConstraint && !isHeightConstraint{
//////                    if exactBounds.width + margin <= exactBounds.width {
//////                            lo = mid + 1
//////                    } else{
//////                        hi = mid - 1
//////                    }
//////            }
////            else if exactBounds.height + margin <= exactBounds.height  && exactBounds.width + margin <= refSize.width{
////                lo = mid + 1
////            } else{
////                hi = mid - 1
////            }
////           // }
////
////            mid = (Int)(hi + lo)/2
////        } while lo <= hi // When Low Value Crosses High Value Thats Our BEst FOnt
//            
//            autoreleasepool {
//
//                let exactBounds = CGRect.zero //getExactBounds(refSize: refSize, attributedString: attributedString , isWidthConstraint: isWidthConstraint, isHeightConstraint: isHeightConstraint ,paddingInPerc: marginInPerc) // Get Exact Bounds With Current Font Size
//        
//        if exactBounds == CGRect.zero { // Font Size Too Large : reduce Font Size
//            hi = mid - 1
//        } else
//        if !isWidthConstraint && isHeightConstraint{
//        
//                            if exactBounds.height + margin <= refSize.height {
//                                    lo = mid + 1
//                            } else{
//                                    hi = mid - 1
//                            }
//        }else
//        if   isWidthConstraint && !isHeightConstraint{
//                            if exactBounds.width + margin <= refSize.width {
//                                    lo = mid + 1
//                            } else{
//                                hi = mid - 1
//                            }
//        }else
//        if exactBounds.height + margin <= refSize.height  && exactBounds.width + margin <= refSize.width{
//            lo = mid + 1
//        } else{
//            hi = mid - 1
//        }
//        
//        mid = (Int)(hi + lo)/2
//                b = exactBounds
//            }
//    } while lo <= hi // When Low Value Crosses High Value Thats Our BEst FOnt
//        
//        print("Bounds: ", b)
//        return CGFloat(mid)
//    }

}


class TextBreaker {
    
    struct TextOutput {
        var image: UIImage
        var bounds : CGRect = .zero
        var fontSize : CGFloat = .zero
        var lineCount : Int = .zero
    }
    
   
    
//    func getTextOutputForText(text:String,properties:TextProperties ,refSize:CGSize, marginWidthPerc : CGFloat = 0 , marginHeightPerc : CGFloat = 0) -> TextOutput {
//        
//        var heightMargin = refSize.height * (marginHeightPerc/100)
//        var widthMargin = refSize.width * (marginWidthPerc/100)
//
//        // Calculate the adjusted rect
//        let adjustedRect = CGRect(
//            x: 0,
//            y: 0,
//            width: refSize.width - (4 * widthMargin),
//            height: refSize.height - (2 * heightMargin)
//        )
//        
//        var fontSize : CGFloat = 1
//        
//        if adjustedRect.size.width < 1 || adjustedRect.size.height < 1 {
//            printLog("JD Handle This Error With 1x1 Putput")
//            return TextOutput(image: UIImage(), bounds: .zero, fontSize: 1, lineCount: 1)
//        }
//        
//        fontSize = binarySearch(userText: text, properties: properties, refSize: adjustedRect.size)
//        var properties1 = properties
//        properties1.fontSize = fontSize
//        
//        let atbString = text.getAtrributedString(textProperties: properties1)
//        let frmeSetter = atbString.framesetter()
//        let frameSize = frmeSetter.frameSize(suggested: CGSize(width:  adjustedRect.width , height:  .infinity))
//        let frame = atbString.framesetter().createFrame(CGRect(origin: .zero, size: frameSize))
//
//        
//        UIGraphicsBeginImageContext(refSize)
//        
//        
//        
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//            return TextOutput(image: UIImage(), bounds: .zero, fontSize: 1, lineCount: 1)
//
//        }
//            properties.backgroundColor.setFill()
//        ctx.fill(CGRect(origin: .zero, size: refSize))
//          
////            UIColor.red.setFill()
////           // ctx.fill(CGRect(origin: .zero, size: textBounds2.size))
////            ctx.stroke(CGRect(origin: textBounds2.origin, size: textBounds2.size))
//        ctx.textMatrix = .identity
//        ctx.translateBy(x: 0, y: refSize.height)
//        ctx.scaleBy(x: 1.0, y: -1.0)
//        
//       
//       
//        
//  
//
////        let x = frame.lineOrigins().map({$0.x}).min() ?? 0
////        let y = frame.lineOrigins().map({$0.y}).min() ?? 0
//        
//        var xOffset : CGFloat = 0
//        var yOffset : CGFloat = 0
//
//            xOffset = ((refSize.width/2) - ( (frameSize.width/2)))
//          yOffset = ((refSize.height/2) - ( (frameSize.height/2)))
//
////        /* By Default XY Alignment In Center*/
////
////            switch userProperties.textGravity.alignmentOfText() {
////        case .center:
////            xOffset = ((refFrameSize.width/2) - ((textBounds.width/2)))
////        case .left:
////            xOffset = -x
////        case .right:
////            xOffset = refFrameSize.width - ( (textBounds2.width));
////            case .justified:
////                xOffset = ((refFrameSize.width/2) - ( (textBounds2.width/2)))
////            case .natural:
////                xOffset = ((refFrameSize.width/2) - (x + (textBounds2.width/2)))
////            @unknown default:
////                xOffset = ((refFrameSize.width/2) - (x + (textBounds2.width/2)))
////            }
////
//              // yOffset = ((refSize.height/2) - ( (textBounds2.height/2)))
//
////        switch yAlign {
////        case .center:
////        case .bottom:
////            yOffset = -textBounds.origin.y
////        case .top:
////            yOffset = refFrameSize.height - (textBounds.origin.y + (textBounds.height));
////        }
//
//       // ctx.translateBy(x:-textBounds.origin.x, y: 0)
//       // if userText != "" {
//            ctx.translateBy(x: xOffset , y: yOffset)
//            frame.draw(in: ctx)
////            ctx.translateBy(x: -xOffset , y: -yOffset)
////            ctx.setStrokeColor(UIColor.black.cgColor)
////
////            ctx.stroke(CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: textBounds))
////
////           
////            ctx.setStrokeColor(UIColor.green.cgColor)
////           // ctx.fill(CGRect(origin: .zero, size: textBounds2.size))
////            ctx.stroke(CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: textBounds2.size))
//
////        }else{
////            textColor.setFill()
////            ctx.fill(CGRect(origin: CGPoint.zero, size: textBounds.size))
////
////        }
//      //  ctx.translateBy(x: -xOffset , y: - yOffset)
//        let textImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return TextOutput(image: textImage!)
//        
//    }
    
  
    
    
    
//    func calculateTextBounds(refSize:CGSize , attributedString : NSMutableAttributedString, isWidthConstraint:Bool = true , isHeightConstraint : Bool = false) -> CGRect  {
//        
//        // convert frame to CTFrame For further CoreText Based Calculation ( lines,run and glyphs )
////        let frame = getCTFrame(refSize: refSize, attributedString: attributedString ,isWidthConstraint: isWidthConstraint , isHeightConstraint: isHeightConstraint)
//
//         let frmeSetter = attributedString.framesetter()
//         let frameSize = frmeSetter.frameSize(suggested: CGSize(width: isWidthConstraint ? refSize.width : CGFloat.infinity, height: isHeightConstraint ? refSize.height : .infinity))
//        let frame = attributedString.framesetter().createFrame(CGRect(origin: .zero, size: frameSize))
//
//       // frame.draw(in: ctx)
//        // get Origins Of Every Line
//        var lineOrigins = frame.lineOrigins()
//        
//        // get total Lines
//        var lines = frame.lines()
//        
//        print("Number Of Lines",lines.count)
//        print("Number Of Lines 2 ",lineOrigins.count)
//
//        let originX = lineOrigins.map({$0.x}).min()
//        let originY = lineOrigins.map({$0.y}).min()
//        let mainBounds = CGRect(origin: CGPoint(x: originX!, y: originY!), size: frameSize)
//        
//        return mainBounds
//        
//    }
//    func analyzeTextWrapping(text: String , properties:TextProperties,  availableSpace: CGSize) -> Int {
//       
//        let attributedString = text.getAtrributedString(textProperties: properties)
//        let maxWidth = availableSpace.width
//        
//        // Step 2: Create a CTFramesetter
//        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
//        
//        // Step 3: Create a path representing the text area (maxWidth and an unlimited height)
//        let path = CGPath(rect: CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude), transform: nil)
//        
//        // Step 4: Create a frame
//        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: attributedString.length), path, nil)
//        
//        // Step 5: Get the lines from the frame
//        let lines = CTFrameGetLines(frame) as! [CTLine]
//        
//        var maxLineWidth: CGFloat = 0
//        var totalHeight: CGFloat = 0
//        
//        // Step 6: Iterate over lines
//        for i in 0..<lines.count {
//            let line = lines[i]
//            
//            // Get the range of characters for this line
//            let range = CTLineGetStringRange(line)
//            let endIndex = range.location + range.length
//            
//            // Check if this is not the last line
//            if i < lines.count - 1 {
//                // Ensure there's at least one character in this line
//                if endIndex > 0 {
//                    // Check for invalid word wrapping
//                    let prevCharIndex = text.index(text.startIndex, offsetBy: endIndex - 1)
//                    let prevChar = text[prevCharIndex]
//                    
//                    // Check the next character only if it exists
//                    if endIndex < text.count {
//                        let nextCharIndex = text.index(text.startIndex, offsetBy: endIndex)
//                        let nextChar = text[nextCharIndex]
//                        
//                        // Validate word wrap based on provided logic
//                        if !isValidWordWrap(before: prevChar, after: nextChar) {
//                            return 1
//                        }
//                    }
//                }
//            }
//            
//            // Calculate the line width and height
//            var ascent: CGFloat = 0
//            var descent: CGFloat = 0
//            var leading: CGFloat = 0
//            let lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
//            let lineHeight = ascent + descent + leading
//            
//            // Update max line width if necessary
//            if CGFloat(lineWidth) > maxLineWidth {
//                maxLineWidth = CGFloat(lineWidth)
//            }
//            
//            // Add to total height
//            totalHeight += lineHeight
//        }
//        // Create a text rectangle with the calculated max width and total height
//        var textRect = CGRect(x: 0, y: 0, width: maxLineWidth, height: totalHeight)
//        
//        // Logic to compare textRect with availableSpace
//        if CGRect(origin: .zero, size: availableSpace).contains(textRect) {
//            // The textRect fits within available space; may be too small
//            return -1
//        } else {
//            // The textRect does not fit within available space
//            if textRect.width > availableSpace.width && textRect.height > availableSpace.height {
//                // Both width and height are too big
//                return 1
//            } else if textRect.width > availableSpace.width && textRect.height < availableSpace.height {
//                // Width is too big, but height has space to grow
//                return -1
//            } else {
//                // Height is too big, and width is smaller
//                return 1
//            }
//        }
//    }

    // Helper function to check valid word wrapping
//    func isValidWordWrap(before: Character, after: Character) -> Bool {
//        // Valid wrap only if the previous character is a space or hyphen
//        return before == " " || before == "-"
//    }
    
//    func binarySearch(userText : String , properties : TextProperties, refSize : CGSize) -> CGFloat {
//        
//        
//        var hi : Int = 1000
//        var lo: Int = 1
//        var mid:Int = (Int)(hi + lo)/2
//        var lastBest = 1
//        var b = CGSize.zero
//       // autoreleasepool {
//        repeat  {
//            let mid = (lo + hi) >> 1
//           // autoreleasepool {
//           // let middleFont = UIFont(name: properties.fontName, size: CGFloat(mid))!
//  
//            var properties1 = properties
//            properties1.fontSize = CGFloat(mid)
//            
//                
//                let doesFit = analyzeTextWrapping(text: userText, properties: properties1, availableSpace: refSize)
//                if doesFit < 0 {
//                            
//                            lo = mid + 1
//                            lastBest = lo
//                        } else if doesFit > 0 {
//                            hi = mid - 1
//                            lastBest = hi
//                        }
//            } while lo <= hi
//   // }
//        print("Bounds: ", b , mid)
//        return CGFloat(lastBest)
//    }
    
}

func drawTextAsImage(keepFontSizeFix:Bool, text: String, boundingBox: CGRect, textProperties: TextProperties, logger: PackageLogger?) -> (UIImage?, CGFloat)? {
    
    let userLanguage = Locale.userLanguageIdentifier
    var adjustedRect = CGRect.zero
//    let widthMargin = boundingBox.width * ( textProperties.externalWidthMargin / 100 )
//    let heightMargin = boundingBox.height * ( textProperties.externalHeightMargin / 100 )
//    adjustedRect.size.width = boundingBox.width - ( 4 * widthMargin )
//    adjustedRect.size.height = boundingBox.height - ( 2 * heightMargin )
    
    
    let width = boundingBox.width * 100 / (100 + (4 * textProperties.externalWidthMargin))
    let height = boundingBox.height * 100 / ( 100 + (2 * textProperties.externalHeightMargin))
    
    adjustedRect.size = CGSize(width: width, height: height)
    
    print("RNK \(adjustedRect)")
    
//    let adjustedWidth = boundingBox.width // This is the calculated width with margins
//    let adjustedHeight = boundingBox.height // This is the calculated height with margins
//
//    let widthMarginPercentage = (textProperties.externalWidthMargin * 100) / boundingBox.width
//    let heightMarginPercentage = (textProperties.externalHeightMargin * 100) / boundingBox.height
//
//    // Reverse the calculation to get the new size
//    let newWidth = (adjustedWidth * (100 / 4 - widthMarginPercentage)) / (100 / 4)
//    let newHeight = (adjustedHeight * (100 / 2 - heightMarginPercentage)) / (100 / 2)

    // Create the original newSize
//    adjustedRect.size = CGSize(width: round(newWidth), height: round(newHeight))
//    printLog("NSK adjustedHeight form Text \(adjustedRect)")

    var currentTextProperties = textProperties
    if !keepFontSizeFix {
        let fontSize = getOptimalFontSize(text: text, boundingBox: adjustedRect, textProperties: textProperties, suggestedWidth: adjustedRect.width)
        currentTextProperties.fontSize = CGFloat(fontSize)
    }
    
    let attributedString = text.getAtrributedString(textProperties: currentTextProperties)
    
    // Step 1: Set up the text storage, layout manager, and text container
    let textStorage = NSTextStorage(attributedString: attributedString)
    let textContainer = NSTextContainer(size: CGSize(width: adjustedRect.width, height: CGFloat.greatestFiniteMagnitude))
    textContainer.lineFragmentPadding = 0
    textContainer.maximumNumberOfLines = 0
    textContainer.lineBreakMode = .byWordWrapping
    
    let layoutManager = NSLayoutManager()
    textStorage.addLayoutManager(layoutManager)
    layoutManager.addTextContainer(textContainer)
    
//    UIGraphicsBeginImageContextWithOptions(boundingBox.size, false, 0)
//    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    // Fill the background with the provided background color
    
//     if text != "" {
//         if textProperties.bgType == 2.0{
//             let bgColor = textProperties.backgroundColor.withAlphaComponent(CGFloat(textProperties.bgAlpha))
//             bgColor.setFill()
//         }else{
//             UIColor.clear.setFill()
//         }
//         context.fill(CGRect(origin: CGPoint.zero, size: boundingBox.size))
//     }
    
  
//   // JDTest Debug
//    let debug = true
//
//    if debug {
//        context.setLineWidth(1)
//        context.setStrokeColor(UIColor.black.cgColor)
//    }
    
    var textRect = CGRect.zero

    // Step 5: Enumerate through the lines and draw them
    var currentY: CGFloat = 0.0
    var isValidWrap = true
    
//    layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(for: textContainer)) { (rect, usedRect, _, lineRange, glyphRange) in
//        // Draw each line as a rectangle to visualize the layout
//      //  context.stroke(rect)
//        textRect = textRect.union(rect)
//      //  let lineText = attributedString.attributedSubstring(from: lineRange)
//      //  lineText.draw(in: rect)
//        // Move to the next Y position for drawing
//     //   currentY += rect.height
//    }
//    // Step 6: Center the text in the bounding box
//       let dx = (boundingBox.width - textRect.width) / 2
//       let dy = (boundingBox.height - textRect.height) / 2
//
//       context.translateBy(x: dx, y: dy)
    
//    layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(for: textContainer)) { (rect, usedRect, _, lineRange, glyphRange) in
//        // Draw each line as a rectangle to visualize the layout
//        let heightOffset = rect.height
//        context.stroke(rect)
//        context.setFillColor(UIColor.red.cgColor)
//        context.fill([usedRect])
//      //  textRect = textRect.union(rect)
//        let lineText = attributedString.attributedSubstring(from: lineRange)
//        lineText.draw(in: rect)
//        // Move to the next Y position for drawing
//        currentY += rect.height
//    }
    
   // var getExactBounds = CTCalculator().getExactBounds(refSize: boundingBox.size, attributedString: attributedString,maxWidth: boundingBox.size.width)
    let newRect = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer)
//    print("Bounding Box From Get Bound \(newRect)")
    let preview = String(text.prefix(24))
    logger?.logErrorFirebase("[TextRenderBreadcrumb] lang=\(userLanguage) textLen=\(text.count) preview=\(preview) ref=\(boundingBox.size.width)x\(boundingBox.size.height) adjusted=\(adjustedRect.size.width)x\(adjustedRect.size.height) font=\(currentTextProperties.fontName) size=\(currentTextProperties.fontSize) maxW=\(newRect.width) threadMain=\(Thread.isMainThread)", record: false)
    var image2 = CTCalculator(logger: logger).drawImageCoreText(textProperties: currentTextProperties, refSize: boundingBox.size, attributedString: attributedString , maxWidth: newRect.width, logger: logger)
    
    //   Step 6: Generate the UIImage from the graphics context
    //   let image = UIGraphicsGetImageFromCurrentImageContext()
    //   UIGraphicsEndImageContext()
    //   print(image)
    
    logger?.logInfo("Create Text Image Info Completed : user language -> \(userLanguage), original Text -> \(text), ref width -> \(boundingBox.size.width), ref height -> \(boundingBox.size.height)")
    
    return (image2,currentTextProperties.fontSize)
}

func getOptimalFontSize(text: String, boundingBox: CGRect, textProperties: TextProperties, suggestedWidth: CGFloat, suggestedHeight: CGFloat = CGFloat.greatestFiniteMagnitude) -> Int {
    binarySearch(text: text, boundingBox: boundingBox, textProperties: textProperties, suggestedWidth: suggestedWidth,suggestedHeight: suggestedHeight)
}

func binarySearch(start: Int = 1 , end: Int = 1000, text: String, boundingBox: CGRect, textProperties: TextProperties, suggestedWidth: CGFloat, suggestedHeight: CGFloat) -> Int {
    var lastBest = start
    var lo = start
    var hi = end - 1
    var mid = 0
    var myTextProp = textProperties
    
    while lo <= hi {
        mid = (lo + hi) / 2
        myTextProp.fontSize = CGFloat(mid)
        let fitStatus = isValidFit(boundingBox: boundingBox, text: text, textProperties: myTextProp, suggestedWidth: suggestedWidth, suggestedHeight: suggestedHeight)
        
        switch fitStatus {
        case .fitsPerfectly, .tooWide:
           
            lastBest = lo
            lo = mid + 1
        case .tooBig , .tooTall :
            hi = mid - 1
            lastBest = hi
       
       
        case .unknown:
            return 17
        }
    }
    
    // Return the best fit found
    return lastBest
}
// Function to get the bounding box height of the font (using CoreText)
func getFontBoundingBox(font: UIFont) -> CGFloat {
    let ctFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
    let boundingBox = CTFontGetBoundingBox(ctFont)
    
    return boundingBox.height
}

enum TextFitStatus: Int {
    case fitsPerfectly = 0   // Text fits perfectly within the available space
    case tooBig = 1          // Text is too big for both width and height
    case tooWide = 2         // Text is too wide but fits the height
    case tooTall = 3         // Text is too tall but fits the width
    case unknown = 4       // Text is too tall but fits the width

    
}

func isValidFit(boundingBox: CGRect, text: String,textProperties: TextProperties,suggestedWidth:CGFloat,suggestedHeight:CGFloat = CGFloat.greatestFiniteMagnitude ) -> TextFitStatus {
    
    let attributedString = text.getAtrributedString(textProperties: textProperties)
    
    // Step 1: Set up the text storage, layout manager, and text container
    let textStorage = NSTextStorage(attributedString: attributedString)
    let textContainer = NSTextContainer(size: CGSize(width: suggestedWidth, height: suggestedHeight))
    textContainer.lineFragmentPadding = 0
    textContainer.maximumNumberOfLines = 0
    textContainer.lineBreakMode = .byWordWrapping
    textContainer.lineFragmentPadding = 0
    let layoutManager = NSLayoutManager()
    textStorage.addLayoutManager(layoutManager)
    layoutManager.addTextContainer(textContainer)
    
//    // Step 2: Set up the paragraph style with the specified attributes
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineHeightMultiple = lineSpacing
//    paragraphStyle.alignment = alignment
//
//    // Step 3: Set up attributes including font, shadow, letter spacing, and paragraph style
//    let attributes: [NSAttributedString.Key: Any] = [
//        .font: textFont,
//        .paragraphStyle: paragraphStyle,
//        .kern: letterSpacing, // Letter spacing (kerning)
//        .shadow: shadow ?? NSShadow()
//    ]
    
  //  textStorage.setAttributedString(attributedString)

    // Step 4: Create a graphics context to draw the text
    
//    UIGraphicsBeginImageContextWithOptions(boundingBox.size, false, 0)
//    guard let context = UIGraphicsGetCurrentContext() else { return .unknown }
//
////    context.setFillColor(UIColor.green.cgColor)
////    context.fill([boundingBox])
//    context.setLineWidth(1)
//    context.setStrokeColor(UIColor.black.cgColor)
    var textRect = CGRect.zero

    // Step 5: Enumerate through the lines and draw them
    var currentY: CGFloat = 0.0
    var isValidWrap = true
    let font = UIFont(name: textProperties.fontName,size:textProperties.fontSize) ?? UIFont.systemFont(ofSize: textProperties.fontSize)
    
    let testFont =   CTFontCreateWithName(textProperties.fontName as CFString,CGFloat(textProperties.fontSize) , nil)
    let rect2 = attributedString.boundingRect(with: CGSize(width: suggestedWidth, height: .infinity),options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
    let boundingBox2 = CTFontGetBoundingBox(testFont)

        
    let newRect = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer)
   
    layoutManager.usesFontLeading = true
    var lines : CGFloat = 0
    layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(for: textContainer)) { (rect, usedRect, _, lineRange, glyphRange) in
        // Draw each line as a rectangle to visualize the layout
//        context.stroke(rect)
//        context.setStrokeColor(UIColor.yellow.cgColor)
//        context.stroke(usedRect)
        textRect = textRect.union(rect)
        
         lines += 1
          
        guard NSMaxRange(lineRange) <= attributedString.length else {
            print("⚠️ Line range out of bounds! \(lineRange) vs \(attributedString.length)")
            return
        }
//        print("isValidFit text:\(text),fontSize:\(textProperties.fontSize), lineHeight: \(font.lineHeight) , rectHeight: \(rect.width):\(rect.height) , usedRect: \(usedRect.width):\(usedRect.height),boundingHeight:\(boundingBox2.height), boundingRect:\(rect2.width):\(rect2.height) , newRect: \(newRect)")
        // Draw the text on the graphics context
//        let lineText = (text as NSString).substring(with: lineRange)
//        lineText.draw(in: rect, withAttributes: attributes)
       let lineText = attributedString.attributedSubstring(from: lineRange)
//        lineText.draw(in: rect)
        // Check for word wrapping validity (space or hyphen)
        if lineRange.location + lineRange.length < text.count { //lineRange.location + lineRange.length < attributedString.length{
            let endIndex = lineRange.location + lineRange.length
            let stringIndex = text.index(text.startIndex, offsetBy: endIndex)
            
            if stringIndex < text.endIndex {
                let previousChar = text[text.index(before: stringIndex)] // Get the previous character
                let nextChar = text[stringIndex] // Get the next character
                
                if !isValidWordWrap(before: previousChar, after: nextChar) {
                    // Draw invalid word wrap indication (e.g., in red color)
//                    context.setStrokeColor(UIColor.red.cgColor)
//                    context.stroke(rect)
                    isValidWrap = false
                   
                }
            }
        }
        
        // Move to the next Y position for drawing
        currentY += rect.height
    }
   
        let lineHeight = font.lineHeight
       let lineCount = ceil(textRect.height / lineHeight) // Calculate the number of lines
    var adjustedHeight = boundingBox2.height * lines //(lineSpacing * (lineCount - 1)) // Add line spacing for each line except the last
    // Step 5: Calculate the total line height considering lineSpacing and bounding box height
    // Step 5: Calculate the total line height considering the line multiplier and bounding box height
      if lines > 1 {
          // If multiple lines, apply lineMultiplier to scale the line height
          adjustedHeight =  (boundingBox2.height * CGFloat(lines)) + (font.lineHeight * CGFloat(textProperties.lineSpacing-1.0) * CGFloat(lines - 1))
      } else {
          // For a single line, use only the fontHeight (no multiplier needed)
          adjustedHeight = boundingBox2.height
      }
    
    textRect.size.height = adjustedHeight
    let textHeight = textRect.height
    let textWidth = textRect.width
    let availableSpace = boundingBox
    
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    print(image)
    
    if isValidWrap == false {
        return .tooTall
    }
    // Check if the text fits within the available space
      if availableSpace.contains(textRect) {
          return .fitsPerfectly // Text fits perfectly
      } else {
          if textWidth > availableSpace.width && textHeight > availableSpace.height {
              return .tooBig // Text is too big for both width and height
          } else if textWidth > availableSpace.width && textHeight < availableSpace.height {
              return .tooWide // Text is too wide but fits height
          } else {
              return .tooTall // Text is too tall but fits width
          }
      }
    
    
//    // Step 6: Generate the UIImage from the graphics context

   // return textRect
}

// Function to check if the word wrap is valid (at space or hyphen)
func isValidWordWrap(before: Character, after: Character) -> Bool {
    return before == " " || before == "-"
}
