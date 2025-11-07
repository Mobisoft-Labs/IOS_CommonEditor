//
//  TextChild.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import Foundation
import MetalKit

class TextChild:TexturableChild{
    
    init(model:TextInfo){
        super.init(model: model)
        print("textID",identification)
    }
    
}

class TestChild : StickerChild {
    override init(model: StickerInfo) {
        
        super.init(model: model)
       
    }

    
}
