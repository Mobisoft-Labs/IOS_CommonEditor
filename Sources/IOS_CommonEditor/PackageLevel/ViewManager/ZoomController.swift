//
//  ZoomController.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 06/08/24.
//
import SwiftUI
import UIKit

struct ZoomController: View {
    @StateObject var actionStates : ActionStates
    
    var body: some View {
        HStack {
            Button {
                actionStates.zoomEditView = .scaleUp
            } label: {
                SwiftUI.Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.black)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding()
            
            Button {
                actionStates.zoomEditView = .scaleDown
            } label: {
                SwiftUI.Image(systemName: "minus")
                    .resizable()
                    .foregroundColor(.black)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding()
        }
        .frame(width: 130, height: 40)
        .background(Color.white)
        .cornerRadius(15.0)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
    
}

