//
//  ViewManagerConfiguration.swift
//  FlyerDemo
//
//  Created by HKBeast on 04/11/25.
//

import Foundation
import SwiftUI
import UIKit

public protocol ViewManagerConfiguration {
    var isPremium: Bool { get }
    var accentColorSwiftUI: Color { get }
    var accentColorUIKit: UIColor { get }
    var TextDragHandlefillColor: UIColor { get }
    var TextDragHandleStrokeColor: UIColor { get }
}
