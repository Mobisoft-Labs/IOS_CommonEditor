//
//  DBManager+Delete.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 21/07/23.
//

import Foundation

extension DBManager{
    
    //MARK: - Delete
    // Delete Template row
    public func deleteTemplateRow(templateId: Int, ratioId: Int) -> Bool {
        _ =  executeDeleteQuery(forTable: TABLE_MUSICINFO, whereColumn: TEMPLATE_ID, withValue: templateId)
        _ =  executeDeleteQuery(forTable: TABLE_IMAGE, whereColumn: TEMPLATE_ID, withValue: templateId)
        _ =  executeDeleteQuery(forTable: TABLE_ANIMATION, whereColumn: TEMPLATE_ID, withValue: templateId)
        _ =  executeDeleteQuery(forTable: TABLE_STICKER, whereColumn: TEMPLATE_ID, withValue: templateId)
        _ =  executeDeleteQuery(forTable: TABLE_TEXT_MODEL, whereColumn: TEMPLATE_ID, withValue: templateId)
        _ =  executeDeleteQuery(forTable: TABLE_BASEMODEL, whereColumn: TEMPLATE_ID, withValue: templateId)
        _ =  executeDeleteQueryForRatio(forTable: TABLE_RATIOMODEL, whereColumn: TEMPLATE_ID, withValue: templateId)
        
        return executeDeleteQuery(forTable: TABLE_TEMPLATE, whereColumn: TEMPLATE_ID, withValue: templateId)
    }
    
    
    // Delete query for individual column in TEMPLATE table
    func deleteTemplateByColumnNew(columnValue: String) -> Bool {
        
        let arrayOfTemplateIds = getTemplateIDs(ByCategoryName: columnValue)
        var count = 0
        arrayOfTemplateIds.forEach { templateID  in
           _ = deleteTemplateRow(templateId: templateID, ratioId: 0)
           count+=1
        }
        logger?.logInfo("TEMPLATE type Templates Deleted Total : \(count)")
        return true
    }

       // Delete Image row
       func deleteImage(imageId: Int) -> Bool {
           return executeDeleteQuery(forTable: TABLE_IMAGE, whereColumn: IMAGE_ID, withValue: imageId)
       }

    
       // Delete BaseModel row
       func deleteBaseModel(modelId: Int) -> Bool {
           return executeDeleteQuery(forTable: TABLE_BASEMODEL, whereColumn: MODEL_ID, withValue: modelId)
       }

    
       // Set SoftDelete flag on BaseModel
       func setSoftDeleteFlagOnBaseModel(modelId: Int, isDeleted: Bool) -> Bool {
           var deleted = false
           let query = "UPDATE \(TABLE_BASEMODEL) SET \(SOFT_DELETE) = \(isDeleted ? 1 : 0) WHERE \(MODEL_ID) = \(modelId)"
           do {
              try updateQuery(query, values: nil)
              deleted = true
           }
           catch {
               logger?.printLog("failed to deleteTemplate")
           }
           
       return deleted
       }

       // Delete StickerModel row
       func deleteStickerModel(stickerId: Int) -> Bool {
           return executeDeleteQuery(forTable: TABLE_STICKER, whereColumn: TEMPLATE_ID, withValue: stickerId)
       }

       // Delete TextModel row
       func deleteTextModel(textId: Int) -> Bool {
           return executeDeleteQuery(forTable: TABLE_TEXT_MODEL, whereColumn: TEMPLATE_ID, withValue: textId)
       }

       // Delete ParentModel row
//       func deleteParentModel(id: Int) -> Bool {
//           return executeDeleteQuery(forTable: tab, whereColumn: ID, withValue: id)
//       }

       // Delete Animation row
       func deleteAnimation(modelId: Int) -> Bool {
           return executeDeleteQuery(forTable: TABLE_ANIMATION, whereColumn: TEMPLATE_ID, withValue: modelId)
       }

       // Delete MusicInfo row by musicId
       func deleteMusicInfo(musicId: Int) -> Bool {
           var deleted = false
           let query = "DELETE FROM \(TABLE_MUSICINFO) WHERE \(MUSIC_ID) = \(musicId)"
           do {
              try updateQuery(query, values: nil)
              deleted = true
           }
           catch {
               logger?.printLog("failed to deleteTemplate")
           }
           
       return deleted
       }

       // Delete MusicInfo row by parentId and parentType
       func deleteMusicInfo(parentId: Int, parentType: Int) -> Bool {
           var deleted = false
           let query = "DELETE FROM \(TABLE_MUSICINFO) WHERE \(parentId) = \(parentId) AND \(parentType) = \(parentType)"
           do {
              try updateQuery(query, values: nil)
              deleted = true
           }
           catch {
               logger?.printLog("failed to deleteTemplate")
           }
           
       return deleted
       }

    // Delete MusicInfo row by parentId and parentType
    func deleteMusicInfo(parentId: Int, templateID : Int,parentType: Int) -> Bool {
        var deleted = false
        let query = "DELETE FROM \(TABLE_MUSICINFO) WHERE \(parentId) = \(parentId) AND \(parentType) = \(parentType)"
        do {
           try updateQuery(query, values: nil)
           deleted = true
        }
        catch {
            logger?.printLog("failed to deleteTemplate")
        }
        
    return deleted
    }
       // Generic function to execute DELETE query
       private func executeDeleteQuery(forTable table: String, whereColumn column: String, withValue value: Int) -> Bool {
           var deleted = false
           let query = "delete from \(table) where \(column)=?"
               do {
                  try updateQuery(query, values: [value])
                  deleted = true
               }
               catch {
                   logger?.printLog("failed to deleteTemplate")
               }
               
           return deleted
       }
    
    // Generic function to execute DELETE query
    private func executeDeleteQueryForRatio(forTable table: String, whereColumn column: String, withValue value: Int) -> Bool {
        var deleted = false
        let category = "FREESTYLE"
        let query = "delete from \(table) where \(column)=? && CATEGORY=?"
            do {
               try updateQuery(query, values: [value, category])
               deleted = true
            }
            catch {
                logger?.printLog("failed to deleteTemplate")
            }
            
        return deleted
    }
    
    
    
    func deleteAllCategoryMetaData() {
        let query = "DELETE FROM \(CATEGORY_META_DATA)"

        do {
            try database.executeUpdate(query, values: nil)
            print("All data deleted from CATEGORY_META_DATA")
        } catch {
            print("Failed to delete data: \(error.localizedDescription)")
        }
    }

    
    
    
    //Delete the Tamplate Headers for the particular category
    func deleteTemplatesHeader(category : String)-> Bool{
        var deleted = false
        let query = "delete from \(TABLE_TEMPLATE) where \(CATEGORY_TEMP)= ? and \(CATEGORY) != 'TEMPLATE_APK'"
            do {
               try updateQuery(query, values: [category])
               deleted = true
            }
            catch {
                logger?.printLog("failed to deleteTemplate")
            }
            
        return deleted
    }
    
    //Delete the category from the CATEGORY_MASTER table.
    func deleteCategory(category: String)-> Bool{
        var deleted = false
        let query = "delete from \(TABLE_CATEGORY) where \(CATEGORY_NAME)=?"
            do {
               try updateQuery(query, values: [category])
               deleted = true
            }
            catch {
                logger?.printLog("failed to deleteTemplate")
            }
            
        return deleted
    }
    
    func deleteFontTable()-> Bool{
        var deleted = false
        let query = "delete from \(TABLE_FONTMODEL)"
            do {
               try updateQuery(query, values: [])
               deleted = true
            }
            catch {
                logger?.printLog("failed to deleteTemplate")
            }
            
        return deleted
    }
    
   
    
    
}


//Delete Query for deleting the rows from all table with the TemplateID.
extension DBManager {
    func deleteRowsWithTemplateID(templateID: String) throws {
        let tables = [
            TABLE_TEMPLATE,
            TABLE_IMAGE,
            TABLE_BASEMODEL,
            TABLE_STICKER,
            TABLE_TEXT_MODEL,
            TABLE_ANIMATION,
            TABLE_MUSICINFO,
            TABLE_ANIMATION_CATEGORIES,
            TABLE_ANIMATION_TEMPLATE,
            TABLE_KEYFRAMES,
            TABLE_MUSICS,
            TABLE_RATIOMODEL,
            TABLE_CATEGORY,
            TABLE_CATEGORY_METADATA
        ]
        
        for table in tables {
            let query = "DELETE FROM \(table) WHERE \(TEMPLATE_ID) = ?"
            try updateQuery(query, values: [templateID])
        }
    }
    
    func deleteFont(){
        let query = "DELETE FROM \(TABLE_FONTMODEL) where \(Font_fontSource) = 'SystemFont';"
        do{
            try updateQuery(query, values: nil)
        }catch{
            
        }
    }
}
