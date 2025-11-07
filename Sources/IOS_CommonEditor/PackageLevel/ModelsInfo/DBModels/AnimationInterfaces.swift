//
//  AnimationProtocol.swift
//  MetalEngine
//
//  Created by HKBeast on 25/07/23.
//

import Foundation

public protocol AnimationTemplateProtocol {
    var animationTemplateId: Int { get set }
    var name: String { get set }
    var type: String { get set }
    var category: Int { get set }
    var duration: Float { get set }
    var isLoopEnabled: Int { get set }
    var isAutoReverse: Int { get set }
    var icon: String { get set }
}

public protocol AnimationModelProtocol {
    var animationId: Int { get set }
    var modelId: Int { get set }
    var inAnimationTemplateId: Int { get set }
    var inAnimationDuration: Float { get set }
    var loopAnimationTemplateId: Int { get set }
    var loopAnimationDuration: Float { get set }
    var outAnimationTemplateId: Int { get set }
    var outAnimationDuration: Float { get set }
}

public protocol AnimationCategoriesModelProtocol {
    var animationCategoriesId: Int { get set }
    var animationName: String { get set }
    var animationIcon: String { get set }
    var order: Int { get set }
    var enabled: Int { get set }
}

public protocol AnimKeyframeModelProtocol {
    var keyframeId: Int { get set }
    var animationTemplateId: Int { get set }
    var keytime: Float { get set }
    var translationX: Float { get set }
    var translationY: Float { get set }
    var scaleX: Float { get set }
    var scaleY: Float { get set }
    var rotationX: Float { get set }
    var rotationY: Float { get set }
    var rotationZ: Float { get set }
    var skewX: Float { get set }
    var skewY: Float { get set }
    var opacity: Float { get set }
    var effectProgress: Float { get set }
    var easingFunction: String { get set }
    var translationRelativeTo: Int { get set }
    var scaleAnchorX: Float { get set }
    var scaleAnchorY: Float { get set }
    var scaleAnchorRelativeTo: Int { get set }
    var rotationXAnchorX: Float { get set }
    var rotationXAnchorY: Float { get set }
    var rotationXAnchorRelativeTo: Int { get set }
    var rotationYAnchorX: Float { get set }
    var rotationYAnchorY: Float { get set }
    var rotationYAnchorRelativeTo: Int { get set }
    var rotationZAnchorX: Float { get set }
    var rotationZAnchorY: Float { get set }
    var rotationZAnchorRelativeTo: Int { get set }
    var skewAnchorX: Float { get set }
    var skewAnchorY: Float { get set }
    var skewAnchorRelativeTo: Int { get set }
    var shader: String { get set }
}
