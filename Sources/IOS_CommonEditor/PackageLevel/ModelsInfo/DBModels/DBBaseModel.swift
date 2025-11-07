//
//  BaseModel.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

struct DBBaseModel:DBBaseModelProtocol{
   
    
    
    var filterType: Int = 0
    
    var brightnessIntensity: Float = 0
    
    var contrastIntensity: Float = 0
    
    var highlightIntensity: Float = 0
    
    var shadowsIntensity: Float = 0
    
    var saturationIntensity: Float = 0
    
    var vibranceIntensity: Float = 0
    
    var sharpnessIntensity: Float = 0
    
    var warmthIntensity: Float = 0
    
    var tintIntensity: Float = 0
    
    var hasMask: Int = 0
    var maskShape: String = ""

    
    var parentId: Int = 0
    var modelId: Int = 0
    var modelType: String = ""
    var dataId: Int = 0
    var posX: Double = 0.0
    var posY: Double = 0.0
    var width: Double = 0.0
    var height: Double = 0.0
    var prevAvailableWidth: Double = 0.0
    var prevAvailableHeight: Double = 0.0
    var rotation: Double = 0
    var modelOpacity: Double = 1
    var modelFlipHorizontal: Int = 0
    var modelFlipVertical: Int = 0
    var lockStatus: String = ""
    var orderInParent: Int = 0
    var bgBlurProgress: Int = 0
    var overlayDataId: Int = 0
    var overlayOpacity: Int = 1
    var startTime: Double = 0.0
    var duration: Double = 5.0
    var softDelete: Int = 0
    var isHidden: Bool = false
    var templateID : Int = 0 //Updated by Neeshu
    var children : [ServerBaseModel] = []
    
    var inAnimation : DBAnimationTemplateModel =  DBAnimationTemplateModel()
    var inAnimationDuration : Float = 0.0
    var outAnimation : DBAnimationTemplateModel =  DBAnimationTemplateModel()
    var outAnimationDuration : Float = 0.0
    var loopAnimation : DBAnimationTemplateModel =  DBAnimationTemplateModel()
    var loopAnimationDuration : Float = 0.0
}



