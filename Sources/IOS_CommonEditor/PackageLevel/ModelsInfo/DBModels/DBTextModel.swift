//
//  TextModel.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

public struct DBTextModel:DBTextModelProtocol {
  
    public var textId: Int = 0
    public var text: String = "Enter Your Text."
    public var textFont: String = ""
    public var textType: String = ""
    public var textColor: String = ""
    public var textGravity: String = ""
    public var lineSpacing: Double = 0.0
    public var letterSpacing: Double = 0.0
    public var shadowColor: String = ""
    public var shadowOpacity: Int = 0
    public var shadowRadius: Double = 0.0
    public var shadowDx: Double = 0.0
    public var shadowDy: Double = 0.0
    public var bgType: Int = 0
    public var bgDrawable: String = ""
    public var bgColor: String = ""
    public var bgAlpha: Double = 0
    public var internalWidthMargin: Double = 0.0
    public var internalHeightMargin: Double = 0.0
    public var xRotationProg: Int = 0
    public var yRotationProg: Int = 0
    public var zRotationProg: Int = 0
    public var curveProg: Int = 0
    public var templateID = 0
    
    public init(textId: Int = 0, text: String = "Enter Your Text.", textFont: String = "", textType: String = "", textColor: String = "", textGravity: String = "", lineSpacing: Double = 0.0, letterSpacing: Double = 0.0, shadowColor: String = "", shadowOpacity: Int = 0, shadowRadius: Double = 0.0, shadowDx: Double = 0.0, shadowDy: Double = 0.0, bgType: Int = 0, bgDrawable: String = "", bgColor: String = "", bgAlpha: Double = 0, internalWidthMargin: Double = 0.0, internalHeightMargin: Double = 0.0, xRotationProg: Int = 0, yRotationProg: Int = 0, zRotationProg: Int = 0, curveProg: Int = 0, templateID: Int = 0) {
        self.textId = textId
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.textGravity = textGravity
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowDx = shadowDx
        self.shadowDy = shadowDy
        self.bgType = bgType
        self.bgDrawable = bgDrawable
        self.bgColor = bgColor
        self.bgAlpha = bgAlpha
        self.internalWidthMargin = internalWidthMargin
        self.internalHeightMargin = internalHeightMargin
        self.xRotationProg = xRotationProg
        self.yRotationProg = yRotationProg
        self.zRotationProg = zRotationProg
        self.curveProg = curveProg
        self.templateID = templateID
    }
}


