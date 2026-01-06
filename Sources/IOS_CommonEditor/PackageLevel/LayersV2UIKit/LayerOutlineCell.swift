//
//  LayerOutlineCell.swift
//  IOS_CommonEditor
//

import UIKit

final class LayerOutlineCell: UICollectionViewListCell {
    func configure(with node: LayerNode) {
        var config = defaultContentConfiguration()
        config.text = "#\(node.id) \(node.type)"
        config.secondaryText = node.softDelete ? "Deleted" : "Order \(node.orderInParent)"
        config.textProperties.color = node.softDelete ? .secondaryLabel : .label
        contentConfiguration = config

        accessories = [.disclosureIndicator(options: .init(isHidden: !node.isExpanded))]
        var trailing: [UICellAccessory] = []
        if node.isLocked, let img = UIImage(systemName: "lock.fill") {
            trailing.append(.customView(configuration: .init(customView: UIImageView(image: img), placement: .trailing(displayed: .always))))
        }
        if node.isHidden, let img = UIImage(systemName: "eye.slash") {
            trailing.append(.customView(configuration: .init(customView: UIImageView(image: img), placement: .trailing(displayed: .always))))
        }
        accessories.append(contentsOf: trailing)
    }
}
