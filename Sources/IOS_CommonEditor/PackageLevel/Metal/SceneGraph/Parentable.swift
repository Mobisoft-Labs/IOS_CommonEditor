//
//  Parentable.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 22/02/23.
//

import MetalKit

//protocol MParentable {
//    
//    var childern : [MChild]! { get set}
//    mutating func addChild(_ childObject: MChild)
//    mutating func removeChild(_ child: MChild)
//    var allChild:[MChild]{get}
//}

extension MParent {
     func addChild(_ childObject: MChild) {
         childern.append(childObject)
         childObject.parent = self as? MParent
    }
     func addChild(_ childObject: MChild,at:Int) {
        if childern.endIndex < at{
            childern.append(childObject)
            logger?.logError("Should'nt Happen I Think \(childern.endIndex) vs Order : \(at)")
        }
        else{
            childern.insert(childObject, at: at)
        }
        childObject.parent = self as? MParent
    }
    
     func removeChild(_ child: MChild) {
        // must discuss with jd Sir
        
        childern.removeAll { $0.id == child.id }
//        if let index = 	childern.firstIndex(where: {$0.id == child.id}){
//            childern.remove(at: index)
//        }
    }
    
     func removeChild(at:Int) {
        // must discuss with jd Sir
        
        childern.remove(at: at)
    }
    
    
    var parentableChilds : [MParent] {
        let parentables = childern.filter({$0 is MParent}) as? [MParent]
        return parentables ?? [MParent]()
    }
    
     func increaseChildsDepth(_ depth: Int) {
        if childern.isEmpty {
        }
    }
}

