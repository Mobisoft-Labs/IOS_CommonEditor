//
//  middleLineView.swift
//  Gesture
//
//  Created by HKBeast on 15/02/24.
//

import Foundation
import UIKit
import UIKit

class MiddleLineView: UIView {
//    var textToDisplay: String = "Initial Text" {
//        didSet {
//            setNeedsDisplay() // Trigger redraw when text changes
//        }
//    }
    
    var longStick : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear // Set background color to transparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear // Set background color to transparent
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Draw line
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: rect.midX, y: rect.minY))
        linePath.addLine(to: CGPoint(x: rect.midX, y: longStick ? rect.maxY : TimelineConstants.rulerHeight))
        linePath.lineWidth = 1.0
//        ThemeManager.shared.accentColor.set()
        TimelineConstants.accentColorMiddleLine.set()
        linePath.stroke()

    }
}
