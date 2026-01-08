//
//  LayerOutlineDragLogic.swift
//  IOS_CommonEditor
//
//  Isolated hover/drag logic toggles for Layers v2 so behavior can be tuned
//  without touching UI/controller code.
//

import UIKit

public struct LayerOutlineDragLogicConfig {
    /// When true, allows hover auto-expand on parents/pages.
    var autoExpandEnabled: Bool = true
    /// When true, auto-collapses a parent if pointer moves below its row bounds.
    var autoCollapseOnDownwardExit: Bool = false
    /// Top/bottom zone ratios for drop placement.
    var topZoneRatio: CGFloat = 0.33
    var bottomZoneRatio: CGFloat = 0.66
    /// Auto-scroll behavior near edges.
    var autoScrollEnabled: Bool = true
    var autoScrollEdgeInset: CGFloat = 40
    var autoScrollStep: CGFloat = 6
    var autoScrollMaxStep: CGFloat = 16
    var autoScrollInterval: TimeInterval = 0.01
    /// Extra bottom inset to keep the last rows touchable.
    var bottomInset: CGFloat = 120
    /// Legacy: snapshot only moves vertically during auto-scroll.
    var moveSnapshotXDuringAutoScroll: Bool = true
    /// Legacy: hover expand has no delay (0 = immediate).
    var hoverExpandDelay: TimeInterval = 0
}

public enum LayerOutlineDragViewPosition {
    /// Drag view follows the user touch point.
    case userTouch
    /// Drag view center follows the user touch point (default).
    case centerOfDragView
    /// Drag view uses an explicit offset from the user touch.
    case offset(CGPoint)
    /// Drag view uses an explicit origin (top-left) in collection coordinates.
    case origin(CGPoint)
    /// Drag view origin (top-left) is relative to the user touch.
    case originFromTouch(CGPoint)
}

public enum LayerOutlineDragHitTestPosition {
    /// Use the raw user touch point for hit testing.
    case userTouch
    /// Use the drag view's current center for hit testing.
    case dragViewCenter
    /// Use the drag view's current origin (top-left) for hit testing.
    case dragViewOrigin
}

public struct LayerOutlineDragAnimationConfig {
    var liftScale: CGFloat = 1.05
    var liftAlpha: CGFloat = 0.96
    var liftShadowOpacity: Float = 0.25
    var liftShadowRadius: CGFloat = 6
    var liftShadowOffset: CGSize = CGSize(width: 0, height: 4)
    var liftBorderWidth: CGFloat = 1
    var liftBorderColor: CGColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
    var liftDuration: TimeInterval = 0.18
    var liftDamping: CGFloat = 0.6
    var liftVelocity: CGFloat = 0.8

    var dropDuration: TimeInterval = 0.18
    var dropAlpha: CGFloat = 0.98
}

public struct LayerOutlineDragLogic {
    var config: LayerOutlineDragLogicConfig = .init()

    func shouldAutoExpand(nodeType: ContentType, localX: CGFloat, indent: CGFloat) -> Bool {
        config.autoExpandEnabled && (nodeType == .Parent || nodeType == .Page) && localX > indent
    }

    func shouldCollapseForIndent(localX: CGFloat, indent: CGFloat) -> Bool {
        localX < indent
    }

    func shouldCollapseForVerticalExit(localY: CGFloat, height: CGFloat) -> Bool {
        if localY < 0 { return true }
        if localY > height { return config.autoCollapseOnDownwardExit }
        return false
    }

    func dropPlacement(localPoint: CGPoint, height: CGFloat, nodeType: ContentType, indent: CGFloat, localX: CGFloat) -> (intoParent: Bool, insertAbove: Bool) {
        let topZone = height * config.topZoneRatio
        let bottomZone = height * config.bottomZoneRatio
        let inMiddle = localPoint.y >= topZone && localPoint.y <= bottomZone
        let canIntoParent = (nodeType == .Parent || nodeType == .Page) && localX > indent && inMiddle
        if canIntoParent {
            return (true, false)
        }
        let insertAbove = localPoint.y < topZone
        return (false, insertAbove)
    }
}
