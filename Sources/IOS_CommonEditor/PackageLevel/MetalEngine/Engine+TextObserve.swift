//
//  Engine+TextObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//
import UIKit

extension MetalEngine {
    public func observeAsCurrentText(_ textModel: TextInfo) {
        if let textModel = templateHandler.currentTextModel,let currentParent = templateHandler.getParentFor(childId: textModel.modelId){
            
            
            
            // Manage ActionState
            
            // Manage Properties
            textModel.$fontName.dropFirst().sink { [weak self] textFont in
                guard let self = self else { return }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextFont(modelId: textModel.textId, newValue: textFont)
                }
                textModel.textFont = UIFont(name: FontDM.getRealFont(nameOfFont: textFont, engineConfig: engineConfig), size: 14) ?? .systemFont(ofSize: 14)
            }.store(in: &modelPropertiesCancellables)
        
            
            textModel.$endTextContentColor.dropFirst().sink { [weak self] textColor in
                guard let self = self else { return }
                //DB Work and Model Work
                if let color = textColor as? BGColor{
                    textModel.textColor = color.bgColor
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateTextColor(modelId: textModel.textId, newValue: color.bgColor.toUIntString())
                    }
                }
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$textGravity.dropFirst().sink { [weak self] textGravity in
                guard let self = self else { return }
                if !(isDBDisabled){
                    // DB Work
                    _ = DBManager.shared.updateTextGravity(modelId: textModel.textId, newValue: textGravity.rawValue)
                }
            }.store(in: &modelPropertiesCancellables)
            
            
            textModel.$endTextBGContent.dropFirst().sink { [weak self] bgContent in
                guard let self = self else { return }
                if let color = bgContent as? BGColor{
                    textModel.bgColor = color.bgColor
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateTextBgColor(modelId: textModel.textId, newValue: color.bgColor.toUIntString())
                    }
                }
                print("SN BG Clor  \(bgContent)")
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$bgType.dropFirst().sink { [weak self] bgType in
                guard let self = self else { return }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextBgType(modelId: textModel.textId, newValue: bgType)
                }
                print("SN BG Type  \(bgType)")
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$endBGAlpha.dropFirst().sink { [weak self] bgAlpha in
                guard let self = self else { return }
                let alpha = bgAlpha * 255
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextBgAlpha(modelId: textModel.textId, newValue: alpha.toDouble())
                }
                print("SN BG Alpha  \(bgAlpha)")
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$endTextShadowColorFilter.dropFirst().sink { [weak self] shadowColor in
                guard let self = self else { return }
                if let shadowColor = shadowColor as? ColorFilter{
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateTextShadowColor(modelId: textModel.textId, newValue: shadowColor.filter.toUIntString())
                        
                    }
                }
                print("SN Shadow Color\(shadowColor)")
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$endDx.dropFirst().sink { [weak self] dx in
                guard let self = self else { return }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextShadowDx(modelId: textModel.textId, newValue: dx)
                }
                print("SN DX \(dx)")
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$endDy.dropFirst().sink { [weak self] dy in
                guard let self = self else { return }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextShadowDy(modelId: textModel.textId, newValue: dy)
                }
                print("SN DY \(dy)")
            }.store(in: &modelPropertiesCancellables)
            
//            textModel.$endOpacity.dropFirst().sink { [unowned self] opacity in
//                print("SN \(opacity)")
//            }.store(in: &cancellables)
//
            textModel.$endLineSpacing.dropFirst().sink {[weak self]  lineSpacing in
                guard let self = self else { return }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextLineSpacing(modelId: textModel.textId, newValue: lineSpacing)
                }
                print("SN \(lineSpacing)")
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$endLetterSpacing.dropFirst().sink {[weak self]  letterSpacing in
                guard let self = self else { return }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextLetterSpacing(modelId: textModel.textId, newValue: letterSpacing)
                }
                print("SN \(letterSpacing)")
            }.store(in: &modelPropertiesCancellables)
            
//            textModel.$endFrame.dropFirst().sink { [unowned self] frame in
//                print("SN \(frame)")
//            }.store(in: &cancellablesForText)
            
//            textModel.$endDuration.dropFirst().sink {[unowned self]  duration in
//                print("SN \(duration)")
//            }.store(in: &cancellables)
            
//            textModel.$endStartTime.dropFirst().sink {[unowned self]  startTime in
//                print("SN \(startTime)")
//            }.store(in: &cancellables)
            
            textModel.$endShadowOpacity.dropFirst().sink { [weak self] shadowOpacity in
                guard let self = self else { return }
                let opacity : Int = Int(shadowOpacity)
                if !(isDBDisabled){
                    _ = DBManager.shared.updateTextShadowRadius(modelId: textModel.textId, newValue: Double(opacity))
                }
                print("SN Shadow Opacity \(shadowOpacity)")
            }.store(in: &modelPropertiesCancellables)
            
            
            templateHandler.currentActionState.$updatedText.dropFirst().sink { [weak self]  text in
                print("SN1 \(text)")
                guard let self = self else { return }
                
                
                var editedText = text
                
                if !templateHandler.isPersonalizeActive {
                    
                    guard var textCheck = self.onUserEditInputText(text) else {
                        self.templateHandler.currentActionState.isTextNotValid = true
                        return
                    }
                    editedText = textCheck
                }
                
                // JD - We need to check text as well as new width and height to skip the closure
                let ctCalc = CTCalculator()
                    let oldText = textModel.text
                    let oldSize = textModel.baseFrame.size
                    let newText = editedText
                    var newSize = CGRect.zero
                    var refSize =  currentParent.baseFrame.size
                    refSize.width = refSize.width * 0.8 * engineConfig.contentScaleFactor//UIStateManager.shared.contentscaleFactor
                    refSize.height = refSize.height * engineConfig.contentScaleFactor//UIStateManager.shared.contentscaleFactor
                    
                let textValue = ctCalc.getBoundsForCurrentFontSize(newText: newText, textProperties: textModel.textProperty, parentSize: CGSize(width: refSize.width, height: refSize.height))
                
                logger.printLog("NSK NewSize from width \(textValue.width), height : \(textValue.height)")
               /*/ newSize.size = CGSize(width: textValue.width/UIStateManager.shared.contentscaleFactor, height: textValue.height/UIStateManager.shared.contentscaleFactor)*/
                newSize.size = CGSize(width: textValue.width, height: textValue.height)
                
//                let widthMarginPercentage = (textModel.textProperty.externalWidthMargin * 100) / newSize.width //currentParent.baseFrame.size.width
//                let heightMarginPercentage = (textModel.textProperty.externalHeightMargin * 100) / newSize.height   //currentParent.baseFrame.size.height
//
//                // Ensure we don't divide by zero by checking the margin percentages
//                var realW = round((newSize.size.width * 100 / 4) / (100 / 4 - widthMarginPercentage))
//                var realH = round((newSize.size.height * 100 / 2) / (100 / 2 - heightMarginPercentage))
                
                print("RNK Metal \(newSize.size)")
                let widthMargin = newSize.width * ( textModel.textProperty.externalWidthMargin / 100 )
                let heightMargin = newSize.height * ( textModel.textProperty.externalHeightMargin / 100 )
                var realW = newSize.size.width + ( 4 * widthMargin )
                var realH = newSize.size.height + ( 2 * heightMargin )
                
                realW = realW / engineConfig.contentScaleFactor//UIStateManager.shared.contentscaleFactor
                realH = realH / engineConfig.contentScaleFactor//UIStateManager.shared.contentscaleFactor
                
                if oldText == newText && oldSize.width == realW && oldSize.height == realH {
                    return
                }
                
                self.templateHandler.currentActionState.isTextInUpdateMode = true
                
                if self.templateHandler.isPersonalizeActive {
                    textModel.textModelChnaged = TextModelChanged(oldText: oldText, newText: newText, oldSize: oldSize, newSize: CGSize(width: oldSize.width, height: oldSize.height))
                }
                else {
                    textModel.textModelChnaged = TextModelChanged(oldText: oldText, newText: newText, oldSize: oldSize, newSize: CGSize(width: realW, height: realH))
                }
                
//                self.analyticsLogger.logEditorInteraction(action: .updateText)
                engineConfig.logUpdateText()
                
            }.store(in: &modelPropertiesCancellables)
            
            textModel.$textModelChnaged.dropFirst().sink{ [weak self] textChangedModel in
                guard let self = self else { return }
                if  textChangedModel == nil{
                    return
                }
                textModel.text = textChangedModel!.newText
                print("KLP \(textChangedModel!.newSize)")
                textModel.baseFrame.size = textChangedModel!.newSize
                let oldPrevAvailableWidth = textModel.prevAvailableWidth
                let oldPrevAvailableHeight = textModel.prevAvailableHeight
                textModel.prevAvailableWidth = Float(textChangedModel!.newSize.width)
                textModel.prevAvailableHeight = Float(textChangedModel!.newSize.height)
                logger.printLog("[preAvailbaleSize changes] text resize modelId=\(textModel.modelId), " +
                                "prevW=\(oldPrevAvailableWidth)->\(textModel.prevAvailableWidth), " +
                                "prevH=\(oldPrevAvailableHeight)->\(textModel.prevAvailableHeight), " +
                                "newSize=\(textChangedModel!.newSize)")
                if textModel.prevAvailableWidth <= 0 || textModel.prevAvailableHeight <= 0 {
                    logger.logErrorFirebase("[preAvailbaleSize changes] Invalid text prevAvailable after resize: " +
                                            "modelId=\(textModel.modelId), prevW=\(textModel.prevAvailableWidth), " +
                                            "prevH=\(textModel.prevAvailableHeight), newSize=\(textChangedModel!.newSize)")
                }
                if !(isDBDisabled){
                    _ = DBManager.shared.updateText(modelId: textModel.textId, newValue: textChangedModel!.newText)
                    if let parent = templateHandler.getModel(modelId: textModel.parentId) {
                        _ = DBManager.shared.updateBaseFrameWithPrevious(modelId: textModel.modelId,
                                                                         newValue: textModel.baseFrame,
                                                                         parentFrame: parent.baseFrame.size,
                                                                         previousWidth: CGFloat(textModel.prevAvailableWidth),
                                                                         previousHeight: CGFloat(textModel.prevAvailableHeight))
                    } else {
                        logger.logErrorFirebase("[preAvailbaleSize changes] Parent not found for text resize: " +
                                                "modelId=\(textModel.modelId), parentId=\(textModel.parentId)")
                    }
                }
                templateHandler.currentActionState.isTextInUpdateMode = false
            }.store(in: &modelPropertiesCancellables)
            
        }
    }
}
