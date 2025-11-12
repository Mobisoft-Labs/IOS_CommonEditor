////
////  EditControlBar.swift
////  VideoInvitation
////
////  Created by Neeshu Kumar on 29/10/24.
////
//
//import SwiftUI
//
//struct EditControlBar: View, Identifiable {
//    let id : Int
//    let vmConfig: ViewManagerConfiguration
//    @ObservedObject var currentModel : ParentInfo
//    
//    var body: some View {
//        VStack{
//            
//            if currentModel.editState {
//                Button {
//                    currentModel.editState = false
//                } label: {
//                    HStack {
//                        ToolbarImageViewSystem(imageName: AppIcons.doneCheckMark,color: vmConfig.accentColorSwiftUI.opacity(0.5))
//                        ToolBarTextItem(text: "Edit_OFF".translate(),textColor: vmConfig.accentColorSwiftUI)
//                        
//                        
//                    }
//                }
//            }else {
//                Button {
//                    currentModel.editState = true
//                } label: {
//                    VStack {
//                        ToolBarTextItem(text: "Edit_".translate(),textColor: vmConfig.accentColorSwiftUI)
//                    }
//                }
//            }
//        }
//        .frame(width: 30 , height: 30)
//        .background(.white)
//        .cornerRadius(25.0)
//        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
//    }
//    
//}
//
////#Preview {
////    EditControlBar()
////}
