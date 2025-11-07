//
//  TimelineConfiguration.swift
//  FlyerDemo
//
//  Created by HKBeast on 06/11/25.
//

import Foundation
import UIKit

public protocol TimelineConfiguration{
    var collectionViewBGColor: UIColor { get }
    var rulerViewBGColor: UIColor { get }
    var rulerColor: UIColor { get }
    var rulerColor2: UIColor { get }
    var rulerColor3: UIColor { get }
    var timelineBackgroundColor: UIColor { get }
    var rulingParentBGColor: UIColor { get }
    var parentModelColor: UIColor { get }
    var stickerModelColor: UIColor { get }
    var textModelColor: UIColor { get }
    var accentColorMiddleLine: UIColor { get }
    var accentColorToggleButton: UIColor { get }
    var accentColor: UIColor { get }
    func logTimelineScrolled()
    
}
