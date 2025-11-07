//
//  GestureHandler.swift
//  VideoInvitation
//
//  Created by HKBeast on 22/09/23.
//

import Foundation
import UIKit

@objc
protocol GestureHandler {
   @objc func handleTapGesture(_ gesture: UITapGestureRecognizer)
    func handleRotationGesture(_ gesture: UIRotationGestureRecognizer)
    func handleScaleGesture(_ gesture: UIPinchGestureRecognizer)
    func handlePanGesture(_ gesture: UIPanGestureRecognizer)
    func handleDoubleTap(_ gesture: UITapGestureRecognizer)
    func handleLongPress(_ gesture: UILongPressGestureRecognizer)
//    func handleSwipeGesture(_ gesture : UISwipeGestureRecognizer)
}


public class GestureHandlerView: UIView {
    var tapGesture: UITapGestureRecognizer!
    var rotationGesture: UIRotationGestureRecognizer!
    var scaleGesture: UIPinchGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    var doubleTapGesture : UITapGestureRecognizer!
    var longPressGesture : UILongPressGestureRecognizer!
//    var swipeGesture : UISwipeGestureRecognizer!
   weak var gestureHandler : GestureHandler?
    
    public var isAllGesturesEnabled: Bool {
        get {
            return isTapGestureEnabled && isRotationGestureEnabled && isScaleGestureEnabled && isPanGestureEnabled
        }
        set {
            isTapGestureEnabled = newValue
            isRotationGestureEnabled = newValue
            isScaleGestureEnabled = newValue
            isPanGestureEnabled = newValue
        }
    }
    
    var isTapGestureEnabled: Bool = true {
           didSet {
               tapGesture.isEnabled = isTapGestureEnabled
           }
       }
       
       var isRotationGestureEnabled: Bool = true {
           didSet {
               rotationGesture.isEnabled = isRotationGestureEnabled
           }
       }
       
       var isScaleGestureEnabled: Bool = true {
           didSet {
               scaleGesture.isEnabled = isScaleGestureEnabled
           }
       }
       
       var isPanGestureEnabled: Bool = true {
           didSet {
               panGesture.isEnabled = isPanGestureEnabled
           }
       }

       override init(frame: CGRect) {
           super.init(frame: frame)
           
           setupGestures()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           setupGestures()
       }
    
    private func setupGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotationGesture(_:)))
        scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handleScaleGesture(_:)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        
        // Add double tap gesture recognizer
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
       
        // Add long press gesture recognizer
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
//        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
//        swipeGesture.direction = .left
        
        // Ensure panGesture only recognizes if swipeGesture fails
//        panGesture.require(toFail: swipeGesture)
        
        
       
//        self.addGestureRecognizer(swipeGesture)
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(rotationGesture)
        self.addGestureRecognizer(scaleGesture)
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(doubleTapGesture)
        self.addGestureRecognizer(longPressGesture)
      }

      @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
          // Implement your tap gesture handling logic here
        
          gestureHandler?.handleTapGesture(gesture)
      }

      @objc func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
          // Implement your rotation gesture handling logic here
          gestureHandler?.handleRotationGesture(gesture)

      }

      @objc func handleScaleGesture(_ gesture: UIPinchGestureRecognizer) {
          // Implement your scale gesture handling logic here
          gestureHandler?.handleScaleGesture(gesture)

      }

      @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
          // Implement your pan gesture handling logic here
          gestureHandler?.handlePanGesture(gesture)

      }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        gestureHandler?.handleDoubleTap(gesture)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        gestureHandler?.handleLongPress(gesture)
    }
    
//    @objc func handleSwipeGesture(_ gesture : UISwipeGestureRecognizer){
//        gestureHandler?.handleSwipeGesture(gesture)
//    }
  }

extension GestureHandlerView : UIGestureRecognizerDelegate {
    // to get simultaneous touch of all gesture
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       
        return true
    }
   
    
 
    
    
}
