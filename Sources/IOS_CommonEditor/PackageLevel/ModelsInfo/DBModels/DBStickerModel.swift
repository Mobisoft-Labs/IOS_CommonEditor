//
//  Sticker.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation


public struct DBStickerModel :DBStickerModelProtocol{
    
    public var stickerId: Int = 1
    public var imageId: Int = 1
    public var stickerType: String = "COLORED"
    public var stickerFilterType: Int = 0
    public var stickerHue: Int = 0
    public var stickerColor: String = ""
    public var xRotationProg: Int = 1
    public var yRotationProg: Int = 1
    public var zRotationProg: Int = 1
    public var templateID : Int = 0
    public var stickerModelType : String = ""
    
    public init(stickerId: Int = 1, imageId: Int = 1, stickerType: String = "COLORED", stickerFilterType: Int = 0, stickerHue: Int = 0, stickerColor: String = "", xRotationProg: Int = 1, yRotationProg: Int = 1, zRotationProg: Int = 1, templateID: Int = 0, stickerModelType: String = "") {
        self.stickerId = stickerId
        self.imageId = imageId
        self.stickerType = stickerType
        self.stickerFilterType = stickerFilterType
        self.stickerHue = stickerHue
        self.stickerColor = stickerColor
        self.xRotationProg = xRotationProg
        self.yRotationProg = yRotationProg
        self.zRotationProg = zRotationProg
        self.templateID = templateID
        self.stickerModelType = stickerModelType
    }
}



