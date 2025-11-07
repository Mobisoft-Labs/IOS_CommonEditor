//
//  FontModel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 15/03/24.
//

import Foundation
import CoreGraphics
import UIKit

enum FontSource:String{
    case Apple = "SystemFont"
    case Server = "Custom"
    case User = "User"
}

public struct FontModel: Hashable {    
  
        var ID: Int = 0
    public var fontName: String = " "
        var fontDisplayName: String = " "
    public var fontFamily: String = " "
        var fontRealName: String = " "
        var fontCategory: String = " "
        var fontSource: String = " "
        var fontLocalPath: String = " "
        var fontServerPath: String = " "
        var isPremium: Bool = false
        var isTrending: Bool = false
        var isFavourite: Bool = false


    init(){
        
    }

    init(fontName: String , family : String,localPath:String, fontSource:FontSource = .User,fontDisplayName:String?) {
        self.fontName = fontName
        self.fontDisplayName = fontDisplayName ?? fontName.replacingOccurrences(of: "-", with: "").addSpaceBeforeCapital()
        self.fontFamily = family
        self.fontLocalPath = localPath
        self.fontSource = fontSource.rawValue
       
        
    }
}

    
public class FontDM{
  
   static var fontArray : [String] = [
        "FlatFlight-Regular.ttf",
        "RetroHouse-Regular.ttf",
        "BlackMoon-Heavy.ttf",
        "MonzaRace-Regular.ttf",
        "OnyxClock-regular.ttf",
        "SecretSketch-Regular.ttf",
        "ScoobyDo-regular.ttf",
        "CommonRobot-regular.ttf",
        "TrickyGarlic-Bold.ttf",
        "ThickFocus-Regular.ttf",
        "DenimSister-Bold.ttf",
        "SimplyFossil-Regular.ttf",
        "OldEnglish-Regular.ttf",
        "RichOnion-Regular.ttf",
        "SpaceDoctor-regular.ttf",
        "HandyRabbit-Regular.ttf",
        "SpaceFact-Regular.ttf",
        "AutumnFlight-Medium.ttf",
        "FlatShadow-Regular.ttf",
        "CraftyPlate-regular.ttf",
        "CraftyWig-regular.ttf",
        "ProudBone-Western.ttf",
        "LavishOven-regular.ttf",
        "RichMotor-Bold.ttf",
        "BakedRage-Regular.ttf",
        "OpenSans-Light.ttf",
        "OpenSans-Extrabold.ttf",
        "OpenSans-Semibold.ttf",
        
        
   
        ]
    
    static var fontDict: [String: String] = [
//        let dictArray: [String: String] = [
            "DEFAULT_TEXT_FONT_NAME": "Default",
            "ffont19": "Font 19",
            "ffont48": "Font 48",
            "ffont46": "Font 46",
            "ffont18": "Font 18",
            "ffont7": "Font 7",
            "font6": "Font 58",
            "ffont49": "Font 49",
            "ffont50": "Font 50",
            "ffont38": "Font 38",
            "ffont45": "Font 45",
            "ffont6": "Font 6",
            "ffont44": "Font 44",
            "ffont25": "Font 25",
            "ffont26": "Font 26",
            "ffont14": "Font 14",
            "font7": "Font 59",
            "ffont9": "Font 9",
            "ffont3": "Font 3",
            "ffont16": "Font 16",
            "ffont20": "Font 20",
            "font15": "Font 67",
            "ffont41": "Font 41",
            "font40": "Font 92",
            "font41": "Font 93",
            "font1": "Font 53",
            "font22": "Font 74",
            "font11": "Font 63",
            "font38": "Font 90",
            "font5": "Font 57",
            "ffont22": "Font 22",
            "font36": "Font 88",
            "ffont4": "Font 4",
            "font17": "Font 69",
            "font31": "Font 83",
            "font27": "Font 79",
            "font28": "Font 80",
            "ffont36": "Font 36",
            "font33": "Font 85",
            "font12": "Font 64",
            "ffont11": "Font 11",
            "ffont27": "Font 27",
            "ffont52": "Font 52",
            "font21": "Font 73",
            "ffont24": "Font 24",
            "ffont28": "Font 28",
            "font42": "Font 94",
            "ffont8": "Font 8",
            "ffont40": "Font 40",
            "ffont31": "Font 31",
            "font20": "Font 72",
            "ffont2": "Font 2",
            "ffont32": "Font 32",
            "font14": "Font 66",
            "font19": "Font 71",
            "ffont37": "Font 37",
            "ffont39": "Font 39",
            "ffont47": "Font 47",
            "ffont23": "Font 23",
            "ffont5": "Font 5",
            "font2": "Font 54",
            "font34": "Font 86",
            "ffont10": "Font 10",
            "font9": "Font 61",
            "ffont51": "Font 51",
            "ffont13": "Font 13",
            "ffont21": "Font 21",
            "ffont12": "Font 12",
            "font25": "Font 77",
            "ffont29": "Font 29",
            "ffont33": "Font 33",
            "font18": "Font 70",
            "ffont43": "Font 43",
            "font26": "Font 78",
            "font23": "Font 75",
            "ffont30": "Font 30",
            "ffont42": "Font 42",
            "font37": "Font 89",
            "ffont34": "Font 34",
            "font35": "Font 87",
            "font8": "Font 60",
            "font24": "Font 76",
            "font39": "Font 91",
            "font30": "Font 82",
            "ffont15": "Font 15",
            "font43": "Font 95",
            "font16": "Font 68",
            "font29": "Font 81",
            "ffont17": "Font 17",
            "font32": "Font 84",
            "font13": "Font 65",
            "ffont35": "Font 35",
            "font10": "Font 62",
            "font44": "Font 96",
            "ffont1.ttf": "Font 1",
            "font4.ttf": "Font 56",
            "font3.ttf": "Font 55"

    ]
    
    static var appFontArray: [String] = [
//        let dictArray: [String: String] = [
            "DEFAULT_TEXT_FONT_NAME",
            "ffont19",
            "ffont48",
            "ffont46",
            "ffont18",
            "ffont7",
            "font6",
            "ffont49",
            "ffont50",
            "ffont38",
            "ffont45",
            "ffont6",
            "ffont44",
            "ffont25",
            "ffont26",
            "ffont14",
            "font7",
            "ffont9",
            "ffont3",
            "ffont16",
            "ffont20",
            "font15",
            "ffont41",
            "font40",
            "font41",
            "font1",
            "font22",
            "font11",
            "font38",
            "font5",
            "ffont22",
            "font36",
            "ffont4",
            "font17",
            "font31",
            "font27",
            "font28",
            "ffont36",
            "font33",
            "font12",
            "ffont11",
            "ffont27",
            "ffont52",
            "font21",
            "ffont24",
            "ffont28",
            "font42",
            "ffont8",
            "ffont40",
            "ffont31",
            "font20",
            "ffont2",
            "ffont32",
            "font14",
            "font19",
            "ffont37",
            "ffont39",
            "ffont47",
            "ffont23",
            "ffont5",
            "font2",
            "font34",
            "ffont10",
            "font9",
            "ffont51",
            "ffont13",
            "ffont21",
            "ffont12",
            "font25",
            "ffont29",
            "ffont33",
            "font18",
            "ffont43",
            "font26",
            "font23",
            "ffont30",
            "ffont42",
            "font37",
            "ffont34",
            "font35",
            "font8",
            "font24",
            "font39",
            "font30",
            "ffont15",
            "font43",
            "font16",
            "font29",
            "ffont17",
            "font32",
            "font13",
            "ffont35",
            "font10",
            "font44",
            "ffont1.ttf",
            "font4.ttf",
            "font3.ttf"

    ]
    
    
    static func getAppleFontModelArray()->[FontModel]{
           var arrayOfFont = [FontModel]()
           arrayOfFont.removeAll()
           for familyName:String in UIFont.familyNames {
                for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
               //    print("--Font Name: \(fontName)")
                    let model = FontModel(fontName: fontName, family: familyName, localPath: "", fontSource: FontSource.Apple, fontDisplayName: nil)
//                    DBManager.shared.deleteFontModelByFontSource(fontSource: FontSource.Apple.rawValue)
                    DBManager.shared.insertFontModel(model: model)
                    
                   arrayOfFont.append(model)
                }
            }
           return arrayOfFont
        }
    
    static func getServerFontModelArray() {
//        var fontNamesWithoutExtension: [String] = []
//        for name in fontArray {
//            let nameWithoutExtension = name.replacingOccurrences(of: ".ttf", with: "")
//            fontNamesWithoutExtension.append(nameWithoutExtension)
//        }
        for font in fontDict{
            let model = FontModel(fontName: font.key, family: font.key, localPath: "\(font.key).ttf", fontSource: FontSource.Server, fontDisplayName: font.value)

            DBManager.shared.insertFontModel(model: model)
        }
    }
        
//        static func getSpecialFontModelArray()->[FontModel]{
//            var arrayOfFont = [FontModel]()
//            arrayOfFont.removeAll()
//            var fontNamesWithoutExtension: [String] = []
//            let fontArray = DBManager.shared.fetchFontModel(fontSource: FontSource.Server.rawValue)
//            for name in fontArray {
//                let nameWithoutExtension = name.replacingOccurrences(of: ".ttf", with: "")
//                fontNamesWithoutExtension.append(nameWithoutExtension)
//            }
//            for font in fontNamesWithoutExtension {
//                let model = FontModel(fontName: font, family: font, localPath: "\(font).ttf")
//    
//                DBManager.shared.insertFontModel(model: model)
//                arrayOfFont.append(model)
//            }
//    
//            return arrayOfFont
//        }
   
//    static func getRealFont(nameOfFont :String) -> String {
//        //  return nameOfFont
//        var type = "ttf"
//        //    let split = nameOfFont.split(separator: ".")
//        //    if split.count > 1 {
//        //    type = String(split.last!)
//        //    }
//        //    let fontName = String(split.first!)
//        //
//        var newFontName = nameOfFont
//        if let  path = Bundle.main.path (forResource: nameOfFont, ofType: ".\(type)") {
//            let url = URL(fileURLWithPath: path)
//            let fontDataProvider = CGDataProvider(url: url as CFURL)
//            let newFont = CGFont(fontDataProvider!)
//            newFontName = newFont?.postScriptName as String? ?? nameOfFont
//        }
//        return newFontName
//        
//    }
    
}
