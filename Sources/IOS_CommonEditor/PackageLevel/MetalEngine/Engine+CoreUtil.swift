//
//  helper.swift
//  VideoInvitation
//
//  Created by HKBeast on 21/06/24.
//

import Foundation

struct MoveModelData{
    let modelID:Int
    let parentID:Int
    let orderInParent:Int
    let baseFrame:Frame
    let depthLevel:Int
    let vFlip:Bool
    let hFlip:Bool
    let baseTime : StartDuration
    let arrayOFParents : [ParentAndChildBaseFrameAndTime]

}
struct ParentAndChildBaseFrameAndTime{
    let modelID:Int
    let  BaseFrame:Frame
    let BaseTime:StartDuration
    let  Child :[ChildBaseFrameAndTime]
}

struct ChildBaseFrameAndTime{
    let modelID:Int
    let  BaseFrame:Frame
    let BaseTime:StartDuration
}

struct ChildNewCenterWithID{
    let modelId : Int
    let center : CGPoint
    let timeline : StartDuration
}

struct parentBaseSize{
    let modelID:Int
    let baseSize:Frame
}


struct GroupModel {
    var oldMM:[MoveModelData]
    var newMM:[MoveModelData]
}


struct OrderChange {
    var selectedModelId : Int
    var oldOrder : Int
    var newOrder : Int
}

enum MoveModelType : String {
    case Group = "Grouped"
    case UnGroup = "UnGrouped"
    case OrderChangeOnly = "OrderChange Only"
    case MoveModel = "Move Model"
    case NotDefined = "Not Defined"
}

struct MoveModel{

    var oldlastSelectedId : Int = -1
    var newLastSelected : Int = -1
    var shouldAddParentID : Int?
    var shouldRemoveParentID : Int?
    var orderChange : OrderChange?
    
    var type : MoveModelType
    var oldMM:[MoveModelData]
    var newMM:[MoveModelData]
}


extension MetalEngine {
    func calculateNewCenterForParent(parentFrame:Frame,childFrame:Frame)->CGPoint{
        // Firstly Calculate the Origin of the Parent
        let parentOriginX = parentFrame.center.x - parentFrame.size.width/2
        let parentOriginY = parentFrame.center.y - parentFrame.size.height/2
        
        // Then Calculate the Origin Of Child
        let childOriginX = childFrame.center.x - childFrame.size.width/2
        let childOriginY = childFrame.center.y - childFrame.size.height/2
        
        // Then get the differnce by subtracting child origin with parent origin.
        _ = childOriginX + parentOriginX
        _ = childOriginY + parentOriginY
        
        //Then Calculate the Center of the child.
        let newChildCenterX = childFrame.center.x - parentOriginX
        let newChildCenterY = childFrame.center.y - parentOriginY
        
        //    //Set the center in the model.
        //    childFrame.center.x = newChildCenterX
        //    childFrame.center.y = newChildCenterY
        
        return CGPoint(x: newChildCenterX, y: newChildCenterY)
    }
    
    func calculateNewCenterForParentUngroup(parentFrame:Frame,childFrame:Frame)->CGPoint{
        // Firstly Calculate the Origin of the Parent
        let parentOriginX = parentFrame.center.x - parentFrame.size.width/2
        let parentOriginY = parentFrame.center.y - parentFrame.size.height/2
        
        // Then Calculate the Origin Of Child
        let childOriginX = childFrame.center.x - childFrame.size.width/2
        let childOriginY = childFrame.center.y - childFrame.size.height/2
        
        // Then get the differnce by subtracting child origin with parent origin.
        let diffX = childOriginX + parentOriginX
        let diffY = childOriginY + parentOriginY
        
        //Then Calculate the Center of the child.
        let newChildCenterX = childFrame.center.x - parentOriginX
        let newChildCenterY = childFrame.center.y - parentOriginY
        
        //    //Set the center in the model.
        //    childFrame.center.x = newChildCenterX
        //    childFrame.center.y = newChildCenterY
        
        return CGPoint(x: newChildCenterX, y: newChildCenterY)
    }
    
//    func changeSize(newBaseSize:CGSize) {
//        isLoading = true
//        self.baseSize = newBaseSize
//        engineConfig.BASE_SIZE = newBaseSize
////        templateHandler.setCurrentModel(id: -1) // JDCHange
//        shouldRenderOnScene = false
//            let ratioId = templateHandler.currentTemplateInfo?.ratioId
//            let ratioModel = DBManager.shared.getRatioDbModel(ratioId: ratioId!)
//            if let ratio = templateHandler.currentTemplateInfo?.ratioInfo.getRatioInfo(ratioInfo: ratioModel!, refSize: newBaseSize, logger: logger){
//                let oldSize = templateHandler.currentTemplateInfo?.ratioSize
//                let newRefSize = ratio.ratioSize
//                updateRatioOFPage2(newPageSize: newRefSize,newBaseSize: newBaseSize)
//              
//                Task {
//                    await sceneManager.changeRatio(ratio: newRefSize, refSize: newBaseSize)
//                    await MainActor.run {
//                        
//                        shouldRenderOnScene = true
//                        sceneManager.redraw()
//                        editorView?.frame.size = newBaseSize
//                        editorView?.updateCenter()
//                        isLoading = false
//                    }
//                }
//                
//
//    //            engine.viewManager?.ratioDidChange(page: engine.templateHandler.currentPageModel!)
//    //            engine.templateHandler.selectCurrentPage()
//              }
//        
//    }
    
    
    func updateRatioOFPage2(newPageSize:CGSize , newBaseSize : CGSize){
        guard let templateInfo = templateHandler.currentTemplateInfo else{
            logger.printLog("Template info object is not found to change ratio")
            return
        }
        for page in templateInfo.pageInfo{
            let oldPageSize = page.baseFrame.size
            page.baseFrame.size = newPageSize
            page.baseFrame.center = CGPoint(x: newBaseSize.width/2, y: newBaseSize.height/2)

            recursiveChildSizeChange(parent: page, oldParentSize: oldPageSize, newParentSize: newPageSize)
        }
    }
    
    public func updateRatioOFPage(newPageSize:CGSize ){
        guard let templateInfo = templateHandler.currentTemplateInfo else{
            logger.printLog("Template info object is not found to change ratio")
            return
        }
        for page in templateInfo.pageInfo{
            let oldPageSize = page.baseFrame.size
            page.baseFrame.size = newPageSize

            recursiveChildSizeChange(parent: page, oldParentSize: oldPageSize, newParentSize: newPageSize)
        }
    }
    
    
    private func recursiveChildSizeChange(parent:ParentModel,oldParentSize:CGSize,newParentSize:CGSize){
        for child in parent.children{
            let oldChildSize = child.baseFrame.size
            let componentX = child.baseFrame.center.x - child.baseFrame.size.width/2
            let componentY = child.baseFrame.center.y - child.baseFrame.size.height/2
            let calculateSize = calculateComponentPosition(componentX: componentX, componentY: componentY, componentWidth: child.baseFrame.size.width, componentHeight: child.baseFrame.size.height, componentAvailableWidth: CGFloat(child.prevAvailableWidth), componentAvailableHeight: CGFloat(child.prevAvailableHeight), rotationInDegree: CGFloat(child.baseFrame.rotation), currentParentWidth: oldParentSize.width, currentParentHeight: oldParentSize.height, newParentWidth: newParentSize.width, newParentHeight: newParentSize.height)
            let newSize = CGSize(width: calculateSize[2], height: calculateSize[3])
            let newCenter = CGPoint(x: calculateSize[0]+(calculateSize[2]/2), y: calculateSize[1]+(calculateSize[3]/2))
            child.baseFrame.size = newSize
            child.baseFrame.center = newCenter
            let oldPrevAvailableWidth = child.prevAvailableWidth
            let oldPrevAvailableHeight = child.prevAvailableHeight
            child.prevAvailableWidth = Float(calculateSize[4])
            child.prevAvailableHeight = Float(calculateSize[5])
            logger.printLog("[preAvailbaleSize changes] ratioChange modelId=\(child.modelId), modelType=\(child.modelType), " +
                            "prevW=\(oldPrevAvailableWidth)->\(child.prevAvailableWidth), " +
                            "prevH=\(oldPrevAvailableHeight)->\(child.prevAvailableHeight), " +
                            "parentOld=\(oldParentSize), parentNew=\(newParentSize)")
            if child.prevAvailableWidth < 0 || child.prevAvailableHeight < 0 {
                logger.logErrorFirebase("[preAvailbaleSize changes] Negative prevAvailable after ratio change: " +
                                        "modelId=\(child.modelId), modelType=\(child.modelType), " +
                                        "prevAvailableWidth=\(child.prevAvailableWidth), prevAvailableHeight=\(child.prevAvailableHeight)")
            }
            if !(isDBDisabled){
                _ = DBManager.shared.updateBaseFrameWithPrevious(modelId: child.modelId, newValue: child.baseFrame, parentFrame: newParentSize, previousWidth: CGFloat(child.prevAvailableWidth), previousHeight: CGFloat(child.prevAvailableHeight))
            }
            if let parent = child as? ParentModel{
                recursiveChildSizeChange(parent: parent, oldParentSize: oldChildSize, newParentSize: newSize)
            }
        }
    }
    
    
    func updateModelDeletionStatus(models:  [PageInfo], currentIndex: Int) -> Int? {
        
        // Find the previous or next model that is not soft deleted
        var newIndex: Int?

        // Check previous models
        for i in stride(from: currentIndex - 1, through: 0, by: -1) {
            if !models[i].softDelete {
                newIndex = i
                break
            }
        }

        // If no previous model found, check next models
        if newIndex == nil {
            for i in stride(from: currentIndex + 1, to: models.count, by: 1) {
                if !models[i].softDelete {
                    newIndex = i
                    break
                }
            }
        }

        // Return the index of the new selected model or nil if no model is found
        return newIndex
    }
    
    
    func updateStartTimeOfTheModel(index : Int){
        let pageArray = templateHandler.currentTemplateInfo!.pageInfo
        for (ind, value) in pageArray.enumerated() {
            if ind > index{
                print("KN Index: \(ind), Value: \(value)")
                let modelId = templateHandler.currentTemplateInfo!.pageInfo[ind].modelId
                templateHandler.currentTemplateInfo!.pageInfo[ind].baseTimeline.startTime -= templateHandler.currentPageModel!.duration
                if !(isDBDisabled){
                    _ = DBManager.shared.updatePageStartTime(modelId: templateHandler.currentTemplateInfo!.pageInfo[ind].modelId, newValue:  templateHandler.currentTemplateInfo!.pageInfo[ind].baseTimeline.startTime)
                }
            }
        }
    }
    func getParentStartTime(parentModel:ParentModel)->Float{
        var startTime = parentModel.baseTimeline.startTime
        if let parentParent = templateHandler.getModel(modelId: parentModel.parentId) as? ParentModel{
            if parentParent.parentId != parentModel.templateID{
                startTime += getParentStartTime(parentModel: parentParent)
            }
        }
        return startTime
    }
    
    func resize(ratioInfo: RatioInfo) {
        
        let newRatioSize =  getProportionalSize(currentRatio: ratioInfo.ratioSize, oldSize: templateHandler.currentTemplateInfo!.ratioSize)
        canvas.resizeCanvas(size: newRatioSize)
        // inform DB to replace ID
    }
    
    
           
           private  func calculateNewChildCenter(oldParent: Frame, newParent: Frame, currentChildCenter: CGPoint) -> CGPoint {
               // Calculate the new center of the child with respect to the new parent size
               let newCenterX = (currentChildCenter.x / oldParent.size.width) * newParent.size.width
               let newCenterY = (currentChildCenter.y / oldParent.size.height) * newParent.size.height
               let newChildCenter = CGPoint(x: newCenterX, y: newCenterY)
               
               return newChildCenter
           }
           
           
           func calculateNewChildCenter(child: BaseModel) -> CGPoint {
               var center = child.baseFrame.center
               
               func recursiveCenterCalculation(child: BaseModel) {
                   // Check if the child has a parent and if the parent is not the template
                   if  let parent = templateHandler.getModel(modelId: child.parentId) {
                       // Update the center relative to the parent
                       if parent.parentId != parent.templateID{
                           center.x += parent.baseFrame.center.x - (parent.baseFrame.size.width / 2)
                           center.y += parent.baseFrame.center.y - (parent.baseFrame.size.height / 2)
                           // Recursively calculate the center for the parent
                           recursiveCenterCalculation(child: parent)
                       }
                   }
               }
               
               // Start the recursive calculation
               recursiveCenterCalculation(child: child)
               
               return center
           }
    func getTheOrderForTheDuplicatdChild() -> Int{
        guard let currentParent = templateHandler.currentSuperModel else{
            return 0
        }
        if templateHandler.currentSuperModel?.children.count == 0 {
            return currentParent.orderInParent + 1
        }
        else{
            return currentParent.children.last!.orderInParent + 1
        }
    }
    
    func changeDurationAndStartTime(model: BaseModel, newStartTime:Float, newDuration: Float, oldDuration: Float){
        let durationChangeProportion = newDuration/oldDuration
        
        if !(isDBDisabled){
            _ = DBManager.shared.updateDuration(modelId: model.modelId, newValue: newDuration)
            _ = DBManager.shared.updateStartTime(modelId: model.modelId, newValue: newStartTime)
        }
        
        if let parent = model as? ParentModel {
            for child in parent.children{
                let childStartTime = child.baseTimeline.startTime * durationChangeProportion
                let childDuration = (child.baseTimeline.duration * durationChangeProportion)
                if let childIS = child as? ParentModel{
                    child.baseTimeline.startTime = childStartTime
                    child.baseTimeline.duration = childDuration
                    changeDurationAndStartTime(model: childIS, newStartTime: childStartTime, newDuration: childDuration, oldDuration: childIS.duration)
                }else{
                    if !(isDBDisabled){
                        _ = DBManager.shared.updateDuration(modelId: child.modelId, newValue: childDuration)
                        _ = DBManager.shared.updateStartTime(modelId: child.modelId, newValue: childStartTime)
                    }
                    child.baseTimeline.startTime = childStartTime
                    child.baseTimeline.duration = childDuration
                }
            }
        }
    }
}
extension MetalEngine{
    func recursiveChildBaseFrame(parent:ParentModel,oldSize:CGSize,newSize:CGSize){
        let newParentSize = newSize
//        let neeParentCenter = parent.center
        for child in parent.children {
            let childOldSize = child.baseFrame.size
            let newSize = recalculateSizeWithParent(parentOldSize: oldSize, parentNewSize: newParentSize, childOldSize: childOldSize)
            let newCenter = recalculateCenterWithParent(parentOldSize: oldSize, parentNewSize: newParentSize, childOldCenter: child.baseFrame.center)
            child.baseFrame.size = newSize
            child.baseFrame.center = newCenter
            if !(isDBDisabled){
                _ = DBManager.shared.updateBaseFrame(modelId: child.modelId, newValue: child.baseFrame, parentFrame: parent.baseFrame.size)
            }
            
            //Neeshu Conflict
            if child is ParentModel{
                recursiveChildBaseFrame(parent: child as! ParentModel, oldSize: childOldSize, newSize: child.baseFrame.size)
            }
        }
    }
    
    
    func recursiveChildBaseFrameForDragging(parent:ParentModel,oldParentCenter: CGPoint,oldParentSize : CGSize ,newSize:CGSize, shouldRevert : Bool){
        let newParentSize = newSize
        for child in parent.children {
            var centerX = child.baseFrame.center.x / parent.baseFrame.size.width
            var centerY = child.baseFrame.center.y / parent.baseFrame.size.height
            var newCenter = CGPoint(
                x: centerX,
                y: centerY
            )
            let childModel = templateHandler.getModel(modelId: child.modelId)
            if shouldRevert{
                let deltaInHeight = newSize.height - oldParentSize.height
                let deltaInWidth = newSize.width - oldParentSize.width
                var newCenterX = child.baseFrame.center.x + deltaInWidth
                var newCenterY = child.baseFrame.center.y + deltaInHeight
                childModel!.baseFrame.center.x = newCenterX
                childModel!.baseFrame.center.y = newCenterY
                newCenterX = newCenterX / newSize.width
                newCenterY = newCenterY / newSize.height
                newCenter = CGPoint(
                   x: newCenterX,
                   y: newCenterY
               )
            }
            
            if !(isDBDisabled){
                _ = DBManager.shared.updateBaseFrame(modelId: child.modelId, newValue: child.baseFrame, parentFrame: newSize, newCenter: newCenter)
            }
            
            if child is ParentModel{
//                recursiveChildBaseFrameForDragging(parent: child as! ParentModel, oldParentCenter : parent.center, oldParentSize: parent.size,  newSize: child.baseFrame.size)
            }
        }
    }
    
    

    
    
    func getNewChildCenter(
        oldParentCenter: CGPoint,
        oldParentSize: CGSize,
        newParentCenter: CGPoint,
        newParentSize: CGSize,
        childCenterInParent: CGPoint
    ) -> CGPoint {

        // Compute the absolute center of the child in the grandparent before resizing the parent
        let childAbsoluteCenter = CGPoint(
            x: oldParentCenter.x + (childCenterInParent.x - oldParentSize.width / 2),
            y: oldParentCenter.y + (childCenterInParent.y - oldParentSize.height / 2)
        )

        // Compute the new child center relative to the resized parent
        let newChildCenterInParent = CGPoint(
            x: childAbsoluteCenter.x - (newParentCenter.x - newParentSize.width / 2),
            y: childAbsoluteCenter.y - (newParentCenter.y - newParentSize.height / 2)
        )

        return newChildCenterInParent
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
    
    
    func onUserEditInputText(_ text: String) -> String? {
        var editedText = text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: " ")

        if editedText.count > 0 {
            return editedText
        } else {
            // Change the state of didTextInvalid.
            return nil
        }
    }

    func addSelectedViewsInGroupView( parentInfo : ParentInfo)->MoveModel {
        var moveModel:MoveModel = MoveModel(type: .Group, oldMM: [], newMM: [])
        var count = parentInfo.children.count
        var temp = [BaseModel]()
        
//        let sortedArray = templateHandler.currentActionState.multiSelectedItems.sorted(by: {
//            $0.orderInParent < $1.orderInParent
//        })
        
        let sortedArrayA = templateHandler.currentActionState.multiSelectedItems.sorted {
            if $0.orderInParent == $1.orderInParent {
                return $0.parentId < $1.parentId
            }
            return $0.orderInParent < $1.orderInParent
        }
        
//        for item in  templateHandler.currentActionState.multiSelectedItems{
//            if temp.contains(where: {$0.modelId == item.modelId}){
//
//           }else{
//               temp.append(item)
//           }
//        }
        
        var sortedArray : [BaseModel] = sortedArrayA
//        let uniqueSet = Set( templateHandler.currentActionState.multiSelectedItems)
//        let temp = Array(uniqueSet)
        
//        let temp : <MultiSelectedArrayObject> = templateHandler.currentActionState.multiSelectedItems
        for selectedViewID in  sortedArray {
//            if let model = templateHandler.getModel(modelId: selectedViewID){
            
                
            let moveModels =  templateHandler.moveChildIntoNewParent(modelID: selectedViewID.modelId, newParentID: parentInfo.modelId, order: count)
            if !moveModels.oldMM.isEmpty{
                moveModel.oldMM.append(moveModels.oldMM[0])
                moveModel.newMM.append(moveModels.newMM[0])
                count += 1
            }
//            }
        }
        
//        moveModel.oldParentID = templateHandler.currentPageModel!.modelId
//        moveModel.newParentID = parentInfo.modelId
        return moveModel
    }
    
    func getParentFrame() -> (CGRect, StartDuration) {
        var minX: CGFloat = .greatestFiniteMagnitude
        var minY: CGFloat = .greatestFiniteMagnitude
        var maxX: CGFloat = 0.0
        var maxY: CGFloat = 0.0
        var startTime: CGFloat = 15.0
        var duration: CGFloat = 0.0

        for selectedViewID in templateHandler.currentActionState.multiSelectedItems {
            guard let modelOfCurrentView = templateHandler.getModel(modelId: selectedViewID.modelId) else { continue }
            var center = templateHandler.calculateNewChildCenter(child: modelOfCurrentView, childOldFrame: modelOfCurrentView.baseFrame)
            let centerX = center.x // modelOfCurrentView.baseFrame.center.x
            let centerY = center.y // modelOfCurrentView.baseFrame.center.y
            let width = modelOfCurrentView.baseFrame.size.width
            let height = modelOfCurrentView.baseFrame.size.height
            let rotationAngle = CGFloat(modelOfCurrentView.baseFrame.rotation) // Assuming this is in radians
            
            let rotation = rotationAngle * .pi / 180
            
            let baseStartTime = modelOfCurrentView.getModelStartTime(templatehandler: templateHandler)
            let baseDuration = modelOfCurrentView.baseTimeline.startTime+modelOfCurrentView.baseTimeline.duration
            // Calculate the corners of the original (non-rotated) frame
            let corners = [
                CGPoint(x: centerX - width / 2, y: centerY - height / 2), // top-left
                CGPoint(x: centerX + width / 2, y: centerY - height / 2), // top-right
                CGPoint(x: centerX - width / 2, y: centerY + height / 2), // bottom-left
                CGPoint(x: centerX + width / 2, y: centerY + height / 2)  // bottom-right
            ]
            
            // Apply the rotation to each corner
            let rotatedCorners = corners.map { point -> CGPoint in
                let translatedX = point.x - centerX
                let translatedY = point.y - centerY
                let rotatedX = translatedX * cos(rotation) - translatedY * sin(rotation)
                let rotatedY = translatedX * sin(rotation) + translatedY * cos(rotation)
                return CGPoint(x: rotatedX + centerX, y: rotatedY + centerY)
            }
            
            // Update min and max coordinates based on rotated corners
            for corner in rotatedCorners {
                if corner.x < minX { minX = corner.x }
                if corner.y < minY { minY = corner.y }
                if corner.x > maxX { maxX = corner.x }
                if corner.y > maxY { maxY = corner.y }
            }
            
            startTime = min(startTime, CGFloat(baseStartTime))
            duration = max(duration, CGFloat( baseDuration))
        }
        
        duration -= startTime
        
        let width = maxX - minX
        let height = maxY - minY
        
        return (CGRect(x: minX, y: minY, width: width, height: height), StartDuration(startTime: Float(startTime), duration: Float(duration)))
    }

}
