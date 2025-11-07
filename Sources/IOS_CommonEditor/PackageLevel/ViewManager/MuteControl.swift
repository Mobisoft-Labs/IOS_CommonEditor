//
//  MuteControl.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 12/08/24.
//

import SwiftUI

public struct MuteControl: View {
    
    @Binding var isMute: Bool
    @State var changeImage: Bool = false
    @State var isShaking: Bool = false
    
    public init(isMute: Binding<Bool>, changeImage: Bool = false, isShaking: Bool = false) {
        self._isMute = isMute
        self._changeImage = State(initialValue: changeImage)
        self._isShaking = State(initialValue: isShaking)
    }
    
    public var body: some View {
        VStack{
            Button {
                isMute.toggle()
                changeImage.toggle()
                // Start or stop shaking based on the changeImage state
                if changeImage {
                    startShaking()
                } else {
                    stopShaking()
                }
            }label: {
                VStack{
                    if changeImage{
                        SwiftUI.Image(systemName: "speaker.slash")
                            .renderingMode(.template)
                            .foregroundColor(Color.label)
                            .frame(width: 40, height: 40)
                    }else{
                        SwiftUI.Image(systemName: "speaker.wave.3")
                            .renderingMode(.template)
                            .foregroundColor(Color.label)
                            .frame(width: 40, height: 40)
                        
                    }
                }
                .frame(width: 40, height: 40)
                .background(Color.secondarySystemBackground)
                .clipShape(Circle())
            }
            .frame(width: 40, height: 40)
            
        }
        .rotationEffect(.degrees(isShaking ? 20 : 0))
        .onAppear(){
            changeImage = isMute
            
            if changeImage {
                startShaking()
            } else {
                stopShaking()
            }
        }
    }
    
    private func startShaking() {
        // Start shaking animation
        withAnimation(Animation.linear(duration: 0.1).repeatForever(autoreverses: true)) {
            isShaking = true
        }
    }
    
    private func stopShaking() {
        // Stop shaking animation
        withAnimation {
            isShaking = false
        }
    }
    
}

//#Preview {
//    MuteControl()
//}
