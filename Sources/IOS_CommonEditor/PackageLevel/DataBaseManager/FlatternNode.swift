//
//  FlatternNode.swift
//  VideoInvitation
//
//  Created by HKBeast on 12/03/24.
//

import Foundation

class NodeHandler {

    var childTable : [Int : BaseModelProtocol] = [:]
    
    
}

class FlatternNode{
    //MARK: - ******* variables ********

    var templateInfo:TemplateInfo
    var flatternTreeArray = [BaseModelProtocol]()
  //  let nodeDictonary:[Int:BaseModelProtocol]
    var nodeDictArray = [[Int:BaseModelProtocol]]()
    
    //MARK: - ******** INIT ******

    init(templateInfo: TemplateInfo) {
        self.templateInfo = templateInfo
    }
    
    //MARK: - ******* PUBLIC METHODS ******

    // function to convert template info to flattern array
    func getFlatternNodeArray()->[[Int:BaseModelProtocol]]{
 
        let templateModel = templateInfo.getDBTemplateModel()
        let pages = templateInfo.pageInfo
        for page in pages {
            nodeDictArray.append([page.modelId:page])
            flatternTreeArray.append(page)
            for model in page.children{
              addParentInDict(model: model)
               
            }
        }
        
        
        return nodeDictArray
    }
    
    private func addParentInDict(model:BaseModelProtocol){
        if model.modelType == .Parent{
            nodeDictArray.append([model.modelId:model])
            flatternTreeArray.append(model)
            let childModels = model as! ParentInfo
            for child in childModels.children{
                addParentInDict(model:child )
            }
            
        }else{
            nodeDictArray.append([model.modelId:model])
            flatternTreeArray.append(model)
        }
    }
    
    
    func getModelFromDict(for id:Int) -> BaseModelProtocol{
        return nodeDictArray[id] as! BaseModelProtocol
    }
    
    func getParentforModel(id:Int)-> BaseModelProtocol{
        let model = nodeDictArray[id] as! BaseModelProtocol
        return getModelFromDict(for: model.parentId)
    }
}



