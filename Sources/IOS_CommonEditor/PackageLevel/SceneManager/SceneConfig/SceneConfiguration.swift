//
//  SceneConfiguration.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation
import UIKit

public protocol SceneConfiguration {
    var accentColor: UIColor { get }
    var contentScaleFactor: CGFloat { get set }
}
