//
//  TemplateInfo.swift
//  MetalEngine
//
//  Created by HKBeast on 27/07/23.
//

import Foundation

public class TemplateInfo : ObservableObject {
    
    
    static public func createDefaultTemplate() -> TemplateInfo{
        let templateInfo = TemplateInfo()
        // db entry
        //template id
        templateInfo.category = "DRAFT"
        templateInfo.categoryTemp = "USER"
        var templateModel = templateInfo.getDBTemplateModel()
        templateModel.templateEventStatus = "UNPUBLISHED"
        let templateId = DBManager.shared.replaceTemplateRowIfNeeded(template: templateModel)
        
        let createdAtDate = Date()
        // Create a DateFormatter
        let dateFormatter = DateFormatter()

        // Set the desired date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert Date to String
        let createdAtString = dateFormatter.string(from: createdAtDate)

        // Print the value
        print("Created At: \(createdAtString)")
        
        _ = DBManager.shared.updateTemplateCreatedDate(templateId: templateId, newValue: createdAtString)
        
        templateInfo.templateId = templateId
        // entry for music ith templateID
        
        var musicInfo = MusicInfo()
        
        musicInfo.parentID = templateId
        musicInfo.templateID = templateId
        musicInfo.musicPath = "first_melody.mp3"
        musicInfo.name = "first melody"
       let musicID = DBMediator.shared.updateMusicInfo(musicInfo: musicInfo)
        
        
        
        let pageInfo = PageInfo()
        let size = getProportionalSize(currentSize: CGSize(width: 1, height: 1), newSize: CGSize(width: 300, height: 300))
        let center = reCalculateCenter(CGPoint(x: 0.5, y: 0.5), currentSize: CGSize(width: 1, height: 1), newSize: size)
        pageInfo.baseFrame.size = size
        pageInfo.baseFrame.center = center
        pageInfo.templateID = templateId
        pageInfo.parentId = templateId
        
        var imageModel = pageInfo.getDBImageModel()
        imageModel.templateID = templateId
        let dataId = DBMediator.shared.updateImageModel(imageModel: imageModel)
        pageInfo.dataId = dataId
        
        if pageInfo.overlayID != -1{
            var overlayModel = pageInfo.getOverlayModel()
            
            overlayModel.templateID = templateId
            let overlayDataId = DBMediator.shared.updateImageModel(imageModel: overlayModel)
            pageInfo.overlayDataId = overlayDataId
        }
        
        let baseModel = pageInfo.getBaseModel(refSize: size)
        let modelId = DBMediator.shared.updateBaseModel(baseModel: baseModel)
        pageInfo.modelId = modelId
        
        templateInfo.pageInfo.append(pageInfo)
        // insert imageModel and get data ID
        // page.data = dataid
        // check for overlay -1
        // // entry page.basemodel
            // pageinfor.modelID = id
        // insert animation for modelID of page
        //page.animationID = id
        //template.append(page)
        // return template
        
        
       return templateInfo
        
    }
    
    static func createDefaultTemplateForImage(imagePath: String? = nil) -> TemplateInfo{
        let templateInfo = TemplateInfo()
        // db entry
        //template id
        templateInfo.category = "DRAFT"
        templateInfo.categoryTemp = "USER"
        
        var templateModel = templateInfo.getDBTemplateModel()
        
        templateModel.templateEventStatus = "UNPUBLISHED"
        let templateId = DBManager.shared.replaceTemplateRowIfNeeded(template: templateModel)
        
        let createdAtDate = Date()
        // Create a DateFormatter
        let dateFormatter = DateFormatter()

        // Set the desired date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert Date to String
        let createdAtString = dateFormatter.string(from: createdAtDate)

        // Print the value
        print("Created At: \(createdAtString)")
        
        _ = DBManager.shared.updateTemplateCreatedDate(templateId: templateId, newValue: createdAtString)
        
        templateInfo.templateId = templateId
        // entry for music ith templateID
        
        var musicInfo = MusicInfo()
        
        musicInfo.parentID = templateId
        musicInfo.templateID = templateId
        musicInfo.musicPath = "first_melody.mp3"
        musicInfo.name = "first melody"
        
        let musicID = DBMediator.shared.updateMusicInfo(musicInfo: musicInfo)
        
        
        
        let pageInfo = PageInfo()
        let size = getProportionalSize(currentSize: CGSize(width: 1, height: 1), newSize: CGSize(width: 300, height: 300))
        let center = reCalculateCenter(CGPoint(x: 0.5, y: 0.5), currentSize: CGSize(width: 1, height: 1), newSize: size)
        pageInfo.baseFrame.size = size
        pageInfo.baseFrame.center = center
        pageInfo.templateID = templateId
        pageInfo.parentId = templateId
        pageInfo.prevAvailableWidth = Float(size.width)
        pageInfo.prevAvailableHeight = Float(size.height)
        
        var imageModel = pageInfo.getDBImageModel()
        if let localPath = imagePath{
            
            imageModel.localPath = localPath
            imageModel.imageWidth = 300
            imageModel.imageHeight = 300
            imageModel.sourceTYPE = SOURCETYPE.DOCUMENT.rawValue
            imageModel.imageType = ImageSourceType.IMAGE.rawValue
            pageInfo.setImageModel(image: imageModel)
//            imageModel.sourceType = .DOCUMENT
        }
        
        imageModel.templateID = templateId
        let dataId = DBMediator.shared.updateImageModel(imageModel: imageModel)
        pageInfo.dataId = dataId
        
        if pageInfo.overlayID != -1{
            var overlayModel = pageInfo.getOverlayModel()
            
            overlayModel.templateID = templateId
            let overlayDataId = DBMediator.shared.updateImageModel(imageModel: overlayModel)
            pageInfo.overlayDataId = overlayDataId
        }
        
        let baseModel = pageInfo.getBaseModel(refSize: size)
        let modelId = DBMediator.shared.updateBaseModel(baseModel: baseModel)
        pageInfo.modelId = modelId
        
        pageInfo.setImageModel(image:imageModel)
        templateInfo.pageInfo.append(pageInfo)
        // insert imageModel and get data ID
        // page.data = dataid
        // check for overlay -1
        // // entry page.basemodel
            // pageinfor.modelID = id
        // insert animation for modelID of page
        //page.animationID = id
        //template.append(page)
        // return template
        
        
       return templateInfo
        
    }
    
    public var category: String = ""
    var categoryTemp: String = ""
    public var isPremium: Int = 0
    public var ratioId: Int = 1
    var sequence_Temp: Int = 0
    public var templateId: Int = 0
    @Published public var templateName: String = ""
    var serverTemplateID = 0
    var thumbLocalPath: String = ""
    var thumbServerPath: String = ""
    @Published  public var thumbTime: Float = 0.0
    @Published public var totalDuration: Float = 5.0
    //Appended properties with the personalised by NK
    
    var colorPalleteId : Int = 0
    var fontSetId : Int = 0
    var eventData : String = ""
    var eventTime : String = ""
    var venue : String = ""
    var name1 : String = ""
    var name2 : String = ""
    var rsvp : String = ""
    var baseColor : String = ""
    var layoutId : Int = 0
    var showWatermark : Int = 0

    
    public var outputType : OutputType = .Image
    //END
    public var pageInfo = [PageInfo]()
   @Published public var ratioInfo = RatioInfo()
    
    var ratioSize : CGSize {
        return CGSize(width: CGFloat(ratioInfo.ratioWidth), height: CGFloat(ratioInfo.ratioHeight))
    }
    
  
    
    
 
    
    
    
    
    // Function to update properties using a DBTemplateModel parameter
    func setTemplateModel(with newModel: DBTemplateModel) {
        self.category = newModel.category
        self.categoryTemp = newModel.categoryTemp
        self.isPremium = newModel.isPremium
        self.ratioId = newModel.ratioId
        self.sequence_Temp = newModel.sequence_Temp
        self.templateId = newModel.templateId
        self.templateName = newModel.templateName
        self.thumbLocalPath = newModel.thumbLocalPath
        self.thumbServerPath = newModel.thumbServerPath
        self.thumbTime = (newModel.thumbTime).toFloat()
        self.totalDuration = (newModel.totalDuration).toFloat()
        self.colorPalleteId = newModel.colorPalleteId
        self.fontSetId = newModel.fontSetId
        self.eventData = newModel.eventData
        self.eventTime = newModel.eventTime
        self.venue = newModel.venue
        self.name1 = newModel.name1
        self.name2 = newModel.name2
        self.rsvp = newModel.rsvp
        self.baseColor = newModel.baseColor
        self.layoutId = newModel.layoutId
        self.showWatermark = newModel.showWatermark
    }
    
    func addPageInfo(pageInfo:PageInfo){
        self.pageInfo.append(pageInfo)
    }
    func getDBTemplateModel() -> DBTemplateModel {
        var templateModel = DBTemplateModel()
        templateModel.category = self.category
        templateModel.categoryTemp = self.categoryTemp
        templateModel.isPremium = self.isPremium
        templateModel.ratioId = self.ratioId
        templateModel.sequence_Temp = self.sequence_Temp
        templateModel.templateId = self.templateId
        templateModel.templateName = self.templateName
        templateModel.thumbLocalPath = self.thumbLocalPath
        templateModel.thumbServerPath = self.thumbServerPath
        templateModel.thumbTime = Double(NSNumber(value: self.thumbTime ).intValue)
        templateModel.totalDuration = Double(NSNumber(value: self.totalDuration ).intValue)
        templateModel.colorPalleteId = self.colorPalleteId
        templateModel.fontSetId = self.fontSetId
        templateModel.eventData = self.eventData
        templateModel.eventTime = self.eventTime
        templateModel.venue = self.venue
        templateModel.name1 = self.name1
        templateModel.name2 = self.name2
        templateModel.rsvp = self.rsvp
        templateModel.baseColor = self.baseColor
        templateModel.layoutId = self.layoutId
        templateModel.showWatermark = self.showWatermark
        return templateModel
    }
    func setTemplateInfo(from serverTemplateModelHeader: ServerDBTemplateHeader) {
        self.categoryTemp = serverTemplateModelHeader.categoryTemp
        self.isPremium = Int(serverTemplateModelHeader.isPremium) ?? 0
        self.ratioId = Int(serverTemplateModelHeader.ratioID) ?? 0
        self.sequence_Temp = Int(serverTemplateModelHeader.sequence) ?? 0
        self.templateId = Int(serverTemplateModelHeader.templateID) ?? 0
        self.thumbServerPath = serverTemplateModelHeader.thumbServerPath
    }
    func setTemplateInfo(from serverTemplateModel: ServerDBTemplate) {
        self.category = serverTemplateModel.category ?? ""
        self.categoryTemp = serverTemplateModel.categoryTemp
        self.serverTemplateID = Int(serverTemplateModel.templateID) ?? 0
        self.isPremium = Int(serverTemplateModel.isPremium) ?? 0
        self.ratioId = Int(serverTemplateModel.ratioID) ?? 0
        self.sequence_Temp = Int(serverTemplateModel.sequence) ?? 0
        self.templateId = Int(serverTemplateModel.templateID) ?? 0
        self.templateName = serverTemplateModel.templateName ?? ""
        self.thumbLocalPath = serverTemplateModel.thumbLocalPath ?? ""
        self.thumbServerPath = serverTemplateModel.thumbServerPath
        self.thumbTime = Float(serverTemplateModel.thumbTime) ?? 0.0
        self.totalDuration = Float(serverTemplateModel.totalDuration) ?? 0.0
        self.colorPalleteId = Int(serverTemplateModel.colorPalleteId ?? "0") ?? 0
        self.fontSetId = Int(serverTemplateModel.fontSetId ?? "0") ?? 0
        self.eventData = serverTemplateModel.eventData ?? ""
        self.eventTime = serverTemplateModel.eventTime ?? ""
        self.venue = serverTemplateModel.venue ?? ""
        self.name1 = serverTemplateModel.name1 ?? ""
        self.name2 = serverTemplateModel.name2 ?? ""
        self.rsvp = serverTemplateModel.rsvp ?? ""
        self.baseColor = serverTemplateModel.baseColor ?? ""
        self.layoutId = Int(serverTemplateModel.layoutId ?? "0") ?? 0
        self.showWatermark = Int(serverTemplateModel.showWatermark ?? "0") ?? 0  

        
    }
    

    func getServerTemplate() -> ServerDBTemplateHeader {
        let dbTemplate = ServerDBTemplateHeader(templateID: String(templateId),
                                     categoryTemp: categoryTemp,
                                     thumbServerPath: thumbServerPath,
                                     isPremium: String(isPremium),
                                     ratioID: String(ratioId),
                                     dataPath: "", // You need to provide a value for this property
                                     isReleased: "", // You need to provide a value for this property
                                     sequence: String(sequence_Temp))
        return dbTemplate
    }

    
    func changeOrderOfPage(oldOrder:Int,newOrder:Int){
        if oldOrder > newOrder{
           let updatedID = increaseOrderOFChildren(at: newOrder)
        }else if newOrder > oldOrder{
            let updatedID = decreaseOrderOFChildren(at: newOrder)
        }
        
    }
    
    func decreaseOrderOFChildren(at order:Int)->Set<Int>{
        var updatedID = Set<Int>()
        for child in pageInfo.prefix(upTo: order){
            child.orderInParent -= 1
            updatedID.insert(child.modelId)
        }
        return updatedID
    }
    
    func increaseOrderOFChildren(at order:Int)->Set<Int>{
        var updatedID = Set<Int>()
        for child in pageInfo.suffix(from: order){
            child.orderInParent += 1
            updatedID.insert(child.modelId)
        }
        return updatedID
    }
    
//    func decreaseOrderOFChildren(from order:Int,to:Int, pageDuration : Float)->([Int:Int], Float){
//        var updatedID = [Int:Int]()
//        var startTime = pageInfo[to].startTime
//        for ord in order...to{
//            let child = pageInfo[ord]
//            child.orderInParent -= 1
//            _ = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: child.orderInParent)
//            child.startTime -= pageDuration
//           _ = DBManager.shared.updateStartTime(modelId: child.modelId, newValue: child.startTime)
//            updatedID[child.modelId] = child.orderInParent
//        }
//        return (updatedID,startTime)
//    }
//
//    func increaseOrderOFChildren(from order:Int,to:Int, pageDuration : Float)->([Int:Int], Float){
//        var updatedID = [Int:Int]()
//        var startTime = pageInfo[to].startTime
//        for ord in order...to{
//            let child = pageInfo[ord]
//            child.orderInParent += 1
//            _ = DBManager.shared.updateOrderInParent(modelId: child.modelId, newValue: child.orderInParent)
//            child.startTime += pageDuration
//            updatedID[child.modelId] = child.orderInParent
//            _ = DBManager.shared.updateStartTime(modelId: child.modelId, newValue: child.startTime)
//        }
//        return (updatedID,startTime)
//    }
}

extension TemplateInfo {
    
    public var isThisTemplateBought : Bool {
        return  isPremium.toBool() && ( category == "DRAFT" || category == "SAVED" )
      
    }
}
