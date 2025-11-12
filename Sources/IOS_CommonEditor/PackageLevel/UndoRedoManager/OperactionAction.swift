//
//  OperactionAction.swift
//  FlyerDemo
//
//  Created by HKBeast on 04/11/25.
//

import Foundation
import UIKit

enum OperationAction {
    case OpacityChanged(OpacityUndoModel)
    case CropChanged(CropActionModel)
    case flipHorizontalChanged(FlipHorizontalAction)
    case flipVeticalChanged(FlipVerticalAction)
    case lockChanged(LockUnlockAction)
    case centerChanged(CenterChanged)
    case frameChanged(FrameChanged)
    case timeChanged(TimeChanged)
    case rotationChanged(RotationChanged)
    case deleteAction(DeleteAction)
    case stickerColorChanged(StickerColorChanged)
    case stickerHueChanged(StickerHueChanged)
    case stickerImageChanged(StickerImageChanged)
    case stikerFilterChanged(StickerFilterChanged)
    case stickerImageContent(StickerImageContentChanged)
    case posXChanged(PosXChanged)
    case posYChanged(PosYChanged)
    case textChanged(TextChanged)
    case textColorChanged(TextColorChanged)
    case textShadowColorChanged(TextShadowColorChanged)
    case textShadowRadiusChanged(TextShadowRadiusChanged)
    case textShadowDxChanged(TextShadowDxChanged)
    case textShadowDyChanged(TextShadowDyChanged)
    case textAlignmentChanged(TextAlignmentChanged)
    case textLetterSpacingChanged(TextLetterSpacingChanged)
    case textLineSpacingChanged(TextLineSpacingChanged)
    case textFontChanged(TextFontChanged)
    case textBgColorChanged(TextBgColorChanged)
    case textBgAlphaChanged(TextBgAlphaChanged)
    case pageTileAMultipleChanged(PageTileAMultipleChanged)
    case pageBGChanged(PageBGChanged)
    case pageBGBlurChanged(PageBGBlurChanged)
    case pageBGColorChanged(PageBGColorChanged)
    case pageOverlayChanged(PageOverlayChanged)
    case pageOverlayOpacityChanged(PageOverlayOpacityChanged)
    case pageBGContentChanged(PageBGContentChanged)
    case pageBGOverlayContentChanged(PageBGOverlayContentChanged)
    case pageOrderChanged(PageOrderChanged)
    case MoveModelChanged(MoveModel)
    case animationChanged(AnimationActiom)
    case lockUnlockAll(lockUnlockAllAction)
    case pageRatioChanged(PageRatioChange)
    case musicChanged(MusicChange)
    case textModelChanged(TextModelChangedForUndoRedo)
    case filterTypeModel(FilterTypeModel)
    case colorAdjustmentTypeModel(ColorAdjustmentTypeModel)
    case brightnessAdjustmentModel(BrightnessAdjustmentModel)
    case contrastAdjustmentModel(ContrastAdjustmentModel)
    case highlightAdjustmentModel(HighlightAdjustmentModel)
    case shadowsAdjustmentModel(ShadowsAdjustmentModel)
    case saturationAdjustmentModel(SaturationAdjustmentModel)
    case vibranceAdjustmentModel(VibranceAdjustmentModel)
    case sharpnessAdjustmentModel(SharpnessAdjustmentModel)
    case warmthAdjustmentModel(WarmthAdjustmentModel)
    case tintAdjustmentModel(TintAdjustmentModel)
    case maskShapeModel(MaskShapeModel)
    case editStateToggle(EditStateAction)
    case inAnimationDurationChange(InAnimationDurationChange)
    case outAnimationDurationChange(OutAnimationDurationChange)
    case loopAnimationDurationChange(LoopAnimationDurationChange)
    case outputTypeChanged(OutputTypeAction)
}

struct OutputTypeAction{
    var oldvalue: OutputType
    var newValue: OutputType
    var id: Int
}

struct EditStateAction{
    var oldvalue: Bool
    var newValue: Bool
    var id: Int
}

struct CropActionModel{
    var oldCropRect: CGRect
    var newCropRect: CGRect
    
    var id: Int
}

struct AnimationActiom{
    var id : Int
    var newValue : AnimTemplateInfo
    var oldValue : AnimTemplateInfo
}

struct InAnimationDurationChange{
    var id : Int
    var newValue : Float
    var oldValue : Float
}

struct OutAnimationDurationChange{
    var id : Int
    var newValue : Float
    var oldValue : Float
}

struct LoopAnimationDurationChange{
    var id : Int
    var newValue : Float
    var oldValue : Float
}

struct OpacityUndoModel {
    var oldOpacity : Float
    var newOpacity : Float
    var id : Int
}

struct FlipHorizontalAction{
    var oldvalue: Bool
    var newValue: Bool
    var id: Int
}

struct FlipVerticalAction{
    var oldvalue: Bool
    var newValue: Bool
    var id: Int
}

struct LockUnlockAction{
    var oldStatus: Bool
    var newStatus: Bool
    var id: Int
}

struct FrameChanged{
    var oldValue : Frame
    var newValue : Frame
    var shouldRevert : Bool = false
    var isParentDragging : Bool = false
    var id : Int
}

struct TimeChanged{
    var oldValue : StartDuration
    var newValue : StartDuration
    var id : Int
}

struct CenterChanged{
    var oldValue : CGPoint
    var newValue : CGPoint
    var id : Int
}

struct StickerColorChanged{
    var oldStickerColor: UIColor
    var newStickerColor: UIColor
    var id : Int
}

struct StickerHueChanged{
    var oldHue: Float
    var newHue: Float
    var id: Int
}

struct StickerImageChanged{
    var oldStickerResId: String
    var newStickerResId: String
    var id: Int
}

struct StickerFilterChanged{
    var oldFilter:AnyColorFilter
    var newFilter:AnyColorFilter
    var id:Int
}

struct StickerImageContentChanged{
    var oldContent:ReplaceModel
    var newContent : ReplaceModel
    var id : Int
}
struct PosXChanged{
    var oldPosX: CGFloat
    var newPosX: CGFloat
    var id: Int
}

struct PosYChanged{
    var oldPosY: CGFloat
    var newPosY: CGFloat
    var id: Int
}

struct TextChanged{
    var shouldRender = true
    var oldText: String
    var newText: String
    var id: Int
}

struct TextModelChangedForUndoRedo{
    var id : Int
    var textModel : TextModelChanged
}

struct TextColorChanged{
    var oldTextColor: AnyBGContent
    var newTextColor: AnyBGContent
    var id: Int
}

struct TextShadowColorChanged{
    var oldShadowColor: AnyColorFilter
    var newShadowColor: AnyColorFilter
    var id: Int
}

struct TextShadowRadiusChanged{
    var oldShadowRadius: Float
    var newShadowRadius: Float
    var id: Int
}

struct TextShadowDxChanged{
    var oldShadowDx: Float
    var newShadowDx: Float
    var id: Int
}

struct TextShadowDyChanged{
    var oldShadowDy: Float
    var newShadowDy: Float
    var id: Int
}

struct TextAlignmentChanged{
    var oldAlignment: HTextGravity
    var newAlignment: HTextGravity
    var id: Int
}

struct TextLetterSpacingChanged{
    var oldLetterSpacing: Float
    var newLetterSpacing: Float
    var id: Int
}

struct TextLineSpacingChanged{
    var oldLineSpacing: Float
    var newLineSpacing: Float
    var id: Int
}

struct TextFontChanged{
    var oldFont: String
    var newFont: String
    var id: Int
}

struct TextNameChnaged{
    var oldText : String
    var newText : String
    var id : Int
}

struct TextBgColorChanged{
    var oldBgColor: AnyBGContent
    var newBGColor: AnyBGContent
    var id: Int
}

struct TextBgAlphaChanged{
    var oldBgAlpha: Float
    var newBgAlpha: Float
    var id: Int
}

struct PageTileAMultipleChanged{
    var oldTileMultiple: Float
    var newTileMultiple: Float
    var id: Int
}

struct PageBGChanged{
    var oldResId: String
    var newResId: String
    var id: Int
}

struct PageBGBlurChanged{
    var oldBgBlur: Float
    var newBgBlur: Float
    var id: Int
}

struct PageBGColorChanged{
    var oldBgColor: UIColor
    var newBgColor: UIColor
    var id: Int
}

struct PageGradientChanged{
    var oldGradientInfo: GradientInfo
    var newGradientInfo: GradientInfo
    var id: Int
}

struct PageOverlayChanged{
    var oldOverlayResId: String
    var newOverlayResId: String
    var id: Int
}

struct PageOverlayOpacityChanged{
    var oldOverlayOpacity: Float
    var newOverlayOpacity: Float
    var id: Int
}

struct PageBGContentChanged{
    var oldBGContent:AnyBGContent
    var newBGContent:AnyBGContent
    var id:Int
}



struct PageBGOverlayContentChanged{
    var oldBGContent:AnyBGContent?
    var newBGContent:AnyBGContent?
    var id:Int
}

struct PageOrderChanged{
    var oldOrder : Int
    var newOrder : Int
    var id : Int
}

struct PageRatioChange{
    var id : Int
    var oldRatioModel : RatioInfo
    var newRatioModel : RatioInfo
}

struct MusicChange{
    var id : Int
    var oldMusicModel : MusicInfo?
    var newMusicModel : MusicInfo?
}

struct lockUnlockAllAction{
    var id: Int
    var newArray : [LockUnlockModel]
    var oldArray : [LockUnlockModel]
}


//Chnages made by NK for Filter and Adjustment.

struct FilterTypeModel{
    var id : Int
    var oldValue : FiltersEnum
    var newValue : FiltersEnum
}

struct ColorAdjustmentTypeModel{
    var id : Int
    var oldValue : String
    var newValue : String
}

struct BrightnessAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct ContrastAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct HighlightAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct ShadowsAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct SaturationAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct VibranceAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct SharpnessAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct WarmthAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct TintAdjustmentModel{
    var id : Int
    var oldValue : Float
    var newValue : Float
}

struct MaskShapeModel{
    var id : Int
    var oldValue : String
    var newValue : String
}

struct DeleteAction{
    var oldValue : Bool
    var newValue : Bool
    var id: Int
    var oldShouldSelectID : Int
    var newShouldSelectID : Int
}

struct RotationChanged{
    var oldValue : Float
    var newValue : Float
    var id : Int
}
