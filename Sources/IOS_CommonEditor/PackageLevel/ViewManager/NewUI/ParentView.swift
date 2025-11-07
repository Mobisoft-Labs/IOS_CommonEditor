//
//  ParentView.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 26/03/24.
//

import UIKit
import Foundation
import SwiftUI


//var tapCheckingState = false

public class ParentView: BaseView {
    
    var childCount : Int = 0
    
    
    func turnOffGrouping() {
        childrens.forEach { view in
            if let childAsParent = view as? ParentView {
                childAsParent.turnOffGrouping()
            }
            view.isSelectedForMultiple = false
        }
    }
    
    
    override func LockedStateUI() {
//        logErrorJD(tag: .selectedVsEdit," LOCKED ON \(identification)")
    }
    
    override  func SelectedStateUI() {
//        logErrorJD(tag: .selectedVsEdit,"SELECTED  ON \(identification)")

    }
    
    override  func NotSelectedStateUI() {
    
//        logErrorJD(tag: .selectedVsEdit,"NOT SELECTED \(identification)")

    }
    
    override func EditStateUI() {
//        logErrorJD(tag: .selectedVsEdit," EDIT ON \(identification)")

    }
    
    override func onActiveOn() {

       
            
            if vISLOCKED {
                _internalUILayerState = .Locked
                _internalDragHandlerState = .hideHandlers
                LockedStateUI()
            } else if vIS_EDIT {
                _internalUILayerState = .Edited
                _internalDragHandlerState = .showHandlersPlusSides
                EditStateUI()
            }
//        else if isSelectedForMultiple {
//                
//                    _internalUILayerState = .MuliSelected
//                    _internalDragHandlerState = .hideHandlers
//                    
//                
//            }
            else {
                _internalUILayerState = .Selected
                _internalDragHandlerState = .showHandlers
                SelectedStateUI()
            }
            
        
        updateBoarder()
        manageHandlers()
    }
    
    override func onActiveOff() {
        if vIS_EDIT {
            _internalUILayerState = .Edited
            _internalDragHandlerState = .hideHandlers
            
            EditStateUI()
        }
//        else
//        if isSelectedForMultiple {
//            _internalUILayerState = .MuliSelected
//                    _internalDragHandlerState = .hideHandlers
//
//        }
        else {
           _internalUILayerState = .NotSelected
           _internalDragHandlerState = .hideHandlers

           NotSelectedStateUI()
       }
       updateBoarder()
        manageHandlers()
    }
    
    
    override func onActiveOnMultiselect() {
        if vIS_EDIT {
            _internalUILayerState = .Edited
        }else {
            _internalUILayerState = .MuliSelected
        }
        _internalDragHandlerState = .hideHandlers
            updateBoarder()
            manageHandlers()
    }
    
    override func onActiveOffMultiselect() {
        if vIS_EDIT {
            _internalUILayerState = .Edited
        }else {
            _internalUILayerState = .NotSelected
        }
        _internalDragHandlerState = .hideHandlers
        updateBoarder()
        manageHandlers()
    }
    
    
    func hasChild(id: Int) -> BaseView? {
        return self.viewWithTag(id) as? BaseView
    }
    //Childrens contains the children array of the parent.
    var childrens : [BaseView] = []
    var activeChildrenCount : Int {
        return childrens.filter({!$0.isHidden}).count
    }
    override var currentTime: Float {
        return _currentTime + (parentView?.currentTime ?? 0)
    }
    
     var templateHandler : TemplateHandler? {
         return parentView?.templateHandler
    }
    
    public override init(id: Int, name: String, logger: PackageLogger, vmConfig: ViewManagerConfiguration) {
        super.init(id: id, name: name, logger: logger, vmConfig: vmConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isExpanding : Bool = false
    var isCollapsing : Bool = false

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Example: Centering child view inside parent
          for subview in subviews {
              subview.center = CGPoint(x: bounds.midX, y: bounds.midY)
          }
        print("layoutSubviews called - Child position:")
        placeHolderView.layer.sublayers?.filter({$0 is CAShapeLayer}).forEach({$0.frame = placeHolderView.bounds; ($0 as? CAShapeLayer)?.path  =  UIBezierPath(rect: $0.bounds).cgPath})
        self.updateDragHandles()
    }
    
    //Function used for adding the sticker.
    func addSubChild(_ view : BaseView ){
        if let childView = view as? BaseView {
            childrens.append(childView)
            childView.parentView = self
        }
        if !isExpanding {
            childCount += 1
        }
        self.placeHolderView.addSubview(view)
        logger.printLog("VM_ Adding \(view.name) - \(view.tag) to \(self.name) \(self.tag)-, allChildren\(childrens.count)")

    }
    
    //Function used for removing the children.
    func removeChild(_ child: BaseView){
        childrens.removeAll { $0 === child }
        child.removeFromSuperview()
        if !isCollapsing {
            childCount -= 1
        }
        logger.printLog("VM_ Removing \(child.name) - \(child.tag) from \(self.name) - \(self.tag), allChildren\(childrens.count)")
    }
    
    //Function used for removing the all child of the parent.
    func removeAllChild(){
        childrens.forEach({removeChild($0 as BaseView)})
    }
    
    
    func getChild(for id:Int)->BaseView?{
        return childrens.first(where: {$0.tag == id})
    }
    
    func sortChildrensInDescendingOrder() {
        childrens.sort { $0.orderInParent > $1.orderInParent }
     }
    
    //This overlapHitTest check that which view is tapped.
    override func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        childrens.forEach { print($0.name, $0.orderInParent) }
        // 1
        if !self.isUserInteractionEnabled || self.isHidden  {//|| self.alpha == 0
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
        
        
        
        sortChildrensInDescendingOrder()
        //3
        for subview in self.childrens{
                
            if let parent = subview as? ParentView , !( parent is PageView ){
                if let templateHandler = parent.templateHandler {
                    if  let parentModel = templateHandler.getModel(modelId: parent.tag) as? ParentInfo , !parentModel.editState {
                            
                            let allChildren = parentModel.children
                            
                            // if has children then check for soft delete status
                            if (allChildren.isEmpty) {
                                logger.logInfo("Empty Parent Child Moved... Moving Ahead")
                        
                         continue
                    }else {
                        let activeChildren = parentModel.activeChildren
                        if activeChildren.isEmpty {
                            logger.logInfo("Empty Parent Deleted Child ... Moving Ahead")
                            
                            continue
                        }
                    }
                }
                
                }
                
            }
                let insideSubview = self.convert(point, to: subview)
                
                //if let sview = subview as? UIBaseView {
                if  let hitView = subview.overlapHitTest(point: insideSubview, withEvent: event) {
                    return hitView
                }
                // }
            
        }
        
        if !canDisplay {
            return nil 
        }
        return hitView
    }
    
    
    
}




extension ParentView {
    
  
    
    func addStickerView(stickerInfo : StickerInfo){
        // JDChange
        let focusRootView = self
        
        let stickerView = StickerView(id: stickerInfo.modelId, name: stickerInfo.modelType.rawValue, logger: logger, vmConfig: vmConfig)
        //stickerView.parentView = focusRootView
        stickerView.startTime = stickerInfo.baseTimeline.startTime
        stickerView.duration = stickerInfo.baseTimeline.duration
        let center = stickerInfo.baseFrame.center
        let size = stickerInfo.baseFrame.size
        stickerView.vISLOCKED = stickerInfo.lockStatus
        stickerView.isHidden = stickerInfo.softDelete
        print("SV Size \(size) and Center \(center)")
//        stickerView.setSize(size: size)
//        stickerView.setCenter(center: center)
//        stickerView.setRotation(angle: Double(stickerInfo.baseFrame.rotation))
        stickerView.setFrame(frame: stickerInfo.baseFrame)
        stickerView.setOrder(order: stickerInfo.orderInParent)
        if let image = stickerInfo.thumbImage{
            stickerView.setThumbImage(thumbImage: image)
        }
        // Determine if the parent view is flipped
        if isViewFlipped(view: focusRootView) {
            // Apply the same transform to the new child view
            stickerView.layer.transform = focusRootView.layer.transform
       
        }
        
        if stickerInfo.modelFlipVertical{
            stickerView.layer.transform = CATransform3DRotate(stickerView.layer.transform, .pi, 1, 0, 0)
        }
        
        if stickerInfo.modelFlipHorizontal{
            stickerView.layer.transform = CATransform3DRotate(stickerView.layer.transform, .pi, 0, 1, 0)
        }
        
        focusRootView.addSubChild(stickerView)
    }
    
    
    func addTextView(textInfo : TextInfo){
        
        // JDChange
         let focusRootView = self
        
        let textView = TextView(id: textInfo.modelId, name: textInfo.modelType.rawValue, logger: logger, vmConfig: vmConfig)
        textView.startTime = textInfo.baseTimeline.startTime
        textView.duration = textInfo.baseTimeline.duration
        let center = textInfo.baseFrame.center
        let size = textInfo.baseFrame.size
        textView.vISLOCKED = textInfo.lockStatus
        textView.isHidden = textInfo.softDelete

//        textView.setSize(size: size)
//        textView.setCenter(center: center)
//        textView.setRotation(angle: Double(textInfo.baseFrame.rotation))
        textView.setFrame(frame: textInfo.baseFrame)

        textView.setOrder(order: textInfo.orderInParent)
        if let image = textInfo.thumbImage{
            textView.setThumbImage(thumbImage: image)
        }
        // Determine if the parent view is flipped
        if isViewFlipped(view: focusRootView) {
            // Apply the same transform to the new child view
            textView.layer.transform = focusRootView.layer.transform
        }
        if textInfo.modelFlipVertical{
            textView.layer.transform = CATransform3DRotate(textView.layer.transform, .pi, 1, 0, 0)
        }
        
        if textInfo.modelFlipHorizontal{
            textView.layer.transform = CATransform3DRotate(textView.layer.transform, .pi, 0, 1, 0)
        }
        
        focusRootView.addSubChild(textView)
    }
    
    func addParentView(parentInfo : ParentInfo){
       
        
        // JDChange
         let focusRootView =  self
   
        let parentView = ParentView(id: parentInfo.modelId, name: parentInfo.modelType.rawValue, logger: logger, vmConfig: vmConfig)
        
        parentView.startTime = parentInfo.baseTimeline.startTime
        parentView.duration = parentInfo.baseTimeline.duration
        let center = parentInfo.baseFrame.center
        let size = parentInfo.baseFrame.size
        parentView.vISLOCKED = parentInfo.lockStatus
        parentView.isHidden = parentInfo.softDelete
//        parentView.setSize(size: size)
//        parentView.setCenter(center: center)
//        parentView.setRotation(angle: Double(parentInfo.baseFrame.rotation))
        
       parentView.setFrame(frame: parentInfo.baseFrame)
        parentView.setOrder(order: parentInfo.orderInParent)
        if let image = parentInfo.thumbImage{
            parentView.setThumbImage(thumbImage: image)
        }
        if isViewFlipped(view: focusRootView) {
            // Apply the same transform to the new child view
            parentView.layer.transform = focusRootView.layer.transform
        }
        
        if parentInfo.modelFlipVertical{
            parentView.layer.transform = CATransform3DRotate(parentView.layer.transform, .pi, 1, 0, 0)
        }
        
        if parentInfo.modelFlipHorizontal{
            parentView.layer.transform = CATransform3DRotate(parentView.layer.transform, .pi, 0, 1, 0)
        }
        
        focusRootView.addSubChild(parentView)
    }
    
    func isViewFlipped(view: UIView) -> Bool {
        let transform = view.layer.transform
        
        // Check if the transform indicates a flip
        let isFlippedX = transform.m11 < 0
        let isFlippedY = transform.m22 < 0
        
        return isFlippedX || isFlippedY
    }
    
    
    func addChildren(children : [BaseModel]) {
        for childModel in children{
            if let stickerInfo = childModel as? StickerInfo{
                self.addStickerView(stickerInfo:stickerInfo)
            }
           else if let textInfo = childModel as? TextInfo{
               self.addTextView(textInfo: textInfo)
            }
            
           else if let parentInfo = childModel as? ParentInfo{
               self.addParentView(parentInfo: parentInfo)
            }
        }
    }
    
    func removeChildren(children : [BaseModel]) {
        for childModel in children{
            if let childView = self.hasChild(id: childModel.modelId) {
                self.removeChild(childView)
            }
        }
//        if !self.childrens.isEmpty {
//            logError("Error still Hold Children")
//        }
    }
}
