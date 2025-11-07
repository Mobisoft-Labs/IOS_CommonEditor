//
//  VM_CoreUtil.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 25/01/25.
//
import Foundation

extension ViewManager {
    
    func indexOfModel(withId id: Int,  models: [PageInfo]) -> Int? {
        for (index, model) in models.enumerated() {
            if model.modelId == id {
                return index
            }
        }
        return nil
    }
    //Scale the child of focused parent.
    func scaleChildOfFocusedParent(scale : CGFloat, parentID: Int){
        let childrenModel = templateHandler?.getChildrenFor(parentID: parentID)
        for childModel in childrenModel!{
            let view = rootView?.viewWithTag(childModel.modelId)
            updateSizeUsingScale(view : view! as! BaseView , scale : scale, model : childModel)
        }
    }
    //Update the Children size that come under the focused parent.
    func updateSizeUsingScale(view: BaseView, scale: CGFloat, model: BaseModel) {
        logger.logWarning("JDDoubt - JDJDJDJD")
        // Update model size with scale factorre
        model.width *= Float(scale)
        model.height *= Float(scale)
        
       
        // Calculate new center based on scaled size
        let newCenterX = Double(model.baseFrame.center.x) * Double(scale)
        let newCenterY = Double(model.baseFrame.center.y) * Double(scale)
        let newCenter = CGPoint(x: newCenterX, y: newCenterY)
        
        // Update model position
        model.baseFrame.center.x = CGFloat(Float(newCenterX))
        model.baseFrame.center.y = CGFloat(Float(newCenterY))
        view.setFrame(frame: model.baseFrame)
    }
    
    func refresh(currentTime:Float? = nil ) {
        
        let cTime = currentTime ?? templateHandler?.playerControls?.currentTime ?? 0.0
        guard let rootView = self.rootView else { return }
        rootView._currentTime = cTime
        
        guard let currentActiveView = currentActiveView else {
            logger.logError("No Current Active View found This Is Bad")
            return
        }
        
        if currentActiveView is PageView {
            return
        }
        
        if templateHandler?.playerControls?.renderState == .Playing {
            // alredy handled for playing state
            return
        }
        
        currentActiveView.refreshUI = true
        refreshControlBar = true
        
       
        
       
    }
    
}
