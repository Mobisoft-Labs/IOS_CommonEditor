//
//  IOSMetalLayer.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 17/01/23.
//

import MetalKit

class IOSMetalLayer : CAMetalLayer {
            
    init(device:MTLDevice) {
        super.init()
        self.device = device
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
