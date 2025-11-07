//
//  DBBaseModelInterface.swift
//  VideoInvitation
//
//  Created by HKBeast on 29/08/23.
//

import Foundation


public protocol DBBaseModelProtocol {
    var modelId: Int { get set }
    var modelType: String { get set }
    var dataId: Int { get set }
    var posX: Double { get set }
    var posY: Double { get set }
    var width: Double { get set }
    var height: Double { get set }
    var prevAvailableWidth: Double { get set }
    var prevAvailableHeight: Double { get set }
    var rotation: Double { get set }
    var modelOpacity: Double { get set }
    var modelFlipHorizontal: Int { get set }
    var modelFlipVertical: Int { get set }
    var lockStatus: String { get set }
    var orderInParent: Int { get set }
    var parentId: Int { get set }
    var bgBlurProgress: Int { get set }
    var overlayDataId: Int { get set }
    var overlayOpacity: Int { get set }
    var startTime: Double { get set }
    var duration: Double { get set }
    var softDelete: Int { get set }
    var isHidden: Bool { get set }
    var templateID:Int{get set}
    
    var inAnimation : DBAnimationTemplateModel {get set}
    var inAnimationDuration : Float {get set}
    var outAnimation : DBAnimationTemplateModel {get set}
    var outAnimationDuration : Float {get set}
    var loopAnimation : DBAnimationTemplateModel {get set}
    var loopAnimationDuration : Float {get set}
    
    // Filters and Adjustment related changes done by NK.
    var filterType : Int {get set}
    var brightnessIntensity : Float {get set}
    var contrastIntensity : Float {get set}
    var highlightIntensity : Float {get set}
    var shadowsIntensity : Float {get set}
    var saturationIntensity : Float {get set}
    var vibranceIntensity : Float {get set}
    var sharpnessIntensity : Float {get set}
    var warmthIntensity : Float {get set}
    var tintIntensity : Float {get set}
    
    var hasMask: Int { get set }
    var maskShape: String { get set }
   
}

public protocol DBStickerModelProtocol {
    var stickerId: Int { get set }
    var imageId: Int { get set }
    var stickerType: String { get set }
    var stickerFilterType: Int { get set }
    var stickerHue: Int { get set }
    var stickerColor: String { get set }
    var xRotationProg: Int { get set }
    var yRotationProg: Int { get set }
    var zRotationProg: Int { get set }
    var stickerModelType : String { get set }
   
}


public protocol DBTextModelProtocol {
    var textId: Int { get set }
    var text: String { get set }
    var textFont: String { get set }
    var textColor: String { get set }
    var textGravity: String { get set }
    var lineSpacing: Double { get set }
    var letterSpacing: Double { get set }
    var shadowColor: String { get set }
    var shadowOpacity: Int { get set }
    var shadowRadius: Double { get set }
    var shadowDx: Double { get set }
    var shadowDy: Double { get set }
    var bgType: Int { get set }
    var bgDrawable: String { get set }
    var bgColor: String { get set }
    var bgAlpha: Double { get set }
    var internalWidthMargin: Double { get set }
    var internalHeightMargin: Double { get set }
    var xRotationProg: Int { get set }
    var yRotationProg: Int { get set }
    var zRotationProg: Int { get set }
    var curveProg: Int { get set }
}

public protocol DBImageProtocol {
    var imageID: Int { get set }
    var imageType: String { get set }
    var serverPath: String { get set }
    var localPath: String { get set }
    var resID: String { get set }
    var isEncrypted: Int { get set }
    var cropX: Double { get set }
    var cropY: Double { get set }
    var cropW: Double { get set }
    var cropH: Double { get set }
    var cropStyle: Int { get set }
    var tileMultiple: Double { get set }
    var colorInfo: String { get set }
    var imageWidth: Double { get set }
    var imageHeight: Double { get set }
}

public protocol DBRatioModelProtocol {
    var id: Int { get set }
    var category: String { get set }
    var categoryDescription: String { get set }
    var imageResId: String { get set }
    var ratioWidth: Double { get set }
    var ratioHeight: Double { get set }
    var outputWidth: Double { get set }
    var outputHeight: Double { get set }
    var isPremium: Int { get set }
}

public protocol DBTemplateModelProtocol {
    var category: String { get set }
    var categoryTemp: String { get set }
    var isPremium: Int { get set }
    var ratioId: Int { get set }
    var sequence_Temp: Int { get set }
    var templateId: Int { get set }
    var templateName: String { get set }
    var thumbLocalPath: String { get set }
    var thumbServerPath: String { get set }
    var thumbTime: Double { get set }
    var totalDuration: Double { get set }
}
