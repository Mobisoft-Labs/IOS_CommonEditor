//
//  TextModel.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

struct DBTextModel:DBTextModelProtocol {
  
    var textId: Int = 0
    var text: String = "Enter Your Text."
    var textFont: String = ""
    var textColor: String = ""
    var textGravity: String = ""
    var lineSpacing: Double = 0.0
    var letterSpacing: Double = 0.0
    var shadowColor: String = ""
    var shadowOpacity: Int = 0
    var shadowRadius: Double = 0.0
    var shadowDx: Double = 0.0
    var shadowDy: Double = 0.0
    var bgType: Int = 0
    var bgDrawable: String = ""
    var bgColor: String = ""
    var bgAlpha: Double = 0
    var internalWidthMargin: Double = 0.0
    var internalHeightMargin: Double = 0.0
    var xRotationProg: Int = 0
    var yRotationProg: Int = 0
    var zRotationProg: Int = 0
    var curveProg: Int = 0
    var templateID = 0
}


