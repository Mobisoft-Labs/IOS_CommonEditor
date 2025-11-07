//
//  GridManager.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 16/04/24.
//

import Foundation
import UIKit

public enum SnappingMode{
    case basic
    case advanced
    case off
}

enum GestureMode{
    case rotation
    case move
    case scale
    case dragScale
}

enum GridLineState {
    case MinX
    case MinY
    case MaxX
    case MaxY
    case CenterX
    case CenterY
}

struct SnappingData{
    var parentState : GridLineState
    var childState : GridLineState
    var modelID : Int
}

class GridManager: UIView {
    var currentPageView : UIView = UIView()
    var parentViewFrame : UIView = UIView()
    // Track snapping state
    var isSnappedToXCenter = false
    var isSnappedToYCenter = false
    
    var updatedRectForRotation : CGRect = CGRect.zero
    
    var xSnapped = false
    var ySnapped = false
    
    var updatedCenterX : CGFloat = 0.0
    var updatedCenterY : CGFloat = 0.0
    
    var snapIDNData : SnappingData? = nil
    
    var selectedDragHandle : String = ""
    
    var rotationGridState : Bool = false
    
    var degreeAngle : Double = 0.0
    
    var rotation : Double{
       let angle = Double(degreeAngle) * Double.pi / 180.0
        return angle
    }
    
    // Used for handle the gestures like rotation , move and scale.
    var gestureMode : GestureMode = .move
    
    // Used for handle the advanced and basic mode.
    var snappingMode : SnappingMode = .basic
    
    var currentViewSize : CGSize = CGSize(width: 200, height: 200)
    
    var rotatedRectForCurrentView : CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)
    
    var templateRotatedRect : CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)
    
    var templateMinPoint : CGPoint = CGPoint.zero
    
    var templateMaxPoint : CGPoint = CGPoint.zero
    
    var newCenter : CGPoint = CGPoint.zero
    
    var snapBreath : CGFloat = 1.5
    
    //This Dictionary contains closest child of the view.
    var closestChildDict : [Int : SnappingData] = [:]
    
    var closestChildDictY : [Int : SnappingData] = [:]
    
    // EditView for converted the point according to that
   weak var pageView : PageView!

    
    // MinXPoint Array.
    var minXArray : [Int : CGPoint] {
        return getMinXArray()
    }
    
    // MaxXPoint Array.
    var maxXArray :  [Int : CGPoint] {
       return getMaxXArray()
    }
    
    // CenterXPoint Array.
    var centerXArray : [Int : CGPoint] {
        return getCenterXArray()
    }
    
    // MinYPoint Array.
    var minYArray : [Int : CGPoint]{
        return getMinYArray()
    }
    
    // MaxYPoint Array.
    var maxYArray : [Int : CGPoint]{
        return getMaxYArray()
    }
    
    // CenterYPoint Array.
    var centerYArray : [Int : CGPoint]{
        return getCenterYArray()
    }
    
    // MARK: States For Advanced Line.
    
    var advancedMinXLine : Bool = false
    
    var advancedMaxXLine : Bool = false
    
    var advancedCenterXLine : Bool = false
    
    var advancedMinYLine : Bool = false
    
    var advancedMaxYLine : Bool = false
    
    var advancedCenterYLine : Bool = false
    
    // MARK: States For Vibraion.
    
    var advancedMinXLineState : Bool = false
    
    var advancedMaxXLineState : Bool = false
    
    var advancedCenterXLineState : Bool = false
    
    var advancedMinYLineState : Bool = false
    
    var advancedMaxYLineState : Bool = false
    
    var advancedCenterYLineState : Bool = false
    
    
    //Template Handler Class Reference.
   weak var templateHandler : TemplateHandler!
    
    var panView : UIView!
    
    var initialCenter = CGPoint.zero

    //States for the Grid Lines.
    
    // Edge Line Point State.
    var topEdgeLine : Bool = false
    var bottomEdgeLine : Bool = false
    var leftEdgeLine : Bool = false
    var rightEdgeLine : Bool = false
    
    // Ideal Line Point State.
    var topIdealLine : Bool = false
    var bottomIdealLine : Bool = false
    var leftIdealLine : Bool = false
    var rightIdealLine : Bool = false
    
    // Center Line Points State.
    var centerXLine : Bool = false
    var centerYLine : Bool = false
    
    // Edge Line Point State.
    var topEdgeState : Bool = true
    var bottomEdgeState : Bool = true
    var leftEdgeState : Bool = true
    var rightEdgeState : Bool = true
    
    // Ideal Line Point State.
    var topIdealState : Bool = true
    var bottomIdealState : Bool = true
    var leftIdealState : Bool = true
    var rightIdealState : Bool = true
    
    // Center Line Points State.
    var centerXState : Bool = true
    var centerYState : Bool = true
    
    
    //MARK: - Rotation Line and Handling State.
    var rightDottedLineDraw : Bool = false
    var leftDottedLineDraw : Bool = false
    var topDottedLineDraw : Bool = false
    var bottomDottedLineDraw : Bool = false
    var rotatedDottedLineDraw : Bool = false
    
    var rightDottedLineState : Bool = false
    var leftDottedLineState : Bool = false
    var topDottedLineState : Bool = false
    var bottomDottedLineState : Bool = false
    //MARK: - Rotation Line and Handling State End.
    
    
    init(frame: CGRect, templateHandler : TemplateHandler, pageView : PageView) {
        self.templateHandler = templateHandler
        self.pageView = pageView
        super.init(frame: frame)
        self.snappingMode = templateHandler.currentActionState.snappingMode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Model MIN , MAX, CENTER Array Calculation Start.
    // Function for getting the MinXPoints Array.
    func getMinXArray() -> [Int : CGPoint]{
        // MinX Array
        var minXArray : [Int : CGPoint] = [:]
        // Get all values from the dictionary
//        let allModels = Array(templateHandler.childDict.values)
        
        let allPageChildrenModels = templateHandler.getChildrenFor(parentID: templateHandler.currentSuperModel!.modelId)
        
        //Iterate into the array and get the MinX Point.
        for model in allPageChildrenModels{
            if model.modelId != templateHandler.currentModel?.modelId && isViewAvailableOrNot(model: model){
          
                let rotation =  Double(model.baseFrame.rotation) * Double.pi / 180.0
        
                let rect = CGRect(x: CGFloat(model.baseFrame.center.x - model.baseFrame.size.width/2), y: CGFloat(model.baseFrame.center.y - model.baseFrame.size.height/2), width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
                
                let rotatedRect = rect.rotatedRect(withAngle: rotation)
                
                let minXPoint = CGPoint(x: Double(rotatedRect.midX) - Double(model.baseFrame.size.width/2), y:Double(rotatedRect.midY) - Double(model.baseFrame.size.height/2))
                
                minXArray[model.modelId] = minXPoint
            }
        }
//        minXArray.append(CGPoint(x: 83.22, y: 167.11))
        return minXArray
    }
    
    // Function for getting the MaxXPoints Array.
    func getMaxXArray() -> [Int : CGPoint]{
        // MinX Array
        var maxXArray : [Int : CGPoint] = [:]
        // Get all values from the dictionary
//        let allModels = Array(templateHandler.childDict.values)
        
        let allPageChildrenModels = templateHandler.getChildrenFor(parentID: templateHandler.currentSuperModel!.modelId)
        
        //Iterate into the array and get the MinX Point.
        for model in allPageChildrenModels{
            if model.modelId != templateHandler.currentModel?.modelId && isViewAvailableOrNot(model: model){
                
                let rotation =  Double(model.baseFrame.rotation) * Double.pi / 180.0
        
                let rect = CGRect(x: CGFloat(model.baseFrame.center.x - model.baseFrame.size.width/2), y: CGFloat(model.baseFrame.center.y - model.baseFrame.size.height/2), width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
                
                let rotatedRect = rect.rotatedRect(withAngle: rotation)
                
                let maxXPoint = CGPoint(x: Double(rotatedRect.midX) + Double(rotatedRect.width/2), y:Double(rotatedRect.midY) + Double(rotatedRect.height/2))
                
                maxXArray[model.modelId] = maxXPoint
            }
        }
//        maxXArray.append(CGPoint(x: 289.83, y: 167.11))
        return maxXArray
    }
    
    
    // Function for getting the CenterXPoints Array.
    func getCenterXArray() -> [Int : CGPoint]{
        // MinX Array
        var centerXArray : [Int : CGPoint] = [:]
        // Get all values from the dictionary
//        let allModels = Array(templateHandler.childDict.values)
        let allPageChildrenModels = templateHandler.getChildrenFor(parentID: templateHandler.currentSuperModel!.modelId)
        
        //Iterate into the array and get the MinX Point.
        for model in allPageChildrenModels{
            if model.modelId != templateHandler.currentModel?.modelId && isViewAvailableOrNot(model: model){
                
                let rotation =  Double(model.baseFrame.rotation) * Double.pi / 180.0
        
                let rect = CGRect(x: CGFloat(model.baseFrame.center.x - model.baseFrame.size.width/2), y: CGFloat(model.baseFrame.center.y - model.baseFrame.size.height/2), width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
                
                let rotatedRect = rect.rotatedRect(withAngle: rotation)
                
                let centerXPoint = CGPoint(x: Double(rotatedRect.midX), y:Double(rotatedRect.midY))
                
                centerXArray[model.modelId] = centerXPoint
            }
        }
//        centerXArray.append(CGPoint(x: 186.45, y: 89.77))
        return centerXArray
    }
    
    
    // Function for getting the MinXPoints Array.
    func getMinYArray() -> [Int : CGPoint]{
        // MinX Array
        var minYArray : [Int : CGPoint] = [:]
        // Get all values from the dictionary
//        let allModels = Array(templateHandler.childDict.values)
        let allPageChildrenModels = templateHandler.getChildrenFor(parentID: templateHandler.currentSuperModel!.modelId)
        
        //Iterate into the array and get the MinX Point.
        for model in allPageChildrenModels{
            if model.modelId != templateHandler.currentModel?.modelId && isViewAvailableOrNot(model: model){

                let rotation =  Double(model.baseFrame.rotation) * Double.pi / 180.0
        
                let rect = CGRect(x: CGFloat(model.baseFrame.center.x - model.baseFrame.size.width/2), y: CGFloat(model.baseFrame.center.y - model.baseFrame.size.height/2), width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
                
                let rotatedRect = rect.rotatedRect(withAngle: rotation)
                
                let minYPoint = CGPoint(x: Double(rotatedRect.midX) - Double(rotatedRect.width/2), y:Double(rotatedRect.midY) - Double(rotatedRect.height/2))
                
                minYArray[model.modelId] = minYPoint
            }
        }
//        minYArray.append(CGPoint(x: 83.22, y: 12.43))
        return minYArray
    }
    
    // Function for getting the MaxXPoints Array.
    func getMaxYArray() -> [Int : CGPoint]{
        // MinX Array
        var maxYArray : [Int : CGPoint] = [:]
        // Get all values from the dictionary
//        let allModels = Array(templateHandler.childDict.values)
        let allPageChildrenModels = templateHandler.getChildrenFor(parentID: templateHandler.currentSuperModel!.modelId)
        
        //Iterate into the array and get the MinX Point.
        for model in allPageChildrenModels{
            if model.modelId != templateHandler.currentModel?.modelId && isViewAvailableOrNot(model: model){
                
                let rotation =  Double(model.baseFrame.rotation) * Double.pi / 180.0
        
                let rect = CGRect(x: CGFloat(model.baseFrame.center.x - model.baseFrame.size.width/2), y: CGFloat(model.baseFrame.center.y - model.baseFrame.size.height/2), width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
                
                let rotatedRect = rect.rotatedRect(withAngle: rotation)
                
                let maxYPoint = CGPoint(x: Double(rotatedRect.midX) + Double(rotatedRect.width/2), y:Double(rotatedRect.midY) + Double(rotatedRect.height/2))
                
                maxYArray[model.modelId] = maxYPoint
            }
        }
//        maxYArray.append(CGPoint(x: 290.33, y: 167.11))
        return maxYArray
    }
    
    
    // Function for getting the CenterXPoints Array.
    func getCenterYArray() -> [Int : CGPoint]{
        // MinX Array
        var centerYArray : [Int : CGPoint] = [:]
        // Get all values from the dictionary
//        let allModels = Array(templateHandler.childDict.values)
        let allPageChildrenModels = templateHandler.getChildrenFor(parentID: templateHandler.currentSuperModel!.modelId)
        
        //Iterate into the array and get the MinX Point.
        for model in allPageChildrenModels{
            if model.modelId != templateHandler.currentModel?.modelId && isViewAvailableOrNot(model: model){
                
                let rotation =  Double(model.baseFrame.rotation) * Double.pi / 180.0
        
                let rect = CGRect(x: CGFloat(model.baseFrame.center.x - model.baseFrame.size.width/2), y: CGFloat(model.baseFrame.center.y - model.baseFrame.size.height/2), width: CGFloat(model.baseFrame.size.width), height: CGFloat(model.baseFrame.size.height))
                
                let rotatedRect = rect.rotatedRect(withAngle: rotation)
                
                let centerYPoint = CGPoint(x: Double(rotatedRect.midX), y:Double(rotatedRect.midY))
                
                centerYArray[model.modelId] = centerYPoint
            }
        }
//        centerYArray.append(CGPoint(x: 186.45, y: 89.77))
        return centerYArray
    }
    // MARK: - Array Calculation END.
    
    //Function used for checking the view is exist on the screen or not.
    func isViewAvailableOrNot(model : BaseModel) -> Bool{
        let currentTime = templateHandler.playerControls?.currentTime ?? 0.0
        let startPos = model.baseTimeline.startTime - currentTime
        let endPos = (model.baseTimeline.startTime + model.baseTimeline.duration) - currentTime
        if startPos >= 0 && endPos >= 0 {
            return false
        }
        else {
            return true
        }
    }
    
    // Function to trigger vibration when snapping occurs
     func triggerVibration() {
         let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
         impactFeedbackGenerator.impactOccurred()
     }
    
    //Draw function for drawing the line.
    override func draw(_ rect: CGRect) {
          let context = UIGraphicsGetCurrentContext()
          context?.setFillColor(UIColor.clear.cgColor)
          context?.fill(rect)
        if let context = context{
            updateGridLineView(context: context)
            drawAdvancedLine(context: context)
            drawRotationLine(context: context)
        }
      }
    
    
    var minPoint : CGPoint = .zero
    var maxPoint : CGPoint = .zero
    
    
    func snapIfNeeded(for angleInDegree : Double, currentParentView: UIView, rootView : UIView){
        degreeAngle = angleInDegree
        if snappingMode == .off{
            templateHandler.currentModel?.baseFrame.rotation = Float(angleInDegree)
            return
        }
        snapForRotationIfNeeded(rotation: degreeAngle, currentParentView: currentParentView, rootView: rootView)
    }

    
    //Function that snap the value if needed.
    func snapIfNeeded(currentViewCenter : CGPoint, currentViewSize : CGSize, rotation : Double, parentViewFrame : UIView, currentPageView : UIView){
        self.parentViewFrame = parentViewFrame
        self.currentPageView = currentPageView
        if snappingMode == .off{
            templateHandler.currentModel?.baseFrame = Frame(size: currentViewSize, center: currentViewCenter, rotation: Float(rotation))
            return
        }
        
        templateHandler.selectedNearestSnappingChildID = 0
            degreeAngle = rotation
            newCenter = currentViewCenter
            minPoint = CGPoint(x: Double(currentViewCenter.x - currentViewSize.width/2), y:  Double(currentViewCenter.y - currentViewSize.height/2))
            maxPoint = CGPoint(x: Double(currentViewCenter.x + currentViewSize.width/2), y:  Double(currentViewCenter.y + currentViewSize.height/2))
        
        self.currentViewSize = currentViewSize
        
        templateMinPoint = CGPoint(x: Double(templateHandler.currentModel!.baseFrame.center.x - templateHandler.currentModel!.baseFrame.size.width/2), y:  Double(templateHandler.currentModel!.baseFrame.center.y - templateHandler.currentModel!.baseFrame.size.height/2))
        
        templateMaxPoint = CGPoint(x: Double(templateHandler.currentModel!.baseFrame.center.x + templateHandler.currentModel!.baseFrame.size.width/2), y:  Double(templateHandler.currentModel!.baseFrame.center.y + templateHandler.currentModel!.baseFrame.size.height/2))
        
         let rotation =  Double(rotation) * Double.pi / 180.0
        
        rotatedRectForCurrentView = CGRect(x: minPoint.x, y: minPoint.y, width: currentViewSize.width, height: currentViewSize.height).rotatedRect(withAngle: rotation)
        
        templateRotatedRect =  CGRect(x: templateMinPoint.x, y: templateMinPoint.y, width: CGFloat(templateHandler.currentModel!.baseFrame.size.width), height: CGFloat(templateHandler.currentModel!.baseFrame.size.height)).rotatedRect(withAngle: rotation)
        
        templateRotatedRect = currentPageView.convert(templateRotatedRect, from: parentViewFrame)
        
        
        let minRotatedPoints = CGPoint(x: templateRotatedRect.minX, y: templateRotatedRect.minY)
        let maxRotatedPoints = CGPoint(x: templateRotatedRect.maxX, y: templateRotatedRect.maxY)
        
        if snappingMode == .advanced{
            //manageState()
            if gestureMode == .dragScale ||   gestureMode == .scale{
//                gestureMode = .scale
                manageAdvanceGridLinesForDragScale(currentViewCenter: newCenter, currentViewSize: currentViewSize)
                //manageGridLinesForDragScale(currentViewCenter: newCenter, currentViewSize: currentViewSize)
            }
            else{
                manageAdvanceGridLines(currentViewCenter: newCenter, currentViewSize: currentViewSize)
            }
            self.setNeedsDisplay()
        }
        else {
            updateGridLineStateWithNewCenterPoint(centerPoint: CGPoint(x: templateRotatedRect.midX, y: templateRotatedRect.midY), minPoint: minRotatedPoints, maxPoint: maxRotatedPoints)
            setNeedsDisplay()
            if gestureMode == .dragScale || gestureMode == .scale{
               // templateHandler.currentModel?.baseFrame = Frame(size: currentViewSize, center: currentViewCenter, rotation: Float(degreeAngle))
                manageSnappingForScalingInBasicMode(currentViewSize: currentViewSize, currentCenter: newCenter)
            }
            
            else if !snapIfNeeded(centerPoint: newCenter, minPoint: minRotatedPoints, maxPoint: maxRotatedPoints){
                var baseFrame = templateHandler.currentModel?.baseFrame
                baseFrame?.center = currentViewCenter
                templateHandler.currentModel?.baseFrame = baseFrame!
                
            }
        }
    }
    
}
