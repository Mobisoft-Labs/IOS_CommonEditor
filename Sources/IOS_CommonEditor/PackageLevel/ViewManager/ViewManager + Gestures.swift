//
//  ViewManager + Gestures.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 28/03/24.
//

import Foundation
import UIKit


extension ViewManager{
    
 
    //Handle the Double Press Gesture.
    func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        print("Double Tap Gesture Tapped")
        if templateHandler?.currentModel?.modelType == .Text{
            print("NK Edit Text")
            templateHandler?.currentActionState.didEditTextClicked = true
        }
        else{
            editView?.canvasView.transform = CGAffineTransform.identity
            invertScale = 1.0
            currentActiveView?.invertedScale = invertScale
            editView?.canvasView.center = CGPoint(x: editView!.bounds.width/2, y: editView!.bounds.height/2)
        }
    }
    //Handle the Long Press Gesture.
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        print("Long Tap Gesture Tapped")
    }
    
    
    func handleMultiSelect(gesture: UITapGestureRecognizer , touchedView:UIView) {
            //JD**
        if touchedView is SceneView || touchedView is PageView {
            logger.printLog("returning, page tapped in MultiSelectMode")
        }else {
            if let touch = touchedView as? BaseView , let model = templateHandler?.getModel(modelId: touch.tag) , touch.canDisplay {
            if model.isSelectedForMultiSelect {
                templateHandler?.currentActionState.removeItemFromMultiSelect = touch.tag
                self.templateHandler?.updateFlatternTree()
            }else {
                templateHandler?.currentActionState.addItemToMultiSelect = touch.tag
                self.templateHandler?.updateFlatternTree()
            }
        }
        
        }
            
        
    }
    

    // Handle the Tap Gesture.
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        logger.logVerbose("Handle Tap Gesture")
        
        guard let rootView = rootView else {
            logger.logErrorFirebaseWithBacktrace("[TapGuard] reason=rootViewNil")
            return
        }
        
        guard let templateHandler = templateHandler else {
            logger.logErrorFirebaseWithBacktrace("[TapGuard] reason=templateHandlerNil")
            return
        }
        guard let currentPageView = rootView.currentPage else {
            logger.logErrorFirebaseWithBacktrace("[TapGuard] reason=currentPageNil")
            return
        }
        
        rootView._templateHandler = templateHandler
        let touchPoint = gesture.location(in: currentPageView)
        let touchPointInScene = gesture.location(in: rootView)
        let currentModelId = templateHandler.currentModel?.modelId ?? -1
        let currentSuperModelId = templateHandler.currentSuperModel?.modelId ?? -1
        let timestamp = Int(Date().timeIntervalSince1970)
        lastGestureContext = "tap modelId=\(currentModelId) superModelId=\(currentSuperModelId) pageTag=\(currentPageView.tag) multiMode=\(templateHandler.currentActionState.multiModeSelected) ts=\(timestamp)"
        logger.logErrorFirebase("[TapFlowBreadcrumb] \(lastGestureContext ?? "tap") touch=\(Int(touchPoint.x))x\(Int(touchPoint.y)) scene=\(Int(touchPointInScene.x))x\(Int(touchPointInScene.y))", record: false)
        
        if rootView.isPremiumTapped(touchPointInScene) {
            handleTapForPremiumButton(gesture)
            logger.logInfo("Premium Button Tapped")
            return
        }
        
        var viewToRayCastIn : BaseView = currentPageView
        
        if templateHandler.currentActionState.multiModeSelected {
            
            guard let view = viewToRayCastIn.overlapHitTest(point: gesture.location(in: viewToRayCastIn), withEvent: nil) else {
                logger.logErrorJD(tag: .viewManager,"ViewNotDetected");
                logger.logErrorFirebaseWithBacktrace("[TapGuard] reason=multiModeViewNotDetected")
                return
            }
            
            handleMultiSelect(gesture: gesture, touchedView: view)

        }
        else {

            // default parent set to page current
            currentParentView = currentPageView
            
            // now if superModel is there then assigned it ( when edited, superModel switches internally )
            
            if let currentSuperModel = templateHandler.currentSuperModel , let parentView =  rootView.hasChild(id: currentSuperModel.modelId) as? ParentView  {
                currentParentView = parentView
            }
            
            let viewToRayCastIn = currentParentView!
            
            

            let touchPoint = gesture.location(in: viewToRayCastIn )
            if viewToRayCastIn.bounds.contains(touchPoint) {
                logger.logInfo("Touch Can Be Found Of Recommeneded Parent")
                guard let view = viewToRayCastIn.overlapHitTest(point: touchPoint, withEvent: nil) else {
                    logger.logErrorJD(tag: .viewManager,"ViewNotDetected");
                    logger.logErrorFirebaseWithBacktrace("[TapGuard] reason=viewNotDetected")
                    setCurrentModel(view: (viewToRayCastIn))
                    return
                }
                guard let baseView = view as? BaseView else {
                    logger.logErrorFirebaseWithBacktrace("[TapGuard] reason=hitTestNonBaseView view=\(type(of: view))")
                    return
                }
                setCurrentModel(view: baseView)
            }else {
                logger.logInfo("Touch Is Out Of Recommeneded Parent")
                setCurrentModel(view: currentParentView)
                rootView.heartBeat(view: controlBarView?.view)
            }
            
        }
  
    }
    
    //Handle the Rotation Gesture that come from the scene view.
    func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        logger.printLog("rotation")
      
        if currentActiveView is PageView {
            logger.logError("Page Is Active, No Rotation")
            return
        }

        guard let templateHandler = templateHandler else {
            logger.logErrorFirebaseWithBacktrace("[RotationGuard] reason=noTemplateHandler state=\(gesture.state.rawValue)")
            return
        }
        guard let currentModel = templateHandler.currentModel else {
            logger.logErrorFirebaseWithBacktrace("[RotationGuard] reason=noCurrentModel state=\(gesture.state.rawValue)")
            return
        }
        guard let currentActiveView = currentActiveView else {
            logger.logErrorFirebaseWithBacktrace("[RotationGuard] reason=noActiveView state=\(gesture.state.rawValue)")
            return
        }
        
       // if !isPageSelected {
            if gesture.state == .began{
                // removeControlViews() /* jD Depricated*/
                logger.logErrorFirebase("[RotationFlowBreadcrumb] stage=rotationBegan modelId=\(currentModel.modelId) rotation=\(currentModel.baseFrame.rotation) state=\(gesture.state.rawValue) parent=\(lastGestureContext ?? "none")", record: false)
                currentActiveView.enableStealthMode = true
                refreshControlBar = true 
                currentActiveView._initialRotation = CGFloat(currentModel.baseFrame.rotation)
                initialRotation = currentModel.baseFrame.rotation
            }
            if gesture.state == .changed{
                logger.logErrorFirebase("[RotationFlowBreadcrumb] stage=rotationChanged modelId=\(currentModel.modelId) rotation=\(currentModel.baseFrame.rotation) parent=\(lastGestureContext ?? "none")", record: false)
                handleRotation(gesture)
//                gesture.rotation = 0.0
            }
            
            if gesture.state == .ended{
//                drawControlViews() Jd Depricate
                logger.logErrorFirebase("[RotationFlowBreadcrumb] stage=rotationEnded modelId=\(currentModel.modelId) rotation=\(currentModel.baseFrame.rotation) parent=\(lastGestureContext ?? "none")", record: false)
                currentActiveView.enableStealthMode = false
                refreshControlBar = true
                gridManager?.manageStateForRotation()
                currentModel.beginFrame.rotation = Float(currentActiveView._initialRotation)
                currentModel.endFrame.rotation = currentModel.baseFrame.rotation
            }
        
        
       // }
    }
    
    // Hnadle the scale gesture that come from the view.
    func handleScaleGesture(_ gesture: UIPinchGestureRecognizer) {
        logger.printLog("scale")
        if currentActiveView is PageView {
           
            // Get the current transformation of the canvas view
            let currentTransform = editView!.canvasView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            
            let pinchCenter = CGPoint(x: gesture.location(in: editView!.canvasView).x - editView!.canvasView.bounds.midX,
            y: gesture.location(in: editView!.canvasView).y - editView!.canvasView.bounds.midY)
            let transform = editView!.canvasView.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
            .scaledBy(x: gesture.scale, y: gesture.scale)
            .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.editView!.canvasView.frame.size.width / self.editView!.canvasView.bounds.size.width
            
            var newScale = currentScale*gesture.scale
            
            if newScale < 1 {
            newScale = 1
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.editView!.canvasView.transform = transform
            gesture.scale = 1
            }else {
                editView!.canvasView.transform = transform
            gesture.scale = 1
            }
            
            if editView!.canvasView.frame.size.width >=  editView!.canvasView.frame.size.height{
                if editView!.canvasView.frame.size.width <= editView!.frame.size.width{
                    let size = editView!.frame.size
                    editView!.canvasView.center = CGPoint(x: size.width/2, y: size.height/2)
                }
            }
            else if editView!.canvasView.frame.size.width <=  editView!.canvasView.frame.size.height{
                if editView!.canvasView.frame.size.height <= editView!.frame.size.height{
                    let size = editView!.frame.size
                    editView!.canvasView.center = CGPoint(x: size.width/2, y: size.height/2)
                }
            }
            
//            // Calculate the width and height after scaling
//            let newWidth = editView.canvasView.bounds.width * currentTransform.a
//            let newHeight = editView.canvasView.bounds.height * currentTransform.d
//            if editView.frame.size.width >= newWidth && editView.frame.size.height >= newHeight{
//                print("Condition Extended")
//            }
//            else{
//                editView.canvasView.transform = editView.canvasView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
//                editView.canvasView.center = CGPoint(x: editView.bounds.width/2, y: editView.bounds.height/2)
//                
                invertScale = editView!.canvasView.frame.size.width / editView!.frame.size.width
//
//            }
            editView!.clipsToBounds = true
            gesture.scale = 1.0
        }else {
            handleScale(gesture: gesture)
        }

    }
    
    
    //Handle the move gesture that come from the control view by deciding the gesture moving, scaling, rotating.
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        guard let templateHandler = templateHandler else { return }
        guard let currentModel = templateHandler.currentModel else {
            logger.logError("Gestures Crash : Current Model not found.")
            return
        }
        if templateHandler.currentActionState.multiModeSelected {
            logger.logError("multi mode On, can not pan people wants panselection ")
            return
           
        }
        
        logger.printLog("pan")
        if  !(currentActiveView is PageView)  {
            // if its locked or transform not available
            if currentActiveView!._canTransform {
                if gesture.state == .began{
                    _ = currentActiveView?.overlapHitTest(point: gesture.location(in: currentActiveView), withEvent: nil)
                    if let currentModel = templateHandler.currentModel{
                        currentActiveView?._initialRotation = CGFloat((currentModel.baseFrame.rotation)) //NK*
                        currentActiveView?._initialCenter = (currentModel.baseFrame.center) /*CGPoint(x: Double(templateHandler.currentModel!.posX), y: Double(templateHandler.currentModel!.posY))*/
                        currentActiveView?._initialSize = (currentModel.baseFrame.size) /*CGSize(width: Double(templateHandler.currentModel!.width), height: Double(templateHandler.currentModel!.height))*/
                        currentModel.beginFrame = (currentModel.baseFrame)
                    }
                }
                if let currentSelectedView = currentActiveView,currentSelectedView.isRotating {
                    handleRotate(gesture)
                }
                else if let currentSelectedView = currentActiveView,currentSelectedView.isScaling{
                    handlePan(gesture)
                }
                
                else if let currentSelectedView = currentActiveView, currentSelectedView.isTextDragging{
                    
                    handleTextPan(gesture)
                }
                else{
                    handleMove(gesture)
                }
                
                if gesture.state == .ended {
                    if currentActiveView!.isRotating{
                        gridManager!.manageStateForRotation()
                        templateHandler.currentModel?.beginFrame.rotation = Float(currentActiveView!._initialRotation)
                        templateHandler.currentModel?.endFrame = currentModel.baseFrame
                        currentActiveView?.isRotating = false
                    }
                    else if currentActiveView!.isTextDragging{
                        currentActiveView?.isTextDragging = false
                        templateHandler.currentModel?.endFrame = Frame(size: currentModel.baseFrame.size, center: currentModel.baseFrame.center, rotation: (currentModel.baseFrame.rotation), shouldRevert: currentModel.baseFrame.shouldRevert, isParentDragging: currentModel.baseFrame.isParentDragging)
                        var baseFrame = currentModel.baseFrame
                        baseFrame.shouldRevert = false
                        baseFrame.isParentDragging = false
                        currentModel.baseFrame = baseFrame
                    }
                    else{
                        currentModel.endFrame = Frame(size: currentModel.baseFrame.size, center: currentModel.baseFrame.center, rotation: (currentModel.baseFrame.rotation))
                        currentActiveView?.isScaling = false
                       
                    }
                    
                    templateHandler.selectedNearestSnappingChildID = 0
                }
            } else {
                if gesture.state == .began {
                    if let v = currentActiveView, v.vISLOCKED {
                        v.heartBeat(view: controlBarView?.view)
                    }
                }
            }
        }
        else{
            // if canvas is identity.
            if editView!.bounds == editView!.canvasView.frame && (templateHandler.currentTemplateInfo?.pageInfo.count)! > 1{
                if gesture.state == .began{
                    editView!.canvasView.backgroundColor = vmConfig.canvasViewBGColor//.white
//                    editView.backgroundColor = .clear
                    // Hide Scene View
                    editView!.canvasView.mtkScene?.isHidden = true
                    // UnHide Collection View
                    templateHandler.currentActionState.currentPage = indexOfModel(withId: templateHandler.currentPageModel!.modelId, models: templateHandler.currentTemplateInfo!.pageInfo)!
                    templateHandler.currentActionState.scrollOffset = -(CGFloat(templateHandler.currentActionState.currentPage) * editView!.bounds.width)
                    templateHandler.currentActionState.isScrollViewShowOrNot = true
                    psScroller.addPageScrollerView(parentView: editView!, actionStates: templateHandler.currentActionState)
                }
                
                if gesture.state == .changed{
                    let translation = gesture.translation(in: editView!.canvasView)
                    let maxOffset : CGFloat = (CGFloat(templateHandler.currentTemplateInfo!.pageInfo.count - 1) * editView!.bounds.width)
                    let nextOffset = templateHandler.currentActionState.scrollOffset + translation.x
                    if abs(nextOffset) < maxOffset && nextOffset < 0 {
                        print("After Condition Fail. It still works. NextOffset \(nextOffset) MaxOffset \(maxOffset)")
                        templateHandler.currentActionState.scrollOffset = nextOffset
                        gesture.setTranslation(.zero, in: editView!.canvasView)
                    }
                }
                
                if gesture.state == .ended{
                    
                    templateHandler.currentActionState.pagerScrolledOff.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                        // Hide Collection View
                       // psScroller.hidePageScroller()
                        // UnHide Scene View
                        editView!.canvasView.mtkScene?.isHidden = false
                        templateHandler.currentActionState.isScrollViewShowOrNot = true
                        psScroller.removePageScrollerView()
                     
                    }
                }
            }
            
            else{
                
                let translation = gesture.translation(in: editView)
                let center = CGPoint(x: editView!.canvasView.center.x + translation.x, y: editView!.canvasView.center.y + translation.y)
                
                //            let editViewMinMax = editView.convert(CGPoint(x: editView.frame.minX, y: editView.frame.maxX), to: editView.canvasView)
                let width = editView!.canvasView.frame.size.width
                let height = editView!.canvasView.frame.size.height
                if center.x - width/2 < editView!.bounds.minX && center.x + width/2 > editView!.bounds.maxX
                    && (center.y - height/2 < editView!.bounds.minY) && (center.y + height/2 > editView!.bounds.maxY)
                {
                    editView!.canvasView.center = center
                }
                else{
                    print("Neeshu")
                }
                 
                
                
                editView!.clipsToBounds = true
                gesture.setTranslation(.zero, in: editView)
                
            }
        }


    }
    
    func calculateRectFromTouches(startPoint: CGPoint, currentPoint: CGPoint) -> CGRect {
        let minX = min(startPoint.x, currentPoint.x)
        let minY = min(startPoint.y, currentPoint.y)
        let maxX = max(startPoint.x, currentPoint.x)
        let maxY = max(startPoint.y, currentPoint.y)
        
        let width = maxX - minX
        let height = maxY - minY
        
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
    
    //This function handle the scale of the view.
    func handleScale(gesture:UIGestureRecognizer) {
        if gesture is UIPinchGestureRecognizer {
            handlePinch(gesture: gesture as! UIPinchGestureRecognizer)
        }
    }
    
    //Handle the Zoom Gesture on the view.
    private  func handlePinch(gesture:UIPinchGestureRecognizer) {
        guard let currentActiveView = currentActiveView else {
            logger.logError("currentActiveView Nil")
            return
        }
        
        guard let templateHandler = templateHandler else {
            return
        }
        
        guard let currentModel = templateHandler.currentModel else {
            return
        }
        
        guard let focusRootView = rootView?.viewWithTag(currentActiveView.parentView!.tag) else {
            logger.logError("currentActiveView Parent Nil")
            return
        }
                
        if currentActiveView._canTransform {
            print("Child Pinching")
            let newScale = gesture.scale
            
            if gesture.state == .began {
                print("Zoom gesture began.")
                //removeControlViews()
                currentActiveView.enableStealthMode = true
                showControlBar = false
                currentModel.beginFrame = currentModel.baseFrame
                currentActiveView._initialCenter = currentModel.baseFrame.center/*CGPoint(x: Double(templateHandler.currentModel!.posX), y: Double(templateHandler.currentModel!.posY))*/
                initialWidth =  currentModel.baseFrame.size.width//CGFloat(templateHandler.currentModel!.width)
                initialHeight =  currentModel.baseFrame.size.height //CGFloat(templateHandler.currentModel!.height)
              //  currentActiveView.gestureIsInProcess = true
            }
            
            if gesture.state == .changed {
                var prevWidth = currentModel.baseFrame.size.width//CGFloat(templateHandler.currentModel!.width)
                var prevHeight =  currentModel.baseFrame.size.height//CGFloat(templateHandler.currentModel!.height)
                let newWidth =  initialWidth * newScale
                let newHeight = initialHeight * newScale
                let newSize = CGSize(width: initialWidth, height: initialHeight).into(newScale)
                if newWidth > 10 || newHeight > 10 {
                    let currentViewCenter = currentModel.baseFrame.center
                    let currentViewSize = newSize
                    if let gridManager = gridManager {
                        gridManager.gestureMode = .scale
                        gridManager.snapIfNeeded(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize, rotation: Double(currentModel.baseFrame.rotation), parentViewFrame: currentParentView!, currentPageView: rootView!.currentPage!)
                        
                        if templateHandler.selectedComponenet == .parent && focusRootView.tag == currentActiveView.tag{
                            scaleChildOfFocusedParent(scale: newScale, parentID: focusRootView.tag)
                        }
                    }else{
                        logger.logWarning("Grid NIL")
                    }
                    
                    logger.printLog("NEWSIZE \(newSize)")
                }
            }
            
            if gesture.state == .ended {
              //  drawControlViews()
                gridManager?.manageStateInBasicMode()
                gridManager?.manageState()
                gridManager?.setNeedsDisplay()
              
                currentModel.endFrame = Frame(size: currentModel.baseFrame.size, center: currentModel.baseFrame.center, rotation: currentModel.baseFrame.rotation)
                currentActiveView.enableStealthMode = false
                showControlBar = true
            }
            
        } else {
            if gesture.state == .began {
                currentActiveView.heartBeat(view: controlBarView?.view)
            }
        }
      }
    
    
    //Handle the Rotation Gesture using UIRotation gesture.
    func handleRotation(_ gesture : UIRotationGestureRecognizer){
        guard let currentActiveView = currentActiveView else {
            return
        }
        guard let currentModel = templateHandler?.currentModel else {
            assert(false, "Gestures Crash : Current Model not found.")
            return
        }
        if currentActiveView._canTransform{
            if gesture.state == .began {
//                removeControlViews()
                currentActiveView.enableStealthMode = true
                showControlBar = false
                currentActiveView._initialCenter = (currentModel.baseFrame.center) /*CGPoint(x: Double(templateHandler.currentModel!.posX), y: Double(templateHandler.currentModel!.posY))*/
            }
            if gesture.state == .changed{
                
                var rotation = initialRotation
                rotation = rotation * .pi / 180
                let newRotation = Float(rad2deg(Double(Float(normalizeRotationRadians(Double(Float(gesture.rotation) + rotation))))))
                var degree = newRotation
                degree = Float(Double(Float(normalizeDegree(CGFloat(degree)))))
                gridManager?.snapIfNeeded(for: Double(degree), currentParentView: currentParentView!, rootView: rootView!.currentPage!)
                
                print("Neeshu Rotation : \(currentModel.rotation)")
//                gesture.rotation = 0
            }
            if gesture.state == .ended{
//                drawControlViews()
                currentActiveView.enableStealthMode = false
                showControlBar = true
                templateHandler!.currentModel?.beginFrame.center = currentActiveView._initialCenter
//                templateHandler.currentActionState.oldCenter = currentActiveView._initialCenter
                templateHandler!.currentModel?.endFrame.center = (currentModel.baseFrame.center) /*CGPoint(x: Double(templateHandler.currentModel!.posX), y: Double(templateHandler.currentModel!.posY))*/
                gridManager?.manageStateForRotation()
            }
        }
//        updateControlBarIfNeeded()
    }
    
    //Handle the rotation of the view using the control panel button.
    func handleRotate(_ gesture:UIPanGestureRecognizer) {
        guard let currentActiveView = currentActiveView else {
            return
        }
        
        guard let currentModel = templateHandler?.currentModel else {
            assert(false, "Gestures Crash : Current Model not found.")
            return
        }
        
        let location = gesture.location(in: currentActiveView.superview)

        switch gesture.state {
        case .began:
            print("Began")
//            removeControlViews()
            currentActiveView.enableStealthMode = true
            showControlBar = false
            currentActiveView.previousLocation = currentActiveView.convert(currentActiveView.rotateHandle!.center, to: currentActiveView.superview!)
            initialRotation = currentModel.baseFrame.rotation
        case .ended:
            currentActiveView.enableStealthMode = false
            showControlBar = true
//            drawControlViews()
            print("Ended")

        case .changed:
            let angle = currentActiveView.angleBetweenPoints(startPoint: currentActiveView.previousLocation, endPoint: location)
            print("angle:",angle)
//            var rotation = templateHandler.currentModel!.rotation
            var rotation = initialRotation * .pi / 180
            var degree = Float(rad2deg(Double(rotation - Float((angle)))))
            degree = Float(normalizeDegree(CGFloat(degree)))
//            templateHandler.currentModel!.rotation = degree
            gridManager?.snapIfNeeded(for: Double(degree), currentParentView: currentParentView!, rootView: rootView!.currentPage!)
//            currentActiveView.previousLocation = location
          //  currentActiveView.enableStealthMode = false

           break
        default:()
        }
//        updateControlBarIfNeeded()
//       currentActiveView.updateDragHandles()
        print("Final:",(currentModel.baseFrame.rotation))
    }
    

    //This function is used for handling the move gesture using the move button.
    func handleMove(_ gesture: UIPanGestureRecognizer) {
        guard let currentActiveView = currentActiveView else {
            return
        }
        
        guard let currentModel = templateHandler?.currentModel else {
            assert(false, "Gestures Crash : Current Model not found.")
            return
        }
        
        if currentActiveView._canTransform {
            print("Moving")
            switch gesture.state {
            case .began:
//                removeControlViews()
                currentActiveView.enableStealthMode = true
                showControlBar = false
                currentActiveView._initialCenter = currentModel.baseFrame.center/*CGPoint(x: Double(templateHandler.currentModel!.posX), y: Double(templateHandler.currentModel!.posY))*/
            case .changed:
                if let superview = currentActiveView.superview {
                    let newCenter = currentActiveView._initialCenter.plus(gesture.translation(in: superview))
                    print("vv \(newCenter)")
                    gridManager?.gestureMode = .move
                    gridManager?.snapIfNeeded(currentViewCenter: newCenter, currentViewSize: currentModel.baseFrame.size, rotation: Double(currentModel.baseFrame.rotation), parentViewFrame: currentParentView!, currentPageView: rootView!.currentPage!)
//                    templateHandler.currentModel!.posX = Float(newCenter.x)
//                    templateHandler.currentModel!.posY = Float(newCenter.y)
                }
            case .ended:
//                drawControlViews()
                currentActiveView.enableStealthMode = false
                showControlBar = true
                gridManager?.manageStateInBasicMode()
                gridManager?.manageState()
                gridManager?.setNeedsDisplay()
                templateHandler!.selectedNearestSnappingChildID = 0
                break
            default:
                break
            }
        } else {
            if gesture.state == .began {
                currentActiveView.heartBeat(view: controlBarView?.view)
            }
        }
       // updateControlBarIfNeeded()
    }

}




func normalizeRotationRadians(_ radians: Double) -> Double {
    let normalizedRadians = radians.truncatingRemainder(dividingBy: 2 * .pi)
    return normalizedRadians >= 0 ? normalizedRadians : normalizedRadians + 2 * .pi
}


func degreesToRadians(_ degrees: Double) -> Double {
    return degrees * .pi / 180.0
}

func normalizeDegree(_ degree: CGFloat) -> CGFloat {
    // Normalize the degree value to be between 0 and 360 degrees
    var normalizedDegree = degree.truncatingRemainder(dividingBy: 360.0)
    
    // Ensure the normalized degree is positive
    if normalizedDegree < 0 {
        normalizedDegree += 360.0
    }
    
    return normalizedDegree
}


extension ViewManager{
    // This handlePan function handle the scaling through the corners.
    func handleTextPan(_ gesture: UIPanGestureRecognizer) {
        var shouldRevert : Bool = false
        var isParentDragging : Bool = false
       
        guard let currentActiveView = currentActiveView else {
            logger.logError("currentActiveView Nil")
            return
        }
        
        guard let templateHandler = templateHandler, let currentModel = templateHandler.currentModel else {
            logger.logError("templateHandler or currentModel nil")

            return
        }
        
        guard let focusRootView = rootView?.hasChild(id: currentActiveView.parentView!.tag) else {
            logger.logError("currentActiveView Parent Nil")
            return
        }
        
        
        
        
        var location = gesture.location(in: currentActiveView.placeHolderView)
        location = currentActiveView.convert(location, to: currentActiveView.placeHolderView)
        let translation = gesture.translation(in: currentActiveView)
        print("Translation X and Y \(translation.x) and \(translation.y)")
        let scaleFactor = 0.7
        switch currentActiveView.selectedView {
            
        case "leftTextDragHandle", "rightTextDragHandle", "topTextDragHandle", "bottomTextDragHandle":
            if gesture.state == .began {
//                removeControlViews()
                currentActiveView.enableStealthMode = true
                showControlBar = false
            }
            
            print("Handle WIDTH HEIGHT \(currentActiveView.distanceTravelled)")
            print("Translation : \(translation.x) \(translation.y)")
            let rotation = currentModel.baseFrame.rotation
            // Calculate the scaling factor
            switch currentActiveView.selectedView {
            case "leftTextDragHandle":
                print("891 leftTextDragHandle")
                currentActiveView.distanceTravelled = -translation.x * scaleFactor
                shouldRevert = true
            case "rightTextDragHandle":
                print("891 rightTextDragHandle")
                currentActiveView.distanceTravelled = translation.x * scaleFactor
            case "bottomTextDragHandle":
                print("891 bottomTextDragHandle")
                currentActiveView.distanceTravelled = translation.y * scaleFactor
            case "topTextDragHandle":
                print("891 topTextDragHandle")
                currentActiveView.distanceTravelled = -translation.y * scaleFactor
                shouldRevert = true
            default:
                break
            }
            
            let prevWidth = currentModel.baseFrame.size.width
            let prevHeight = currentModel.baseFrame.size.height
            var newHeight = prevHeight
            var newWidth = prevWidth
            var scaleFactor : Float = 0.0
            var travelDistanceByY = newHeight - prevHeight
            var travelDistanceByX = newWidth - prevWidth
            
            if currentActiveView.selectedView == "leftTextDragHandle" || currentActiveView.selectedView == "rightTextDragHandle"{
                newWidth    = currentModel.baseFrame.size.width + CGFloat(currentActiveView.distanceTravelled)
                scaleFactor = Float(newWidth/prevWidth)
                newHeight   =  currentModel.baseFrame.size.height * CGFloat(scaleFactor)
                travelDistanceByY = newHeight - prevHeight
                travelDistanceByX = newWidth - prevWidth
            }
            else{
                newHeight   = currentModel.baseFrame.size.height + CGFloat(currentActiveView.distanceTravelled)
                scaleFactor = Float(newHeight/prevHeight)
                newWidth    = currentModel.baseFrame.size.width * CGFloat(scaleFactor)
                travelDistanceByY = newHeight - prevHeight
                travelDistanceByX = newWidth - prevWidth
            }
            
            let posX = currentModel.baseFrame.center.x
            let posY = currentModel.baseFrame.center.y
            let degree = currentModel.baseFrame.rotation
            
            let bottomOffSetY = CGPoint(x: CGFloat(posX), y: CGFloat(posY) + CGFloat(travelDistanceByY) / 2).rotate(origin: CGPoint(x: CGFloat(posX), y: CGFloat(posY)), CGFloat(degree))//(Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let topOffSetY = CGPoint(x: CGFloat(posX), y: CGFloat(posY) - CGFloat(travelDistanceByY) / 2).rotate(origin: CGPoint(x: CGFloat(posX), y: CGFloat(posY)), CGFloat(degree))
            let leftOffSetX   = CGPoint(x: CGFloat(posX) - CGFloat(travelDistanceByX) / 2, y: CGFloat(posY) ).rotate(origin: CGPoint(x: CGFloat(posX), y: CGFloat(posY)), CGFloat(degree))
            let rightOffsetX  = CGPoint(x: CGFloat(posX) + CGFloat(travelDistanceByX) / 2, y: CGFloat(posY) ).rotate(origin: CGPoint(x: CGFloat(posX), y: CGFloat(posY)), CGFloat(degree))

            
            print("Handle Center \(currentActiveView.distanceTravelled/2) \(currentModel.posX) \( currentModel.posY)")
            
            
            let calculatedWidth = currentModel.baseFrame.size.width * CGFloat(scaleFactor)
            let calculatedHeight = currentModel.baseFrame.size.height * CGFloat(scaleFactor)
            
            if calculatedWidth > 10 || calculatedHeight > 10 {
                
                var calculatedCenter = CGPoint.zero
                
                if currentActiveView.selectedView == "topTextDragHandle"{
                    calculatedCenter = topOffSetY
                    
                }
                else if currentActiveView.selectedView == "bottomTextDragHandle"{
                    calculatedCenter = bottomOffSetY
                }
                else if currentActiveView.selectedView == "rightTextDragHandle"{
                    calculatedCenter = rightOffsetX
                }
                else{
                    calculatedCenter = leftOffSetX
                }
                if templateHandler.selectedComponenet == .parent /*&& focusRootView.tag == currentActiveView.tag*/{
                    isParentDragging = true
                }
                
                print("Handle WIDTH HEIGHT \(currentActiveView.distanceTravelled) \(currentModel.width) \( currentModel.height)")
                print("Handle Center \(currentActiveView.distanceTravelled/2) \(currentModel.posX) \( currentModel.posY)")
                
                if currentActiveView.selectedView == "leftTextDragHandle" || currentActiveView.selectedView == "rightTextDragHandle"{
                    var baseFrame = currentModel.baseFrame
                    baseFrame.size.width = CGFloat(calculatedWidth)
                    baseFrame.center = calculatedCenter
                    baseFrame.isParentDragging = isParentDragging
                    baseFrame.shouldRevert = shouldRevert
                    currentModel.baseFrame = baseFrame
                    
                    
                    //                templateHandler.currentModel?.width = calculatedWidth
                    //                templateHandler.currentModel?.posX = Float(calculatedCenter.x)
                    //                templateHandler.currentModel?.posY = Float(calculatedCenter.y)
                }
                else {
                    var baseFrame = currentModel.baseFrame
                    baseFrame.size.height = CGFloat(calculatedHeight)
                    baseFrame.center = calculatedCenter
                    baseFrame.isParentDragging = isParentDragging
                    baseFrame.shouldRevert = shouldRevert
                    currentModel.baseFrame = baseFrame
                    
                    //                templateHandler.currentModel?.height = calculatedHeight
                    //                templateHandler.currentModel?.posY = Float(calculatedCenter.y)
                    //                templateHandler.currentModel?.posX = Float(calculatedCenter.x)
                }
                
                gesture.setTranslation(.zero, in: currentActiveView)
               // currentActiveView.updateDragHandles()
            }
            
            if gesture.state == .ended {
                currentActiveView.isScaling = false
                currentActiveView.distanceTravelled = 0.0
//                drawControlViews()
                currentActiveView.enableStealthMode = false
                showControlBar = true
                gridManager?.manageStateInBasicMode()
                gridManager?.manageState()
                gridManager?.setNeedsDisplay()
            }
           // updateControlBarIfNeeded()
            
        default:
            break
        }
}
}


extension ViewManager{
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        
        guard let currentActiveView = currentActiveView else {
            logger.logError("currentActiveView Nil")
            return
        }
        
        guard let templateHandler = templateHandler, let currentModel = templateHandler.currentModel else {
            logger.logError("templateHandler or currentModel nil")

            return
        }
        
        guard let focusRootView = rootView?.hasChild(id:  currentActiveView.parentView!.tag) else {
            logger.logError("currentActiveView Parent Nil")
            return
        }
        
        guard let currentPageView = rootView?.currentPage else {
            logger.logError("No Current Page Found")
            return
        }
        
        let prevCenterX = (currentModel.beginFrame.center).x.roundToDecimal(2)
        
        var cLocationX = gesture.location(in: currentPageView).x.roundToDecimal(2)
        
        var location = gesture.location(in: currentActiveView.placeHolderView)
        location = currentActiveView.convert(location, to: currentActiveView.placeHolderView)
        let translation = gesture.translation(in: currentActiveView)
      //  print("NL Tx \(translation.x) and Ty \(translation.y)")

        let scalingFactor: CGFloat = 1.0 // Adjust this value to control the sensitivity
        let adjustedTranslation = CGPoint(x: translation.x * scalingFactor, y: translation.y * scalingFactor)

        
        var shouldSkipUpdate : Bool = false
        
        switch currentActiveView.selectedView {
            
        case "topLeft", "topRight", "bottomLeft", "bottomRight":
            if gesture.state == .began {
//                removeControlViews()
                currentActiveView.enableStealthMode = true
                showControlBar = false
            }

//            print("Handle WIDTH HEIGHT \(currentActiveView.distanceTravelled)")
//            print("Adjusted Translation : \(adjustedTranslation.x) \(adjustedTranslation.y)")
            let rotation = currentModel.baseFrame.rotation
            let center = currentModel.baseFrame.center
           // print("NL X \(cLocation.x) Y \(cLocation.y)")
            switch currentActiveView.selectedView {
//            case "topLeft":
////                if cLocationX > prevCenterX{
////                    shouldSkipUpdate = true
////                }else {
//                    if location.x > 0 && location.y > 0 {
//                        currentActiveView.distanceTravelled = -adjustedTranslation.x
//                        //                        print("NN1")
//                    } else if location.x > 0 && location.y < 0 {
//                        currentActiveView.distanceTravelled = -adjustedTranslation.x
//                        //                        print("NN2")
//                    } else if location.x < 0 && location.y > 0 {
//                        currentActiveView.distanceTravelled = adjustedTranslation.x
//                        //                        print("NN3")
//                    } else if location.x < 0 && location.y < 0 {
//                        currentActiveView.distanceTravelled = -adjustedTranslation.x
//                        //                        print("NN4")
//                    }
//                }
            case "topLeft":
                // Make all quadrants consistent
                if location.x > 0 && location.y > 0 {
                    currentActiveView.distanceTravelled = -adjustedTranslation.x
                } else if location.x > 0 && location.y < 0 {
                    currentActiveView.distanceTravelled = -adjustedTranslation.x
                } else if location.x < 0 && location.y > 0 {
                    currentActiveView.distanceTravelled = -adjustedTranslation.x  // Changed from positive to negative
                } else if location.x < 0 && location.y < 0 {
                    currentActiveView.distanceTravelled = -adjustedTranslation.x
                }
            case "topRight":
//                if cLocationX < prevCenterX{
//                    shouldSkipUpdate = true
//                } else {
                    if location.x > 0 && location.y > 0 {
                        currentActiveView.distanceTravelled = adjustedTranslation.x
                        //                        print("NN1")
                    } else if location.x > 0 && location.y < 0 {
                        currentActiveView.distanceTravelled = adjustedTranslation.x
                        //                        print("NN2")
                    } else if location.x < 0 && location.y > 0 {
                        currentActiveView.distanceTravelled = adjustedTranslation.x
                        //                        print("NN3")
                    } else if location.x < 0 && location.y < 0 {
                        currentActiveView.distanceTravelled = adjustedTranslation.x
                        //                        print("NN4")
                    }
//                }
            case "bottomLeft":
//                if cLocationX > prevCenterX{
//                    shouldSkipUpdate = true
//                } else {
                    if location.x > 0 && location.y > 0 {
                        currentActiveView.distanceTravelled = -adjustedTranslation.x
                    } else if location.x > 0 && location.y < 0 {
                        currentActiveView.distanceTravelled = -adjustedTranslation.x
                    } else if location.x < 0 && location.y > 0 {
                        currentActiveView.distanceTravelled = -adjustedTranslation.x
                    } else if location.x < 0 && location.y < 0 {
                        currentActiveView.distanceTravelled = -adjustedTranslation.x
                    }
//                }
            case "bottomRight":
                if location.x > 0 && location.y > 0 {
                    currentActiveView.distanceTravelled = adjustedTranslation.x
                    //                        print("NN1")
                    logger.printLog("DragHandle-- BottomRight Moving...")
                } else if location.x > 0 && location.y < 0 {
                    currentActiveView.distanceTravelled = adjustedTranslation.x
                    logger.printLog("DragHandle-- BottomRight Moving...")
                    
                    //                        print("NN2")
                } else if location.x < 0 && location.y > 0 {
                    currentActiveView.distanceTravelled = adjustedTranslation.x
                    logger.printLog("DragHandle-- BottomRight Moving...")
                    
                    //                        print("NN3")
                } else if location.x < 0 && location.y < 0 {
                    currentActiveView.distanceTravelled = adjustedTranslation.x
                    logger.printLog("DragHandle-- BottomRight Moving...")
                    
                }
                default:
                logger.printLog("DragHandle-- Break...")
                    break
                }
            
        
        if !shouldSkipUpdate  {
            //For Managing the Anchor Point.
            gridManager?.selectedDragHandle = currentActiveView.selectedView
            logger.printLog("DragHandle--  Updating...")
            let prevWidth = Float(currentModel.baseFrame.size.width)
            let prevHeight = Float(currentModel.baseFrame.size.height)
            var travelDistanceByY : Float = 0.0
            var travelDistanceByX : Float = 0.0
            var scaleFactor : Float = 0.0
            
            if prevWidth < prevHeight {
                
                let newHeight = Float(currentModel.baseFrame.size.height) + Float(currentActiveView.distanceTravelled)
                scaleFactor = newHeight / prevHeight
                let newWidth = Float(currentModel.baseFrame.size.width) * scaleFactor
                
                travelDistanceByY = newHeight - prevHeight
                travelDistanceByX = newWidth - prevWidth
            }
            else{
                let newWidth = Float(currentModel.baseFrame.size.width) + Float(currentActiveView.distanceTravelled)
                scaleFactor = newWidth / prevWidth
                let newHeight = Float(currentModel.baseFrame.size.height) * scaleFactor
                
                travelDistanceByY = newHeight - prevHeight
                travelDistanceByX = newWidth - prevWidth
            }
            
            let angleInDegree = Double(currentModel.baseFrame.rotation)
            let angleInRadian = degreesToRadians(angleInDegree)
            
            let topleftOffSetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let topleftOffSetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let topRigthOffsetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) + (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let topRigthOffsetY = -(Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let bottomLeftOfsetX = -(Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let bottomLeftOfsetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) - (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let bottomRightOffsetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let bottomRightOffsetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            
            // print("Handle Center \(currentActiveView.distanceTravelled / 2) \(currentModel.posX) \(currentModel.posY)")
            
            let calculatedWidth = Float(currentModel.baseFrame.size.width) * scaleFactor
            let calculatedHeight = Float(currentModel.baseFrame.size.height) * scaleFactor
            
            if calculatedWidth > 10 || calculatedHeight > 10 {
                var calulatedCenterX: Float = .zero
                var calulatedCenterY: Float = .zero
//                
//                if currentActiveView.selectedView == "topLeft" {
//                    calulatedCenterX = Float(currentModel.baseFrame.center.x) - Float(topleftOffSetX)
//                    calulatedCenterY = Float(currentModel.baseFrame.center.y) - Float(topleftOffSetY)
//                }
                if currentActiveView.selectedView == "topLeft" {
                    // Adjust the formula to correctly account for rotation
                    calulatedCenterX = Float(currentModel.baseFrame.center.x) - Float(topleftOffSetX)
                    calulatedCenterY = Float(currentModel.baseFrame.center.y) - Float(topleftOffSetY)
                }
                else if currentActiveView.selectedView == "bottomRight" {
                    calulatedCenterX = Float(currentModel.baseFrame.center.x) + Float(bottomRightOffsetX)
                    calulatedCenterY = Float(currentModel.baseFrame.center.y) + Float(bottomRightOffsetY)
                } else if currentActiveView.selectedView == "bottomLeft" {
                    calulatedCenterX = Float(currentModel.baseFrame.center.x) + Float(bottomLeftOfsetX)
                    calulatedCenterY = Float(currentModel.baseFrame.center.y) - Float(bottomLeftOfsetY)
                } else {
                    calulatedCenterX = Float(currentModel.baseFrame.center.x) + Float(topRigthOffsetX)
                    calulatedCenterY = Float(currentModel.baseFrame.center.y) - Float(topRigthOffsetY)
                }
                if templateHandler.selectedComponenet == .parent && focusRootView.tag == currentActiveView.tag {
                    scaleChildOfFocusedParent(scale: CGFloat(scaleFactor), parentID: currentActiveView.tag)
                }
                
//                currentModel.baseFrame = Frame(size: CGSize(width: Double(calculatedWidth), height: Double(calculatedHeight)), center: CGPoint(x: Double(calulatedCenterX), y: Double(calulatedCenterY)), rotation: currentModel.baseFrame.rotation)
                
                //                print("Handle WIDTH HEIGHT \(currentActiveView.distanceTravelled) \(currentModel.width) \(currentModel.height)")
                //                print("Handle Center \(currentActiveView.distanceTravelled / 2) \(currentModel.posX) \(currentModel.posY)")
                //
                //                print("NL CX \(calulatedCenterX) CY \(calulatedCenterY)")
                
                gridManager?.gestureMode = .dragScale
                gridManager?.snapIfNeeded(currentViewCenter: CGPoint(x: Double(calulatedCenterX), y: Double(calulatedCenterY)), currentViewSize: CGSize(width: Double(calculatedWidth), height: Double(calculatedHeight)), rotation: Double(currentModel.baseFrame.rotation), parentViewFrame: currentParentView!, currentPageView: rootView!.currentPage!)
                
                //                print("NL W \(calculatedWidth) H \(calculatedHeight)")
                
                gesture.setTranslation(.zero, in: currentActiveView)
                // currentActiveView.updateDragHandles()
            }
        }

            if gesture.state == .ended {
                logger.printLog("DragHandle-- Pan ended")
                onTouchEnd()
            }

        default:
            break
        }
        
        func onTouchEnd() {
            currentActiveView.isScaling = false
            currentActiveView.distanceTravelled = 0.0
//                drawControlViews()
            currentActiveView.enableStealthMode = false
            showControlBar = true
            gridManager?.manageStateInBasicMode()
            gridManager?.manageState()
            gridManager?.setNeedsDisplay()
        }
        
       // updateControlBarIfNeeded()
    }

}
