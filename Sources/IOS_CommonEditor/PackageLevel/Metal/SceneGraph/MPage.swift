//
//  MPage.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import Foundation
import MetalKit

class MPage:MParent {
//    var backgroundChild:BGChild?
 
    init(pageInfo : PageInfo) {
        super.init(model: pageInfo)
        switchTo(type: .SceneRender)
    }

}
