//
//  ControlsView.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 28/01/25.
//

//
//  ControlView.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 26/03/24.
//


enum ContolViewState{
    case selected
    case unSelected
    case editState
    case multiSelect
}


import UIKit
import SwiftUI
import Foundation

protocol ControlsStateChanged{
    func didisLockedStateChnaged()
}

public class ControlsView : UIView {
    
    var editorView : UIView? {
        return nil
    }
    
    var _internalUILayerState : InternalUILayerState = .NotSelected
    var _internalDragHandlerState : InternalDragHandlerState = .hideHandlers
    
    enum InternalUILayerState {
        case Locked
        case Edited
        case Selected
        case NotSelected
        case MuliSelected
    }
    
    enum InternalDragHandlerState {
        case hideHandlers
        case showHandlers
        case showHandlersPlusSides
    }
    
    var selectedLayerColor = UIColor.white.cgColor
    var lockedLayerColor = UIColor.systemPink.cgColor
    var editLayerColor = UIColor.white.cgColor
    var dragHandlerColor = UIColor.systemPink.cgColor
    
    
    var vISLOCKED : Bool = false {
        didSet {
            refreshUI = true
        }
    }
    var vIS_EDIT : Bool = false {
        didSet {
            animateEditLayer = vIS_EDIT
            
            if isSelectedForMultiple {
                refreshUIForMultiselect()
            }else{
                refreshUI = true
            }
        }
           
    }
    
    
    var enableStealthMode : Bool = false {
        didSet {
            
            refreshUI = true
        }
    }
    
    private var animateEditLayer : Bool = false
    
    var refreshUI : Bool = true {
        didSet {
            updateUILayers()
        }
    }
    
    
    var canDisplay: Bool {
        return true
    }
    
    private  func updateUILayers() {
        
        placeHolderView.alpha =  canDisplay ? enableStealthMode ? 0.5 : 1.0 : 0.0
        
        isActive ? onActiveOn() : onActiveOff()
        
        
    }
    
    func LockedStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit," Not SUPOPRT ON \(identification)")
    }
    
    func SelectedStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit," Not SUPOPRT ON \(identification)")
    }
    
    func EditStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit," Not SUPOPRT ON \(identification)")
        
    }
    
    func NotSelectedStateUI() {
        logger.logErrorJD(tag: .selectedVsEdit," Not SUPOPRT ON \(identification)")
        
    }
    
    func onActiveOn() { }
    
    func onActiveOff() { }
    
    func onActiveOnMultiselect() { }
    
    func onActiveOffMultiselect() { }

    func manageHandlers() {
        if enableStealthMode {
            removeDragHandlers()
            return
        }
        if !canDisplay {
            removeDragHandlers()
            return
        }
        
        switch _internalDragHandlerState {
        case .hideHandlers: removeDragHandlers()
        case .showHandlers: addDragHandlers()
        case .showHandlersPlusSides: addDragHandlersWithSides()
        }
        
    }
    
    var notSelectedColor  : UIColor {
        return .clear
    }
    var notSelectedBorderWidth  : CGFloat {
        return 0
    }
    
    func updateBoarder(){
        removeDottedBorder()
        
        switch _internalUILayerState {
        case .Locked:
            placeHolderView.layer.borderWidth = 1 / invertedScale
            placeHolderView.layer.borderColor = lockedLayerColor
            placeHolderView.layer.shadowColor =  UIColor.gray.cgColor
            placeHolderView.layer.shadowOpacity = 1
            placeHolderView.layer.shadowOffset = CGSize.zero
            placeHolderView.layer.shadowRadius = 1 / invertedScale
            placeHolderView.layer.cornerRadius = 4.0 / invertedScale
        case .Edited:
            applyDottedBorder()
            placeHolderView.layer.shadowColor =  UIColor.gray.cgColor
            placeHolderView.layer.shadowOpacity = 1
            placeHolderView.layer.shadowOffset = CGSize.zero
            placeHolderView.layer.shadowRadius = 1 / invertedScale
            placeHolderView.layer.cornerRadius = 4.0 / invertedScale
        case .Selected:
            placeHolderView.layer.borderWidth = 1 / invertedScale
            placeHolderView.layer.borderColor = selectedLayerColor
            placeHolderView.layer.shadowColor =  UIColor.gray.cgColor
            placeHolderView.layer.shadowOpacity = 1
            placeHolderView.layer.shadowOffset = CGSize.zero
            placeHolderView.layer.shadowRadius = 1 / invertedScale
            placeHolderView.layer.cornerRadius = 4.0 / invertedScale
        case .NotSelected:
            placeHolderView.layer.borderWidth = notSelectedBorderWidth
            placeHolderView.layer.borderColor = notSelectedColor.cgColor
            placeHolderView.layer.shadowColor =  UIColor.clear.cgColor
            placeHolderView.layer.shadowOpacity = 0
            placeHolderView.layer.shadowOffset = CGSize.zero
            placeHolderView.layer.shadowRadius = 0
            placeHolderView.layer.cornerRadius = 0
        case .MuliSelected:
            placeHolderView.layer.borderWidth = 1 / invertedScale
            placeHolderView.layer.borderColor = UIColor.orange.cgColor
            placeHolderView.layer.shadowColor =  UIColor.gray.cgColor
            placeHolderView.layer.shadowOpacity = 1
            placeHolderView.layer.shadowOffset = CGSize.zero
            placeHolderView.layer.shadowRadius = 1 / invertedScale
            placeHolderView.layer.cornerRadius = 4.0 / invertedScale
        }
        
    }
    
    var thumbImage : UIImage?
    
    //Breathing space is the space that contain the controllers button like zoom , delete and lock.
    var _breath : CGFloat = 0
    var breathingSpace : CGFloat {
        set {
            _breath = newValue
        }
        get {
            return _breath
        }
        
    }
    
    @Published var _isLocked : Bool = false
    
    @Published var _isDelete : Bool = false
    
    var anchorable : Bool = true
    
    var distanceTravelled = 0.0
    
    //id contains the current ID of the view.
    //    var tagID : Int
    
    //name contains the current view name.
    var name : String
    
    //size contains the size of the current view.
    var size : CGSize = .zero
    
    //center contains the center of the current view.
    var centerPoints : CGPoint = .zero
    
    //rotationAngle contains the angle of the current view.
    var rotationAngle : Double = 0.0
    
    //For Text Dragging State.
    var isTextDragging : Bool = false
    
    // Decide the transform operation performed or not.
    var _canTransform : Bool {
        return !vISLOCKED && isTransformable
    }
    
    
    internal var isTransformable: Bool {
        return true
    }

    func refreshUIForMultiselect() {
           
            
            placeHolderView.alpha =  1.0
            
            isSelectedForMultiple ? onActiveOnMultiselect() : onActiveOffMultiselect()
        
    }
    var isSelectedForMultiple = false {
        
        didSet {
            if isSelectedForMultiple != oldValue {
                print("NKC \(isSelectedForMultiple) Id : \(self.tag), MultiSelect ")
                refreshUIForMultiselect()
            }
        }
    }
    
    var isActive = false {
        didSet {
            refreshUI = true
            if isActive {
                isActiveAnimation()
            }
        }
    }
    
    var invertedScale : CGFloat = 1.0 {
        didSet {
          invertScaling(scale: invertedScale)
          updateBoarder()
        }
    }
    
    

    
    
    // isRotating variable defines that the rotation is starting using button or parent gesture.
    var isRotating = false
    
    // isMoving variable defines that the move is starting using button or parent gesture.
    var isMoving = false
    
    // isScaled variable defines that the move is starting using button or parent gesture.
    var isScaling = false
    
    //Used for scaling from the corner points.
    var selectedView : String = ""
    
    func onDeleteAction(){
        self.isHidden = true
        enableStealthMode = true
       
    }
    
    func onUndeleteAction(){
        self.isHidden = false
        enableStealthMode = false
        
    }
    
    //Intial center , Rotation, Size for the gestures.
    var _initialCenter : CGPoint = .zero
    var _initialRotation : CGFloat = .zero
    var _currentRotation : CGFloat = .zero
    
    var _TouchLocationAtStart_Rotation = CGPoint.zero
    
    var _initialSize : CGSize = .zero
    var previousLocation = CGPointZero

    //Place holder that contain the buttons and dummy view.
    var placeHolderView : UIView!
    //Buttons that used for gestures actions and operations
    var topLeft:DragHandle?
    var topRight:DragHandle?
    var bottomLeft:DragHandle?
    var bottomRight:DragHandle?
    var rotateHandle:RotateHandle?
   // var hostingerView : UIHostingController<RotationController>?

    
    var topTextDragHandle: TextDragHandleForVertical?
    var bottomTextDragHandle : TextDragHandleForVertical?
    var leftTextDragHandle : TextDragHandleForHorizontal?
    var rightTextDragHandle : TextDragHandleForHorizontal?
    
    
        //JD
//    var pan : UIPanGestureRecognizer!
//    var tap : UITapGestureRecognizer!
    var identification : String {
        return "\(tag) : \(name)"
    }
    
    var logger: PackageLogger
    
    var vmConfig: ViewManagerConfiguration
    
    public init(id : Int , name : String, logger: PackageLogger, vmConfig: ViewManagerConfiguration){
        self.name = name
        self.logger = logger
        self.vmConfig = vmConfig
        super.init(frame: .zero)
        self.tag = id
        placeHolderView = UIView(frame: CGRect(origin: .zero, size: self.size))
        placeHolderView.backgroundColor = .systemPink.withAlphaComponent(0.0)//.green.withAlphaComponent(0.5)
        self.addSubview(placeHolderView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// Override layoutSubviews to update button position at runtime
    public override func layoutSubviews() {
      super.layoutSubviews()
     // removeDottedBorder(from: self.placeHolderView)
     // updateUIStates()
      placeHolderView.layer.sublayers?.filter({$0 is CAShapeLayer}).forEach({$0.frame = placeHolderView.bounds; ($0 as? CAShapeLayer)?.path  =  UIBezierPath(rect: $0.bounds).cgPath})
      self.updateDragHandles()
  }
    
    //Set Thumb Image
    func setThumbImage(thumbImage: UIImage){
        self.thumbImage = thumbImage
    }
    
    func setFrame(frame : Frame) {
        self.transform = CGAffineTransform.identity

        self.size = frame.size
        let newSize = CGSize(width: breathingSpace + size.width, height: breathingSpace + size.height)
        self.frame.size = newSize
        placeHolderView.frame.size = size
        
        self.centerPoints = frame.center
        self.center = frame.center
        placeHolderView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)

        
        let radians = frame.rotation * .pi / 180
        self.rotationAngle = Double((radians.truncatingRemainder(dividingBy: 2 * .pi) + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi))//radians
        self.transform = self.transform.rotated(by: rotationAngle)
        
       // refreshUI = true
    }

    //Function Used for invert the scale of controllers.
    func invertScaling(scale : CGFloat) {
         let inverseScale = 1 / scale
        //Inverted Scale For the Drag Corners
         topLeft?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
         topRight?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
         bottomLeft?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
         bottomRight?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
         rotateHandle?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
        
        topTextDragHandle?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
        bottomTextDragHandle?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
        leftTextDragHandle?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
        rightTextDragHandle?.transform = CGAffineTransform(scaleX: inverseScale, y: inverseScale)
        
     }


    func applyDottedBorder() {
        
        let dottedBorder = CAShapeLayer()
        dottedBorder.strokeColor = UIColor.white.cgColor
        dottedBorder.cornerRadius = 4.0
        dottedBorder.lineDashPattern = [4, 2] // 4 points long dash, 2 points space
        dottedBorder.frame = placeHolderView.bounds
        dottedBorder.fillColor = nil
        dottedBorder.path = UIBezierPath(rect: placeHolderView.bounds).cgPath
        placeHolderView.layer.addSublayer(dottedBorder)
        
        let dottedBorder2 = CAShapeLayer()
        dottedBorder2.cornerRadius = 4.0
        dottedBorder2.strokeColor = UIColor.black.cgColor
        dottedBorder2.lineDashPattern = [4, 2] // 4 points long dash, 2 points space
        dottedBorder2.frame = placeHolderView.bounds
        dottedBorder2.fillColor = nil
        dottedBorder2.path = UIBezierPath(rect: placeHolderView.bounds.insetBy(dx: 1, dy: 1)).cgPath
        placeHolderView.layer.addSublayer(dottedBorder2)
        
        if animateEditLayer {
            animateEditLayer = false
            // Animation for the transition from solid line to dotted line
            let dashAnimation = CABasicAnimation(keyPath: "lineDashPattern")
            dashAnimation.fromValue = [0,0]  // Starting with a solid line
            dashAnimation.toValue = [4, 2]    // Transitioning to a dashed line (4 points long dash, 2 points space)
            dashAnimation.duration = 0.5      // Duration of the animation
            dashAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            // Apply the animation to the layer
            dottedBorder.add(dashAnimation, forKey: "lineDashPatternAnimation")
            dottedBorder2.add(dashAnimation, forKey: "lineDashPatternAnimation")
            selectionVibrate()
        }

    }
    
    func removeDottedBorder() {
        placeHolderView.layer.sublayers?.filter({$0 is CAShapeLayer}).forEach({$0.removeFromSuperlayer()})
        placeHolderView.layer.borderWidth = 0
        placeHolderView.layer.borderColor = UIColor.clear.cgColor

     }

 
    //Used for bring the selected view in the front of all view.
    func bringToTop(child:UIView){
        self.bringSubviewToFront(child)
    }
    
    var isHighLighted : Bool = false {
        didSet {
            updateHighLightState()
        }
    }
    func updateHighLightState(){
        isHighLighted ?  highLightSelectedView() : unHighLightSelectedView()
    }
    
    func highLightSelectedView(){
        self.layer.borderColor = UIColor.red.withAlphaComponent(0.4).cgColor//.alpha(0.4)
        self.layer.borderWidth = 1
    }
    
    func unHighLightSelectedView(){
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    
    //Shows the controls of the selected view.
    func addDragHandlers() {
        //if controllable {
            removeDragHandlers()
            
        let resizeFillColor = vmConfig.accentColorUIKit//Color()
        let resizeStrokeColor = UIColor.white//Color()
        let rotateFillColor = UIColor.white//Color()
            let rotateStrokeColor = UIColor.clear//Color()
            

        topLeft = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        topRight = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        bottomLeft = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        bottomRight = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        rotateHandle = RotateHandle(fillColor: rotateFillColor, strokeColor: rotateStrokeColor , imageName:"arrow.trianglehead.2.counterclockwise", vmConfig: vmConfig)
        //hostingerView = UIHostingController(rootView: RotationController())
            
           // hostingerView?.view.frame.size = CGSize(width: 40, height: 40)
           // hostingerView!.view.backgroundColor = .clear
            addSubview(topLeft!)
            addSubview(topRight!)
            addSubview(bottomLeft!)
            addSubview(bottomRight!)
            addSubview(rotateHandle!)
            
            
            self.updateDragHandles()
            
            invertScaling(scale: invertedScale)
      //  }
    }
    func addDragHandlersWithSides() {
        //if controllable {
            removeDragHandlers()
        let resizeFillColor = vmConfig.TextDragHandlefillColor//Color()
        let resizeStrokeColor = vmConfig.TextDragHandleStrokeColor//UIColor.white
        let rotateFillColor = UIColor.white//Color()
            let rotateStrokeColor = UIColor.clear//Color()
            
        topLeft = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        topRight = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        bottomLeft = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        bottomRight = DragHandle(fillColor: resizeFillColor, strokeColor: resizeStrokeColor, vmConfig: vmConfig)
        rotateHandle = RotateHandle(fillColor: rotateFillColor, strokeColor: rotateStrokeColor , imageName:"arrow.trianglehead.2.counterclockwise", vmConfig: vmConfig)

//        hostingerView = UIHostingController(rootView: RotationController())
            
        topTextDragHandle = TextDragHandleForVertical(fillColor: resizeStrokeColor, strokeColor: resizeStrokeColor)
        bottomTextDragHandle = TextDragHandleForVertical(fillColor: resizeStrokeColor, strokeColor: resizeStrokeColor)
        leftTextDragHandle = TextDragHandleForHorizontal(fillColor: resizeStrokeColor, strokeColor: resizeStrokeColor)
        rightTextDragHandle = TextDragHandleForHorizontal(fillColor: resizeStrokeColor, strokeColor: resizeStrokeColor)

//            hostingerView?.view.frame.size = CGSize(width: 40, height: 40)
//            hostingerView!.view.backgroundColor = .clear
            addSubview(topLeft!)
            addSubview(topRight!)
            addSubview(bottomLeft!)
            addSubview(bottomRight!)
            addSubview(rotateHandle!)

            addSubview(topTextDragHandle!)
            addSubview(bottomTextDragHandle!)
            addSubview(leftTextDragHandle!)
            addSubview(rightTextDragHandle!)
            
            
            self.updateDragHandles()
            
            invertScaling(scale: invertedScale)
      //  }
    }
    
    func removeDragHandlers() {
        topLeft?.removeFromSuperview()
        topRight?.removeFromSuperview()
        bottomLeft?.removeFromSuperview()
        bottomRight?.removeFromSuperview()
        rotateHandle?.removeFromSuperview()
       // hostingerView?.view.removeFromSuperview()
        
        topTextDragHandle?.removeFromSuperview()
        bottomTextDragHandle?.removeFromSuperview()
        leftTextDragHandle?.removeFromSuperview()
        rightTextDragHandle?.removeFromSuperview()
    }
    
    //This function is used for updating the Drag Handlers.
    func updateDragHandles() {
        topLeft?.center = self.placeHolderView.transformedTopLeft()
        topRight?.center = self.placeHolderView.transformedTopRight()
        bottomLeft?.center = self.placeHolderView.transformedBottomLeft()
        bottomRight?.center = self.placeHolderView.transformedBottomRight()
        topTextDragHandle?.center = self.placeHolderView.transformedTextHandleTop()
        bottomTextDragHandle?.center = self.placeHolderView.transformedTextHandleBottom()
        leftTextDragHandle?.center = self.placeHolderView.transformedTextHandleLeft()
        rightTextDragHandle?.center = self.placeHolderView.transformedTextHandleRight()
       // rotateHandle?.center = self.placeHolderView.transformRotateHandleLeft()
        smartUpdateRotationHandler()
    }
    
    var rotationHandlerPosition : RotateHandlerPosition = .Right
    
    enum RotateHandlerPosition {
        case Top
        case Bottom
        case Left
        case Right
        case Hidden
    }
    
    
    func smartUpdateRotationHandler() {
        // start from   3, 12 , 9 , 6
        // 3 is orifin
        
        // calcualte  Bounds
         
        // check if currentActiveView Dynamic bounds withing editView
        // check if currentActiveView + rotation can fit in 3'Oclock
        // check if currentActiveView + rotation can fit in 12'Oclock
        // check if currentActiveView + rotation can fit in 9'Oclock
        // check if currentActiveView + rotation can fit in 6'Oclock

        // if all are none , hide it
        // { Type - Left , Right , Top , Bottom , Hidden }
        
        // Now Its Time For Control Bar
        
        guard let rotateHandle = rotateHandle else {
            return
        }
        guard let editView = editorView else {
            return
        }
        rotateHandle.isHidden = false

        let rotateHandleOffset = CGFloat( 25 + 40 )
        
        var selfArea = self.convert(self.bounds, to: editView)
        
        print(selfArea)
        
        let parentWidth = editView.bounds.width
        let parentHeight = editView.bounds.height
        
        // lets see what if it can set to right
        let centerRight = placeHolderView.transformedRotateHandleRight()
        
        let centerRightWithRespectToEditview = self.convert(centerRight, to: editView)
            
        
       

        // Rotate handle size
       // let rotateHandleSize = rotateHandle.bounds.size
        let handleWidth : CGFloat  = 40 // rotateHandleSize.width
        let handleHeight : CGFloat = 40 //rotateHandleSize.height

        // Get the transformed center position of the rotate handle considering rotation
      //  let transformedRotateHandle = placeHolderView.transformedRotateHandle()

        // Calculate the four possible positions around the sticker view
        let right = placeHolderView.transformedRotateHandleRight()
        let left = placeHolderView.transformRotateHandleLeft()
        let top = placeHolderView.transformRotateHandleTop()
        let bottom = placeHolderView.transformRotateHandleBottom()
     
       // self.transform = .identity
        let rightPosition = self.convert(right, to: editView)
        let leftPosition = self.convert(left, to: editView)
        let topPosition = self.convert(top, to: editView)
        let bottomPosition = self.convert(bottom, to: editView)
       // self.transform = cTrnasofrm

        // Function to check if a position is within bounds
        func isPositionInBounds(_ position: CGPoint) -> Bool {
            let isInBoundsX = position.x - 25 >= 0 && position.x + 25 <= parentWidth
            let isInBoundsY = position.y - 25  >= 0 && position.y + 25  <= parentHeight
            return isInBoundsX && isInBoundsY
        }

        // Try to place the rotate handle at the four positions, checking for bounds overflow
        if isPositionInBounds(bottomPosition) {
            rotateHandle.center = bottom
            rotationHandlerPosition = .Bottom
            print("Rotate Handle positioned at the bottom")
        }else if isPositionInBounds(leftPosition) {
            rotateHandle.center = left
            rotationHandlerPosition = .Left
            print("Rotate Handle positioned to the left")
        }else if isPositionInBounds(rightPosition) {
            rotateHandle.center = right
            rotationHandlerPosition = .Right
            print("Rotate Handle positioned to the right")
        }else if isPositionInBounds(topPosition) {
            rotateHandle.center = top
            rotationHandlerPosition = .Top
            print("Rotate Handle positioned at the top")
        }else {
            rotationHandlerPosition = .Hidden
            // No valid position fits within bounds, hide the rotate handle
            rotateHandle.isHidden = true
            print("Rotate Handle: No space available, hiding handle")
        }
        
        
    }
    
    
    
    //This function find the angle between two points.
    func angleBetweenPoints(startPoint:CGPoint, endPoint:CGPoint)  -> CGFloat {
      let a = startPoint.x - self.center.x
      let b = startPoint.y - self.center.y
      let c = endPoint.x - self.center.x
      let d = endPoint.y - self.center.y
      let atanA = atan2(a, b)
      let atanB = atan2(c, d)
      let angle = atanA - atanB
        return angle < 0 ? abs(angle) : 6.28 - angle
    }

    func getBounds()->CGSize {
        return self.bounds.size
    }
    
    //Set new size to the self view.
    func setNewSize(size:CGSize) {
          let newSize = size.plus(100)
          self.bounds.size = newSize
      }
    
    //Animate the controllers.
    func heartBeat(view:UIView?) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.values = [1.0, 1.2, 1.0]
            animation.keyTimes = [0, 0.5, 1]
            animation.duration = 0.2
            animation.repeatCount = 3
            animation.isRemovedOnCompletion = true
            view?.layer.add(animation, forKey: "pulse")
    }
    
    func isActiveAnimation() {
        vibrate()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.values = [1.0, 1.02, 1.0]
            animation.duration = 0.5
            animation.repeatCount = 1
            animation.isRemovedOnCompletion = true
            self.layer.add(animation, forKey: "pulse")
           
    }
    
    //Below function defines that the button is tapped/touched or not.
    func isButtonTouched(button:DragHandle,point:CGPoint)->Bool {
        return button.point(inside: self.convert(point, to: button) , with: nil) && self.isActive
    }
    
    func isHTextButtonTouched(button:TextDragHandleForHorizontal,point:CGPoint)->Bool {
        return button.point(inside: self.convert(point, to: button) , with: nil) && self.isActive
    }
    
    func isVTextButtonTouched(button:TextDragHandleForVertical,point:CGPoint)->Bool {
        return button.point(inside: self.convert(point, to: button) , with: nil) && self.isActive
    }
     
    func isViewTouched(button:UIView,point:CGPoint)->Bool {
        return button.point(inside: self.convert(point, to: button) , with: nil) && self.isActive
    }
    
    func isPixelTransparent(atPoint:CGPoint)->Bool {
        if let thumbImage = thumbImage {
            return isPointTransparent(in: thumbImage, at: atPoint, in: self.bounds, withRotation: rotationAngle)
            
        }
        else{
            print("NK Thumb Not Generated.")
            return self.bounds.contains(atPoint)
        }
    }
 
    
    func reverseRotate(point: CGPoint, angle: Double) -> CGPoint {
        let cosTheta = cos(angle)
        let sinTheta = sin(angle)
        
        let rotatedX = point.x * cosTheta + point.y * sinTheta
        let rotatedY = -point.x * sinTheta + point.y * cosTheta
        
        return CGPoint(x: rotatedX, y: rotatedY)
    }

    /// Checks if a point inside the bounds of the image is transparent (alpha = 0).
    /// Also checks the surrounding 10 pixels in each direction (top, left, right, bottom).
    /// - Parameters:
    ///   - point: The point within the bounds to check.
    ///   - bounds: The bounds in which the point resides, different from the image's size.
    ///   - image: The UIImage to check.
    ///   - rotation: The rotation angle in radians.
    /// - Returns: A boolean indicating whether the pixel at the point or any adjacent pixel within 10 pixels is non-transparent.
    func isPointTransparent(in image: UIImage, at point: CGPoint, in bounds: CGRect, withRotation rotation: CGFloat) -> Bool {
        guard let cgImage = image.cgImage else {
            return false
        }
        let mySize = image.mySize
        let xRatio = mySize.width / bounds.width
        let yRatio = mySize.height / bounds.height
        
        let newPoint = reverseRotate(point: point, angle: rotationAngle)
        // Convert the point to the image's coordinate space
        var imagePoint = CGPoint(x: point.x * xRatio, y: point.y * yRatio)
        
        // Apply rotation to the imagePoint
        let center = CGPoint(x: mySize.width / 2, y: mySize.height / 2)
        
        // Define the range of pixels to check around the point (10 pixels in each direction)
        let pixelRange: Int = 10
        
        // Function to check if a specific point in the image is47 non-transparent
        func isPixelNonTransparent(at point: CGPoint) -> Bool {
            guard CGRect(origin: .zero, size: mySize).contains(point) else {
                return false
            }
            
            let pixelX = Int(point.x)
            let pixelY = Int(point.y)
            
            guard let dataProvider = cgImage.dataProvider,
                  let pixelData = dataProvider.data else {
                return false
            }
            
            let data = CFDataGetBytePtr(pixelData)
            let bytesPerPixel = cgImage.bitsPerPixel / 8
            let bytesPerRow = cgImage.bytesPerRow
            
//            let pixelIndex = pixelY * bytesPerRow + pixelX * bytesPerPixel
//            let alpha = data?[pixelIndex + 10] ?? 0
            let pixelIndex = pixelY * bytesPerRow + pixelX * bytesPerPixel
               let alphaIndex = pixelIndex + (bytesPerPixel - 1) // Correct alpha channel index
               let alpha = data?[alphaIndex] ?? 0
               
            return alpha != 0
        }
        
        // Check the target point first
        if isPixelNonTransparent(at: imagePoint) {
            return true
        }
        
        // Check the adjacent pixels within the specified range
        for dx in -pixelRange...pixelRange {
            for dy in -pixelRange...pixelRange {
                if dx == 0 && dy == 0 { continue } // Skip the center point (already checked)
                
                let adjacentPoint = CGPoint(x: imagePoint.x + CGFloat(dx), y: imagePoint.y + CGFloat(dy))
                if isPixelNonTransparent(at: adjacentPoint) {
                    return true
                }
            }
        }
        
        // If no adjacent pixels are non-transparent, return false
        return false
    }
    
    
    
    public func colorOfPoint(image: UIImage, bounds: CGSize, point: CGPoint) -> CGColor? {
        // Ensure the point is within the 500x500 bounds
        guard point.x >= 0, point.y >= 0, point.x < bounds.width, point.y < bounds.height else {
            return nil
        }

        // Calculate the scaling factors to map the 500x500 bounds to the 300x300 image
        let scaleX = image.mySize.width / bounds.width
        let scaleY = image.mySize.height / bounds.height

        // Convert the point from the 500x500 bounds to the 300x300 image bounds
        let imagePoint = CGPoint(x: point.x * scaleX, y: point.y * scaleY)

        // Ensure the converted point is within the image bounds
        guard imagePoint.x >= 0, imagePoint.y >= 0, imagePoint.x < image.mySize.width, imagePoint.y < image.mySize.height else {
            return nil
        }

        // Get the color at the converted image point
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        context!.translateBy(x: -imagePoint.x, y: -imagePoint.y)

        // Render the image in the context
        if let cgImage = image.cgImage {
            context!.draw(cgImage, in: CGRect(origin: .zero, size: image.mySize))
        }

        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

        return color.cgColor
    }
    
    struct AnchorPoints {
        static var Center = CGPoint(x: 0.5, y: 0.5)
    }
  
    //The below function checks the view contains the tapped location or not.
func  contains(point: CGPoint) -> Bool {

//    if !canDisplay {
//        return false
//    }
        
//        if let btn = lockHandle , isButtonTouched(button: btn, point: point) {
//            _isLocked = true
//            return true
//         }else
//         if let btn = unlockHandle ,isButtonTouched(button: btn, point: point) {
//             _isLocked = false
//            return true
//         }else
//         if let btn = deleteHandle ,isButtonTouched(button: btn, point: point) {
//             _isDelete.toggle()
//            return true
//         }
//        else
        if let btn = rotateHandle ,isViewTouched(button: btn, point: point) {
            isRotating = true
           return true
        }
        
        else if let btn = topLeft , isButtonTouched(button: btn, point: point){
            selectedView = "topLeft"
            isScaling = true
        }
        
        else if let btn = topRight , isButtonTouched(button: btn, point: point){
            selectedView = "topRight"
            isScaling = true
        }
        
        else if let btn = bottomLeft , isButtonTouched(button: btn, point: point){
            selectedView = "bottomLeft"
            isScaling = true
        }
        
        else if let btn = bottomRight , isButtonTouched(button: btn, point: point){
            selectedView = "bottomRight"
            isScaling = true
        }
        
//        else if let btn = editHandle , isButtonTouched(button: btn, point: point){
//            print("Edit Button Tapped")
//        }
        
        else if let btn = topTextDragHandle, isVTextButtonTouched(button: btn, point: point){
            print("89 Top Text Drag Handle Tapped")
            selectedView = "topTextDragHandle"
            isTextDragging = true
        }
        
        else if let btn = bottomTextDragHandle, isVTextButtonTouched(button: btn, point: point){
            print("89 Bottom Text Drag Handle Tapped")
            selectedView = "bottomTextDragHandle"
            isTextDragging = true
        }
        
        else if let btn = leftTextDragHandle, isHTextButtonTouched(button: btn, point: point){
            print("89 Left Text Drag Handle Tapped")
            selectedView = "leftTextDragHandle"
            isTextDragging = true
        }
        
        else if let btn = rightTextDragHandle, isHTextButtonTouched(button: btn, point: point){
            print("89 Right Text Drag Handle Tapped")
            selectedView = "rightTextDragHandle"
            isTextDragging = true
        }
    //    print("Using contatins")
       
            
            return  self.isPixelTransparent(atPoint: point)
        
       
   }
}



extension UIColor {
    static let darkRed = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1) // Dark red
    static let lightRed = UIColor(red: 1, green: 0.4, blue: 0.4, alpha: 1) // Light red
    
    static let darkGreen = UIColor(red: 40/255, green: 49/255, blue: 27/255, alpha: 1) // Dark green
    static let lightGreen = UIColor(red: 179/255, green: 223/255, blue: 114/255, alpha: 1) // Light green
}


func vibrate() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}
