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
    let templateID: String
    let category: String?
    let templateName: String?
    let ratioID: String
    let thumbServerPath: String
    let thumbLocalPath: String?
    let thumbTime: String
    let totalDuration: String
    let sequence: String
    let isPremium: String
    let categoryTemp: String
    let serverTemplateID:Int?
    let dataPath: String
    let isReleased: String?
    let colorPalleteId : String?
    let fontSetId : String?
    let eventData : String?
    let eventTime : String?
    let venue : String?
    let name1 : String?
    let name2 : String?
    let rsvp : String?
    let baseColor : String?
    let layoutId : String?
    let music: ServerMusicModel?
    let pages: [ServerPageModel]?
    var showWatermark : String?
    
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
struct ServerMusicModel: Codable {
    let musicID: String
    let musicType: String
    let name: String
    let musicPath: String
    let parentID: String
    let parentType: String
    let startTimeOfAudio: String
    let endTimeOfAudio: String
    let startTime: String
    let duration: String
    let templateID: String

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
struct ServerPageModel: Codable {
    let modelID: String
    let modelType: String
    let dataID: String
    let posX: String
    let posY: String
    let width: String
    let height: String
    let prevAvailableWidth: String
    let prevAvailableHeight: String
    let rotation: String
    let modelOpacity: String
    let modelFlipHorizontal: String
    let modelFlipVertical: String
    let lockStatus: String
    let orderInParent: String
    let parentID: String
    let bgBlurProgress: String
    let overlayDataID: String
    let overlayOpacity: String
    let startTime: String
    let duration: String
    let softDelete: String
    var templateID: String
    let hasMask: String?
    let maskShape: String?
    var image: ServerImageModel?
    var overlayImage: ServerImageModel?
    var children: [ServerBaseModel]?
    var animation: ServerAnimationModel?

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
struct ServerImageModel: Codable {
    let imageID: String
    let imageType: String
    let serverPath: String
    let localPath: String
    let resID: String
    let isEncrypted: String
    let cropX: String
    let cropY: String
    let cropW: String
    let cropH: String
    let cropStyle: String
    let tileMultiple: String
    let colorInfo: String
    let imageWidth: String
    let imageHeight: String
    var templateID: String

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
struct ServerBaseModel: Codable {
    let modelID: String
    let modelType: String
    let dataID: String
    let posX: String
    let posY: String
    let width: String
    let height: String
    let prevAvailableWidth: String
    let prevAvailableHeight: String
    let rotation: String
    let modelOpacity: String
    let modelFlipHorizontal: String
    let modelFlipVertical: String
    let lockStatus: String
    let orderInParent: String
    let parentID: String
    let bgBlurProgress: String
    let overlayDataID: String
    let overlayOpacity: String
    let startTime: String
    let duration: String
    let softDelete: String
    let hasMask: String?
    let maskShape: String?
    var templateID: String
    var stickerInfo: ServerStickerModel?
    var textInfo : ServerTextModel?
    var animation: ServerAnimationModel?
    var parent : ServerParentModel?
    var children: [ServerBaseModel]?

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
struct ServerStickerModel: Codable {
    let stickerID: String
    let imageID: String
    let stickerType: String
    let stickerFilterType: String
    let stickerHue: String
    let stickerColor: String
    let xRotationProg: String
    let yRotationProg: String
    let zRotationProg: String
    let templateID: String
    var image: ServerImageModel?
    let animation: ServerAnimationModel?
    let stickerModelType : String?
    


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
struct ServerAnimationModel: Codable {
    let animationID: String
    let modelID: String
    var inAnimationTemplateID: String
    var inAnimationDuration: String
    var loopAnimationTemplateID: String
    var loopAnimationDuration: String
    var outAnimationTemplateID: String
    var outAnimationDuration: String
    let templateID: String

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
struct ServerTextModel: Codable {
    let textID: String
    let text: String?
    let textFont: String
    let textColor: String
    let textGravity: String
    let lineSpacing: String
    let letterSpacing: String
    let shadowColor: String
    let shadowOpacity: String
    let shadowRadius: String
    let shadowDx: String
    let shadowDy: String
    let bgType: String
    let bgDrawable: String
    let bgColor: String
    let bgAlpha: String
    let internalWidthMargin: String
    let internalHeightMargin: String
    let xRotationProg: String
    let yRotationProg: String
    let zRotationProg: String
    let curveProg: String
    let templateID: String
    

    enum CodingKeys: String, CodingKey {
        case textID = "TEXT_ID"
        case text = "TEXT"
        case textFont = "TEXT_FONT"
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
struct ServerParentModel: Codable {
    let modelID: String
    let modelType: String
    let dataID: String
    let posX: String
    let posY: String
    let width: String
    let height: String
    let prevAvailableWidth: String
    let prevAvailableHeight: String
    let rotation: String
    let modelOpacity: String
    let modelFlipHorizontal: String
    let modelFlipVertical: String
    let lockStatus: String
    let orderInParent: String
    let parentID: String
    let bgBlurProgress: String
    let overlayDataID: String
    let overlayOpacity: String
    let startTime: String
    let duration: String
    let softDelete: String
    let hasMask: String?
    let maskShape: String?
    let templateID: String
    let children: [ServerBaseModel]?
    let animation: ServerAnimationModel?

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


