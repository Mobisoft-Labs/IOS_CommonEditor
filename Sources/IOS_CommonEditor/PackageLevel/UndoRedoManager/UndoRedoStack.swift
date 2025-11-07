////
////  UndoRedoHandler.swift
////  Show Gallery Photos Practice
////
////  Created by HKBeast on 19/04/23.
////
//
//import Foundation
//import UIKit
//

struct UndoRedoStack<T> {
     var elements = [T]()
    
    // Push an element onto the stack
    mutating func push(_ element: T) {
        elements.append(element)
    }
    
    // Pop an element from the stack and return it
    mutating func pop() -> T? {
        return elements.popLast()
    }
    
    // Peek at the top element of the stack without removing it
    func peek() -> T? {
        return elements.last
    }
    
    // Check if the stack is empty
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    // Return the size of the stack
    func size() -> Int {
        return elements.count
    }
    
    // Empty the stack
    mutating func clear() {
        elements.removeAll()
        
    }
    
    
}

