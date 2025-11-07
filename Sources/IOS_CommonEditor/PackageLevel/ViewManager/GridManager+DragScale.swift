//
//  GridManager+DragScale.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/07/24.
//


import Foundation
import UIKit

extension GridManager{
    func manageAdvanceGridLinesForDragScale(currentViewCenter: CGPoint, currentViewSize: CGSize){
        if checkStateForMinXDragScale(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
           print("69 MinX Checked")
        }
       else if checkStateForMaxXDragScale(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
            print("69 MaxX Checked")
        }
//        else if checkStateForCenterXDragScale(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
//            print("69 CenterX Checked")
//        }

//
        
       else if checkStateForMinYDragScale(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize) {
            print("69 MinY Checked")
        }
       else if checkStateForMaxYDragScale(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
            print("69 MaxY Checked")
        }
//
//       else if checkStateForCenterYDragScale(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
//            print("69 CenterY Checked")
//        }


        else {
            if gestureMode == .scale{
                var baseFrame = templateHandler.currentModel!.baseFrame
                baseFrame.size = CGSize(width: currentViewSize.width, height: currentViewSize.height)
                templateHandler.currentModel?.baseFrame = baseFrame
            }
            
            else if gestureMode == .dragScale{
                var baseFrame = templateHandler.currentModel!.baseFrame
                baseFrame.size = CGSize(width: currentViewSize.width, height: currentViewSize.height)
                baseFrame.center = currentViewCenter
                templateHandler.currentModel?.baseFrame = baseFrame
            }
        }
        
        setNeedsDisplay()
    }
    
   //MARK: For X Checking
    func checkStateForMinXDragScale(currentViewCenter : CGPoint, currentViewSize : CGSize)-> Bool{
        for point in minXArray{
            if advancedLineMinXFrame.contains(point.value){
                advancedMinXLine = true
                if templateHandler.selectedNearestSnappingChildID == point.key { return false}
                templateHandler.selectedNearestSnappingChildID = point.key
                print("22 MinX Contains By MinXFrame \(advancedLineMinXFrame)\(currentViewCenter)\(point)")
                if !advancedMinXLineState
                {
                    triggerVibration()
                     if gestureMode == .scale{
                         let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minX, actualSnapSideType: .minX)
                         scaleCurrentSelectedView(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minX, actualSnapSideType: .minX)
                        setDragScaleNCenter(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    advancedMinXLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in maxXArray{
            if advancedLineMinXFrame.contains(point.value){
                advancedMinXLine = true
                if templateHandler.selectedNearestSnappingChildID == point.key { return false}
                templateHandler.selectedNearestSnappingChildID = point.key
                if !advancedMinXLineState
                {
                    triggerVibration()
                     if gestureMode == .scale{
                         let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxX, actualSnapSideType: .minX)
                         scaleCurrentSelectedView(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxX, actualSnapSideType: .minX)
                        setDragScaleNCenter(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    print("22 Center Contains By MaxXFrame")
                    advancedMinXLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in centerXArray{
            if advancedLineMinXFrame.contains(point.value){
                advancedMinXLine = true
                if templateHandler.selectedNearestSnappingChildID == point.key { return false}
                templateHandler.selectedNearestSnappingChildID = point.key
                if !advancedMinXLineState
                {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerX, actualSnapSideType: .centerX)
                        scaleCurrentSelectedView(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{

                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerX, actualSnapSideType: .centerX)
                        setDragScaleNCenter(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    print("22 Center Contains By MaxXFrame")
                    advancedMinXLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }
        
        advancedMinXLine = false
        advancedMinXLineState = false
        return false
    }


    func checkStateForMaxXDragScale(currentViewCenter : CGPoint, currentViewSize : CGSize)-> Bool{
        for point in minXArray{
            if advancedLineMaxXFrame.contains(point.value){
                advancedMaxXLine = true
                if templateHandler.selectedNearestSnappingChildID == point.key { return false}
                templateHandler.selectedNearestSnappingChildID = point.key
                print("23 MaxX Contains By MinXFrame")
                if !advancedMaxXLineState
                {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minX, actualSnapSideType: .maxX)
                        scaleCurrentSelectedView(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minX, actualSnapSideType: .maxX)
                        setDragScaleNCenter(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    advancedMaxXLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in maxXArray{
            if advancedLineMaxXFrame.contains(point.value){
                print("23 MaxX Contains By MaxXFrame")
                advancedMaxXLine = true
                if templateHandler.selectedNearestSnappingChildID == point.key { return false}
                templateHandler.selectedNearestSnappingChildID = point.key
                if !advancedMaxXLineState
                {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxX, actualSnapSideType: .maxX)
                        scaleCurrentSelectedView(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxX, actualSnapSideType: .maxX)
                        setDragScaleNCenter(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    advancedMaxXLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }
        
        
        for point in centerXArray{
            if advancedLineMaxXFrame.contains(point.value){
                advancedMaxXLine = true
                if templateHandler.selectedNearestSnappingChildID == point.key { return false}
                templateHandler.selectedNearestSnappingChildID = point.key
                print("23 MaxX Contains By CenterX")
                if !advancedMaxXLineState
                {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerX, actualSnapSideType: .centerX)
                        scaleCurrentSelectedView(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerX, actualSnapSideType: .centerX)
                        setDragScaleNCenter(sizeType: .width, snapDistanceType: snapDistanceType)
                    }
                    advancedMaxXLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }
        
        advancedMaxXLine = false
        advancedMaxXLineState = false
        return false
    }

    func checkStateForCenterXDragScale(currentViewCenter : CGPoint, currentViewSize : CGSize) -> Bool{
        for point in minXArray{
            if advancedLineCenterXFrame.contains(point.value){
                advancedCenterXLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("24 CenterX Contains By MinXFrame")
                if !advancedCenterXLineState{
                    triggerVibration()
                    if gestureMode == .scale{
                      //  scaleCurrentSelectedView(sizeType: .width)
                    }
                    else if gestureMode == .dragScale{
                       // setDragScaleNCenter(sizeType: .width)
                    }
                    advancedCenterXLineState = true
                }
                return true
            }
        }

        for point in maxXArray{
            if advancedLineCenterXFrame.contains(point.value){
                advancedCenterXLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("24 CenterX Contains By MaxXFrame")
                if !advancedCenterXLineState{
                    triggerVibration()
                    if gestureMode == .scale{
                       // scaleCurrentSelectedView(sizeType: .width)
                    }
                    else if gestureMode == .dragScale{
                      //  setDragScaleNCenter(sizeType: .width)
                    }
                    advancedCenterXLineState = true
                }
                return true
            }
        }

        for point in centerXArray{
            if advancedLineCenterXFrame.contains(point.value){
                advancedCenterXLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("24 CenterX Contains By CenterXFrame")
                if !advancedCenterXLineState{
                    triggerVibration()
                    if gestureMode == .scale{
                      //  scaleCurrentSelectedView(sizeType: .width)
                    }
                    else if gestureMode == .dragScale{
                     //   setDragScaleNCenter(sizeType: .width)
                    }
                    advancedCenterXLineState = true
                }
                return true
            }
        }

        advancedCenterXLine = false
        advancedCenterXLineState = false
        return false
    }





   //MARK: For Y Checking
    func checkStateForMinYDragScale(currentViewCenter : CGPoint, currentViewSize : CGSize) -> Bool{
        for point in minYArray{
            if advancedLineMinYFrame.contains(point.value){
                advancedMinYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                
                
                print("25 MinY Contains By MinYFrame")
                if !advancedMinYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minY, actualSnapSideType: .minY)
                        scaleCurrentSelectedView(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minY, actualSnapSideType: .minY)
                        setDragScaleNCenter(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    advancedMinYLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in maxYArray{
            if advancedLineMinYFrame.contains(point.value){
                advancedMinYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("25 MinY Contains By MaxYFrame")
                if !advancedMinYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxY, actualSnapSideType: .minY)
                        scaleCurrentSelectedView(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxY, actualSnapSideType: .minY)
                        setDragScaleNCenter(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    advancedMinYLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in centerYArray{
            if advancedLineMinYFrame.contains(point.value){
                advancedMinYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("25 MinY Contains By CenterYFrame")
                if !advancedMinYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerY, actualSnapSideType: .centerY)
                        scaleCurrentSelectedView(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerY, actualSnapSideType: .centerY)
                        setDragScaleNCenter(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    advancedMinYLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        advancedMinYLine = false
        advancedMinYLineState = false
        return false
    }


    func checkStateForMaxYDragScale(currentViewCenter : CGPoint, currentViewSize: CGSize) -> Bool{
        for point in minYArray{
            if advancedLineMaxYFrame.contains(point.value){
                advancedMaxYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("26 MaxY Contains By MinYFrame")
                if !advancedMaxYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minY, actualSnapSideType: .maxY)
                        scaleCurrentSelectedView(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .minY, actualSnapSideType: .maxY)
                        setDragScaleNCenter(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    advancedMaxYLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in maxYArray{
            if advancedLineMaxYFrame.contains(point.value){
                advancedMaxYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("26 MaxY Contains By MaxYFrame")
                if !advancedMaxYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxY, actualSnapSideType: .maxY)
                        scaleCurrentSelectedView(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .maxY, actualSnapSideType: .maxY)
                        setDragScaleNCenter(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    advancedMaxYLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        for point in centerYArray{
            if advancedLineMaxYFrame.contains(point.value){
                advancedMaxYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("26 MaxY Contains By CenterYFrame")
                if !advancedMaxYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerY, actualSnapSideType: .centerY)
                        scaleCurrentSelectedView(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    else if gestureMode == .dragScale{
                        let snapDistanceType = getSnapDistanceType(nearestChildID: point.key, nearestSnapSideType: .centerY, actualSnapSideType: .centerY)
                        setDragScaleNCenter(sizeType: .height, snapDistanceType: snapDistanceType)
                    }
                    advancedMaxYLineState = true
                }
//                else {
//                    return false
//                }
                return true
            }
        }

        advancedMaxYLine = false
        advancedMaxYLineState = false
        return false
    }

    func checkStateForCenterYDragScale(currentViewCenter : CGPoint, currentViewSize : CGSize) -> Bool{
        for point in minYArray{
            if advancedLineCenterYFrame.contains(point.value){
                advancedCenterYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("27 CenterY Contains By MinYFrame")
                if !advancedCenterYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                      //  scaleCurrentSelectedView(sizeType: .height)
                    }
                    else if gestureMode == .dragScale{
                       // setDragScaleNCenter(sizeType: .height)
                    }
                    advancedCenterYLineState = false
                }
                return true
            }
        }

        for point in maxYArray{
            if advancedLineCenterYFrame.contains(point.value){
                advancedCenterYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("27 CenterY Contains By MaxYFrame")
                if !advancedCenterYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                      //  scaleCurrentSelectedView(sizeType: .height)
                    }
                    else if gestureMode == .dragScale{
                     //   setDragScaleNCenter(sizeType: .height)
                    }
                    advancedCenterYLineState = false
                }
                return true
            }
        }

        for point in centerYArray{
            if advancedLineCenterYFrame.contains(point.value){
                advancedCenterYLine = true
                templateHandler.selectedNearestSnappingChildID = point.key
                print("27 CenterY Contains By CenterYFrame")
                if !advancedCenterYLineState {
                    triggerVibration()
                    if gestureMode == .scale{
                       // scaleCurrentSelectedView(sizeType: .height)
                    }
                    else if gestureMode == .dragScale{
                       // setDragScaleNCenter(sizeType: .height)
                    }
                    advancedCenterYLineState = false
                }
                return true
            }
        }

        advancedCenterYLine = false
        advancedCenterYLineState = true
        return false
    }
    
    
    func getSnapDistanceType(nearestChildID : Int, nearestSnapSideType : SnapSideType, actualSnapSideType : SnapSideType) -> SnapDistanceType{
        let nearestChildModel = templateHandler.getModel(modelId: nearestChildID)!
        let selectedModel = templateHandler.currentModel!
        //For Selected model
        let selectedModelWidth = selectedModel.baseFrame.size.width
        let selectedModelHeight = selectedModel.baseFrame.size.height
        let selectedModelCenterX = selectedModel.baseFrame.center.x
        let selectedModelCenterY = selectedModel.baseFrame.center.y
        
        //For Nearest Model
        let nearestModelWidth = nearestChildModel.baseFrame.size.width
        let nearestModelHeight = nearestChildModel.baseFrame.size.height
        let nearestModelCenterX = nearestChildModel.baseFrame.center.x
        let nearestModelCenterY = nearestChildModel.baseFrame.center.y
        
        if nearestSnapSideType == .minX && actualSnapSideType == .maxX{
            let nearestChildMinX = nearestModelCenterX - nearestModelWidth/2
            let selectedChildMaxX = selectedModelCenterX + selectedModelWidth/2
            if nearestChildMinX > selectedChildMaxX{
                return .max
            }
            else{
                return .min
            }
        }
        
        if nearestSnapSideType == .maxX && actualSnapSideType == .maxX{
            let nearestChildMaxX = nearestModelCenterX + nearestModelWidth/2
            let selectedChildMaxX = selectedModelCenterX + selectedModelWidth/2
            if nearestChildMaxX > selectedChildMaxX{
                return .max
            }
            else{
                return .min
            }
        }
        
        else if nearestSnapSideType == .minX && actualSnapSideType == .minX{
            let nearestChildMinX = nearestModelCenterX - nearestModelWidth/2
            let selectedChildMinX = selectedModelCenterX - selectedModelWidth/2
            if nearestChildMinX > selectedChildMinX{
                return .max
            }
            else{
                return .min
            }
        }
        
       else if nearestSnapSideType == .maxX && actualSnapSideType == .minX{
            let nearestChildMaxX = nearestModelCenterX + nearestModelWidth/2
            let selectedChildMinX = selectedModelCenterX - selectedModelWidth/2
            if nearestChildMaxX > selectedChildMinX{
                return .max
            }
            else{
                return .min
            }
        }
        
      else if nearestSnapSideType == .maxX && actualSnapSideType == .minX{
            let nearestChildMaxX = nearestModelCenterX + nearestModelWidth/2
            let selectedChildMinX = selectedModelCenterX - selectedModelWidth/2
            if nearestChildMaxX > selectedChildMinX{
                return .max
            }
            else{
                return .min
            }
        }
        

        
        
       else if nearestSnapSideType == .minY && actualSnapSideType == .maxY{
            let nearestChildMinY = nearestModelCenterY - nearestModelHeight/2
            let selectedChildMaxY = selectedModelCenterY + selectedModelHeight/2
            if nearestChildMinY > selectedChildMaxY{
                return .max
            }
            else{
                return .min
            }
        }
        
      else  if nearestSnapSideType == .maxY && actualSnapSideType == .maxY{
            let nearestChildMaxY = nearestModelCenterY + nearestModelHeight/2
            let selectedChildMaxY = selectedModelCenterY + selectedModelHeight/2
            if nearestChildMaxY > selectedChildMaxY{
                return .max
            }
            else{
                return .min
            }
        }
        
      else  if nearestSnapSideType == .minY && actualSnapSideType == .minY{
            let nearestChildMinY = nearestModelCenterY - nearestModelHeight/2
            let selectedChildMinY = selectedModelCenterY - selectedModelHeight/2
            if nearestChildMinY > selectedChildMinY{
                return .max
            }
            else{
                return .min
            }
        }
        
      else  if nearestSnapSideType == .maxY && actualSnapSideType == .minY{
            let nearestChildMaxY = nearestModelCenterY + nearestModelHeight/2
            let selectedChildMinY = selectedModelCenterY - selectedModelHeight/2
            if nearestChildMaxY > selectedChildMinY{
                return .max
            }
            else{
                return .min
            }
        }
        return .max
    }
}
