//
//  AnimationCategories.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

public struct DBAnimationCategoriesModel:AnimationCategoriesModelProtocol {
 
    public var animationCategoriesId: Int = 0
    public var animationName: String = ""
    public var animationIcon: String = ""
    public var order: Int = 0
    public var enabled: Int = 0
}



