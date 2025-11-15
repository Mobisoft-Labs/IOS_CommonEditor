//
//  BaseModel.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

public struct DBBaseModel:DBBaseModelProtocol{
   
    
    
    public var filterType: Int = 0
    
    public var brightnessIntensity: Float = 0
     
    public var contrastIntensity: Float = 0
     
    public var highlightIntensity: Float = 0
     
    public var shadowsIntensity: Float = 0
     
    public var saturationIntensity: Float = 0
    public var vibranceIntensity: Float = 0
    public var sharpnessIntensity: Float = 0
    public var warmthIntensity: Float = 0
    public var tintIntensity: Float = 0
    public var hasMask: Int = 0
    public var maskShape: String = ""

    public var parentId: Int = 0
    public var modelId: Int = 0
    public var modelType: String = ""
    public var dataId: Int = 0
    public var posX: Double = 0.0
    public var posY: Double = 0.0
    public var width: Double = 0.0
    public var height: Double = 0.0
    public var prevAvailableWidth: Double = 0.0
    public var prevAvailableHeight: Double = 0.0
    public var rotation: Double = 0
    public var modelOpacity: Double = 1
    public var modelFlipHorizontal: Int = 0
    public var modelFlipVertical: Int = 0
    public var lockStatus: String = ""
    public var orderInParent: Int = 0
    public var bgBlurProgress: Int = 0
    public var overlayDataId: Int = 0
    public var overlayOpacity: Int = 1
    public var startTime: Double = 0.0
    public var duration: Double = 5.0
    public var softDelete: Int = 0
    public var isHidden: Bool = false
    public var templateID : Int = 0 //Updated by Neeshu
    public var children : [ServerBaseModel] = []
    public var inAnimation : DBAnimationTemplateModel =  DBAnimationTemplateModel()
    public var inAnimationDuration : Float = 0.0
    public var outAnimation : DBAnimationTemplateModel =  DBAnimationTemplateModel()
    public var outAnimationDuration : Float = 0.0
    public var loopAnimation : DBAnimationTemplateModel =  DBAnimationTemplateModel()
    public var loopAnimationDuration : Float = 0.0
    
    public init(filterType: Int = 0, brightnessIntensity: Float = 0, contrastIntensity: Float = 0, highlightIntensity: Float = 0, shadowsIntensity: Float = 0, saturationIntensity: Float = 0, vibranceIntensity: Float = 0, sharpnessIntensity: Float = 0, warmthIntensity: Float = 0, tintIntensity: Float = 0, hasMask: Int = 0, maskShape: String = "", parentId: Int = 0, modelId: Int = 0, modelType: String = "", dataId: Int = 0, posX: Double = 0.0, posY: Double = 0.0, width: Double = 0.0, height: Double = 0.0, prevAvailableWidth: Double = 0.0, prevAvailableHeight: Double = 0.0, rotation: Double = 0, modelOpacity: Double = 1, modelFlipHorizontal: Int = 0, modelFlipVertical: Int = 0, lockStatus: String = "", orderInParent: Int = 0, bgBlurProgress: Int = 0, overlayDataId: Int = 0, overlayOpacity: Int = 0, startTime: Double = 0.0, duration: Double = 5.0, softDelete: Int = 0, isHidden: Bool = false, templateID: Int = 0, children: [ServerBaseModel] = [], inAnimation: DBAnimationTemplateModel = DBAnimationTemplateModel(), inAnimationDuration: Float = 0.0, outAnimation: DBAnimationTemplateModel = DBAnimationTemplateModel(), outAnimationDuration: Float = 0.0, loopAnimation: DBAnimationTemplateModel = DBAnimationTemplateModel(), loopAnimationDuration: Float = 0.0) {
        self.filterType = filterType
        self.brightnessIntensity = brightnessIntensity
        self.contrastIntensity = contrastIntensity
        self.highlightIntensity = highlightIntensity
        self.shadowsIntensity = shadowsIntensity
        self.saturationIntensity = saturationIntensity
        self.vibranceIntensity = vibranceIntensity
        self.sharpnessIntensity = sharpnessIntensity
        self.warmthIntensity = warmthIntensity
        self.tintIntensity = tintIntensity
        self.hasMask = hasMask
        self.maskShape = maskShape
        self.parentId = parentId
        self.modelId = modelId
        self.modelType = modelType
        self.dataId = dataId
        self.posX = posX
        self.posY = posY
        self.width = width
        self.height = height
        self.prevAvailableWidth = prevAvailableWidth
        self.prevAvailableHeight = prevAvailableHeight
        self.rotation = rotation
        self.modelOpacity = modelOpacity
        self.modelFlipHorizontal = modelFlipHorizontal
        self.modelFlipVertical = modelFlipVertical
        self.lockStatus = lockStatus
        self.orderInParent = orderInParent
        self.bgBlurProgress = bgBlurProgress
        self.overlayDataId = overlayDataId
        self.overlayOpacity = overlayOpacity
        self.startTime = startTime
        self.duration = duration
        self.softDelete = softDelete
        self.isHidden = isHidden
        self.templateID = templateID
        self.children = children
        self.inAnimation = inAnimation
        self.inAnimationDuration = inAnimationDuration
        self.outAnimation = outAnimation
        self.outAnimationDuration = outAnimationDuration
        self.loopAnimation = loopAnimation
        self.loopAnimationDuration = loopAnimationDuration
    }
}



