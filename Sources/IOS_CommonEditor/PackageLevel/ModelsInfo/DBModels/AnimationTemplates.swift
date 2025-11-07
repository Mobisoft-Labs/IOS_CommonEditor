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
}




public enum AnimeType : String {
    case In = "IN"
    case Out = "OUT"
    case Loop = "LOOP"
}
