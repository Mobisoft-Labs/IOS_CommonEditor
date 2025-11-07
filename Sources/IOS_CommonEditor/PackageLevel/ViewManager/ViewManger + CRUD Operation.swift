//
//  ViewManger + CRUD Operation.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 02/04/24.
//

import Foundation

extension ViewManager {
    
    func ratioDidChange(page:PageInfo){
        DispatchQueue.main.async{ [weak self] in
            self?.rootView?.replacePage(newPageInfo: page, templateHandler: self!.templateHandler!)
            self?.updateGridMangerIfNeeded()

        }
    }
    func replacePage(newPageInfo: PageInfo) {
        DispatchQueue.main.async{ [weak self] in
            self?.rootView?.replacePage(newPageInfo: newPageInfo, templateHandler: self!.templateHandler!)
        }
    }
    
    public func removePage(){
        rootView?.removeCurrentPage()
       
       // controlBarView?.view.removeFromSuperview()
    }
    
    public func addPage(pageInfo:PageInfo) {
        guard let rootView = self.rootView , let templateHandler = templateHandler else {
            return
        }
        rootView.addPage(pageInfo: pageInfo, templateHandler: templateHandler)
        updateGridMangerIfNeeded()
        
    }
}


extension ViewManager{
    
    func addChild(info : BaseModel , toParenID: Int ){
        
        
        // lets ask RootView To Give Me Parent For This Sticker
        guard let parentView = rootView?.hasChild(id:toParenID) as? ParentView else {
            logger.logError( "ParentView Nil")
            return
        }
        switch info.modelType {
        case .Sticker:
            parentView.addStickerView(stickerInfo: info as! StickerInfo)
        case .Text:
            parentView.addTextView(textInfo: info as! TextInfo)
        case .Parent:
            parentView.addParentView(parentInfo: info as! ParentInfo)
        default:
            logger.logError("Model Type Bug")
            break;
        }
        
    }
    
    
    
    func expandParent(parentID:Int) {
        
        guard let parentView = rootView?.hasChild(id: parentID) as? ParentView else {
            logger.logError("parentView Nil")
            return
        }
        
        guard let templateHandler = templateHandler else {
            logger.logError("templateHandler Nil")
            return
        }
        let children = templateHandler.getChildrenFor(parentID: parentID)
        parentView.isExpanding = true
        parentView.addChildren(children: children)
        parentView.isExpanding = false
        logger.logVerbose("Parent Expanded In ViewManger With \(children.count) children added")
    }
    
    func collapseParent(parentId:Int) {
        
        guard let parentView = rootView?.hasChild(id: parentId) as? ParentView else {
            logger.logError("parentView Nil")
            return
        }
        guard let templateHandler = templateHandler else {
            logger.logError("templateHandler Nil")
            return
        }
        
        let children = templateHandler.getChildrenFor(parentID: parentId)
        parentView.isCollapsing = true
        parentView.removeChildren(children: children)
        parentView.isCollapsing = false
        logger.logVerbose("Parent Collapsed In ViewManger With \(children.count) children Removed")
        
    }
   
    

    
    func removeChild(childID:Int,parentId:Int) {
        
        
        guard let childView = rootView?.hasChild(id: childID)  else {
            logger.logError("child alredy not exist")
            return
        }
        guard let parentView = childView.parentView else {
            logger.logError("parentView Nil")
            return
        }
        
        parentView.removeChild(childView)
        
    }

    func moveChild(childId:Int, withProperties baseFrame : Frame , orderInParent: Int, flipH:Bool,flipV:Bool, to newParentID : Int , from oldParentID : Int) {
        
        removeChild(childID: childId, parentId: oldParentID)
        
        var currentParentView : ParentView?
        
        defer {
            
            
           
        }

        currentParentView = rootView?.hasChild(id: newParentID) as? ParentView
        
        if currentParentView == nil {
            logger.logError("MM Parent not created.Should'nt Be Called ")
            let parentModel = templateHandler?.getModel(modelId: newParentID) as? ParentInfo
            guard let parentModel = parentModel else {
                logger.logError("MM Parent Model does not exist insde the child dict.")
                return }
            logger.logError("KN Parent Model \(parentModel)")
            guard  let myParentView = rootView?.hasChild(id: parentModel.modelId) as? ParentView  else {
                logger.logError("PArentNIL MM")
                return }
            myParentView.addParentView(parentInfo: parentModel)
            currentParentView = rootView?.viewWithTag(newParentID) as? ParentView
        }
        
        let parentModelInfo = templateHandler?.getModel(modelId: newParentID)
        
       
        if    parentModelInfo is PageInfo || (parentModelInfo as! ParentInfo).editState{
            
            if let childModel = templateHandler?.getModel(modelId: childId) {
                
                childModel.parentId = newParentID
                childModel.baseFrame = baseFrame
                childModel.orderInParent = orderInParent
                childModel.modelFlipHorizontal = flipH
                childModel.modelFlipVertical = flipV
                addChild(info: childModel, toParenID: newParentID)
                
            }
        }

    }

    func removeParentAndChildren(parentID: Int) {
        if let currentParentView = rootView?.viewWithTag(parentID) as? ParentView {
            let superParent = currentParentView.parentView
            superParent?.removeChild(currentParentView)
        }
                
    }

    func redrawParentAndChildren(parentID: Int, parentSize : Frame) {
        // Redraw the parent and its children
        let parentInfo = templateHandler?.getModel(modelId: parentID) as? ParentInfo
        parentInfo?.baseFrame = parentSize
        
        guard let parentInfo = parentInfo , let parentView = rootView?.viewWithTag(parentInfo.parentId) as? ParentView else {
            logger.logError("moveModel - Expected parent view Not Found")
                return
        }
        parentView.addParentView(parentInfo: parentInfo)
    }

    func handleInvalidMove(childID: Int, parentID: Int) {
        // Handle cases where the move is invalid
        logger.logError("Parent is not exist.")
    }

    func isParentEmpty(parentID: Int) -> Bool {
        // Check if the parent has no children
        let parentView = rootView?.viewWithTag(parentID) as? ParentView
        if let parentView = parentView{
            if parentView.name == "PAGE" { return false }
            if parentView.childrens.isEmpty {
                return true
            }
        }
        return false

    }

    func removeParent(parentID: Int) {
        // Remove the parent from the model
        guard  let parentView = rootView?.viewWithTag(parentID) as? BaseView else {
            logger.logError("moveModel - Expected parent view Not Found")
            return
        }
       if let  myParentView = parentView.parentView  {
            if parentView.name != "PAGE"{
                myParentView.removeChild(parentView)
           }
        }
        
     
         
        
    }
}


extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        // Return unique elements from the sequence
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}


