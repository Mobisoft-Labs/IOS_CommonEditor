//
//  FontUtility.swift
//  FlyerDemo
//
//  Created by HKBeast on 04/11/25.
//

import Foundation
import CoreGraphics
import UIKit

extension FontDM{
    static public func getRealFont(nameOfFont :String, engineConfig: EngineConfiguration?) -> String {
        var path:String?
        
        let baseName = (nameOfFont as NSString).deletingPathExtension
        
        if let tpath = Bundle.main.path(forResource: "\(baseName).ttf", ofType: nil) {
            path = tpath
        }else if let tpath = Bundle.main.path(forResource: "\(baseName).otf", ofType: nil){
            path = tpath
        }else if let tpath = Bundle.main.path(forResource: "\(baseName).TTF", ofType: nil){
            path = tpath
        }else if let fPath = engineConfig?.loadFontFromDocumentsDirectory(fontName: nameOfFont){
            path = fPath
        }else{
            path = Bundle.main.path(forResource: "defaultfont", ofType: ".ttf")
        }
        let url = URL(fileURLWithPath: path!)
        let fontDataProvider = CGDataProvider(url: url as CFURL)
        if let fontDataProvider = fontDataProvider{
            let newFont = CGFont(fontDataProvider)
            let newFontName = newFont?.postScriptName as String?
            return newFontName!
        }else{
            
            let documentsDirectory = (engineConfig?.getFontAssetsPath())!/*FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!*/
            let fontPath = documentsDirectory.appendingPathComponent("\(nameOfFont)").path
            
            
            guard FileManager.default.fileExists(atPath: fontPath) else {
                print("❌ Font file not found at path: \(fontPath)")
                path = Bundle.main.path(forResource: "defaultfont", ofType: ".ttf")
                let url = URL(fileURLWithPath: path!)
                let fontDataProvider = CGDataProvider(url: url as CFURL)
                let newFont = CGFont(fontDataProvider!)
                let newFontName = newFont?.postScriptName as String?
                return newFontName!
            }
            
            // Extract the PostScript name (check if the font is already registered)
            if let fontName = getFontPostScriptName(from: fontPath), UIFont(name: fontName, size: 12) != nil {
                print("✅ Font already registered: \(fontName)")
                return fontName
            }
            
            do {
                let fontData = try Data(contentsOf: URL(fileURLWithPath: fontPath))
                guard let provider = CGDataProvider(data: fontData as CFData),
                      let font = CGFont(provider) else {
                    print("❌ Failed to create CGFont")
                    path = Bundle.main.path(forResource: "defaultfont", ofType: ".ttf")
                    let url = URL(fileURLWithPath: path!)
                    let fontDataProvider = CGDataProvider(url: url as CFURL)
                    let newFont = CGFont(fontDataProvider!)
                    let newFontName = newFont?.postScriptName as String?
                    return newFontName!
                }
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    print("❌ Failed to register font: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
                    path = Bundle.main.path(forResource: "defaultfont", ofType: ".ttf")
                    let url = URL(fileURLWithPath: path!)
                    let fontDataProvider = CGDataProvider(url: url as CFURL)
                    let newFont = CGFont(fontDataProvider!)
                    let newFontName = newFont?.postScriptName as String?
                    return newFontName!
                }
                
                print("✅ Successfully registered font: \(font.postScriptName!)")
                return (font.postScriptName as String?)!
            } catch {
                print("❌ Error loading font data: \(error)")
                path = Bundle.main.path(forResource: "defaultfont", ofType: ".ttf")
                let url = URL(fileURLWithPath: path!)
                let fontDataProvider = CGDataProvider(url: url as CFURL)
                let newFont = CGFont(fontDataProvider!)
                let newFontName = newFont?.postScriptName as String?
                return newFontName!
            }
            
        }
        
        func getFontPostScriptName(from fontPath: String) -> String? {
            let url = URL(fileURLWithPath: fontPath)
            do {
                let fontData = try Data(contentsOf: url)
                guard let provider = CGDataProvider(data: fontData as CFData),
                      let font = CGFont(provider) else {
                    return nil
                }
                return font.postScriptName as String?
            } catch {
                return nil
            }
        }
        
    }
}
