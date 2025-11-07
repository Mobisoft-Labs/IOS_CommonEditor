//
//  ViewManager+ZoomCotrollerLogic.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 29/03/25.
//

import UIKit

extension ViewManager{
     func zoomIn() {
        guard let editView = editView else { return }
        if editView.canvasView.frame.size.width > editView.canvasView.frame.size.height{
            currentScale = editView.canvasView.frame.size.width / editView.frame.size.width
        }
        else{
            currentScale = editView.canvasView.frame.size.height / editView.frame.size.height
        }
        adjustZoom(scale: zoomInScale)
    }
    
     func zoomOut() {
        guard let editView = editView else { return }

        if editView.canvasView.frame.size.width >= editView.canvasView.frame.size.height{
            currentScale = editView.canvasView.frame.size.width / editView.frame.size.width
        }
        else{
            currentScale = editView.canvasView.frame.size.height / editView.frame.size.height
        }
        adjustZoom(scale: zoomOutScale)
    }
    
     func adjustZoom(scale: CGFloat) {
        guard let editView = editView else { return }

        var prevCenter = editView.canvasView.center
        // Calculate the new scale based on the current scale
         let newScale = currentScale * scale
        
        // Check if the new scale is within the allowed range
        guard newScale > minScale && newScale < maxScale else {
            return
        }
        
        // If the view is not in its initial state, perform bounds check
         if currentScale != 1.0 {
            // Calculate the new frame size based on the new scale
            let newWidth = editView.canvasView.frame.size.width * scale
            let newHeight = editView.canvasView.frame.size.height * scale
            let newCenterX = editView.bounds.width / 2
            let newCenterY = editView.bounds.height / 2
            
            // Check if the new frame would be within bounds
            let minX = newCenterX - newWidth / 2
            let maxX = newCenterX + newWidth / 2
            let minY = newCenterY - newHeight / 2
            let maxY = newCenterY + newHeight / 2
            
            if  minX >= editView.bounds.minX && maxX <= editView.bounds.maxX &&
                    minY >= editView.bounds.minY && maxY <= editView.bounds.maxY{
                prevCenter = editView.center
            }
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                let prevCenter = editView.canvasView.center
                editView.canvasView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
                editView.canvasView.center = CGPoint(
                    x: prevCenter.x,
                    y: prevCenter.y
                )
            }
            
            if editView.canvasView.frame.size.width >=  editView.canvasView.frame.size.height{
                if editView.canvasView.frame.size.width <= editView.frame.size.width{
                    let size = editView.frame.size
                    editView.canvasView.center = CGPoint(x: size.width/2, y: size.height/2)
                }
            }
            else if editView.canvasView.frame.size.width <=  editView.canvasView.frame.size.height{
                if editView.canvasView.frame.size.height <= editView.frame.size.height{
                    let size = editView.frame.size
                    editView.canvasView.center = CGPoint(x: size.width/2, y: size.height/2)
                }
            }
        }
        
        // Update the current scale
         currentScale = newScale
         if currentScale > 1.0 {
             invertScale = currentScale
             currentActiveView?.invertedScale = currentScale
         }
    }
   
}
