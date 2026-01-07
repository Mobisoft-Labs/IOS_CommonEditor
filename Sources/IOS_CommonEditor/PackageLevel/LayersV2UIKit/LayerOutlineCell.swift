//
//  LayerOutlineCell.swift
//  IOS_CommonEditor
//

import UIKit

final class LayerOutlineCell: UICollectionViewListCell {
    var onToggleExpand: (() -> Void)?
    var onToggleLock: (() -> Void)?
    var onToggleHide: (() -> Void)?
    var onDeleteRestore: (() -> Void)?

    private let expandButton = UIButton(type: .system)
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trailingStack = UIStackView()
    private let rootStack = UIStackView()
    private var leadingConstraint: NSLayoutConstraint?
    private let colorDot = UIView()
    private let dragHandle = UIImageView(image: UIImage(systemName: "line.horizontal.3"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        
        backgroundConfiguration = .clear()
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        expandButton.tintColor = .tertiaryLabel
        expandButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        expandButton.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
        expandButton.widthAnchor.constraint(equalToConstant: 20).isActive = true

        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        thumbImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        thumbImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        colorDot.translatesAutoresizingMaskIntoConstraints = false
        colorDot.layer.cornerRadius = 5
        colorDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        colorDot.heightAnchor.constraint(equalToConstant: 10).isActive = true

        dragHandle.tintColor = .tertiaryLabel
        dragHandle.widthAnchor.constraint(equalToConstant: 16).isActive = true
        dragHandle.heightAnchor.constraint(equalToConstant: 16).isActive = true

        titleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.font = .preferredFont(forTextStyle: .footnote)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let lockButton = makeTrailingButton(systemName: "lock.fill", action: #selector(lockTapped))
        let hideButton = makeTrailingButton(systemName: "eye.slash", action: #selector(hideTapped))
        let deleteButton = makeTrailingButton(systemName: "trash", action: #selector(deleteTapped))

        trailingStack.axis = .horizontal
        trailingStack.spacing = 8
        trailingStack.addArrangedSubview(dragHandle)
        trailingStack.addArrangedSubview(lockButton)
        trailingStack.addArrangedSubview(hideButton)
        trailingStack.addArrangedSubview(deleteButton)

        rootStack.axis = .horizontal
        rootStack.alignment = .center
        rootStack.spacing = 8
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        rootStack.addArrangedSubview(expandButton)
        rootStack.addArrangedSubview(thumbImageView)
        rootStack.addArrangedSubview(colorDot)
        rootStack.addArrangedSubview(textStack)
        rootStack.addArrangedSubview(trailingStack)

        contentView.addSubview(rootStack)
        leadingConstraint = rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        leadingConstraint?.isActive = true
        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        // Bottom separator for clearer boundaries
        let separator = UIView()
        separator.backgroundColor = UIColor.separator.withAlphaComponent(0.3)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func configure(with node: LayerNode,
                   onToggleExpand: (() -> Void)?,
                   onToggleLock: (() -> Void)?,
                   onToggleHide: (() -> Void)?,
                   onDeleteRestore: (() -> Void)?) {
        self.onToggleExpand = onToggleExpand
        self.onToggleLock = onToggleLock
        self.onToggleHide = onToggleHide
        self.onDeleteRestore = onDeleteRestore

        titleLabel.text = "#\(node.id) \(node.type)"
        subtitleLabel.text = node.softDelete ? "Deleted" : "Order \(node.orderInParent)"
        titleLabel.textColor = node.softDelete ? .secondaryLabel : .label
        subtitleLabel.textColor = node.softDelete ? .tertiaryLabel : .secondaryLabel
        contentView.layer.borderWidth = node.isSelected ? 1.0 : 0.6
        contentView.layer.borderColor = (node.isSelected ? UIColor.tintColor : UIColor.separator.withAlphaComponent(0.4)).cgColor
        contentView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(node.softDelete ? 0.4 : 0.7)

        if let thumb = node.thumbImage {
            thumbImageView.image = thumb
            thumbImageView.contentMode = .scaleAspectFill
        } else {
            thumbImageView.image = icon(for: node)
            thumbImageView.tintColor = node.softDelete ? .secondaryLabel : .label
            thumbImageView.contentMode = .scaleAspectFit
        }

        expandButton.isHidden = !(node.type == .Page || node.type == .Parent)
        expandButton.setImage(UIImage(systemName: node.isExpanded ? "chevron.down" : "chevron.right"), for: .normal)
        expandButton.isEnabled = !node.isLocked
        expandButton.alpha = node.isLocked ? 0.4 : 1.0
        leadingConstraint?.constant = 12 + CGFloat(node.depth) * 16
        colorDot.backgroundColor = color(for: node)
        // Button colors and states
        trailingStack.arrangedSubviews.forEach { $0.isHidden = false }
        trailingStack.arrangedSubviews.compactMap { $0 as? UIButton }.forEach { btn in
            if btn.currentImage == UIImage(systemName: "trash") {
                btn.tintColor = node.softDelete ? .systemGreen : .systemRed
            } else {
                btn.tintColor = node.softDelete ? .tertiaryLabel : .secondaryLabel
                btn.isEnabled = !node.softDelete
            }
        }
        dragHandle.isHidden = false
        dragHandle.alpha = node.softDelete ? 0.3 : 1.0
    }

    private func icon(for node: LayerNode) -> UIImage? {
        switch node.type {
        case .Page: return UIImage(systemName: "doc.richtext")
        case .Parent: return UIImage(systemName: "folder")
        case .Sticker: return UIImage(systemName: "seal")
        case .Text: return UIImage(systemName: "textformat")
        default: return UIImage(systemName: "square.on.square")
        }
    }

    private func color(for node: LayerNode) -> UIColor {
        switch node.type {
        case .Page: return UIColor(named: "PageLayer") ?? .systemBlue
        case .Parent: return UIColor(named: "parentCollapsed") ?? .systemOrange
        case .Sticker: return UIColor(named: "stickerLayer") ?? .systemTeal
        case .Text: return UIColor(named: "textLayer") ?? .systemGreen
        default: return .secondaryLabel
        }
    }

    private func makeTrailingButton(systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .secondaryLabel
        button.addTarget(self, action: action, for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }

    @objc private func expandTapped() {
        onToggleExpand?()
    }

    @objc private func lockTapped() {
        onToggleLock?()
    }

    @objc private func hideTapped() {
        onToggleHide?()
    }

    @objc private func deleteTapped() {
        onDeleteRestore?()
    }
}
