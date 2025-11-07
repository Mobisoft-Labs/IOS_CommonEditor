//
//  MFrameCollection.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation
import Foundation

class KeyFrameCollection {
     var collection: [KeyFrame]
    
    init() {
        collection = []
    }
    
    deinit {
//        for keyFrame in collection {
//            keyFrame.delete()
//        }
        collection.removeAll()
      //  print("KeyFrameCollection Deleted Successfully")
    }
    
    func add(component: KeyFrame) {
        collection.append(component)
    }
    
    func remove(component: KeyFrame) {
        if let index = collection.firstIndex(where: { $0 === component }) {
            collection.remove(at: index)
        }
    }
    
    func indexOf(component: KeyFrame) -> Int {
        if let index = collection.firstIndex(where: { $0 === component }) {
            return index
        }
        return -1
    }
    
    func elementAt(index: Int) -> KeyFrame? {
        if index >= 0 && index < collection.count {
            return collection[index]
        }
        return nil
    }
    
    func getCount() -> Int {
        return collection.count
    }
    
    func clear() {
//        for keyFrame in collection {
//            keyFrame.delete()
//        }
        collection.removeAll()
    }
}
