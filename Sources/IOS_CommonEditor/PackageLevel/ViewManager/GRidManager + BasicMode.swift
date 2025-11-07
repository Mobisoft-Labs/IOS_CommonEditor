//
//  GRidManager + BasicMode.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 27/04/24.
//

import Foundation
import UIKit


// Basic Mode Functionailties goes below.
extension GridManager{
    
    //Computed frames for the Gride Lines.
    
    // Edge Line Computed Frame.
    var topEdgeLineFrame : CGRect {
        return CGRect(x: 0, y: 0 , width: self.bounds.width, height: 2 * snapBreath)
    }
    var bottomEdgeLineFrame : CGRect {
        return CGRect(x: 0, y: self.bounds.maxY - snapBreath, width: self.bounds.width, height: 2 * snapBreath)
    }
    var leftEdgeLineFrame : CGRect {
        return CGRect(x: 0 - snapBreath, y: 0, width: 2 * snapBreath, height: self.bounds.height)
    }
    var rightEdgeLineFrame : CGRect {
        return CGRect(x: self.bounds.maxX + snapBreath, y: 0, width: 2 * snapBreath, height: self.bounds.height)
    }
    
    // Ideal Line Computed Frame.
    var topIdealLineFrame : CGRect {
        return CGRect(x: 10, y: 10 - snapBreath, width: self.bounds.width - 10 , height: 2 * snapBreath)
    }
    var bottomIdealLineFrame : CGRect {
        return CGRect(x: 10, y: self.bounds.maxY - 10 - snapBreath, width: self.bounds.width - 10, height: 2 * snapBreath)
    }
    var leftIdealLineFrame : CGRect {
        return  CGRect(x: 10 - snapBreath, y: 10, width: 2 * snapBreath, height: self.bounds.height - 10)
    }
    var rightIdealLineFrame : CGRect {
        return CGRect(x: self.bounds.maxX - 10 - snapBreath , y: 10, width: 2 * snapBreath, height: self.bounds.height - 10)
    }
    
    // Center Line Computed Frame.
    var centerXLineFrame : CGRect {
        return CGRect(x: 0, y: self.bounds.midY - snapBreath, width: self.bounds.width, height: 2 * snapBreath)
    }
    
    var centerYLineFrame : CGRect {
        return CGRect(x: self.bounds.midX - snapBreath, y: self.bounds.minY , width: 2 * snapBreath, height: self.bounds.height)
    }
    
    func updateGridLineStateWithNewCenterPoint(centerPoint: CGPoint, minPoint: CGPoint, maxPoint: CGPoint) {
        var snapX = false
        var snapY = false
        
        // Check snapping on X-axis
        if leftEdgeLineFrame.contains(centerPoint) || leftEdgeLineFrame.contains(minPoint) || leftEdgeLineFrame.contains(maxPoint) {
            leftEdgeLine = true
            snapX = true
        } else {
            leftEdgeLine = false
        }
        
        if rightEdgeLineFrame.contains(centerPoint) || rightEdgeLineFrame.contains(minPoint) || rightEdgeLineFrame.contains(maxPoint) {
            rightEdgeLine = true
            snapX = true
        } else {
            rightEdgeLine = false
        }
        
        if centerYLineFrame.contains(centerPoint) || centerYLineFrame.contains(minPoint) || centerYLineFrame.contains(maxPoint) {
            centerYLine = true
            snapX = true
        } else {
            centerYLine = false
        }
        
        // Check snapping on Y-axis
        if topEdgeLineFrame.contains(centerPoint) || topEdgeLineFrame.contains(minPoint) || topEdgeLineFrame.contains(maxPoint) {
            topEdgeLine = true
            snapY = true
        } else {
            topEdgeLine = false
        }
        
        if bottomEdgeLineFrame.contains(centerPoint) || bottomEdgeLineFrame.contains(minPoint) || bottomEdgeLineFrame.contains(maxPoint) {
            bottomEdgeLine = true
            snapY = true
        } else {
            bottomEdgeLine = false
        }
        
        if centerXLineFrame.contains(centerPoint) || centerXLineFrame.contains(minPoint) || centerXLineFrame.contains(maxPoint) {
            centerXLine = true
            snapY = true
        } else {
            centerXLine = false
        }
        
        // Adjust movement logic
        // Ensure snapping in one axis does not lock movement in the other axis
        if snapX && !snapY {
            topEdgeLine = false
            bottomEdgeLine = false
            centerXLine = false
        } else if snapY && !snapX {
            leftEdgeLine = false
            rightEdgeLine = false
            centerYLine = false
        }
        
        // Handle ideal snapping
        if topIdealLineFrame.contains(centerPoint) || topIdealLineFrame.contains(minPoint) || topIdealLineFrame.contains(maxPoint) ||
            bottomIdealLineFrame.contains(centerPoint) || bottomIdealLineFrame.contains(minPoint) || bottomIdealLineFrame.contains(maxPoint) ||
            leftIdealLineFrame.contains(centerPoint) || leftIdealLineFrame.contains(minPoint) || leftIdealLineFrame.contains(maxPoint) ||
            rightIdealLineFrame.contains(centerPoint) || rightIdealLineFrame.contains(minPoint) || rightIdealLineFrame.contains(maxPoint) {
            topIdealLine = true
            bottomIdealLine = true
            leftIdealLine = true
            rightIdealLine = true
        } else {
            topIdealLine = false
            bottomIdealLine = false
            leftIdealLine = false
            rightIdealLine = false
        }
    }
    // MARK:- Drawing Functions Starts from here.
    
    //Function for drawing the Top Edge Line.
    func drawTopEdgeLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: topEdgeLineFrame.origin)
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: topEdgeLineFrame.width, y: topEdgeLineFrame.origin.y))
        // Draw the line
        context.strokePath()
    }
    
    //Function for drawing the Top Edge Line.
    func drawBottomEdgeLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: bottomEdgeLineFrame.origin)
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: bottomEdgeLineFrame.width, y: bottomEdgeLineFrame.origin.y))
        // Draw the line
        context.strokePath()
    }
    
    
    //Function for drawing the Top Edge Line.
    func drawLeftEdgeLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: leftEdgeLineFrame.origin)
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: leftEdgeLineFrame.origin.x, y: leftEdgeLineFrame.height))
        // Draw the line
        context.strokePath()
    }
    
    
    //Function for drawing the Top Edge Line.
    func drawRightEdgeLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: rightEdgeLineFrame.origin)
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: rightEdgeLineFrame.origin.x, y: rightEdgeLineFrame.height))
        // Draw the line
        context.strokePath()
    }
    
    
    //Function for drawing the Top Edge Line.
    func drawTopIdealLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: CGPoint(x: topIdealLineFrame.minX, y: topIdealLineFrame.origin.y))
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: topIdealLineFrame.width, y: topIdealLineFrame.origin.y))
        // Draw the line
        context.strokePath()
    }
    
    //Function for drawing the Top Edge Line.
    func drawBottomIdealLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: CGPoint(x: bottomIdealLineFrame.origin.x, y: bottomIdealLineFrame.origin.y))
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: bottomIdealLineFrame.width, y: bottomIdealLineFrame.origin.y))
        // Draw the line
        context.strokePath()
    }
    
    //Function for drawing the Top Edge Line.
    func drawLeftIdealLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to:CGPoint(x: leftIdealLineFrame.origin.x + 2 , y: leftIdealLineFrame.origin.y))
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: leftIdealLineFrame.origin.x + 2, y: leftIdealLineFrame.height))
        // Draw the line
        context.strokePath()
    }
    
    //Function for drawing the Top Edge Line.
    func drawRightIdealLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to:  CGPoint(x:rightIdealLineFrame.origin.x + 2, y: rightIdealLineFrame.origin.y))
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: rightIdealLineFrame.origin.x + 2, y: rightIdealLineFrame.height))
        // Draw the line
        context.strokePath()
    }
    
    //Function for drawing the Top Edge Line.
    func drawCenterXLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: CGPoint(x: centerXLineFrame.origin.x, y: centerXLineFrame.origin.y))
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: centerXLineFrame.size.width, y: centerXLineFrame.origin.y))
        // Draw the line
        context.strokePath()
    }
    
    //Function for drawing the Top Edge Line.
    func drawCenterYLine(context : CGContext){
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(1.0)
        // Move to the starting point of the line
        context.move(to: CGPoint(x: centerYLineFrame.origin.x, y: centerYLineFrame.origin.y))
        // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: centerYLineFrame.origin.x, y: centerYLineFrame.height))
        // Draw the line
        context.strokePath()
    }
    
    func manageStateInBasicMode(){
        topEdgeLine = false
        bottomEdgeLine = false
        leftEdgeLine = false
        rightEdgeLine = false
        topIdealLine = false
        bottomIdealLine = false
        leftIdealLine = false
        rightIdealLine = false
        centerXLine = false
        centerYLine = false
    }
    
    
    // Functions for updating the grid lines.
    func updateGridLineView(context : CGContext){
        if topEdgeLine{
            drawTopEdgeLine(context: context)
        }
        if bottomEdgeLine{
            drawBottomEdgeLine(context: context)
        }
        if leftEdgeLine{
            drawLeftEdgeLine(context: context)
        }
        if rightEdgeLine{
            drawRightEdgeLine(context: context)
        }
        if topIdealLine{
            drawTopIdealLine(context: context)
        }
        if bottomIdealLine{
            drawBottomIdealLine(context: context)
        }
        if leftIdealLine{
            drawLeftIdealLine(context: context)
        }
        if rightIdealLine{
            drawRightIdealLine(context: context)
        }
        if centerXLine{
            drawCenterXLine(context: context)
        }
        if centerYLine{
            drawCenterYLine(context: context)
        }
    }
    
    
    func snapIfNeeded(centerPoint: CGPoint, minPoint: CGPoint, maxPoint: CGPoint) -> Bool {
        var snapped = false
        let convertedCenterPoint = currentPageView.convert(centerPoint, from: parentViewFrame)
        updatedCenterX = convertedCenterPoint.x//centerPoint.x
        updatedCenterY = convertedCenterPoint.y//centerPoint.y
        
        // Check and update top edge snapping
        if containsAnyPoint(frame: topEdgeLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: topEdgeState) {
            print("11 Top Edge Snapping")
            topEdgeState = false
            snapped = true
        } else {
            topEdgeState = true
        }
        
        // Check and update bottom edge snapping
        if containsAnyPoint(frame: bottomEdgeLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: bottomEdgeState) {
            print("11 Bottom Edge Snapping")
            bottomEdgeState = false
            snapped = true
        } else {
            bottomEdgeState = true
        }
        
        // Check and update left edge snapping
        if containsAnyPoint(frame: leftEdgeLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: leftEdgeState) {
            print("11 Left Edge Snapping")
            leftEdgeState = false
            snapped = true
        } else {
            leftEdgeState = true
        }
        
        // Check and update right edge snapping
        if containsAnyPoint(frame: rightEdgeLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: rightEdgeState) {
            print("11 Right Edge Snapping")
            rightEdgeState = false
            snapped = true
        } else {
            rightEdgeState = true
        }
        
        // Check and update top ideal snapping
        if containsAnyPoint(frame: topIdealLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: topIdealState) {
            print("11 Top Ideal Snapping")
            topIdealState = false
            snapped = true
        } else {
            topIdealState = true
        }
        
        // Check and update bottom ideal snapping
        if containsAnyPoint(frame: bottomIdealLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: bottomIdealState) {
            print("11 Bottom Ideal Snapping")
            bottomIdealState = false
            snapped = true
        } else {
            bottomIdealState = true
        }
        
        // Check and update left ideal snapping
        if containsAnyPoint(frame: leftIdealLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: leftIdealState) {
            print("11 Left Ideal Snapping")
            leftIdealState = false
            snapped = true
        } else {
            leftIdealState = true
        }
        
        // Check and update right ideal snapping
        if containsAnyPoint(frame: rightIdealLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: rightIdealState) {
            print("11 Right Ideal Snapping")
            rightIdealState = false
            snapped = true
        } else {
            rightIdealState = true
        }
        
        // Check and update center X snapping
        if containsAnyPoint(frame: centerXLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: centerXState) {
            print("11 Center X Snapping")
            centerXState = false
            snapped = true
        } else {
            centerXState = true
        }
        
        // Check and update center Y snapping
        if containsAnyPoint(frame: centerYLineFrame, centerPoint: centerPoint, minPoint: minPoint, maxPoint: maxPoint, currentState: centerYState) {
            print("11 Center Y Snapping")
            centerYState = false
            snapped = true
        } else {
            centerYState = true
        }
        let cnvertedCenter = parentViewFrame.convert(CGPoint(x: updatedCenterX, y: updatedCenterY), from: currentPageView)
        if xSnapped && updatedCenterX == templateHandler.currentModel?.baseFrame.center.x {
            templateHandler.currentModel?.baseFrame.center.y = cnvertedCenter.y//updatedCenterY//CGPoint(x: updatedCenterX, y: updatedCenterY)
        }
        else if ySnapped && updatedCenterY == templateHandler.currentModel?.baseFrame.center.y {
            templateHandler.currentModel?.baseFrame.center.x = cnvertedCenter.x//updatedCenterX//CGPoint(x: updatedCenterX, y: updatedCenterY)
        }
        else if xSnapped && updatedCenterX != templateHandler.currentModel?.baseFrame.center.x {
            templateHandler.currentModel?.baseFrame.center.x = cnvertedCenter.x//updatedCenterX
        }
        else if ySnapped && updatedCenterY != templateHandler.currentModel?.baseFrame.center.y {
            templateHandler.currentModel?.baseFrame.center.y = cnvertedCenter.y//updatedCenterY//CGPoint(x: updatedCenterX, y: updatedCenterY)
        }
        else{
            templateHandler.currentModel?.baseFrame.center = cnvertedCenter//CGPoint(x: updatedCenterX, y: updatedCenterY)
        }
        return snapped
    }
    
    func containsAnyPoint(frame: CGRect, centerPoint: CGPoint, minPoint: CGPoint, maxPoint: CGPoint, currentState: Bool) -> Bool {
        
        let currentModel = templateHandler.currentModel!
        let rotatedSizeAndCenter = rotatedBoundingBoxCenter(
            width: currentModel.baseFrame.size.width,
            height: currentModel.baseFrame.size.height,
            centerX: currentModel.baseFrame.center.x,
            centerY: currentModel.baseFrame.center.y,
            angleDegrees: CGFloat(currentModel.baseFrame.rotation)
        )
        let centerPoint = currentPageView.convert(centerPoint, from: parentViewFrame)
        
        // Define all points to check
        let points: [(point: CGPoint, updateLogic: () -> Void, snapLogic: () -> Void)] = [
            (CGPoint(x: centerPoint.x, y: centerPoint.y), {
//                self.updatedCenterY = centerPoint.y
                let currentY = self.updatedCenterY
                let deltaY = centerPoint.y - currentY
                self.updatedCenterY = frame.midY//currentY + deltaY
            }, {
                self.xSnapped = true
                self.ySnapped = true
            }),
            (CGPoint(x: centerPoint.x, y: centerPoint.y), {
//                self.updatedCenterX = centerPoint.x
                let currentX = self.updatedCenterX
                let deltaX = centerPoint.x - currentX
                self.updatedCenterX = frame.midX//currentX + deltaX
            }, {
                self.xSnapped = true
                self.ySnapped = true
            }),
            (CGPoint(x: minPoint.x, y: centerPoint.y), {
                self.updatedCenterX = frame.minX + rotatedSizeAndCenter.boundingWidth / 2
            }, {
                self.xSnapped = true
            }),
            (CGPoint(x: centerPoint.x, y: minPoint.y), {
                self.updatedCenterY = frame.minY + rotatedSizeAndCenter.boundingHeight / 2
            }, {
                self.ySnapped = true
            }),
            (CGPoint(x: maxPoint.x, y: centerPoint.y), {
                self.updatedCenterX = frame.midX - rotatedSizeAndCenter.boundingWidth / 2
            }, {
                self.xSnapped = true
            }),
            (CGPoint(x: centerPoint.x, y: maxPoint.y), {
                self.updatedCenterY = frame.midY - rotatedSizeAndCenter.boundingHeight / 2
            }, {
                self.ySnapped = true
            })
        ]
        
        // Iterate over points and apply logic if the point is within the frame
        for (point, updateLogic, snapLogic) in points {
            if frame.contains(point) {
                print("Point \(point) found in frame")
                if currentState {
                    updateLogic()
                    snapLogic() // Apply snapping logic
                    triggerVibration()
                }
                return true
            }
        }
        
        // If no points are in the frame, reset snapping
        xSnapped = false
        ySnapped = false
        
        print("xSnapped: \(xSnapped), ySnapped: \(ySnapped)")
        return false
    }
}





// Basic Snapping for Scalling.

/*
 - Manage Grid Lines for basic like which one will be show or not. (Already Done)
 - Second Logic is for snapping. topIdealLineFrame, bottomIdealLineFrame, leftIdealLineFrame,
    rightIdealLineFrame, centerXLineFrame,centerYLineFrame
 */

extension GridManager {
    // Define snap point enums outside the function
    enum XSnapPoint { case none, left, right, center }
    enum YSnapPoint { case none, top, bottom, center }
    
    // Static properties to track current snap points
    static var currentXSnapPoint: XSnapPoint = .none
    static var currentYSnapPoint: YSnapPoint = .none
    
    func manageSnappingForScalingInBasicMode(currentViewSize: CGSize, currentCenter: CGPoint) {
        // Define snap threshold - how close an edge needs to be to snap
        let snapThreshold: CGFloat = 0.25
        
        // Set a very small release threshold to make snaps release easily
        let releaseThreshold: CGFloat = 0.25
        
        var didSnap = false
        var newSize = currentViewSize
        var newCenter = currentCenter
        
        // If there's a parent view, convert the center lines to the parent's coordinate system
        var adjustedCenterXLineFrame = centerXLineFrame
        var adjustedCenterYLineFrame = centerYLineFrame
        
   
            // Convert center line frames from current page view's coordinate system to parent view's coordinate system
        adjustedCenterXLineFrame = currentPageView.convert(centerXLineFrame, to: parentViewFrame)
        adjustedCenterYLineFrame = currentPageView.convert(centerYLineFrame, to: parentViewFrame)
        
        // Calculate current frame boundaries
        let leftEdge = currentCenter.x - currentViewSize.width / 2
        let rightEdge = currentCenter.x + currentViewSize.width / 2
        let topEdge = currentCenter.y - currentViewSize.height / 2
        let bottomEdge = currentCenter.y + currentViewSize.height / 2
        
        // Check if we should release X snap
        if isSnappedToXCenter {
            var shouldReleaseXSnap = false
            
            switch GridManager.currentXSnapPoint {
            case .center:
                // Check if center has moved far enough from center line to release
                if abs(currentCenter.x - adjustedCenterXLineFrame.midX) > releaseThreshold {
                    shouldReleaseXSnap = true
                }
            case .left:
                // Check if left edge has moved far enough from center line to release
                if abs(leftEdge - adjustedCenterXLineFrame.midX) > releaseThreshold {
                    shouldReleaseXSnap = true
                }
            case .right:
                // Check if right edge has moved far enough from center line to release
                if abs(rightEdge - adjustedCenterXLineFrame.midX) > releaseThreshold {
                    shouldReleaseXSnap = true
                }
            case .none:
                shouldReleaseXSnap = true
            }
            
            if shouldReleaseXSnap {
                isSnappedToXCenter = false
                GridManager.currentXSnapPoint = .none
                print("Released X snap")
            }
        }
        
        // Check if we should release Y snap
        if isSnappedToYCenter {
            var shouldReleaseYSnap = false
            
            switch GridManager.currentYSnapPoint {
            case .center:
                // Check if center has moved far enough from center line to release
                if abs(currentCenter.y - adjustedCenterYLineFrame.midY) > releaseThreshold {
                    shouldReleaseYSnap = true
                }
            case .top:
                // Check if top edge has moved far enough from center line to release
                if abs(topEdge - adjustedCenterYLineFrame.midY) > releaseThreshold {
                    shouldReleaseYSnap = true
                }
            case .bottom:
                // Check if bottom edge has moved far enough from center line to release
                if abs(bottomEdge - adjustedCenterYLineFrame.midY) > releaseThreshold {
                    shouldReleaseYSnap = true
                }
            case .none:
                shouldReleaseYSnap = true
            }
            
            if shouldReleaseYSnap {
                isSnappedToYCenter = false
                GridManager.currentYSnapPoint = .none
                print("Released Y snap")
            }
        }
        
        // Handle X snap if still active
        if isSnappedToXCenter {
            switch GridManager.currentXSnapPoint {
            case .center:
                // Keep center aligned
                newCenter.x = adjustedCenterXLineFrame.midX
                didSnap = true
            case .left:
                // Keep left edge aligned to center line
                newSize.width = (currentCenter.x - adjustedCenterXLineFrame.midX) * 2
                let aspectRatio = currentViewSize.width / currentViewSize.height
                newSize.height = newSize.width / aspectRatio
                newCenter.x = adjustedCenterXLineFrame.midX + (newSize.width / 2)
                didSnap = true
            case .right:
                // Keep right edge aligned to center line
                newSize.width = (adjustedCenterXLineFrame.midX - currentCenter.x) * 2
                let aspectRatio = currentViewSize.width / currentViewSize.height
                newSize.height = newSize.width / aspectRatio
                newCenter.x = adjustedCenterXLineFrame.midX - (newSize.width / 2)
                didSnap = true
            case .none:
                // Should never happen
                break
            }
        }
        
        // Handle Y snap if still active
        if isSnappedToYCenter {
            switch GridManager.currentYSnapPoint {
            case .center:
                // Keep center aligned
                newCenter.y = adjustedCenterYLineFrame.midY
                didSnap = true
            case .top:
                // Keep top edge aligned to center line
                newSize.height = (currentCenter.y - adjustedCenterYLineFrame.midY) * 2
                let aspectRatio = currentViewSize.width / currentViewSize.height
                newSize.width = newSize.height * aspectRatio
                newCenter.y = adjustedCenterYLineFrame.midY + (newSize.height / 2)
                didSnap = true
            case .bottom:
                // Keep bottom edge aligned to center line
                newSize.height = (adjustedCenterYLineFrame.midY - currentCenter.y) * 2
                let aspectRatio = currentViewSize.width / currentViewSize.height
                newSize.width = newSize.height * aspectRatio
                newCenter.y = adjustedCenterYLineFrame.midY - (newSize.height / 2)
                didSnap = true
            case .none:
                // Should never happen
                break
            }
        }
        
        // Only check for new snapping if not already snapped
        if !didSnap && !isSnappedToXCenter && !isSnappedToYCenter {
            // Calculate distances to center lines
            let distanceLeftToCenter = abs(leftEdge - adjustedCenterXLineFrame.midX)
            let distanceRightToCenter = abs(rightEdge - adjustedCenterXLineFrame.midX)
            let distanceCenterXToCenter = abs(currentCenter.x - adjustedCenterXLineFrame.midX)
            
            let distanceTopToCenter = abs(topEdge - adjustedCenterYLineFrame.midY)
            let distanceBottomToCenter = abs(bottomEdge - adjustedCenterYLineFrame.midY)
            let distanceCenterYToCenter = abs(currentCenter.y - adjustedCenterYLineFrame.midY)
            
            // Check for X snapping
            if distanceCenterXToCenter <= snapThreshold {
                // Center point snaps to center line
                newCenter.x = adjustedCenterXLineFrame.midX
                isSnappedToXCenter = true
                GridManager.currentXSnapPoint = .center
                didSnap = true
                print("Snapped center to X centerline")
                triggerVibration()
            } else if distanceLeftToCenter <= snapThreshold {
                // Left edge snaps to center line
                let widthAdjustment = leftEdge - adjustedCenterXLineFrame.midX
                newSize.width = currentViewSize.width - widthAdjustment
                
                // Maintain aspect ratio
                let aspectRatio = currentViewSize.width / currentViewSize.height
                newSize.height = newSize.width / aspectRatio
                
                // Adjust center to keep left edge at center line
                newCenter.x = adjustedCenterXLineFrame.midX + (newSize.width / 2)
                
                isSnappedToXCenter = true
                GridManager.currentXSnapPoint = .left
                didSnap = true
                print("Snapped left edge to X centerline")
                triggerVibration()
            } else if distanceRightToCenter <= snapThreshold {
                // Right edge snaps to center line
                let widthAdjustment = adjustedCenterXLineFrame.midX - rightEdge
                newSize.width = currentViewSize.width + widthAdjustment
                
                // Maintain aspect ratio
                let aspectRatio = currentViewSize.width / currentViewSize.height
                newSize.height = newSize.width / aspectRatio
                
                // Adjust center to keep right edge at center line
                newCenter.x = adjustedCenterXLineFrame.midX - (newSize.width / 2)
                
                isSnappedToXCenter = true
                GridManager.currentXSnapPoint = .right
                didSnap = true
                print("Snapped right edge to X centerline")
                triggerVibration()
            }
            
            // Check for Y snapping (only if X didn't snap)
            if !didSnap {
                if distanceCenterYToCenter <= snapThreshold {
                    // Center point snaps to center line
                    newCenter.y = adjustedCenterYLineFrame.midY
                    isSnappedToYCenter = true
                    GridManager.currentYSnapPoint = .center
                    didSnap = true
                    print("Snapped center to Y centerline")
                    triggerVibration()
                } else if distanceTopToCenter <= snapThreshold {
                    // Top edge snaps to center line
                    let heightAdjustment = topEdge - adjustedCenterYLineFrame.midY
                    newSize.height = currentViewSize.height - heightAdjustment
                    
                    // Maintain aspect ratio
                    let aspectRatio = currentViewSize.width / currentViewSize.height
                    newSize.width = newSize.height * aspectRatio
                    
                    // Adjust center to keep top edge at center line
                    newCenter.y = adjustedCenterYLineFrame.midY + (newSize.height / 2)
                    
                    isSnappedToYCenter = true
                    GridManager.currentYSnapPoint = .top
                    didSnap = true
                    print("Snapped top edge to Y centerline")
                    triggerVibration()
                } else if distanceBottomToCenter <= snapThreshold {
                    // Bottom edge snaps to center line
                    let heightAdjustment = adjustedCenterYLineFrame.midY - bottomEdge
                    newSize.height = currentViewSize.height + heightAdjustment
                    
                    // Maintain aspect ratio
                    let aspectRatio = currentViewSize.width / currentViewSize.height
                    newSize.width = newSize.height * aspectRatio
                    
                    // Adjust center to keep bottom edge at center line
                    newCenter.y = adjustedCenterYLineFrame.midY - (newSize.height / 2)
                    
                    isSnappedToYCenter = true
                    GridManager.currentYSnapPoint = .bottom
                    didSnap = true
                    print("Snapped bottom edge to Y centerline")
                    triggerVibration()
                }
            }
        }
        
        // Update the frame
        if didSnap {
            templateHandler.currentModel?.baseFrame.size = newSize
            templateHandler.currentModel?.baseFrame.center = newCenter
        } else if !isSnappedToXCenter && !isSnappedToYCenter {
            // No snapping, update normally
            templateHandler.currentModel?.baseFrame.size = currentViewSize
            templateHandler.currentModel?.baseFrame.center = currentCenter
        } else {
            // Somehow we're still snapped but didn't update - this shouldn't happen
            // Release all snaps as a failsafe
            isSnappedToXCenter = false
            isSnappedToYCenter = false
            GridManager.currentXSnapPoint = .none
            GridManager.currentYSnapPoint = .none
            templateHandler.currentModel?.baseFrame.size = currentViewSize
            templateHandler.currentModel?.baseFrame.center = currentCenter
        }
    }
}
