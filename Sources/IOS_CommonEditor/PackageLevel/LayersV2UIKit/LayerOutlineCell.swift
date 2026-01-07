//
//  LayerOutlineCell.swift
//  IOS_CommonEditor
//

import UIKit

final class LayerOutlineCell: UICollectionViewListCell {
    var onToggleExpand: (() -> Void)?
    var onSelectTick: (() -> Void)?
    var onToggleLock: (() -> Void)?

    private let expandButton = UIButton(type: .system)
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trailingStack = UIStackView()
    private let rootStack = UIStackView()
    private var leadingConstraint: NSLayoutConstraint?
    private let colorDot = UIView()
    private let dragHandle = UIImageView(image: UIImage(systemName: "line.horizontal.3"))
    private let selectButton = UIButton(type: .system)
    private var expandWidthConstraint: NSLayoutConstraint?
    private var thumbLeadingConstraint: NSLayoutConstraint?

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
        expandWidthConstraint = expandButton.widthAnchor.constraint(equalToConstant: 20)
        expandWidthConstraint?.isActive = true

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

        selectButton.setImage(UIImage(systemName: "circle"), for: .normal)
        selectButton.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
        selectButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 32).isActive = true

        let lockButton = makeTrailingButton(systemName: "lock.fill", action: #selector(lockTapped))

        trailingStack.axis = .horizontal
        trailingStack.spacing = 8
        trailingStack.addArrangedSubview(dragHandle)
        trailingStack.addArrangedSubview(selectButton)
        trailingStack.addArrangedSubview(lockButton)

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
        // Extra thumb shift parity: we adjust the thumb's leading when expand is hidden.
        thumbLeadingConstraint = thumbImageView.leadingAnchor.constraint(equalTo: expandButton.trailingAnchor, constant: 5)
        thumbLeadingConstraint?.isActive = true
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
                   onSelectTick: (() -> Void)?,
                   onToggleLock: (() -> Void)?) {
        self.onToggleExpand = onToggleExpand
        self.onSelectTick = onSelectTick
        self.onToggleLock = onToggleLock

        titleLabel.text = "#\(node.id) \(node.type)"
        subtitleLabel.text = node.softDelete ? "Deleted" : "Order \(node.orderInParent)"
        titleLabel.textColor = node.softDelete ? .secondaryLabel : .label
        subtitleLabel.textColor = node.softDelete ? .tertiaryLabel : .secondaryLabel
        contentView.layer.borderWidth = node.isSelected ? 1.0 : 0.6
        contentView.layer.borderColor = (node.isSelected ? UIColor.tintColor : UIColor.separator.withAlphaComponent(0.4)).cgColor
        contentView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(node.softDelete ? 0.4 : 0.7)
        selectButton.setImage(UIImage(systemName: node.isSelected ? "checkmark.circle.fill" : "circle"), for: .normal)
        selectButton.tintColor = node.isSelected ? .systemBlue : .secondaryLabel

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
        if node.isLocked {
            expandButton.isHidden = true
            expandWidthConstraint?.constant = 0
        } else {
            expandWidthConstraint?.constant = (node.type == .Page || node.type == .Parent) ? 20 : 0
        }
        // Legacy: non-parents shift thumbnail left by removing spacing after expand button.
        if node.type == .Page || node.type == .Parent {
            rootStack.setCustomSpacing(8, after: expandButton)
            thumbLeadingConstraint?.constant = 5
        } else {
            rootStack.setCustomSpacing(0, after: expandButton)
            // Legacy uses a negative shift when no expand button.
            thumbLeadingConstraint?.constant = -40
        }
        leadingConstraint?.constant = 12 + CGFloat(node.depth) * 16
        colorDot.backgroundColor = color(for: node)
        // Button colors and states
        trailingStack.arrangedSubviews.forEach { $0.isHidden = false }
        trailingStack.arrangedSubviews.compactMap { $0 as? UIButton }.forEach { btn in
            btn.tintColor = node.softDelete ? .tertiaryLabel : .secondaryLabel
            btn.isEnabled = !node.softDelete
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
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }

    @objc private func expandTapped() {
        onToggleExpand?()
    }

    @objc private func selectTapped() {
        onSelectTick?()
    }

    @objc private func lockTapped() {
        onToggleLock?()
    }

}
