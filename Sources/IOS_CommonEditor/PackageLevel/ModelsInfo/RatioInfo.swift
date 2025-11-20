//
//  RatioInfo.swift
//  VideoInvitation
//
//  Created by HKBeast on 02/09/23.
//

import Foundation

public struct RatioInfo:RatioModelProtocol{
    public var id: Int = 0
    
    public var category: String = " "
    
    public var categoryDescription: String = " "
    
    public var imageResId: String = " "
    
    public var ratioWidth: Float = 0.0
    
    public var ratioHeight: Float = 0.0
    
    public var outputWidth: Float = 0.0
    
    public var outputHeight: Float = 0.0
    
    public var isPremium: Int = 0
    
    public var ratioSize : CGSize  {
        return CGSize(width: CGFloat(ratioWidth), height: CGFloat(ratioHeight))
    }
    
    public init(id: Int = 0, category: String = " ", categoryDescription: String = " ", imageResId: String = " ", ratioWidth: Float = 0.0, ratioHeight: Float = 0.0, outputWidth: Float = 0.0, outputHeight: Float = 0.0, isPremium: Int = 0) {
        self.id = id
        self.category = category
        self.categoryDescription = categoryDescription
        self.imageResId = imageResId
        self.ratioWidth = ratioWidth
        self.ratioHeight = ratioHeight
        self.outputWidth = outputWidth
        self.outputHeight = outputHeight
        self.isPremium = isPremium
    }
    
    mutating func setRatioModel(ratioInfo: DBRatioTableModel , refSize:CGSize, logger: DBLogger?) {
         // Set all values from the provided ratioInfo
         self.id = ratioInfo.id
         self.category = ratioInfo.category
         self.categoryDescription = ratioInfo.categoryDescription
         self.imageResId = ratioInfo.imageResId
        
        self.ratioWidth = ratioInfo.ratioWidth.toFloat()
        self.ratioHeight = ratioInfo.ratioHeight.toFloat()
        
        let newSize = getProportionalSize(currentRatio: CGSize(width: CGFloat(ratioWidth), height: CGFloat(ratioHeight)), oldSize: refSize)
        logger?.printLog("NEWSIZE: \(newSize)")
        self.ratioWidth = Float(newSize.width)
        self.ratioHeight = Float(newSize.height)
        
        
        self.outputWidth = ratioInfo.outputWidth.toFloat()
        self.outputHeight = ratioInfo.outputHeight.toFloat()
         self.isPremium = ratioInfo.isPremium
     }
    func getRatioModel() -> DBRatioTableModel {
        var ratioModel = DBRatioTableModel()
        ratioModel.id = self.id
        ratioModel.category = self.category
        ratioModel.categoryDescription = self.categoryDescription
        ratioModel.imageResId = self.imageResId
        ratioModel.ratioWidth = Double(NSNumber(value: self.ratioWidth).intValue)
        ratioModel.ratioHeight = Double(NSNumber(value: self.ratioHeight).intValue)
        ratioModel.outputWidth = Double(NSNumber(value: self.outputWidth).intValue)
        ratioModel.outputHeight = Double(NSNumber(value: self.outputHeight).intValue)
        ratioModel.isPremium = self.isPremium
        return ratioModel
    }
    
    public func getRatioInfo(ratioInfo: DBRatioTableModel , refSize:CGSize, logger: PackageLogger?)->RatioInfo{
        var ratio = RatioInfo()
        ratio.id = ratioInfo.id
        ratio.category = ratioInfo.category
        ratio.categoryDescription = ratioInfo.categoryDescription
        ratio.imageResId = ratioInfo.imageResId
       
        ratio.ratioWidth = ratioInfo.ratioWidth.toFloat()
        ratio.ratioHeight = ratioInfo.ratioHeight.toFloat()
       
       let newSize = getProportionalSize(currentRatio: CGSize(width: CGFloat(ratio.ratioWidth), height: CGFloat(ratio.ratioHeight)), oldSize: refSize)
        logger?.printLog("NEWSIZE: \(newSize)")
        ratio.ratioWidth = Float(newSize.width)
        ratio.ratioHeight = Float(newSize.height)
       
       
        ratio.outputWidth = ratioInfo.outputWidth.toFloat()
        ratio.outputHeight = ratioInfo.outputHeight.toFloat()
        ratio.isPremium = ratioInfo.isPremium
        return ratio
    }

}
