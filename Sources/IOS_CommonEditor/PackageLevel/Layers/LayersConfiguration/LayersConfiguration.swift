//
//  LayersConfiguration.swift
//  FlyerDemo
//
//  Created by HKBeast on 05/11/25.
//

import Foundation
import SwiftUI
import UIKit

public protocol LayersConfiguration{
    var accentColorSwiftUI: Color { get }
    var accentColorUIKit: UIColor { get }
    func removeOrDismissViewController(_ childViewController: UIViewController)
}
