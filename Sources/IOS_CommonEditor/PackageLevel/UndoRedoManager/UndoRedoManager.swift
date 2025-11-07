//
//  UndoRedoManager.swift
//  VideoInvitation
//
//  Created by HKBeast on 28/03/24.
//

import Foundation
import Combine


public class UndoRedoManager  : TemplateObserversProtocol , ActionStateObserversProtocol {
    public func observeAsCurrentBaseModel(_ baseModel: BaseModel) {
        // No Need
    }
    
  
    
    public var modelPropertiesCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public var actionStateCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
   
    
    weak var templateHandler : TemplateHandler?
    
    /// State for handling Looping of undo.
    public var undoState : Bool = false
    @Published public var undoNumberCount:Bool = false
    @Published public var redoNumberCount:Bool = false
    
    var logger: PackageLogger
     var undoStack = UndoRedoStack<OperationAction>()
     var redoStack = UndoRedoStack<OperationAction>()
    
    init(logger: PackageLogger){
        self.logger = logger
        logger.printLog("init \(self)")
    }
    deinit {
        logger.printLog("de-init \(self)")
    }
    public func setTemplateHandler(templateHandler:TemplateHandler) {
        self.templateHandler = templateHandler
        observeCurrentActions()
    }
    
    func addOperation(_ operation: OperationAction , shouldAdd:Bool = true ) {
        if shouldAdd {
            undoStack.push(operation)
            logger.logInfo("operation added : \(operation)")
        }else{
            undoStack.pop()
        }
        redoStack.clear()
        if redoStack.size() > 0{
            redoNumberCount = true
        }else{
            redoNumberCount = false
        }
        if undoStack.size() > 0{
            undoNumberCount = true
        }else{
            undoNumberCount = false
        }
    }
    
    
    
    func undo() -> OperationAction? {
        if let operation = undoStack.pop() {
            redoStack.push(operation)
            if redoStack.size() > 0{
                redoNumberCount = true
            }else{
                redoNumberCount = false
            }
            if undoStack.size() > 0{
                undoNumberCount = true
            }else{
                undoNumberCount = false
            }
            return operation
        }
        return nil
    }
    
    func redo() -> OperationAction? {
        if let operation = redoStack.pop() {
            undoStack.push(operation)
            if redoStack.size() > 0{
                redoNumberCount = true
            }else{
                redoNumberCount = false
            }
            if undoStack.size() > 0{
                undoNumberCount = true
            }else{
                undoNumberCount = false
            }
            return operation
        }
        return nil
    }
    
    func peekUndo() -> OperationAction? {
        return undoStack.peek()
    }
    
    func peekRedo() -> OperationAction? {
        return redoStack.peek()
    }
    
    func isUndoEmpty() -> Bool {
        return undoStack.isEmpty()
    }
    
    func isRedoEmpty() -> Bool {
        return redoStack.isEmpty()
    }
    
    public func undoCount() -> Int{
        return undoStack.size()
    }
    
    public func redoCount() -> Int{
        return redoStack.size()
    }
    
    func clearStacks() {
        undoStack = UndoRedoStack<OperationAction>()
        redoStack = UndoRedoStack<OperationAction>()
    }
}



