//
//  ViewManager + ControlBar.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/04/24.
//
//
import Foundation
import SwiftUI


public protocol ToolBarIntegrator {
    func getEasyToolBar() -> any View
    func getEditToolBar(id: Int, currentModel: ParentInfo) -> any View
    
}


extension ViewManager {
    
    func addControlBar() {
    
//        guard let provider = easyToolBarProvider else {
//            logger.printLog("⚠️ EasyToolBarProvider not set")
//            return
//        }
//        let view = provider.makeEasyToolBar()
//        TBI.getEasyTooLBar()
//        let view = AnyView(EasyToolBar(vmConfig: vmConfig).environmentObject(templateHandler!).environment(\.sizeCategory, .medium))
        let view = AnyView(toolbarConfig.getEasyToolBar())
        if controlBarView == nil {
            controlBarView = UIHostingController(rootView: view )
            controlBarView!.view.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
            editView?.addSubview(controlBarView!.view)
            controlBarView!.view.isUserInteractionEnabled = true
            controlBarView!.view.backgroundColor = .clear
        } else {
            controlBarView?.rootView = view
        }
        
        controlBarView?.view.isHidden = false
        
            updateVerticalPosition()
            updateHorizontalPosition()
        
    }
    
    func updateControlBarPosition() {
        updateVerticalPosition()
        updateHorizontalPosition()
    }
    
    func updateVerticalPosition() {
        
        if let currentActiveView = currentActiveView  {
            
            guard let controlBarView = controlBarView?.view else {
                logger.logInfo("Alredy Nil ControlBar View")
                return
            }
//            let currentViewCenter = po
            
            let currentViewSize = currentActiveView.frame.size

            
            // Define control bar's width and height
                let controlBarWidth: CGFloat = 180
                let controlBarHeight: CGFloat = 40
                let offset: CGFloat = 25 // The fixed offset (top or bottom)
                
            var defaultCenterX : CGFloat = editView!.frame.width/2
            var defaultCenterY : CGFloat = 40
            
            var finalPositionX = defaultCenterX
            var finalPositionY = defaultCenterY
            
            
            // here get currentActiveView rotatedRect
            // rotationButton rotated Rect
            // get min max from both
            // measure according to new rect
            
            let currentViewFrame = currentActiveView.frame
            let currentActiveViewBounds = currentActiveView.bounds
           
            
            var minX = currentViewFrame.minX
            var maxX = currentViewFrame.maxX
            var minY = currentViewFrame.minY
            var maxY = currentViewFrame.maxY
            
            // check if rotation handle exist or not ( in locked case or extra zoom it may be unAvailable
            if  let rotationSuperView = currentActiveView.rotateHandle?.superview {
                let rotationFrame =  rotationSuperView.convert(currentActiveView.rotateHandle!.frame, to: currentActiveView.parentView)
               
                
                minX = min(currentViewFrame.minX, rotationFrame.minX)
                maxX = max(currentViewFrame.maxX, rotationFrame.maxX)
                minY = min(currentViewFrame.minY, rotationFrame.minY)
                maxY = max(currentViewFrame.maxY, rotationFrame.maxY)
                
            }
            
            let newOrigin = currentActiveView.parentView!.convert(CGPoint(x: minX, y: minY), to: editView)

            if (newOrigin.y - 25) <  60 {
                finalPositionY = editView!.frame.height - 40
            }
            
            controlBarView.center = CGPoint(x: finalPositionX, y: finalPositionY)
        }
    }
    func updateHorizontalPosition() {
        
    }
    func removeControlBar() {
        guard let controlBarView = controlBarView?.view  else {
            logger.logInfo("Alredy Nil ControlBar View")
        return
    }
        controlBarView.isHidden = true
        
    }

    func needToShift(childRect: CGRect) -> Bool {
        let childRectMinX = childRect.minX - 50
        let childRectMaxX = childRect.maxX + 50
        let childRectMinY = childRect.minY - 50
        let childRectMaxY = childRect.maxY + 50
        
        let parentFrame = editView!.bounds
        
        return parentFrame.contains(CGPoint(x: childRectMinX, y: childRectMinY)) &&
        parentFrame.contains(CGPoint(x: childRectMinX, y: childRectMaxY)) &&
        parentFrame.contains(CGPoint(x: childRectMaxX, y: childRectMinY)) &&
        parentFrame.contains(CGPoint(x: childRectMaxX, y: childRectMaxY))
    }
    
    func needToShiftForControlBar(childRect: CGRect) -> Bool {
        let childRectMinX = childRect.minX
        let childRectMaxX = childRect.maxX
        let childRectMinY = childRect.minY - 110
        let childRectMaxY = childRect.maxY + 110
        
        let parentFrame = editView!.bounds
        
        return parentFrame.contains(CGPoint(x: childRectMinX, y: childRectMinY)) &&
        parentFrame.contains(CGPoint(x: childRectMinX, y: childRectMaxY)) &&
        parentFrame.contains(CGPoint(x: childRectMaxX, y: childRectMinY)) &&
        parentFrame.contains(CGPoint(x: childRectMaxX, y: childRectMaxY))
    }
    
    
    
    //Draw the control views for the edit state.
    func drawControlBarForEdit(model : ParentInfo) {
        guard let currentActiveView = rootView?.viewWithTag(model.modelId) else { return }
//        guard let editView = editView,
//                      let currentActiveView = rootView?.viewWithTag(model.modelId),
//                      let provider = controlBarProvider else {
//                    return
//                }
//        let view = provider.makeEditControlBar(for: model, id: model.modelId)
//        let view =  EditControlBar(id: model.modelId, vmConfig: vmConfig, currentModel: model)
        let view = toolbarConfig.getEditToolBar(id: model.modelId, currentModel: model)
        let controlBarView = UIHostingController(rootView: AnyView(view))
        controlBarView.view.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        editView?.addSubview(controlBarView.view)
        controlBarView.view.isUserInteractionEnabled = true
        controlBarView.view.backgroundColor = .clear
        
        controlBarContainer.append(ControlBarEntry(id: model.modelId, controller: controlBarView))
//        controlBarContainer.append(controlBarView)
        
        controlBarView.view.frame.size = CGSize(width: 40, height: 40)
        let frameOfCurrentView = currentActiveView.convert(currentActiveView.bounds, to: editView)
        
        
        let childMaxX = frameOfCurrentView.midX + frameOfCurrentView.width/2
        let childMinX = frameOfCurrentView.midX - frameOfCurrentView.width/2
        let childMaxY = frameOfCurrentView.midY + frameOfCurrentView.height/2
        let childMinY = frameOfCurrentView.midY - frameOfCurrentView.height/2
        
        let parentMaxX = editView!.bounds.maxX
        let parentMaxY = editView!.bounds.maxY
        
        let parentMinY = editView!.bounds.minY
        let parentMinX = editView!.bounds.minX
        
        let controlBarHeight: CGFloat = 30 // Height of the control bar
        
        var centerX = frameOfCurrentView.midX
        var centerY = frameOfCurrentView.minY - controlBarHeight
        
        let isShiftedOrNot = needToShiftForControlBar(childRect: frameOfCurrentView)
        
        if !isShiftedOrNot{
            // Handle X direction conditions
            if childMaxX + 40  > parentMaxX {
                print("Control Child MaxX is greater")
                centerX = abs(frameOfCurrentView.minX) //- 60
                if centerX < 64{
                    centerX =  64
                }
            } else if frameOfCurrentView.minX < parentMinX {
                print("Control Child MaxX is lesser")
                let diff = abs(frameOfCurrentView.minX) //+ 60
                centerX = frameOfCurrentView.midX + diff
            }
            
            
             if childMaxY + (controlBarHeight + 40)  > parentMaxY {
                print("Control Child MaxY is greater")
                centerY = childMinY - controlBarHeight
            } else if childMinY - (controlBarHeight + 40)  < parentMinY
            {
                print("Control Child MaxY is lesser")
                centerY = childMaxY + controlBarHeight
            }
        }
        
        // Set the center point
        controlBarView.view.center = CGPoint(x: centerX, y: centerY)
        
        // Reset the center point if the view is completely out of bounds
        if frameOfCurrentView.maxX < 0 || frameOfCurrentView.minX > parentMaxX ||
            frameOfCurrentView.maxY < 0 || frameOfCurrentView.minY > parentMaxY {
            controlBarView.view.center = CGPoint(x: parentMaxX / 2, y: parentMaxY - 60 / 2)
        }
    }

    
}
