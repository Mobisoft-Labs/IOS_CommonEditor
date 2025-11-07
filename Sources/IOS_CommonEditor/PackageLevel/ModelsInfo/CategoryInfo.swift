//
//  CategoryInfo.swift
//  VideoInvitation
//
//  Created by HKBeast on 14/03/24.
//

import Foundation

// MARK: Category Info for the UI work.
struct CategoryInfo {
    var categoryId: Int
    var categoryName: String
    var categoryThumbPath: String // TODO: Delete From Disk
    var lastModified: String
    var categoryThumbType: String
    var categoryDataPath: String
    var categoryMetaData: [DBCategoryMetaModel]?
    var canDelete: Bool
    var isHeaderDownloaded: Bool

    // Function to set CategoryInfo from Category
    mutating func setCategoryInfo(category: ServerCategoryModel) {
        self.categoryId = Int(category.categoryId) ?? 0
        self.categoryName = category.categoryName
        self.categoryThumbPath = category.categoryThumbPath ?? ""
        self.lastModified = category.lastModified
        self.categoryThumbType = category.categoryThumbType ?? ""
        self.categoryDataPath = category.categoryDataPath
        self.categoryMetaData = []
        self.canDelete = category.canDelete == "1"
        self.isHeaderDownloaded = category.isHeaderDownloaded == "1"
    }


    // Function to get Category from CategoryInfo
    func getCategoryServer() -> ServerCategoryModel {
        return ServerCategoryModel(categoryId: String(categoryId),
                        categoryName: categoryName,
                        categoryThumbPath: categoryThumbPath,
                        lastModified: lastModified,
                        isHeaderDownloaded: isHeaderDownloaded ? "0" : nil,
                        canDelete: canDelete ? "0" : nil,
                        categoryThumbType: categoryThumbType,
                        categoryDataPath: categoryDataPath,
                        categoryMetaData: nil)
    }

    // Function to set CategoryInfo from DBCategoryModel
    mutating func setCategoryInfo(dbCategoryModel: DBCategoryModel) {
        self.categoryId = dbCategoryModel.categoryId
        self.categoryName = dbCategoryModel.categoryName
        self.categoryThumbPath = dbCategoryModel.categoryThumbPath
        self.lastModified = dbCategoryModel.lastModified
        self.categoryThumbType = dbCategoryModel.categoryThumbType
        self.categoryDataPath = dbCategoryModel.categoryDataPath
        self.categoryMetaData = dbCategoryModel.categoryMetaData
        self.canDelete = dbCategoryModel.canDelete
        self.isHeaderDownloaded = dbCategoryModel.isHeaderDownloaded
    }

    // Function to get DBCategoryModel from CategoryInfo
    func getDBCategoryModel() -> DBCategoryModel {
        return DBCategoryModel(categoryId: categoryId,
                               categoryName: categoryName,
                               categoryThumbPath: categoryThumbPath,
                               lastModified: lastModified,
                               categoryThumbType: categoryThumbType,
                               categoryDataPath: categoryDataPath,
                               categoryMetaData: categoryMetaData,
                               canDelete: canDelete,
                               isHeaderDownloaded: isHeaderDownloaded)
    }
    
    
    // Initializer from DBCategoryModel
       init(from dbCategoryModel: DBCategoryModel) {
           self.categoryId = dbCategoryModel.categoryId
           self.categoryName = dbCategoryModel.categoryName
           self.categoryThumbPath = dbCategoryModel.categoryThumbPath
           self.lastModified = dbCategoryModel.lastModified
           self.categoryThumbType = dbCategoryModel.categoryThumbType
           self.categoryDataPath = dbCategoryModel.categoryDataPath
           self.categoryMetaData = dbCategoryModel.categoryMetaData
           self.canDelete = dbCategoryModel.canDelete
           self.isHeaderDownloaded = dbCategoryModel.isHeaderDownloaded
       }

       // Initializer from Category
       init(form category: ServerCategoryModel) {
           self.categoryId = Int(category.categoryId) ?? 0
           self.categoryName = category.categoryName
           self.categoryThumbPath = category.categoryThumbPath ?? ""
           self.lastModified = category.lastModified
           self.categoryThumbType = category.categoryThumbType ?? ""
           self.categoryDataPath = category.categoryDataPath
           self.categoryMetaData = nil
           self.canDelete = category.canDelete == "1"
           self.isHeaderDownloaded = category.isHeaderDownloaded == "1"
       }
}

