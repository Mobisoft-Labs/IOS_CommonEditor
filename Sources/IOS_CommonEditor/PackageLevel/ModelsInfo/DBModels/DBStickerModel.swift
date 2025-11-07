//
//  Sticker.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation


struct DBStickerModel :DBStickerModelProtocol{
 
        var stickerId: Int = 1
        var imageId: Int = 1
        var stickerType: String = "COLORED"
        var stickerFilterType: Int = 0
        var stickerHue: Int = 0
        var stickerColor: String = ""
        var xRotationProg: Int = 1
        var yRotationProg: Int = 1
        var zRotationProg: Int = 1
        var templateID : Int = 0
        var stickerModelType : String = ""
    }



