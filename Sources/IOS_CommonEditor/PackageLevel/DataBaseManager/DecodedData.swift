//
//  DecodedData.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 27/02/24.
//

import Foundation
import UIKit



// MARK: Category Decodable Model
public struct ServerCategoryModel: Codable {
    let categoryId: String
    let categoryName: String
    let categoryThumbPath: String? // TODO: Delete From Disk
    let lastModified: String
    let isHeaderDownloaded : String?
    let canDelete : String?
    let categoryThumbType : String?
    let categoryDataPath: String
    let categoryMetaData: [ServerCategoryMetaData]?
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "CATEGORY_ID"
        case categoryName = "CATEGORY_NAME"
        case categoryThumbPath = "CATEGORY_THUMB_PATH"
        case lastModified = "LAST_MODIFIED"
        case isHeaderDownloaded = "IS_HEADER_DOWNLOADED"
        case canDelete  = "CAN_DELETE"
        case categoryThumbType  = "CATEGORY_THUMB_TYPE"
        case categoryDataPath = "CATEGORY_DATA_PATH"
        case categoryMetaData = "Category_Meta_Data"
    }
    
   
}
// MARK: CategoryMetaData Decodable Model
struct ServerCategoryMetaData: Codable {
    let fieldId: String
    let fieldDisplayName: String
    let templateValue: String
    let categoryName: String
    let seq: String
    
    enum CodingKeys: String, CodingKey {
        case fieldId = "FIELD_ID"
        case fieldDisplayName = "FIELD_DISPLAY_NAME"
        case templateValue = "TEMPLATE_VALUE"
        case categoryName = "CATEGORY_NAME"
        case seq = "SEQ"
    }
}
// MARK: Template Decodable Model
public struct ServerDBTemplateHeader: Codable {
    let templateID: String
    let categoryTemp: String
    let thumbServerPath: String
    let isPremium: String
    let ratioID: String
    let dataPath: String
    let isReleased: String
    let sequence: String

    enum CodingKeys: String, CodingKey {
        case templateID = "TEMPLATE_ID"
        case categoryTemp = "CATEGORY_TEMP"
        case thumbServerPath = "THUMB_SERVER_PATH"
        case isPremium = "IS_PREMIUM"
        case ratioID = "RATIO_ID"
        case dataPath = "DATA_PATH"
        case isReleased = "IS_RELEASED"
        case sequence = "SEQUENCE"
    }
}

public struct AllTemplateData: Codable {
    let category: String
    let templates: [ServerDBTemplate]
    
    enum CodingKeys: String, CodingKey {
        case category = "Category"
        case templates = "Templates"
    }
}


// MARK: Template Data Decodable Model
public struct ServerDBTemplate: Codable {
    public let templateID: String
    public let category: String?
    public let templateName: String?
    public let ratioID: String
    public let thumbServerPath: String
    public let thumbLocalPath: String?
    public let thumbTime: String
    public let totalDuration: String
    public let sequence: String
    public let isPremium: String
    public let categoryTemp: String
    public let serverTemplateID:Int?
    public let dataPath: String
    public let isReleased: String?
    public let colorPalleteId : String?
    public let fontSetId : String?
    public let eventData : String?
    public let eventTime : String?
    public let venue : String?
    public let name1 : String?
    public let name2 : String?
    public let rsvp : String?
    public let baseColor : String?
    public let layoutId : String?
    public let music: ServerMusicModel?
    public let pages: [ServerPageModel]?
    public var showWatermark : String?
    
    public init(templateID: String, category: String?, templateName: String?, ratioID: String, thumbServerPath: String, thumbLocalPath: String?, thumbTime: String, totalDuration: String, sequence: String, isPremium: String, categoryTemp: String, serverTemplateID: Int?, dataPath: String, isReleased: String?, colorPalleteId: String?, fontSetId: String?, eventData: String?, eventTime: String?, venue: String?, name1: String?, name2: String?, rsvp: String?, baseColor: String?, layoutId: String?, music: ServerMusicModel?, pages: [ServerPageModel]?, showWatermark: String? = nil) {
        self.templateID = templateID
        self.category = category
        self.templateName = templateName
        self.ratioID = ratioID
        self.thumbServerPath = thumbServerPath
        self.thumbLocalPath = thumbLocalPath
        self.thumbTime = thumbTime
        self.totalDuration = totalDuration
        self.sequence = sequence
        self.isPremium = isPremium
        self.categoryTemp = categoryTemp
        self.serverTemplateID = serverTemplateID
        self.dataPath = dataPath
        self.isReleased = isReleased
        self.colorPalleteId = colorPalleteId
        self.fontSetId = fontSetId
        self.eventData = eventData
        self.eventTime = eventTime
        self.venue = venue
        self.name1 = name1
        self.name2 = name2
        self.rsvp = rsvp
        self.baseColor = baseColor
        self.layoutId = layoutId
        self.music = music
        self.pages = pages
        self.showWatermark = showWatermark
    }
    
    enum CodingKeys: String, CodingKey {
        case templateID = "TEMPLATE_ID"
        case category = "CATEGORY"
        case templateName = "TEMPLATE_NAME"
        case ratioID = "RATIO_ID"
        case thumbServerPath = "THUMB_SERVER_PATH"
        case thumbLocalPath = "THUMB_LOCAL_PATH"
        case thumbTime = "THUMB_TIME"
        case totalDuration = "TOTAL_DURATION"
        case sequence = "SEQUENCE"
        case isPremium = "IS_PREMIUM"
        case categoryTemp = "CATEGORY_TEMP"
        case dataPath = "DATA_PATH"
        case music = "MUSIC"
        case pages = "PAGES"
        case serverTemplateID = "SERVER_TEMPLATE_ID"
        case isReleased = "IS_RELEASED"
        case colorPalleteId = "colorPalleteId"
        case fontSetId = "fontSetId"
        case eventData = "eventData"
        case eventTime = "eventTime"
        case venue = "venue"
        case name1 = "name1"
        case name2 = "name2"
        case rsvp = "rsvp"
        case baseColor = "baseColor"
        case layoutId = "layoutId"
        case showWatermark = "SHOW_WM_GUEST"

    }
}

// MARK: Music Decodable Model
public struct ServerMusicModel: Codable {
    public let musicID: String
    public let musicType: String
    public let name: String
    public let musicPath: String
    public let parentID: String
    public let parentType: String
    public let startTimeOfAudio: String
    public let endTimeOfAudio: String
    public let startTime: String
    public let duration: String
    public let templateID: String

    enum CodingKeys: String, CodingKey {
        case musicID = "MUSIC_ID"
        case musicType = "MUSIC_TYPE"
        case name = "NAME"
        case musicPath = "MUSIC_PATH"
        case parentID = "PARENT_ID"
        case parentType = "PARENT_TYPE"
        case startTimeOfAudio = "START_TIME_OF_AUDIO"
        case endTimeOfAudio = "END_TIME_OF_AUDIO"
        case startTime = "START_TIME"
        case duration = "DURATION"
        case templateID = "TEMPLATE_ID"
    }
}

// MARK: Page Decodable Model
public struct ServerPageModel: Codable {
    public let modelID: String
    public let modelType: String
    public let dataID: String
    public let posX: String
    public let posY: String
    public let width: String
    public let height: String
    public let prevAvailableWidth: String
    public let prevAvailableHeight: String
    public let rotation: String
    public let modelOpacity: String
    public let modelFlipHorizontal: String
    public let modelFlipVertical: String
    public let lockStatus: String
    public let orderInParent: String
    public let parentID: String
    public let bgBlurProgress: String
    public let overlayDataID: String
    public let overlayOpacity: String
    public let startTime: String
    public let duration: String
    public let softDelete: String
    public var templateID: String
    public let hasMask: String?
    public let maskShape: String?
    public var image: ServerImageModel?
    public var overlayImage: ServerImageModel?
    public var children: [ServerBaseModel]?
    public var animation: ServerAnimationModel?

    enum CodingKeys: String, CodingKey {
        case modelID = "MODEL_ID"
        case modelType = "MODEL_TYPE"
        case dataID = "DATA_ID"
        case posX = "POS_X"
        case posY = "POS_Y"
        case width = "WIDTH"
        case height = "HEIGHT"
        case prevAvailableWidth = "PREV_AVAILABLE_WIDTH"
        case prevAvailableHeight = "PREV_AVAILABLE_HEIGHT"
        case rotation = "ROTATION"
        case modelOpacity = "MODEL_OPACITY"
        case modelFlipHorizontal = "MODEL_FLIP_HORIZONTAL"
        case modelFlipVertical = "MODEL_FLIP_VERTICAL"
        case lockStatus = "LOCK_STATUS"
        case orderInParent = "ORDER_IN_PARENT"
        case parentID = "PARENT_ID"
        case bgBlurProgress = "BG_BLUR_PROGRESS"
        case overlayDataID = "OVERLAY_DATA_ID"
        case overlayOpacity = "OVERLAY_OPACITY"
        case startTime = "START_TIME"
        case duration = "DURATION"
        case softDelete = "SOFT_DELETE"
        case hasMask = "HAS_MASK"
        case maskShape = "MASK_SHAPE"
        case templateID = "TEMPLATE_ID"
        case image = "Image"
        case overlayImage = "OverlayImage"
        case children = "Children"
        case animation = "Animation"
    }
    
    init(modelID: String = "", modelType: String = "", dataID: String = "", posX: String = "", posY: String = "", width: String = "", height: String = "", prevAvailableWidth: String = "", prevAvailableHeight: String = "", rotation: String = "", modelOpacity: String = "", modelFlipHorizontal: String = "", modelFlipVertical: String = "", lockStatus: String = "", orderInParent: String = "", parentID: String = "", bgBlurProgress: String = "", overlayDataID: String = "", overlayOpacity: String = "", startTime: String = "", duration: String = "", softDelete: String = "",hasMask: String? = nil, maskShape: String? = nil, templateID: String = "", image: ServerImageModel? = nil, overlayImage: ServerImageModel? = nil, children: [ServerBaseModel]? = nil, animation: ServerAnimationModel? = nil) {
        self.modelID = modelID
        self.modelType = modelType
        self.dataID = dataID
        self.posX = posX
        self.posY = posY
        self.width = width
        self.height = height
        self.prevAvailableWidth = prevAvailableWidth
        self.prevAvailableHeight = prevAvailableHeight
        self.rotation = rotation
        self.modelOpacity = modelOpacity
        self.modelFlipHorizontal = modelFlipHorizontal
        self.modelFlipVertical = modelFlipVertical
        self.lockStatus = lockStatus
        self.orderInParent = orderInParent
        self.parentID = parentID
        self.bgBlurProgress = bgBlurProgress
        self.overlayDataID = overlayDataID
        self.overlayOpacity = overlayOpacity
        self.startTime = startTime
        self.duration = duration
        self.softDelete = softDelete
        self.hasMask = hasMask
        self.maskShape = maskShape
        self.templateID = templateID
        self.image = image
        self.overlayImage = overlayImage
        self.children = children
        self.animation = animation
    }
}

// MARK: Image Decodable Model
public struct ServerImageModel: Codable {
    public let imageID: String
    public let imageType: String
    public let serverPath: String
    public let localPath: String
    public let resID: String
    public let isEncrypted: String
    public let cropX: String
    public let cropY: String
    public let cropW: String
    public let cropH: String
    public let cropStyle: String
    public let tileMultiple: String
    public let colorInfo: String
    public let imageWidth: String
    public let imageHeight: String
    public var templateID: String

    enum CodingKeys: String, CodingKey {
        case imageID = "IMAGE_ID"
        case imageType = "IMAGE_TYPE"
        case serverPath = "SERVER_PATH"
        case localPath = "LOCAL_PATH"
        case resID = "RES_ID"
        case isEncrypted = "IS_ENCRYPTED"
        case cropX = "CROP_X"
        case cropY = "CROP_Y"
        case cropW = "CROP_W"
        case cropH = "CROP_H"
        case cropStyle = "CROP_STYLE"
        case tileMultiple = "TILE_MULTIPLE"
        case colorInfo = "COLOR_INFO"
        case imageWidth = "IMAGE_WIDTH"
        case imageHeight = "IMAGE_HEIGHT"
        case templateID = "TEMPLATE_ID"
    }
}

// MARK: Base Model Decodable Model
public struct ServerBaseModel: Codable {
    public let modelID: String
    public let modelType: String
    public let dataID: String
    public let posX: String
    public let posY: String
    public let width: String
    public let height: String
    public let prevAvailableWidth: String
    public let prevAvailableHeight: String
    public let rotation: String
    public let modelOpacity: String
    public let modelFlipHorizontal: String
    public let modelFlipVertical: String
    public let lockStatus: String
    public let orderInParent: String
    public let parentID: String
    public let bgBlurProgress: String
    public let overlayDataID: String
    public let overlayOpacity: String
    public let startTime: String
    public let duration: String
    public let softDelete: String
    public let hasMask: String?
    public let maskShape: String?
    public var templateID: String
    public var stickerInfo: ServerStickerModel?
    public var textInfo : ServerTextModel?
    public var animation: ServerAnimationModel?
    public var parent : ServerParentModel?
    public var children: [ServerBaseModel]?

    enum CodingKeys: String, CodingKey {
        case modelID = "MODEL_ID"
        case modelType = "MODEL_TYPE"
        case dataID = "DATA_ID"
        case posX = "POS_X"
        case posY = "POS_Y"
        case width = "WIDTH"
        case height = "HEIGHT"
        case prevAvailableWidth = "PREV_AVAILABLE_WIDTH"
        case prevAvailableHeight = "PREV_AVAILABLE_HEIGHT"
        case rotation = "ROTATION"
        case modelOpacity = "MODEL_OPACITY"
        case modelFlipHorizontal = "MODEL_FLIP_HORIZONTAL"
        case modelFlipVertical = "MODEL_FLIP_VERTICAL"
        case lockStatus = "LOCK_STATUS"
        case orderInParent = "ORDER_IN_PARENT"
        case parentID = "PARENT_ID"
        case bgBlurProgress = "BG_BLUR_PROGRESS"
        case overlayDataID = "OVERLAY_DATA_ID"
        case overlayOpacity = "OVERLAY_OPACITY"
        case startTime = "START_TIME"
        case duration = "DURATION"
        case softDelete = "SOFT_DELETE"
        case hasMask = "HAS_MASK"
        case maskShape = "MASK_SHAPE"
        case templateID = "TEMPLATE_ID"
        case stickerInfo = "StickerInfo"
        case textInfo = "TextInfo"
        case parent = "Parent"
        case animation = "Animation"
        case children = "Children"
    }
    
    init(modelID: String = "", modelType: String = "", dataID: String = "", posX: String = "", posY: String = "", width: String = "", height: String = "", prevAvailableWidth: String = "", prevAvailableHeight: String = "", rotation: String = "", modelOpacity: String = "", modelFlipHorizontal: String = "", modelFlipVertical: String = "", lockStatus: String = "", orderInParent: String = "", parentID: String = "", bgBlurProgress: String = "", overlayDataID: String = "", overlayOpacity: String = "", startTime: String = "", duration: String = "", softDelete: String = "",hasMask: String? = nil, maskShape: String? = nil, templateID: String = "", stickerInfo: ServerStickerModel? = nil, textInfo: ServerTextModel? = nil, animation: ServerAnimationModel? = nil, parent: ServerParentModel? = nil, children: [ServerBaseModel]? = nil) {
        self.modelID = modelID
        self.modelType = modelType
        self.dataID = dataID
        self.posX = posX
        self.posY = posY
        self.width = width
        self.height = height
        self.prevAvailableWidth = prevAvailableWidth
        self.prevAvailableHeight = prevAvailableHeight
        self.rotation = rotation
        self.modelOpacity = modelOpacity
        self.modelFlipHorizontal = modelFlipHorizontal
        self.modelFlipVertical = modelFlipVertical
        self.lockStatus = lockStatus
        self.orderInParent = orderInParent
        self.parentID = parentID
        self.bgBlurProgress = bgBlurProgress
        self.overlayDataID = overlayDataID
        self.overlayOpacity = overlayOpacity
        self.startTime = startTime
        self.duration = duration
        self.softDelete = softDelete
        self.hasMask = hasMask
        self.maskShape = maskShape
        self.templateID = templateID
        self.stickerInfo = stickerInfo
        self.textInfo = textInfo
        self.animation = animation
        self.parent = parent
        self.children = children
    }
}

// MARK: Sticker Info Decodable Model
public struct ServerStickerModel: Codable {
    public let stickerID: String
    public let imageID: String
    public let stickerType: String
    public let stickerFilterType: String
    public let stickerHue: String
    public let stickerColor: String
    public let xRotationProg: String
    public let yRotationProg: String
    public let zRotationProg: String
    public let templateID: String
    public var image: ServerImageModel?
    public let animation: ServerAnimationModel?
    public let stickerModelType : String?
    


    enum CodingKeys: String, CodingKey {
        case stickerID = "STICKER_ID"
        case imageID = "IMAGE_ID"
        case stickerType = "STICKER_TYPE"
        case stickerFilterType = "STICKER_FILTER_TYPE"
        case stickerHue = "STICKER_HUE"
        case stickerColor = "STICKER_COLOR"
        case xRotationProg = "X_ROATATION_PROG"
        case yRotationProg = "Y_ROATATION_PROG"
        case zRotationProg = "Z_ROATATION_PROG"
        case templateID = "TEMPLATE_ID"
        case image = "Image"
        case animation = "Animation"
        case stickerModelType = "stickerType"
//        case templateID = "TEMPLATE_ID"
    }
}

// MARK: Animation Decodable Model
public struct ServerAnimationModel: Codable {
    public let animationID: String
    public let modelID: String
    public var inAnimationTemplateID: String
    public var inAnimationDuration: String
    public var loopAnimationTemplateID: String
    public var loopAnimationDuration: String
    public var outAnimationTemplateID: String
    public var outAnimationDuration: String
    public let templateID: String

    enum CodingKeys: String, CodingKey {
        case animationID = "ANIMATION_ID"
        case modelID = "MODEL_ID"
        case inAnimationTemplateID = "IN_ANIMATION_TEMPLATE_ID"
        case inAnimationDuration = "IN_ANIMATION_DURATION"
        case loopAnimationTemplateID = "LOOP_ANIMATION_TEMPLATE_ID"
        case loopAnimationDuration = "LOOP_ANIMATION_DURATION"
        case outAnimationTemplateID = "OUT_ANIMATION_TEMPLATE_ID"
        case outAnimationDuration = "OUT_ANIMATION_DURATION"
        case templateID = "TEMPLATE_ID"
    }
}



// MARK: Text Info Decodable Model
public struct ServerTextModel: Codable {
    public let textID: String
    public let text: String?
    public let textFont: String
    public let textType: String?
    public let textColor: String
    public let textGravity: String
    public let lineSpacing: String
    public let letterSpacing: String
    public let shadowColor: String
    public let shadowOpacity: String
    public let shadowRadius: String
    public let shadowDx: String
    public let shadowDy: String
    public let bgType: String
    public let bgDrawable: String
    public let bgColor: String
    public let bgAlpha: String
    public let internalWidthMargin: String
    public let internalHeightMargin: String
    public let xRotationProg: String
    public let yRotationProg: String
    public let zRotationProg: String
    public let curveProg: String
    public let templateID: String
    

    enum CodingKeys: String, CodingKey {
        case textID = "TEXT_ID"
        case text = "TEXT"
        case textFont = "TEXT_FONT"
        case textType = "textType"
        case textColor = "TEXT_COLOR"
        case textGravity = "TEXT_GRAVITY"
        case lineSpacing = "LINE_SPACING"
        case letterSpacing = "LETTER_SPACING"
        case shadowColor = "SHADOW_COLOR"
        case shadowOpacity = "SHADOW_OPACITY"
        case shadowRadius = "SHADOW_RADIUS"
        case shadowDx = "SHADOW_Dx"
        case shadowDy = "SHADOW_Dy"
        case bgType = "BG_TYPE"
        case bgDrawable = "BG_DRAWABLE"
        case bgColor = "BG_COLOR"
        case bgAlpha = "BG_ALPHA"
        case internalWidthMargin = "INTERNAL_WIDTH_MARGIN"
        case internalHeightMargin = "INTERNAL_HEIGHT_MARGIN"
        case xRotationProg = "X_ROATATION_PROG"
        case yRotationProg = "Y_ROATATION_PROG"
        case zRotationProg = "Z_ROATATION_PROG"
        case curveProg = "CURVE_PROG"
        case templateID = "TEMPLATE_ID"
    }
}


// MARK: Parent Decodable Model
public struct ServerParentModel: Codable {
    public let modelID: String
    public let modelType: String
    public let dataID: String
    public let posX: String
    public let posY: String
    public let width: String
    public let height: String
    public let prevAvailableWidth: String
    public let prevAvailableHeight: String
    public let rotation: String
    public let modelOpacity: String
    public let modelFlipHorizontal: String
    public let modelFlipVertical: String
    public let lockStatus: String
    public let orderInParent: String
    public let parentID: String
    public let bgBlurProgress: String
    public let overlayDataID: String
    public let overlayOpacity: String
    public let startTime: String
    public let duration: String
    public let softDelete: String
    public let hasMask: String?
    public let maskShape: String?
    public let templateID: String
    public let children: [ServerBaseModel]?
    public let animation: ServerAnimationModel?

    enum CodingKeys: String, CodingKey {
        case modelID = "MODEL_ID"
        case modelType = "MODEL_TYPE"
        case dataID = "DATA_ID"
        case posX = "POS_X"
        case posY = "POS_Y"
        case width = "WIDTH"
        case height = "HEIGHT"
        case prevAvailableWidth = "PREV_AVAILABLE_WIDTH"
        case prevAvailableHeight = "PREV_AVAILABLE_HEIGHT"
        case rotation = "ROTATION"
        case modelOpacity = "MODEL_OPACITY"
        case modelFlipHorizontal = "MODEL_FLIP_HORIZONTAL"
        case modelFlipVertical = "MODEL_FLIP_VERTICAL"
        case lockStatus = "LOCK_STATUS"
        case orderInParent = "ORDER_IN_PARENT"
        case parentID = "PARENT_ID"
        case bgBlurProgress = "BG_BLUR_PROGRESS"
        case overlayDataID = "OVERLAY_DATA_ID"
        case overlayOpacity = "OVERLAY_OPACITY"
        case startTime = "START_TIME"
        case duration = "DURATION"
        case softDelete = "SOFT_DELETE"
        case hasMask = "HAS_MASK"
        case maskShape = "MASK_SHAPE"
        case templateID = "TEMPLATE_ID"
        case children = "Children"
        case animation = "Animation"
    }
}


