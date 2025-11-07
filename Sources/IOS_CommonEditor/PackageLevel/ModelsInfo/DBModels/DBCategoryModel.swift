//
//  DBCategoryModel.swift
//  VideoInvitation
//
//  Created by HKBeast on 19/03/24.
//

import Foundation

struct DBCategoryModel{
    let categoryId: Int
    let categoryName: String
    let categoryThumbPath: String // TODO: Delete From Disk
    let lastModified: String
    let categoryThumbType : String
    let categoryDataPath: String
    let categoryMetaData: [DBCategoryMetaModel]?
    var canDelete: Bool
    var isHeaderDownloaded: Bool
    
    
}
