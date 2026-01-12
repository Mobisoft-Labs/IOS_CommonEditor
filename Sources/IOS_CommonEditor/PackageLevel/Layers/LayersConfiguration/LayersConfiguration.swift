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
    var layersFeedbackSubject: String { get }
    var layersFeedbackUserId: String? { get }
    var layersFeedbackPromptKey: String { get }
    var layersFeedbackYesKey: String { get }
    var layersFeedbackNoKey: String { get }
    var layersFeedbackMinimumLongPressCount: Int { get }
    var layersFeedbackPersistenceKey: String { get }
    var layersFeedbackPersists: Bool { get }
    func submitLayersFeedback(subject: String, response: String, userId: String?)
}
