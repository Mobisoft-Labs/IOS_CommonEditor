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
    @Published public var thumbTime: Float = 00.0
    @Published public var addWatermark : Bool = true
    @Published public var videoLength : Float = 5.0
    @Published public var albumName : String = "Ace LogoMaker"
    @Published public var FPS : FrameRateSettings = .LowFPS
    @Published public var isMute : Bool = false
    @Published public var audioFileURL : String = ""
    @Published public var audioExt : String = "mp3"
    
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
    
    var ext : String {
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
