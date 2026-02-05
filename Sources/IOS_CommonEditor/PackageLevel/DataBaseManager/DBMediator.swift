//
//  DBMediator.swift
//  MetalEngine
//
//  Created by HKBeast on 24/07/23.
//

import Foundation
import UIKit
// supposed to be a repository



public class DBMediator : DictCacheProtocol  {
    func cleanUp() {
        resetDictionary()
    }
    
    func addModel(model: BaseModel) {
        childDict[model.modelId] = model
    }
    
    func removeModel(modelId:Int) {
        childDict.removeValue(forKey: modelId)
    }
    
    
    func getModel(modelId : Int) -> BaseModel? {
        return childDict[modelId]
    }
    
    public static var shared = DBMediator()
     var dbManager = DBManager()

    public var childDict = [Int:BaseModel]()
    
    //Template Handler class reference varable for handling the all operation regarding the template.
   // var templateHandler : TemplateHandler = TemplateHandler()
    
    func resetDictionary() {
        childDict.removeAll()
//        templateHandler = TemplateHandler()
    }

    private func normalizePrevAvailableSize(model: BaseModel, parentSize: CGSize, source: String) {
        
        if CGFloat(model.prevAvailableWidth) == model.baseFrame.size.width && CGFloat(model.prevAvailableHeight) == model.baseFrame.size.height {
            return
        }
        let prevW = model.prevAvailableWidth
        let prevH = model.prevAvailableHeight
        if !prevW.isFinite || !prevH.isFinite {
            DBManager.logger?.logError("[preAvailbaleSize changes] \(source) invalid prevAvailable: " +
                                       "modelId=\(model.modelId), modelType=\(model.modelType), " +
                                       "prevW=\(prevW), prevH=\(prevH)")
            return
        }

        // Normalize negative/zero baseFrame sizes from legacy DB values.
        let frameW = model.baseFrame.size.width
        let frameH = model.baseFrame.size.height
        if !frameW.isFinite || !frameH.isFinite || frameW <= 0 || frameH <= 0 {
            let fixedW = abs(frameW)
            let fixedH = abs(frameH)
            if fixedW > 0 && fixedH > 0 {
                model.baseFrame.size = CGSize(width: fixedW, height: fixedH)
                model.width = Float(fixedW)
                model.height = Float(fixedH)
                DBManager.logger?.printLog("[preAvailbaleSize changes] \(source) normalized baseFrame size: " +
                                           "modelId=\(model.modelId), modelType=\(model.modelType), " +
                                           "frameW=\(frameW)->\(fixedW), frameH=\(frameH)->\(fixedH)")
            } else {
                DBManager.logger?.logError("[preAvailbaleSize changes] \(source) baseFrame invalid: " +
                                           "modelId=\(model.modelId), modelType=\(model.modelType), " +
                                           "frameW=\(frameW), frameH=\(frameH)")
                return
            }
        }

        if prevW <= 0 || prevH <= 0 {
            let fallbackW = Float(model.baseFrame.size.width)
            let fallbackH = Float(model.baseFrame.size.height)
            if fallbackW <= 0 || fallbackH <= 0 {
                DBManager.logger?.logError("[preAvailbaleSize changes] \(source) fallback invalid: " +
                                           "modelId=\(model.modelId), modelType=\(model.modelType), " +
                                           "fallbackW=\(fallbackW), fallbackH=\(fallbackH)")
                return
            }
            model.prevAvailableWidth = fallbackW
            model.prevAvailableHeight = fallbackH
            DBManager.logger?.printLog("[preAvailbaleSize changes] \(source) normalized prevAvailable: " +
                                       "modelId=\(model.modelId), modelType=\(model.modelType), " +
                                       "prevW=\(prevW)->\(fallbackW), prevH=\(prevH)->\(fallbackH)")
        }

        if parentSize.width > 0 && parentSize.height > 0 {
            _ = dbManager.updateBaseFrameWithPrevious(modelId: model.modelId,
                                                      newValue: model.baseFrame,
                                                      parentFrame: parentSize,
                                                      previousWidth: CGFloat(model.prevAvailableWidth),
                                                      previousHeight: CGFloat(model.prevAvailableHeight))
        } else {
            DBManager.logger?.logError("[preAvailbaleSize changes] \(source) invalid parentSize for DB update: " +
                                       "modelId=\(model.modelId), modelType=\(model.modelType), " +
                                       "parentSize=\(parentSize)")
        }
    }
    //MARK: - Fetch Methods
    
    func fetchCategoryInfoModel() -> [CategoryMetaInfo]{
        var categoryMetaInfo = [CategoryMetaInfo]()
            
        let categorMetaModel = dbManager.getAllCatergoryMetaModel()
            print("\(categorMetaModel)")
        for model in categorMetaModel{
            let newModel = CategoryMetaInfo()
            newModel.setBaseModel(categoryMetaModel: model)
            categoryMetaInfo.append(newModel)
        }
        
            
        return categoryMetaInfo
    }
    func insertCategoryMetaModel(categoryInfo:CategoryMetaInfo){
        let newmodel = categoryInfo.getCategoryMetaModel()
        dbManager.replaceTemplateMetaDataRowIfNeeded(metaData: newmodel)
    }
    
    func fetchStickerInfoModel(modelID:Int,refSize:CGSize)->StickerInfo?{
        
        var  stickerInfo = StickerInfo()
        
        if let baseModel = dbManager.getBaseModelFromDB(modelId: modelID){
            stickerInfo.setBaseModel(baseModel: baseModel, refSize: refSize)
            normalizePrevAvailableSize(model: stickerInfo, parentSize: refSize, source: "fetchStickerInfoModel")
            if baseModel.modelType == "IMAGE"{
                guard let stickerModel = dbManager.getStickerModel(stickerId: baseModel.dataId) else {
                    DBManager.logger?.printLog(" BaseModel found but not sticker")
                    return nil}
                stickerInfo.setStickerModel(stickerModel: stickerModel)
                guard let imageModel = dbManager.getImage(imageId: stickerModel.imageId) else{
                    DBManager.logger?.printLog(" StickerModel found but not Image")
                    return nil
                }
                stickerInfo.setImageModel(image: imageModel)
                return stickerInfo
            }
        }
       return nil
    }
    
    
    func createStickerInfo(baseModel:DBBaseModel,refSize:CGSize) -> StickerInfo? {
        var  stickerInfo = StickerInfo()
        stickerInfo.setBaseModel(baseModel: baseModel, refSize: refSize)
        normalizePrevAvailableSize(model: stickerInfo, parentSize: refSize, source: "createStickerInfo")

        var animationModel = dbManager.getAnimation(modelId: stickerInfo.modelId)
//        animationModel.inAnimationTemplateId = 58
//        animationModel.outAnimationTemplateId = 59
//        animationModel.loopAnimationTemplateId = 52

//        var animationInfo = DBMediator.shared.fetchAnimationInfo(for: 1189 )//101 //185 // 161 // 3759 // 3758
//        let inTemplateModel = DBMediator.shared.fetchAnimTemplateInfo(templateID: 58) // JD HERE TEST
//        let outTemplateModel = DBMediator.shared.fetchAnimTemplateInfo(templateID: 59)
//        let loopTemplateModel = DBMediator.shared.fetchAnimTemplateInfo(templateID: 2)
        stickerInfo.setAnimation(animationModel: animationModel)

        if baseModel.modelType == "IMAGE"{
            guard let stickerModel = dbManager.getStickerModel(stickerId: baseModel.dataId) else {
                DBManager.logger?.printLog(" BaseModel found but not sticker")
                return nil}
            stickerInfo.setStickerModel(stickerModel: stickerModel)
            guard let imageModel = dbManager.getImage(imageId: stickerModel.imageId) else{
                DBManager.logger?.printLog(" StickerModel found but not Image")
                return nil
            }
            stickerInfo.setImageModel(image: imageModel)
            if onlinePreview { addModel(model: stickerInfo);}
            return stickerInfo
        }
        if onlinePreview { addModel(model: stickerInfo) ;}
        return stickerInfo
    }
    

    func createTextInfo(model:DBBaseModel,refSize:CGSize)->TextInfo?{
        var textInfo = TextInfo()
        textInfo.setBaseModel(baseModel: model, refSize: refSize)
        normalizePrevAvailableSize(model: textInfo, parentSize: refSize, source: "createTextInfo")
        
        let animationModel = dbManager.getAnimation(modelId: textInfo.modelId)
         

        textInfo.setAnimation(animationModel: animationModel)

        
            if model.modelType == "TEXT"{
                guard let textModel = dbManager.getTextModel(textId: model.dataId)else{
                    DBManager.logger?.printLog(" BaseModel found but not textModel")
                    return nil
                }
                textInfo.setTextModel(textModel: textModel, engineConfig: DBManager.engineConfig)
                if onlinePreview { addModel(model: textInfo) ; }
                return textInfo
            }
       // addModel(model: textInfo)
        return textInfo
    }
    
    
    
    func fetchAnimTemplateInfo(templateID:Int)->AnimTemplateInfo{
        var animTemplateInfo = AnimTemplateInfo()
        let templateModel = dbManager.getAnimationTemplates(for: templateID)
        let categoryModel = dbManager.getAnimationCategories(for: templateModel.category)
        let keyFrameModels = dbManager.getKeyframeModel(for: templateModel.animationTemplateId)
        animTemplateInfo.setAnimationTemplate(animationTemplate: templateModel)
        animTemplateInfo.setAnimationCategory(animationCategory: categoryModel)
        animTemplateInfo.setKeyFrame(keyFrames: keyFrameModels)
        return animTemplateInfo
    }
    
    func fetchAnimationInfo(for animationId:Int)->AnimationInfo{
         let animationModel = dbManager.getAnimation(modelId: animationId)
            
        let inTemplateModel = fetchAnimTemplateInfo(templateID: 58) // JD HERE TEST
        let outTemplateModel = fetchAnimTemplateInfo(templateID: 59)
        let loopTemplateModel = fetchAnimTemplateInfo(templateID: 2)
        var animationInfo = AnimationInfo(animTemplateInfoForIN: inTemplateModel, animTemplateInfoForLOOP: loopTemplateModel, animTemplateInfoForOUT: outTemplateModel)
        animationInfo.setAnimationModel(animationModel: animationModel)
        return animationInfo
        
    }
    

    
  
    
    func fetchTemplateUsingServerID(server_ID : Int)-> Int{
        let id = dbManager.getTemplateUsingServerID(serverID: server_ID)
        return id
    }
    
    //MARK: - Insert Methods
    func insertMainAnimation(dbAnimation:DBAnimationModel)->Int{
        
        let result = dbManager.replaceAnimationRowIfNeeded(animation: dbAnimation)
        
        
        return result
    }
    
    func insertTextInfo(textInfoModel: TextInfo,parentID:Int,templateID:Int,refSize:CGSize, newOrder: Int)->Int{
        
        let textId = dbManager.replaceTextModelIfNeeded(textDbModel: textInfoModel.getTextModel())
        var baseModel = textInfoModel.getBaseModel(refSize: refSize)
        baseModel.dataId = textId
        baseModel.parentId = parentID
        baseModel.templateID = templateID
        baseModel.orderInParent = newOrder
        baseModel.lockStatus = "N"
        baseModel.modelOpacity = baseModel.modelOpacity * 255
        let baseModelId = dbManager.replaceBaseModelIfNeeded(baseModel: baseModel)
        
        // NK animation entry
        var animation =  textInfoModel.getAnimation()
          animation.modelId = baseModelId
        _ =  dbManager.replaceAnimationRowIfNeeded(animation:animation)
        
        return baseModelId
    }
    
    
    func insertTextInfo(textInfoModel: TextInfo,parentID:Int,templateID:Int,refSize:CGSize)->Int{
        
        let textId = dbManager.replaceTextModelIfNeeded(textDbModel: textInfoModel.getTextModel())
        var baseModel = textInfoModel.getBaseModel(refSize: refSize)
        baseModel.dataId = textId
        baseModel.parentId = parentID
        baseModel.templateID = templateID
        baseModel.modelOpacity = Double(textInfoModel.modelOpacity * 255)
        let baseModelId = dbManager.replaceBaseModelIfNeeded(baseModel: baseModel)
        
        // NK animation entry
        var animation =  textInfoModel.getAnimation()
          animation.modelId = baseModelId
        _ =  dbManager.replaceAnimationRowIfNeeded(animation:animation)
        
        return baseModelId
    }
    
    
    public func insertStickerInfo(stickerInfoModel: StickerInfo,parentID:Int,templateID:Int,refSize:CGSize, newOrder: Int)->Int{
//        let imageModel = stickerInfoModel.getDBImageModel()
        let imageId = dbManager.replaceImageRowIfNeeded(image: stickerInfoModel.getDBImageModel())
//        stickerInfoModel.imageID = imageId
//        stickerInfoModel.imageId = imageId
        
        var stickerModel = stickerInfoModel.getStickerModel()
        stickerModel.imageId = imageId
//        stickerModel.imageID = imageId
        let stickerID = dbManager.replaceStickerRowIfNeeded(stickerDbModel: stickerModel)
        
        stickerModel.stickerId = stickerID
        stickerInfoModel.dataId = stickerID
        stickerInfoModel.parentId = parentID
        stickerInfoModel.templateID = templateID
        stickerInfoModel.softDelete = false 
        var baseModel = stickerInfoModel.getBaseModel(refSize: refSize)
        baseModel.dataId = stickerID
        baseModel.orderInParent = newOrder
        let baseModelID = dbManager.replaceBaseModelIfNeeded(baseModel: baseModel)
//        stickerInfoModel.modelId = baseModelID
      var animation =  stickerInfoModel.getAnimation()
        animation.modelId = baseModelID
        // NK animation entry
       _ =  dbManager.replaceAnimationRowIfNeeded(animation:animation)
//       baseModel
        return baseModelID
    }
    
    func insertTemplateInfo(templateInfoModel: TemplateInfo) -> Int {
        // Insert Template
        let templateID = dbManager.replaceTemplateRowIfNeeded(template: templateInfoModel.getDBTemplateModel())
        
        // Insert Pages
        for pageInfo in templateInfoModel.pageInfo {
            _ = insertPageInfo(pageInfo: pageInfo, templateInfo: templateInfoModel)
        
        }
        
        return templateID
    }

    
    func insertPageInfo(pageInfo:PageInfo,templateInfo:TemplateInfo)->Int{
        let templateID = templateInfo.templateId
        let refSize = templateInfo.ratioSize
        var pageModel = pageInfo
        pageModel.parentId = templateID
        pageModel.templateID = templateID
//            let pageID = dbManager.replaceBaseModelIfNeeded(baseModel: pageInfo.getBaseModel())
       let bgImage = pageInfo.getDBImageModel()
        let bgImageID = dbManager.replaceImageRowIfNeeded(image: bgImage)
        pageModel.dataId = bgImageID
        let bgOverlayID = dbManager.replaceImageRowIfNeeded(image: pageInfo.getOverlayModel())
        pageModel.overlayDataId = bgOverlayID
        
        let pageID = dbManager.replaceBaseModelIfNeeded(baseModel: pageModel.getBaseModel(refSize: refSize))
        insertBaseModelChildren(childrens: pageModel.children, ParentID: pageID, templateID: templateID)
        return pageID
    }
    
    func insertBaseModelChildren(childrens:[BaseModelProtocol],ParentID:Int,templateID:Int){
        for children in childrens{
            var newModel = children
            newModel.templateID = templateID
            newModel.parentId = ParentID
            if newModel.modelType == .Parent{
                let model = newModel as! ParentInfo
             // let id = dbManager.replaceBaseModelIfNeeded(baseModel: model.getBaseModel())
//                insertParentInfo(parentInfo: model, parentID: ParentID, templateID: templateID)
            }
            else if newModel.modelType == .Sticker{
//               var sticekrModel = newMod
//                var model =
//                insertStickerInfo(stickerInfoModel: newModel as! StickerInfo,parentID: ParentID,templateID: templateID, refSize: .zero)
               
                
            }else{
               // insertTextInfo(textInfoModel: newModel as! TextInfo,parentID: ParentID,templateID: templateID, refSize: <#CGSize#>)
            }
        }
    }
    
//    func insertParentInfo(parentInfo:ParentInfo,parentID:Int,templateID:Int,refSize:CGSize){
//        // insertBaseModel
//        var baseModel = parentInfo.getBaseModel(refSize: refSize)
//        baseModel.parentId = parentID
//        let baseModelID = dbManager.replaceBaseModelIfNeeded(baseModel: parentInfo.getBaseModel(refSize: refSize))
//        var animationModel = parentInfo.getAnimation()
//        animationModel.modelId = baseModelID
//        // insertAnimation
//        var animationID = dbManager.replaceAnimationRowIfNeeded(animation: animationModel)
//        for child in parentInfo.children{
//            if child.modelType == .Parent{
//            
////                insertParentInfo(parentInfo: child as! ParentInfo, parentID: baseModelID, templateID: templateID, refSize: baseModel.base)
//            }else if child.modelType == .Sticker{
//                // get Sticker Model
////                insertStickerInfo(stickerInfoModel: child as! StickerInfo, parentID: baseModelID, templateID: templateID, refSize: refSize)
//                // changeStickerModel.parentID
//                // insert it in DB
//            }else if child.modelType == .Text{
//               // insertTextInfo(textInfoModel: child as!TextInfo, parentID: baseModelID, templateID: templateID)
//            }
//        }
//    }
    
    
    //MARK: - Update
    
    public func updateAnimationModel(animationModel:DBAnimationModel)->Int{
        return dbManager.replaceAnimationRowIfNeeded(animation: animationModel)
    }
    func updateStickerModel(stickerModel:DBStickerModel)->Int{
        let modelIndex = dbManager.replaceStickerRowIfNeeded(stickerDbModel: stickerModel)
       return modelIndex
    }
    
    func updateBaseModel(baseModel:DBBaseModel)->Int{
        let modelIndex = dbManager.replaceBaseModelIfNeeded(baseModel: baseModel)
        return modelIndex
    }
    
    func updateTextModel(textModel:DBTextModel)->Int{
        let modelIndex = dbManager.replaceTextModelIfNeeded(textDbModel: textModel)
        return modelIndex
    }
    
    public func updateImageModel(imageModel:DBImageModel)->Int{
        let modelIndex = dbManager.replaceImageRowIfNeeded(image: imageModel)
        return modelIndex
    }
    public func updateMusicInfo(musicInfo:MusicInfo)->Int{
        let modelIndex = dbManager.replaceMusicInfoRowIfNeeded(musicDbModel: musicInfo)
        return modelIndex
    }
    
    func updateTemplateModel(templateModel:DBTemplateModel)->Int{
        let modelIndex = dbManager.replaceTemplateRowIfNeeded(template: templateModel)
        return modelIndex
    }
    
    func updateCategoryMetaModel(categoryMetaInfo: CategoryMetaInfo){
        do{
            try dbManager.updateUserValueInCategoryMetaModel(fieldId: categoryMetaInfo.fieldId, userValue: categoryMetaInfo.userValue)
        }catch{
            print("Error updating in DB")
        }
    }
    
    //MARK: - Delete
    
    func deleteStickerModel(modelId:Int)->Bool{
        let deleted = dbManager.deleteStickerModel(stickerId: modelId)
        return deleted
    }
    
    func deleteTextModel(modelId:Int)->Bool{
        let deleted = dbManager.deleteTextModel(textId: modelId)
        return deleted
    }
    
    func deleteImageModel(modelId:Int)->Bool{
        let deleted = dbManager.deleteImage(imageId: modelId)
        return deleted
    }
    
    func deleteMusicInfo(modelId:Int)->Bool{
        let deleted = dbManager.deleteMusicInfo(musicId: modelId)
        return deleted
    }
    
    func deleteBasemodel(modelId:Int)->Bool{
        let deleted = dbManager.deleteBaseModel(modelId: modelId)
        return deleted
    }
    
    func deleteAnimationModel(modelId:Int)->Bool{
        let deleted = dbManager.deleteAnimation(modelId: modelId)
        return deleted
    }
    
    func deleteTemplateModel(modelId:Int, ratioId : Int)->Bool{
        
        let deleted = dbManager.deleteTemplateRow(templateId: modelId, ratioId: ratioId)
        return deleted
    }
    
    //MARK: -

    var onlinePreview : Bool = false
    
    public func fetchTemplate(tempID:Int,refSize:CGSize , onlinePreview : Bool = true)->TemplateInfo?{
        self.onlinePreview = onlinePreview
        if onlinePreview {
            resetDictionary()
        }
        let tempInfo = TemplateInfo()
        guard var templateModel = dbManager.getTemplate(templateId: tempID) else{
            DBManager.logger?.printLog("template Model not found for templateID: \(tempID)")
            return nil
        }
        if let dbRatioModel = dbManager.getRatioDbModel(ratioId: templateModel.ratioId){
            tempInfo.ratioInfo.setRatioModel(ratioInfo: dbRatioModel, refSize: refSize, logger: DBManager.logger)
        }
        tempInfo.setTemplateModel(with: templateModel)
        let ListOfPages = dbManager.getActivePagesList(templateId: tempID)
        
        if ListOfPages.isEmpty {
            DBManager.logger?.printLog("No Pages Found")
            return tempInfo
        }
        
         for index in 0...ListOfPages.count - 1 {
            let pageModel = ListOfPages[index]
            
             if let pageInfo = createPageInfo(pageModel: pageModel, refSize: tempInfo.ratioSize){
                
                // JD: page center multipler ( now its dynamic for every page centered to currentScene by its order)
               //  logErrorJD(tag: .LockAllLayers)
                // pageInfo.unlockedModel = templateHandler.filterAndTransformLockAll(pageInfo)
                 let baseSize = onlinePreview ? refSize : tempInfo.ratioSize
                pageInfo.baseFrame.center.x = CGFloat(Float((0 + 1)) * Float(pageModel.posX * baseSize.width))
                pageInfo.baseFrame.center.y = CGFloat(Float((0 + 1)) * Float(pageModel.posY * baseSize.height))

                tempInfo.addPageInfo(pageInfo: pageInfo)
            }
        }
        
//        tempInfo.childDict = childDict
       return tempInfo
    }
    func addPageInfo(){
        
    }
    
    func createPageInfo(pageModel:DBBaseModel , refSize:CGSize)->PageInfo?{
       var pageInfo = PageInfo()
        pageInfo.setBaseModel(baseModel: pageModel, refSize: refSize)
        normalizePrevAvailableSize(model: pageInfo, parentSize: refSize, source: "createPageInfo")
        let animationModel = dbManager.getAnimation(modelId: pageInfo.modelId)
         
         
         pageInfo.setAnimation(animationModel: animationModel)
        
        var parentSize : CGSize = CGSize(width: CGFloat(pageInfo.width), height: CGFloat(pageInfo.height))
        // bgInfo
      //  var bgInfo = pageInfo
        
        //add base model in backgroundInfo
//        bgInfo.setBaseModel(baseModel: pageModel, refSize: parentSize)
        
        if var imageModel = dbManager.getImage(imageId: pageInfo.dataId){
            //add Image Model in background info
            pageInfo.setImageModel(image: imageModel)
        }
        
        if let overlayModel = dbManager.getImage(imageId: pageInfo.overlayDataId) {
            //add Overlay Model in background info
            pageInfo.setOverlayModel(image: overlayModel)
        }
        
      
      
//        pageInfo.bgInfo = bgInfo
        
//        pageInfo.setImageModel(image: imageModel)
        let children = dbManager.getChildAndParentModelListOfParent(parentId: pageModel.modelId)
        
        for child in children{
            if child.modelType == "PARENT"{
                if let parentChild = createParentInfo(pageInfo: child, refSize: parentSize){
                    pageInfo.addChild(child: parentChild)
                }
            }
            else if child.modelType == "TEXT"{
                if let textChild =  createTextInfo(model: child, refSize: parentSize){
                    pageInfo.addChild(child: textChild)
                }
            }
            else{
                if let stickerChild = createStickerInfo(baseModel: child, refSize: parentSize){
                    
                    pageInfo.addChild(child: stickerChild)
                }
            }
        }
        if onlinePreview {  addModel(model: pageInfo) ; }

        return pageInfo
    }
    
    func createParentInfo(pageInfo:DBBaseModel,refSize:CGSize)->ParentInfo?{
        var parentInfo = ParentInfo()
        parentInfo.setBaseModel(baseModel: pageInfo as! DBBaseModel, refSize: refSize)
        normalizePrevAvailableSize(model: parentInfo, parentSize: refSize, source: "createParentInfo")
        
        let animationModel = dbManager.getAnimation(modelId: parentInfo.modelId)
         
        
        parentInfo.setAnimation(animationModel: animationModel)
        let children = dbManager.getChildAndParentModelListOfParent(parentId: pageInfo.modelId)
        
        let parentSize : CGSize = CGSize(width: CGFloat(parentInfo.width), height: CGFloat(parentInfo.height))
        
        for child in children{
            if child.modelType == "PARENT"{
                if let parentChild = createParentInfo(pageInfo: child, refSize: parentSize){
                    parentInfo.addChild(child: parentChild)
                }
            }
            else if child.modelType == "TEXT"{
                if let textChild =  createTextInfo(model: child, refSize: parentSize){
                    parentInfo.addChild(child: textChild)
                }
            }
            else{
                if let stickerChild = createStickerInfo(baseModel: child, refSize: parentSize){
                    
                    parentInfo.addChild(child: stickerChild)
                }
            }
        }
        if onlinePreview { addModel(model: parentInfo) ; }

        return parentInfo
    }
    
    // TemplateInfo ()
//    1. GetTemplateModel(ID)
//
//    2. tempInfo.set(db_templateModel)
//
//    3. get list of pages for tempID - > [BaseModels] // page 1
//
//    4. for each pageModel
//    pageInfo = createPageInfo(pageModel)
//    addPage(pageInfo)
//    createParentInfo(baseModel) -> parentInfo
//    var parentInfo()
        
    // setInfo(baseModel)
        
    // getListOfChildren(parentID)
        
    // each child ( BaseModel )
//    if parent {
//    // parentInfo = creatPrentInfo(parent)
//    parentInfo.addChild(parentINfo)
//
//    if sticker {
//    // stickerInfo = createStickerInfo(sticker)
//    parentInfo.addChild(stickerInfo)
//
//    if text { textInfo = createTextInfo(text)
//    parentInfo.addChild(textInfo)
        
        
        
//    createPageInfo(baseModel)->PageINfo
//    var pageInfo()
//    pageInfo.set(baseModel)
//    // get iamge info
//    pageINfo.set(imgeInfo)
//
    // getListOfChildren(baseModel)
        
//    // each child
//    if parent {
//    // parentInfo = creatPrentInfo(parent)
//    parentInfo.addChild(parentINfo)
//
//    if sticker {
//    // stickerInfo = createStickerInfo(sticker)
//    parentInfo.addChild(stickerInfo)
//
//    if text { textInfo = createTextInfo(text)
//    parentInfo.addChild(textInfo)
        
    
    
    
}


//
//
//struct StickerInfo: StickerInfoProtocol , BaseModelInterface {
//    var parentId: Int = 0
//    var modelId: Int = 0
//    var modelType: String = ""
//    var dataId: Int = 0
//    var posX: Double = 0.0
//    var posY: Double = 0.0
//    var width: Double = 0.0
//    var height: Double = 0.0
//    var prevAvailableWidth: Double = 0.0
//    var prevAvailableHeight: Double = 0.0
//    var rotation: Int = 0
//    var modelOpacity: Int = 100
//    var modelFlipHorizontal: Int = 0
//    var modelFlipVertical: Int = 0
//    var lockStatus: String = ""
//    var orderInParent: Int = 0
//    var bgBlurProgress: Int = 0
//    var overlayDataId: Int = 0
//    var overlayOpacity: Int = 100
//    var startTime: Double = 0.0
//    var duration: Double = 0.0
//    var softDelete: Int = 0
//    var isHidden: Bool = false
//
//    var stickerId: Int = 1
//    var imageId: Int = 1
//    var stickerType: String = "PAGE"
//    var stickerFilterType: Int = 0
//    var stickerHue: Int = 0
//    var stickerColor: String = ""
//    var xRotationProg: Int = 1
//    var yRotationProg: Int = 1
//    var zRotationProg: Int = 1
//
//    var imageInfo: ImageInfo?
//
//    
//    func getBaseModel()->BaseModel {
//       return BaseModel(
//    }
//
//        get stickTableInfo () -> StickerInfo {
//
//        }
//
//       func setBaseModel(BaseModel) {
//           self.
//           
//        }
//        setStickInfo
//        setImageInfo
//
//}



/*
 onDuplicate(id) {
 
 var dupicateStickerModel : StickerInfo
 
 
 }
 insertSticker(stickerInfo:StickerInfo)
   var id = db.insertIntoStickerTable(stickerInfo)
 let baseModel = StickerModel as? BaseModel {
 db.insertIntoBaseModelTable(stickerInfo)
 }
 
 fetchStickerInfo(id) -> StickerInfo{
    // var model : BaseModel = getBaseModel(id)
    // var sticker : StickerInfo = getSticker(model.stickerID)

return stickerInfo as! StickerInfo
 */


//
//protocol StickerInfoProtocol {
//    var stickerId: Int { get set }
//    var imageId: Int { get set }
//    var stickerType: String { get set }
//    var stickerFilterType: Int { get set }
//    var stickerHue: Int { get set }
//    var stickerColor: String { get set }
//    var xRotationProg: Int { get set }
//    var yRotationProg: Int { get set }
//    var zRotationProg: Int { get set }
//    var imageInfo: ImageInfo? { get set }
//}
//

//struct ImageInfo {
//    var imageID: Int = 0
//    var imageType: String = ""
//    var serverPath: String = ""
//    var localPath: String = ""
//    var resID: String = ""
//    var isEncrypted: Int = 0
//    var cropX: Float = 0.0
//    var cropY: Float = 0.0
//    var cropW: Float = 0.0
//    var cropH: Float = 0.0
//    var cropStyle: Int = 0
//    var tileMultiple: Float = 1.0
//    var colorInfo: String = ""
//    var imageWidth: Int = 0
//    var imageHeight: Int = 0
//}
//
//protocol BaseModelInterface {
//    var modelId: Int { get set }
//    var modelType: String { get set }
//    var dataId: Int { get set }
//    var posX: Double { get set }
//    var posY: Double { get set }
//    var width: Double { get set }
//    var height: Double { get set }
//    var prevAvailableWidth: Double { get set }
//    var prevAvailableHeight: Double { get set }
//    var rotation: Int { get set }
//    var modelOpacity: Int { get set }
//    var modelFlipHorizontal: Int { get set }
//    var modelFlipVertical: Int { get set }
//    var lockStatus: String { get set }
//    var orderInParent: Int { get set }
//    var parentId: Int { get set }
//    var bgBlurProgress: Int { get set }
//    var overlayDataId: Int { get set }
//    var overlayOpacity: Int { get set }
//    var startTime: Double { get set }
//    var duration: Double { get set }
//    var softDelete: Int { get set }
//    var isHidden: Bool { get set }
//}
//protocol A {
//    func a()
//    var JD:Int { get  }
//}
//
//protocol B {
//    func b()
//    var himanshu : Int { get  }
//}
//
//struct Test: A, B {
//    var JD: Int = 0
//
//    var himanshu: Int = 0
//
//    func a() {
//        printLog("Function a() from protocol A")
//    }
//
//    func b() {
//        printLog("Function b() from protocol B")
//    }
//}
//

extension DBMediator{
    
    func createTemplateInfo(dbTemplate:ServerDBTemplate){
        var templateInfo = TemplateInfo()
        var PageInfo = PageInfo()
        
    }
    
    func downloadServerImage(dbImageModel:ServerImageModel) async->Bool{
        if dbImageModel.imageType == "STORAGEIMAGE"{
            let image:UIImage?
      
            do{
                
                image = try await DBManager.logger?.fetchImage(imageURL: dbImageModel.serverPath)
                if let imageData = image?.pngData() {
                    try DBManager.logger?.saveImageToDocumentsDirectory(imageData: imageData, filename: dbImageModel.serverPath, directory: DBManager.logger!.getAssetPath()!)
                }
               
            }
            catch{
                print("image is not downloaded for server Path")
            }
            return true
        }
        return false
    }
    
    func convertTemplateData(templateData:ServerDBTemplate)->TemplateInfo{
        var templateInfo = TemplateInfo()
        templateInfo.setTemplateInfo(from: templateData)
        // insert Template in db
        let newTemplateID = dbManager.replaceTemplateRowIfNeeded(template: templateInfo.getDBTemplateModel())
        templateInfo.templateId = newTemplateID
        // insert page
        
        
        
        
        if let pages = templateData.pages{
            for page in pages{
                
            }
        }
        return templateInfo
    }
}
