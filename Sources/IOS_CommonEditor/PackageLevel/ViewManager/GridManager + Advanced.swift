//
//  GridManager + Advanced.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 27/04/24.
//

import Foundation
import UIKit

enum SizeType{
    case width
    case height
}

enum SnapDistanceType{
    case min
    case max
}

enum SnapSideType{
    case minX
    case maxX
    case minY
    case maxY
    case centerX
    case centerY
}

extension GridManager{
    
    // Advanced Line Frame for MaxX.
    var advancedLineMinXFrameDraw : CGRect {
        return CGRect(x: templateRotatedRect.origin.x - snapBreath, y: 0 , width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    // Advanced Line Frame for MaxX.
    var advancedLineMaxXFrameDraw : CGRect {
        return CGRect(x: Double(templateRotatedRect.width/2) + templateRotatedRect.midX  - snapBreath, y: 0, width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    // Advanced Line Frame for CenterX.
    var advancedLineCenterXFrameDraw : CGRect {
        return CGRect(x: 0, y: templateRotatedRect.midY - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    // Advanced Line Frame for MinY.
    var advancedLineMinYFrameDraw : CGRect {
        return CGRect(x: 0, y: (templateRotatedRect.origin.y) - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    // Advanced Line Frame for MaxY.
    var advancedLineMaxYFrameDraw : CGRect {
        return CGRect(x: 0, y: Double(templateRotatedRect.height)/2 + templateRotatedRect.midY - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    // Advanced Line Frame for CenterY.
    var advancedLineCenterYFrameDraw : CGRect {
        return CGRect(x: templateRotatedRect.midX - snapBreath, y: 0, width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    // Advanced Line Frame for MinY.
    var advancedLineMinXFrame : CGRect {
        return CGRect(x: rotatedRectForCurrentView.origin.x - snapBreath, y: 0 , width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    // Advanced Line Frame for MaxY.
    var advancedLineMaxXFrame : CGRect {
        return  CGRect(x: Double(rotatedRectForCurrentView.width/2) + rotatedRectForCurrentView.midX  - snapBreath, y: 0, width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    // Advanced Line Frame for CenterX.
    var advancedLineCenterXFrame : CGRect {
        return  CGRect(x: 0, y: rotatedRectForCurrentView.midY - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    // Advanced Line Frame for MinY.
    var advancedLineMinYFrame : CGRect {
        return CGRect(x: 0, y: (rotatedRectForCurrentView.origin.y) - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    // Advanced Line Frame for MaxY.
    var advancedLineMaxYFrame : CGRect {
        return CGRect(x: 0, y: Double(rotatedRectForCurrentView.height)/2 + rotatedRectForCurrentView.midY - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    // Advanced Line Frame for CenterY.
    var advancedLineCenterYFrame : CGRect {
        return CGRect(x: rotatedRectForCurrentView.midX - snapBreath, y: 0, width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    
    //MARK: Advanced Line Drawing Logic Starts From here.
    func drawAdvancedLine(context : CGContext){
        if advancedMinXLine{
            drawAdvancedMinXLine(context: context)
        }
        else if advancedMaxXLine{
            drawAdvancedMaxXLine(context: context)
        }
        else if advancedCenterXLine{
            drawAdvancedCenterXLine(context: context)
        }
        if advancedMinYLine{
            drawAdvancedMinYLine(context: context)
        }
        else if advancedMaxYLine{
            drawAdvancedMaxYLine(context: context)
        }
        else if advancedCenterYLine{
            drawAdvancedCenterYLine(context: context)
        }
    }
    
    //MARK: - Drawing Advanced Line .
    func drawAdvancedMinXLine(context : CGContext){
        // Set the line color to yellow
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
         context.move(to: CGPoint(x: advancedLineMinXFrameDraw.origin.x + advancedLineMinXFrameDraw.width/2, y: advancedLineMinXFrameDraw.origin.y))
         // Add a line to the end point of the line
         context.addLine(to: CGPoint(x: advancedLineMinXFrameDraw.origin.x + advancedLineMinXFrameDraw.width/2, y: advancedLineMinXFrameDraw.height))
         // Draw the line
         context.strokePath()
    }
    
    func drawAdvancedMaxXLine(context : CGContext){
        // Set the line color to yellow
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: advancedLineMaxXFrameDraw.origin.x + advancedLineMaxXFrameDraw.width/2, y: advancedLineMaxXFrameDraw.origin.y))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: advancedLineMaxXFrameDraw.origin.x + advancedLineMaxXFrameDraw.width/2, y: advancedLineMaxXFrameDraw.height))
         // Draw the line
         context.strokePath()
    }
    
    func drawAdvancedCenterXLine(context : CGContext){
        // Set the line color to yellow
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: advancedLineCenterXFrameDraw.origin.x, y: advancedLineCenterXFrameDraw.origin.y))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: advancedLineCenterXFrameDraw.width, y: advancedLineCenterXFrameDraw.origin.y))
         // Draw the line
         context.strokePath()
    }
    
    func drawAdvancedMinYLine(context : CGContext){
        // Set the line color to yellow
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
         context.move(to: CGPoint(x: advancedLineMinYFrameDraw.origin.x, y: advancedLineMinYFrameDraw.origin.y + advancedLineMinYFrameDraw.height/2))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: advancedLineMinYFrameDraw.size.width, y: advancedLineMinYFrameDraw.origin.y + advancedLineMinYFrameDraw.height/2))
         // Draw the line
         context.strokePath()
    }
    
    func drawAdvancedMaxYLine(context : CGContext){
        // Set the line color to yellow
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: advancedLineMaxYFrameDraw.origin.x, y: advancedLineMaxYFrameDraw.origin.y + advancedLineMaxYFrameDraw.height/2))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: advancedLineMaxYFrameDraw.size.width, y: advancedLineMaxYFrameDraw.origin.y + advancedLineMaxYFrameDraw.height/2))
         // Draw the line
         context.strokePath()
    }
    
    func drawAdvancedCenterYLine(context : CGContext){
        // Set the line color to yellow
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: advancedLineCenterYFrameDraw.origin.x, y: advancedLineCenterYFrameDraw.origin.y))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: advancedLineCenterYFrameDraw.origin.x, y: advancedLineCenterYFrameDraw.height))
         // Draw the line
         context.strokePath()
    }
    //MARK: - Advanced Line Drawing End.
    
    
    
    func manageState(){
        advancedMinXLine = false
        advancedMaxXLine = false
        advancedCenterXLine = false
        
        advancedMinYLine = false
        advancedMaxYLine = false
        advancedCenterYLine = false
    }
    
    func manageAdvanceGridLines(currentViewCenter: CGPoint, currentViewSize: CGSize){
        if checkStateForMinX(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
           print("MinX Checked")
        }
        else if checkStateForMaxX(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
            print("MaxX Checked")
        }
        else if checkStateForCenterX(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
            print("CenterX Checked")
        }
        if checkStateForMinY(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize) {
            print("MinY Checked")
        }
       else if checkStateForMaxY(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
            print("MaxY Checked")
        }
        
        else if checkStateForCenterY(currentViewCenter: currentViewCenter, currentViewSize: currentViewSize){
            print("CenterY Checked")
        }

        var closestChild = getClosestChild(closestChildDict: closestChildDict)
        
        
        // In your main code, replace the call to getClosestChild with:
        let (xSnapData, ySnapData) = getClosestChildMinXAndMinY(closestChildDict: closestChildDict)
        print("Snapped Data \(xSnapData) \(ySnapData)")

        print("Closest Child \(closestChild)")
        print("Nearby Child : \(closestChildDict)")
        if gestureMode == .move{
//            if let closestChild = closestChild{
//                updateFrameForSelectedViewForMove(snapData: closestChild)
//            }
//            else{
//                templateHandler.currentModel?.baseFrame.center = newCenter
//            }
//            
            if let xSnapData = xSnapData{
                updateFrameForSelectedViewForMove(snapData: xSnapData)
            }
            
            if let ySnapData = ySnapData{
                updateFrameForSelectedViewForMove(snapData: ySnapData)
            }
            
            if xSnapData == nil && ySnapData == nil{
                templateHandler.currentModel?.baseFrame.center = newCenter
            }
            
//            if let closestChildInY = closestChildInY{
//                updateFrameForSelectedViewForMove(snapData: closestChildInY)
//            }
        }
//        else if gestureMode == .scale{
//            if let closestChild = closestChild {
//                updateFrameForSelectedViewForScale(snapData: closestChild)
//            }
//            else{
//                manageState()
//                templateHandler.currentModel?.baseFrame.size = currentViewSize
//            }
//        }
        
//        else if gestureMode == .dragScale{
//            setDragScaleNCenter()
//            if let closestChild = closestChild , snapIDNData?.modelID != closestChild.modelID{
//                updateFrameForSelectedViewForDragScale(snapData: closestChild)
//            }
//            else{
//                manageState()
//                templateHandler.currentModel?.baseFrame = Frame(size: currentViewSize, center: currentViewCenter, rotation: templateHandler.currentModel!.baseFrame.rotation)
//            }
//        }
    }
    
   //MARK: For X Checking
    func checkStateForMinX(currentViewCenter : CGPoint, currentViewSize : CGSize)-> Bool{
        for point in minXArray{
            if advancedLineMinXFrame.contains(point.value){
                print("HEYNEESHU : MINX FROM MINX \(advancedLineMinXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MinX, childState: .MinX, modelID: point.key)
                return true
            }
        }
        
        for point in maxXArray{
            if advancedLineMinXFrame.contains(point.value){
                print("HEYNEESHU : MAXX FROM MINX \(advancedLineMinXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MinX, childState: .MaxX, modelID: point.key)
                return true
            }
        }
        
        for point in centerXArray{
            if advancedLineMinXFrame.contains(point.value){
                print("HEYNEESHU : CENTERX FROM MINX \(advancedLineMinXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MinX, childState: .CenterX, modelID: point.key)
                return true
            }
        }
        advancedMinXLine = false
        advancedMinXLineState = false
        return false
    }
    
    
    func checkStateForMaxX(currentViewCenter : CGPoint, currentViewSize : CGSize)-> Bool{
        for point in minXArray{
            if advancedLineMaxXFrame.contains(point.value){
                print("HEYNEESHU : MINX FROM MAXX \(advancedLineMaxXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MaxX, childState: .MinX, modelID: point.key)
                return true
            }
        }
        
        for point in maxXArray{
            if advancedLineMaxXFrame.contains(point.value){
                print("HEYNEESHU : MAXX FROM MAXX \(advancedLineMaxXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MaxX, childState: .MaxX, modelID: point.key)
                return true
            }
        }
        
        for point in centerXArray{
            if advancedLineMaxXFrame.contains(point.value){
                print("HEYNEESHU : CENTERX FROM MAXX \(advancedLineMaxXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MaxX, childState: .CenterX, modelID: point.key)
                return true
            }
        }
        
        advancedMaxXLine = false
        advancedMaxXLineState = false
        return false
    }
    
    func checkStateForCenterX(currentViewCenter : CGPoint, currentViewSize : CGSize) -> Bool{
        for point in minXArray{
            if advancedLineCenterXFrame.contains(point.value){
                print("HEYNEESHU : MINX FROM CENTERX \(advancedLineCenterXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .CenterY, childState: .MinX, modelID: point.key)
                return true
            }
        }
        
        for point in maxXArray{
            if advancedLineCenterXFrame.contains(point.value){
                print("HEYNEESHU : MAXX FROM CENTERX \(advancedLineCenterXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .CenterY, childState: .MaxX, modelID: point.key)
                return true
            }
        }
        
        for point in centerXArray{
            if advancedLineCenterXFrame.contains(point.value){
                print("HEYNEESHU : CENTERX FROM CENTERX \(advancedLineCenterXFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .CenterY, childState: .CenterY, modelID: point.key)
                return true
            }
        }
        
        advancedCenterXLine = false
        advancedCenterXLineState = false
        return false
    }
    
    
    
    
    
   //MARK: For Y Checking
    func checkStateForMinY(currentViewCenter : CGPoint, currentViewSize : CGSize) -> Bool{
        for point in minYArray{
            if advancedLineMinYFrame.contains(point.value){
                print("HEYNEESHU : MINY FROM MINY \(advancedLineMinYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MinY, childState: .MinY, modelID: point.key)
                return true
            }
        }
        
        for point in maxYArray{
            if advancedLineMinYFrame.contains(point.value){
                print("HEYNEESHU : MAXY FROM MINY \(advancedLineMinYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MinY, childState: .MaxY, modelID: point.key)
                return true
            }
        }
        
        for point in centerYArray{
            if advancedLineMinYFrame.contains(point.value){
                print("HEYNEESHU : CENTERY FROM MINY \(advancedLineMinYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MinY, childState: .CenterY, modelID: point.key)
                return true
            }
        }
        
        advancedMinYLine = false
        advancedMinYLineState = true
        return false
    }
    
    
    func checkStateForMaxY(currentViewCenter : CGPoint, currentViewSize: CGSize) -> Bool{
        for point in minYArray{
            if advancedLineMaxYFrame.contains(point.value){
                print("HEYNEESHU : MINY FROM MAXY \(advancedLineMaxYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MaxY, childState: .MinY, modelID: point.key)
                return true
            }
        }
        
        for point in maxYArray{
            if advancedLineMaxYFrame.contains(point.value){
                print("HEYNEESHU : MAXY FROM MAXY \(advancedLineMaxYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MaxY, childState: .MaxY, modelID: point.key)
                return true
            }
        }
        
        for point in centerYArray{
            if advancedLineMaxYFrame.contains(point.value){
                print("HEYNEESHU : CENTERY FROM MAXY \(advancedLineMaxYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .MaxY, childState: .CenterY, modelID: point.key)
                return true
            }
        }
        
        advancedMaxYLine = false
        advancedMaxYLineState = true
        return false
    }
    
    func checkStateForCenterY(currentViewCenter : CGPoint, currentViewSize : CGSize) -> Bool{
        for point in minYArray{
            if advancedLineCenterYFrame.contains(point.value){
                print("HEYNEESHU : MINY FROM CENTERY \(advancedLineCenterYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .CenterX, childState: .MinY, modelID: point.key)
                return true
            }
        }
        
        for point in maxYArray{
            if advancedLineCenterYFrame.contains(point.value){
                print("HEYNEESHU : MAXY FROM CENTERY \(advancedLineCenterYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .CenterX, childState: .MaxY, modelID: point.key)
                return true
            }
        }
        
        for point in centerYArray{
            if advancedLineCenterYFrame.contains(point.value){
                print("HEYNEESHU : CENTERY FROM CENTERY \(advancedLineCenterYFrame)")
                closestChildDict[point.key] = SnappingData(parentState: .CenterX, childState: .CenterX, modelID: point.key)
                return true
            }
        }
        
        advancedCenterYLine = false
        advancedCenterYLineState = true
        return false
    }
    
 //For setting the Scale and Center with Snapping at the time of drag handle.
    func setDragScaleNCenter(sizeType : SizeType, snapDistanceType : SnapDistanceType){
        if sizeType == .width{
            var baseFrame = templateHandler.currentModel!.baseFrame
            var newWidth = currentViewSize.width
            var travelDistanceByX : Double =  snapDistanceType == .min ? -1.5 : 1.5
            if snapDistanceType == .min{
                if currentViewSize.width < (templateHandler.currentModel?.baseFrame.size.width)!{
                    newWidth = newWidth - 1.5
                    travelDistanceByX = -1.5
                }
                else{
                    newWidth = newWidth + 1.5
                    travelDistanceByX = 1.5
                }
            }
            else{
                if currentViewSize.width < (templateHandler.currentModel?.baseFrame.size.width)!{
                    newWidth = newWidth - 1.5
                    travelDistanceByX = -1.5
                }
                else{
                    newWidth = newWidth + 1.5
                    travelDistanceByX = 1.5
                }
            }
            let oldWidth = currentViewSize.width
            let scaleFactor = (newWidth / currentViewSize.width)
            let travelDistanceByY = currentViewSize.height * scaleFactor - currentViewSize.height
            
            let newHeight = (currentViewSize.height * scaleFactor)
            baseFrame.size = CGSize(width: newWidth, height: newHeight)
            let angleInRadian = degreesToRadians(Double(templateHandler.currentModel!.baseFrame.rotation))
            
            let topleftOffSetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let topleftOffSetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let topRigthOffsetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) + (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let topRigthOffsetY = -(Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let bottomLeftOfsetX = -(Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let bottomLeftOfsetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) - (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let bottomRightOffsetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let bottomRightOffsetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            
            var calulatedCenterX : Float = 0.0
            var calulatedCenterY : Float = 0.0
            
            if selectedDragHandle == "topLeft" {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) - Float(topleftOffSetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) - Float(topleftOffSetY)
            } else if selectedDragHandle == "bottomRight" {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) + Float(bottomRightOffsetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) + Float(bottomRightOffsetY)
            } else if selectedDragHandle == "bottomLeft" {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) + Float(bottomLeftOfsetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) - Float(bottomLeftOfsetY)
            } else {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) + Float(topRigthOffsetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) - Float(topRigthOffsetY)
            }
            
            baseFrame.center = CGPoint(x: Double(calulatedCenterX), y: Double(calulatedCenterY))
            templateHandler.currentModel?.baseFrame = baseFrame
        }
        else if sizeType == .height{
            var baseFrame = templateHandler.currentModel!.baseFrame
            var newHeight = currentViewSize.height
            var travelDistanceByY = snapDistanceType == .min ? -1.5 : 1.5
            if snapDistanceType == .min {
                if currentViewSize.height < (templateHandler.currentModel?.baseFrame.size.height)! {
                    newHeight = newHeight - 1.5
                    travelDistanceByY = -1.5
                }
                else {
                    newHeight = newHeight + 1.5
                    travelDistanceByY = 1.5
                }
            }
            else {
                if currentViewSize.height < (templateHandler.currentModel?.baseFrame.size.height)! {
                    newHeight = newHeight - 1.5
                    travelDistanceByY = -1.5
                }
                else {
                    newHeight = newHeight + 1.5
                    travelDistanceByY = 1.5
                }
            }
            let oldHeight = currentViewSize.height
            let scaleFactor = (newHeight / currentViewSize.height)
            let travelDistanceByX = currentViewSize.width * scaleFactor - currentViewSize.width
            
            let newWidth = (currentViewSize.width * scaleFactor)
            baseFrame.size = CGSize(width: newWidth, height: newHeight)
            let angleInRadian = degreesToRadians(Double(templateHandler.currentModel!.baseFrame.rotation))
            
            let topleftOffSetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let topleftOffSetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let topRigthOffsetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) + (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let topRigthOffsetY = -(Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let bottomLeftOfsetX = -(Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let bottomLeftOfsetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) - (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            let bottomRightOffsetX = (Double(travelDistanceByX) / 2) * cos(angleInRadian) - (Double(travelDistanceByY) / 2) * sin(angleInRadian)
            let bottomRightOffsetY = (Double(travelDistanceByX) / 2) * sin(angleInRadian) + (Double(travelDistanceByY) / 2) * cos(angleInRadian)
            
            var calulatedCenterX : Float = 0.0
            var calulatedCenterY : Float = 0.0
            
            if selectedDragHandle == "topLeft" {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) - Float(topleftOffSetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) - Float(topleftOffSetY)
            } else if selectedDragHandle == "bottomRight" {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) + Float(bottomRightOffsetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) + Float(bottomRightOffsetY)
            } else if selectedDragHandle == "bottomLeft" {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) + Float(bottomLeftOfsetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) - Float(bottomLeftOfsetY)
            } else {
                calulatedCenterX = Float(templateHandler.currentModel!.baseFrame.center.x) + Float(topRigthOffsetX)
                calulatedCenterY = Float(templateHandler.currentModel!.baseFrame.center.y) - Float(topRigthOffsetY)
            }
            
            baseFrame.center = CGPoint(x: Double(calulatedCenterX), y: Double(calulatedCenterY))
            templateHandler.currentModel?.baseFrame = baseFrame
        }
    }
//    
    //This method get the ID of Nearest Child and Updated BaseFrame of Selected Child.
    //getClosestChildNFrame(arrayOfAllNearbyChild) -> (ClosestChildID , BaseFrame)
    func getClosestChild(closestChildDict : [Int : SnappingData]) -> SnappingData?{
        var closestDistance : CGFloat = .infinity
        var closestChildData : SnappingData?
        
        // One by One Iterate into the Dictionary.
        for closestChild in closestChildDict{
            //Get the Model using the ID.
            let closestChildModel = templateHandler?.getModel(modelId: closestChild.key)
            //Check the Distance from the selected child.
            let xDirectionDistance = abs(templateHandler.currentModel!.baseFrame.center.x - CGFloat(closestChildModel!.baseFrame.center.x))
            let yDirectionDistance = abs(templateHandler.currentModel!.baseFrame.center.y - CGFloat(closestChildModel!.baseFrame.center.y))
            let distance = sqrt((xDirectionDistance * xDirectionDistance) + (yDirectionDistance * yDirectionDistance)).roundToDecimal(2)
            print("NDD \(distance)")
            if closestDistance > distance{
                closestDistance = distance
                closestChildData = closestChild.value
            }
        }
        
        if let closestChildData = closestChildData{
            snapIDNData = closestChildData
        }
        else{
            snapIDNData = nil
            templateHandler.selectedNearestSnappingChildID = 0
        }
        
        return closestChildData
    }
    
    
    func getClosestChildMinXAndMinY(closestChildDict: [Int: SnappingData]) -> (xSnap: SnappingData?, ySnap: SnappingData?) {
        var closestXDistance: CGFloat = .infinity
        var closestYDistance: CGFloat = .infinity
        var closestXChildData: SnappingData?
        var closestYChildData: SnappingData?
        
        // One by One Iterate into the Dictionary.
        for closestChild in closestChildDict {
            //Get the Model using the ID.
            guard let closestChildModel = templateHandler?.getModel(modelId: closestChild.key),
                  let currentModel = templateHandler.currentModel else { continue }
            
            let snapData = closestChild.value
            
            // Filter and process X-axis snappers
            if snapData.parentState == .MinX || snapData.parentState == .MaxX || snapData.parentState == .CenterX {
                let xDistance = abs(currentModel.baseFrame.center.x - CGFloat(closestChildModel.baseFrame.center.x))
                
                if xDistance < closestXDistance {
                    closestXDistance = xDistance
                    closestXChildData = snapData
                }
            }
            
            // Filter and process Y-axis snappers
            if snapData.parentState == .MinY || snapData.parentState == .MaxY || snapData.parentState == .CenterY {
                let yDistance = abs(currentModel.baseFrame.center.y - CGFloat(closestChildModel.baseFrame.center.y))
                
                if yDistance < closestYDistance {
                    closestYDistance = yDistance
                    closestYChildData = snapData
                }
            }
        }
        
        // For backward compatibility, maintain the snapIDNData
        // Prioritize X if available, otherwise Y
        if let xData = closestXChildData {
            snapIDNData = xData
        } else if let yData = closestYChildData {
            snapIDNData = yData
        } else {
            snapIDNData = nil
            templateHandler.selectedNearestSnappingChildID = 0
        }
        
        return (closestXChildData, closestYChildData)
    }
    
    
    func updateFrameForSelectedViewForMove(snapData: SnappingData) {
        guard !closestChildDict.isEmpty else { return }
        
        
        var closestChildPointX: Double?
        var closestChildPointY: Double?
        
        // Model of Moving Child.
        guard let selectedChildModel = templateHandler.currentModel else { return }
        templateHandler.prevSnappingChild = snapData
        
        let rotatedSizeAndCenter = rotatedBoundingBoxCenter(width: selectedChildModel.baseFrame.size.width, height: selectedChildModel.baseFrame.size.height, centerX: selectedChildModel.baseFrame.center.x, centerY: selectedChildModel.baseFrame.center.y, angleDegrees: CGFloat(selectedChildModel.baseFrame.rotation))
        templateHandler.selectedNearestSnappingChildID = snapData.modelID
        
        // Getting the template through the ID for most closest view.
        guard let model = templateHandler.getModel(modelId: snapData.modelID) else { return }
        
        let childRotatedSizeAndCenter = rotatedBoundingBoxCenter(width: model.baseFrame.size.width, height: model.baseFrame.size.height, centerX: model.baseFrame.center.x, centerY: model.baseFrame.center.y, angleDegrees: CGFloat(model.baseFrame.rotation))
        
        // Check and set the value of the point that is closest by their edge.
        switch snapData.childState {
        case .MinX:
            closestChildPointX = model.baseFrame.center.x - childRotatedSizeAndCenter.boundingWidth / 2
        case .MaxX:
            closestChildPointX = model.baseFrame.center.x + childRotatedSizeAndCenter.boundingWidth / 2
        case .CenterX:
            closestChildPointX = model.baseFrame.center.x
        case .MinY:
            closestChildPointY = model.baseFrame.center.y - childRotatedSizeAndCenter.boundingHeight / 2
        case .MaxY:
            closestChildPointY = model.baseFrame.center.y + childRotatedSizeAndCenter.boundingHeight / 2
        case .CenterY:
            closestChildPointY = model.baseFrame.center.y
        }
        
        // Handle X-axis snapping
        if let closestX = closestChildPointX {
            switch snapData.parentState {
            case .MinX:
                let minXPoint = selectedChildModel.baseFrame.center.x - rotatedSizeAndCenter.boundingWidth / 2
                let tX = closestX - minXPoint
                if !advancedMinXLine {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                    updateGridLines(gridLineState: .MinX)
                }
                
            case .MaxX:
                let maxXPoint = selectedChildModel.baseFrame.center.x + rotatedSizeAndCenter.boundingWidth / 2
                let tX = closestX - maxXPoint
                if !advancedMaxXLine {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                    updateGridLines(gridLineState: .MaxX)
                }
            case .CenterX:
                // Simplify center point calculation
                let tX = closestX - rotatedSizeAndCenter.centerX
                if !advancedCenterYLine {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                    updateGridLines(gridLineState: .CenterY)
                }
            default:
                break
            }
        }
        
        // Handle Y-axis snapping
        if let closestY = closestChildPointY {
            switch snapData.parentState {
            case .MinY:
                let minYPoint = selectedChildModel.baseFrame.center.y - rotatedSizeAndCenter.boundingHeight / 2
                let tY = closestY - minYPoint
                if !advancedMinYLine{
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                    updateGridLines(gridLineState: .MinY)
                }
            case .MaxY:
                let maxYPoint = selectedChildModel.baseFrame.center.y + rotatedSizeAndCenter.boundingHeight / 2
                let tY = closestY - maxYPoint
                if !advancedMaxYLine{
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                    updateGridLines(gridLineState: .MaxY)
                }
            case .CenterY:
                // Simplify center point calculation
                let tY = closestY - rotatedSizeAndCenter.centerY
                if !advancedCenterXLine{
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                    updateGridLines(gridLineState: .CenterX)
                }
            default:
                break
            }
        }
        
        // Apply the "free axis" adjustment
        if templateHandler.prevSnappingChild.modelID == snapData.modelID {
            // If snapping on X axis, allow Y to move freely
            if templateHandler.prevSnappingChild.parentState == .MaxX ||
               templateHandler.prevSnappingChild.parentState == .MinX ||
               templateHandler.prevSnappingChild.parentState == .CenterX {
                templateHandler.currentModel?.baseFrame.center.y = newCenter.y
            }
            // If snapping on Y axis, allow X to move freely
            else if templateHandler.prevSnappingChild.parentState == .MaxY ||
                    templateHandler.prevSnappingChild.parentState == .MinY ||
                    templateHandler.prevSnappingChild.parentState == .CenterY {
                templateHandler.currentModel?.baseFrame.center.x = newCenter.x
            }
        }
        // Set the value for highlighting the closest view.
//        updateGridLines(gridLineState: updatedGridLine)



        self.closestChildDict.removeAll()
    }
    
    
    func updateFrameForXAxisSnap(snapData: SnappingData) {
        guard !closestChildDict.isEmpty else { return }
        var closestChildPointX: Double?
        
        // Model of Moving Child.
        guard let selectedChildModel = templateHandler.currentModel else { return }
        
        // Getting the template through the ID for most closest view.
        guard let model = templateHandler.getModel(modelId: snapData.modelID) else { return }
        
        let rotatedSizeAndCenter = rotatedBoundingBoxCenter(
            width: selectedChildModel.baseFrame.size.width,
            height: selectedChildModel.baseFrame.size.height,
            centerX: selectedChildModel.baseFrame.center.x,
            centerY: selectedChildModel.baseFrame.center.y,
            angleDegrees: CGFloat(selectedChildModel.baseFrame.rotation))
        
        let childRotatedSizeAndCenter = rotatedBoundingBoxCenter(
            width: model.baseFrame.size.width,
            height: model.baseFrame.size.height,
            centerX: model.baseFrame.center.x,
            centerY: model.baseFrame.center.y,
            angleDegrees: CGFloat(model.baseFrame.rotation))
        
        // Check and set the value of the point that is closest by their edge.
        switch snapData.childState {
        case .MinX:
            closestChildPointX = model.baseFrame.center.x - childRotatedSizeAndCenter.boundingWidth / 2
        case .MaxX:
            closestChildPointX = model.baseFrame.center.x + childRotatedSizeAndCenter.boundingWidth / 2
        case .CenterX:
            closestChildPointX = model.baseFrame.center.x
        default:
            break
        }
        
        // Check and update the frame of the selected child model.
        if let closestX = closestChildPointX {
            switch snapData.parentState {
            case .MinX:
                let minXPoint = selectedChildModel.baseFrame.center.x - rotatedSizeAndCenter.boundingWidth / 2
                let tX = closestX - minXPoint
                if snapIDNData!.modelID == snapData.modelID && snapIDNData!.childState == snapData.childState && abs(tX) >= 2 {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                }
                else if snapIDNData!.modelID != snapData.modelID {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                }
                updateGridLines(gridLineState: .MinX)
            case .MaxX:
                let maxXPoint = selectedChildModel.baseFrame.center.x + rotatedSizeAndCenter.boundingWidth / 2
                let tX = closestX - maxXPoint
                if snapIDNData!.modelID == snapData.modelID && snapIDNData!.childState == snapData.childState && abs(tX) >= 2 {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                }
                else if snapIDNData!.modelID != snapData.modelID {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                }
                updateGridLines(gridLineState: .MaxX)
            case .CenterX:
                var centerXPoint = rotatedSizeAndCenter.centerX
                if snapData.childState == .MaxX {
                    centerXPoint = rotatedSizeAndCenter.centerX + rotatedSizeAndCenter.boundingWidth/2
                }
                else if snapData.childState == .MinX {
                    centerXPoint = rotatedSizeAndCenter.centerX - rotatedSizeAndCenter.boundingWidth/2
                }
                let tX = closestX - centerXPoint
                if snapIDNData!.modelID == snapData.modelID && snapIDNData!.childState == snapData.childState {
                    if abs(tX) >= 2 {
                        triggerVibration()
                        templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                    }
                }
                else if snapIDNData!.modelID != snapData.modelID {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.x = selectedChildModel.baseFrame.center.x + tX
                }
                updateGridLines(gridLineState: .CenterX)
            default:
                break
            }
        }
        
        // Set the value for highlighting the most closest view.
        templateHandler.selectedNearestSnappingChildID = snapData.modelID
    }

    func updateFrameForYAxisSnap(snapData: SnappingData) {
        guard !closestChildDictY.isEmpty else { return }
        var closestChildPointY: Double?
        
        // Model of Moving Child.
        guard let selectedChildModel = templateHandler.currentModel else { return }
        
        // Getting the template through the ID for most closest view.
        guard let model = templateHandler.getModel(modelId: snapData.modelID) else { return }
        
        let rotatedSizeAndCenter = rotatedBoundingBoxCenter(
            width: selectedChildModel.baseFrame.size.width,
            height: selectedChildModel.baseFrame.size.height,
            centerX: selectedChildModel.baseFrame.center.x,
            centerY: selectedChildModel.baseFrame.center.y,
            angleDegrees: CGFloat(selectedChildModel.baseFrame.rotation))
        
        let childRotatedSizeAndCenter = rotatedBoundingBoxCenter(
            width: model.baseFrame.size.width,
            height: model.baseFrame.size.height,
            centerX: model.baseFrame.center.x,
            centerY: model.baseFrame.center.y,
            angleDegrees: CGFloat(model.baseFrame.rotation))
        
        // Check and set the value of the point that is closest by their edge.
        switch snapData.childState {
        case .MinY:
            closestChildPointY = model.baseFrame.center.y - childRotatedSizeAndCenter.boundingHeight / 2
        case .MaxY:
            closestChildPointY = model.baseFrame.center.y + childRotatedSizeAndCenter.boundingHeight / 2
        case .CenterY:
            closestChildPointY = model.baseFrame.center.y
        default:
            break
        }
        
        // Check and update the frame of the selected child model.
        if let closestY = closestChildPointY {
            switch snapData.parentState {
            case .MinY:
                let minYPoint = selectedChildModel.baseFrame.center.y - rotatedSizeAndCenter.boundingHeight / 2
                let tY = closestY - minYPoint
                if snapIDNData!.modelID == snapData.modelID && snapIDNData!.childState == snapData.childState && abs(tY) >= 2 {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                }
                else if snapIDNData!.modelID != snapData.modelID {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                }
                updateGridLines(gridLineState: .MinY)
            case .MaxY:
                let maxYPoint = selectedChildModel.baseFrame.center.y + rotatedSizeAndCenter.boundingHeight / 2
                let tY = closestY - maxYPoint
                if snapIDNData!.modelID == snapData.modelID && snapIDNData!.childState == snapData.childState && abs(tY) >= 2 {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                }
                else if snapIDNData!.modelID != snapData.modelID {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                }
                updateGridLines(gridLineState: .MaxY)
            case .CenterY:
                var centerYPoint = rotatedSizeAndCenter.centerY
                if snapData.childState == .MaxY {
                    centerYPoint = rotatedSizeAndCenter.centerY + rotatedSizeAndCenter.boundingHeight/2
                }
                else if snapData.childState == .MinY {
                    centerYPoint = rotatedSizeAndCenter.centerY - rotatedSizeAndCenter.boundingHeight/2
                }
                let tY = closestY - centerYPoint
                if snapIDNData!.modelID == snapData.modelID && snapIDNData!.childState == snapData.childState {
                    if abs(tY) >= 2 {
                        triggerVibration()
                        templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                    }
                }
                else if snapIDNData!.modelID != snapData.modelID {
                    triggerVibration()
                    templateHandler.currentModel?.baseFrame.center.y = selectedChildModel.baseFrame.center.y + tY
                }
                updateGridLines(gridLineState: .CenterY)
            default:
                break
            }
        }
        
        // Set the value for highlighting the most closest view.
        templateHandler.selectedNearestSnappingChildID = snapData.modelID
    }
    
    
    //This function is used for updating the frame of Current View.
    func updateFrameForSelectedViewForScale(snapData : SnappingData, snapDistanceType : SnapDistanceType){
        var sizeType : SizeType = .width
        manageState()
        updateGridLines(gridLineState: snapData.parentState)
        if snapData.childState == .CenterX || snapData.childState == .MaxX || snapData.childState == .MinX{
            sizeType = .width
        }
        else{
            sizeType = .height
        }
        scaleCurrentSelectedView(sizeType: sizeType, snapDistanceType: snapDistanceType)
    }
    
    //This function is used for updating the frame of Current View.
//    func updateFrameForSelectedViewForDragScale(snapData : SnappingData){
//        if snapIDNData?.modelID == snapData.modelID {
//            return
//        }
//        snapIDNData = snapData
//        templateHandler.selectedNearestSnappingChildID = snapData.modelID
//        updateGridLines(gridLineState: snapData.parentState)
//        setDragScaleNCenter()
//    }
    
    
    func updateGridLines(gridLineState : GridLineState){
        switch gridLineState{
        case .MinX:
            advancedMinXLine = true
            advancedMaxXLine = false
            advancedCenterXLine = false
        case .MinY:
            advancedMinYLine = true
            advancedMaxYLine = false
            advancedCenterYLine = false
        case .MaxX:
            advancedMaxXLine = true
            advancedMinXLine = false
            advancedCenterXLine = false
        case .MaxY:
            advancedMaxYLine = true
            advancedMinYLine = false
            advancedCenterYLine = false
        case .CenterX:
            advancedCenterXLine = true
            advancedMaxXLine = false
            advancedMinXLine = false
        case .CenterY:
            advancedCenterYLine = true
            advancedMaxYLine = false
            advancedMinYLine = false
        }
        setNeedsDisplay()
    }
    
    
    func scaleCurrentSelectedView(sizeType : SizeType, snapDistanceType : SnapDistanceType){
        var baseFrame = templateHandler.currentModel!.baseFrame
        if sizeType == .width{
            let oldWidth = currentViewSize.width
            var newWidth = currentViewSize.width
            if snapDistanceType == .min{
                if currentViewSize.width < (templateHandler.currentModel?.baseFrame.size.width)!{
                    newWidth = newWidth - 3
                }
                else{
                    newWidth = newWidth + 3
                }
            }
            else{
                if currentViewSize.width < (templateHandler.currentModel?.baseFrame.size.width)!{
                    newWidth = newWidth - 3
                }
                else{
                    newWidth = newWidth + 3
                }
            }
            let scale = newWidth/oldWidth
            let oldHeight = currentViewSize.height
            let newHeight = currentViewSize.height * scale
            
          
            baseFrame.size = CGSize(width: newWidth, height: newHeight)
            templateHandler.currentModel?.baseFrame = baseFrame
        }
        else if sizeType == .height {
            let oldHeight = currentViewSize.height
            var newHeight = currentViewSize.height
            if snapDistanceType == .min {
                if currentViewSize.height < (templateHandler.currentModel?.baseFrame.size.height)! {
                    newHeight = newHeight - 3
                }
                else {
                    newHeight = newHeight + 3
                }
            }
            else {
                if currentViewSize.height < (templateHandler.currentModel?.baseFrame.size.height)! {
                    newHeight = newHeight - 3
                }
                else {
                    newHeight = newHeight + 3
                }
            }
            let scale = newHeight/oldHeight
            let oldWidth = currentViewSize.width
            let newWidth = currentViewSize.width * scale
            baseFrame.size = CGSize(width: newWidth, height: newHeight)
            templateHandler.currentModel?.baseFrame = baseFrame
        }
    }
    
}



extension CGRect {
    //For Calulating the Rotated Rect.
    func rotatedRect(withAngle angle: CGFloat) -> CGRect {
        let center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
        var corners = [(CGFloat, CGFloat)]()
        
        // Calculate the corners of the original rectangle
        corners.append((origin.x, origin.y))
        corners.append((origin.x + size.width, origin.y))
        corners.append((origin.x, origin.y + size.height))
        corners.append((origin.x + size.width, origin.y + size.height))
        
        // Rotate each corner around the center
        let rotatedCorners = corners.map { corner -> CGPoint in
            let dx = corner.0 - center.x
            let dy = corner.1 - center.y
            let newX = center.x + dx * cos(angle) - dy * sin(angle)
            let newY = center.y + dx * sin(angle) + dy * cos(angle)
            return CGPoint(x: newX, y: newY)
        }
        
        // Find the bounding rectangle of the rotated corners
        let minX = rotatedCorners.map { $0.x }.min() ?? 0
        let minY = rotatedCorners.map { $0.y }.min() ?? 0
        let maxX = rotatedCorners.map { $0.x }.max() ?? 0
        let maxY = rotatedCorners.map { $0.y }.max() ?? 0
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    
    func originalRect(fromAngle angle: CGFloat) -> CGRect {
        let center = CGPoint(x: midX, y: midY)
        var corners = [CGPoint]()
        
        // Calculate the corners of the rectangle
        let halfWidth = width / 2
        let halfHeight = height / 2
        
        corners.append(CGPoint(x: -halfWidth, y: -halfHeight))   // Top-left
        corners.append(CGPoint(x: halfWidth, y: -halfHeight))    // Top-right
        corners.append(CGPoint(x: -halfWidth, y: halfHeight))    // Bottom-left
        corners.append(CGPoint(x: halfWidth, y: halfHeight))     // Bottom-right
        
        // Rotate each corner around the center
        let unrotatedCorners = corners.map { corner -> CGPoint in
            let dx = corner.x
            let dy = corner.y
            let originalX = center.x + dx * cos(angle) - dy * sin(angle)
            let originalY = center.y + dx * sin(angle) + dy * cos(angle)
            return CGPoint(x: originalX, y: originalY)
        }
        
        // Find the bounding rectangle of the unrotated corners
        let minX = unrotatedCorners.map { $0.x }.min() ?? 0
        let minY = unrotatedCorners.map { $0.y }.min() ?? 0
        let maxX = unrotatedCorners.map { $0.x }.max() ?? 0
        let maxY = unrotatedCorners.map { $0.y }.max() ?? 0
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

}


func rotatedBoundingBoxCenter(width: CGFloat, height: CGFloat, centerX: CGFloat, centerY: CGFloat, angleDegrees: CGFloat) -> (centerX: CGFloat, centerY: CGFloat, boundingWidth: CGFloat, boundingHeight: CGFloat) {
    // Convert the angle to radians
    let angleRadians = angleDegrees * CGFloat.pi / 180.0

    // Calculate the new width and height of the bounding box
    let boundingWidth = abs(width * cos(angleRadians)) + abs(height * sin(angleRadians))
    let boundingHeight = abs(width * sin(angleRadians)) + abs(height * cos(angleRadians))

    // The center of the bounding box remains the same as the original center
    let boundingCenterX = centerX
    let boundingCenterY = centerY

    return (boundingCenterX, boundingCenterY, boundingWidth, boundingHeight)
}



extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.up) / divisor
    }
}
