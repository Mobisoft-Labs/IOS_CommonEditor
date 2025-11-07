//
//  StickerChild.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import Foundation
import MetalKit

class StickerChild:TexturableChild{
     init(model: StickerInfo) {
         super.init(model: model)
//         canColorApply = true
    }
    
    override func preRenderCalculation() {
       // zRotation = 2 * context.currentTime
        super.preRenderCalculation()
    }
}


