//
//  UndoRedoExecuter.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 09/04/24.
//

import Foundation

public class UndoRedoExecuter{
    
    var logger: PackageLogger
    
    deinit {
        logger.printLog("de-init \(self)")
    }
    init(logger: PackageLogger) {
        self.logger = logger
        logger.printLog("init \(self)")
    }
    public func PerformUndoAction(engine: MetalEngine){
        let result = engine.undoRedoManager?.undo()//UndoRedoManager.shared.undo()
        let currentModelId = engine.templateHandler.currentModel?.modelId ?? -1
        let pageId = engine.templateHandler.currentPageModel?.modelId ?? -1
        logger.logErrorFirebase("[TimelineTrace][Undo] begin result=\(String(describing: result)) currentModelId=\(currentModelId) pageId=\(pageId) isMainThread=\(Thread.isMainThread)", record: false)
        if currentModelId == -1 || pageId == -1 {
            logger.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModelId) pageId=\(pageId)")
        }
        switch result{
        case .OpacityChanged(let opacity):
            setCurrentModelIfNeeded(engine: engine, currentId: opacity.id)
            engine.templateHandler.currentModel?.endOpacity = opacity.oldOpacity
            engine.templateHandler.currentModel?.modelOpacity = opacity.oldOpacity
        case .CropChanged(let cropRect):
            setCurrentModelIfNeeded(engine: engine, currentId: cropRect.id)
            engine.templateHandler.currentStickerModel?.cropRect = cropRect.oldCropRect
        case .flipHorizontalChanged(let flipH):
            setCurrentModelIfNeeded(engine: engine, currentId: flipH.id)
            engine.templateHandler.currentModel?.modelFlipHorizontal = flipH.oldvalue
        case .flipVeticalChanged(let flipV):
            setCurrentModelIfNeeded(engine: engine, currentId: flipV.id)
            engine.templateHandler.currentModel?.modelFlipVertical = flipV.oldvalue
        case .lockChanged(let lockStatus):
            setCurrentModelIfNeeded(engine: engine, currentId: lockStatus.id)
            engine.templateHandler.currentModel?.lockStatus = lockStatus.oldStatus
            
            
        case .deleteAction(let deleteModel):
            setCurrentModelIfNeeded(engine: engine, currentId: deleteModel.id)
            engine.templateHandler.currentModel?.softDelete = deleteModel.oldValue
            
            if deleteModel.oldValue == true {
                setCurrentModelIfNeeded(engine: engine, currentId: deleteModel.oldShouldSelectID,smartSelect: false)

            }
            engine.templateHandler.currentActionState.updatePageAndParentThumb = true
            engine.templateHandler.currentActionState.shouldRefreshOnAddComponent = true
            
        case .centerChanged(let centerModel):
            setCurrentModelIfNeeded(engine: engine, currentId: centerModel.id)
            engine.templateHandler.currentModel?.baseFrame.center.x = CGFloat(centerModel.oldValue.x)
            engine.templateHandler.currentModel?.baseFrame.center.y = CGFloat(centerModel.oldValue.y)
        case .frameChanged(let frameModel):
            setCurrentModelIfNeeded(engine: engine, currentId: frameModel.id)
            var oldValue = frameModel.oldValue
            oldValue.shouldRevert = frameModel.shouldRevert
            oldValue.isParentDragging = frameModel.isParentDragging
            engine.templateHandler.currentModel?.beginFrame = engine.templateHandler.currentModel!.baseFrame
            engine.templateHandler.currentModel?.baseFrame = oldValue
            engine.templateHandler.currentModel?.endFrame = oldValue
            
            var baseFrame = engine.templateHandler.currentModel?.baseFrame
            baseFrame?.shouldRevert = false
            baseFrame?.isParentDragging = false
            engine.templateHandler.currentModel?.baseFrame = baseFrame!
            
        case .timeChanged(let timelineModel):
            setCurrentModelIfNeeded(engine: engine, currentId: timelineModel.id)
            engine.templateHandler.currentModel?.beginBaseTimeline = engine.templateHandler.currentModel!.baseTimeline
            engine.templateHandler.currentModel?.baseTimeline = StartDuration(startTime:  timelineModel.oldValue.startTime, duration: timelineModel.oldValue.duration)
            engine.templateHandler.currentModel?.endBaseTimeline =  StartDuration(startTime:  timelineModel.oldValue.startTime, duration: timelineModel.oldValue.duration)
            engine.templateHandler.currentActionState.shouldRefreshOnAddComponent = true
            engine.templateHandler.setCurrentTime(engine.templateHandler.getStartTimeForSacredTimeline(model: engine.templateHandler.currentModel!)+(timelineModel.oldValue.duration/2) )
            
        case .rotationChanged(let rotationModel):
            setCurrentModelIfNeeded(engine: engine, currentId: rotationModel.id)
            engine.templateHandler.currentModel?.baseFrame.rotation = rotationModel.oldValue
        case .stickerColorChanged(let color):
            setCurrentModelIfNeeded(engine: engine, currentId: color.id)
            engine.templateHandler.currentStickerModel?.stickerColor = color.oldStickerColor
            engine.templateHandler.currentActionState.updateThumb = true
        case .stickerHueChanged(let hue):
            setCurrentModelIfNeeded(engine: engine, currentId: hue.id)
            engine.templateHandler.currentStickerModel?.stickerHue = hue.oldHue
            engine.templateHandler.currentActionState.updateThumb = true
            
        case .stickerImageChanged(let sticker):
            setCurrentModelIfNeeded(engine: engine, currentId: sticker.id)
            engine.templateHandler.currentStickerModel?.resID = sticker.oldStickerResId
            engine.templateHandler.currentActionState.updateThumb = true
        case .posXChanged(let posX):
            setCurrentModelIfNeeded(engine: engine, currentId: posX.id)
            engine.templateHandler.currentModel?.baseFrame.center.x = CGFloat(posX.oldPosX)
        case .posYChanged(let posY):
            setCurrentModelIfNeeded(engine: engine, currentId: posY.id)
            engine.templateHandler.currentModel?.baseFrame.center.y = CGFloat(posY.oldPosY)
        case .textChanged(let text):
            setCurrentModelIfNeeded(engine: engine, currentId: text.id)
            engine.templateHandler.currentTextModel?.text = text.oldText
        case .textColorChanged(let textColor):
            setCurrentModelIfNeeded(engine: engine, currentId: textColor.id)
            engine.templateHandler.currentTextModel?.textContentColo = textColor.oldTextColor
            engine.templateHandler.currentTextModel?.endTextContentColor = textColor.oldTextColor
            engine.templateHandler.currentActionState.updateThumb = true
        case .textShadowColorChanged(let shadowColor):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowColor.id)
            engine.templateHandler.currentTextModel?.shadowColor = (shadowColor.oldShadowColor as! ColorFilter).filter
            engine.templateHandler.currentTextModel?.textShadowColorFilter = shadowColor.oldShadowColor
            engine.templateHandler.currentTextModel?.endTextShadowColorFilter = shadowColor.oldShadowColor
        case .textShadowRadiusChanged(let shadowRadius):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowRadius.id)
            engine.templateHandler.currentTextModel?.shadowRadius = shadowRadius.oldShadowRadius
            
            engine.templateHandler.currentTextModel?.beginShadowOpacity = shadowRadius.oldShadowRadius
            
            engine.templateHandler.currentTextModel?.endShadowOpacity = shadowRadius.oldShadowRadius
        case .textShadowDxChanged(let shadowDx):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowDx.id)
            engine.templateHandler.currentTextModel?.beginDx = shadowDx.oldShadowDx
            engine.templateHandler.currentTextModel?.shadowDx = shadowDx.oldShadowDx
            engine.templateHandler.currentTextModel?.endDx = shadowDx.oldShadowDx
        case .textShadowDyChanged(let shadowDy):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowDy.id)
            engine.templateHandler.currentTextModel?.beginDy = shadowDy.oldShadowDy
            
            engine.templateHandler.currentTextModel?.shadowDy = shadowDy.oldShadowDy
            
            engine.templateHandler.currentTextModel?.endDy = shadowDy.oldShadowDy
        case .textAlignmentChanged(let alignment):
            setCurrentModelIfNeeded(engine: engine, currentId: alignment.id)
            engine.templateHandler.currentTextModel?.textGravity = alignment.oldAlignment
        case .textLetterSpacingChanged(let letterSpacing):
            setCurrentModelIfNeeded(engine: engine, currentId: letterSpacing.id)
            engine.templateHandler.currentTextModel?.letterSpacing = letterSpacing.oldLetterSpacing
            engine.templateHandler.currentTextModel?.endLetterSpacing = letterSpacing.oldLetterSpacing
        case .textLineSpacingChanged(let lineSpacing):
            setCurrentModelIfNeeded(engine: engine, currentId: lineSpacing.id)
            engine.templateHandler.currentTextModel?.lineSpacing = lineSpacing.oldLineSpacing
            engine.templateHandler.currentTextModel?.endLineSpacing = lineSpacing.oldLineSpacing
        case .textFontChanged(let font):
            setCurrentModelIfNeeded(engine: engine, currentId: font.id)
            engine.templateHandler.currentTextModel?.fontName = font.oldFont
        case .textBgColorChanged(let bgColor):
            setCurrentModelIfNeeded(engine: engine, currentId: bgColor.id)
            engine.templateHandler.currentTextModel?.textBGContent = bgColor.oldBgColor
            engine.templateHandler.currentTextModel?.endTextBGContent = bgColor.oldBgColor
            engine.templateHandler.currentActionState.updateThumb = true
        case .textBgAlphaChanged(let bgAlpha):
            setCurrentModelIfNeeded(engine: engine, currentId: bgAlpha.id)
            engine.templateHandler.currentTextModel?.bgAlpha = bgAlpha.oldBgAlpha
        case .pageTileAMultipleChanged(let tileSize):
            setCurrentModelIfNeeded(engine: engine, currentId: tileSize.id)
            engine.templateHandler.currentPageModel?.tileMultiple = tileSize.oldTileMultiple
        case .pageBGChanged(let bg):
            setCurrentModelIfNeeded(engine: engine, currentId: bg.id)
            engine.templateHandler.currentPageModel?.resID = bg.oldResId
        case .pageBGBlurChanged(let bgBlur):
            setCurrentModelIfNeeded(engine: engine, currentId: bgBlur.id)
            engine.templateHandler.currentPageModel?.bgBlurProgress = bgBlur.oldBgBlur
        case .pageBGColorChanged(let bgColor):
            setCurrentModelIfNeeded(engine: engine, currentId: bgColor.id)
            engine.templateHandler.currentPageModel?.color = bgColor.oldBgColor
        case .pageOverlayChanged(let overlay):
            setCurrentModelIfNeeded(engine: engine, currentId: overlay.id)
            engine.templateHandler.currentPageModel?.overlayResID = overlay.oldOverlayResId
        case .pageOverlayOpacityChanged(let overlayOpacity):
            setCurrentModelIfNeeded(engine: engine, currentId: overlayOpacity.id)
            engine.templateHandler.currentPageModel?.overlayOpacity = overlayOpacity.oldOverlayOpacity
            
        case .pageBGContentChanged(let bg):
            
            setCurrentModelIfNeeded(engine: engine, currentId: bg.id)
            engine.templateHandler.currentPageModel?.bgContent = bg.oldBGContent
            engine.templateHandler.currentPageModel?.endBgContent = bg.oldBGContent
            
        case .pageBGOverlayContentChanged(let bgOverlay):
            
            setCurrentModelIfNeeded(engine: engine, currentId: bgOverlay.id)
            engine.templateHandler.currentPageModel?.bgOverlayContent = bgOverlay.oldBGContent
            
        case .stikerFilterChanged(let colorFilter):
            setCurrentModelIfNeeded(engine: engine, currentId: colorFilter.id)
            engine.templateHandler.currentStickerModel?.stickerFilter = colorFilter.oldFilter
            engine.templateHandler.currentStickerModel?.endStickerFilter = colorFilter.oldFilter
            engine.templateHandler.currentActionState.updateThumb = true
        case .pageOrderChanged(_):
            break

        case .none:
            break
        case .stickerImageContent(let stickerImageContent):
            setCurrentModelIfNeeded(engine: engine, currentId: stickerImageContent.id)
            engine.templateHandler.currentStickerModel?.baseFrame = stickerImageContent.oldContent.baseFrame
            engine.templateHandler.currentStickerModel?.changeOrReplaceImage = stickerImageContent.oldContent
            engine.templateHandler.currentActionState.updateThumb = true
        case .MoveModelChanged(let moveModel):
            let currentModelId = engine.templateHandler.currentModel?.modelId ?? -1
            let pageId = engine.templateHandler.currentPageModel?.modelId ?? -1
            logger.logErrorFirebase("[TimelineTrace][Undo] MoveModelChanged type=\(moveModel.type) oldLast=\(moveModel.oldlastSelectedId) newLast=\(moveModel.newLastSelected) addParentId=\(moveModel.shouldAddParentID ?? -1) removeParentId=\(moveModel.shouldRemoveParentID ?? -1) oldIds=\(moveModel.oldMM.map { $0.modelID }) newIds=\(moveModel.newMM.map { $0.modelID }) currentModelId=\(currentModelId) pageId=\(pageId) isMainThread=\(Thread.isMainThread)", record: false)
            if currentModelId == -1 || pageId == -1 {
                logger.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModelId) pageId=\(pageId)")
            }
            let oldMM = moveModel.newMM
            let newMM = moveModel.oldMM
            var moveModelNew = MoveModel(type: moveModel.type, oldMM: oldMM, newMM: newMM)

            if moveModel.type == MoveModelType.OrderChangeOnly {
                let orderChangeObject = OrderChange(selectedModelId: moveModel.orderChange!.selectedModelId, oldOrder: moveModel.orderChange!.newOrder, newOrder: moveModel.orderChange!.oldOrder)
                
                moveModelNew.orderChange = orderChangeObject
            }
            

            moveModelNew.newLastSelected = moveModel.oldlastSelectedId
            moveModelNew.oldlastSelectedId = moveModel.newLastSelected

            if moveModel.type == MoveModelType.UnGroup || moveModel.type == MoveModelType.Group {
                moveModelNew.shouldAddParentID = moveModel.shouldRemoveParentID
                moveModelNew.shouldRemoveParentID = moveModel.shouldAddParentID
            }
            engine.templateHandler?.performGroupAction(moveModel: moveModelNew)
            
        case .animationChanged(let animationModel):
            setCurrentModelIfNeeded(engine: engine, currentId: animationModel.id)
            if animationModel.oldValue.type == "IN"{
                engine.templateHandler.currentModel?.inAnimation = animationModel.oldValue
                engine.templateHandler.currentActionState.lastSelectedAnimType = animationModel.oldValue.type
                engine.templateHandler.currentActionState.lastSelectedCategoryId = animationModel.oldValue.category
            }
            else if animationModel.oldValue.type == "OUT"{
                engine.templateHandler.currentModel?.outAnimation = animationModel.oldValue
                engine.templateHandler.currentActionState.lastSelectedAnimType = animationModel.oldValue.type
                engine.templateHandler.currentActionState.lastSelectedCategoryId = animationModel.oldValue.category
            }
            else if animationModel.oldValue.type == "LOOP"{
                engine.templateHandler.currentModel?.loopAnimation = animationModel.oldValue
                engine.templateHandler.currentActionState.lastSelectedAnimType = animationModel.oldValue.type
                engine.templateHandler.currentActionState.lastSelectedCategoryId = animationModel.oldValue.category
            }else{
                if engine.templateHandler.currentActionState.lastSelectedAnimType == "IN"{
                    engine.templateHandler.currentModel?.inAnimation = animationModel.oldValue
                }else if engine.templateHandler.currentActionState.lastSelectedAnimType == "OUT"{
                    engine.templateHandler.currentModel?.outAnimation = animationModel.oldValue
                }else{
                    engine.templateHandler.currentModel?.loopAnimation = animationModel.oldValue
                }
            }
        case .some(.pageRatioChanged(let ratioModel)):
            engine.templateHandler.selectCurrentPage()
            print("Ratio selected: \(ratioModel)")
            engine.templateHandler.currentTemplateInfo?.ratioId = ratioModel.oldRatioModel.id
            engine.templateHandler.currentTemplateInfo!.ratioInfo = ratioModel.oldRatioModel
            engine.templateHandler.currentActionState.updatePageAndParentThumb = true

        case .some(.musicChanged(let musicModel)):
            engine.templateHandler.currentActionState.currentMusic = musicModel.oldMusicModel
        case .some(.textModelChanged(let textChanged)):
            let oldTextSize = textChanged.textModel.oldSize
            let oldText = textChanged.textModel.oldText
            var textChangedModel = textChanged
            textChangedModel.textModel.oldSize = textChanged.textModel.newSize
            textChangedModel.textModel.oldText = textChanged.textModel.newText
            textChangedModel.textModel.newSize = oldTextSize
            textChangedModel.textModel.newText = oldText
            engine.templateHandler.currentTextModel?.textModelChnaged = textChangedModel.textModel
            engine.templateHandler.currentActionState.updateThumb = true
            
        case .some(.lockUnlockAll(let lockUnlockAl)):
            setCurrentModelIfNeeded(engine: engine, currentId: lockUnlockAl.id)
            engine.templateHandler.currentPageModel?.lockUnlockState = lockUnlockAl.oldArray
        case .some(.maskShapeModel(let maskModel)):
            setCurrentModelIfNeeded(engine: engine, currentId: maskModel.id)
            engine.templateHandler.currentModel?.maskShape = maskModel.oldValue
        case .some(.filterTypeModel(let filterType)):
            setCurrentModelIfNeeded(engine: engine, currentId: filterType.id)
            engine.templateHandler.currentModel?.filterType = filterType.oldValue
        case .some(.colorAdjustmentTypeModel(let colorAdjustmentType)):
            setCurrentModelIfNeeded(engine: engine, currentId: colorAdjustmentType.id)
            engine.templateHandler.currentModel?.colorAdjustmentType = colorAdjustmentType.oldValue
        case .some(.brightnessAdjustmentModel(let brightness)):
            setCurrentModelIfNeeded(engine: engine, currentId: brightness.id)
            engine.templateHandler.currentModel?.brightnessIntensity = brightness.oldValue
        case .some(.contrastAdjustmentModel(let contrast)):
            setCurrentModelIfNeeded(engine: engine, currentId: contrast.id)
            engine.templateHandler.currentModel?.contrastIntensity = contrast.oldValue
        case .some(.highlightAdjustmentModel(let highlight)):
            setCurrentModelIfNeeded(engine: engine, currentId: highlight.id)
            engine.templateHandler.currentModel?.highlightIntensity = highlight.oldValue
        case .some(.shadowsAdjustmentModel(let shadows)):
            setCurrentModelIfNeeded(engine: engine, currentId: shadows.id)
            engine.templateHandler.currentModel?.shadowsIntensity = shadows.oldValue
        case .some(.saturationAdjustmentModel(let saturation)):
            setCurrentModelIfNeeded(engine: engine, currentId: saturation.id)
            engine.templateHandler.currentModel?.saturationIntensity = saturation.oldValue
        case .some(.vibranceAdjustmentModel(let vibrance)):
            setCurrentModelIfNeeded(engine: engine, currentId: vibrance.id)
            engine.templateHandler.currentModel?.vibranceIntensity = vibrance.oldValue
        case .some(.sharpnessAdjustmentModel(let sharpness)):
            setCurrentModelIfNeeded(engine: engine, currentId: sharpness.id)
            engine.templateHandler.currentModel?.sharpnessIntensity = sharpness.oldValue
        case .some(.warmthAdjustmentModel(let warmth)):
            setCurrentModelIfNeeded(engine: engine, currentId: warmth.id)
            engine.templateHandler.currentModel?.warmthIntensity = warmth.oldValue
        case .some(.tintAdjustmentModel(let tint)):
            setCurrentModelIfNeeded(engine: engine, currentId: tint.id)
            engine.templateHandler.currentModel?.tintIntensity = tint.oldValue
        case .some(.editStateToggle(let editAction)):
           
            
            setCurrentModelIfNeeded(engine: engine, currentId: editAction.id)
            if let currentModel = engine.templateHandler.currentModel as? ParentModel {
                currentModel.editState = editAction.oldvalue
            }
            
            
        case .some(.inAnimationDurationChange(let inAnimation)):
            setCurrentModelIfNeeded(engine: engine, currentId: inAnimation.id)
            engine.templateHandler.currentModel?.inAnimationDuration = inAnimation.oldValue
        case .some(.outAnimationDurationChange(let outAnimation)):
            setCurrentModelIfNeeded(engine: engine, currentId: outAnimation.id)
            engine.templateHandler.currentModel?.outAnimationDuration = outAnimation.oldValue
        case .some(.loopAnimationDurationChange(let loopAnimation)):
            setCurrentModelIfNeeded(engine: engine, currentId: loopAnimation.id)
            engine.templateHandler.currentModel?.loopAnimationDuration = loopAnimation.oldValue
        case .outputTypeChanged(let output):
            engine.templateHandler.currentTemplateInfo?.outputType = output.oldvalue
        }
    }
    
    public func PerformRedoAction(engine: MetalEngine){
        let result = engine.undoRedoManager?.redo()//UndoRedoManager.shared.redo()
        switch result{
        case .stikerFilterChanged(let colorFilter):
            setCurrentModelIfNeeded(engine: engine, currentId: colorFilter.id)
            engine.templateHandler.currentStickerModel?.stickerFilter = colorFilter.newFilter
            engine.templateHandler.currentStickerModel?.endStickerFilter = colorFilter.newFilter
            engine.templateHandler.currentActionState.updateThumb = true
        
        case .OpacityChanged(let opacity):
            setCurrentModelIfNeeded(engine: engine, currentId: opacity.id)
            engine.templateHandler.currentModel?.endOpacity = opacity.newOpacity
            engine.templateHandler.currentModel?.modelOpacity = opacity.newOpacity
            
        case .CropChanged(let cropRect):
            setCurrentModelIfNeeded(engine: engine, currentId: cropRect.id)
            engine.templateHandler.currentStickerModel?.cropRect = cropRect.newCropRect
        case .flipHorizontalChanged(let flipH):
            setCurrentModelIfNeeded(engine: engine, currentId: flipH.id)
            engine.templateHandler.currentModel?.modelFlipHorizontal = flipH.newValue
            
        case .flipVeticalChanged(let flipV):
            setCurrentModelIfNeeded(engine: engine, currentId: flipV.id)
            engine.templateHandler.currentModel?.modelFlipVertical = flipV.newValue
            
        case .lockChanged(let lockStatus):
            setCurrentModelIfNeeded(engine: engine, currentId: lockStatus.id)
            engine.templateHandler.currentModel?.lockStatus = lockStatus.newStatus
            
        case .deleteAction(let deleteModel):
            setCurrentModelIfNeeded(engine: engine, currentId: deleteModel.id)
            engine.templateHandler.currentModel?.softDelete = deleteModel.newValue
            
            if deleteModel.newValue == true {
                setCurrentModelIfNeeded(engine: engine, currentId: deleteModel.newShouldSelectID,smartSelect: false)

            }
            engine.templateHandler.currentActionState.updatePageAndParentThumb = true
            engine.templateHandler.currentActionState.shouldRefreshOnAddComponent = true
            
        case .centerChanged(let centerModel):
            setCurrentModelIfNeeded(engine: engine, currentId: centerModel.id)
            engine.templateHandler.currentModel?.baseFrame.center.x = CGFloat(centerModel.newValue.x)
            engine.templateHandler.currentModel?.baseFrame.center.y = CGFloat(centerModel.newValue.y)
        case .frameChanged(let frameModel):
            setCurrentModelIfNeeded(engine: engine, currentId: frameModel.id)
            var newValue = frameModel.newValue
            newValue.shouldRevert = frameModel.shouldRevert
            newValue.isParentDragging = frameModel.isParentDragging
            engine.templateHandler.currentModel?.beginFrame = engine.templateHandler.currentModel!.baseFrame
            engine.templateHandler.currentModel?.baseFrame = newValue
            engine.templateHandler.currentModel?.endFrame = newValue
            
            var baseFrame = engine.templateHandler.currentModel?.baseFrame
            baseFrame?.shouldRevert = false
            baseFrame?.isParentDragging = false
            engine.templateHandler.currentModel?.baseFrame = baseFrame!
            
        case .timeChanged(let timelineModel):
            setCurrentModelIfNeeded(engine: engine, currentId: timelineModel.id)
            engine.templateHandler.currentModel?.beginBaseTimeline = engine.templateHandler.currentModel!.baseTimeline
            engine.templateHandler.currentModel?.endBaseTimeline =  StartDuration(startTime:  timelineModel.newValue.startTime, duration: timelineModel.newValue.duration)
            engine.templateHandler.currentModel?.baseTimeline = StartDuration(startTime:  timelineModel.newValue.startTime, duration: timelineModel.newValue.duration)
            engine.templateHandler.currentActionState.shouldRefreshOnAddComponent = true
            engine.templateHandler.setCurrentTime(engine.templateHandler.getStartTimeForSacredTimeline(model: engine.templateHandler.currentModel!)+(timelineModel.newValue.duration/2) )
        case .rotationChanged(let rotationModel):
            setCurrentModelIfNeeded(engine: engine, currentId: rotationModel.id)
            engine.templateHandler.currentModel?.baseFrame.rotation = rotationModel.newValue
            
        case .stickerColorChanged(let color):
            setCurrentModelIfNeeded(engine: engine, currentId: color.id)
            engine.templateHandler.currentStickerModel?.stickerColor = color.newStickerColor
            engine.templateHandler.currentActionState.updateThumb = true
        case .stickerHueChanged(let hue):
            setCurrentModelIfNeeded(engine: engine, currentId: hue.id)
            engine.templateHandler.currentStickerModel?.stickerHue = hue.newHue
            engine.templateHandler.currentActionState.updateThumb = true
        case .stickerImageChanged(let sticker):
            setCurrentModelIfNeeded(engine: engine, currentId: sticker.id)
            engine.templateHandler.currentStickerModel?.resID = sticker.newStickerResId
            engine.templateHandler.currentActionState.updateThumb = true
        case .posXChanged(let posX):
            engine.templateHandler.currentModel?.baseFrame.center.x = CGFloat(posX.newPosX)
        case .posYChanged(let posY):
            setCurrentModelIfNeeded(engine: engine, currentId: posY.id)
            engine.templateHandler.currentModel?.baseFrame.center.y = CGFloat(posY.newPosY)
        case .textChanged(let text):
            setCurrentModelIfNeeded(engine: engine, currentId: text.id)
            engine.templateHandler.currentTextModel?.text = text.newText
        case .textColorChanged(let textColor):
            setCurrentModelIfNeeded(engine: engine, currentId: textColor.id)
            engine.templateHandler.currentTextModel?.textContentColo = textColor.newTextColor
            engine.templateHandler.currentTextModel?.endTextContentColor = textColor.newTextColor
            engine.templateHandler.currentActionState.updateThumb = true
        case .textShadowColorChanged(let shadowColor):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowColor.id)
            engine.templateHandler.currentTextModel?.shadowColor = (shadowColor.newShadowColor as! ColorFilter).filter
            
            engine.templateHandler.currentTextModel?.textShadowColorFilter = (shadowColor.newShadowColor)
            
            engine.templateHandler.currentTextModel?.endTextShadowColorFilter = (shadowColor.newShadowColor)
        case .textShadowRadiusChanged(let shadowRadius):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowRadius.id)
            engine.templateHandler.currentTextModel?.shadowRadius = shadowRadius.newShadowRadius
            
            engine.templateHandler.currentTextModel?.endShadowOpacity = shadowRadius.newShadowRadius
            
            engine.templateHandler.currentTextModel?.beginShadowOpacity = shadowRadius.newShadowRadius
        case .textShadowDxChanged(let shadowDx):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowDx.id)
            engine.templateHandler.currentTextModel?.beginDx = shadowDx.newShadowDx
            
            engine.templateHandler.currentTextModel?.shadowDx = shadowDx.newShadowDx
            
            engine.templateHandler.currentTextModel?.endDx = shadowDx.newShadowDx
        case .textShadowDyChanged(let shadowDy):
            setCurrentModelIfNeeded(engine: engine, currentId: shadowDy.id)
            engine.templateHandler.currentTextModel?.beginDy = shadowDy.newShadowDy
            engine.templateHandler.currentTextModel?.shadowDy = shadowDy.newShadowDy
            
            engine.templateHandler.currentTextModel?.endDy = shadowDy.newShadowDy
        case .textAlignmentChanged(let alignment):
            setCurrentModelIfNeeded(engine: engine, currentId: alignment.id)
            engine.templateHandler.currentTextModel?.textGravity = alignment.newAlignment
        case .textLetterSpacingChanged(let letterSpacing):
            setCurrentModelIfNeeded(engine: engine, currentId: letterSpacing.id)
            engine.templateHandler.currentTextModel?.letterSpacing = letterSpacing.newLetterSpacing
            engine.templateHandler.currentTextModel?.endLetterSpacing = letterSpacing.newLetterSpacing
        case .textLineSpacingChanged(let lineSpacing):
            setCurrentModelIfNeeded(engine: engine, currentId: lineSpacing.id)
            engine.templateHandler.currentTextModel?.lineSpacing = lineSpacing.newLineSpacing
            engine.templateHandler.currentTextModel?.endLineSpacing = lineSpacing.newLineSpacing
        case .textFontChanged(let font):
            setCurrentModelIfNeeded(engine: engine, currentId: font.id)
            engine.templateHandler.currentTextModel?.fontName = font.newFont
        case .textBgColorChanged(let bgColor):
            setCurrentModelIfNeeded(engine: engine, currentId: bgColor.id)
            engine.templateHandler.currentTextModel?.textBGContent = bgColor.newBGColor
            engine.templateHandler.currentTextModel?.endTextBGContent = bgColor.newBGColor
            engine.templateHandler.currentActionState.updateThumb = true
        case .textBgAlphaChanged(let bgAlpha):
            setCurrentModelIfNeeded(engine: engine, currentId: bgAlpha.id)
            engine.templateHandler.currentTextModel?.bgAlpha = bgAlpha.newBgAlpha
        case .pageTileAMultipleChanged(let tileSize):
            setCurrentModelIfNeeded(engine: engine, currentId: tileSize.id)
            engine.templateHandler.currentPageModel?.tileMultiple = tileSize.newTileMultiple
        case .pageBGChanged(let bg):
            setCurrentModelIfNeeded(engine: engine, currentId: bg.id)
            engine.templateHandler.currentPageModel?.resID = bg.newResId
        case .pageBGBlurChanged(let bgBlur):
            setCurrentModelIfNeeded(engine: engine, currentId: bgBlur.id)
            engine.templateHandler.currentPageModel?.bgBlurProgress = bgBlur.newBgBlur
        case .pageBGColorChanged(let bgColor):
            setCurrentModelIfNeeded(engine: engine, currentId: bgColor.id)
            engine.templateHandler.currentPageModel?.color = bgColor.newBgColor
        case .pageOverlayChanged(let overlay):
            setCurrentModelIfNeeded(engine: engine, currentId: overlay.id)
            engine.templateHandler.currentPageModel?.overlayResID = overlay.newOverlayResId
        case .pageOverlayOpacityChanged(let overlayOpacity):
            setCurrentModelIfNeeded(engine: engine, currentId: overlayOpacity.id)
            engine.templateHandler.currentPageModel?.overlayOpacity = overlayOpacity.newOverlayOpacity
            
        case .stickerImageContent(let stickerImageContent):
            setCurrentModelIfNeeded(engine: engine, currentId: stickerImageContent.id)
            engine.templateHandler.currentStickerModel?.baseFrame = stickerImageContent.newContent.baseFrame
            engine.templateHandler.currentStickerModel?.changeOrReplaceImage = stickerImageContent.newContent
            engine.templateHandler.currentActionState.updateThumb = true
        case .pageBGContentChanged(let bg):
            setCurrentModelIfNeeded(engine: engine, currentId: bg.id)
            engine.templateHandler.currentPageModel?.bgContent = bg.newBGContent
            engine.templateHandler.currentPageModel?.endBgContent = bg.newBGContent
            
        case .pageBGOverlayContentChanged(let bgOverlay):
            
            setCurrentModelIfNeeded(engine: engine, currentId: bgOverlay.id)
            engine.templateHandler.currentPageModel?.bgOverlayContent = bgOverlay.newBGContent
       
        case .some(.pageOrderChanged(_)): break
            
        case .MoveModelChanged(let moveModel):
            engine.templateHandler.selectCurrentPage()
            engine.templateHandler?.performGroupAction(moveModel: moveModel)
        case .none:
                break
        case .animationChanged(let animationModel):
            setCurrentModelIfNeeded(engine: engine, currentId: animationModel.id)
            if animationModel.newValue.type == "IN"{
                engine.templateHandler.currentModel?.inAnimation = animationModel.newValue
                engine.templateHandler.currentActionState.lastSelectedAnimType = animationModel.newValue.type
                engine.templateHandler.currentActionState.lastSelectedCategoryId = animationModel.newValue.category
            }
            else if animationModel.newValue.type == "OUT"{
                engine.templateHandler.currentModel?.outAnimation = animationModel.newValue
                engine.templateHandler.currentActionState.lastSelectedAnimType = animationModel.newValue.type
                engine.templateHandler.currentActionState.lastSelectedCategoryId = animationModel.newValue.category
            }
            else if animationModel.newValue.type == "LOOP"{
                engine.templateHandler.currentModel?.loopAnimation = animationModel.newValue
                engine.templateHandler.currentActionState.lastSelectedAnimType = animationModel.newValue.type
                engine.templateHandler.currentActionState.lastSelectedCategoryId = animationModel.newValue.category
            }else{
                if engine.templateHandler.currentActionState.lastSelectedAnimType == "IN"{
                    engine.templateHandler.currentModel?.inAnimation = animationModel.newValue
                }else if engine.templateHandler.currentActionState.lastSelectedAnimType == "OUT"{
                    engine.templateHandler.currentModel?.outAnimation = animationModel.newValue
                }else{
                    engine.templateHandler.currentModel?.loopAnimation = animationModel.newValue
                }
            }
        case .some(.pageRatioChanged(let ratioModel)):
            engine.templateHandler.selectCurrentPage()
            engine.templateHandler.currentTemplateInfo?.ratioId = ratioModel.oldRatioModel.id
            engine.templateHandler.currentTemplateInfo!.ratioInfo = ratioModel.newRatioModel
            engine.templateHandler.currentActionState.updatePageAndParentThumb = true

        case .some(.musicChanged(let musicModel)):
            engine.templateHandler.currentActionState.currentMusic = musicModel.newMusicModel
        case .some(.textModelChanged(let textChanged)):
            engine.templateHandler.currentTextModel?.textModelChnaged = textChanged.textModel
            engine.templateHandler.currentActionState.updateThumb = true
            
        case .some(.lockUnlockAll(let lockUnlockAl)):
            setCurrentModelIfNeeded(engine: engine, currentId: lockUnlockAl.id)
            engine.templateHandler.currentPageModel?.lockUnlockState = lockUnlockAl.newArray
            
        case .some(.filterTypeModel(let filterType)):
            setCurrentModelIfNeeded(engine: engine, currentId: filterType.id)
            engine.templateHandler.currentModel?.filterType = filterType.newValue
            
        case .some(.maskShapeModel(let maskModel)):
            setCurrentModelIfNeeded(engine: engine, currentId: maskModel.id)
            engine.templateHandler.currentModel?.maskShape = maskModel.newValue
            
        case .some(.colorAdjustmentTypeModel(let colorAdjustmentType)):
            setCurrentModelIfNeeded(engine: engine, currentId: colorAdjustmentType.id)
            engine.templateHandler.currentModel?.colorAdjustmentType = colorAdjustmentType.newValue
            
        case .some(.brightnessAdjustmentModel(let brightness)):
            setCurrentModelIfNeeded(engine: engine, currentId: brightness.id)
            engine.templateHandler.currentModel?.brightnessIntensity = brightness.newValue
            
        case .some(.contrastAdjustmentModel(let contrast)):
            setCurrentModelIfNeeded(engine: engine, currentId: contrast.id)
            engine.templateHandler.currentModel?.contrastIntensity = contrast.newValue
            
        case .some(.highlightAdjustmentModel(let highlight)):
            setCurrentModelIfNeeded(engine: engine, currentId: highlight.id)
            engine.templateHandler.currentModel?.highlightIntensity = highlight.newValue
            
        case .some(.shadowsAdjustmentModel(let shadows)):
            setCurrentModelIfNeeded(engine: engine, currentId: shadows.id)
            engine.templateHandler.currentModel?.shadowsIntensity = shadows.newValue
            
        case .some(.saturationAdjustmentModel(let saturation)):
            setCurrentModelIfNeeded(engine: engine, currentId: saturation.id)
            engine.templateHandler.currentModel?.saturationIntensity = saturation.newValue
            
        case .some(.vibranceAdjustmentModel(let vibrance)):
            setCurrentModelIfNeeded(engine: engine, currentId:vibrance.id)
            engine.templateHandler.currentModel?.vibranceIntensity = vibrance.newValue
            
        case .some(.sharpnessAdjustmentModel(let sharpness)):
            setCurrentModelIfNeeded(engine: engine, currentId:sharpness.id)
            engine.templateHandler.currentModel?.sharpnessIntensity = sharpness.newValue
            
        case .some(.warmthAdjustmentModel(let warmth)):
            setCurrentModelIfNeeded(engine: engine, currentId: warmth.id)
            engine.templateHandler.currentModel?.warmthIntensity = warmth.newValue
            
        case .some(.tintAdjustmentModel(let tint)):
            setCurrentModelIfNeeded(engine: engine, currentId: tint.id)
            engine.templateHandler.currentModel?.tintIntensity = tint.newValue
        case .some(.editStateToggle(let editAction)):
       //     break;
            setCurrentModelIfNeeded(engine: engine, currentId: editAction.id)
            if let currentModel = engine.templateHandler.currentModel as? ParentModel {
                currentModel.editState = editAction.newValue
            }

        case .some(.inAnimationDurationChange(let inAnimation)):
            setCurrentModelIfNeeded(engine: engine, currentId: inAnimation.id)
            engine.templateHandler.currentModel?.inAnimationDuration = inAnimation.newValue
        case .some(.outAnimationDurationChange(let outAnimation)):
            setCurrentModelIfNeeded(engine: engine, currentId: outAnimation.id)
            engine.templateHandler.currentModel?.outAnimationDuration = outAnimation.newValue
        case .some(.loopAnimationDurationChange(let loopAnimation)):
            setCurrentModelIfNeeded(engine: engine, currentId: loopAnimation.id)
            engine.templateHandler.currentModel?.loopAnimationDuration = loopAnimation.newValue
        case .outputTypeChanged(let output):
            engine.templateHandler.currentTemplateInfo?.outputType = output.newValue
        }
    }
    
    func setCurrentModelIfNeeded(engine: MetalEngine, currentId: Int , smartSelect:Bool = true ){
        if engine.templateHandler.currentModel?.modelId != currentId{
            engine.templateHandler.deepSetCurrentModel(id: currentId,smartSelect: smartSelect)
        }
    }
}
