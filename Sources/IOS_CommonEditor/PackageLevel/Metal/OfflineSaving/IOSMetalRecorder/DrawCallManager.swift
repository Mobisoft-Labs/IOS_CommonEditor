//
//  TimeLooper.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 20/01/23.
//

import MetalKit


protocol DrawCallListener : AnyObject{
    var ID : Int { get set }
    func onDrawCallListened(_ displayLink: CADisplayLink)
    
}

public class DrawCallManager{
    
    deinit {
        logger.printLog("de-init \(self)")
        listeners.removeAll()
        stopNotifyingDrawCall()
    }
     var listeners = [DrawCallListener]()
    var logger: PackageLogger
    
    private(set) var displayLink : CADisplayLink?
    var preferedFPS : CAFrameRateRange = CAFrameRateRange(minimum: Float(MetalDefaults.PreferredFrameRate), maximum: Float(MetalDefaults.PreferredFrameRate))
    public var onDrawCall : (()->Void)?
    
    init(logger: PackageLogger) {
        self.logger = logger
        logger.printLog("init \(self)")
        // setup our delegate listener reference
       // self.listener = listener
        
        // setup & kick off the display link
        startNotifyingDrawCall()
    }
    
    func  addListener(_ listner: DrawCallListener) {
        listeners.append(listner)
    }
    
    func  removeListener(_ listner: DrawCallListener) {
        listeners.removeAll(where: {$0.ID == listner.ID})
    }
    
    func startNotifyingDrawCall(){
        displayLink = CADisplayLink(target: self, selector: #selector(self.drawFrameCall))
           displayLink?.add(to: .main, forMode: .default)
        displayLink?.preferredFrameRateRange = preferedFPS
    }
    
    public func stopNotifyingDrawCall(){
        
        displayLink?.invalidate()
        listeners.removeAll()
    }
    
    @objc func drawFrameCall(){
        guard let displayLink else { return }
        listeners.forEach({$0.onDrawCallListened(displayLink)})
      // printLog("Listners",listeners.count)
    }
    
    
    
    
}






