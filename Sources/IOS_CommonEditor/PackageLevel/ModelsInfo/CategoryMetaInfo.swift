//
//  CategoryMetaInfo.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 11/03/24.
//

import Foundation

enum FieldDisplayType{
    case date
    case time
    case name
}

class CategoryMetaInfoPerCategory: ObservableObject {
    var categoryName : String
    @Published var fields : [CategoryMetaInfo]
    
    init(categoryName: String, fields: [CategoryMetaInfo]) {
        self.categoryName = categoryName
        self.fields = fields
    }
}

class CategoryMetaInfo: ObservableObject{
    var id = UUID()
    var fieldId: Int
    var fieldDisplayName: String
    var templateValue: String
    var categoryName: String
    var seq: String
    @Published var userValue: String = ""
    
    
    
//    @Published var date: Date
//    @Published var time: Date
    var type: FieldDisplayType {
        switch fieldDisplayName {
        case "Date":
            return .date
        case "Time":
            return .time
        default:
            return .name
        }
    }
    
    // Empty initializer
    init() {
        self.fieldId = -1
        self.fieldDisplayName = ""
        self.templateValue = ""
        self.categoryName = ""
        self.seq = ""
        self.userValue = ""
//        self.date = Date()
//        self.time = Date()
    }
    
    func setBaseModel(categoryMetaModel: DBCategoryMetaModel){
        fieldId = categoryMetaModel.fieldId
        fieldDisplayName = categoryMetaModel.fieldDisplayName
        templateValue = categoryMetaModel.templateValue
        categoryName = categoryMetaModel.categoryName
        seq = String(categoryMetaModel.seq)
//        userValue = categoryMetaModel.userValue ?? ""
        
        if type == .date{
            if let dateString = categoryMetaModel.userValue {
                
                userValue = dateString
//                // Convert string to date
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MMMM dd, yyyy" // Use your desired date format
//                if let date = dateFormatter.date(from: dateString) {
//                    // Set the user value to the converted date string
//                    userValue = dateFormatter.string(from: date)
//                }
            }
        }else if type == .time{
            if let timeString = categoryMetaModel.userValue {
                userValue = timeString
                // Convert string to time
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "h:mm a" // Use your desired time format
//                if let time = dateFormatter.date(from: timeString) {
//                    // Set the user value to the converted time string
//                    userValue = dateFormatter.string(from: time)
//                }
            }
        }else{
            userValue = categoryMetaModel.userValue ?? ""
        }
        
    }
    
    func getCategoryMetaModel() -> DBCategoryMetaModel {
        
        var categoryMetaModel = DBCategoryMetaModel()
        
        categoryMetaModel.fieldId = fieldId
        categoryMetaModel.fieldDisplayName = fieldDisplayName
        categoryMetaModel.templateValue = templateValue
        categoryMetaModel.categoryName = categoryName
        categoryMetaModel.seq = Int(seq) ?? 0
//        categoryMetaModel.userValue = userValue
        
        if type == .date{
            let dateFormatter = DateFormatter()
            if let date = dateFormatter.date(from: userValue) {
                // Convert date to string
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy" // Use your desired date format
                categoryMetaModel.userValue = dateFormatter.string(from: date)
            }
        }else if type == .time{
            let dateFormatter = DateFormatter()
            if let time = dateFormatter.date(from: userValue) {
                // Convert time to string
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a" // Use your desired time format
                categoryMetaModel.userValue = dateFormatter.string(from: time)
            }
        }else{
            categoryMetaModel.userValue = userValue
        }
       
        return categoryMetaModel
   }
    
    
}

// JD New Logic

extension CategoryMetaInfo {
    /// Maps a single `CategoryFormField` to a `CategoryMetaInfo`
    static func from(formField: CategoryFormField) -> CategoryMetaInfo {
        let fieldIdInt = Int(formField.fieldID) ?? 0
        var metaData = CategoryMetaInfo()
        metaData.setBaseModel(formField: formField)
        return metaData
    }

    /// Maps an array of `CategoryFormField` to `[CategoryMetaInfo]`
    static func from(formFields: [CategoryFormField]) -> [CategoryMetaInfo] {
        formFields.map { from(formField: $0) }
    }
}

extension CategoryMetaInfo {

    func setBaseModel(formField: CategoryFormField) {
        self.fieldId = Int(formField.fieldID) ?? -1
        self.fieldDisplayName = formField.fieldDisplayName
        self.templateValue = formField.templateValue ?? ""
        self.categoryName = formField.categoryName
        self.seq = String(formField.seq)

        if type == .date {
            if let dateString = formField.templateValue {
                userValue = dateString
            }
        } else if type == .time {
            if let timeString = formField.templateValue {
                userValue = timeString
            }
        } else {
            userValue =  ""
        }
    }
}
