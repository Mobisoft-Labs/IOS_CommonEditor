//
//  GridManager + Rotation.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 30/04/24.
//

import Foundation
import UIKit

// GRid Manager Rotation Logic Goes Here.
extension GridManager{
    
    var rightCenterXDottedLine : CGRect{
        return CGRect(x: updatedRectForRotation.midX, y: updatedRectForRotation.midY - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    var leftCenterXDottedLine : CGRect{
        return CGRect(x: updatedRectForRotation.midX, y: updatedRectForRotation.midY - snapBreath, width: pageView.bounds.width, height: 2 * snapBreath)
    }
    
    var topCenterYDottedLine : CGRect{
        return  CGRect(x: updatedRectForRotation.midX - snapBreath, y: updatedRectForRotation.midY, width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    var bottomCenterYDottedLine : CGRect{
        return  CGRect(x: updatedRectForRotation.midX - snapBreath, y: updatedRectForRotation.midY, width: 2 * snapBreath, height: pageView.bounds.height)
    }
    
    var rotatedDottedLine : CGRect{
        let points = CGPoint(x:  updatedRectForRotation.midX, y: 0 - (2 * (pageView.bounds.height)))

        return CGRect(x: points.x, y: points.y, width: 2 * snapBreath, height:  pageView.bounds.height)

    }
    
    //MARK: - Rotated Dotted Line Logic Goes Here.
    
    func drawRightDottedLine(context : CGContext){
//        let  dashes: [ CGFloat ] = [ 0.0, 2.0 , 4.0 ,6.0 ]
//
//        context.setLineDash(phase: 0, lengths: dashes)
        
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: rightCenterXDottedLine.origin.x, y: rightCenterXDottedLine.origin.y + rightCenterXDottedLine.height/2))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: rightCenterXDottedLine.width, y: rightCenterXDottedLine.origin.y + rightCenterXDottedLine.height/2))
         // Draw the line
         context.strokePath()
    }
    
    func drawLeftDottedLine(context : CGContext){
//        let  dashes: [ CGFloat ] = [ 0.0, 2.0 , 4.0 ,6.0 ]
//
//        context.setLineDash(phase: 0, lengths: dashes)
        
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
         context.move(to: CGPoint(x: leftCenterXDottedLine.origin.x, y: leftCenterXDottedLine.origin.y +  leftCenterXDottedLine.height/2))
         // Add a line to the end point of the line
        context.addLine(to: CGPoint(x: -leftCenterXDottedLine.width, y: leftCenterXDottedLine.origin.y + leftCenterXDottedLine.height/2))
         // Draw the line
         context.strokePath()
    }

    
    func drawTopDottedLine(context : CGContext){
//        let  dashes: [ CGFloat ] = [ 0.0, 2.0 , 4.0 ,6.0 ]
//
//        context.setLineDash(phase: 0, lengths: dashes)
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: topCenterYDottedLine.origin.x + topCenterYDottedLine.width / 2 , y: topCenterYDottedLine.origin.y))
         // Add a line to the end point of the line
         context.addLine(to: CGPoint(x: topCenterYDottedLine.origin.x + topCenterYDottedLine.width / 2, y: -topCenterYDottedLine.height))
         // Draw the line
         context.strokePath()
    }

    func drawBottomDottedLine(context : CGContext){
//        let  dashes: [ CGFloat ] = [ 0.0, 2.0 , 4.0 ,6.0 ]
//
//        context.setLineDash(phase: 0, lengths: dashes)
         
        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
         // Set line width if needed
         context.setLineWidth(1.0)
         // Move to the starting point of the line
        context.move(to: CGPoint(x: bottomCenterYDottedLine.origin.x + bottomCenterYDottedLine.width / 2 , y: bottomCenterYDottedLine.origin.y))
         // Add a line to the end point of the line
         context.addLine(to: CGPoint(x: bottomCenterYDottedLine.origin.x + bottomCenterYDottedLine.width / 2, y: bottomCenterYDottedLine.height))
         // Draw the line
         context.strokePath()
    }

    
    func drawRotatedDottedLine(context : CGContext){
        
        guard let currentModel = templateHandler.currentModel else {
//            printLog("Nil Current Model")
            return
        }
        
        let rotatedOrigin = rotatedDottedLine.origin.rotate(origin: CGPoint(x: CGFloat(updatedRectForRotation.midX), y: CGFloat(updatedRectForRotation.midY)), CGFloat(currentModel.baseFrame.rotation))
        
     
        
//       printLog("NewRoPoint",rotatedOrigin)
        
        let  dashes: [ CGFloat ] = [ 0.0, 2.0 , 4.0 ,6.0 ]

        context.setLineDash(phase: 0, lengths: dashes)

        // Set the line color to darkGreen
        let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.setStrokeColor(darkGreen.cgColor)
        // Set line width if needed
        context.setLineWidth(2.0)
        // Move to the starting point of the line
        context.move(to: CGPoint(x: CGFloat(updatedRectForRotation.midX), y: CGFloat(updatedRectForRotation.midY)))
        // Add a line to the end point of the line
        context.addLine(to: rotatedOrigin)
        // Draw the line
        context.strokePath()
    }
    
    
    func drawRotationLine(context : CGContext){
        if rightDottedLineDraw{
            drawRightDottedLine(context: context)
        }
        if leftDottedLineDraw{
            drawLeftDottedLine(context: context)
        }
        if topDottedLineDraw{
            drawTopDottedLine(context: context)
        }
        if bottomDottedLineDraw{
            drawBottomDottedLine(context: context)
        }
        if rotatedDottedLineDraw{
            drawRotatedDottedLine(context: context)
        }
    }
    
    func snapForRotationIfNeeded(rotation : Double, currentParentView : UIView, rootView : UIView){
        let baseFrame = (templateHandler.currentModel?.baseFrame)!
        updatedRectForRotation = CGRect(origin: CGPoint(x: baseFrame.center.x - baseFrame.size.width / 2 , y: baseFrame.center.y - baseFrame.size.height / 2 ), size: baseFrame.size)
        updatedRectForRotation = currentParentView.convert(updatedRectForRotation, to: rootView)
        checkForRotatedLine()
        manageRotationState()
        manageRotationGridLines()
        setNeedsDisplay()
    }
    
    
    func manageRotationState(){
        topDottedLineDraw = false
        bottomDottedLineDraw = false
        rightDottedLineDraw = false
        leftDottedLineDraw = false
        rotatedDottedLineDraw = true
        setNeedsDisplay()
    }
    
    func manageStateForRotation(){
        topDottedLineDraw = false
        bottomDottedLineDraw = false
        rightDottedLineDraw = false
        leftDottedLineDraw = false
        rotatedDottedLineDraw = false
        setNeedsDisplay()
    }
    
    func manageRotationGridLines(){
        checkForRightCenterX()
        checkForLeftCenterX()
        checkRightCenterY()
        checkLeftCenterY()
    }
    
    //Function for checking the rotated line is come within the MinX.
    func checkForRightCenterX(){
        if (degreeAngle < 45 || degreeAngle > 315)  && degreeAngle > 0{
            print("99N Right Line Enable")
            topDottedLineDraw = true
        }
    }
    
    //Function for checking the rotated line is come within the MaxX.
    func checkForLeftCenterX(){
        if degreeAngle < 135 && degreeAngle > 45{
            print("99N Left Line Enable")
            rightDottedLineDraw = true
        }
    }
    
    //Function for checking the rotated line is come within the MinY.
    func checkRightCenterY(){
        if degreeAngle < 225 && degreeAngle > 135{
            print("99N Top Line Enable")
            bottomDottedLineDraw = true
        }
    }
    
    //Function for checking the rotated line is come within the MaxX.
    func checkLeftCenterY(){
        if degreeAngle < 315 && degreeAngle > 225{
            print("99N Bottom Line Enable")
            leftDottedLineDraw = true
        }
    }
    
    
    
    func checkForRotatedLine(){
        if degreeAngle > 80 && degreeAngle < 100{
            if !rotationGridState{
                triggerVibration()
                setRotation(angle: 90)
//                templateHandler.currentModel?.rotation = 90
                rotationGridState = true
            }
            return
        }
        else if degreeAngle < 190 && degreeAngle > 170{
            if !rotationGridState{
                triggerVibration()
                setRotation(angle: 180)
//                templateHandler.currentModel?.rotation = 180
                rotationGridState = true
            }
            return
        }
        else if degreeAngle < 280 && degreeAngle > 260{
            if !rotationGridState{
                triggerVibration()
                setRotation(angle: 270)
//                templateHandler.currentModel?.rotation = 270
                rotationGridState = true
            }
            return
        }
        else if (degreeAngle < 10 && degreeAngle > 0) || (degreeAngle > 350 && degreeAngle < 360){
            if !rotationGridState{
                triggerVibration()
                setRotation(angle: 360)
//                templateHandler.currentModel?.rotation = 360
                rotationGridState = true
            }
            return
        }
        else{
            rotationGridState = false
            setRotation(angle: Float(degreeAngle))
//            templateHandler.currentModel?.rotation = Float(degreeAngle)
        }
    }
    
    func setRotation(angle : Float){
        var baseFrame = templateHandler.currentModel!.baseFrame
        baseFrame.rotation = angle
        templateHandler.currentModel?.baseFrame = baseFrame
    }
    
}


func cornerPointsOfRotatedRect(rect: CGRect, angle: CGFloat , anchor: CGPoint? = nil ) -> [CGPoint] {
    // Calculate the center of the rectangle
    var center = CGPoint(x: rect.midX, y: rect.midY)
    
    if let anchor = anchor {
        center = anchor
    }
    // Calculate half width and half height of the rectangle
    let halfWidth = rect.width / 2.0
    let halfHeight = rect.height / 2.0
    
    // Convert the angle to radians
    let radians = angle * CGFloat.pi / 180.0
    
    // Calculate the sin and cos of the angle
    let sinTheta = sin(radians)
    let cosTheta = cos(radians)
    
    // Calculate the corner points of the rotated rectangle
    let topLeft = CGPoint(x: center.x + (-halfWidth * cosTheta - (-halfHeight * sinTheta)),
                          y: center.y + (-halfWidth * sinTheta + (-halfHeight * cosTheta)))
    
    let topRight = CGPoint(x: center.x + (halfWidth * cosTheta - (-halfHeight * sinTheta)),
                           y: center.y + (halfWidth * sinTheta + (-halfHeight * cosTheta)))
    
    let bottomRight = CGPoint(x: center.x + (halfWidth * cosTheta - (halfHeight * sinTheta)),
                              y: center.y + (halfWidth * sinTheta + (halfHeight * cosTheta)))
    
    let bottomLeft = CGPoint(x: center.x + (-halfWidth * cosTheta - (halfHeight * sinTheta)),
                             y: center.y + (-halfWidth * sinTheta + (halfHeight * cosTheta)))
    
    return [topLeft, topRight, bottomRight, bottomLeft]
}

public extension CGFloat {
    ///Returns radians if given degrees
    var radians: CGFloat{return self * .pi / 180}
}

public extension CGPoint {
    /// Rotates point by given degrees
    func rotate(origin: CGPoint? = CGPoint(x: 0.5, y: 0.5), _ byDegrees: CGFloat) -> CGPoint {
        guard let origin = origin else { return self }

        let rotationSin = sin(byDegrees.radians)
        let rotationCos = cos(byDegrees.radians)

        let xOffset = self.x - origin.x
        let yOffset = self.y - origin.y

        let x = xOffset * rotationCos - yOffset * rotationSin + origin.x
        let y = xOffset * rotationSin + yOffset * rotationCos + origin.y

        return CGPoint(x: x, y: y)
    }
}
