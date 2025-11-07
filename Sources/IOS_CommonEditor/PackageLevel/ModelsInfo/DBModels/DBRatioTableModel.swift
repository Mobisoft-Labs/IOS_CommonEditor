//
//  RatioTable.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

public struct DBRatioTableModel: Identifiable {
    public var id: Int = 0
    public var category: String = ""
    public var categoryDescription: String = ""
    var imageResId: String = ""
    public var ratioWidth: Double = 0.0
    public var ratioHeight: Double = 0.0
    public var outputWidth: Double = 0.0
    public var outputHeight: Double = 0.0
    var isPremium: Int = 0
    
    public init(id: Int = 0, category: String = "", categoryDescription: String = "", imageResId: String = "", ratioWidth: Double = 0.0, ratioHeight: Double = 0.0, outputWidth: Double = 0.0, outputHeight: Double = 0.0, isPremium: Int = 0) {
        self.id = id
        self.category = category
        self.categoryDescription = categoryDescription
        self.imageResId = imageResId
        self.ratioWidth = ratioWidth
        self.ratioHeight = ratioHeight
        self.outputWidth = outputWidth
        self.outputHeight = outputHeight
        self.isPremium = isPremium
    }
}


