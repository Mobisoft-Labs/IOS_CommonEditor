//
//  TemplateHandler.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 28/03/24.
//

import Foundation
import SwiftUI
import Combine

protocol TemplateHandlerProtocol {
   
}
protocol AnimationRepositoryStorable {
    var AnimationsTemplates : [DBAnimationTemplateModel]? { get set }
    var AnimationCategories : [DBAnimationCategoriesModel]? { get set }
    var KeyFrames : [DBAnimKeyframeModel]?  { get set }

    func getAnimationTemplate(for animTemplateID: Int) -> DBAnimationTemplateModel
    func getAnimationCategoryModel(for categoryId: Int) -> DBAnimationCategoriesModel
    func getKeyframes(for animationTempalteId : Int) -> [DBAnimKeyframeModel]
}





public class DataSourceRepository : AnimationRepositoryStorable {
    
    public static var shared : DataSourceRepository = DataSourceRepository()
    
    var logger: PackageLogger?
    
    deinit {
        logger?.printLog("Neeshu deinited")
    }
    
    init() {
        
    }
    
    func setPackageLogger(logger: PackageLogger){
        self.logger = logger
    }
    
    func cleanUp() {
        AnimationCategories = nil
        AnimationsTemplates = nil
        KeyFrames = nil
//        AnimationCategories.removeAll()
//        AnimationsTemplates.removeAll()
//        KeyFrames.removeAll()
    }
    
   lazy var AnimationsTemplates : [DBAnimationTemplateModel]? =  {
        return DBManager.shared.getAllAnimationTemplate()
    }()
    
    lazy var AnimationCategories : [DBAnimationCategoriesModel]?  = {
        return DBManager.shared.getAnimationCategory()
    }()
    
    lazy var KeyFrames : [DBAnimKeyframeModel]? = {
        return DBManager.shared.getAllKEyFrameModel()
    }()
    
    lazy public var getUniqueStickerCategories: [String] = {
        let stickerImages = StickerDBManager.shared.getStickerImages()
        
        let stickerInfo = StickerDBManager.shared.getStickerInfo(resID: stickerImages)
        
        return Array(Set(stickerInfo.values)).sorted()
    }()
    
//    lazy var getStickerInfo: [String:String] = {
//        let stickerImages = StickerDBManager.shared.getStickerImages()
//        
//        return StickerDBManager.shared.getStickerInfo(resID: stickerImages)
//    }()
    
    lazy public var getStickerInfo: [StickerModel] = {
        return StickerDBManager.shared.getAllStickerInfo()
    }()
     
    public func getTemplateColorArray(templateID: Int) -> [UIColor]{
        return DBManager.shared.fetchTemplateColors(templateID: templateID)
    }
    
    public func getAllAnimationTemplates() -> [DBAnimationTemplateModel]{
        return DBManager.shared.getAllAnimationTemplate()
    }
    
    public func getAllAnimationCategories() -> [DBAnimationCategoriesModel]{
        return DBManager.shared.getAnimationCategory()
    }
    
    func getAnimationTemplate(for animTemplateID: Int) -> DBAnimationTemplateModel {
        return AnimationsTemplates?.filter({$0.animationTemplateId == animTemplateID}).first ?? DBAnimationTemplateModel()
    }
    
    func getAnimationCategoryModel(for categoryId: Int) -> DBAnimationCategoriesModel {
        return AnimationCategories?.filter({$0.animationCategoriesId == categoryId}).first ?? DBAnimationCategoriesModel()
    }
    
    func getKeyframes(for animationTempalteId : Int) -> [DBAnimKeyframeModel] {
        return KeyFrames?.filter({$0.animationTemplateId == animationTempalteId}) ?? []
    }
    
//    func getStickerInfo() -> [String:String]{
//        let stickerImages = StickerDBManager.shared.getStickerImages()
//        
//        return StickerDBManager.shared.getStickerInfo(resID: stickerImages)
//    }
    
//    func getUniqueStickerCategories() -> [String]{
//        
//        let stickerImages = StickerDBManager.shared.getStickerImages()
//        
//        let stickerInfo = StickerDBManager.shared.getStickerInfo(resID: stickerImages)
//        
//        return Array(Set(stickerInfo.values)).sorted()
//    }
    
    
    public func fetchAnimationInfo(for templateId : Int) -> AnimTemplateInfo {
        var animTemplateInfo = AnimTemplateInfo()
        let templateModel =  getAnimationTemplate(for: templateId) //dbManager.getAnimationTemplates(for: templateID)
        let categoryModel =  getAnimationCategoryModel(for: templateModel.category) //dbManager.getAnimationCategories(for: templateModel.category)
        let keyFrameModels =  getKeyframes(for: templateModel.animationTemplateId)// dbManager.getKeyframeModel(for: templateModel.animationTemplateId)
        animTemplateInfo.setAnimationTemplate(animationTemplate: templateModel)
        animTemplateInfo.setAnimationCategory(animationCategory: categoryModel)
        animTemplateInfo.setKeyFrame(keyFrames: keyFrameModels)
        return animTemplateInfo
    }
   
}

//class PlayerControls : ObservableObject {
//   @Published var playStatus : SceneRenderingState = .Prepared
//   @Published var currentTime : Float = 0
//   @Published var duration : Float = 10
//    
//}

protocol DictCacheProtocol {
    var childDict : [Int : BaseModel] { get set }
    func cleanUp()
    func addModel(model: BaseModel)
    func removeModel(modelId:Int)
    func getModel(modelId : Int) -> BaseModel?
}


public class TemplateHandler  : TemplateHandlerProtocol,DictCacheProtocol, ObservableObject {
    
   
    
    public var logger: PackageLogger?
    var engineConfig: EngineConfiguration?
    
    deinit {
        logger?.printLog("de-init \(self)")
    }
    
    public func setPackageLogger(logger: PackageLogger, engineConfig: EngineConfiguration){
        self.logger = logger
        self.engineConfig = engineConfig
        currentActionState.setPackageLogger(logger: logger, actionStateConfig: engineConfig)
    }
    
    var deepSelectionInProgress :  Bool = false

    
    func currentPageStartTime() -> CGFloat {
        CGFloat(self.currentPageModel?.baseTimeline.startTime ?? 0.0)
    }
    
    func setCurrentTime(_ time: Float) {
        playerControls?.setCurrentTime(time)
    }
    
    var isPersonalizeActive : Bool = false
    // It store the id of nearest snapping child.
    @Published var selectedNearestSnappingChildID : Int = 0
    
//    @Published var uiStateManager : UIStateManager
    
    @Published var templateDuration : Double = 0.0
   public weak  var playerControls : TimeLoopHnadler?
    
    var cancellables = Set<AnyCancellable>()
    
    @Published public var renderingState : MetalEngine.RenderingState = .Animating
    
    @Published public var setSelectedModelChanged : BaseModel?
    
    // Manage the control View
    @Published public var selectedComponenet : Component = .base
    
    //    @Published var currentMusic: MusicInfo?
    
    //    var currentMusic: MusicInfo?
    
    
    var lastSelectedId: Int?
    
    var pageModelID: Int?
    //Action State that is used for performing actions like Delete , Replace and lock status.
    // var actionStates : [Int : ActionStates] = [:]
    
    //Contains the current action state.
    public var currentActionState = ActionStates()
    
    
    // contains export settings
    public var exportSettings = ExportSettings()
    
    //save current template info
    public var currentTemplateInfo:TemplateInfo?
    
    public var childDict : [Int : BaseModel] = [:]
    
    // Contains Reference of CurrentSticker Model.
    public var currentStickerModel : StickerInfo?
    
    // Contains Reference of CurrentText Model.
    public var currentTextModel : TextInfo?
    
    // Contains Reference of CurrentText Model.
    public var currentParentModel : ParentModel?
    
    // Contains Referance of Current Model Common Properties.
    public var currentModel : BaseModel?
    
    // Contains Referance of Page Model Common Properties.
    @Published public var currentPageModel : PageInfo?

    var prevSnappingChild : SnappingData = SnappingData(parentState: .CenterX, childState: .CenterX, modelID: -1)
    
    public init(){ }
    
    func cleanUp() {
        childDict.removeAll()
    }
    
    func addModel(model: BaseModel) {
        childDict[model.modelId] = model
        currentSuperModel?.children.append(model)
    }
    
    func removeModel(modelId:Int) {
        childDict.removeValue(forKey: modelId)
    }
    
    func getParentModel(for childID : Int) -> ParentModel? {
        return getModel(modelId: getModel(modelId: childID)!.parentId) as? ParentModel
    }
    
    
    func getModel(modelId : Int) -> BaseModel? {
        return childDict[modelId]
//        if let model = childDict[modelId], !model.softDelete {
//            return model
//        }
//        return nil
    }
    
    func getPageModelFromPageInfo() -> [MultiSelectedArrayObject]{
    var pageModelArray : [MultiSelectedArrayObject] = []
        for model in currentTemplateInfo!.pageInfo{
            if !model.softDelete{
                let page = MultiSelectedArrayObject(id: model.modelId, thumbImage: model.thumbImage, orderID: model.orderInParent)
                pageModelArray.append(page)
        }
    }
    return pageModelArray
}
    
    func getAllParentOfChild(childId:Int) -> [BaseModel] {
        var models = [BaseModel]()
        
        if let model = getModel(modelId: childId) {
            if let parentModel = getParentFor(childId: model.modelId) {
                // parent is available
                models.append(parentModel as! BaseModel)
                
                let parents =  getAllParentOfChild(childId: parentModel.modelId)
                
                models.append(contentsOf: parents)
                        
            }
            
        }
        
   return models

    }
    
    func requestParentModelsForCurrentChild(id:Int) -> [BaseModel] {
        var models = [BaseModel]()
        if let model = getModel(modelId: id) {
            if var parentModel = getModel(modelId: model.parentId) {
                models.append(parentModel)
                
                models.append(contentsOf: requestParentModelsForCurrentChild(id: parentModel.modelId))
            }
        }
        return models
    }
    
    func getAllChildModels(pageID: Int) -> [BaseModel] {
        var models = [BaseModel]()
        
        if let model = getModel(modelId: pageID) {
            models.append(model)
            let children = getChildrenFor(parentID: pageID)
            
            for child in children {
                if child.modelType == .Parent {
                    let parents = getAllChildModels(pageID: child.modelId)
//                    models.append(contentsOf: parents)
                }
                models.append(child)
            }
        }
        return models
    }
    
    func getAllParentOfModels(childID : Int) -> [BaseModel] {
        var models = [BaseModel]()
        if let model = getModel(modelId: childID){
            models.append(model)
            if model.modelType != .Page{
                let parents = getAllParentOfModels(childID: model.parentId)
                models.append(contentsOf: parents)
            }
            else{
                return models
            }
        }
        return models  
    }
    
    func getParentFor(childId:Int) -> BaseModelProtocol? {
        guard let child = childDict[childId] else { return nil }
        if child.modelType == .Page {//}|| child.editState{
            return child
        }
        return childDict[child.parentId]
    }
    
    func getChildrenFor(parentID: Int) -> [BaseModel] {
        var children = childDict.values.filter { $0.parentId == parentID && !$0.softDelete }
        // logError("JDReview")
        // Remove "Parent" type models if they have no children
        children.removeAll { child in
            child.modelType == .Parent && getChildrenFor(parentID: child.modelId).isEmpty
        }

        return Array(children)
    }
    func getChildrenIDS(parentID : Int) -> [Int] {
        let children = childDict.values.filter { $0.parentId == parentID }
        return Array(children).map({return $0.modelId})
    }
    
    func filterAndTransformLockAll(_ parentInfos: ParentModel) -> [LockUnlockModel] {
        return parentInfos.children
            .flatMap { child -> [LockUnlockModel] in
                // Check if the child is also a ParentModel
                if let childAsParent = child as? ParentModel {
                    // Recursively process the child to get its filtered children
                    let filteredChildren = filterAndTransformLockAll(childAsParent)
                    
                    // If the parent itself is locked, return only the filtered children
                    if child.lockStatus {
                        return filteredChildren
                    } else {
                        // Otherwise, include the current LockUnlockModel and its filtered children
                        let lockUnlockModel = LockUnlockModel(id: child.modelId, lockStatus: true)
                        return [lockUnlockModel] + filteredChildren
                    }
                } else if !child.lockStatus {
                    // If the child is not a parent and its lockStatus is false, create a LockUnlockModel
                    let lockUnlockModel = LockUnlockModel(id: child.modelId, lockStatus: true)
                    return [lockUnlockModel]
                } else {
                    // If the child is not a parent and is locked, return an empty array
                    return []
                }
            }
    }// end of filterAndTransform function
    
    
    
    func filterAndTransformUnlockAll(_ parentInfos: ParentModel) -> [LockUnlockModel] {
        return parentInfos.children
            .flatMap { child -> [LockUnlockModel] in
                // Check if the child is also a ParentModel
                if let childAsParent = child as? ParentModel {
                    // Recursively process the child to get its filtered children
                    let filteredChildren = filterAndTransformUnlockAll(childAsParent)
                    
                    // If the parent itself is locked, return only the filtered children
                    if !child.lockStatus {
                        return filteredChildren
                    } else {
                        // Otherwise, include the current LockUnlockModel and its filtered children
                        let lockUnlockModel = LockUnlockModel(id: child.modelId, lockStatus: false)
                        return [lockUnlockModel] + filteredChildren
                    }
                } else if child.lockStatus {
                    // If the child is not a parent and its lockStatus is false, create a LockUnlockModel
                    let lockUnlockModel = LockUnlockModel(id: child.modelId, lockStatus: false)
                    return [lockUnlockModel]
                } else {
                    // If the child is not a parent and is locked, return an empty array
                    return []
                }
            }
    }// end of filterAndTransform function
    
    func getChildrenMultiselectObject(parentID : Int) -> [MultiSelectedArrayObject]{
        
        // Filter children in parent model
//        var children = childDict.values.filter { $0.parentId == parentID && $0.softDelete == false }
        
        let children = childDict.values.filter { child in
            // Ensure `softDelete` is false
            guard !child.softDelete else { return false }
            
            guard child.parentId == parentID else { return false }
            
            // Check if the child is a ParentModel with non-empty children, or just include the child if it's not a ParentModel
            if let parentModel = child as? ParentModel {
                return !parentModel.children.isEmpty
            } else {
                return true
            }
            
           
        }

        // creating array and map children with id and thumbImage
//        return Array(children).map({return MultiSelectedArrayObject(id: $0.modelId, thumbImage: ($0.thumbImage ?? UIImage(named: "b0"))!)})
        return children
            .sorted(by: { $0.orderInParent < $1.orderInParent }) // Sort by `orderID`
                .map { child in
                    MultiSelectedArrayObject(id: child.modelId, thumbImage: child.thumbImage ?? UIImage(named: "none")!, orderID: child.orderInParent)
                }
    }
    
    var flatternTree = [BaseModel]()
    var layers = [BaseModel]()
    
    func updateFlatternTree(modelId : Int = -1) {
        flatternTree.removeAll()
        flatternTree = flattenedLayers()
        
    }
    
    func flattenedLayers(modelId : Int = -1) -> [BaseModel] {
        
        var result: [BaseModel] = []

        for layer in layers {
            result += getUnselectedArray(layer)
        }
        
        return result
    }
    
    func getUnselectedArray(_ node: BaseModel, modelId : Int = -1) -> [BaseModel]{
        var result: [BaseModel] = []
        if let node = node as? ParentModel, (node.editState || modelId == node.modelId){
            if  node.modelId != 0 && !(node is PageInfo){
                result.append(node)
            }
            
            for child in node.activeChildren {
                child.depthLevel = 0
                child.depthLevel += 1
                result += getUnselectedArray(child)
            
            }
        } else {
            result.append(node)
        }
        
        return result
    }
    
    func expandNode(_ node:ParentModel , expand: Bool) {
        var result: [BaseModel] = []
        
        for child in node.activeChildren {
            result += getUnselectedArray(child)
        }
        
        if let index = flatternTree.firstIndex(where: { $0.modelId == node.modelId }) {
            
            if expand {
                var counter = index + 1
                result.forEach { node in
                    addChildToFlatternTree(node: node, atIndex: counter)
                    counter += 1
                }
            }else{
                result.forEach { node in
                    removeChildrenFromFlatternTree(for: node.modelId)
                }
                
            }
        }
        
    }
    
    func addChildToFlatternTree(node: BaseModel , atIndex:Int) {
        // Find the node in the flattened tree
//        if let index = flatternTree.firstIndex(where: { $0.modelId == nodeID }) {
//            let node = flatternTree[index]

            // Remove children nodes from the flattened tree
        if !flatternTree.contains(where: { $0.modelId == node.modelId}){
            flatternTree.insert(node, at: atIndex)
        }
       // }
        // You might also need to update other data structures or perform additional logic based on your data model.
    }
    
    func removeChildrenFromFlatternTree(for nodeID: Int) {
        // Find the node in the flattened tree
        if let index = flatternTree.firstIndex(where: { $0.modelId == nodeID }) {
            let node = flatternTree[index]

            // Remove children nodes from the flattened tree
            flatternTree.remove(at: index) // All(where: { $0.parentId == node.modelId })
        }
        // You might also need to update other data structures or perform additional logic based on your data model.
    }
    
    /// always ensures right parent is selected
    var currentSuperModel : ParentModel?
    
    /// dont use this variable
    var currentEditedParentModel : ParentModel? //
    
    func forceSelectCurrentPage() {
        
    }
    func selectCurrentPage() {
        if let id = currentPageModel?.modelId {
            deepSetCurrentModel(id: id)
        }else {
            logger?.logError("No Current Page Model")
           //deepSetCurrentModel(id: currentTemplateInfo!.pageInfo.first!.modelId)
        }
    }
    
    
    
    public func setCurrentModel(id : Int , deepSmartSelect:Bool = true ){
            
        logger?.logInfo("set id: \(id)")

            if playerControls?.renderState == .Playing{
                playerControls?.renderState = .Paused
                return
            }
//            
//            
        if let model = currentModel , model.modelId == id /*&& model.modelId != pageModelID*/ {
            logger?.printLog("Same Item Selected Again")
            setSmartCurrentTime(selectedModel: model)
            return
        }
//        
//        if lastSelectedId != id{
//            lastSelectedId = currentModel?.modelId
//        }
        
        if id == -1{
            if let currentModel = currentModel as? ParentModel,currentModel.modelType == .Parent, currentModel.editState, id != -1{
                if deepSmartSelect {
                    currentModel.editState = false
                }
            }
            currentModel?.isActive = false
            selectedComponenet = .base
            currentModel = nil
            currentSuperModel = nil
            currentTextModel = nil
           // currentPageModel = nil
            currentStickerModel = nil
            currentParentModel = nil
            currentSuperModel = nil 
            
        }else{
            currentModel?.isActive = false
//            if currentModel != nil{
//                getEditCloseForChild(model: currentModel!)
//            }
            
            
            
            if let model = getModel(modelId: id){
                print("SelectedModel:",id ,"Type",model.modelType.rawValue)
       
                currentModel = model as BaseModel
                
                if model.modelType == .Sticker{
                    selectedComponenet = .sticker
                    //                    lastSelectedId = model.modelId
                    currentStickerModel = model as? StickerInfo
                    //                    currentActionState.parentEditState = false
                    currentSuperModel = getModel(modelId: model.parentId) as? ParentModel
                }
                else if model.modelType == .Text{
                    selectedComponenet = .text
                    //                    lastSelectedId = model.modelId
                    currentTextModel = model as? TextInfo
                    currentSuperModel = getModel(modelId: model.parentId) as? ParentModel
                    //                    currentActionState.parentEditState = false
                    
                }
                else if model.modelType == .Parent{
                    selectedComponenet = .parent
                    //                    lastSelectedId = model.modelId
                    currentParentModel = model as? ParentInfo
                    currentSuperModel = getModel(modelId: model.parentId) as? ParentModel
                    
                    if currentParentModel!.editState {
                        currentSuperModel = model as? ParentInfo
                        currentEditedParentModel = model as? ParentInfo
                    }else{
                        currentEditedParentModel = nil
                    }
                    
                    //                if let currentParentModel = currentParentModel{
                    //                    currentActionState.parentEditState = (currentParentModel.editState)
                    //                }
                }
                else if model.modelType == .Page{
                    selectedComponenet = .page

                    pageModelID = model.modelId
                    //                    lastSelectedId = model.modelId
                    // currentParentModel = model as? ParentModel
                    currentPageModel = model as? PageInfo
                    currentSuperModel = model as? ParentModel
                    // currentActionState.selectedPageID = model.modelId
                    currentActionState.lastSelectedTextTab = ""
                    //                    currentActionState.parentEditState = false
                    //                    playerControls.currentTime = currentModel!.startTime + 0.2
                }
                //
                
                //                getEditOpenForChild(model: model)
                setSelectedModelChanged =  model
                setSmartCurrentTime(selectedModel: model)
                //                getEditOpenForChild(model: model)
                currentModel?.isActive = true
            }
            }
        
    }
    
    
    func setSmartCurrentTime(selectedModel:BaseModel) {
        let currentTime = playerControls?.currentTime ?? 0.0
        // Calculate the end time based on startTime and duration
        let startTime =  getStartTimeForSacredTimeline(model: selectedModel)
        let endTime = startTime +  selectedModel.baseTimeline.duration
        
        let startTimeOfCurrentSuperModel = getStartTimeForSacredTimeline(model: currentSuperModel!)
        let durationOfCurrentSuperModel = startTimeOfCurrentSuperModel + (currentSuperModel!.baseTimeline.duration )
        
        var idealTime : Float = currentTime
        
        
        // Check if currentTime is out of the range [startTime, endTime]
//        if !(currentTime >= startTime && currentTime <= endTime) {
//            idealTime = startTime
//        }
        
        if (currentTime <= startTime || currentTime > endTime) {
            idealTime = startTime
        }
        if !(idealTime > startTimeOfCurrentSuperModel && idealTime <= durationOfCurrentSuperModel) {
            idealTime = startTimeOfCurrentSuperModel
        }
        
        
        if idealTime != currentTime {
            setCurrentTime(idealTime)
        }
    }
    
    func recursiveEditStateOff(id:Int){
        if let model = getModel(modelId: id) as? ParentModel{
            if model.parentId != model.templateID && model.editState{
                model.editState = false
                recursiveEditStateOff(id: model.parentId)
            }
        }
    }
    
    
    func updateRatioRecursive(newSize:CGSize , parentID : Int) {
        let currentParent = getModel(modelId: parentID)
        let currentParentSize = currentParent?.baseFrame.size ?? newSize
        let children = getChildrenFor(parentID: parentID)
        
        children.forEach { child in
            let child1 = child
            let newSize = reCalculateSize(currentChildSize: child1.size, currentParentSize: currentParentSize, newParentSize: newSize)
            // calculate size and set
            child1.width = Float(newSize.width)
            child1.height = Float(newSize.height)
            
            if child is ParentModel {
                updateRatioRecursive(newSize: newSize, parentID: child.modelId)
            }
        }
        
    }
    
    
    
    func updateBaseFrame(baseFrame:Frame,parentID:Int){
        
    }
    
    
    func updateCenter(newSize:CGSize , parentID : Int) {
        let currentParent = getModel(modelId: parentID)
        let currentParentCenter = currentParent?.baseFrame.center ?? .zero
        let currentParentSize = currentParent?.baseFrame.size ?? .zero
        let children = getChildrenFor(parentID: parentID)
        
        children.forEach { child in
            let child1 = child
            let newCenter = recalculateCenter(currentCenter: currentParentCenter, currentParentSize: currentParentSize, newParentSize: newSize)
            // calculate size and set
            child1.baseFrame.center.x = (newCenter.x)
            child1.baseFrame.center.y = (newCenter.y)
            
            if child is ParentModel {
                updateCenter(newSize: newSize, parentID: child.modelId)
            }
        }
        
    }
    
    
    func updateRotation(parentID: Int, newRotation: CGFloat) {
        guard let currentParent = getModel(modelId: parentID) else { return }
        
        // Update the parent's rotation
        currentParent.baseFrame.rotation = Float(newRotation)
        
        // Get the children of the parent
        let children = getChildrenFor(parentID: parentID)
        
        children.forEach { child in
            // Update the child's rotation to match the parent's new rotation
            child.baseFrame.rotation = Float(newRotation)
            
            // If the child is also a parent, recursively update its children's rotation
            if child is ParentModel {
                updateRotation(parentID: child.modelId, newRotation: newRotation)
            }
        }
    }

    
    //    //Method is used for getting the action state for particular models.
    //    func getActionState(modelID : Int)-> ActionStates{
    //        if actionStates.keys.contains(modelID){
    //            return actionStates[modelID]!
    //        }
    //        else{
    //            return createActionState(modelID: modelID)
    //        }
    //    }
    //
    //    //Method is used for if the action state not exist then create new action state and return.
    //    func createActionState(modelID : Int) -> ActionStates{
    //        let actionState = ActionStates(modelId: modelID)
    //        actionStates[modelID] = actionState
    //        return actionState
    //    }
    //}
    
//    func moveChildIntoNewParent(childID:Int,newParentID:Int,at order:Int,ungroup:Bool = false)->MoveModel{
//        // create move Model object
//        var moveModel = MoveModel(oldMM: [], newMM: [])
//        
//        // create object for old and new moveModel
//        
//        let oldMM = [MoveModelData]()
//        let newMM = [MoveModelData]()
//        
//        
//        if let child = getModel(modelId: childID),let oldParent = getModel(modelId: child.parentId) as? ParentModel, let newParent = getModel(modelId: newParentID)as? ParentModel{
//            // create a object for childto store child New center for old child
//            var newChildSizeArrayForOld = [ChildNewCenterWithID]()
//            
//            // for each and hold oldcenter of oldChild in NewParent
//            for newParentChild in newParent.children{
//                let child = ChildNewCenterWithID(modelId: newParentChild.modelId, center: newParentChild.baseFrame.center, timeline: child.baseTimeline)
//                newChildSizeArrayForOld.append(child)
//            }
//            
//            // flip of Parent in case child's old Parent is flip
//            
//            let oldPVFlip = recursiveParentFlipVerticalCalculation(model: oldParent)
//            let oldPHFlip = recursiveParentFlipHorizontalCalculation(model: oldParent)
//            
//            // if oldparent flip is true at recursive it means right now child
//            
//            // storing old chid center and change center if flip is true at any point
//            var oldChildFrame = child.baseFrame
//            if oldPHFlip{
//                oldChildFrame.center.x = oldParent.baseFrame.size.width - oldChildFrame.center.x
//            }
//            if oldPVFlip{
//                oldChildFrame.center.y = oldParent.baseFrame.size.height - oldChildFrame.center.y
//            }
//            
//           // actual flip of child
//            
//            let oldVFlip = child.modelFlipVertical != oldPVFlip
//            let oldHFlip = child.modelFlipHorizontal != oldPHFlip
//            
//         // store old value of child corresponding old parent
//            let oldModelData = MoveModelData(modelID: childID, parentID: child.parentId, orderInParent: child.orderInParent, baseFrame: child.baseFrame, depthLevel: child.depthLevel,vFlip: child.modelFlipVertical,hFlip: child.modelFlipHorizontal, baseTime: child.baseTimeline, destinationParentSize: parentBaseSize(modelID: newParentID, baseSize: newParent.baseFrame), destinationParentStartTime: newParent.baseTimeline.startTime,  destinationParentDuration: newParent.baseTimeline.duration, DestinationChildCenter: newChildSizeArrayForOld)
//            
//            // creating New values for child and NewParent if move of child affect the new parent
//            
//            let parentID = newParent.modelId
//            let orderInParent = order
//            // depth level of new child will be +1 of parent depth
//            let newDepthLevel = newParent.depthLevel+1
//            
//            var parentIsPage = false
//            
//            // newParent is page
//            if newParent.parentId == newParent.templateID{
//                parentIsPage = true
//            }
//            var childNewCenterWRTNewPage = calculateNewChildCenter(child: child,isungroup: parentIsPage, childOldFrame: oldChildFrame)
//            
//            // calculate new rotaion of child from old to add in new Parent
//            let newRotation = child.baseFrame.rotation + recursiveParentRotationCalculation(model: newParent)+recursiveParentRotationCalculation(model: oldParent)
//            
//            
//            // calculate new center with respect to new parent
//            
//            var newCenterForChild = calculateNewChildCenterForNewParent(childCenter: childNewCenterWRTNewPage, isungroup: parentIsPage,newParent: newParent)
//            
//            // child updated baseFrame
//            var newBaseFrame = Frame(size: oldChildFrame.size, center: newCenterForChild, rotation: newRotation)
//            
//            // calculate newParentSize if it effect the new Parent
//            // what if New parent is rotated
//            // and also new child is rotated
//            
//            
//            let parentnewSize = getNewparentFrame(childNewBaseFrame: newBaseFrame, parentFrame: newParent.baseFrame)
//            
//            newCenterForChild = calculateNewChildCenterForNewParent(childCenter: childNewCenterWRTNewPage, isungroup: parentIsPage, newParent: newParent, parentNewFrame: parentnewSize)
//            newBaseFrame = Frame(size: oldChildFrame.size, center: newCenterForChild, rotation: newRotation)
//            
//          
//            
//            // calculate new Flip of child with respect to newParent
//            let newVFlip = oldVFlip != recursiveParentFlipVerticalCalculation(model: newParent)
//            let newHFlip = oldHFlip != recursiveParentFlipHorizontalCalculation(model: newParent)
//            
//            // calculate new center of parent
//            
//            //calculate startTime wrtpage
//            
//            // new time with respect to parent
//            var newStartTimeOfChild = getNewStartTimeAndDurationForChild(child: child, newParent: newParent)
//            
//            var newparentStartTime = newParent.baseTimeline.startTime//parent.startTime
//            var newparentDuration = newParent.baseTimeline.duration//parent.duration
//            
//            if newStartTimeOfChild < 0{
//                newparentStartTime += newStartTimeOfChild
//                newparentDuration += newparentStartTime - newParent.baseTimeline.startTime
//                newStartTimeOfChild = 0
//            }
//            
//            // startTime and duration for eachChild in NewParent
//            // childstartTime += newparentStartTime - newParent.baseTime.startTime
//            
//            var newChildSizeArrayForNew = [ChildNewCenterWithID]()
//            for newParentChild in newParent.children{
//                newChildSizeArrayForNew.append(  newCenterAndTimeWithNewParent(newParent: newParent, child: newParentChild, newParentNewSize: parentnewSize, newStartTime: newparentStartTime))
//                
//            }
//            
//            
//            // change everychild startTime in engine and scene and view
//            
//            // center of each child in New parent
//                  // create formula for this
//            
//            
//            
//            // pending
//            // function to get minMax with rotate view for any child
//            
//            // function to get frame from child and newParent
//            
//            // function to calculate center for newParent with newSize
//            
//            // add a array of child center and baseTimeline
//            
//            
//            let newModelData = MoveModelData(modelID: childID, parentID: parentID, orderInParent: orderInParent, baseFrame: newBaseFrame, depthLevel: newDepthLevel,vFlip: newVFlip,hFlip: newHFlip, baseTime: StartDuration(startTime: newStartTimeOfChild, duration: child.baseTimeline.duration), destinationParentSize: parentBaseSize(modelID: parentID, baseSize: parentnewSize),destinationParentStartTime: newparentStartTime, destinationParentDuration: newparentDuration, DestinationChildCenter: newChildSizeArrayForNew)
//            moveModel.oldMM.append(oldModelData)
//             moveModel.newMM.append(newModelData)
//            
//            
//        }// end of optional from old parent, child and new parent
//      
//        return moveModel
//        
//    }
//    
    
    func moveChildIntoNewParent(modelID:Int,newParentID:Int,order:Int) -> MoveModel{

          
   //
           // create move Model object
        var moveModel = MoveModel(type: .NotDefined, oldMM: [], newMM: [])
           
       
           
           guard let exsitingChild = getModel(modelId: modelID) else { return moveModel }
      
           if let oldParent = getModel(modelId: exsitingChild.parentId),let newParent = getModel(modelId: newParentID){
               // storing old child frame + Base Time + other properties except array OF Parents
       
               // new start
               // flip of Parent in case child's old Parent is flip
               
               let oldPVFlip = recursiveParentFlipVerticalCalculation(model: oldParent)
               let oldPHFlip = recursiveParentFlipHorizontalCalculation(model: oldParent)
               
               // if oldparent flip is true at recursive it means right now child
               
               // storing old chid center and change center if flip is true at any point
               var oldChildFrame = exsitingChild.baseFrame
               var existingChildNewRotation = exsitingChild.baseFrame.rotation + recursiveParentRotationCalculation(model: newParent)+recursiveParentRotationCalculation(model: oldParent)
      
               
             
               if oldPHFlip{
                   oldChildFrame.center.x = oldParent.baseFrame.size.width - oldChildFrame.center.x

               }
               if oldPVFlip{
                   oldChildFrame.center.y = oldParent.baseFrame.size.height - oldChildFrame.center.y

               }
               
               let childNewCenterWRTNewPage = calculateNewChildCenter(child: exsitingChild, childOldFrame: oldChildFrame)
               
               let orderInParent = order
               // depth level of new child will be +1 of parent depth
               let newDepthLevel = newParent.depthLevel+1
               let oldVFlip = exsitingChild.modelFlipVertical != oldPVFlip
               let oldHFlip = exsitingChild.modelFlipHorizontal != oldPHFlip
               // calculate new Flip of child with respect to newParent
               let newVFlip = oldVFlip != recursiveParentFlipVerticalCalculation(model: newParent)
               let newHFlip = oldHFlip != recursiveParentFlipHorizontalCalculation(model: newParent)
               
            
               
               
             
               
               // childFrame and Time wrt Page
               let childNewRotatedFrameWRTPage = Frame(size: exsitingChild.baseFrame.size, center: childNewCenterWRTNewPage, rotation: existingChildNewRotation)
               let childBaseTimeWRTPage = StartDuration(startTime:  getOldStartTime(child: exsitingChild), duration: exsitingChild.baseTimeline.duration)
            
               let arrayOfParent = parentIDOfParents(parent: newParent)
               
              var oldParentAndChildData = [ParentAndChildBaseFrameAndTime]()
              var newParentAndChildData = [ParentAndChildBaseFrameAndTime]()
               
               var oldExistingChildFrame = childNewRotatedFrameWRTPage
               var oldExitingChildTime = childBaseTimeWRTPage
               
               var newParentSize = CGSize(width: 0, height: 0)
               
               for parentID in arrayOfParent {
                   if let modelOFArrayOfParent = getModel(modelId: parentID) as? ParentModel{
                  
                       
                       // store and calculate new frame of parent wrt To Child
                       let newBaseFrameOfParentArrayParent = getNewParentFrame(childNewBaseFrame: oldExistingChildFrame, parentFrame: modelOFArrayOfParent.baseFrame)
                      
                       oldExistingChildFrame.center.x -= newBaseFrameOfParentArrayParent.getRotatedFrame().minX
                       oldExistingChildFrame.center.y -= newBaseFrameOfParentArrayParent.getRotatedFrame().minY
                       oldExistingChildFrame.center = newBaseFrameOfParentArrayParent.getRotatedCenter(childPoint: oldExistingChildFrame.center)
                      
                       if newParentID == parentID{
                           newParentSize = newBaseFrameOfParentArrayParent.size
                       }
                      // calculate new BaseTime of Parent wrt to child
                       
                       let newParentStartTime = min(modelOFArrayOfParent.baseTimeline.startTime,oldExitingChildTime.startTime)
                       var newParentDuration = max(modelOFArrayOfParent.baseTimeline.startTime+modelOFArrayOfParent.baseTimeline.duration, oldExitingChildTime.startTime+oldExitingChildTime.duration)
                       newParentDuration = newParentDuration - newParentStartTime
                       
                       oldExitingChildTime.startTime -= newParentStartTime
                       
                  
                       
                       // store new BaseTime of Parent wrt to child
                       let newBaseTimeOfParentArrayParent = StartDuration(startTime: newParentStartTime, duration: newParentDuration)
                       
                       var arrayOldChildFrameAndTime = [ChildBaseFrameAndTime]()
                       var arrayNewChildFrameAndTime = [ChildBaseFrameAndTime]()
                       
                       
                       for child in modelOFArrayOfParent.children {
                           let childIDInList = arrayOfParent.contains(child.modelId)
                           if !childIDInList{
                               let OldChildFrameAndTime = ChildBaseFrameAndTime(modelID: child.modelId, BaseFrame: child.baseFrame, BaseTime: child.baseTimeline)
                               let newFrameOfChild = reverseCalculationOFBaseFrame(child: child, parentSize: newBaseFrameOfParentArrayParent, parentOldSize: modelOFArrayOfParent.baseFrame)
                               let newTimeOfChild = reverseCalculationOFBaseTime(child: child, parentNewBaseTime: newBaseTimeOfParentArrayParent, parentOldBaseTime: modelOFArrayOfParent.baseTimeline)
                               
                               let NewChildFrameAndTime = ChildBaseFrameAndTime(modelID: child.modelId, BaseFrame: newFrameOfChild, BaseTime: newTimeOfChild)
                               arrayOldChildFrameAndTime.append(OldChildFrameAndTime)
                               arrayNewChildFrameAndTime.append(NewChildFrameAndTime)
                           }
                           
                       }
                       let oldParentAndChildBaseFrameAndTime = ParentAndChildBaseFrameAndTime(modelID: parentID, BaseFrame: modelOFArrayOfParent.baseFrame, BaseTime: modelOFArrayOfParent.baseTimeline, Child: arrayOldChildFrameAndTime)
                       
                       let newParentAndChildBaseFrameAndTime = ParentAndChildBaseFrameAndTime(modelID: parentID, BaseFrame: newBaseFrameOfParentArrayParent, BaseTime: newBaseTimeOfParentArrayParent, Child: arrayNewChildFrameAndTime)
                       
                       oldParentAndChildData.append(oldParentAndChildBaseFrameAndTime)
                       newParentAndChildData.append(newParentAndChildBaseFrameAndTime)
                       
                       
                   } // end of cheking Parent is exist or not
                   
               }// end of ParentID's array loop
               
               let oldModel = MoveModelData(modelID: exsitingChild.modelId, parentID: oldParent.modelId, orderInParent: exsitingChild.orderInParent, baseFrame: exsitingChild.baseFrame, depthLevel: exsitingChild.depthLevel, vFlip: exsitingChild.modelFlipVertical, hFlip: exsitingChild.modelFlipHorizontal, baseTime: exsitingChild.baseTimeline, arrayOFParents: oldParentAndChildData)
               // new frame of existing child
               var newBaseTimeOfExistingChild = oldExitingChildTime
               var newBaseFrameOfExistingChild = oldExistingChildFrame
              

               if recursiveParentFlipHorizontalCalculation(model: newParent){
                   newBaseFrameOfExistingChild.center.x = newParentSize.width - newBaseFrameOfExistingChild.center.x
               }
               if recursiveParentFlipVerticalCalculation(model: newParent){
                   newBaseFrameOfExistingChild.center.y = newParentSize.height - newBaseFrameOfExistingChild.center.y
               }
              
               let newModel = MoveModelData(modelID: exsitingChild.modelId, parentID: newParentID, orderInParent: order, baseFrame: newBaseFrameOfExistingChild, depthLevel: newDepthLevel, vFlip: newVFlip, hFlip: newHFlip, baseTime: newBaseTimeOfExistingChild, arrayOFParents: newParentAndChildData)
               
               
               moveModel.oldMM.append(oldModel)
               moveModel.newMM.append(newModel)
                    
           }// end of unwrap oldParent and New parent
           return moveModel
       }
    
    func parentIDOfParents(parent : BaseModel)->[Int]{
        var arrayOFParent = [Int]()
        func recursiveParentID(model:BaseModel){
            if model.parentId != model.templateID{
                guard let newParent = getModel(modelId: model.parentId)else{
                    return
                }
                recursiveParentID(model: newParent)
                arrayOFParent.append(model.modelId)
            }
            
        }
        recursiveParentID(model: parent)
//        arrayOFParent.append(parent.modelId)
        return arrayOFParent
    }
    
    func getNewParentframe(child:BaseModel)->[ParentBFAndTime]{
        let arrayOfParentAndChild = [ParentBFAndTime]()
        return arrayOfParentAndChild
      
    }
    
//    func getRecursiveFrameAndTime(child:ParentModel,childNewFrame:Frame,childNewTime:StartDuration,oldParentChildModel: inout [ParentBFAndTime],newParentChildModel: inout [ParentBFAndTime] ){
//        if let parent = getModel(modelId: child.parentId) as? ParentModel{
//            // check if parent is not a page
//            if parent.modelType != .Page{
//                // get old frame and time for parent
//                 // new frame for parent
//                // calculate new center with respect to new parent
//                
//               // var childNewCenterWRTNewPage = calculateNewChildCenter(child: child, childOldFrame: child.baseFrame)
//                
//               // var newCenterForChild = calculateNewChildCenterForNewParent(childCenter: childNewCenterWRTNewPage,newParent: parent)
//                
//                // child updated baseFrame
//               // var newBaseFrame = Frame(size: child.baseFrame.size, center: newCenterForChild, rotation: child.baseFrame.rotation)
//                
//                // calculate newParentSize if it effect the new Parent
//                // what if New parent is rotated
//                // and also new child is rotated
//                let parentOldFrame = parent.baseFrame
//                let parentoldbaseFrame = parent.baseTimeline
//                
//                
//                
//                var childBaseTimeAndFrame = [BaseFrameAndStartTime]()
//                
//                for childs in parent.children{
//                    // save old baseFrame and old baseTime
//                   let oldChildFrameAndTime = BaseFrameAndStartTime(modelID: childs.modelId, baseFrame: childs.baseFrame, baseTime: childs.baseTimeline)
//                    childBaseTimeAndFrame.append(oldChildFrameAndTime)
//                }
//                
//                let oldFrameAndTime = ParentBFAndTime(modelID: parent.modelId, baseFrame: parentOldFrame, baseTime: parentoldbaseFrame, childs: childBaseTimeAndFrame)
//                
//                oldParentChildModel.append(oldFrameAndTime)
//                
////
//                
//                
//                let parentNewSize = getNewparentFrame(childNewBaseFrame: childNewFrame, parentFrame: parent.baseFrame)
//                
//                let ParentNewStartTime = calculateParentBaseTime(parent: parent, child: childNewTime)
//                
//                for childs in parent.children{
//                    // reverse Calculation Of BaseFrame
//                    // reverse calculation of baseTime
//                    
//                    
//                }
//           
//                // save new frame and time for parent
//                
//                // get recursive call for parent again
//            }
//        }
//    }
    
//    func reverseCalculationOfBaseTimeAndBaseFrame(parent:ParentModel,parentNewFrame:Frame,parentOldFrame:Frame)->[BaseFrameAndStartTime]{
//        var arrayOfChildBaseFrameAndStartTime = [BaseFrameAndStartTime]()
//        for child in parent.children{
//            let childNewFrame = reverseCalculationOFBaseFrame(child: child, parentSize: parentNewFrame, parentOldSize: parentOldFrame)
//            
//            arrayOfChildBaseFrameAndStartTime
//        }
//    }
//    
    
    func calculateParentBaseTime(parent:ParentModel,child:StartDuration)->StartDuration{
        let baseTime = StartDuration(startTime: 0, duration: 0)
        
        let minStarTime = min(parent.baseTimeline.startTime, child.startTime)
        
        let diff = minStarTime - parent.baseTimeline.startTime
        
        let newDuration = parent.baseTimeline.duration + diff
        
        return StartDuration(startTime: minStarTime, duration: newDuration)
        
    }
    
    func reverseCalculationOFBaseFrame(child:BaseModel,parentSize:Frame,parentOldSize:Frame)->Frame{
        let newparentOriginX = parentSize.center.x - parentSize.size.width/2
        let newparentOriginY = parentSize.center.y - parentSize.size.height/2
        
        // Firstly Calculate the Origin of the Parent
        let oldparentOriginX = parentOldSize.center.x - parentOldSize.size.width/2
        let oldparentOriginY = parentOldSize.center.y - parentOldSize.size.height/2
        
        
        // Then get the differnce by subtracting child origin with parent origin.
        let diffX = oldparentOriginX - newparentOriginX
        let diffY = oldparentOriginY - newparentOriginY
        
        
        let newCenterForChild = CGPoint(x: child.baseFrame.center.x+diffX, y: child.baseFrame.center.y+diffY)
        return Frame(size: child.baseFrame.size, center: newCenterForChild, rotation: child.baseFrame.rotation)
    }
    
    func reverseCalculationOFBaseTime(child:BaseModel,parentNewBaseTime:StartDuration,parentOldBaseTime:StartDuration)->StartDuration{
        let diffrenceInStartTime = parentOldBaseTime.startTime - parentNewBaseTime.startTime
        
        let newStartTime = child.baseTimeline.startTime + diffrenceInStartTime
        return StartDuration(startTime: newStartTime, duration: child.duration)
        
    }

    func getNewParentFrame(childNewBaseFrame:Frame,parentFrame:Frame)->Frame{
        let childBounds = childNewBaseFrame.getRotatedFrame()
        let parentBounds = parentFrame.getRotatedFrame()
        
        let minX  = min(childBounds.minX,parentBounds.minX)
        let minY  = min(childBounds.minY,parentBounds.minY)
        let maxX  = max(childBounds.maxX,parentBounds.maxX)
        let maxY  = max(childBounds.maxY,parentBounds.maxY)
        
       
        let center = CGPoint(x:  minX + (maxX-minX)/2, y: minY + (maxY-minY)/2)
        let newSize = CGSize(width: maxX-minX, height: maxY-minY)
        let newFrame = Frame(size: newSize, center: center, rotation: parentFrame.rotation)
        
        return newFrame
    }

    
    // recursive Method to update time
    
    
    func newCenterAndTimeWithNewParent (newParent:BaseModel,child:BaseModel,newParentNewSize:Frame ,newStartTime:Float)-> ChildNewCenterWithID{
        let newparentOriginX = newParentNewSize.center.x - newParentNewSize.size.width/2
        let newparentOriginY = newParentNewSize.center.y - newParentNewSize.size.height/2
        
        // Firstly Calculate the Origin of the Parent
        let oldparentOriginX = newParent.baseFrame.center.x - newParent.baseFrame.size.width/2
        let oldparentOriginY = newParent.baseFrame.center.y - newParent.baseFrame.size.height/2
        
        let differenceOFTime = newStartTime - newParent.baseTimeline.startTime
        
        // Then get the differnce by subtracting child origin with parent origin.
        let diffX = oldparentOriginX - newparentOriginX
        let diffY = oldparentOriginY - newparentOriginY
        
        
        let newCenterForChild = CGPoint(x: child.baseFrame.center.x+diffX, y: child.baseFrame.center.y+diffY)
        return ChildNewCenterWithID(modelId: child.modelId, center: newCenterForChild, timeline: StartDuration(startTime: child.baseTimeline.startTime + differenceOFTime, duration: child.baseTimeline.duration))
    }
    
    func getNewStartTimeAndDurationForChild(child:BaseModel,newParent:BaseModel)->Float{
        
        // get child oldStartTime
        let oldStartTimeOfChildWRTPage = getOldStartTime(child: child)
        
       
        
        return getNewStartTime(childStartTime: oldStartTimeOfChildWRTPage, newParentID: newParent.modelId)
        
        
    }
    
     func getStartTimeForSacredTimeline(model:BaseModel) -> Float {
        // basically recurse till page
        if model.modelType == .Page{
            return model.baseTimeline.startTime
        }
        
        var time = model.baseTimeline.startTime
        if let parent = getModel(modelId: model.parentId) as? ParentModel{
            time += getStartTimeForSacredTimeline(model: parent)
        }
        return time
        
    }
    
   private func getOldStartTime(child:BaseModel)-> Float{
        var startTime = child.baseTimeline.startTime
        if let parentModel = getModel(modelId: child.parentId) as? ParentModel{
            startTime += recursiveParentStartTime(model: parentModel)
        }
        
        return startTime
    }

    
    
     func recursiveParentStartTime(model:ParentModel)->Float{
       if model.modelType == .Page{
           return model.baseTimeline.startTime
       }
        var time = model.baseTimeline.startTime
        if let parent = getModel(modelId: model.parentId) as? ParentModel{
            time += recursiveParentStartTime(model: parent)
        }
        return time
    }
    
    private func getNewStartTime(childStartTime:Float,newParentID:Int)-> Float{
        var startTime = childStartTime
        if let parentModel = getModel(modelId: newParentID) as? ParentModel{
            startTime -= recursiveChildToParentStartTime(time: startTime, model: parentModel)
        }
        
        return startTime
    }
    
    func getNewStartTimeForNewComponent(childStartTime:Float,newParentID:Int)-> Float{
        var startTime = childStartTime
        if let parentModel = getModel(modelId: newParentID) as? ParentModel{
            if parentModel.modelType == .Page{
                startTime -= recursiveChildToParentStartTime(time: startTime, model: parentModel)
            }else{
                let singleParentModel = getModel(modelId: parentModel.parentId)
                if singleParentModel?.modelType == .Page{
                    startTime -= recursiveChildToParentStartTime(time: startTime, model: parentModel)
                }else{
                    startTime = recursiveChildToParentStartTime(time: startTime, model: parentModel)
                }
            }
        }
        
        return startTime
    }

    private func recursiveChildToParentStartTime(time: Float,model:ParentModel)->Float{
        var newTime = time
       if model.modelType == .Page{
           return newTime - model.baseTimeline.startTime
       }
        newTime -= model.baseTimeline.startTime
        if let parent = getModel(modelId: model.parentId) as? ParentModel{
            newTime -= recursiveChildToParentStartTime(time: time, model: parent)
        }
        return newTime
    }
    
    
//    func moveChildIntoNewParent1(childID:Int,newParentID:Int,at order:Int,ungroup:Bool = false)->MoveModel{
//        
//      
//        
//        let isUngroup = ungroup
//        var moveModel = MoveModel(oldMM: [], newMM: [])
//        
//        let oldMM = [MoveModelData]()
//        let newMM = [MoveModelData]()
//        
//        if let child = getModel(modelId: childID),let oldParent = getModel(modelId: child.parentId) as? ParentModel{
//            if let parent = getModel(modelId: newParentID)as? ParentModel{
//                
////                var oldChildSizeArrayForOld = [ChildNewCenterWithID]()
//                var newChildSizeArrayForOld = [ChildNewCenterWithID]()
//                
//                
//                for newParentChild in parent.children{
//                    let child = ChildNewCenterWithID(modelId: newParentChild.modelId, center: newParentChild.baseFrame.center, timeline: child.baseTimeline)
//                    newChildSizeArrayForOld.append(child)
//                }
//                
//                let oldPVFlip = recursiveParentFlipVerticalCalculation(model: oldParent)
//                let oldPHFlip = recursiveParentFlipHorizontalCalculation(model: oldParent)
//                
//                let oldVFlip = child.modelFlipVertical != oldPVFlip
//                let oldHFlip = child.modelFlipVertical != oldPHFlip
//                
//                
//                var oldChildFrame = child.baseFrame
//                
//                if oldPHFlip{
////                    if newBaseFrame.center.x > parentnewSize.size.width/2{
////                        newBaseFrame.center.x = parentnewSize.size.width - newBaseFrame.center.x
////                    }else{
//                    oldChildFrame.center.x = oldParent.baseFrame.size.width - oldChildFrame.center.x
////                    }
//                }
//                
//                if oldPVFlip{
////                    if  newBaseFrame.center.y > parentnewSize.size.height/2{
////                        newBaseFrame.center.y = parentnewSize.size.height - newBaseFrame.center.y
////                    }else{
//                    oldChildFrame.center.y = oldParent.baseFrame.size.height - oldChildFrame.center.y
////                    }
//                }
//                
//                
//                let oldModelData = MoveModelData(modelID: childID, parentID: child.parentId, orderInParent: child.orderInParent, baseFrame: child.baseFrame, depthLevel: child.depthLevel,vFlip: oldHFlip,hFlip: oldVFlip, destinationParentSize: parentBaseSize(modelID: newParentID, baseSize: parent.baseFrame), destinationParentStartTime: parent.baseTimeline.startTime,  destinationParentDuration: parent.baseTimeline.duration, DestinationChildCenter: newChildSizeArrayForOld)
//                
//                let parentID = parent.modelId
//                let orderInParent = order
//                var parentIsPage = false
//                let newDepthLevel = parent.depthLevel+1
//                if parent.parentId == parent.templateID{
//                    parentIsPage = true
//                }
//                var childNewCenterWRTPage = calculateNewChildCenter(child: child,isungroup: parentIsPage, childOldFrame: oldChildFrame)
//                
////                child.baseFrame.center = childNewSizeWRTPage
////                let newChildCenter = calculateNewChildCenter(oldParent: oldParent.baseFrame, newParent: templateHandler.currentPageModel!.baseFrame, currentChildCenter: child.baseFrame.center)
////                child.baseFrame.center = newChildCenter
//                
//                // calculate new rotation
//                
//                
//                let newRotation = child.baseFrame.rotation + recursiveParentRotationCalculation(model: parent)+recursiveParentRotationCalculation(model: oldParent)
//                
//                
//                
//                
//                
//                
//                
//                // child updated baseFrame
//                var newBaseFrame = Frame(size: oldChildFrame.size, center: childNewCenterWRTPage, rotation: newRotation)
//                
//                
//                var parentnewSize = calculateNewParentFrame(childFrame: newBaseFrame, parentFrame: parent.baseFrame)
//              
////                if let parentOfParent = templateHandler.getModel(modelId: parent.parentId){
////                    let centerX = parentnewSize.center.x/parentOfParent.baseFrame.size.width
////                    let centerY = parentnewSize.center.y/parentOfParent.baseFrame.size.height
////                    parentnewSize.center = CGPoint(x: centerX, y: centerY)
////                }
//                
//                
//                // center of parent - center of main parent
//                
//                let newVFlip = oldVFlip != recursiveParentFlipVerticalCalculation(model: parent)
//                let newHFlip = oldHFlip != recursiveParentFlipVerticalCalculation(model: parent)
//                
//                
//                
//                newBaseFrame.center = calculateNewCenterForParent(parentFrame: parentnewSize, childFrame: newBaseFrame)
//                
//              
//                
//                
////                if isUngroup{
//                var newparentStartTime = parent.baseTimeline.startTime//parent.startTime
//                var newparentDuration = parent.baseTimeline.duration//parent.duration
//             
////                    if child.startTime < parent.startTime{
////                        let newparentStartTime = child.startTime
////                        let newparentDuration = parent.duration + (parent.startTime-child.startTime)
////                    }
//                if child.baseTimeline.startTime < parent.baseTimeline.startTime{
//                    newparentStartTime = child.baseTimeline.startTime
////                    newparentDuration = parent.baseTimeline.duration + (parent.baseTimeline.startTime-child.baseTimeline.startTime)
//                }
//                
//                if (child.baseTimeline.duration + child.baseTimeline.startTime) > (parent.baseTimeline.duration){
//                    newparentDuration = parent.baseTimeline.duration + ((child.baseTimeline.duration + child.baseTimeline.startTime) - parent.baseTimeline.duration)
//                }
//           
//               
//                
////                var oldChildSizeArrayForNew = oldChildSizeArrayForOld
//                var newChildSizeArrayForNew = [ChildNewCenterWithID]()
//                
//           
//                
////                if !isUngroup{
//                    for newParentChild in parent.children{
//                        // calculate new Size for each child of parent wrt to parent
//                        
//                        
//                        
//                        
//                        // check if parent origin is changed
//                        // if origin is changed then changed value + center
//                        // Firstly Calculate the Origin of the Parent
//                        let newparentOriginX = parentnewSize.center.x - parentnewSize.size.width/2
//                        let newparentOriginY = parentnewSize.center.y - parentnewSize.size.height/2
//                        
//                        // Firstly Calculate the Origin of the Parent
//                        let oldparentOriginX = parent.baseFrame.center.x - parent.baseFrame.size.width/2
//                        let oldparentOriginY = parent.baseFrame.center.y - parent.baseFrame.size.height/2
//                        
//                        
//                        // Then get the differnce by subtracting child origin with parent origin.
//                        let diffX = oldparentOriginX - newparentOriginX
//                        let diffY = oldparentOriginY - newparentOriginY
//                        
//                        
//                        
//                        
//                        var newCenterForChild = CGPoint(x: newParentChild.baseFrame.center.x+diffX, y: newParentChild.baseFrame.center.y+diffY)
////                        
////                        if oldPHFlip{
//////                            if newCenterForChild.x > parentnewSize.size.width/2{
//////                                newCenterForChild.x = parentnewSize.size.width - newCenterForChild.x
//////                            }else{
////                                newCenterForChild.x = parentnewSize.size.width - newCenterForChild.x
//////                            }
////                        }
////                        
////                        if oldVFlip{
//////                            if newCenterForChild.y > parentnewSize.size.height/2{
//////                                newCenterForChild.y = parentnewSize.size.height - newCenterForChild.y
//////                            }else{
////                                newCenterForChild.y = parentnewSize.size.height - newCenterForChild.y
//////                            }
////                        }
////                        
//                        let child = ChildNewCenterWithID(modelId: newParentChild.modelId, center: newCenterForChild, timeline: StartDuration(startTime: 0, duration: 0))
//                        
//                        newChildSizeArrayForNew.append(child)
//                    }
//                    
////                }
//                let newModelData = MoveModelData(modelID: childID, parentID: parentID, orderInParent: orderInParent, baseFrame: newBaseFrame, depthLevel: newDepthLevel,vFlip: newVFlip,hFlip: newHFlip, destinationParentSize: parentBaseSize(modelID: parentID, baseSize: parentnewSize),destinationParentStartTime: newparentStartTime, destinationParentDuration: newparentDuration, DestinationChildCenter: newChildSizeArrayForNew)
//                moveModel.oldMM.append(oldModelData)
//                 moveModel.newMM.append(newModelData)
//                
//             
////                if !isUngroup{
////                 
////                }else{
////                    let newModelData = MoveModelData(modelID: childID, parentID: parentID, orderInParent: orderInParent, baseFrame: newBaseFrame, depthLevel: newDepthLevel,vFlip: newVFlip,hFlip: newHFlip, destinationParentSize: parentBaseSize(modelID: parentID, baseSize: oldParent.baseFrame),destinationParentStartTime: oldParent.baseTimeline.startTime, destinationParentDuration: oldParent.baseTimeline.duration, DestinationChildCenter: newChildSizeArrayForOld)
////                    moveModel.oldMM.append(oldModelData)
////                    moveModel.newMM.append(newModelData)
////                }
////                
//              
//                
//                
//                
//            }
//            
//        }
//        return moveModel
//    }
//    
    func recursiveParentFlipHorizontalCalculation(model:BaseModel)->Bool{
        var flip = model.modelFlipHorizontal
        if  let parent = getModel(modelId: model.parentId) {
            if parent.parentId != parent.templateID{
                flip = flip != recursiveParentFlipVerticalCalculation(model: parent)
            }
        }
        return flip
    }
    
    func recursiveParentFlipVerticalCalculation(model: BaseModel) -> Bool {
        var flip = model.modelFlipVertical
        if let parent = getModel(modelId: model.parentId) {
            if parent.parentId != parent.templateID {
                flip = flip != recursiveParentFlipVerticalCalculation(model: parent) // XOR logic
            }
        }
        return flip
    }
    
    
    
    func recursiveParentRotationCalculation(model: BaseModel)->Float {
        var rotation = model.baseFrame.rotation
        if  let parent = getModel(modelId: model.parentId) {
            if parent.parentId != parent.templateID{
                rotation += recursiveParentRotationCalculation(model: parent)
            }
        }
        return rotation
    }
    
    func calculateNewChildCenter(child: BaseModel,isungroup:Bool = false,childOldFrame:Frame) -> CGPoint {
         var center = childOldFrame.center
         
         func recursiveCenterCalculation(child: BaseModel) {
             // Check if the child has a parent and if the parent is not the template
             if  let parent = getModel(modelId: child.parentId) {
                 // Update the center relative to the parent
                 if parent.parentId != parent.templateID{
                     center.x += parent.baseFrame.center.x - (parent.baseFrame.size.width / 2)
                      center.y += parent.baseFrame.center.y - (parent.baseFrame.size.height / 2)
                     
                      center = parent.baseFrame.getRotatedCenter(childPoint: center)
                     
                     
 //                    center.x += rotatedFrame.minX
 //                    center.y += rotatedFrame.minY
                     // Recursively calculate the center for the parent
                     recursiveCenterCalculation(child: parent)
                 }
 //                }else if  parent.parentId == parent.templateID && isungroup {
 ////                    center.x += parent.baseFrame.center.x - (parent.baseFrame.size.width / 2)
 ////                    center.y += parent.baseFrame.center.y - (parent.baseFrame.size.height / 2)
 //                }
             }
         }
         
         // Start the recursive calculation
         recursiveCenterCalculation(child: child)
         
         return center
     }
    
    
    func calculateNewChildCenterForNewParent(childCenter: CGPoint,isungroup:Bool = false,newParent:BaseModel) -> CGPoint {
        var center = childCenter
        
        func recursiveCenterCalculation(child: BaseModel) {
            // Check if the child has a parent and if the parent is not the template
            if  let parent = getModel(modelId: child.parentId) {
                // Update the center relative to the parent
                if parent.parentId != parent.templateID{
                    center.x -= parent.baseFrame.center.x - (parent.baseFrame.size.width / 2)
                    center.y -= parent.baseFrame.center.y - (parent.baseFrame.size.height / 2)
                    // Recursively calculate the center for the parent
                    recursiveCenterCalculation(child: parent)
                }
                else if  parent.parentId == parent.templateID  {
                    center.x -= child.baseFrame.center.x - (child.baseFrame.size.width / 2)
                    center.y -= child.baseFrame.center.y - (child.baseFrame.size.height / 2)
                }
            }
        }
    
        // Start the recursive calculation
        recursiveCenterCalculation(child: newParent)
        
        return center
    }
    
   
    
    func calculateNewChildCenterForNewParent(childCenter: CGPoint,isungroup:Bool = false,newParent:BaseModel,parentNewFrame:Frame) -> CGPoint {
        var center = childCenter
        
        func recursiveCenterCalculation(child: BaseModel) {
            // Check if the child has a parent and if the parent is not the template
            if  let parent = getModel(modelId: child.parentId) {
                // Update the center relative to the parent
                if parent.parentId != parent.templateID{
                    center.x -= parent.baseFrame.center.x - (parent.baseFrame.size.width / 2)
                    center.y -= parent.baseFrame.center.y - (parent.baseFrame.size.height / 2)
                    // Recursively calculate the center for the parent
                    recursiveCenterCalculation(child: parent)
                }
                else if  parent.parentId == parent.templateID  {
                    center.x -= child.baseFrame.center.x - (child.baseFrame.size.width / 2)
                    center.y -= child.baseFrame.center.y - (child.baseFrame.size.height / 2)
                }
            }
        }
    
        // Start the recursive calculation
        if let parentModel = getModel(modelId: newParent.parentId){
            recursiveCenterCalculation(child: parentModel)
        }
        center.x -= parentNewFrame.center.x - (parentNewFrame.size.width / 2)
        center.y -= parentNewFrame.center.y - (parentNewFrame.size.height / 2)
        
        return center
    }
    
    
    
//    func calculateNewParentFrame(childFrame: Frame, parentFrame: Frame) -> Frame {
//        // Calculate the child's frame bounds
//        var childMinX = childFrame.center.x - (childFrame.size.width / 2)
//        var childMaxX = childFrame.center.x + (childFrame.size.width / 2)
//        var childMinY = childFrame.center.y - (childFrame.size.height / 2)
//        var childMaxY = childFrame.center.y + (childFrame.size.height / 2)
//        
//        
//
//        // Calculate the parent's frame bounds
//        let parentMinX = parentFrame.center.x - (parentFrame.size.width / 2)
//        let parentMaxX = parentFrame.center.x + (parentFrame.size.width / 2)
//        let parentMinY = parentFrame.center.y - (parentFrame.size.height / 2)
//        let parentMaxY = parentFrame.center.y + (parentFrame.size.height / 2)
//        
//        childMinX += parentMinX
//        childMaxX += parentMinX
//        childMinY += parentMinY
//        childMaxY += parentMinY
//        
//        
//
//        // Determine the new bounds for the parent frame
//        let newMinX = min(parentMinX, childMinX)
//        let newMaxX = max(parentMaxX, childMaxX)
//        let newMinY = min(parentMinY, childMinY)
//        let newMaxY = max(parentMaxY, childMaxY)
//
//        // Calculate the new size and center for the parent frame
//        let newWidth = newMaxX - newMinX
//        let newHeight = newMaxY - newMinY
//        let newCenterX = (newMinX + newMaxX) / 2
//        let newCenterY = (newMinY + newMaxY) / 2
//
//        // Create a new parent frame
//        let newParentFrame = Frame(size: CGSize(width: newWidth, height: newHeight), center: CGPoint(x: newCenterX, y: newCenterY), rotation: parentFrame.rotation)
//
//        // Return the new parent frame
//        return newParentFrame
//    }
    
    
    func decreaseOrderOFChildren(from order: Int, to: Int, pageDuration: Float) -> ([Int: Int], Float)? {
        // Check if 'currentTemplateInfo' and 'pageInfo' are not nil
        guard let templateInfo = currentTemplateInfo,
              order >= 0,
              to >= 0,
              order < templateInfo.pageInfo.count,
              to < templateInfo.pageInfo.count else {
            print("Error: Invalid 'from' or 'to' index or 'currentTemplateInfo' is nil.")
            return nil
        }
        
        // Ensure 'order' index is less than or equal to 'to' index
        guard order <= to else {
            print("Error: 'from' index should be less than or equal to 'to' index.")
            return nil
        }

        var updatedID = [Int: Int]()
        var startTime = templateInfo.pageInfo[to].baseTimeline.startTime

        for ord in order...to {
            let child = templateInfo.pageInfo[ord]
            
            // Ensure 'orderInParent' does not become negative or zero
            if child.orderInParent <= 0 {
                print("Error: orderInParent cannot be less than or equal to zero for modelId \(child.modelId).")
                return nil
            }

            // Ensure 'startTime' does not become negative
            if child.startTime - pageDuration < 0 {
                print("Error: startTime cannot become negative for modelId \(child.modelId).")
                return nil
            }

            // Update the order and start time in the local model
            child.orderInParent -= 1
            let orderUpdateSuccess = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: child.orderInParent)
            
            child.startTime -= pageDuration
            let startTimeUpdateSuccess = DBManager.shared.updateStartTime(modelId: child.modelId, newValue: child.baseTimeline.startTime)
            
            // Check if both database updates were successful
            if !orderUpdateSuccess || !startTimeUpdateSuccess {
                print("Error: Failed to update the database for modelId \(child.modelId).")
                return nil
            }
            
            updatedID[child.modelId] = child.orderInParent
        }

        return (updatedID, startTime)
    }
    
    func increaseOrderOFChildren(from order: Int, to: Int, pageDuration: Float) -> ([Int: Int], Float)? {
        // Check if 'currentTemplateInfo' and 'pageInfo' are not nil
        guard let templateInfo = currentTemplateInfo,
              order >= 0,
              to >= 0,
              order < templateInfo.pageInfo.count,
              to < templateInfo.pageInfo.count else {
            print("Error: Invalid 'from' or 'to' index or 'currentTemplateInfo' is nil.")
            return nil
        }
        
        // Ensure 'order' index is less than or equal to 'to' index
        guard order <= to else {
            print("Error: 'from' index should be less than or equal to 'to' index.")
            return nil
        }

        var updatedID = [Int: Int]()
        var startTime = templateInfo.pageInfo[order].baseTimeline.startTime

        for ord in order...to {
            let child = templateInfo.pageInfo[ord]
            
            // Ensure that updating the order does not result in invalid state
            if child.orderInParent >= Int.max {
                print("Error: orderInParent has reached its maximum value for modelId \(child.modelId).")
                return nil
            }

            // Update the order and start time in the local model
            child.orderInParent += 1
            let orderUpdateSuccess = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: child.orderInParent)
            
            child.startTime += pageDuration
            let startTimeUpdateSuccess = DBManager.shared.updateStartTime(modelId: child.modelId, newValue: child.baseTimeline.startTime)
            
            // Check if both database updates were successful
            if !orderUpdateSuccess || !startTimeUpdateSuccess {
                print("Error: Failed to update the database for modelId \(child.modelId).")
                return nil
            }
            
            updatedID[child.modelId] = child.orderInParent
        }

        return (updatedID, startTime)
    }

}

extension TemplateHandler {
    func performGroupAction(moveModel:MoveModel) {
        
      
        let pageId = currentPageModel?.modelId ?? -1
        let currentModelId = currentModel?.modelId ?? -1
        logger?.logErrorFirebase("[TimelineTrace][performGroupAction] begin type=\(moveModel.type) pageId=\(pageId) oldLast=\(moveModel.oldlastSelectedId) newLast=\(moveModel.newLastSelected) addParentId=\(moveModel.shouldAddParentID ?? -1) removeParentId=\(moveModel.shouldRemoveParentID ?? -1) oldIds=\(moveModel.oldMM.map { $0.modelID }) newIds=\(moveModel.newMM.map { $0.modelID }) isMainThread=\(Thread.isMainThread)", record: false)
        if currentModelId == -1 || pageId == -1 {
            logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingIds currentModelId=\(currentModelId) pageId=\(pageId)")
        }
        deepSetCurrentModel(id: currentPageModel?.modelId ?? -1)
        logger?.logInfo("Action:\(moveModel.type)")
        currentActionState.moveModel = moveModel
        
        deepSetCurrentModel(id: moveModel.newLastSelected)
        // Here I Need deepSetCurrentModel
        currentActionState.updateThumb = true
        currentActionState.updatePageAndParentThumb = true

        currentActionState.shouldRefreshOnAddComponent = true
        let endModelId = currentModel?.modelId ?? -1
        logger?.logErrorFirebase("[TimelineTrace][performGroupAction] end type=\(moveModel.type) currentModelId=\(endModelId) isMainThread=\(Thread.isMainThread)", record: false)
        if endModelId == -1 {
            logger?.logErrorFirebaseWithBacktrace("[TimelineTraceGuard] reason=missingCurrentModelId currentModelId=\(endModelId)")
        }

    }
    
     
    public func deepSetCurrentModel(id:Int , smartSelect: Bool = true , deepSmartSelect: Bool = true ) -> Bool {
        

        if playerControls?.renderState == .Playing{
            playerControls?.renderState = .Paused
//            return false
        }
        
        if let model = currentModel , model.modelId == id {
            logger?.printLog("Same Item Selected Again")
            setSmartCurrentTime(selectedModel: model)
            return true
        }
        
//        if lastSelectedId != id{
//            lastSelectedId = currentModel?.modelId
//        }
        
        if smartSelect {
            // let start deep inspection
            deepSelectionInProgress = true
            
            // if model id is -1 then base is selected
            
            var currentParents : [ParentModel] = []
            
            // Step 2: Get the parents for the current child (ChildD)
            if let currentModel  = currentModel {
                currentParents = requestParentModelsForCurrentChild(id: currentModel.modelId) as! [ParentModel]
                    if let currentModel = currentModel as? ParentModel,currentModel.modelType == .Parent, currentModel.editState {
                        currentParents.append(currentModel)
                    }
                
            }
            
            var newParents : [ParentModel] = []
            
            if let newModelToSelect = getModel(modelId: id) {
                // Step 3: Get the parents for the new child (ChildE)
                newParents = requestParentModelsForCurrentChild(id: newModelToSelect.modelId) as! [ParentModel]
            }
            
            // Step 4: Identify parents to be turned off and on based on the difference
            let parentsToTurnOff = currentParents.filter { parent in
                return !newParents.contains { newParent in newParent.modelId == parent.modelId }
            }
            
            let parentsToTurnOn = newParents.filter { newParent in
                return !currentParents.contains { parent in parent.modelId == newParent.modelId }
            }
            
            
            
            
            
            
            // Step 5: Turn off the editState for the parents that are no longer relevant
            for parent in parentsToTurnOff {
                // Skip if parent is of type 'Page'
                if parent.modelType == .Page {
                    continue
                }
                
                
                if parent.editState {
                    logger?.logInfo("Turning off editState for Parent \(parent.modelId)")
                    setCurrentModel(id: parent.modelId)
                    parent.editState = false
                }
            }
            
            // Step 6: Turn on the editState for the parents that need to be edited
            for parent in parentsToTurnOn.reversed() {
                // Skip if parent is of type 'Page'
                if parent.modelType == .Page {
                    continue
                }
                
                if !parent.editState {
                    logger?.logInfo("Turning on editState for Parent \(parent.modelId)")
                    setCurrentModel(id: parent.modelId)
                    parent.editState = true
                }
            }
            
            deepSelectionInProgress = false
        }
        setCurrentModel(id: id,deepSmartSelect: deepSmartSelect)
        
        return true
    }
    

}


struct BaseFrameAndStartTime{
    var modelID : Int
    var baseFrame : Frame
    var baseTime : StartDuration
}

struct ParentBFAndTime{
    var modelID : Int
    var baseFrame : Frame
    var baseTime : StartDuration
    var childs : [BaseFrameAndStartTime]
}

public func downsample(imageAt imageURL: String,
                to pointSize: CGSize,
                scale: CGFloat = UIScreen.main.scale) -> UIImage? {

    // Create an CGImageSource that represent an image
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
//        return nil
//    }
    guard let imageSource = CGImageSourceCreateWithData(UIImage(named: imageURL)!.pngData() as! CFData, imageSourceOptions)  else {
        return nil
    }
    
    // Calculate the desired dimension
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    // Perform downsampling
    let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
        return nil
    }
    
    // Return the downsampled image as UIImage
    return UIImage(cgImage: downsampledImage)
}


public func downsampleLocal(imageData: Data,
                to pointSize: CGSize,
                scale: CGFloat = UIScreen.main.scale) -> UIImage? {

    // Create an CGImageSource that represent an image
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
//        return nil
//    }
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)  else {
        return nil
    }
    
    // Calculate the desired dimension
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    // Perform downsampling
    let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
        return nil
    }
    
    // Return the downsampled image as UIImage
    return UIImage(cgImage: downsampledImage)
}
