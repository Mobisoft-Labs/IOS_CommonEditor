//
//  StackLayoutV2.swift
//  IOS_CommonEditor
//
//  Lightweight stacked layout for Layers v2. Mirrors the V1 stacked indentation
//  and sizing so we get predictable hit testing and expansion visuals.
//

import UIKit

protocol StackedCollectionViewDelegateV2: AnyObject {
    /// Flattened rows in display order (including soft-deleted items when needed).
    func flattenedNodes() -> [LayerNode]
}

final class StackedVerticalFlowLayoutV2: UICollectionViewFlowLayout {
    weak var stackedDelegate: StackedCollectionViewDelegateV2?

    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    private var cachedContentSize: CGSize = .zero

    override init() {
        super.init()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        sectionInset = .zero
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        sectionInset = .zero
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let width = collectionView.bounds.width
        let rows = stackedDelegate?.flattenedNodes() ?? []

        cachedAttributes.removeAll()
        var y: CGFloat = 0
        var maxIndent: CGFloat = 0

        for index in 0..<rows.count {
            let indexPath = IndexPath(item: index, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let indent = CGFloat(rows[index].depth) * 16.0
            let height: CGFloat = 72
            maxIndent = max(maxIndent, indent)
            // Keep full width; contentSize widens to allow horizontal scroll for deep indents.
            attr.frame = CGRect(x: indent, y: y, width: width, height: height)
            cachedAttributes.append(attr)
            y += height
        }

        cachedContentSize = CGSize(width: width + maxIndent, height: y)
    }

    override var collectionViewContentSize: CGSize {
        cachedContentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cachedAttributes.filter { rect.intersects($0.frame) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributes.first(where: { $0.indexPath == indexPath })
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView?.bounds.size
    }
}
