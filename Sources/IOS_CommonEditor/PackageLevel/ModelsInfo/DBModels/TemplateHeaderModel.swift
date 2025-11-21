//
//  TemplateHeaderModel.swift
//  FlyerDemo
//
//  Created by HKBeast on 06/11/25.
//

import Foundation

public struct CategoryModel: Codable, Identifiable,Hashable {
    public let id: String
    public let name: String
    let lastModified: String
    let thumbnailPath: String?
    let isReleased: String
    let categoryDataPath: String
    let buildCategory : String
    let formFields: [CategoryFormField]

    public init(id: String, name: String, lastModified: String, thumbnailPath: String?, isReleased: String, categoryDataPath: String, formFields: [CategoryFormField] , buildCategory:String) {
        self.id = id
        self.name = name
        self.lastModified = lastModified
        self.thumbnailPath = thumbnailPath
        self.isReleased = isReleased
        self.categoryDataPath = categoryDataPath
        self.formFields = formFields
        self.buildCategory = buildCategory
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "CATEGORY_ID"
        case name = "CATEGORY_NAME"
        case lastModified = "LAST_MODIFIED"
        case thumbnailPath = "CATEGORY_THUMB_PATH"
        case isReleased = "IS_RELEASED"
        case categoryDataPath = "CATEGORY_DATA_PATH"
        case formFields = "Category_Meta_Data"
        case buildCategory = "BUILD_CATEGORY"
    }
}
extension Array where Element == CategoryModel {
    /// Returns a flattened `[CategoryFormField]` from an array of `CategoryModel`
    func allFormFields() -> [CategoryFormField] {
        self.flatMap { $0.formFields }
    }
}

public struct CategoryFormField: Codable, Hashable{
    let fieldID: Int
    let fieldDisplayName: String
    let templateValue: String?
    let categoryName: String
    let seq: Int
    
    enum CodingKeys: String, CodingKey {
        case fieldID = "FIELD_ID"
        case fieldDisplayName = "FIELD_DISPLAY_NAME"
        case templateValue = "TEMPLATE_VALUE"
        case categoryName = "CATEGORY_NAME"
        case seq = "SEQ"
    }
}

// MARK: - TemplateModel
public struct TemplateHeaderModel: Codable, Identifiable ,Hashable{
    public let id: String
    public let thumbServerPath: String
    public let dataPath: String
    public let isPremium: String
    public let templateDisplayName:String?
    public let ratioWidth : String
    public let ratioHeight : String
    
    enum CodingKeys: String, CodingKey {
        case id = "TEMPLATE_ID"
        case thumbServerPath = "THUMB_SERVER_PATH"
        case dataPath = "DATA_PATH"
        case isPremium = "IS_PREMIUM"
        case templateDisplayName = "TEMPLATE_NAME"
        case ratioWidth = "RATIO_WIDTH"
        case ratioHeight = "RATIO_HEIGHT"

    }
    static var myArray = [TemplateHeaderModel]()
    public static func getPlaceholders() -> [TemplateHeaderModel] {
        if !myArray.isEmpty {
            return myArray
        }
        var array = [TemplateHeaderModel]()
        
        for each in 0...10 {
            let element = TemplateHeaderModel(id: "\(each)", thumbServerPath: "", dataPath: "", isPremium: "0", templateDisplayName: "", ratioWidth: "1", ratioHeight: "1")
            array.append(element)
        }
        myArray = array
        return array
    }
}
