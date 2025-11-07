//
//  AnimationKeyFrame.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

struct DBAnimKeyframeModel:AnimKeyframeModelProtocol {
    var keyframeId: Int = 0
    var animationTemplateId: Int = 0
    var keytime: Float = 0.0
    var translationX: Float = 0.0
    var translationY: Float = 0.0
    var scaleX: Float = 1.0
    var scaleY: Float = 1.0
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var skewX: Float = 0.0
    var skewY: Float = 0.0
    var opacity: Float = 1.0
    var effectProgress: Float = 0.0
    var easingFunction: String = ""
    var translationRelativeTo: Int = 0
    var scaleAnchorX: Float = 0.0
    var scaleAnchorY: Float = 0.0
    var scaleAnchorRelativeTo: Int = 0
    var rotationXAnchorX: Float = 0.0
    var rotationXAnchorY: Float = 0.0
    var rotationXAnchorRelativeTo: Int = 0
    var rotationYAnchorX: Float = 0.0
    var rotationYAnchorY: Float = 0.0
    var rotationYAnchorRelativeTo: Int = 0
    var rotationZAnchorX: Float = 0.0
    var rotationZAnchorY: Float = 0.0
    var rotationZAnchorRelativeTo: Int = 0
    var skewAnchorX: Float = 0.0
    var skewAnchorY: Float = 0.0
    var skewAnchorRelativeTo: Int = 0
    var shader: String = ""
}


