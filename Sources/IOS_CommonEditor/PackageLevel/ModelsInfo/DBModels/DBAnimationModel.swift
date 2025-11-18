//
//  DataModels.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation
public struct DBAnimationModel : AnimationModelProtocol{
    public var animationId: Int = 0
    public var modelId: Int = 0 // Exception
    public var inAnimationTemplateId: Int = 1
    public var inAnimationDuration: Float = 1.0
    public var loopAnimationTemplateId: Int = 1
    public var loopAnimationDuration: Float = 1.0
    public var outAnimationTemplateId: Int = 1
    public var  outAnimationDuration: Float = 1.0
    public var templateID :Int = 0
    
    public init(animationId: Int = 0, modelId: Int = 0, inAnimationTemplateId: Int = 1, inAnimationDuration: Float = 1.0, loopAnimationTemplateId: Int = 1, loopAnimationDuration: Float = 1.0, outAnimationTemplateId: Int = 1, outAnimationDuration: Float = 1, templateID: Int = 0) {
        self.animationId = animationId
        self.modelId = modelId
        self.inAnimationTemplateId = inAnimationTemplateId
        self.inAnimationDuration = inAnimationDuration
        self.loopAnimationTemplateId = loopAnimationTemplateId
        self.loopAnimationDuration = loopAnimationDuration
        self.outAnimationTemplateId = outAnimationTemplateId
        self.outAnimationDuration = outAnimationDuration
        self.templateID = templateID
    }
}
