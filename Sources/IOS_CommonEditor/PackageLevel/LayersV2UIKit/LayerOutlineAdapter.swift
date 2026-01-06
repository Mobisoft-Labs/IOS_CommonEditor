//
//  LayerOutlineAdapter.swift
//  IOS_CommonEditor
//
//  Factory for the Layers v2 outline UI. Keeps integration behind a flag.
//

import UIKit

public struct LayersV2Feature {
    /// Toggle to turn on the new Layers v2 outline. Defaults to off to avoid impacting existing UI.
    public static var isEnabled: Bool = true
}

public final class LayerOutlineAdapter {
    private let templateHandler: TemplateHandler
    private let logger: PackageLogger?
    private var reducer: LayerReducer
    private var controller: LayerOutlineViewController

    public init?(templateHandler: TemplateHandler, logger: PackageLogger? = nil) {
        guard let page = templateHandler.currentPageModel else { return nil }
        let tree = LayerTreeBuilder.build(from: page)
        self.reducer = LayerReducer(tree: tree)
        self.templateHandler = templateHandler
        self.logger = logger
        self.controller = LayerOutlineViewController(reducer: reducer, logger: logger, onSelect: { node in
            templateHandler.deepSetCurrentModel(id: node.id)
        })
    }

    /// Returns the view controller for presentation or embedding.
    public func viewController() -> UIViewController {
        controller
    }

    /// Refresh the outline from the current TemplateHandler tree (call after external mutations).
    public func refreshFromTemplate() {
        guard let page = templateHandler.currentPageModel else { return }
        let tree = LayerTreeBuilder.build(from: page)
        reducer = LayerReducer(tree: tree)
        controller.reload(with: reducer)
    }

    /// Apply a reorder/move/delete/undelete request and refresh UI.
    public func apply(_ block: (inout LayerReducer) -> Void) {
        block(&reducer)
        controller.reload(with: reducer)
    }
}
