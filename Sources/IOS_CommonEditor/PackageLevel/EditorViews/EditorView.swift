//
//  EditorView.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 18/03/24.
//

import UIKit

public class EditorView : UIView {
    
    var logger: PackageLogger
    var sceneConfig: SceneConfiguration
    var vmConfig: ViewManagerConfiguration
    
    deinit {
        logger.printLog("de-init \(self)")
    }
    /*
     var gestureView : UIGestureView
     var canvasView : CanvasView?
     var metalView
     var transform? = .identity

     init(rect:) {
     add GestureView
     autoresize to parent frame
     }
     */
    
    lazy public var gestureView : GestureHandlerView = {
        var gestView = GestureHandlerView(frame: self.bounds)
        gestView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        gestView.translatesAutoresizingMaskIntoConstraints = true
        gestView.backgroundColor = .clear
        return gestView
    }()
    
     var canvasView : CanvasView!
     var imageView : UIImageView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(gestureView)
//        self.clipsToBounds = true
//    }
    
    init(frame: CGRect, logger: PackageLogger, vmConfig: ViewManagerConfiguration, sceneConfig: SceneConfiguration) {
        self.logger = logger   // must initialize before calling super
        self.vmConfig = vmConfig
        self.sceneConfig = sceneConfig
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(gestureView)
        clipsToBounds = true
    }
    
   
    
    /* Updated By Neeshu */
    func prepareCanvasView(size:CGSize) {
        // If Canvas View is already created. Then no need to create it again only change the size of that with New Size.
        if canvasView == nil{
            let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            canvasView = CanvasView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            canvasView.center = center
            canvasView.isUserInteractionEnabled = false
            canvasView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            canvasView.translatesAutoresizingMaskIntoConstraints = true
            
            addSubview(canvasView)
        }
        else {
            canvasView.frame.size = size
        }
    }
    
    /* Updated By Neeshu */
    func prepareMetalView(size:CGSize) {
        // If Metal View is already created. Then no need to create it again only change the size of that with New Size.
        if canvasView.mtkScene == nil{
            let center = CGPoint(x: self.canvasView.bounds.width/2, y: self.canvasView.bounds.height/2)
            let metalView = IOSMetalView(frame: CGRect(x: 0, y: 0, width: self.canvasView.frame.size.width, height: self.canvasView.frame.size.height))
            metalView.center = center
            metalView.setPackageLogger(logger: logger, sceneConfig: sceneConfig)
//            metalView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
//            metalView.translatesAutoresizingMaskIntoConstraints = true
            
            canvasView.addSubview(metalView)
            metalView.backgroundColor = .clear

            metalView.addDropShadow()
            canvasView.mtkScene = metalView
        }
        else {
            canvasView.mtkScene?.frame.size = size
        }
    }
    
    func prepareSceneUIView(size:CGSize , tempId : Int , tempName : String) {
        let center = CGPoint(x: self.canvasView.bounds.width/2, y: self.canvasView.bounds.height/2)

        let sceneView = SceneView(id: tempId, name: tempName, logger: logger, vmConfig: vmConfig)
        sceneView.frame = CGRect(x: 0, y: 0, width: self.canvasView.frame.size.width, height: self.canvasView.frame.size.height)
        sceneView.center = center
//        sceneView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
//        sceneView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.addSubview(sceneView)
//        sceneView.backgroundColor = .white
//        sceneView.addDropShadow()
        canvasView.touchView = sceneView
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {

        if let canvasView = canvasView {
            canvasView.mtkScene?.frame.size = canvasView.bounds.size
            canvasView.touchView?.frame.size = canvasView.bounds.size
            let center = CGPoint(x: canvasView.bounds.width/2, y: canvasView.bounds.height/2)
            canvasView.mtkScene?.center = center
            canvasView.touchView?.center = center

        }
        
       
    }
    
    func updateCenter() {
        if let canvasView = canvasView {
            let center = CGPoint(x: canvasView.bounds.width/2, y: canvasView.bounds.height/2)
            canvasView.mtkScene?.center = center
            canvasView.touchView?.center = center
        }
    }
    
}


