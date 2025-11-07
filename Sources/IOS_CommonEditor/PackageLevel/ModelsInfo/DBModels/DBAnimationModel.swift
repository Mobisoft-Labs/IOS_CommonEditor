//
//  DataModels.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation
struct DBAnimationModel : AnimationModelProtocol{
   var animationId: Int = 0
    var modelId: Int = 0 // Exception
    var inAnimationTemplateId: Int = 1
    var inAnimationDuration: Float = 1.0
    var loopAnimationTemplateId: Int = 1
     var loopAnimationDuration: Float = 1.0
     var outAnimationTemplateId: Int = 1
    var  outAnimationDuration: Float = 1.0
    var templateID :Int = 0
  
}
