//
//  DBCategoryMetaDataModel.swift
//  VideoInvitation
//
//  Created by HKBeast on 09/03/24.
//

import Foundation
struct DBCategoryMetaModel: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var fieldId: Int
    var fieldDisplayName: String
    var templateValue: String
    var categoryName: String
    var seq: Int
    var userValue: String?
    
    // Initializer taking a CategoryMetaData instance
    init(from categoryMetaData: ServerCategoryMetaData) {
        self.fieldId = Int(categoryMetaData.fieldId) ?? -1
        self.fieldDisplayName = categoryMetaData.fieldDisplayName
        self.templateValue = categoryMetaData.templateValue
        self.categoryName = categoryMetaData.categoryName
        self.seq = Int(categoryMetaData.seq) ?? -1
        self.userValue = nil
    }
    
    
    
    // Empty initializer
    init() {
        self.fieldId = -1
        self.fieldDisplayName = ""
        self.templateValue = ""
        self.categoryName = ""
        self.seq = -1
        self.userValue = nil
    }
    
    // Conformance to Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Conformance to Equatable protocol
    static func == (lhs: DBCategoryMetaModel, rhs: DBCategoryMetaModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
