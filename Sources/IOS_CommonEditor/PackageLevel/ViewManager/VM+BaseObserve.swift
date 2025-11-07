//
//  VM+BaseObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/01/25.
//
import UIKit

extension ViewManager {
    
    public func observeAsCurrentBaseModel(_ baseModel: BaseModel) {
        
       
        
        baseModel.$modelFlipHorizontal.dropFirst().sink { [weak self] value in
            self?.currentActiveView!.layer.transform = CATransform3DRotate(self!.currentActiveView!.layer.transform, .pi, 0, 1, 0)
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$modelFlipVertical.dropFirst().sink { [weak self] value in
            self?.currentActiveView!.layer.transform = CATransform3DRotate(self!.currentActiveView!.layer.transform, .pi, 1, 0, 0)
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$softDelete.dropFirst().sink{ [weak self]  value in
            if  self?.templateHandler?.selectedComponenet != .page{
                value ? self?.currentActiveView?.onDeleteAction() : self?.currentActiveView?.onUndeleteAction()
                self?.refreshControlBar = true
            }
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$lockStatus.dropFirst().sink{ [weak self] value in
                if self?.currentActiveView is PageView {
                    self?.logger.logError("Page Cannot Be Locked ")
                } else{
                    self?.currentActiveView?.vISLOCKED = value
                }
            self?.refreshControlBar = true

   
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$baseFrame.dropFirst().sink { [weak self] frame in
            self?.logger.printLog("KL \(frame)")
            guard let currentModel = self!.templateHandler?.currentModel else { return }
            guard let self = self else{ return }
            guard let currentActiveView = currentActiveView else { return }
            let oldSize = currentActiveView.size
            currentActiveView.setFrame(frame: frame)
            guard let currentModel = templateHandler?.currentModel else { return }

            if currentModel is ParentInfo && frame.isParentDragging{
                let parentModel = (templateHandler!.currentSuperModel!) as! ParentModel
                recursiveChildBaseFrameForDragging(parent:currentModel as! ParentInfo,oldParentSize : oldSize ,newSize:frame.size, shouldRevert: frame.shouldRevert)
            }
            else if currentModel is ParentInfo && !frame.isParentDragging && frame.size != currentModel.baseFrame.size{
               recursiveChildBaseFrame(parent: currentModel as! ParentInfo, oldSize: oldSize, newSize: frame.size)
            }
            self.refreshControlBar = true

        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$baseTimeline.dropFirst().removeDuplicates().sink {[weak self] baseTimeline in
            
            guard let currentActiveView = self?.currentActiveView else {
                self?.logger.logError("No Current Active View found This Is Bad")
                return
            }
            currentActiveView.startTime = baseTimeline.startTime
            currentActiveView.duration = baseTimeline.duration
            self?.refreshControlBar = true

        }.store(in: &modelPropertiesCancellables)
        
        //Set the Thumb Image into the Current View.
        baseModel.$thumbImage.dropFirst().sink{ [weak self] thumbImage in
            if let thumbImage = thumbImage{
                self?.currentActiveView?.setThumbImage(thumbImage: thumbImage)
            }
        }.store(in: &modelPropertiesCancellables)
        
        baseModel.$isActive.dropFirst().sink(receiveValue: { [weak self] isSelected in
            self?.logger.logErrorJD(tag: .isSelected,
                       "\(baseModel.modelType.rawValue)")
            guard let self = self else { return }
            
        guard let currentActiveView = self.currentActiveView ,
              let currentParentView = currentParentView
                else {
            logger.logError(" Child Or Parent UIView Not Found")
            return }
            
            currentParentView.bringToTop(child: currentActiveView)
            currentActiveView.isActive = isSelected
            currentActiveView.invertedScale =  invertScale

            if !(currentActiveView is PageView) {
                showControlBar = isSelected
            }else{
                showControlBar = false
            }
//            updateControlBarIfNeeded()
            

        }).store(in: &modelPropertiesCancellables)
    }
}


extension ViewManager{
    func recursiveChildBaseFrameForDragging(parent:ParentModel,oldParentSize : CGSize ,newSize:CGSize, shouldRevert : Bool){
        guard let templateHandler = templateHandler else { return }
        for child in parent.children {
            let view = currentParentView?.viewWithTag(child.modelId) as? BaseView
            let centerX = view!.centerPoints.x//child.baseFrame.center.x
            let centerY = view!.centerPoints.y//child.baseFrame.center.y
            var newCenter = CGPoint(
                x: centerX,
                y: centerY
            )
            
            if shouldRevert{
                let deltaInHeight = newSize.height - oldParentSize.height
                let deltaInWidth = newSize.width - oldParentSize.width
                let newCenterX = view!.centerPoints.x/*child.baseFrame.center.x*/ + deltaInWidth
                let newCenterY = view!.centerPoints.y/*child.baseFrame.center.y*/ + deltaInHeight
                print("NHH \(newCenter), \(deltaInHeight)")
                newCenter = CGPoint(
                   x: newCenterX,
                   y: newCenterY
               )
                print("NHH \(newCenter)")
            }
            
            var baseFrame = child.baseFrame
            baseFrame.center = newCenter
            view?.setFrame(frame:  baseFrame)
        }
    }
}




extension ViewManager{
    func recursiveChildBaseFrame(parent:ParentModel,oldSize:CGSize,newSize:CGSize){
        let newParentSize = newSize
//        let neeParentCenter = parent.center
        for child in parent.children {
            guard let view = currentParentView?.viewWithTag(child.modelId) as? BaseView else { return }
            let childOldSize = view.size//child.baseFrame.size
            let newSize = recalculateSizeWithParent(parentOldSize: oldSize, parentNewSize: newParentSize, childOldSize: childOldSize)
            let newCenter = recalculateCenterWithParent(parentOldSize: oldSize, parentNewSize: newParentSize, childOldCenter: view.centerPoints)/*child.baseFrame.center)*/
            
            var baseFrame = child.baseFrame
            baseFrame.center = newCenter
            baseFrame.size = newSize
            view.setFrame(frame:  baseFrame)
            
            //Neeshu Conflict
            if child is ParentModel{
                recursiveChildBaseFrame(parent: child as! ParentModel, oldSize: childOldSize, newSize: child.baseFrame.size)
            }
        }
    }
    
    
    private func recalculateSizeWithParent(parentOldSize: CGSize, parentNewSize: CGSize, childOldSize: CGSize) -> CGSize {
          let widthScaleFactor = childOldSize.width / parentOldSize.width
          let heightScaleFactor = childOldSize.height / parentOldSize.height
          
          let childNewWidth = parentNewSize.width * widthScaleFactor
          let childNewHeight = parentNewSize.height * heightScaleFactor
          
          return CGSize(width: childNewWidth, height: childNewHeight)
      }

      private func recalculateCenterWithParent(parentOldSize: CGSize, parentNewSize: CGSize, childOldCenter: CGPoint) -> CGPoint {
          let widthScaleFactor = childOldCenter.x / parentOldSize.width
          let heightScaleFactor = childOldCenter.y / parentOldSize.height
          
          let childNewWidth = parentNewSize.width * widthScaleFactor
          let childNewHeight = parentNewSize.height * heightScaleFactor
          
          return CGPoint(x: childNewWidth, y: childNewHeight)
      }
}
