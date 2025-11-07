//
//  WatermarkView.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 25/01/25.
//

import UIKit

extension ViewManager {

    @objc internal func handleTapForPremiumButton(_ gesture: UITapGestureRecognizer) {
        if !(vmConfig.isPremium || templateHandler?.currentTemplateInfo?.isPremium == 1){
            templateHandler?.currentActionState.didGetPremiumTapped = true
        }
    }
    
    func updateGridMangerIfNeeded() {
        guard let currentPageView = rootView?.currentPage else {
            logger.logError("No Current Page Found")
            return
        }
        
        if gridManager == nil{
            gridManager = GridManager(frame: currentPageView.bounds, templateHandler: templateHandler!, pageView: currentPageView)
            gridManager?.center = CGPoint(x: Double(editView!.canvasView.bounds.width/2), y: Double(editView!.canvasView.bounds.height/2))
            gridManager?.backgroundColor = .clear
            editView?.canvasView.addSubview(gridManager!)
        }else{
            guard let rootView = rootView , let currentPage = rootView.currentPage else {
                logger.logError("No Current Page Found")
                return
            }
            guard let editView = editView else {
                logger.logError("No Current Page Found")
                return
            }

            
            gridManager?.removeFromSuperview()
            gridManager = nil
            gridManager = GridManager(frame: currentPageView.bounds, templateHandler: templateHandler!, pageView: currentPage)
            gridManager?.center = CGPoint(x: Double(editView.canvasView.bounds.width/2), y: Double(editView.canvasView.bounds.height/2))
            gridManager?.backgroundColor = .clear
            editView.canvasView.addSubview(gridManager!)

        }
    }
    
}
