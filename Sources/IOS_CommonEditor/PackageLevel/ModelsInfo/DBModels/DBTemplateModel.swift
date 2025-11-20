//
//  Templates.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation


//struct DBTemplateModel:DBTemplateModelProtocol, Identifiable {
//    var id: UUID = UUID()
//    var category: String = ""
//    var categoryTemp: String = ""
//    var isPremium: Int = 0
//    var ratioId: Int = 0
//    var sequence_Temp: Int = 0
//    var templateId: Int = 0
//    var templateName: String = ""
//    var thumbLocalPath: String = ""
//    var thumbServerPath: String = ""
//    var thumbTime: Double = 0.0
//    var totalDuration: Double = 0.0
//}

public enum OutputType : String  {
    case Image = "Image"
    case Video = "Video"
    case GIF = "Gif"
}

public struct DBTemplateModel: Identifiable, Hashable {
    public var id: UUID = UUID()
    public var category: String
    public var categoryTemp: String
    public var isPremium: Int
    public var ratioId: Int
    public var sequence_Temp: Int
    public var templateId: Int
    public var templateName: String
    public var thumbLocalPath: String
    public var thumbServerPath: String
    public var thumbTime: Double
    public var totalDuration: Double
    var serverTemplateId : Int
    var dataPath : String
    var isRelease : Int
    var isDetailDownloaded : Int
    // Append the properties with Personalised by NK.
    var colorPalleteId : Int
    var fontSetId : Int
    var eventData : String
    var eventTime : String
    var venue : String
    var name1 : String
    var name2 : String
    var rsvp : String
    var baseColor : String
    var layoutId : Int
    //Append the properties for RSVP by Jay
    var eventId : Int
    var templateStatus: String
    public var originalTemplate: Int
    var templateEventStatus: String
    var softDelete: Int
    var eventTemplateJson: String
    var userId: Int
    var eventStartDate: String
    var showWatermark : Int
    // End
    public var createdAt: String
    public var updatedAt: String
  //  let templateID: String
    
    var outputType = OutputType.Image
    
  
    // Initializer taking a DBTemplate instance and an additional category parameter
    public init(from dbTemplate: ServerDBTemplateHeader) {  // DBTemlateData
        
        self.category = dbTemplate.categoryTemp
        self.categoryTemp = dbTemplate.categoryTemp
        self.isPremium = Int(dbTemplate.isPremium) ?? 0
        self.ratioId = Int(dbTemplate.ratioID) ?? 0
        self.sequence_Temp = Int(dbTemplate.sequence) ?? 0
        self.templateId = Int(dbTemplate.templateID) ?? 0
        self.templateName = dbTemplate.categoryTemp
        self.thumbLocalPath = ""
        self.thumbServerPath = dbTemplate.thumbServerPath
        self.thumbTime = 0.0
        self.totalDuration = 5.0 // JD Hardcode HK Correction
        self.serverTemplateId = -1
        self.dataPath = dbTemplate.dataPath
        self.isRelease = 0
        self.isDetailDownloaded = 0
        self.colorPalleteId = 0
        self.fontSetId = 0
        self.eventData = ""
        self.eventTime = ""
        self.venue = ""
        self.name1 = ""
        self.name2 = ""
        self.rsvp = ""
        self.baseColor = ""
        self.layoutId = 0
        self.eventId = -1
        self.templateStatus = ""
        self.originalTemplate = 0
        self.templateEventStatus = ""
        self.softDelete = 1
        self.eventTemplateJson = ""
        self.userId = -1
        self.eventStartDate = ""
        self.showWatermark = 0
        self.createdAt = ""
        self.updatedAt = ""
       // self.templateID = dbTemplate.
    }
    
    public init(from dbTemplate: TemplateHeaderModel) {  // DBTemlateData
        
        self.category = "nil"
        self.categoryTemp = "dbTemplate.categoryTemp"
        self.isPremium = Int(dbTemplate.isPremium) ?? 0
        self.ratioId =  0
        self.sequence_Temp = 0
        self.templateId = 0
        self.templateName = "dbTemplate.categoryTemp"
        self.thumbLocalPath = ""
        self.thumbServerPath = dbTemplate.thumbServerPath
        self.thumbTime = 0.0
        self.totalDuration = 5.0 // JD Hardcode HK Correction
        self.serverTemplateId = -1
        self.dataPath = dbTemplate.dataPath
        self.isRelease = 0
        self.isDetailDownloaded = 0
        self.colorPalleteId = 0
        self.fontSetId =  0
        self.eventData = ""
        self.eventTime = ""
        self.venue = ""
        self.name1 = ""
        self.name2 = ""
        self.rsvp = ""
        self.baseColor = ""
        self.layoutId = 0
        self.eventId = -1
        self.templateStatus = ""
        self.originalTemplate = 0
        self.templateEventStatus = ""
        self.softDelete = 1
        self.eventTemplateJson = ""
        self.userId = -1
        self.eventStartDate = ""
        self.showWatermark = 0
        self.createdAt = ""
        self.updatedAt = ""
       // self.templateID = dbTemplate.
    }
    
    public init(from templateData:ServerDBTemplate){
        self.category = templateData.category!
        self.categoryTemp = templateData.categoryTemp
        self.isPremium = Int(templateData.isPremium) ?? 0
        self.ratioId = Int(templateData.ratioID) ?? 0
        self.sequence_Temp = Int(templateData.sequence) ?? 0
        self.templateId = Int(templateData.templateID) ?? 0
        self.templateName = templateData.categoryTemp
        self.thumbLocalPath = templateData.thumbLocalPath ?? ""
        self.thumbServerPath = templateData.thumbServerPath
        self.thumbTime = Double(templateData.thumbTime ) ?? 0.0
        self.totalDuration = Double(templateData.totalDuration ) ?? 0.0
        self.serverTemplateId = templateData.serverTemplateID ?? -1
        self.dataPath = templateData.dataPath
        self.isRelease = 0
        self.isDetailDownloaded = 0
        self.colorPalleteId = Int(templateData.colorPalleteId ?? "0") ?? 0
        self.fontSetId = Int(templateData.fontSetId ?? "0") ?? 0
        self.eventData = templateData.eventData ?? ""
        self.eventTime = templateData.eventTime ?? ""
        self.venue = templateData.venue ?? ""
        self.name1 = templateData.name1 ?? ""
        self.name2 = templateData.name2 ?? ""
        self.rsvp = templateData.rsvp ?? ""
        self.baseColor = templateData.baseColor ?? ""
        self.layoutId = Int(templateData.layoutId ?? "0") ?? 0
        self.eventId = -1
        self.templateStatus = ""
        self.originalTemplate = 0
        self.templateEventStatus = ""
        self.softDelete = 1
        self.eventTemplateJson = ""
        self.userId = -1
        self.eventStartDate = ""
        self.showWatermark = Int(templateData.showWatermark ?? "0") ?? 0
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    
    // Empty initializer
    public init() {
        self.category = ""
        self.categoryTemp = ""
        self.isPremium = 0
        self.ratioId = 0
        self.sequence_Temp = 0
        self.templateId = 0
        self.templateName = ""
        self.thumbLocalPath = ""
        self.thumbServerPath = ""
        self.thumbTime = 0.0
        self.totalDuration = 0.0
        self.serverTemplateId = -1
        self.dataPath = ""
        self.isRelease = 0
        self.isDetailDownloaded = 0
        self.colorPalleteId = 0
        self.fontSetId =  0
        self.eventData = ""
        self.eventTime = ""
        self.venue = ""
        self.name1 = ""
        self.name2 = ""
        self.rsvp = ""
        self.baseColor = ""
        self.layoutId = 0
        self.eventId = -1
        self.templateStatus = ""
        self.originalTemplate = 0
        self.templateEventStatus = ""
        self.softDelete = 1
        self.eventTemplateJson = ""
        self.userId = -1
        self.eventStartDate = ""
        self.showWatermark = 0
        self.createdAt = ""
        self.updatedAt = ""
    }
//
    // Conformance to Hashable protocol
    public func hash(into hasher: inout Hasher) {
          hasher.combine(id)
      }
      
      // Conformance to Equatable protocol
      static public func == (lhs: DBTemplateModel, rhs: DBTemplateModel) -> Bool {
          return lhs.id == rhs.id
      }
}

