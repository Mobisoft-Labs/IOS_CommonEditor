////
////  ContentView.swift
////  DummyForPager
////
////  Created by Neeshu Kumar on 08/08/24.
////

import SwiftUI

struct PagerView: View {
    @StateObject var currentActionState: ActionStates
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                if currentActionState.isScrollViewShowOrNot{
                    createScrollView(geometry: geometry) // Create the ScrollView component
                        .frame(width: geometry.size.width, height: currentActionState.pageSize.height)
                        .onChange(of: currentActionState.scrollOffset) { newValue in
                            handleScrollOffsetChange(newValue: newValue, geometry: geometry) // Handle scroll offset changes
                        }
                        .onChange(of: currentActionState.pagerScrolledOff) { isScrolledEnd in
                            handlePagerScrolledOff(geometry: geometry) // Handle when the pager scroll ends
                        }
                }
            }
            .frame(height: currentActionState.pageSize.height)
        }
        .disabled(true)
        .onAppear {
            handleOnAppear() // Handle the view's onAppear event
        }
        .onDisappear {
            handleOnDisappear() // Handle the view's onDisappear event
        }
    }
    
    // Function to create the ScrollView component
    private func createScrollView(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: true) {
            createImageStack(geometry: geometry) // Create the image stack
        }
        .disabled(true)
//        .content.offset(x: CGFloat(10), y: 0) // Adjust content offset based on scrollOffset
    }
    
    // Function to create the HStack of images
    private func createImageStack(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<currentActionState.pageModelArray.count, id: \.self) { index in
                HStack(alignment: .center, content: {
                    createImageView(index: index, geometry: geometry)
                      
                })
                .disabled(true)
                .frame(width: geometry.size.width)
                .offset(x: currentActionState.scrollOffset, y: 0)
             // Adjust offset
            }
        }
        .disabled(true)
        .animation(.bouncy, value: currentActionState.currentPage) // Smoother animation
    }

    // Function to create individual image views
    private func createImageView(index: Int, geometry: GeometryProxy) -> some View {
        
        ZStack {
            if let image = currentActionState.pageModelArray[index].thumbImage{
                SwiftUI.Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: currentActionState.pageSize.width, height: currentActionState.pageSize.height)
                    .cornerRadius(10)
                    .padding(.horizontal, (geometry.size.width - currentActionState.pageSize.width) / 2)
                    .tag(index)
                    .disabled(true)
                
                //            Text("Page \(index)")
                
            }
        }
        
    }
    
    // Function to handle scroll offset changes
    private func handleScrollOffsetChange(newValue: CGFloat, geometry: GeometryProxy) {
        // For Enhancement
        print("Continous Offset \(newValue)")
    }
    
    // Function to handle when the pager scroll ends
    private func handlePagerScrolledOff(geometry: GeometryProxy) {
        let pageWidth = -geometry.size.width
        var halfPageWidth : Int = Int(geometry.size.width/1.5)
        let mod = abs(currentActionState.scrollOffset).truncatingRemainder(dividingBy: geometry.size.width)
        let halfWidth = geometry.size.width/3
        var index : Int =  currentActionState.currentPage
        currentActionState.directionOfScrollView =  (CGFloat(index) * abs(pageWidth)) > abs(currentActionState.scrollOffset) ? .right : .left
        if mod > halfWidth{
            if currentActionState.directionOfScrollView == .left{
                halfPageWidth = -halfPageWidth
                currentActionState.currentPage = min(currentActionState.pageModelArray.count - 1,currentActionState.currentPage + 1)
            }
            else if currentActionState.directionOfScrollView == .right{
                currentActionState.currentPage = max(0,currentActionState.currentPage - 1)
            }
            //        let unsignedCurrentOffset : Int = abs(Int(currentOffset))
            index = currentActionState.currentPage //(unsignedCurrentOffset + halfPageWidth) / Int(geometry.size.width)
            print("NK INdex : \(index)")
            print("Ended Offset \(currentActionState.scrollOffset)")
        }
        
        currentActionState.scrollOffset = CGFloat(currentActionState.currentPage) * pageWidth
        // Update the selected page and current page index
        if index >= 0 && index < currentActionState.pageModelArray.count {
            let currentModelID = currentActionState.pageModelArray[index].id
            currentActionState.selectedPageID = currentModelID
            currentActionState.currentPage = index // Update current page index
            print("Current page index: \(currentModelID)")
        }
    }
    
    // Function to handle onAppear event
    private func handleOnAppear() {
        print("Hey Neeshu On Appear")
    }
    
    // Function to handle onDisappear event
    private func handleOnDisappear() {
        print("Hey Neeshu On Disappear")
    }
}
struct PagerControllerView: View {
    @StateObject var currentActionState : ActionStates
    
    var body: some View {
        ZStack {
            PagerView(currentActionState: currentActionState)
        }
    }
}


// Collection View Updation using page (page number)
// Collection View Updation usnig Offset

// In above code in both case page selected.
