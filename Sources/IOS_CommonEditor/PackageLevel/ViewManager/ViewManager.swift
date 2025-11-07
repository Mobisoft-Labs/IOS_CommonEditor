//
//  ViewManager.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 20/03/24.
//




import UIKit
import Combine
import SwiftUI

// Handle the selection of component.
public enum Component{
    case sticker
    case parent
    case page
    case text
    case base
}

//public var globalRefSize = CGSize(width: 393.0, height: 698.67)



public class ViewManager : GestureHandler ,
                    TemplateObserversProtocol ,
                    ActionStateObserversProtocol ,
                    PlayerControlsReadObservableProtocol
{
    var currentScale : CGFloat = 1.0
    var zoomInScale: CGFloat = 1.2
    var zoomOutScale: CGFloat {
        1 / zoomInScale
    }
    let minScale: CGFloat = 0.9
    let maxScale: CGFloat = 30.0
 
    var initialBeginPoint : CGPoint = .zero

    public var actionStateCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    public var modelPropertiesCancellables: Set<AnyCancellable> = []
    public var playerControlsCancellables: Set<AnyCancellable> = []
    var zoomCancellables : Set<AnyCancellable> = Set<AnyCancellable>()

    // Container for containing multiple control bar.
    var controlBarContainer : [UIHostingController<EditControlBar>] = []//[ControlBarEntry] = []//[UIHostingController<EditControlBar>] = []
    
//    public var controlBarProvider: AnyEditControlBarProvider?
//    public var easyToolBarProvider: AnyEasyToolBarProvider?
    
    // Cancellables for Edit State.
    var editStateCancellables: [Int: Set<AnyCancellable>] = [:]
    
    
   // var cancellablesEdit = Set<AnyCancellable>()
  
    var psScroller = PageScrollerHandler()
  
    var gridManager : GridManager?

    
    /// represents current Template placeholder view. contains array of pages as child in future.
    public weak var rootView : SceneView?
    
    /// currentActiveView view denotes the Current Selected View.
    var currentActiveView : BaseView?
    
    var currentParentView : ParentView?

    
    var zoomHostingerController : UIHostingController<ZoomController>?
    
//    var muteHostingerController : UIHostingController<MuteControl>?
    
    
    //Inverted scale for managing the controls of Control View.
    var invertScale : CGFloat = 1.0
    
    var initialRotation : Float = 0.0

    var logger: PackageLogger
    
    var vmConfig: ViewManagerConfiguration
    
    //Hostinger View for controllling the ControlBar of View Manger.
    var controlBarView :  UIHostingController<AnyView>?
    

    /// Canvas View  view for managing the changes in canavas view like scale and pan gesture.
   public weak var editView : EditorView?
    
    /// Template Handler class reference that handle all the operation regarding the templae.
   weak var templateHandler : TemplateHandler?
        
    

    /// multipleSelectViews denotes the array of child views.
    var multipleSelectViewsID = [Int]()
    

    var highlightedNearestSnappingView : BaseView?
    
    var showControlBar : Bool = false {
        didSet {

            
                showControlBar ? addControlBar() : removeControlBar()
                refreshControlBar = true

        }
    }
    
    var refreshControlBar:Bool = false {
        didSet {
            
            if let activeView = currentActiveView , activeView.canDisplay , !activeView.enableStealthMode , !(activeView is PageView) {
                controlBarView?.view.isHidden = false
                updateControlBarPosition()
            }else{
                controlBarView?.view.isHidden = true
            }
        }
    }
    
    
    var initialWidth : CGFloat = 0
    var initialHeight : CGFloat = 0

    
    
    deinit {
        logger.printLog("de-init \(self)")
    }
    
//    public func addControlBar<V: EditControlBarProtocol>(_ view: V) {
//        let controller = UIHostingController(rootView: AnyView(view))
//        controlBarContainer.append(controller)
//    }
        
//    public func setMuteControl<V: MuteControlProtocol>(_ view: V) {
//        muteHostingerController = UIHostingController(rootView: AnyView(view))
//    }
//    
    public func canRenderWatermark(_ canRender : Bool) {
        rootView?.showWatermark = canRender
    }
    
    
    public func setTemplateHandler(templateHandler:TemplateHandler) {
        self.templateHandler = templateHandler
        observeCurrentActions()
    }
    
    public init(canvasView : EditorView, logger: PackageLogger, vmConfig: ViewManagerConfiguration) {
       
        self.editView = canvasView
        self.logger = logger
        self.vmConfig = vmConfig
        guard let templateHandler = templateHandler else { return }
        zoomHostingerController = UIHostingController(rootView: ZoomController(actionStates: templateHandler.currentActionState))
        zoomHostingerController?.view.frame = CGRect(x: Int(logger.getBaseSize().width) - 135, y: 10, width: 130, height: 40)
        zoomHostingerController?.view.backgroundColor = .clear
        zoomHostingerController?.view.isHidden = true
        self.editView?.addSubview(zoomHostingerController!.view)
    
    }
    

    
    // Function used for setting the model of currently tapped view.
    func setCurrentModel(view : BaseView?) {
        templateHandler?.setCurrentModel(id: view!.tag)
       // currentActiveView = rootView?.viewWithTag(view!.tag) as? BaseView
    }


}



