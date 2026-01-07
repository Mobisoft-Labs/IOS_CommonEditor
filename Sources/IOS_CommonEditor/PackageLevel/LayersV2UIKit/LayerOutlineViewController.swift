//
//  LayerOutlineViewController.swift
//  IOS_CommonEditor
//

import UIKit

/// A standalone Layers v2 outline powered by LayerReducer. Not wired to existing layers UI yet.
 class LayerOutlineViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    private(set) var reducer: LayerReducer
    private let logger: PackageLogger?
    weak var adapter: LayerOutlineAdapter?
    private let onSelect: ((LayerNode) -> Void)?
    private let onToggleLock: ((Int) -> Void)?
    private let onToggleHide: ((Int) -> Void)?
    private let onDeleteRestore: ((Int, Bool) -> Void)?
    private let onMove: ((Int, Int, Int, Int, Bool) -> Void)?
    private let onReorder: ((Int, Int, Int) -> Void)?
    private let onClose: (() -> Void)?
    private var hoverExpandTimer: Timer?
    private var hoverPendingParentId: Int?
    private var hoverAutoExpandedParents: Set<Int> = []
    private var dragSnapshot: UIView?
    private var dragSourceIndexPath: IndexPath?
    private var dragSourceId: Int?
    private var dragTouchOffset: CGPoint = .zero
    private var dropIndicator = UIView()
    private var dragTargetIndexPath: IndexPath?
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    private var dragLogic = LayerOutlineDragLogic()
    private var dragAnimationConfig = LayerOutlineDragAnimationConfig()
    private var dragViewPosition: LayerOutlineDragViewPosition = .centerOfDragView
    private var dragHitTestPosition: LayerOutlineDragHitTestPosition = .userTouch
    private var autoScrollTimer: Timer?
    private var autoScrollDeltaY: CGFloat = 0
    private var autoScrollDeltaX: CGFloat = 0
    private var dropHereView = UIView()
    private var dropHereLabel = UILabel()
    private var longPressGesture: UILongPressGestureRecognizer?
    private var dragPanGesture: UIPanGestureRecognizer?
    private var isScrollingVertically = true
    private var isScrollingHorizontally = true
    private var lockedOffsetX: CGFloat = 0
    private var lockedOffsetY: CGFloat = 0
    private enum ScrollAxis {
        case none
        case vertical
        case horizontal
    }
    private var currentScrollAxis: ScrollAxis = .none

    init(
        reducer: LayerReducer,
        logger: PackageLogger? = nil,
        dragLogicConfig: LayerOutlineDragLogicConfig = .init(),
        dragAnimationConfig: LayerOutlineDragAnimationConfig = .init(),
        dragViewPosition: LayerOutlineDragViewPosition = .centerOfDragView,
        dragHitTestPosition: LayerOutlineDragHitTestPosition = .userTouch,
        onSelect: ((LayerNode) -> Void)? = nil,
        onToggleLock: ((Int) -> Void)? = nil,
        onToggleHide: ((Int) -> Void)? = nil,
        onDeleteRestore: ((Int, Bool) -> Void)? = nil,
        onMove: ((Int, Int, Int, Int, Bool) -> Void)? = nil,
        onReorder: ((Int, Int, Int) -> Void)? = nil,
        onClose: (() -> Void)? = nil
    ) {
        self.reducer = reducer
        self.logger = logger
        self.dragLogic = LayerOutlineDragLogic(config: dragLogicConfig)
        self.dragAnimationConfig = dragAnimationConfig
        self.dragViewPosition = dragViewPosition
        self.dragHitTestPosition = dragHitTestPosition
        self.onSelect = onSelect
        self.onToggleLock = onToggleLock
        self.onToggleHide = onToggleHide
        self.onDeleteRestore = onDeleteRestore
        self.onMove = onMove
        self.onReorder = onReorder
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        setupHeader()
        configureCollectionView()
        configureDataSource()
        applySnapshot()
    }

    // MARK: - Public updates

    func reload(with reducer: LayerReducer) {
        self.reducer = reducer
        guard isViewLoaded else { return }
        applySnapshot()
    }

    func refreshSnapshot() {
        guard isViewLoaded else { return }
        applySnapshot()
    }

    func reconfigureItems(_ ids: [Int]) {
        guard isViewLoaded, dataSource != nil else { return }
        var snapshot = dataSource.snapshot()
        let existing = Set(snapshot.itemIdentifiers)
        let safeIds = ids.filter { existing.contains($0) }
        guard !safeIds.isEmpty else { return }
        snapshot.reconfigureItems(safeIds)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func updateDragLogic(config: LayerOutlineDragLogicConfig) {
        dragLogic = LayerOutlineDragLogic(config: config)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: dragLogic.config.bottomInset, right: 0)
    }

    func updateDragPresentation(animation: LayerOutlineDragAnimationConfig, position: LayerOutlineDragViewPosition) {
        dragAnimationConfig = animation
        dragViewPosition = position
    }

    func updateDragPresentation(animation: LayerOutlineDragAnimationConfig,
                                position: LayerOutlineDragViewPosition,
                                hitTestPosition: LayerOutlineDragHitTestPosition) {
        dragAnimationConfig = animation
        dragViewPosition = position
        dragHitTestPosition = hitTestPosition
    }

    // MARK: - Private

    private func configureCollectionView() {
        let layout = StackedVerticalFlowLayoutV2()
        layout.stackedDelegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LayerOutlineCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = true
        addDragGestures()

        dropIndicator.backgroundColor = .systemBlue
        dropIndicator.alpha = 0.0
        collectionView.addSubview(dropIndicator)

        dropHereView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        dropHereView.layer.cornerRadius = 6
        dropHereView.alpha = 0.0
        dropHereView.isUserInteractionEnabled = false
        dropHereLabel.text = "Drop Here"
        dropHereLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        dropHereLabel.textColor = .systemBlue
        dropHereLabel.translatesAutoresizingMaskIntoConstraints = false
        dropHereView.addSubview(dropHereLabel)
        NSLayoutConstraint.activate([
            dropHereLabel.centerXAnchor.constraint(equalTo: dropHereView.centerXAnchor),
            dropHereLabel.centerYAnchor.constraint(equalTo: dropHereView.centerYAnchor)
        ])
        collectionView.addSubview(dropHereView)

        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.frame.origin.y = 44
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: dragLogic.config.bottomInset, right: 0)
    }

    private func setupHeader() {
        let bar = UIStackView()
        bar.axis = .horizontal
        bar.spacing = 8
        bar.alignment = .center
        bar.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.text = "Layers"
        title.font = .preferredFont(forTextStyle: .headline)
        title.textColor = .label

        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        close.tintColor = .label
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        bar.addArrangedSubview(title)
        bar.addArrangedSubview(UIView())
        bar.addArrangedSubview(close)

        view.addSubview(bar)
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    @objc private func closeTapped() {
        onClose?()
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LayerOutlineCell,
                let self = self,
                let node = self.reducer.tree.nodes[itemIdentifier]
            else { return UICollectionViewCell() }
            cell.configure(
                with: node,
                onToggleExpand: { [weak self] in
                    self?.selectIfNeeded(nodeId: node.id)
                    self?.toggleExpand(nodeId: node.id)
                },
                onSelectTick: { [weak self] in
                    self?.selectIfNeeded(nodeId: node.id)
                    self?.onClose?()
                },
                onToggleLock: { [weak self] in
                    self?.selectIfNeeded(nodeId: node.id)
                    self?.onToggleLock?(node.id)
                }
            )
            return cell
        }
    }

    private func applySnapshot() {
        guard dataSource != nil else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        snapshot.appendItems(rows.map { $0.id }, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func toggleExpand(nodeId: Int) {
        reducer.toggleExpanded(id: nodeId)
        applySnapshot()
    }

    private func selectIfNeeded(nodeId: Int) {
        guard let node = reducer.tree.nodes[nodeId], !node.isSelected else { return }
        reducer.select(id: nodeId)
        if let selected = reducer.tree.nodes[nodeId] {
            onSelect?(selected)
        }
        applySnapshot()
    }

    private func logOrders(parentId: Int, label: String) {
        let active = reducer.tree.activeChildren(of: parentId).map { "\($0.id):\($0.orderInParent)" }.joined(separator: ",")
        let all = reducer.tree.allChildren(of: parentId).map { "\($0.id):\($0.orderInParent)\($0.softDelete ? "D" :"DN")" }.joined(separator: ",")
        logger?.printLog("[LayersV2UI] \(label) parent=\(parentId) active[\(active)] all[\(all)]")
    }
}

extension LayerOutlineViewController: StackedCollectionViewDelegateV2 {
    func flattenedNodes() -> [LayerNode] {
        return reducer.tree.flattened(includeSoftDeleted: true)
    }
}

extension LayerOutlineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath), var node = reducer.tree.nodes[id] else { return }
        // Selection only; expansion handled by accessory button.
        reducer.select(id: id)
        node = reducer.tree.nodes[id] ?? node
        onSelect?(node)
        applySnapshot()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // Disable default long-press context menu; we use custom gestures.
        return nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = scrollView.contentOffset.y
        let horizontalOffset = scrollView.contentOffset.x

        let maxXLimit = max(0, scrollView.contentSize.width - scrollView.bounds.width)
        let maxYLimit = max(0, scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)

        if horizontalOffset > maxXLimit {
            scrollView.setContentOffset(CGPoint(x: maxXLimit, y: scrollView.contentOffset.y), animated: false)
        }
        if horizontalOffset < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: false)
        }
        if verticalOffset < 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: false)
        }
        if verticalOffset > maxYLimit {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: maxYLimit), animated: false)
        }

        if abs(verticalOffset) > abs(horizontalOffset) {
            isScrollingVertically = true
            isScrollingHorizontally = false
        } else if abs(horizontalOffset) > abs(verticalOffset) {
            isScrollingVertically = false
            isScrollingHorizontally = true
        }
        // Axis-dependent lock without bounce
        if isScrollingVertically {
            if currentScrollAxis != .vertical {
                lockedOffsetX = scrollView.contentOffset.x
                currentScrollAxis = .vertical
            }
            if scrollView.contentOffset.x != lockedOffsetX {
                scrollView.contentOffset.x = lockedOffsetX
            }
        } else if isScrollingHorizontally {
            if currentScrollAxis != .horizontal {
                lockedOffsetY = scrollView.contentOffset.y
                currentScrollAxis = .horizontal
            }
            if scrollView.contentOffset.y != lockedOffsetY {
                scrollView.contentOffset.y = lockedOffsetY
            }
        }
    }
}

extension LayerOutlineViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === dragPanGesture {
            return dragSnapshot != nil
        }
        return true
    }
}

// MARK: - Custom Drag (legacy-style)

extension LayerOutlineViewController {
    private func addDragGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.15
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        longPress.delegate = self
        pan.delegate = self
        collectionView.addGestureRecognizer(longPress)
        collectionView.addGestureRecognizer(pan)
        pan.require(toFail: collectionView.panGestureRecognizer)
        longPressGesture = longPress
        dragPanGesture = pan
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)),
                  let id = dataSource.itemIdentifier(for: indexPath),
                  let node = reducer.tree.nodes[id],
                  !node.softDelete else { return }
            log("longPress began id=\(id)")
            feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator?.prepare()
            dragSourceIndexPath = indexPath
            dragSourceId = id
            let touch = gesture.location(in: collectionView)
            if let cell = collectionView.cellForItem(at: indexPath) {
                collectionView.panGestureRecognizer.isEnabled = false
                if node.type == .Parent || node.type == .Page, node.isExpanded {
                    // Legacy: collapse expanded parent before dragging.
                    reducer.toggleExpanded(id: node.id)
                    applySnapshot()
                }
                dragTouchOffset = CGPoint(x: touch.x - cell.center.x, y: touch.y - cell.center.y)
                let snapshot = cell.snapshotView(afterScreenUpdates: false) ?? UIView(frame: cell.frame)
                snapshot.frame = cell.frame
                snapshot.layer.cornerRadius = 6
                snapshot.layer.masksToBounds = true
                snapshot.layer.borderWidth = dragAnimationConfig.liftBorderWidth
                snapshot.layer.borderColor = dragAnimationConfig.liftBorderColor
                snapshot.alpha = 0.9
                snapshot.layer.shadowColor = UIColor.black.cgColor
                snapshot.layer.shadowRadius = dragAnimationConfig.liftShadowRadius
                snapshot.layer.shadowOpacity = dragAnimationConfig.liftShadowOpacity
                snapshot.layer.shadowOffset = dragAnimationConfig.liftShadowOffset
                collectionView.addSubview(snapshot)
                dragSnapshot = snapshot
                UIView.animate(withDuration: dragAnimationConfig.liftDuration,
                               delay: 0,
                               usingSpringWithDamping: dragAnimationConfig.liftDamping,
                               initialSpringVelocity: dragAnimationConfig.liftVelocity,
                               options: [.curveEaseInOut],
                               animations: {
                    snapshot.transform = CGAffineTransform(scaleX: self.dragAnimationConfig.liftScale, y: self.dragAnimationConfig.liftScale)
                    snapshot.alpha = self.dragAnimationConfig.liftAlpha
                })
                feedbackGenerator?.impactOccurred()
                cell.isHidden = true
            }
            collectionView.isScrollEnabled = false
        case .changed:
            updateDragPosition(gesture)
        case .ended, .cancelled, .failed:
            log("longPress end/cancel")
            finishDrag(at: gesture.location(in: collectionView))
        default:
            break
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            updateDragPosition(gesture)
        case .ended, .cancelled, .failed:
            log("pan end/cancel")
            finishDrag(at: gesture.location(in: collectionView))
        default:
            break
        }
    }

    private func updateDragPosition(_ gesture: UIGestureRecognizer) {
        guard let snapshot = dragSnapshot else {
            log("drag update: no snapshot, skipping")
            return
        }
        let touchLocation = gesture.location(in: collectionView)
        let dragCenterPoint = dragCenter(for: touchLocation)
        snapshot.center = dragCenterPoint
        let hitLocation = dragHitTestLocation(touchLocation: touchLocation, dragCenter: dragCenterPoint)
        updateAutoScroll(at: touchLocation)
        
        // Hover expand using point-based indent check
        if let indexPath = collectionView.indexPathForItem(at: hitLocation),
           let nodeId = dataSource.itemIdentifier(for: indexPath),
           let node = reducer.tree.nodes[nodeId] {
            log("drag over id=\(node.id)")
            updateHoverState(location: hitLocation, node: node, indexPath: indexPath)
            showDropIndicator(at: indexPath, location: hitLocation)
        } else {
            log("drag over: no valid indexPath/node, collapsing hover")
            cancelHoverExpand()
            collapseAllAutoExpanded()
            hideDropIndicator()
        }
    }

    private func finishDrag(at location: CGPoint) {
        let dragCenterPoint = dragCenter(for: location)
        let hitLocation = dragHitTestLocation(touchLocation: location, dragCenter: dragCenterPoint)
        guard let sourceId = dragSourceId,
              let sourceNode = reducer.tree.nodes[sourceId] else {
            log("finishDrag: missing source, abort")
            cleanupDrag()
            return
        }

        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        guard !rows.isEmpty else {
            log("finishDrag: no rows, abort")
            cleanupDrag()
            return
        }

        let targetInfo = dropTarget(at: hitLocation)
        guard let target = targetInfo.node else {
            log("finishDrag: no target, abort")
            cleanupDrag()
            return
        }
        if target.id == sourceId {
            log("finishDrag: drop on self, cancel")
            cleanupDrag()
            return
        }

        let parentId: Int
        let targetOrder: Int
        let dropIntoParent = targetInfo.intoParent

        if dropIntoParent {
            parentId = target.id
            targetOrder = reducer.tree.activeChildren(of: parentId).count
        } else {
            parentId = target.parentId
            let active = reducer.tree.activeChildren(of: parentId)
            let targetIndex = active.firstIndex(where: { $0.id == target.id }) ?? active.count
            targetOrder = targetInfo.insertAbove ? targetIndex : targetIndex + 1
        }

        let sameParent = sourceNode.parentId == parentId
        let currentOrder = reducer.tree.activeChildren(of: sourceNode.parentId).firstIndex(where: { $0.id == sourceId }) ?? 0

        if sameParent && currentOrder == targetOrder {
            log("finishDrag: no-op move, cancel")
            cleanupDrag()
            return
        }

        log("perform drop source=\(sourceId) parent=\(parentId) order=\(targetOrder) sameParent=\(sameParent)")
        dragTargetIndexPath = nil
        onMove?(sourceId, parentId, targetOrder, currentOrder, sameParent)
        adapter?.refreshFromTemplate()
        reducer = adapter?.currentReducer ?? reducer
        // Keep destination parent open in UI.
        if let parent = reducer.tree.nodes[parentId], !parent.isExpanded {
            reducer.toggleExpanded(id: parentId)
        }
        applySnapshot()
        // Scroll back to the moved node so the view doesn’t jump to top.
        let flattened = reducer.tree.flattened(includeSoftDeleted: true)
        if let newIndex = flattened.firstIndex(where: { $0.id == sourceId }) {
            let idx = IndexPath(item: newIndex, section: 0)
            dragTargetIndexPath = idx
            collectionView.scrollToItem(at: idx, at: .centeredVertically, animated: false)
        }
        animateDropIfNeeded()
    }

    private func animateDropIfNeeded() {
        guard let snapshot = dragSnapshot else {
            cleanupDrag()
            return
        }
        guard let targetIndex = dragTargetIndexPath,
              let attrs = collectionView.layoutAttributesForItem(at: targetIndex) else {
            cleanupDrag()
            return
        }
        UIView.animate(withDuration: dragAnimationConfig.dropDuration,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            snapshot.transform = .identity
            snapshot.frame = attrs.frame
            snapshot.alpha = self.dragAnimationConfig.dropAlpha
        }, completion: { _ in
            self.cleanupDrag()
        }
        )
    }

    private func dragCenter(for location: CGPoint) -> CGPoint {
        switch dragViewPosition {
        case .userTouch:
            return location
        case .centerOfDragView:
            return CGPoint(x: location.x - dragTouchOffset.x, y: location.y - dragTouchOffset.y)
        case .offset(let offset):
            return CGPoint(x: location.x + offset.x, y: location.y + offset.y)
        case .origin(let origin):
            if let snapshot = dragSnapshot {
                return CGPoint(x: origin.x + snapshot.bounds.width / 2, y: origin.y + snapshot.bounds.height / 2)
            }
            return origin
        case .originFromTouch(let originOffset):
            if let snapshot = dragSnapshot {
                let origin = CGPoint(x: location.x + originOffset.x, y: location.y + originOffset.y)
                return CGPoint(x: origin.x + snapshot.bounds.width / 2, y: origin.y + snapshot.bounds.height / 2)
            }
            return CGPoint(x: location.x + originOffset.x, y: location.y + originOffset.y)
        }
    }

    private func dragHitTestLocation(touchLocation: CGPoint, dragCenter: CGPoint) -> CGPoint {
        switch dragHitTestPosition {
        case .userTouch:
            return touchLocation
        case .dragViewCenter:
            return dragSnapshot?.center ?? dragCenter
        }
    }

    private func cleanupDrag() {
        dragSnapshot?.removeFromSuperview()
        dragSnapshot = nil
        feedbackGenerator = nil
        dragTargetIndexPath = nil
        stopAutoScroll()
        // Make sure no cells stay hidden after drag completes.
        collectionView.visibleCells.forEach { $0.isHidden = false }
        collectionView.panGestureRecognizer.isEnabled = true
        dragSourceIndexPath = nil
        dragSourceId = nil
        collectionView.isScrollEnabled = true
        hideDropIndicator()
        cancelHoverExpand()
    }

    // MARK: - Debug logging
    private func log(_ message: String) {
        print("[LayersV2UI] \(message)")
        logger?.printLog("[LayersV2UI] \(message)")
    }

    private func dropTarget(at location: CGPoint) -> (node: LayerNode?, intoParent: Bool, insertAbove: Bool) {
        var targetIndexPath = collectionView.indexPathForItem(at: location)
        if targetIndexPath == nil {
            // Legacy: scan upward to find a drop target.
            var y = location.y
            while y > 0 {
                if let idx = collectionView.indexPathForItem(at: CGPoint(x: location.x, y: y)) {
                    targetIndexPath = idx
                    break
                }
                y -= 4
            }
        }
        guard let indexPath = targetIndexPath,
              let nodeId = dataSource.itemIdentifier(for: indexPath),
              let node = reducer.tree.nodes[nodeId],
              let attrs = collectionView.layoutAttributesForItem(at: indexPath) else {
            log("dropTarget: no index/node/attrs")
            return (nil, false, false)
        }
        let localPoint = CGPoint(x: location.x - attrs.frame.minX, y: location.y - attrs.frame.minY)
        let indent = CGFloat(node.depth) * 16.0
        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        let currentIndex = indexPath.item
        let lowerNode = currentIndex + 1 < rows.count ? rows[currentIndex + 1] : nil
        let midY = attrs.frame.height / 2

        // Legacy: if lower cell is deeper and drag is in bottom half, drop into parent.
        if localPoint.y >= midY, let lower = lowerNode, lower.depth > node.depth {
            return (node, true, false)
        }
        // Legacy: empty parent can accept drop into itself when drag is to the right.
        if (node.type == .Parent || node.type == .Page),
           reducer.tree.activeChildren(of: node.id).isEmpty,
           localPoint.y >= midY,
           localPoint.x > 40 {
            return (node, true, false)
        }

        let placement = dragLogic.dropPlacement(localPoint: localPoint,
                                               height: attrs.frame.height,
                                               nodeType: node.type,
                                               indent: indent,
                                               localX: localPoint.x)
        return (node, placement.intoParent, placement.insertAbove)
    }

    private func showDropIndicator(at indexPath: IndexPath, location: CGPoint) {
        guard let attrs = collectionView.layoutAttributesForItem(at: indexPath) else {
            log("showDropIndicator: missing attrs")
            return
        }
        let info = dropTarget(at: location)
        var y = attrs.frame.minY
        var x = attrs.frame.minX
        var width = attrs.frame.width
        if info.intoParent {
            y = attrs.frame.maxY - 4
        } else if info.insertAbove {
            y = attrs.frame.minY
        } else {
            y = attrs.frame.maxY
        }
        // Legacy: if lower depth is less than current, align to parent boundary.
        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        if indexPath.item + 1 < rows.count {
            let current = rows[indexPath.item]
            let lower = rows[indexPath.item + 1]
            if lower.depth < current.depth {
                x = attrs.frame.minX
                width = attrs.frame.width
            }
        }
        dropIndicator.frame = CGRect(x: x, y: y - 1, width: width, height: 2)
        dropIndicator.alpha = 1.0

        let stripHeight: CGFloat = 18
        dropHereView.frame = CGRect(x: x + 8,
                                    y: y - stripHeight / 2,
                                    width: width - 16,
                                    height: stripHeight)
        dropHereView.alpha = 1.0
    }

    private func hideDropIndicator() {
        dropIndicator.alpha = 0.0
        dropHereView.alpha = 0.0
    }

    private func updateAutoScroll(at location: CGPoint) {
        // Determine auto-scroll deltas based on how close the drag is to edges,
        // using an accelerated step toward the edge.
        guard dragLogic.config.autoScrollEnabled else {
            // Auto-scroll disabled via config.
            log("autoScroll disabled")
            stopAutoScroll()
            return
        }
        let inset = dragSnapshot.map { max(dragLogic.config.autoScrollEdgeInset, min($0.frame.width, $0.frame.height) / 4) } ?? dragLogic.config.autoScrollEdgeInset
        let bounds = collectionView.bounds
        var deltaY: CGFloat = 0
        var deltaX: CGFloat = 0
        if location.y < bounds.minY + inset {
            // Near top edge: scroll up.
            let distance = max(0, location.y - bounds.minY)
            let t = max(0, min(1, 1 - (distance / inset)))
            let step = dragLogic.config.autoScrollStep + t * (dragLogic.config.autoScrollMaxStep - dragLogic.config.autoScrollStep)
            deltaY = -step
        } else if location.y > bounds.maxY - inset {
            // Near bottom edge: scroll down.
            let distance = max(0, bounds.maxY - location.y)
            let t = max(0, min(1, 1 - (distance / inset)))
            let step = dragLogic.config.autoScrollStep + t * (dragLogic.config.autoScrollMaxStep - dragLogic.config.autoScrollStep)
            deltaY = step
        }
        if location.x < bounds.minX + inset {
            // Near left edge: scroll left.
            let distance = max(0, location.x - bounds.minX)
            let t = max(0, min(1, 1 - (distance / inset)))
            let step = dragLogic.config.autoScrollStep + t * (dragLogic.config.autoScrollMaxStep - dragLogic.config.autoScrollStep)
            deltaX = -step
        } else if location.x > bounds.maxX - inset {
            // Near right edge: scroll right.
            let distance = max(0, bounds.maxX - location.x)
            let t = max(0, min(1, 1 - (distance / inset)))
            let step = dragLogic.config.autoScrollStep + t * (dragLogic.config.autoScrollMaxStep - dragLogic.config.autoScrollStep)
            deltaX = step
        }
        // If content can't scroll on an axis, ignore its delta.
        let maxOffsetX = max(0, collectionView.contentSize.width - collectionView.bounds.width)
        let maxOffsetY = max(0, collectionView.contentSize.height - collectionView.bounds.height + collectionView.contentInset.bottom)
        if maxOffsetX == 0 { deltaX = 0 }
        if maxOffsetY == 0 { deltaY = 0 }
        if deltaX == 0 && deltaY == 0 {
            // No edge pressure: stop auto-scroll.
            log("autoScroll idle")
            stopAutoScroll()
            return
        }
        if deltaY != autoScrollDeltaY || deltaX != autoScrollDeltaX {
            // Edge pressure changed: restart timer with new deltas.
            autoScrollDeltaY = deltaY
            autoScrollDeltaX = deltaX
            log("autoScroll deltaX=\(String(format: "%.1f", deltaX)) deltaY=\(String(format: "%.1f", deltaY))")
            startAutoScroll()
        }
    }

    private func startAutoScroll() {
        // Scroll the collection view while dragging near edges. If we hit a limit,
        // stop moving on that axis to avoid flicker.
        autoScrollTimer?.invalidate()
        let timer = Timer(timeInterval: dragLogic.config.autoScrollInterval, repeats: true) { [weak self] _ in
            guard let self else { return }
            let maxOffsetX = max(0, self.collectionView.contentSize.width - self.collectionView.bounds.width)
            let maxOffsetY = max(0, self.collectionView.contentSize.height - self.collectionView.bounds.height + self.collectionView.contentInset.bottom)
            let current = self.collectionView.contentOffset
            var appliedDeltaX = self.autoScrollDeltaX
            var appliedDeltaY = self.autoScrollDeltaY
            if (appliedDeltaX > 0 && current.x >= maxOffsetX) || (appliedDeltaX < 0 && current.x <= 0) {
                // Hit horizontal limit: stop moving on X to avoid flicker.
                appliedDeltaX = 0
            }
            if (appliedDeltaY > 0 && current.y >= maxOffsetY) || (appliedDeltaY < 0 && current.y <= 0) {
                // Hit vertical limit: stop moving on Y to avoid flicker.
                appliedDeltaY = 0
            }
            if appliedDeltaX == 0 && appliedDeltaY == 0 {
                // Both axes blocked: stop auto-scroll timer.
                self.stopAutoScroll()
                return
            }
            var offset = current
            offset.x = min(max(0, current.x + appliedDeltaX), maxOffsetX)
            offset.y = min(max(0, current.y + appliedDeltaY), maxOffsetY)
            self.log("autoScroll tick offsetX=\(String(format: "%.1f", offset.x)) offsetY=\(String(format: "%.1f", offset.y))")
            self.collectionView.setContentOffset(offset, animated: false)
            if self.dragLogic.config.moveSnapshotXDuringAutoScroll {
                self.dragSnapshot?.center.x += appliedDeltaX
            }

            // Legacy only moves snapshot on Y during auto-scroll.
            self.dragSnapshot?.center.y += appliedDeltaY
        }
        autoScrollTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func stopAutoScroll() {
        if autoScrollTimer != nil {
            log("autoScroll stop")
        }
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
        autoScrollDeltaY = 0
        autoScrollDeltaX = 0
    }

    // Hover-expand/collapse support for custom drag (single source of truth).
    private func updateHoverState(location: CGPoint, node: LayerNode, indexPath: IndexPath) {
        guard let attrs = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let localX = location.x - attrs.frame.minX
        let localY = location.y - attrs.frame.minY
        let indent = CGFloat(node.depth) * 16.0
        let midX = attrs.frame.width / 2
        let midY = attrs.frame.height / 2

        let selectedAncestors = Set(ancestorIds(of: selectedNodeIdFromTemplate()))
        if selectedAncestors.contains(node.id) {
            // Legacy: skip hover expand/collapse on selected ancestor branch.
            return
        }

        // Collapse any auto-expanded parents that are no longer in the hovered branch.
        let hoverBranch = Set(ancestorIds(of: node.id))
        log("hover branch=\(hoverBranch.sorted()) autoExpanded=\(hoverAutoExpandedParents.sorted()) node=\(node.id) x=\(String(format: "%.1f", localX)) y=\(String(format: "%.1f", localY)) indent=\(String(format: "%.1f", indent))")
        let toCollapse = hoverAutoExpandedParents.subtracting(hoverBranch)
        if !toCollapse.isEmpty {
            log("hover collapse set=\(toCollapse.sorted())")
            toCollapse.forEach { collapseAutoExpanded(parentId: $0) }
        }

        if node.type == .Parent || node.type == .Page {
            if node.isExpanded {
                // Legacy collapse regions: top half OR bottom-left quadrant.
                let inTopHalf = localY >= 0 && localY < midY
                let inBottomLeft = localY >= midY && localY <= attrs.frame.height && localX >= 0 && localX <= midX
                if inTopHalf || inBottomLeft {
                    log("hover collapse: legacy region parent=\(node.id)")
                    collapseAutoExpanded(parentId: node.id)
                }
            } else {
                // Legacy expand region: bottom-right quadrant.
                let inBottomRight = localY >= midY && localY <= attrs.frame.height && localX >= midX && localX <= attrs.frame.width
                if inBottomRight && dragLogic.shouldAutoExpand(nodeType: node.type, localX: localX, indent: indent) {
                    scheduleHoverExpand(parentId: node.id)
                } else {
                    cancelHoverExpand()
                }
            }
        } else {
            cancelHoverExpand()
        }
    }

    private func scheduleHoverExpand(parentId: Int) {
        if hoverAutoExpandedParents.contains(parentId) { return }
        if hoverPendingParentId == parentId { return }
        cancelHoverExpand()
        hoverPendingParentId = parentId
        log("hover expand scheduled parent=\(parentId)")
        if dragLogic.config.hoverExpandDelay <= 0 {
            hoverPendingParentId = nil
            if let currentNode = reducer.tree.nodes[parentId], !currentNode.isExpanded {
                reducer.toggleExpanded(id: parentId)
                hoverAutoExpandedParents.insert(parentId)
                applySnapshot()
                log("hover expand applied parent=\(parentId)")
            }
            return
        }
        hoverExpandTimer = Timer.scheduledTimer(withTimeInterval: dragLogic.config.hoverExpandDelay, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.hoverPendingParentId = nil
            if let currentNode = self.reducer.tree.nodes[parentId], !currentNode.isExpanded {
                self.reducer.toggleExpanded(id: parentId)
                self.hoverAutoExpandedParents.insert(parentId)
                self.applySnapshot()
                self.log("hover expand applied parent=\(parentId)")
            }
        }
    }

    private func cancelHoverExpand() {
        hoverExpandTimer?.invalidate()
        hoverExpandTimer = nil
        hoverPendingParentId = nil
    }

    private func collapseAutoExpanded(parentId: Int) {
        let toCollapse = hoverAutoExpandedParents.filter { $0 == parentId || isDescendant($0, of: parentId) }
        guard !toCollapse.isEmpty else { return }
        for id in toCollapse {
            if let node = reducer.tree.nodes[id], node.isExpanded {
                reducer.toggleExpanded(id: id)
            }
            hoverAutoExpandedParents.remove(id)
        }
        applySnapshot()
    }

    private func collapseAllAutoExpanded() {
        let ids = hoverAutoExpandedParents
        if ids.isEmpty { return }
        for id in ids {
            if let node = reducer.tree.nodes[id], node.isExpanded {
                reducer.toggleExpanded(id: id)
            }
        }
        hoverAutoExpandedParents.removeAll()
        applySnapshot()
    }

    private func isDescendant(_ childId: Int, of ancestorId: Int) -> Bool {
        var current = reducer.tree.nodes[childId]?.parentId
        while let pid = current {
            if pid == ancestorId { return true }
            current = reducer.tree.nodes[pid]?.parentId
        }
        return false
    }

    private func ancestorIds(of nodeId: Int) -> [Int] {
        var ids: [Int] = [nodeId]
        var current = reducer.tree.nodes[nodeId]?.parentId
        while let pid = current {
            ids.append(pid)
            current = reducer.tree.nodes[pid]?.parentId
        }
        return ids
    }

    private func selectedNodeIdFromTemplate() -> Int {
        adapter?.currentModelId() ?? reducer.tree.nodes.values.first(where: { $0.isSelected })?.id ?? -1
    }

    private func logHoverContext(parentId: Int, nodeId: Int, location: CGPoint) {
        // Log hover info relative to parent bounds when available.
        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        if let parentIndex = rows.firstIndex(where: { $0.id == parentId }) {
            let parentIndexPath = IndexPath(item: parentIndex, section: 0)
            if let attrs = collectionView.layoutAttributesForItem(at: parentIndexPath) {
                let localX = location.x - attrs.frame.minX
                let localY = location.y - attrs.frame.minY
                let isDesc = isDescendant(nodeId, of: parentId)
                log("hover parent=\(parentId) node=\(nodeId) desc=\(isDesc) localX=\(String(format: "%.1f", localX)) localY=\(String(format: "%.1f", localY))")
            }
        }
    }
}
