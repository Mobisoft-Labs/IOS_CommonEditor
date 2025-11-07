//
//  ToolBarButtons.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 29/01/25.
//

import SwiftUI


struct EditOnItem : View {
    @EnvironmentObject var currentModel : BaseModel
    var vmConfig: ViewManagerConfiguration
    
    var body: some View {
        if let model = currentModel as? ParentInfo {
            Button {
                model.editState = false
            } label: {
                HStack {
                    ToolbarImageViewSystem(imageName: AppIcons.doneCheckMark,color: vmConfig.accentColorSwiftUI.opacity(0.5))
                    ToolBarTextItem(text: "Edit_OFF"/*.translate()*/,textColor: vmConfig.accentColorSwiftUI)

                        
                }
            }
        }
    }
}

struct UnLockItem : View {
    @EnvironmentObject var currentModel : BaseModel
    var vmConfig: ViewManagerConfiguration
    
    var body: some View {
        
        Button {
            currentModel.lockStatus = false
        } label: {
            HStack {
                ToolbarImageViewSystem(imageName: AppIcons.lock,color: vmConfig.accentColorSwiftUI)
                ToolBarTextItem(text: "unlock_"/*.translate()*/,textColor: vmConfig.accentColorSwiftUI)

            }
        }
    }
}


struct DeleteOptionItem : View {
   
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates
    @EnvironmentObject var templateHandler : TemplateHandler

   
    
    var body : some View {
        HStack {
            Menu {
                Button(action: {
                    currentModel.softDelete = true
                   // templateHandler.deepSetCurrentModel(id: currentModel.parentId, smartSelect: false)
                   // currentActionModel.isSelectLastModel = true
                    currentActionModel.isCurrentModelDeleted = true
                    currentActionModel.updatePageAndParentThumb = true

                    currentActionModel.shouldRefreshOnAddComponent = true
                }) {
                    Text("Yes_")
                }

                Button(action: {}) {
                    Text("No_")
                }
            } label: {
                VStack {
                    ToolbarImageViewSystem(imageName: AppIcons.delete,color: .red)
                }
            }

        }
    }
}


struct LockItem : View {
    @EnvironmentObject var currentModel : BaseModel
    
    var body: some View {
      
        Button {
            currentModel.lockStatus = true 
        } label: {
            VStack {
                ToolbarImageViewSystem(imageName: AppIcons.unLock)
            }
        }
           
    }
}

struct EditItem : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var actions : ActionStates
    var vmConfig: ViewManagerConfiguration
    
    var body: some View {
        if let model = currentModel as? ParentInfo {
            Button {
                model.editState = true
            } label: {
                VStack {
                    ToolBarTextItem(text: "Edit_"/*.translate()*/,textColor: vmConfig.accentColorSwiftUI)
                }
            }
        }else if let model = currentModel as? TextInfo {
            Button {
                actions.didEditTextClicked = true
            } label: {
                VStack {
                    ToolBarTextItem(text: "Edit_"/*.translate()*/,textColor: vmConfig.accentColorSwiftUI)
                }
            }
        }
           
    }
}

struct ReplaceStickerItem : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var actionState : ActionStates
    @Binding var didTapReplaceSticker : Bool
    var body: some View {
        if let currentModel = currentModel as? StickerInfo {
            Button {
                didTapReplaceSticker = true
            } label: {
                VStack {
                    ToolbarImageViewSystem(imageName: AppIcons.stickerReplace)
                }
            }
            
        }
    }
}


struct ThreeDotOptionItem : View {

    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var templateHandler: TemplateHandler
  //  @Binding var didReplaceClicked : Bool
    var currentActionModel : ActionStates {
        return templateHandler.currentActionState
    }
    var body : some View {
        HStack {
            // Action Menu
            Menu {
                Button {
                    currentActionModel.copyModel = currentModel.modelId
                } label: {
                    Text("Copy_")
                }

                Button {
                    currentActionModel.duplicateModel = currentModel.modelId
                } label: {
                    Text("Duplicate_")
                }
                if !currentActionModel.multiModeSelected {
                    Button {
                        currentActionModel.multiModeSelected = true
                    } label: {
                        Text("Create_Group_")
                    }
                }
            } label: {
                ToolbarImageViewSystem(imageName: AppIcons.threeDotButton)
            }
        }
    }
}


public struct AppIcons {
    static var threeDotButton = "ellipsis.circle"
    static public var delete = "trash"
    static var lock = "lock.fill"
    static var unLock = "lock.open"
    static var doneCheckMark = "checkmark"
    static var stickerReplace = "repeat"
    
}

struct ToolbarImageViewSystem : View {
    var imageName: String
    var color: Color = .black
    var size: CGFloat = 20
    
    var body: some View {
       
        SwiftUI.Image(systemName: imageName)
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(width: size, height: size)
            .frame(width: 25, height: 25)

    }
}
