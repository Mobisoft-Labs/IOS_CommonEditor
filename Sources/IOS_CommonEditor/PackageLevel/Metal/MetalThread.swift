//
//  MetalThread.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 16/04/24.
//

import Foundation

class MetalThread {
    private var queue: DispatchQueue
    private var currentTask: DispatchWorkItem?
    var stopRendering: Bool = false

    deinit {
        print("deinit - \(self)")
    }
    init(label: String) {
        queue = DispatchQueue(label: label , qos:.background, autoreleaseFrequency: .inherit)
    }


       func async(task: @escaping () -> Void) {
           // Cancel the previous task
           currentTask?.cancel()

           // Create a new task
           let newTask = DispatchWorkItem { [weak self] in
               guard self != nil else { return }
//               guard !newTask.isCancelled else { return }
               task()
           }

           currentTask = newTask
           queue.async(execute: newTask)
       }

       func clear() {
           currentTask?.cancel()
           stopRendering = true
       }
    
    func isCancelled() -> Bool {
        return currentTask?.isCancelled ?? true
    }
    
}


