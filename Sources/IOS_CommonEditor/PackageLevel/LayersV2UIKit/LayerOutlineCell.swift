//
//  LayerOutlineCell.swift
//  IOS_CommonEditor
//

import UIKit
import Combine

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
    private let lockButton = UIButton(type: .system)
    private var expandWidthConstraint: NSLayoutConstraint?
    private var thumbLeadingConstraint: NSLayoutConstraint?
    private var cancellables = Set<AnyCancellable>()
    private var isParentNode: Bool = false

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

        configureLockButton()

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
                   model: BaseModel,
                   hasVisibleChildren: Bool,
                   onToggleExpand: (() -> Void)?,
                   onSelectTick: (() -> Void)?,
                   onToggleLock: (() -> Void)?) {
        self.onToggleExpand = onToggleExpand
        self.onSelectTick = onSelectTick
        self.onToggleLock = onToggleLock
        cancellables.removeAll()

        titleLabel.text = "#\(model.modelId) \(model.modelType)"
        subtitleLabel.text = model.softDelete ? "Deleted" : "Order \(model.orderInParent)"
        titleLabel.textColor = model.softDelete ? .secondaryLabel : .label
        subtitleLabel.textColor = model.softDelete ? .tertiaryLabel : .secondaryLabel
        let isSelected = model.isLayerAtive
        let isParent = (node.type == .Page || node.type == .Parent) && hasVisibleChildren
        isParentNode = isParent
        let isExpanded = (model as? ParentModel)?.isExpanded ?? false
        updateSelectionUI(isSelected: isSelected)
        updateExpandedUI(isExpanded: isExpanded, isParent: isParent, isSelected: isSelected, isDeleted: model.softDelete, depth: node.depth)

        thumbImageView.image = model.thumbImage ?? icon(for: node)
        thumbImageView.tintColor = model.softDelete ? .secondaryLabel : .label
        thumbImageView.contentMode = model.thumbImage == nil ? .scaleAspectFit : .scaleAspectFill

        expandButton.isHidden = !isParent
        expandButton.setImage(UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right"), for: .normal)
        expandButton.isEnabled = !model.lockStatus
        expandButton.alpha = model.lockStatus ? 0.4 : 1.0
        updateLockIcon(isLocked: model.lockStatus)
        if model.lockStatus {
            expandButton.isHidden = true
            expandWidthConstraint?.constant = 0
        } else {
            expandWidthConstraint?.constant = isParent ? 20 : 0
        }
        // Legacy: non-parents shift thumbnail left by removing spacing after expand button.
        if isParent {
            rootStack.setCustomSpacing(8, after: expandButton)
            thumbLeadingConstraint?.constant = 5
        } else {
            rootStack.setCustomSpacing(0, after: expandButton)
            // Legacy uses a negative shift when no expand button.
            thumbLeadingConstraint?.constant = -40
        }
        leadingConstraint?.constant = 12 + CGFloat(node.depth) * 16
        updateColorDot(model: model, node: node)
        // Button colors and states
        trailingStack.arrangedSubviews.forEach { $0.isHidden = false }
        trailingStack.arrangedSubviews.compactMap { $0 as? UIButton }.forEach { btn in
            btn.tintColor = model.softDelete ? .tertiaryLabel : .secondaryLabel
            btn.isEnabled = !model.softDelete
        }
        dragHandle.isHidden = false
        dragHandle.alpha = model.softDelete ? 0.3 : 1.0

        bind(model: model, node: node, isParent: isParent)
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

    private func bind(model: BaseModel, node: LayerNode, isParent: Bool) {
        model.$isLayerAtive
            .receive(on: RunLoop.main)
            .sink { [weak self] isSelected in
                self?.updateSelectionUI(isSelected: isSelected)
                let isExpanded = (model as? ParentModel)?.isExpanded ?? false
                self?.updateExpandedUI(isExpanded: isExpanded, isParent: isParent, isSelected: isSelected, isDeleted: model.softDelete, depth: node.depth)
            }
            .store(in: &cancellables)

        model.$lockStatus
            .receive(on: RunLoop.main)
            .sink { [weak self] isLocked in
                guard let self else { return }
                self.expandButton.isEnabled = !isLocked
                self.expandButton.alpha = isLocked ? 0.4 : 1.0
                self.updateLockIcon(isLocked: isLocked)
                if isLocked {
                    self.expandButton.isHidden = true
                    self.expandWidthConstraint?.constant = 0
                } else {
                    self.expandButton.isHidden = !self.isParentNode
                    self.expandWidthConstraint?.constant = self.isParentNode ? 20 : 0
                }
            }
            .store(in: &cancellables)

        model.$thumbImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                guard let self else { return }
                self.thumbImageView.image = image ?? self.icon(for: node)
                self.thumbImageView.contentMode = image == nil ? .scaleAspectFit : .scaleAspectFill
            }
            .store(in: &cancellables)

        if let parent = model as? ParentModel {
            parent.$isExpanded
                .receive(on: RunLoop.main)
                .sink { [weak self] expanded in
                    self?.expandButton.setImage(UIImage(systemName: expanded ? "chevron.down" : "chevron.right"), for: .normal)
                    if let self {
                        self.updateColorDot(model: model, node: node)
                        self.updateExpandedUI(isExpanded: expanded, isParent: isParent, isSelected: model.isLayerAtive, isDeleted: model.softDelete, depth: node.depth)
                    }
                }
                .store(in: &cancellables)
        }
    }

    private func updateSelectionUI(isSelected: Bool) {
        contentView.layer.borderWidth = isSelected ? 1.0 : 0.6
        contentView.layer.borderColor = (isSelected ? UIColor.tintColor : UIColor.separator.withAlphaComponent(0.4)).cgColor
        selectButton.setImage(UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle"), for: .normal)
        selectButton.tintColor = isSelected ? .systemBlue : .secondaryLabel
    }

    private func configureLockButton() {
        lockButton.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        lockButton.imageView?.contentMode = .scaleAspectFit
        lockButton.tintColor = .secondaryLabel
        lockButton.addTarget(self, action: #selector(lockTapped), for: .touchUpInside)
        lockButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        lockButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    private func updateLockIcon(isLocked: Bool) {
        let name = isLocked ? "lock.fill" : "lock.open"
        lockButton.setImage(UIImage(systemName: name), for: .normal)
    }

    private func updateColorDot(model: BaseModel, node: LayerNode) {
        if let parent = model as? ParentModel {
            let colorName = parent.isExpanded ? "parentExpanded" : "parentCollapsed"
            colorDot.backgroundColor = UIColor(named: colorName) ?? .systemOrange
        } else {
            colorDot.backgroundColor = color(for: node)
        }
    }

    private func updateExpandedUI(isExpanded: Bool, isParent: Bool, isSelected: Bool, isDeleted: Bool, depth: Int) {
        if isDeleted {
            contentView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.4)
            return
        }
        if isSelected {
            contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.18)
            return
        }
        if isParent && isExpanded {
            let cappedDepth = min(max(depth, 0), 4)
            let base: CGFloat = 0.08
            let step: CGFloat = 0.02
            let alpha = base + (CGFloat(cappedDepth) * step)
            contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(alpha)
        } else {
            contentView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.7)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

}
