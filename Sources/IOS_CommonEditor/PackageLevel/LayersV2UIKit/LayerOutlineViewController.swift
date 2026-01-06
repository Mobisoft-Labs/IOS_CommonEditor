//
//  LayerOutlineViewController.swift
//  IOS_CommonEditor
//

import UIKit

/// A standalone Layers v2 outline powered by LayerReducer. Not wired to existing layers UI yet.
final class LayerOutlineViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    private(set) var reducer: LayerReducer
    private let logger: PackageLogger?
    weak var adapter: LayerOutlineAdapter?
    private let onSelect: ((LayerNode) -> Void)?
    private let onToggleLock: ((Int) -> Void)?
    private let onToggleHide: ((Int) -> Void)?
    private let onDeleteRestore: ((Int, Bool) -> Void)?
    private let onMove: ((Int, Int, Int) -> Void)?
    private let onReorder: ((Int, Int, Int) -> Void)?

    init(
        reducer: LayerReducer,
        logger: PackageLogger? = nil,
        onSelect: ((LayerNode) -> Void)? = nil,
        onToggleLock: ((Int) -> Void)? = nil,
        onToggleHide: ((Int) -> Void)? = nil,
        onDeleteRestore: ((Int, Bool) -> Void)? = nil,
        onMove: ((Int, Int, Int) -> Void)? = nil,
        onReorder: ((Int, Int, Int) -> Void)? = nil
    ) {
        self.reducer = reducer
        self.logger = logger
        self.onSelect = onSelect
        self.onToggleLock = onToggleLock
        self.onToggleHide = onToggleHide
        self.onDeleteRestore = onDeleteRestore
        self.onMove = onMove
        self.onReorder = onReorder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupHeader()
        configureCollectionView()
        configureDataSource()
        applySnapshot()
    }

    // MARK: - Public updates

    func reload(with reducer: LayerReducer) {
        self.reducer = reducer
        applySnapshot()
    }

    // MARK: - Private

    private func configureCollectionView() {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        layoutConfig.showsSeparators = true
        layoutConfig.leadingSwipeActionsConfigurationProvider = nil
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self, let nodeId = self.dataSource.itemIdentifier(for: indexPath), let node = self.reducer.tree.nodes[nodeId] else { return nil }

            let delete = UIContextualAction(style: .destructive, title: node.softDelete ? "Undelete" : "Delete") { _, _, completion in
                if node.softDelete {
                    self.reducer.undelete(id: node.id)
                } else {
                    self.reducer.delete(id: node.id)
                }
                self.logOrders(parentId: node.parentId, label: "swipe-delete")
                self.applySnapshot()
                completion(true)
            }
            delete.backgroundColor = node.softDelete ? .systemGreen : .systemRed

            let lock = UIContextualAction(style: .normal, title: node.isLocked ? "Unlock" : "Lock") { _, _, completion in
                self.reducer.toggleLock(id: node.id)
                self.logOrders(parentId: node.parentId, label: "swipe-lock")
                self.applySnapshot()
                completion(true)
            }
            lock.backgroundColor = .systemBlue

            let hide = UIContextualAction(style: .normal, title: node.isHidden ? "Show" : "Hide") { _, _, completion in
                self.reducer.toggleHidden(id: node.id)
                self.logOrders(parentId: node.parentId, label: "swipe-hide")
                self.applySnapshot()
                completion(true)
            }
            hide.backgroundColor = .systemGray

            return UISwipeActionsConfiguration(actions: [delete, lock, hide])
        }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: layoutConfig))
        collectionView.register(LayerOutlineCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
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
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
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
                    self?.toggleExpand(nodeId: node.id)
                },
                onToggleLock: { [weak self] in
                    self?.onToggleLock?(node.id)
                },
                onToggleHide: { [weak self] in
                    self?.onToggleHide?(node.id)
                },
                onDeleteRestore: { [weak self] in
                    self?.onDeleteRestore?(node.id, node.softDelete)
                }
            )
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        snapshot.appendItems(rows.map { $0.id }, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func toggleExpand(nodeId: Int) {
        reducer.toggleExpanded(id: nodeId)
        applySnapshot()
    }

    private func logOrders(parentId: Int, label: String) {
        let active = reducer.tree.activeChildren(of: parentId).map { "\($0.id):\($0.orderInParent)" }.joined(separator: ",")
        let all = reducer.tree.allChildren(of: parentId).map { "\($0.id):\($0.orderInParent)\($0.softDelete ? "D" :"DN")" }.joined(separator: ",")
        logger?.printLog("[LayersV2UI] \(label) parent=\(parentId) active[\(active)] all[\(all)]")
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
        guard let id = dataSource.itemIdentifier(for: indexPath), let node = reducer.tree.nodes[id] else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return nil }
            let lock = UIAction(title: node.isLocked ? "Unlock" : "Lock", image: UIImage(systemName: "lock")) { _ in
                self.reducer.toggleLock(id: id)
                self.applySnapshot()
            }
            let hide = UIAction(title: node.isHidden ? "Show" : "Hide", image: UIImage(systemName: "eye.slash")) { _ in
                self.reducer.toggleHidden(id: id)
                self.applySnapshot()
            }
            let delete = UIAction(title: node.softDelete ? "Undelete" : "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                if node.softDelete {
                    self.reducer.undelete(id: id)
                } else {
                    self.reducer.delete(id: id)
                }
                self.applySnapshot()
            }
            return UIMenu(title: "", children: [lock, hide, delete])
        }
    }
}

// MARK: - Drag & Drop

extension LayerOutlineViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let id = dataSource.itemIdentifier(for: indexPath), let node = reducer.tree.nodes[id], !node.softDelete else { return [] }
        let itemProvider = NSItemProvider(object: "\(id)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = id
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard session.localDragSession != nil else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        guard let indexPath = destinationIndexPath else {
            return UICollectionViewDropProposal(operation: .move)
        }
        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        guard indexPath.item < rows.count else { return UICollectionViewDropProposal(operation: .cancel) }
        let targetNode = rows[indexPath.item]
        if let draggingId = session.localDragSession?.items.first?.localObject as? Int {
            if isDescendant(candidate: targetNode.id, of: draggingId) || targetNode.id == draggingId {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
            if let draggingNode = reducer.tree.nodes[draggingId], draggingNode.isLocked {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard coordinator.session.localDragSession != nil else { return }
        guard let item = coordinator.items.first,
              let sourceId = item.dragItem.localObject as? Int else { return }

        let rows = reducer.tree.flattened(includeSoftDeleted: true)
        guard !rows.isEmpty else { return }

        // Figure out drop target
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: rows.count - 1, section: 0)
        let targetIndex = min(max(0, destinationIndexPath.item), rows.count - 1)
        let targetNode = rows[targetIndex]

        // If dropping on a parent/page, move into it at end; else use its parent.
        let dropIntoParent = (targetNode.type == .Parent || targetNode.type == .Page)
        let parentId: Int
        let targetOrder: Int
        if dropIntoParent {
            parentId = targetNode.id
            targetOrder = reducer.tree.activeChildren(of: parentId).count
        } else {
            parentId = targetNode.parentId
            let active = reducer.tree.activeChildren(of: parentId)
            targetOrder = active.firstIndex(where: { $0.id == targetNode.id }) ?? active.count
        }

        let sourceNode = reducer.tree.nodes[sourceId]
        if sourceNode?.parentId == parentId {
            // Same parent reorder
            reorderWithinParent(parentId: parentId, sourceId: sourceId, targetOrder: targetOrder)
        } else {
            // Move to new parent
            moveToParent(nodeId: sourceId, newParentId: parentId, order: targetOrder)
        }

        // Let the collection view animate the drop.
        let dropIndexPath = IndexPath(item: targetIndex, section: 0)
        coordinator.drop(item.dragItem, toItemAt: dropIndexPath)

        // Refresh from TemplateHandler to reflect committed order
        if let adapter = adapter {
            adapter.refreshFromTemplate()
            reducer = adapter.currentReducer
            applySnapshot()
        }
    }

    private func reorderWithinParent(parentId: Int, sourceId: Int, targetOrder: Int) {
        // Compute current order in active list
        let active = reducer.tree.activeChildren(of: parentId)
        guard let currentIndex = active.firstIndex(where: { $0.id == sourceId }) else { return }
        onReorder?(parentId, currentIndex, targetOrder)
        // Optimistically update local reducer for immediate visual feedback
        reducer.reorderWithinParent(parentId: parentId, fromActiveIndex: currentIndex, toActiveIndex: targetOrder)
        applySnapshot()
    }

    private func moveToParent(nodeId: Int, newParentId: Int, order: Int) {
        onMove?(nodeId, newParentId, order)
        // Optimistic local update
        reducer.moveToParent(id: nodeId, newParentId: newParentId, toActiveIndex: order)
        applySnapshot()
    }

    private func isDescendant(candidate: Int, of potentialParent: Int) -> Bool {
        guard let candidateNode = reducer.tree.nodes[candidate] else { return false }
        var currentParent = candidateNode.parentId
        while let node = reducer.tree.nodes[currentParent] {
            if node.id == potentialParent { return true }
            currentParent = node.parentId
        }
        return false
    }
}
