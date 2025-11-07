//
//  EasyToolBar.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 29/01/25.
//
import SwiftUI

struct EasyToolBar: View {
    
    @EnvironmentObject var templateHandler : TemplateHandler
    var vmConfig: ViewManagerConfiguration
    
    var body : some View {
        if let currentModel = templateHandler.currentModel {
            HStack {
                
                // it will depend upon which of currentModel is of Type
                if templateHandler.currentModel is StickerInfo {
                    StickerEasyToolBar(vmConfig: vmConfig)
                } else if templateHandler.currentModel is TextInfo {
                    TextEasyToolBar(vmConfig: vmConfig)
                } else {
                    ParentEasyToolBar(vmConfig: vmConfig)
                }
                
            } .frame(width: 180,height: 40)
                .background(.white)
                .cornerRadius(20.0)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                .environmentObject(templateHandler.currentActionState)
                .environmentObject(currentModel)
                .environmentObject(templateHandler)

        }
    }
    
    
}

struct StickerEasyToolBar : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates

    @State var uniqueCategories: [String] = []
    @State var didReplaceClicked: Bool = false

    var vmConfig: ViewManagerConfiguration
 
    
   
    
    var body: some View {
      
        if currentModel is StickerInfo {
               
            if currentModel.lockStatus {
                    
                HStack {
                       
                    UnLockItem(vmConfig: vmConfig)
                       
                }.frame(width: 180)
                  
                  
        } else {
                HStack {
                          
                    ReplaceStickerItem(didTapReplaceSticker: $didReplaceClicked)
                    ToolSeparator()
                    LockItem()
                    ThreeDotOptionItem()
                    ToolSeparator()
                    DeleteOptionItem()
                            
                }.frame(width: 180)
                .fullScreenCover(isPresented: $didReplaceClicked) {
//                    NavigationView {
//                        StickerPicker(
//                            newStickerAdded: $currentActionModel.replaceSticker,
//                            isStickerPickerPresented: $didReplaceClicked,
//                            uniqueCategories: $uniqueCategories,
//                            previousSticker : (currentModel as? StickerInfo)!.changeOrReplaceImage?.imageModel,
//                            replaceSticker: $currentActionModel.replaceSticker,
//                            updateThumb: $currentActionModel.updateThumb
//                            
//                        )
//                        .navigationTitle("Sticker_").environment(\.sizeCategory, .medium)
//                        .navigationBarItems(trailing: Button(action: {
//                            // Action for done button
//                            didReplaceClicked = false
//                        }) {
//                            VStack{
//                                SwiftUI.Image("ic_Close")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                            }
//                            .frame(width: 30, height: 30)
//                            .background(.white)
//                            .cornerRadius(15)
//                        })
//                        .navigationBarTitleDisplayMode(.inline)
//                    }
//                    .navigationViewStyle(StackNavigationViewStyle())
                }
                }
                    
                

        }
            
        
    }
}
struct ParentEasyToolBar : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates
    var vmConfig: ViewManagerConfiguration
    
    var body: some View {
        if let model = currentModel as? ParentInfo {
            
            
            
            
            if model.lockStatus {
                
                HStack {
                    
                    UnLockItem(vmConfig: vmConfig)
                    
                }.frame(width: 180)
                
                
            } else if model.editState {
                
                HStack {
                    
                    EditOnItem(vmConfig: vmConfig)
                    
                }.frame(width: 180)
                
            } else /* Selected  */{
                    HStack {
                              
                        EditItem(vmConfig: vmConfig)
                        ToolSeparator()
                        LockItem()
                        ThreeDotOptionItem()
                        ToolSeparator()
                        DeleteOptionItem()
                                
                    }.frame(width: 180)
                  
            }
                        
                    

            
            }
    }
}
struct TextEasyToolBar : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates
    var vmConfig: ViewManagerConfiguration
    
    var body: some View {
        
        if currentModel is TextInfo {
               
            if currentModel.lockStatus {
                    
                HStack {
                       
                        UnLockItem(vmConfig: vmConfig)
                       
                }.frame(width: 180)
                  
                  
        } else {
                HStack {
                          
                    EditItem(vmConfig: vmConfig)
                    ToolSeparator()
                    LockItem()
                    ThreeDotOptionItem()
                    ToolSeparator()
                    DeleteOptionItem()
                            
                }.frame(width: 180)
              
                }
                    
                

        }
            
        
    }
}

struct ToolSeparator : View {
    var body: some View {
        
        Text("|").multilineTextAlignment(.center).font(.footnote).frame(height: 30).foregroundStyle(.secondary)
    }
}

struct ToolBarTextItem : View {
    var text: String
    var textColor : Color = .secondary
    var body: some View {
        Text(text).multilineTextAlignment(.center).font(.footnote).frame(height: 30).foregroundStyle(textColor)

    }
}
