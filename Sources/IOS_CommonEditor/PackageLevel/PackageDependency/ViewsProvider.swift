//
//  ViewsProvider.swift
//  FlyerDemo
//
//  Created by HKBeast on 04/11/25.
//

import Foundation
import SwiftUI
import SwiftUI

struct ControlBarEntry {
    let id: Int
    let controller: UIHostingController<AnyView>
}

public protocol EditControlBarProtocol: View {}
public protocol MuteControlProtocol: View {}

protocol EditControlBarProvider {
    associatedtype ControlBarView: View
    func makeEditControlBar(for model: ParentInfo, id: Int) -> ControlBarView
}

public class AnyEditControlBarProvider {
    private let _makeEditControlBar: (ParentInfo, Int) -> AnyView
    
    init<P: EditControlBarProvider>(_ provider: P) {
        _makeEditControlBar = { model, id in
            AnyView(provider.makeEditControlBar(for: model, id: id))
        }
    }
    
    func makeEditControlBar(for model: ParentInfo, id: Int) -> AnyView {
        _makeEditControlBar(model, id)
    }
}

public protocol EasyToolBarProvider {
    associatedtype ToolBarView: View
    func makeEasyToolBar() -> ToolBarView
}

public final class AnyEasyToolBarProvider {
    private let _makeEasyToolBar: () -> AnyView
    
    public init<P: EasyToolBarProvider>(_ provider: P) {
        _makeEasyToolBar = {
            AnyView(provider.makeEasyToolBar())
        }
    }
    
    public func makeEasyToolBar() -> AnyView {
        _makeEasyToolBar()
    }
}
