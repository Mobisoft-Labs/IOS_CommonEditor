//
//  AnimationTemplates.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

public struct DBAnimationTemplateModel : AnimationTemplateProtocol {
    public var animationTemplateId: Int = 0
    public var name: String = "none"
    public var type: String = "ANY"
    public var category: Int = 1
    public var duration: Float = 1.0
    public var isLoopEnabled: Int = 0
    public var isAutoReverse: Int = 0
    public var icon: String = "None.png"
    
    public init(animationTemplateId: Int = 0, name: String = "none", type: String = "ANY", category: Int = 1, duration: Float = 1.0, isLoopEnabled: Int = 0, isAutoReverse: Int = 0, icon: String = "None.png") {
        self.animationTemplateId = animationTemplateId
        self.name = name
        self.type = type
        self.category = category
        self.duration = duration
        self.isLoopEnabled = isLoopEnabled
        self.isAutoReverse = isAutoReverse
        self.icon = icon
    }
}




public enum AnimeType : String {
    case In = "IN"
    case Out = "OUT"
    case Loop = "LOOP"
}
