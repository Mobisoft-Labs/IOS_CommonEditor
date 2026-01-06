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
    private let onSelect: ((LayerNode) -> Void)?

    init(reducer: LayerReducer, logger: PackageLogger? = nil, onSelect: ((LayerNode) -> Void)? = nil) {
        self.reducer = reducer
        self.logger = logger
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self, let nodeId = self.dataSource.itemIdentifier(for: indexPath), let node = self.reducer.tree.nodes[nodeId] else { return nil }
            let delete = UIContextualAction(style: .destructive, title: node.softDelete ? "Undelete" : "Delete") { _, _, completion in
                if node.softDelete {
                    self.reducer.undelete(id: node.id)
                } else {
                    self.reducer.delete(id: node.id)
                }
                self.logOrders(parentId: node.parentId, label: "swipe")
                self.applySnapshot()
                completion(true)
            }
            delete.backgroundColor = node.softDelete ? .systemGreen : .systemRed
            return UISwipeActionsConfiguration(actions: [delete])
        }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: layoutConfig))
        collectionView.register(LayerOutlineCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LayerOutlineCell,
                let node = self?.reducer.tree.nodes[itemIdentifier]
            else { return UICollectionViewCell() }
            cell.configure(with: node)
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

    private func logOrders(parentId: Int, label: String) {
        let active = reducer.tree.activeChildren(of: parentId).map { "\($0.id):\($0.orderInParent)" }.joined(separator: ",")
        let all = reducer.tree.allChildren(of: parentId).map { "\($0.id):\($0.orderInParent)\($0.softDelete ? "D" :"DN")" }.joined(separator: ",")
        logger?.printLog("[LayersV2UI] \(label) parent=\(parentId) active[\(active)] all[\(all)]")
    }
}

extension LayerOutlineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath), var node = reducer.tree.nodes[id] else { return }
        // Toggle expansion for parents; otherwise select.
        if reducer.tree.childrenByParent[id] != nil {
            reducer.toggleExpanded(id: id)
        } else {
            reducer.select(id: id)
            onSelect?(node)
        }
        node = reducer.tree.nodes[id] ?? node
        logOrders(parentId: node.parentId, label: "tap")
        applySnapshot()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
}
