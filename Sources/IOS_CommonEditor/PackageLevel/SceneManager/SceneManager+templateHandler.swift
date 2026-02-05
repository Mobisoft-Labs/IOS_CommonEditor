import Foundation
import UIKit
import simd
import Combine // Import Combine framework for using publishers and subscribers


extension SceneManager {

    func addSticker(stickerInfo:StickerInfo) async -> Bool{

        if let stickerChild = await createSticker(stickerInfo){
            if canCacheMchild { cacheChild(key: stickerChild.id, value: stickerChild) }
            if var parnt = currentParent as? MParent{
                
                parnt.addChild(stickerChild, at: stickerChild.mOrder)
                parnt.increaseChildOrderInParent(order: stickerChild.mOrder+1)
                return true
            }
        }
       return false
    }
    
    
    func addText(textInfo:TextInfo) async{
        let textChild = createText(textInfo)
        if canCacheMchild { cacheChild(key: textChild.id, value: textChild) }
        // childTable[sticerInfo.modelId] = stickerChild
        if var parnt = currentParent as? MParent{
            
            parnt.addChild(textChild, at: textChild.mOrder)
            parnt.increaseChildOrderInParent(order: textChild.mOrder+1)
            return
        }
    }
    
}

extension SceneManager{
    func addPage(pm:PageInfo)async{
        
        
        if  let page = await createPage(pm){
            let newSize = await metalDisplay!.bounds.size
            let newCenter = CGPoint(x: newSize.width/2, y: newSize.height/2)
            // page.center.y = 248
            page.center = newCenter
            currentScene?.addChild(page)
            currentScene?.context = currentScene!.context
            currentScene?.context.rootSize = newSize//await metalDisplay!.bounds.size
            //                  redraw()'
            print("At the time of duplicate \(currentScene?.context)")
        }
        
    }
    
    func addPage(parent:ParentInfo) async{
        let parentInfo = await createMParent(parentModel: parent)
        if canCacheMchild { cacheChild(key: parent.modelId, value: parentInfo) }
        if var page = currentPage as? MPage{
            page.addChild(parentInfo)
        }
    }
    
     func changeDuration(model:MChild,newDuration:Float){
         let oldDuration = model.mDuration
         let durationChangeProportion = newDuration/oldDuration
 //        let changeInDuration = (durationChange*100)/oldDuration
         model.mDuration = newDuration
//         _ = DBManager.shared.updateDuration(modelId: model.modelId, newValue: newDuration)
         if let parent = model as? MParent{
             for child in parent.childern{
                 let childDuration = (child.mDuration * durationChangeProportion)
                 if let childIS = child as? MParent{
                     changeDuration(model: childIS, newDuration: childDuration)
                 }else{
                     model.mDuration = childDuration
                 }
             }
         }
     }
    
    func changeStartTimeAndDuration(model: MChild, newStartTime:Float, newDuration: Float, oldDuration: Float){
        let durationChangeProportion = newDuration/oldDuration
        
//        model.startTime = newStartTime
        model.setMStartTime(newStartTime)
//        model.mDuration = newDuration
        model.setMDuration(newDuration)
        
        print("base time mStart Time:\(model.mStartTime) \(model.mDuration)")
        
        if let parent = model as? MParent{
            
            if parent is MPage{
                currentScene?.setMDuration(templateHandler?.currentTemplateInfo?.totalDuration ?? 0)
                parent.backgroundChild?.setMDuration(newDuration)
                parent.watermarkChild?.setMDuration(newDuration)
                return
            }
            
            for child in parent.childern{
                let childStartTime = (child.startTime * durationChangeProportion)
                let childDuration = (child.mDuration * durationChangeProportion)
                if let childIS = child as? MParent{
//                    model.startTime = childStartTime
                    child.setMStartTime(childStartTime)
//                    child.mDuration = childDuration
                    child.setMDuration(childDuration)
                    changeStartTimeAndDuration(model: childIS, newStartTime:childStartTime, newDuration: childDuration, oldDuration: childIS.mDuration)
                }else{
//                    model.startTime = childStartTime
                    child.setMStartTime(childStartTime)
//                    child.mDuration = childDuration
                    child.setMDuration(childDuration)
                }
            }
            
        }
    }
    
    
    //NK***
    func updateStartTimeOfTheModel(index : Int){
        let pageArray = currentScene!.childern
        for (ind, value) in pageArray!.enumerated() {
            if ind > index{
                print("KN Index: \(ind), Value: \(value)")
                let modelId = templateHandler!.currentTemplateInfo!.pageInfo[ind].modelId
                pageArray![ind].startTime -= templateHandler!.currentPageModel!.duration
            }
        }
    }
     
     
     
     func changeStartTime(model:MChild,newStartTime:Float){
         let oldDuration = model.startTime
         let startTimeChangeProportion = newStartTime/oldDuration
 //        let changeInDuration = (durationChange*100)/oldDuration
         
         model.startTime = newStartTime
         if let parent = model as? MParent{
             for child in parent.childern{
                 let childStartTime = (child.startTime * startTimeChangeProportion)
                 if let childIS = child as? MParent{
                    
                     changeStartTime(model: childIS, newStartTime: childStartTime)
                 }else{
                     model.startTime = childStartTime
                 }
             }
         }
     }
    
    
    
    // change order in page
    func changePageSequence(template:TemplateInfo,oldOrder:Int,newOrder:Int){
        // calculations to update orders , parents
        let oldPage = template.pageInfo[oldOrder]
        template.pageInfo.remove(at: oldOrder)
        
        template.pageInfo.insert(oldPage, at: newOrder)
        
        
        
        // db updation
        // refreshIds = [ modelIds affected ]
        
    }
    
    
    func addParent(parentInfo:ParentInfo) async{
//        func addParent(ParentInfo){
        // create a method to remove everyChild of Parent from currentmParent
        let mParent = await createMParent(parentModel: parentInfo)
//           childTable[modelID] = mParent
//        if canCacheMchild { cacheChild(key: parentInfo.modelId, value: mParent) }
        
        if var page = currentPage as? MPage{
             page.addChild(mParent,at: mParent.mOrder)
//            page.increaseChildOrderInParent(order: mParent.mOrder+1)
             mParent.context = currentScene!.context
//            page.removeChild(<#T##child: MChild##MChild#>)
        }
//           redraw()
    }
    
 
    func orderChange(newOrder:Int){
        // get pageModel
        // old order and new order
        // refresh list from old order to new order
        
        if let pageModel = currentPage as? MPage{
            
            let oldOrder = pageModel.mOrder
            if oldOrder < newOrder{
                // order of oldOrder +1 to newOrder decrease order by 1
                let updateDict = currentScene?.decreaseOrderOFChildren(from: oldOrder+1, to: newOrder, duration: pageModel.mDuration)
                
                let child = currentScene!.childern[oldOrder]
                if let updateDict = updateDict{
                    child.mOrder = newOrder
                    child.startTime = updateDict.1
                }
                // remove page from template at order
                currentScene?.childern.remove(at: oldOrder)
                
                // add page in template at new order
                currentScene?.childern.insert(child, at: newOrder)
               
                
            }else{
                // order from newOrder to newOrder -1 increase by 1
                
                // remove page from template at oldOrder
                // add Page in template at newOrder
                let updateDict = currentScene?.increaseOrderOFChildren(from: newOrder, to: oldOrder-1, duration: pageModel.mDuration)
                
                let child = currentScene!.childern[oldOrder]
                if let updateDict = updateDict{
                    child.mOrder = newOrder
                    child.startTime = updateDict.1
                }
                
                currentScene?.childern.remove(at: oldOrder)
                
                currentScene?.childern.insert(child, at: newOrder)
            }
            
            
        }
        
    }
    func orderChangeInParent(newOrder:Int){
        // get pageModel
        // old order and new order
        // refresh list from old order to new order
        
        if let pageModel = currentChild as? MParent,let page = currentPage as? MPage{
            
            let oldOrder = pageModel.mOrder
            if oldOrder < newOrder{
                
                // order of oldOrder +1 to newOrder decrease order by 1
                let updateDict = currentScene?.decreaseOrderOFChildren(from: oldOrder+1, to: newOrder, duration: pageModel.mDuration)
                // remove page from template at order
                page.childern.remove(at: oldOrder)
                // add page in template at new order
                // remove page from template at order
                
                page.childern.insert(pageModel, at: newOrder)
                pageModel.mOrder = newOrder
            }else{
                // order from newOrder to newOrder -1 increase by 1
                
                // remove page from template at oldOrder
                // add Page in template at newOrder
                
                
                
                let updateDict = page.increaseOrderOFChildren(from: newOrder, to: oldOrder-1, duration: pageModel.mDuration)
                
                page.childern.remove(at: oldOrder)
                
                pageModel.mOrder = newOrder
                page.childern.insert(pageModel, at: newOrder)
            }
            
            
        }
        
    }
        
}

extension SceneManager{
    
    
    func recursiveChildBaseFrame(parent:MParent,oldSize:CGSize){
        let newParentSize = parent.size
//        let neeParentCenter = parent.center
        for child in parent.childern {
            let childOldSize = child.size
            let newSize = recalculateSizeWithParent(parentOldSize: oldSize, parentNewSize: newParentSize, childOldSize: childOldSize)
            let newCenter = recalculateCenterWithParent(parentOldSize: oldSize, parentNewSize: newParentSize, childOldCenter: child.center)
            child.setmSize(width: newSize.width, height: newSize.height)
            child.setmCenter(centerX: newCenter.x, centerY: newCenter.y)
            
            if child is MParent{
                recursiveChildBaseFrame(parent: child as! MParent, oldSize: childOldSize)
            }
        }
    }
    
    
    
    func recursiveChildCenter(parent:MParent,oldParentCenter: CGPoint,oldSize : CGSize ,newParentSize:CGSize, shouldRevert : Bool){
        for child in parent.childern {
            var centerX = child.center.x
            var centerY = child.center.y 
            var newCenter = CGPoint(
                x: centerX,
                y: centerY
            )
            if shouldRevert{
                let deltaInHeight = newParentSize.height - oldSize.height
                let deltaInWidth = newParentSize.width - oldSize.width
                var newCenterX = child.center.x + deltaInWidth
                var newCenterY = child.center.y + deltaInHeight
                newCenter = CGPoint(
                   x: newCenterX,
                   y: newCenterY
               )
            }
            child.setmCenter(centerX: newCenter.x, centerY: newCenter.y)

                    
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
    

    func getOuterFrameSize(originalSize: CGSize, angle: CGFloat) -> CGSize {
        let radians = angle * .pi / 180  // Convert degrees to radians
        let halfWidth = originalSize.width / 2
        let halfHeight = originalSize.height / 2

        // Define the four corners relative to the center
        let corners = [
            CGPoint(x: -halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: halfHeight),
            CGPoint(x: -halfWidth, y: halfHeight)
        ]

        // Rotate each corner
        var rotatedCorners: [CGPoint] = []
        for corner in corners {
            let rotatedX = corner.x * cos(radians) - corner.y * sin(radians)
            let rotatedY = corner.x * sin(radians) + corner.y * cos(radians)
            rotatedCorners.append(CGPoint(x: rotatedX, y: rotatedY))
        }

        // Compute the bounding box by finding min/max X and Y
        let minX = rotatedCorners.map { $0.x }.min() ?? 0
        let maxX = rotatedCorners.map { $0.x }.max() ?? 0
        let minY = rotatedCorners.map { $0.y }.min() ?? 0
        let maxY = rotatedCorners.map { $0.y }.max() ?? 0

        // Calculate final width and height
        let newWidth = maxX - minX
        let newHeight = maxY - minY

        return CGSize(width: newWidth, height: newHeight)
    }

    
    func getNewCenter(oldCenter: CGPoint, oldSize: CGSize, newSize: CGSize) -> CGPoint {
        let deltaX = (newSize.width - oldSize.width) / 2
        let deltaY = (newSize.height - oldSize.height) / 2
        
        let newCenterX = oldCenter.x + deltaX
        let newCenterY = oldCenter.y + deltaY
        
        return CGPoint(x: newCenterX, y: newCenterY)
    }
    
    
    
    func recursiveBaseSizeAndCenter(parent: MParent,oldParentSize:CGSize) {
        if let page = parent as? MPage{
            if  let child = page.backgroundChild{
                let oldSize = child.size
                let newChildSize = reCalculateSize(currentChildSize: oldSize, currentParentSize: oldParentSize, newParentSize: parent.size,aspectRatio: false)
                let center = recalculateCenter(currentCenter: child.center, currentParentSize: oldSize, newParentSize: newChildSize)
//                print("parent old child\(child.id)",child.size,child.center)
               
                // Update the child's baseFrame
                child.setmSize(width: parent.size.width, height: parent.size.height)
                child.setmCenter(centerX: center.x, centerY: center.y)
                
//                print("parent new child\(child.id)",child.size,child.center)
            }
        }
        
        for child in parent.allChild {
        
            let oldSize = child.size
//            child.previousWidth = Float(oldSize.width)
//            child.previousHeight = Float(oldSize.height)
            
            // recalculate Size
            if child is BGChild{
            
            }else if child is MWatermark{
                
            }
            else{
              
                
                if let childModel = templateHandler?.childDict[child.id]{
                    
                    child.setmSize(width: childModel.baseFrame.size.width, height: childModel.baseFrame.size.height)
                    child.setmCenter(centerX: childModel.baseFrame.center.x, centerY: childModel.baseFrame.center.y)
                    child.previousWidth = childModel.prevAvailableWidth
                    child.previousHeight = childModel.prevAvailableHeight
                    print("parent new child\(child.id)",child.size,child.center)
                    
                    if let childText = child as? TextChild , let childModelText = childModel as? TextInfo{
                        let textProperties = childModelText.textProperty
                        let sceneSize = currentSceneSize
                        let maxWidth = sceneSize.width * sceneConfig!.contentScaleFactor
                        let maxHeight = sceneSize.height * sceneConfig!.contentScaleFactor
                        if let texture =  Conversion.loadTexture(image: childModelText.createImage(keepSameFont: false, text: childModelText.text, properties: textProperties, refSize: childModel.baseFrame.size, maxWidth: maxWidth, maxHeight: maxHeight, contentScaleFactor: sceneConfig!.contentScaleFactor, logger: logger)!, flip: false ){
                            // Set Texture
                            childText.setTexture(texture: texture)
                            
                        }
                    }
                }
                if let childParent = child as? MParent {
                              recursiveBaseSizeAndCenter(parent: childParent, oldParentSize: oldSize)
                }
            }
        }
    }
}

func recalculateSizeWithParent(parentOldSize: CGSize, parentNewSize: CGSize, childOldSize: CGSize) -> CGSize {
    let widthScaleFactor = childOldSize.width / parentOldSize.width
    let heightScaleFactor = childOldSize.height / parentOldSize.height
    
    let childNewWidth = parentNewSize.width * widthScaleFactor
    let childNewHeight = parentNewSize.height * heightScaleFactor
    
    return CGSize(width: childNewWidth, height: childNewHeight)
}

func recalculateCenterWithParent(parentOldSize: CGSize, parentNewSize: CGSize, childOldCenter: CGPoint) -> CGPoint {
    let widthScaleFactor = childOldCenter.x / parentOldSize.width
    let heightScaleFactor = childOldCenter.y / parentOldSize.height
    
    let childNewWidth = parentNewSize.width * widthScaleFactor
    let childNewHeight = parentNewSize.height * heightScaleFactor
    
    return CGPoint(x: childNewWidth, y: childNewHeight)
}

/// Calculates a proportional size while maintaining the same aspect ratio of oldSize.
func getProportionalSizeWithAspect(currentSize: CGSize, newSize: CGSize) -> CGSize {
    let aspectRatio = currentSize.width / currentSize.height
    
    let widthScale = newSize.width / currentSize.width
    let heightScale = newSize.height / currentSize.height
    
    // Use the larger scale to ensure the new size fits within the bounds of newSize
    let scale = max(widthScale, heightScale)
    
    let newWidth = currentSize.width * scale
    let newHeight = currentSize.height * scale
    
    return CGSize(width: newWidth, height: newHeight)
}

func getSideCorner(oldParentSize: CGSize, newParentSize: CGSize, childCenter: CGPoint, childSize: CGSize, childNewSize: CGSize) -> CGPoint {
    let halfOldParentWidth = oldParentSize.width / 2
    let halfOldParentHeight = oldParentSize.height / 2
    let halfChildSizeWidth = childSize.width / 2
    let halfChildSizeHeight = childSize.height / 2

    var newCenter = CGPoint.zero

    // Determine which region the child was in
    
    
    let isTop = (childCenter.y - halfChildSizeHeight) <= 10.0 // if it comes 10.0 or less it mean it lies in top left
    let isBottom = (childCenter.y + halfChildSizeHeight) >= oldParentSize.height
    let isLeft = (childCenter.x - halfChildSizeWidth) <= 10.0
    let isRight = (childCenter.x + halfChildSizeWidth) >= oldParentSize.height

    
    if isTop && isLeft {
        // Top Left Corner
        newCenter = CGPoint(x: childCenter.x, y: childCenter.y)
    } else if isTop && isRight {
        // Top Right Corner
        newCenter = CGPoint(x: childCenter.x+(childNewSize.width-childSize.width), y: childCenter.y)
    } else if isBottom && isLeft {
        // Bottom Left Corner
        newCenter = CGPoint(x: childNewSize.width / 2, y: newParentSize.height - childNewSize.height / 2)
    } else if isBottom && isRight {
        // Bottom Right Corner
        newCenter = CGPoint(x: newParentSize.width - childNewSize.width / 2, y: newParentSize.height - childNewSize.height / 2)
    } else {
        // Not in a corner, calculate proportionally
        let normalizedX = childCenter.x / oldParentSize.width
        let normalizedY = childCenter.y / oldParentSize.height
        newCenter = CGPoint(x: normalizedX * newParentSize.width, y: normalizedY * newParentSize.height)
    }

    return newCenter
}



func calculateComponentPosition(componentX: CGFloat, componentY: CGFloat, componentWidth: CGFloat, componentHeight: CGFloat,
                                componentAvailableWidth: CGFloat, componentAvailableHeight: CGFloat, rotationInDegree: CGFloat,
                                currentParentWidth: CGFloat, currentParentHeight: CGFloat, newParentWidth: CGFloat, newParentHeight: CGFloat) -> [CGFloat] {
    
    // This method scales a component from an old parent size to a new parent size while
    // preserving aspect-fit constraints. The "available" size represents the container
    // the content was fit into before resizing (prevAvailableWidth/Height).
    //
    // Example:
    // - Content was fit into a 300x200 container (available), resulting in a 300x150 final size.
    // - If the parent width doubles while height stays, the available size becomes 600x200.
    // - The content is re-fit into 600x200, producing a 400x200 final size (not 600x300).
    // This prevents incorrect scaling when aspect ratios change.
    let componentCenterX = componentWidth / 2.0 + componentX
    let componentCenterY = componentHeight / 2.0 + componentY
    let rotationInRadian = rotationInDegree * .pi / 180.0
    
    let componentTopLeftAfterRotationX = componentCenterX + (componentX - componentCenterX) * cos(rotationInRadian) - (componentY - componentCenterY) * sin(rotationInRadian)
    let componentTopLeftAfterRotationY = componentCenterY + (componentX - componentCenterX) * sin(rotationInRadian) + (componentY - componentCenterY) * cos(rotationInRadian)

    let componentTopRightAfterRotationX = componentCenterX + (componentX + componentWidth - componentCenterX) * cos(rotationInRadian) - (componentY - componentCenterY) * sin(rotationInRadian)
    let componentTopRightAfterRotationY = componentCenterY + (componentX + componentWidth - componentCenterX) * sin(rotationInRadian) + (componentY - componentCenterY) * cos(rotationInRadian)

    let componentBottomLeftAfterRotationX = componentCenterX + (componentX + componentWidth - componentCenterX) * cos(rotationInRadian) - (componentY + componentHeight - componentCenterY) * sin(rotationInRadian)
    let componentBottomLeftAfterRotationY = componentCenterY + (componentX + componentWidth - componentCenterX) * sin(rotationInRadian) + (componentY + componentHeight - componentCenterY) * cos(rotationInRadian)

    let componentBottomRightAfterRotationX = componentCenterX + (componentX - componentCenterX) * cos(rotationInRadian) - (componentY + componentHeight - componentCenterY) * sin(rotationInRadian)
    let componentBottomRightAfterRotationY = componentCenterY + (componentX - componentCenterX) * sin(rotationInRadian) + (componentY + componentHeight - componentCenterY) * cos(rotationInRadian)

    
    let componentLeft = min(componentTopLeftAfterRotationX, min(componentTopRightAfterRotationX, min(componentBottomLeftAfterRotationX, componentBottomRightAfterRotationX)))
    let componentTop = min(componentTopLeftAfterRotationY, min(componentTopRightAfterRotationY, min(componentBottomLeftAfterRotationY, componentBottomRightAfterRotationY)))
    let componentRight = max(componentTopLeftAfterRotationX, max(componentTopRightAfterRotationX, max(componentBottomLeftAfterRotationX, componentBottomRightAfterRotationX)))
    let componentBottom = max(componentTopLeftAfterRotationY, max(componentTopRightAfterRotationY, max(componentBottomLeftAfterRotationY, componentBottomRightAfterRotationY)))
    
    let currentParentLeft = 0.0
    let currentParentTop = 0.0
    let currentParentRight = currentParentWidth
    let currentParentBottom = currentParentHeight
    
    let currentParentCenterX = currentParentWidth / 2.0 + currentParentLeft
    let currentParentCenterY = currentParentHeight / 2.0 + currentParentTop
    
    let componentDistanceFromCXToCX = abs(componentCenterX - currentParentCenterX)
    let componentDistanceFromCXToLeft = abs(componentCenterX - currentParentLeft)
    let componentDistanceFromCXToRight = abs(componentCenterX - currentParentRight)
    
    let componentDistanceFromCYToCY = abs(componentCenterY - currentParentCenterY)
    let componentDistanceFromCYToTop = abs(componentCenterY - currentParentTop)
    let componentDistanceFromCYToBottom = abs(componentCenterY - currentParentBottom)
    
    let componentDistanceFromLeftToLeft = abs(componentLeft - currentParentLeft)
    let componentDistanceFromLeftToCX = abs(componentLeft - currentParentCenterX)
    
    let componentDistanceFromTopToTop = abs(componentTop - currentParentTop)
    let componentDistanceFromTopToCY = abs(componentTop - currentParentCenterY)
    
    let componentDistanceFromRightToRight = abs(componentRight - currentParentRight)
    let componentDistanceFromRightToCX = abs(componentRight - currentParentCenterX)
    
    let componentDistanceFromBottomToBottom = abs(componentBottom - currentParentBottom)
    let componentDistanceFromBottomToCY = abs(componentBottom - currentParentCenterY)
    
    let parentRatioX = newParentWidth / currentParentWidth
    let parentRatioY = newParentHeight / currentParentHeight
    
    let newComponentX = componentX * parentRatioX
    let newComponentY = componentY * parentRatioY
    
    let newComponentWidth = componentAvailableWidth * parentRatioX
    let newComponentHeight = componentAvailableHeight * parentRatioY
    
    let resizeDim = getResizeDim(requiredWidth: CGFloat(componentWidth), requiredHeight: CGFloat(componentHeight), availableWidth: CGFloat(newComponentWidth), availableHeight: CGFloat(newComponentHeight))
    
    let newComponentFinalW = resizeDim.width
    let newComponentFinalH = resizeDim.height
    
    let changeRatioInComponentWidth = newComponentFinalW / componentWidth
    let changeRatioInComponentHeight = newComponentFinalH / componentHeight
    
    var newComponentFinalX = newComponentX
    var newComponentFinalY = newComponentY
    
    let minDistanceX = min(componentDistanceFromLeftToLeft, min(componentDistanceFromRightToRight, min(componentDistanceFromCXToCX, min(componentDistanceFromLeftToCX, min(componentDistanceFromCXToLeft, min(componentDistanceFromCXToRight, componentDistanceFromRightToCX))))))
    let minDistanceY = min(componentDistanceFromTopToTop, min(componentDistanceFromBottomToBottom, min(componentDistanceFromCYToCY, min(componentDistanceFromTopToCY, min(componentDistanceFromCYToTop, min(componentDistanceFromCYToBottom, componentDistanceFromBottomToCY))))))
    
    if componentDistanceFromLeftToLeft == minDistanceX {
        newComponentFinalX = currentParentLeft + ((componentX - currentParentLeft) * changeRatioInComponentWidth)
    } else if componentDistanceFromRightToRight == minDistanceX {
        newComponentFinalX = newParentWidth - newComponentFinalW + (((componentX + componentWidth) - currentParentRight) * changeRatioInComponentWidth)
    } else if componentDistanceFromCXToCX == minDistanceX {
        newComponentFinalX = newParentWidth / 2.0 - newComponentFinalW / 2.0 + ((componentCenterX - currentParentCenterX) * changeRatioInComponentWidth)
    } else if componentDistanceFromLeftToCX == minDistanceX {
        newComponentFinalX = newParentWidth / 2.0 + ((componentX - currentParentCenterX) * changeRatioInComponentWidth)
    } else if componentDistanceFromCXToLeft == minDistanceX {
        newComponentFinalX = currentParentLeft - newComponentFinalW / 2.0 + ((componentCenterX - currentParentLeft) * changeRatioInComponentWidth)
    } else if componentDistanceFromRightToCX == minDistanceX {
        newComponentFinalX = newParentWidth / 2.0 - newComponentFinalW + (((componentX + componentWidth) - currentParentCenterX) * changeRatioInComponentWidth)
    } else if componentDistanceFromCXToRight == minDistanceX {
        newComponentFinalX = newParentWidth - newComponentFinalW / 2.0 + ((componentCenterX - currentParentRight) * changeRatioInComponentWidth)
    }
    
    if componentDistanceFromTopToTop == minDistanceY {
        newComponentFinalY = currentParentTop + ((componentY - currentParentTop) * changeRatioInComponentHeight)
    } else if componentDistanceFromBottomToBottom == minDistanceY {
        newComponentFinalY = newParentHeight - newComponentFinalH + (((componentY + componentHeight) - currentParentBottom) * changeRatioInComponentHeight)
    } else if componentDistanceFromCYToCY == minDistanceY {
        newComponentFinalY = newParentHeight / 2.0 - newComponentFinalH / 2.0 + ((componentCenterY - currentParentCenterY) * changeRatioInComponentHeight)
    } else if componentDistanceFromTopToCY == minDistanceY {
        newComponentFinalY = newParentHeight / 2.0 + ((componentY - currentParentCenterY) * changeRatioInComponentHeight)
    } else if componentDistanceFromCYToTop == minDistanceY {
        newComponentFinalY = currentParentTop - newComponentFinalH / 2.0 + ((componentCenterY - currentParentTop) * changeRatioInComponentHeight)
    } else if componentDistanceFromBottomToCY == minDistanceY {
        newComponentFinalY = newParentHeight / 2.0 - newComponentFinalH + (((componentY + componentHeight) - currentParentCenterY) * changeRatioInComponentHeight)
    } else if componentDistanceFromCYToBottom == minDistanceY {
        newComponentFinalY = newParentHeight - newComponentFinalH / 2.0 + ((componentCenterY - currentParentBottom) * changeRatioInComponentHeight)
    }
    
    if componentAvailableWidth < 0 || componentAvailableHeight < 0 || newComponentWidth < 0 || newComponentHeight < 0 ||
        newComponentFinalW < 0 || newComponentFinalH < 0 || newComponentFinalX < 0 || newComponentFinalY < 0 {
        print("[preAvailbaleSize changes] calculateComponentPosition negative sizes: " +
              "componentAvailableWidth=\(componentAvailableWidth), componentAvailableHeight=\(componentAvailableHeight), " +
              "newComponentWidth=\(newComponentWidth), newComponentHeight=\(newComponentHeight), " +
              "newComponentFinalW=\(newComponentFinalW), newComponentFinalH=\(newComponentFinalH), " +
              "newComponentFinalX=\(newComponentFinalX), newComponentFinalY=\(newComponentFinalY)")
    }

    return [newComponentFinalX, newComponentFinalY, newComponentFinalW, newComponentFinalH, newComponentWidth, newComponentHeight]
}

func calculateComponentPositionProportional(componentX: CGFloat, componentY: CGFloat, componentWidth: CGFloat, componentHeight: CGFloat,
                                            componentAvailableWidth: CGFloat, componentAvailableHeight: CGFloat, rotationInDegree: CGFloat,
                                            currentParentWidth: CGFloat, currentParentHeight: CGFloat, newParentWidth: CGFloat, newParentHeight: CGFloat) -> [CGFloat] {
    let componentCenterX = componentWidth / 2.0 + componentX
    let componentCenterY = componentHeight / 2.0 + componentY
    let rotationInRadian = rotationInDegree * .pi / 180.0
    
    let componentTopLeftAfterRotationX = componentCenterX + (componentX - componentCenterX) * cos(rotationInRadian) - (componentY - componentCenterY) * sin(rotationInRadian)
    let componentTopLeftAfterRotationY = componentCenterY + (componentX - componentCenterX) * sin(rotationInRadian) + (componentY - componentCenterY) * cos(rotationInRadian)
    
    let componentTopRightAfterRotationX = componentCenterX + (componentX + componentWidth - componentCenterX) * cos(rotationInRadian) - (componentY - componentCenterY) * sin(rotationInRadian)
    let componentTopRightAfterRotationY = componentCenterY + (componentX + componentWidth - componentCenterX) * sin(rotationInRadian) + (componentY - componentCenterY) * cos(rotationInRadian)
    
    let componentBottomLeftAfterRotationX = componentCenterX + (componentX + componentWidth - componentCenterX) * cos(rotationInRadian) - (componentY + componentHeight - componentCenterY) * sin(rotationInRadian)
    let componentBottomLeftAfterRotationY = componentCenterY + (componentX + componentWidth - componentCenterX) * sin(rotationInRadian) + (componentY + componentHeight - componentCenterY) * cos(rotationInRadian)
    
    let componentBottomRightAfterRotationX = componentCenterX + (componentX - componentCenterX) * cos(rotationInRadian) - (componentY + componentHeight - componentCenterY) * sin(rotationInRadian)
    let componentBottomRightAfterRotationY = componentCenterY + (componentX - componentCenterX) * sin(rotationInRadian) + (componentY + componentHeight - componentCenterY) * cos(rotationInRadian)
    
    let componentLeft = min(componentTopLeftAfterRotationX, min(componentTopRightAfterRotationX, min(componentBottomLeftAfterRotationX, componentBottomRightAfterRotationX)))
    let componentTop = min(componentTopLeftAfterRotationY, min(componentTopRightAfterRotationY, min(componentBottomLeftAfterRotationY, componentBottomRightAfterRotationY)))
    let componentRight = max(componentTopLeftAfterRotationX, max(componentTopRightAfterRotationX, max(componentBottomLeftAfterRotationX, componentBottomRightAfterRotationX)))
    let componentBottom = max(componentTopLeftAfterRotationY, max(componentTopRightAfterRotationY, max(componentBottomLeftAfterRotationY, componentBottomRightAfterRotationY)))
    
    let currentParentLeft = 0.0
    let currentParentTop = 0.0
    let currentParentRight = currentParentWidth
    let currentParentBottom = currentParentHeight
    
    let currentParentCenterX = currentParentWidth / 2.0 + currentParentLeft
    let currentParentCenterY = currentParentHeight / 2.0 + currentParentTop
    
    let componentDistanceFromCXToCX = abs(componentCenterX - currentParentCenterX)
    let componentDistanceFromCXToLeft = abs(componentCenterX - currentParentLeft)
    let componentDistanceFromCXToRight = abs(componentCenterX - currentParentRight)
    
    let componentDistanceFromCYToCY = abs(componentCenterY - currentParentCenterY)
    let componentDistanceFromCYToTop = abs(componentCenterY - currentParentTop)
    let componentDistanceFromCYToBottom = abs(componentCenterY - currentParentBottom)
    
    let componentDistanceFromLeftToLeft = abs(componentLeft - currentParentLeft)
    let componentDistanceFromLeftToCX = abs(componentLeft - currentParentCenterX)
    
    let componentDistanceFromTopToTop = abs(componentTop - currentParentTop)
    let componentDistanceFromTopToCY = abs(componentTop - currentParentCenterY)
    
    let componentDistanceFromRightToRight = abs(componentRight - currentParentRight)
    let componentDistanceFromRightToCX = abs(componentRight - currentParentCenterX)
    
    let componentDistanceFromBottomToBottom = abs(componentBottom - currentParentBottom)
    let componentDistanceFromBottomToCY = abs(componentBottom - currentParentCenterY)
    
    let parentRatioX = newParentWidth / currentParentWidth
    let parentRatioY = newParentHeight / currentParentHeight
    
    let newComponentX = componentX * parentRatioX
    let newComponentY = componentY * parentRatioY
    
    let newComponentWidth = componentAvailableWidth * parentRatioX
    let newComponentHeight = componentAvailableHeight * parentRatioY
    
    let proportionalW = componentWidth * parentRatioX
    let proportionalH = componentHeight * parentRatioY
    
    let fitDim = getResizeDim(requiredWidth: CGFloat(componentWidth), requiredHeight: CGFloat(componentHeight), availableWidth: CGFloat(newComponentWidth), availableHeight: CGFloat(newComponentHeight))
    
    var newComponentFinalW = proportionalW
    var newComponentFinalH = proportionalH
    if proportionalW > newComponentWidth || proportionalH > newComponentHeight {
        newComponentFinalW = fitDim.width
        newComponentFinalH = fitDim.height
    }
    
    let changeRatioInComponentWidth = newComponentFinalW / componentWidth
    let changeRatioInComponentHeight = newComponentFinalH / componentHeight
    
    var newComponentFinalX = newComponentX
    var newComponentFinalY = newComponentY
    
    let minDistanceX = min(componentDistanceFromLeftToLeft, min(componentDistanceFromRightToRight, min(componentDistanceFromCXToCX, min(componentDistanceFromLeftToCX, min(componentDistanceFromCXToLeft, min(componentDistanceFromCXToRight, componentDistanceFromRightToCX))))))
    let minDistanceY = min(componentDistanceFromTopToTop, min(componentDistanceFromBottomToBottom, min(componentDistanceFromCYToCY, min(componentDistanceFromTopToCY, min(componentDistanceFromCYToTop, min(componentDistanceFromCYToBottom, componentDistanceFromBottomToCY))))))
    
    if componentDistanceFromLeftToLeft == minDistanceX {
        newComponentFinalX = currentParentLeft + ((componentX - currentParentLeft) * changeRatioInComponentWidth)
    } else if componentDistanceFromRightToRight == minDistanceX {
        newComponentFinalX = newParentWidth - newComponentFinalW + (((componentX + componentWidth) - currentParentRight) * changeRatioInComponentWidth)
    } else if componentDistanceFromCXToCX == minDistanceX {
        newComponentFinalX = newParentWidth / 2.0 - newComponentFinalW / 2.0 + ((componentCenterX - currentParentCenterX) * changeRatioInComponentWidth)
    } else if componentDistanceFromLeftToCX == minDistanceX {
        newComponentFinalX = newParentWidth / 2.0 + ((componentX - currentParentCenterX) * changeRatioInComponentWidth)
    } else if componentDistanceFromCXToLeft == minDistanceX {
        newComponentFinalX = currentParentLeft - newComponentFinalW / 2.0 + ((componentCenterX - currentParentLeft) * changeRatioInComponentWidth)
    } else if componentDistanceFromRightToCX == minDistanceX {
        newComponentFinalX = newParentWidth / 2.0 - newComponentFinalW + (((componentX + componentWidth) - currentParentCenterX) * changeRatioInComponentWidth)
    } else if componentDistanceFromCXToRight == minDistanceX {
        newComponentFinalX = newParentWidth - newComponentFinalW / 2.0 + ((componentCenterX - currentParentRight) * changeRatioInComponentWidth)
    }
    
    if componentDistanceFromTopToTop == minDistanceY {
        newComponentFinalY = currentParentTop + ((componentY - currentParentTop) * changeRatioInComponentHeight)
    } else if componentDistanceFromBottomToBottom == minDistanceY {
        newComponentFinalY = newParentHeight - newComponentFinalH + (((componentY + componentHeight) - currentParentBottom) * changeRatioInComponentHeight)
    } else if componentDistanceFromCYToCY == minDistanceY {
        newComponentFinalY = newParentHeight / 2.0 - newComponentFinalH / 2.0 + ((componentCenterY - currentParentCenterY) * changeRatioInComponentHeight)
    } else if componentDistanceFromTopToCY == minDistanceY {
        newComponentFinalY = newParentHeight / 2.0 + ((componentY - currentParentCenterY) * changeRatioInComponentHeight)
    } else if componentDistanceFromCYToTop == minDistanceY {
        newComponentFinalY = currentParentTop - newComponentFinalH / 2.0 + ((componentCenterY - currentParentTop) * changeRatioInComponentHeight)
    } else if componentDistanceFromBottomToCY == minDistanceY {
        newComponentFinalY = newParentHeight / 2.0 - newComponentFinalH + (((componentY + componentHeight) - currentParentCenterY) * changeRatioInComponentHeight)
    } else if componentDistanceFromCYToBottom == minDistanceY {
        newComponentFinalY = newParentHeight - newComponentFinalH / 2.0 + ((componentCenterY - currentParentBottom) * changeRatioInComponentHeight)
    }
    
    if componentAvailableWidth < 0 || componentAvailableHeight < 0 || newComponentWidth < 0 || newComponentHeight < 0 ||
        newComponentFinalW < 0 || newComponentFinalH < 0 || newComponentFinalX < 0 || newComponentFinalY < 0 {
        print("[preAvailbaleSize changes] calculateComponentPositionProportional negative sizes: " +
              "componentAvailableWidth=\(componentAvailableWidth), componentAvailableHeight=\(componentAvailableHeight), " +
              "newComponentWidth=\(newComponentWidth), newComponentHeight=\(newComponentHeight), " +
              "newComponentFinalW=\(newComponentFinalW), newComponentFinalH=\(newComponentFinalH), " +
              "newComponentFinalX=\(newComponentFinalX), newComponentFinalY=\(newComponentFinalY)")
    }
    
    return [newComponentFinalX, newComponentFinalY, newComponentFinalW, newComponentFinalH, newComponentWidth, newComponentHeight]
}

func getResizeDim(requiredWidth: CGFloat, requiredHeight: CGFloat, availableWidth: CGFloat, availableHeight: CGFloat) -> CGSize {
    let ratio = requiredWidth / requiredHeight

    let newWidth1 = availableWidth
    let newHeight1 = availableWidth / ratio

    let newWidth2 = availableHeight * ratio
    let newHeight2 = availableHeight

    if newWidth1 <= availableWidth && newHeight1 <= availableHeight {
        // This means image has scaled in Y direction adjust the Y accordingly
        return CGSize(width: newWidth1, height: newHeight1)
    } else if newWidth2 <= availableWidth && newHeight2 <= availableHeight {
        // This means the image has scaled in X direction adjust the X accordingly
        return CGSize(width: newWidth2, height: newHeight2)
    }
    return CGSize(width: 0, height: 0)
}



func getProptionalMargin(oldSize : CGSize , newSize : CGSize, widthMargin : CGFloat, heightMargin : CGFloat) -> (widthMargin : CGFloat, heightMargin : CGFloat){
    
    let valueOfWidthMargin = ((oldSize.width * widthMargin) / 100 )
    let valueOfHeightMargin = ((oldSize.height * heightMargin) / 100 )
    let newWidth = oldSize.width + valueOfWidthMargin
    let newHeight = oldSize.height + valueOfHeightMargin
    let newWidthMargin = ((widthMargin * 100 * 4) / newWidth )
    let newHeightMargin = ((heightMargin * 100 * 2) / newHeight )
    
    return (widthMargin : newWidthMargin, heightMargin : newHeightMargin)
}
