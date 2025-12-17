//
//  ParentInfo.swift
//  MetalEngine
//
//  Created by HKBeast on 28/07/23.
//

import Foundation
import Combine

//protocol ParentModelProtocol : BaseModelProtocol {}
public class ParentModel : BaseModel {
    
    func getCopy() -> ParentInfo{
        var parentInfo = ParentInfo()
        parentInfo.baseFrame = self.baseFrame
        parentInfo.baseTimeline = self.baseTimeline
        parentInfo.modelType = self.modelType
        parentInfo.modelFlipHorizontal = self.modelFlipHorizontal
        parentInfo.modelFlipVertical = self.modelFlipVertical
        parentInfo.orderInParent = self.orderInParent
        parentInfo.prevAvailableWidth = self.prevAvailableWidth
        parentInfo.prevAvailableHeight = self.prevAvailableHeight
        parentInfo.beginHighlightIntensity = self.beginHighlightIntensity
        parentInfo.beginOpacity = self.beginOpacity
        parentInfo.filterType = self.filterType
        parentInfo.lockStatus = self.lockStatus
        parentInfo.hasMask = self.hasMask
               parentInfo.maskShape = self.maskShape
        parentInfo.parentId = self.parentId
        parentInfo.templateID = self.templateID
        parentInfo.bgBlurProgress = self.bgBlurProgress
        parentInfo.brightnessIntensity = self.brightnessIntensity
        parentInfo.colorAdjustmentType = self.colorAdjustmentType
        parentInfo.contrastIntensity = self.contrastIntensity
        parentInfo.highlightIntensity = self.highlightIntensity
        parentInfo.inAnimation = self.inAnimation
        parentInfo.outAnimation = self.outAnimation
        parentInfo.loopAnimation = self.loopAnimation
        parentInfo.modelOpacity = self.modelOpacity
        parentInfo.saturationIntensity = self.saturationIntensity
        parentInfo.shadowsIntensity = self.shadowsIntensity
        parentInfo.sharpnessIntensity = self.sharpnessIntensity
        parentInfo.softDelete = self.softDelete
        parentInfo.thumbImage = self.thumbImage
        parentInfo.tintIntensity = self.tintIntensity
        parentInfo.warmthIntensity = self.warmthIntensity
        parentInfo.vibranceIntensity = self.vibranceIntensity
        parentInfo.dataId = self.dataId
        parentInfo.depthLevel = self.depthLevel
        parentInfo.center = self.center
        parentInfo.duration = self.duration
        parentInfo.height = self.height
        parentInfo.identity = self.identity
        parentInfo.inAnimationDuration = self.inAnimationDuration
        parentInfo.outAnimationDuration = self.outAnimationDuration
        parentInfo.loopAnimationDuration = self.loopAnimationDuration
        parentInfo.isHidden = self.isHidden
        parentInfo.isActive = self.isActive
        parentInfo.isSelectedForMultiSelect = self.isSelectedForMultiSelect
        parentInfo.overlayOpacity = self.overlayOpacity
        parentInfo.overlayDataId  = self.overlayDataId
        parentInfo.posX = self.posX
        parentInfo.posY =  self.posY
        parentInfo.rotation = self.rotation
        parentInfo.width = self.width
        parentInfo.startTime = self.startTime
        parentInfo.size = self.size
        parentInfo.children = self.children
        return parentInfo
    }
    
    
    
    @Published public var children = [ BaseModel ]()
    
    public var activeChildren: [BaseModel] {
        // Filter the children where softDelete is false
//        return children.filter { !$0.softDelete }
        return children.filter { child in
            // Ensure `softDelete` is false
            guard !child.softDelete else { return false }
            
            // Check if the child is a ParentModel with non-empty children, or just include the child if it's not a ParentModel
//            if let parentModel = child as? ParentModel {
//                return !parentModel.children.isEmpty
//            } else {
                return true
          //  }
        }
    }
    
    // it will forcefully update is expand State because is expanded is depend on editState
    @Published public var editState : Bool = false
    
    @Published var isExpanded : Bool = false
    
    init() {
        super.init()
        identity = "Parent"
    }
    override func updateDepthLevelForChildren() {
        for child in children {
            child.depthLevel = self.depthLevel + 1
            child.updateDepthLevelForChildren()
        }
    }
   override func findNodeByID(_ nodeID: Int) -> BaseModel? {
        if self.modelId == nodeID {
            return self
        }

        for child in children {
            if let foundNode = child.findNodeByID(nodeID) {
                return foundNode
            }
        }

        return nil
    }
    
    func increaseOrderFromIndex(_ index: Int) {
          guard isParent, index >= 0, index < children.count  else {
              // If not a parent or index is out of bounds, or no order + 1 children exist, return.
              return
          }

        for i in index...children.count-1  {
              children[i].orderInParent = children[i].orderInParent + 1
//              let child = children[i+1].modelId
            print("model Id \(children[i].modelId) increase newOrder \(children[i].orderInParent)")
             _ = DBManager.shared.updateOrderInParent(modelId: children[i].modelId, newValue: children[i].orderInParent)
          }
      }
    
    func increaseOrderFromIndex(_ index: Int,to:Int) {
          guard isParent, index >= 0, index < children.count  else {
              // If not a parent or index is out of bounds, or no order + 1 children exist, return.
              return
          }

        for i in index...to  {
              children[i].orderInParent = children[i].orderInParent + 1
//              let child = children[i+1].modelId
            print("model Id \(children[i].modelId) increase newOrder \(children[i].orderInParent)")
             _ = DBManager.shared.updateOrderInParent(modelId: children[i].modelId, newValue: children[i].orderInParent)
          }
      }
    
    func increaseOrderInParent(_ index: Int) {
          guard isParent, index >= 0, index < children.count  else {
              // If not a parent or index is out of bounds, or no order + 1 children exist, return.
              return
          }

        // This helper is unsafe as-written (i+1 can overflow); prefer changeOrder. Keep it safe for legacy callers.
        for i in index..<children.count {
            children[i].orderInParent = i
            _ = DBManager.shared.updateOrderInParent(modelId: children[i].modelId, newValue: children[i].orderInParent)
        }
      }
    
    
    func decreaseOrderFromIndex(_ index: Int) {
          guard isParent, index >= 0, index < children.count else {
              // If not a parent or index is out of bounds, or no order + 1 children exist, return.
              return
          }

        for i in index...children.count - 1 {
              children[i].orderInParent = children[i].orderInParent - 1
            print("model Id \(children[i].modelId) decrease newOrder \(children[i].orderInParent)")
            _ = DBManager.shared.updateOrderInParent(modelId: children[i].modelId, newValue: children[i].orderInParent)
          }
      }
    
    func decreaseOrderFromIndex(_ index: Int,to:Int) {
          guard isParent, index >= 0, index <= to else {
              // If not a parent or index is out of bounds, or no order + 1 children exist, return.
              return
          }

        for i in index...to{
              children[i].orderInParent = children[i].orderInParent - 1
            print("model Id \(children[i].modelId) decrease newOrder \(children[i].orderInParent)")
            _ = DBManager.shared.updateOrderInParent(modelId: children[i].modelId, newValue: children[i].orderInParent)
          }
      }
    //method to change level of every child
    func increaseChildLevel(newLevel: Int, logger: PackageLogger?) {
        if self.isParent{
            guard let parentableChilds = children.map({$0 as? ParentModel}) as? [ParentModel] else {
                logger?.printLog("Parentable childs nil \(#function)")
                return }
            parentableChilds.forEach { $0.increaseChildLevel(newLevel: newLevel + 1, logger: logger) }
        }
    }
    
    func decreaseChildLevel(newLevel: Int, logger: PackageLogger?) {
            
        if self.isParent{
            guard let parentableChilds = children.map({$0 as? ParentModel}) as? [ParentModel] else {
                logger?.printLog("Parentable childs nil \(#function)")
                return }

            parentableChilds.forEach { $0.decreaseChildLevel(newLevel: newLevel - 1, logger: logger) }
        }
    }
    
   
    
}

public class ParentInfo:ParentModel{
//    var templateID: Int = -1

    // Text
//    @Published var oldText: String = ""
//    @Published var newText: String = ""
//    
    //override the model type.
    override public var modelType: ContentType {
            get { return .Parent }
            set { }
        }
    
//    @Published var children = [ BaseModelProtocol ]()
  
  
    func setBaseModel(baseModel:DBBaseModel,refSize: CGSize){
        modelId = baseModel.modelId
        parentId = baseModel.parentId
        modelType = ContentType(rawValue: baseModel.modelType) ?? .Sticker
        dataId = baseModel.dataId
        posX = (baseModel.posX).toFloat() * Float(refSize.width)
        posY = (baseModel.posY).toFloat() * Float(refSize.height)
        width = (baseModel.width).toFloat() * Float(refSize.width)
        height = (baseModel.height).toFloat() * Float(refSize.height)
        prevAvailableWidth = (baseModel.prevAvailableWidth).toFloat() * Float(refSize.width)
        prevAvailableHeight = (baseModel.prevAvailableHeight).toFloat() * Float(refSize.height)
        rotation = (baseModel.rotation).toFloat()
        modelOpacity = (baseModel.modelOpacity).toFloat()/255.0
        modelFlipHorizontal = baseModel.modelFlipHorizontal.toBool()
        modelFlipVertical = baseModel.modelFlipVertical.toBool()
        lockStatus = baseModel.lockStatus.toBool()
        orderInParent = baseModel.orderInParent
        bgBlurProgress = baseModel.bgBlurProgress.toFloat()
        overlayDataId = baseModel.overlayDataId
        overlayOpacity = baseModel.overlayOpacity.toFloat()
        startTime = (baseModel.startTime).toFloat()
        duration = (baseModel.duration).toFloat()
        softDelete = baseModel.softDelete.toBool()
        isHidden = baseModel.isHidden
        templateID = baseModel.templateID
        hasMask = baseModel.hasMask.toBool()
        maskShape = baseModel.maskShape

        baseFrame = Frame(size: CGSize(width: Double(baseModel.width * Double(refSize.width)), height: Double(baseModel.height * Double(refSize.height))), center: CGPoint(x: Double(baseModel.posX * Double(refSize.width)), y: Double(baseModel.posY * Double(refSize.height))), rotation: self.rotation)
        beginFrame = baseFrame
        endFrame = baseFrame
        baseTimeline = StartDuration(startTime: (baseModel.startTime).toFloat(), duration: (baseModel.duration).toFloat())
        beginBaseTimeline = baseTimeline
        endBaseTimeline = baseTimeline
    }
    
    
   
    
    func getBaseModel(refSize:CGSize) -> DBBaseModel {
       return DBBaseModel(
        hasMask: hasMask.toInt(), maskShape: maskShape, parentId: parentId,
        modelId: modelId,
        modelType: modelType.rawValue,
        dataId: dataId,
        posX: (baseFrame.center.x).toDouble()/refSize.width,
        posY: (baseFrame.center.y).toDouble()/refSize.height,
        width: (baseFrame.size.width).toDouble()/refSize.width,
        height: (baseFrame.size.height).toDouble()/refSize.height,
        prevAvailableWidth: (prevAvailableWidth).toDouble()/refSize.height,
        prevAvailableHeight: (prevAvailableHeight).toDouble()/refSize.height,
        rotation: (baseFrame.rotation).toDouble(),
        modelOpacity: (modelOpacity).toDouble()*255.0,
        modelFlipHorizontal: modelFlipHorizontal.toInt(),
        modelFlipVertical: modelFlipVertical.toInt(),
        lockStatus: lockStatus.toString(),
        orderInParent: orderInParent,
        bgBlurProgress: bgBlurProgress.toInt(),
        overlayDataId: overlayDataId,
        overlayOpacity: overlayOpacity.toInt(),
        //        startTime: (startTime).toDouble(),
        //        duration: (duration).toDouble(),
        startTime: (baseTimeline.startTime).toDouble(),
        duration: (baseTimeline.duration).toDouble(),
        softDelete: softDelete.toInt(),
        isHidden: isHidden,
        templateID: templateID
       )
   }
    
    static func createParentInfo(parentModel:BaseModel)->ParentInfo{
        var defaultParentInfo = ParentInfo()
        defaultParentInfo.baseFrame = Frame(size: CGSize(width: parentModel.baseFrame.size.width/2, height: parentModel.baseFrame.size.height/2), center: CGPoint(x: parentModel.baseFrame.size.width/2, y: parentModel.baseFrame.size.height/2), rotation: 0)
        defaultParentInfo.parentId = parentModel.modelId
        defaultParentInfo.templateID = parentModel.templateID
     
//        defaultParentInfo.modelId = id
        return defaultParentInfo
    }
    
//    func decreaseOrderOFChildren(at order:Int){
//        for child in children.suffix(from: order){
//            child.orderInParent -= 1
//        }
//    }
//    
//    func increaseOrderOFChildren(at order:Int){
//        for child in children.suffix(from: order){
//            child.orderInParent += 1
//        }
//    }
    
    

}

extension ParentModel {
    
    func addChild(child:BaseModel){
        self.children.append(child)
    }
    
    func addChild(_ child:BaseModel ,at index: Int){
        self.children.insert(child, at: index)
    }
    func removeChild(at index: Int ) {
        self.children.remove(at: index)
    }
    
    func changeOrder(child:BaseModel,oldOrder:Int,newOrder:Int) {
//        guard oldOrder != newOrder else {
//               print("No change in order.")
//               return
//           }
//        
//                // If moving up in the order (from higher index to lower index)
//                   if oldOrder > newOrder {
//                       // Move the child from old position to the new position
//                       addChild(child, at: newOrder)
//                       print("scene addChild",newOrder+1)
//                       
//                       child.orderInParent = newOrder
//                       removeChild(at: oldOrder+1)
//                       increaseOrderFromIndex(newOrder+1, to: oldOrder)
//                     
//                   }
//                   // If moving down in the order (from lower index to higher index)
//                   else if oldOrder < newOrder {
//                       // Move the child from old position to the new position
//                       addChild(child, at: newOrder + 1)
//                     
//                       print("scene addChild",newOrder)
//                       child.orderInParent = newOrder
//                       removeChild(at: oldOrder)
//                       decreaseOrderFromIndex(oldOrder, to: newOrder-1)
//
//                  
//                   }
        
        guard oldOrder != newOrder else { return }
        guard oldOrder >= 0, newOrder >= 0, oldOrder < children.count, newOrder < children.count else {
            print("changeOrder: bounds check failed old:\(oldOrder) new:\(newOrder) count:\(children.count)")
            return
        }

        // Remove and insert in the new position using current indices
        let moved = children.remove(at: oldOrder)
        children.insert(moved, at: newOrder)

        // Rewrite orders to match array indices and persist
        for (idx, child) in children.enumerated() {
            child.orderInParent = idx
            _ = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: idx)
        }
#if DEBUG
        assertOrderIntegrity(context: "changeOrder")
#endif
    }
    
#if DEBUG
    func assertOrderIntegrity(context: String) {
        for (idx, child) in children.enumerated() {
            if child.orderInParent != idx {
                print("[OrderIntegrity] mismatch in ParentModel at \(context): childId=\(child.modelId) order=\(child.orderInParent) idx=\(idx)")
            }
        }
    }
#endif
}
