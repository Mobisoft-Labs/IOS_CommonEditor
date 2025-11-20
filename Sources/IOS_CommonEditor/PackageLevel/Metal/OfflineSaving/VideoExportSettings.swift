//
//  VideoExportSettings.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 14/05/24.
//

import Foundation


public final class ExportSettings: ObservableObject {
    @Published public var name : String = "AceLogoMaker_"
    @Published public var resolution : ExportVideoResolution = .HD
    @Published public var exportType : ExportType = .Photo
    @Published public var exportImageFormat : ExportPhotoFormat = .JPEG
    @Published public var customImageSize: CGSize?
    @Published public var thumbTime: Float = 00.0
    @Published public var addWatermark : Bool = true
    @Published public var videoLength : Float = 5.0
    @Published public var albumName : String = "Ace LogoMaker"
    @Published public var FPS : FrameRateSettings = .LowFPS
    @Published public var isMute : Bool = false
    @Published public var audioFileURL : String = ""
    @Published public var audioExt : String = "mp3"
    @Published public var logoVariants: [ExportImageVariant] = ExportImageVariant.defaultLogoVariants
    @Published public var templateId: Int = 0
    @Published public var templateDisplayName: String = ""
    @Published public var exportFolderIdentifier: String = ""
    @Published public var isForcedToSaveTransparent : Bool = false
    
    public init() {}
    
    public var formattedThumbTime: String {
        String(format: "%.2f", thumbTime)
    }
       
    public var formattedResolutionWidth: String {
        String(format: "%.0f", resolution.size.width)
    }
    
    public var formattedResolutionHeight: String {
        String(format: "%.0f", resolution.size.height)
    }
}

extension ExportSettings {
    public func duplicate() -> ExportSettings {
        let copy = ExportSettings()
        copy.name = name
        copy.resolution = resolution
        copy.exportType = exportType
        copy.exportImageFormat = exportImageFormat
        copy.customImageSize = customImageSize
        copy.thumbTime = thumbTime
        copy.addWatermark = addWatermark
        copy.videoLength = videoLength
        copy.albumName = albumName
        copy.FPS = FPS
        copy.isMute = isMute
        copy.audioFileURL = audioFileURL
        copy.audioExt = audioExt
        copy.logoVariants = logoVariants
        copy.templateId = templateId
        copy.templateDisplayName = templateDisplayName
        copy.exportFolderIdentifier = exportFolderIdentifier
        return copy
    }
    
    public func configureTemplateContext(id: Int, name: String) {
        templateId = id
        templateDisplayName = name
        exportFolderIdentifier = ExportSettings.folderIdentifier(for: id, name: name)
    }
    
    public static func folderIdentifier(for id: Int, name: String) -> String {
        let sanitizedName = sanitize(name)
        return sanitizedName.isEmpty ? "\(id)" : "\(id)_\(sanitizedName)"
    }
    var folderKey: String {
        if !exportFolderIdentifier.isEmpty {
            return exportFolderIdentifier
        }
        let baseName = templateDisplayName.isEmpty ? name : templateDisplayName
        return ExportSettings.folderIdentifier(for: templateId, name: baseName)
    }
    
    private static func sanitize(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let components = trimmed
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        return components.joined(separator: "_")
    }
}


public enum FrameRateSettings {
    case LowFPS
    case HighFPS
    
    var frameRate : Int {
        switch self {
        case .LowFPS:
            30
        case .HighFPS:
            60
        }
    }
    
    var displayTitle : String {
        switch self {
        case .LowFPS:
            "30 FPS"
        case .HighFPS:
            "60 FPS"
        }
    }
    var displaySubtitle : String {
        switch self {
        case .LowFPS:
            "Recommended"
        case .HighFPS:
            "High Frame Rate"
        }
    }
}


public enum ExportType {
    case Variants
    case Video
    case Photo
    case GIF
   // case PDF - future
   // case GIF - future
}
public enum ExportPhotoFormat {
    case PNG
    case JPEG
    
    var size : CGSize {
        return CGSize(width: 2048, height: 2048)
    }
    
    public var ext : String {
        switch self {
        case .PNG:
            return ".png"
        case .JPEG:
            return ".jpg"
        }
    }
    
    var displayTitle : String {
        switch self {
        case .PNG:
            return "PNG"
        case .JPEG:
            return "JPEG"
        }
    }
    
    var displaySubtitle : String {
        switch self {
        case .PNG:
            return "Supports transparency. Best quality. File are generally big"
        case .JPEG:
            return "No transparency.High quality. File are generally small"
        
        }
    }
}
public enum ExportVideoResolution {
    /// 480p
    case SD
    /// 720p
    case HD
    /// 1080p
    case FHD
    /// 2016p
    case UHD
   // case custom(res: CGSize) - for future
    
    var size : CGSize {
        switch self {
        case .SD:
            return CGSize(width: 480, height: 480)
        case .HD:
            return CGSize(width: 720, height: 720)
        case .FHD:
            return CGSize(width: 1080, height: 1080)
        case .UHD:
            return CGSize(width: 2160, height: 2160)
        }
    }
    var assetsMaxSize : CGSize {
        switch self {
        case .SD:
            return CGSize(width: 480, height: 480)
        case .HD:
            return CGSize(width: 500, height: 500)
        case .FHD:
            return CGSize(width: 720, height: 720)
        case .UHD:
            return CGSize(width: 1080, height: 1080)
        }
    }
    
    var ext : String {
       return ".mp4"
    }
    
    var displayTitle : String {
        switch self {
        case .SD:
            return "480p"
        case .HD:
            return "720p HD"
        case .FHD:
            return "1080p HD"
        case .UHD:
            return "2160p 4K"
        }
    }
    
    var displaySubtitle : String {
        switch self {
        case .SD:
            return "Low quality video"
        case .HD:
            return "Perfect for social media"
        case .FHD:
            return "Full HD"
        case .UHD:
            return "Ultra High Defination"
        }
    }
    
}

public struct ExportImageVariant: Hashable {
    public let displayName: String
    public let fileNameToken: String
    public let size: CGSize
    public let sizeDescription: String
    public let isFree: Bool
    public let showsTransparencyBackground: Bool
    public let enforcesPNGFormat: Bool
    
    var requiresPremium: Bool { !isFree }
    
    public init(displayName: String,
         fileNameToken: String,
         size: CGSize,
         sizeDescription: String,
         isFree: Bool = false,
         showsTransparencyBackground: Bool = false,
         enforcesPNGFormat: Bool = false) {
        self.displayName = displayName
        self.fileNameToken = fileNameToken
        self.size = size
        self.sizeDescription = sizeDescription
        self.isFree = isFree
        self.showsTransparencyBackground = showsTransparencyBackground
        self.enforcesPNGFormat = enforcesPNGFormat
    }
    
    public static let defaultLogoVariants: [ExportImageVariant] = [
        ExportImageVariant(displayName: "Icon", fileNameToken: "icon", size: CGSize(width: 256, height: 256), sizeDescription: "256 x 256 px", isFree: true),
        ExportImageVariant(displayName: "HD+", fileNameToken: "hd_plus", size: CGSize(width: 1080, height: 1080), sizeDescription: "1080 x 1080 px", isFree: true),
        ExportImageVariant(displayName: "Fav Icon", fileNameToken: "fav_icon", size: CGSize(width: 1080, height: 1080), sizeDescription: "1080 x 1080 px", showsTransparencyBackground: true, enforcesPNGFormat: true),
        ExportImageVariant(displayName: "Instagram", fileNameToken: "instagram", size: CGSize(width: 320, height: 320), sizeDescription: "320 x 320 px"),
        ExportImageVariant(displayName: "Facebook", fileNameToken: "facebook", size: CGSize(width: 170, height: 170), sizeDescription: "170 x 170 px"),
        ExportImageVariant(displayName: "Twitter", fileNameToken: "twitter", size: CGSize(width: 400, height: 400), sizeDescription: "400 x 400 px"),
        ExportImageVariant(displayName: "LinkedIn", fileNameToken: "linkedin", size: CGSize(width: 400, height: 400), sizeDescription: "400 x 400 px"),
        ExportImageVariant(displayName: "YouTube", fileNameToken: "youtube", size: CGSize(width: 800, height: 800), sizeDescription: "800 x 800 px"),
        ExportImageVariant(displayName: "TikTok", fileNameToken: "tiktok", size: CGSize(width: 200, height: 200), sizeDescription: "200 x 200 px"),
        ExportImageVariant(displayName: "Snapchat", fileNameToken: "snapchat", size: CGSize(width: 320, height: 320), sizeDescription: "320 x 320 px"),
        ExportImageVariant(displayName: "WhatsApp Business", fileNameToken: "whatsapp_business", size: CGSize(width: 500, height: 500), sizeDescription: "500 x 500 px")
    ]
    
    public func fileName(with baseName: String, using ext: String) -> String {
        let sanitizedBase = baseName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
        let width = Int(size.width.rounded())
        let height = Int(size.height.rounded())
        return "\(fileNameToken)_\(sanitizedBase)_\(width)x\(height)\(ext)"
    }
}
