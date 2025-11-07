//
//  BaseView.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 26/03/24.
//

import UIKit
var deadTag = 0

public class TextView : BaseView {
    
    override func onActiveOn() {

        if vISLOCKED {
            _internalUILayerState = .Locked
            _internalDragHandlerState = .hideHandlers
            LockedStateUI()
        } else /* Selected  */{
            _internalUILayerState = .Selected
            _internalDragHandlerState = .showHandlersPlusSides
            SelectedStateUI()
        }
            
        updateBoarder()
        manageHandlers()
        
    }
    
    override func onActiveOff() {
       
    _internalUILayerState = .NotSelected
    _internalDragHandlerState = .hideHandlers
    NotSelectedStateUI()
    updateBoarder()
        manageHandlers()
    }
    
    override func onActiveOnMultiselect() {
        _internalUILayerState = .MuliSelected
        _internalDragHandlerState = .hideHandlers
            updateBoarder()
            manageHandlers()
    }
    
    override func onActiveOffMultiselect() {
        _internalUILayerState = .NotSelected
        _internalDragHandlerState = .hideHandlers
        updateBoarder()
        manageHandlers()
    }
    
    
}
public class StickerView : BaseView {
    override func onActiveOn() {

        if vISLOCKED {
            _internalUILayerState = .Locked
            _internalDragHandlerState = .hideHandlers
            LockedStateUI()
        } else /* Selected  */{
            _internalUILayerState = .Selected
            _internalDragHandlerState = .showHandlers
            SelectedStateUI()
        }
            
        updateBoarder()
        manageHandlers()
    }
   
    
    
    override func onActiveOff() {
       
    _internalUILayerState = .NotSelected
    _internalDragHandlerState = .hideHandlers
    NotSelectedStateUI()
    updateBoarder()
    manageHandlers()
    }
    
    override func onActiveOnMultiselect() {
        _internalUILayerState = .MuliSelected
        _internalDragHandlerState = .hideHandlers
            updateBoarder()
            manageHandlers()
    }
    
    override func onActiveOffMultiselect() {
        _internalUILayerState = .NotSelected
        _internalDragHandlerState = .hideHandlers
        updateBoarder()
        manageHandlers()
    }
    
}


//var currentActualTime : Float = 0.0
public class BaseView: ControlsView {
    
    
    
    
    override var editorView : UIView? {
        return parentView?.editorView ??  nil
    }
    

    override func LockedStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit," LOCKED ON \(identification)")
    }
    
    override  func SelectedStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit,"SELECTED  ON \(identification)")

    }
    
    override  func NotSelectedStateUI() {
    
        logger.logErrorJD(tag: .selectedVsEdit,"NOT SELECTED \(identification)")

    }
    
    override func EditStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit," NOT SUPPORTED EDIT \(vIS_EDIT) \(identification)")

    }
    
   
    
    var _currentTime : Float = 0
    
    var startTime : Float = 0
//
    var duration : Float = 0
    
    var currentTime: Float {
        return parentView?.currentTime ?? _currentTime
    }
    
    internal var vStartTime : Float  {
        return startTime + (parentView?.vStartTime ?? 0.0)
    }
    
//        didSet {
//            print("Duration:",_duration)
//        }
//    }
    
    //Sequence or orderInParent
    var orderInParent : Int = 0
    
    // Parent view reference (optional for root view)
    weak var parentView: ParentView?
    
//    // Computed property to calculate current time
//    var currentTime: Float {
//        return _currentTime + (parentView?.currentTime ?? 0)
//    }
 
    public override init(id: Int, name: String, logger: PackageLogger, vmConfig: ViewManagerConfiguration) {
        super.init(id: id, name: name, logger: logger, vmConfig: vmConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOrder(order : Int){
        self.orderInParent = order
    }

    
     func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // 1
         if !self.isUserInteractionEnabled || self.isHidden { // || self.alpha == 0
            return nil
        }
        //2
        var hitView: UIView? = self
        if !self.contains(point: point) {
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        
         if let hitView_ = hitView as? BaseView {
             
//             if hitView_.tag != deadTag{
//                 return hitView_
//             }
             if hitView_.canDisplay {
                 return hitView_
             }
            
             hitView = nil
        }

        return hitView
    }
    
   override var canDisplay: Bool {
        if currentTime >= vStartTime && currentTime <= vStartTime + duration && !isHidden {
            
          
            return true
        }
        return false
    }
   
    var shouldEntertain : Bool {
        if let page = self as? PageView {
            return true
        } else if let parent = self as? ParentView {
            if parent.childCount == 0 {
                return false
            }

            return true
            
        }
        return true
    }
    
}


func imageFromColor(color: UIColor, size: CGSize) -> UIImage? {
    // Create a rectangle with the given size
    let rect = CGRect(origin: .zero, size: size)
    
    // Begin a new image context with opaque, 0 scale
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    
    // Get the current context
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    // Fill the rectangle with the specified color
    context.setFillColor(color.cgColor)
    context.fill(rect)
    
    // Get the image from the current image context
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
        return nil
    }
    
    // End the image context
    UIGraphicsEndImageContext()
    
    return image
}
