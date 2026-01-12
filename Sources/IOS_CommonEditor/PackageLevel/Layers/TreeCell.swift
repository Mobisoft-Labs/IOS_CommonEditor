//
//  TreeCell.swift
//  Tree
//
//  Created by IRIS STUDIO IOS on 30/12/23.
//

import UIKit
import Combine
import SwiftUI

protocol LayerCellDelegate: AnyObject {
    func didTapExpandCollapseButton(cell: LayerCell)
    func didTapLockButton(cell: LayerCell)
    func didTapHiddenButton(cell: LayerCell)
    func didTapSelectButton(cell: LayerCell)
}

class LayerCell: UICollectionViewCell {
    private lazy var indentationViewWidthConstraint: NSLayoutConstraint = {
        return indentationView.widthAnchor.constraint(equalToConstant: 0)
    }()
    private var chipHeightConstraint: NSLayoutConstraint?
    private var expandCollapseWidthConstraint: NSLayoutConstraint?
    private var blurLeadingFromExpandConstraint: NSLayoutConstraint?
    private var blurLeadingFromContainerConstraint: NSLayoutConstraint?
    private var thumbImageLeadingConstraint: NSLayoutConstraint?
    
    weak var delegate: LayerCellDelegate?
    var node : BaseModel!
    private var currentDesignSystem: LayersDesignSystem?
    private var childCancellables = Set<AnyCancellable>()
    
//    private var thumbImageWidthConstant: CGFloat = 40
    private var displayViewWidthConstraint: NSLayoutConstraint?
    
    let expandCollapseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let indentationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let guideLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let guideTickView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        return view
    }()

    let lockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "lock.open"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//    let thumbImage: UIView = {
//        let button = UIView(frame: .zero)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let thumbnailContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

//    lazy var displayView : DisplayView = {
//        var displayView = DisplayView(frame: self.frame)
//        displayView.backgroundColor = .red
//        displayView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return displayView
//    }()
    
    lazy var thumbImageView: UIImageView = {
        var thumbImageView = UIImageView(frame: .zero)
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return thumbImageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private let chipView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let chipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "GROUP"
        return label
    }()

    private let selectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let draggableIndicator: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupViews()
        
       
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    private func setupViews() {
        contentView.isUserInteractionEnabled = true
        blurView.isUserInteractionEnabled = true
        expandCollapseButton.isUserInteractionEnabled = true
        contentView.addSubview(indentationView)
        indentationView.addSubview(guideLineView)
        indentationView.addSubview(guideTickView)
        contentView.addSubview(expandCollapseButton)
        contentView.addSubview(blurView)
        blurView.addSubview(thumbnailContainer)
        thumbnailContainer.addSubview(thumbImageView)
        blurView.addSubview(chipView)
        chipView.addSubview(chipLabel)
        blurView.addSubview(titleLabel)
        blurView.addSubview(subtitleLabel)
        blurView.addSubview(lockButton)
        blurView.addSubview(selectionButton)
        blurView.addSubview(draggableIndicator)
        
        expandCollapseButton.addTarget(self, action: #selector(expandCollapseButtonTapped), for: .touchUpInside)
        lockButton.addTarget(self, action: #selector(lockButtonTapped), for: .touchUpInside)
        selectionButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)


        NSLayoutConstraint.activate([
            
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            indentationView.topAnchor.constraint(equalTo: contentView.topAnchor),
            indentationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            indentationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            guideLineView.trailingAnchor.constraint(equalTo: indentationView.trailingAnchor, constant: -10),
            guideLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            guideLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            guideLineView.widthAnchor.constraint(equalToConstant: 2),

            guideTickView.trailingAnchor.constraint(equalTo: guideLineView.leadingAnchor),
            guideTickView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            guideTickView.widthAnchor.constraint(equalToConstant: 10),
            guideTickView.heightAnchor.constraint(equalToConstant: 2),

            expandCollapseButton.leadingAnchor.constraint(equalTo: indentationView.trailingAnchor, constant: 12),
            expandCollapseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            expandCollapseButton.heightAnchor.constraint(equalToConstant: 36),

            thumbnailContainer.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 12),
            thumbnailContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailContainer.widthAnchor.constraint(equalToConstant: 56),
            thumbnailContainer.heightAnchor.constraint(equalToConstant: 56),

            thumbImageView.centerXAnchor.constraint(equalTo: thumbnailContainer.centerXAnchor),
            thumbImageView.centerYAnchor.constraint(equalTo: thumbnailContainer.centerYAnchor),
            thumbImageView.widthAnchor.constraint(equalTo: thumbnailContainer.widthAnchor, constant: -12),
            thumbImageView.heightAnchor.constraint(equalTo: thumbnailContainer.heightAnchor, constant: -12),

            chipView.leadingAnchor.constraint(equalTo: thumbnailContainer.trailingAnchor, constant: 10),
            chipView.topAnchor.constraint(equalTo: thumbnailContainer.topAnchor, constant: 2),

            chipLabel.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 8),
            chipLabel.centerYAnchor.constraint(equalTo: chipView.centerYAnchor),
            chipView.trailingAnchor.constraint(equalTo: chipLabel.trailingAnchor, constant: 8),

            titleLabel.leadingAnchor.constraint(equalTo: thumbnailContainer.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: chipView.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: lockButton.leadingAnchor, constant: -12),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: lockButton.leadingAnchor, constant: -12),

            lockButton.trailingAnchor.constraint(equalTo: selectionButton.leadingAnchor, constant: -8),
            lockButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lockButton.widthAnchor.constraint(equalToConstant: 26),
            lockButton.heightAnchor.constraint(equalToConstant: 26),

            selectionButton.trailingAnchor.constraint(equalTo: draggableIndicator.leadingAnchor, constant: -8),
            selectionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionButton.widthAnchor.constraint(equalToConstant: 28),
            selectionButton.heightAnchor.constraint(equalToConstant: 28),

            draggableIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            draggableIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            draggableIndicator.widthAnchor.constraint(equalToConstant: 26),
            draggableIndicator.heightAnchor.constraint(equalToConstant: 26)
                   
               ])
        blurLeadingFromExpandConstraint = blurView.leadingAnchor.constraint(equalTo: expandCollapseButton.trailingAnchor, constant: 8)
        blurLeadingFromContainerConstraint = blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        blurLeadingFromExpandConstraint?.isActive = true

        chipHeightConstraint = chipView.heightAnchor.constraint(equalToConstant: 18)
        chipHeightConstraint?.isActive = true

        expandCollapseWidthConstraint = expandCollapseButton.widthAnchor.constraint(equalToConstant: 36)
        expandCollapseWidthConstraint?.isActive = true

//                indentationViewWidthConstraint.isActive = true
        indentationViewWidthConstraint.isActive = true
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.clear.cgColor
        
    }

    func updateConstraints1(node: BaseModel) {
        indentationViewWidthConstraint.constant = 0
        guideLineView.isHidden = true
        guideTickView.isHidden = true
        layoutIfNeeded()
    }

    func lockToggle(isLocked:Bool) {
        lockButton.setImage(UIImage(systemName: isLocked ? "lock.fill" : "lock.open"), for: .normal)
    }
    
    func hiddenToggle() {
       // hiddenButton.image(UIImage(systemName: node.isHidden ? "eye.slash.fill" : "eye"), for: .normal)
    }
    
    
    func toggleExpanded(isEdit:Bool) {
        expandCollapseButton.isHidden = !node.isParent
        
        if node is ParentModel {
            expandCollapseButton.setImage(UIImage(systemName: isEdit ? "chevron.down" : "chevron.right"), for: .normal)
            animateLeadingLayout(showExpand: true, expandWidth: 36)
        }else{
            animateLeadingLayout(showExpand: false, expandWidth: 0)
           
        }
    }
    private func adjustThumbImageLeadingConstraint() {
        guard node is ParentModel else {
             
               expandCollapseButton.isHidden = true
               return
           }

           
       }
    
    func configure(with node: BaseModel) {
        configure(with: node, designSystem: nil)
    }

    func configure(with node: BaseModel, designSystem: LayersDesignSystem?) {
        self.node = node
        if let designSystem {
            currentDesignSystem = designSystem
            applyDesignSystem(designSystem)
        }
        cancellables.removeAll()
        childCancellables.removeAll()
        node.$isLayerAtive.sink(receiveValue: { [weak self] newValue in
            self?.isTapped = newValue
            if newValue{
                
            }else{
//                unSelectedCell()
            }
        }).store(in: &cancellables)
        
       
        
        if let parentNode = node as? ParentModel{
            parentNode.$isExpanded.sink(receiveValue: { [weak self] newValue in
                self?.toggleExpanded(isEdit:newValue)
                
            }).store(in: &cancellables)
            bindParentChildren(parentNode)
        }else{
            toggleExpanded(isEdit:false)

        }
        
        node.$thumbImage.sink { [weak self] newValue in
            
            self?.thumbImageView.image = resizeImage(image: newValue ?? UIImage(named: "none")!, targetSize: CGSize(width: 100, height: 100))
            self?.thumbImageView.contentMode = .scaleAspectFit
        }.store(in: &cancellables)

        node.$lockStatus.sink(receiveValue: { [weak self] newValue in
            self?.lockToggle(isLocked: newValue)
            if let parentNode = node as? ParentModel{
                self?.expandCollapseButton.isHidden = newValue
                self?.animateLeadingLayout(showExpand: !newValue, expandWidth: newValue ? 0 : 36)
            }
        }).store(in: &cancellables)
        
       // lockToggle()
        hiddenToggle()
        //  hiddenButton.isHidden = node.isHidden

        updateConstraints1(node: node)
       

        configureLabels(for: node)
        configureChip(for: node)
        
    }

    private func bindParentChildren(_ parentNode: ParentModel) {
        updateParentSubtitle(parentNode)
        parentNode.$children
            .sink { [weak self] children in
                self?.updateParentSubtitle(parentNode)
                self?.bindChildSoftDelete(children)
            }
            .store(in: &cancellables)
        bindChildSoftDelete(parentNode.children)
    }

    private func bindChildSoftDelete(_ children: [BaseModel]) {
        childCancellables.removeAll()
        for child in children {
            child.$softDelete
                .removeDuplicates()
                .sink { [weak self] _ in
                    guard let self, let parentNode = self.node as? ParentModel else { return }
                    self.updateParentSubtitle(parentNode)
                }
                .store(in: &childCancellables)
        }
    }

    private func updateParentSubtitle(_ parentNode: ParentModel) {
        let childCount = parentNode.activeChildren.count
        subtitleLabel.text = "\(childCount) Elements"
        subtitleLabel.isHidden = false
    }

    private func applyDesignSystem(_ designSystem: LayersDesignSystem) {
        blurView.backgroundColor = designSystem.cardColor
        blurView.layer.borderColor = designSystem.cardBorder.cgColor
        blurView.layer.borderWidth = designSystem.cardBorderWidth
        blurView.layer.cornerRadius = designSystem.cardCornerRadius
        blurView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        blurView.layer.shadowOpacity = 1
        blurView.layer.shadowRadius = 6
        blurView.layer.shadowOffset = CGSize(width: 0, height: 2)
        blurView.layer.masksToBounds = false
        blurView.clipsToBounds = false
        expandCollapseButton.tintColor = designSystem.dragHandleColor
        expandCollapseButton.backgroundColor = designSystem.accentColor.withAlphaComponent(0.15)
        expandCollapseButton.layer.cornerRadius = 18
        expandCollapseButton.clipsToBounds = true
        expandCollapseButton.layer.borderWidth = 1
        expandCollapseButton.layer.borderColor = designSystem.accentColor.withAlphaComponent(0.2).cgColor
        expandCollapseButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        expandCollapseButton.layer.shadowOpacity = 1
        expandCollapseButton.layer.shadowRadius = 4
        expandCollapseButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        expandCollapseButton.layer.masksToBounds = false
        lockButton.tintColor = designSystem.lockTint
        draggableIndicator.tintColor = designSystem.dragHandleColor
        selectionButton.tintColor = designSystem.accentColor
        titleLabel.font = designSystem.titleFont
        titleLabel.textColor = designSystem.primaryText
        subtitleLabel.font = designSystem.subtitleFont
        subtitleLabel.textColor = designSystem.secondaryText
        chipView.backgroundColor = designSystem.chipBackground
        chipView.layer.borderWidth = 1
        chipView.layer.borderColor = designSystem.chipBorder.cgColor
        chipLabel.textColor = designSystem.chipTextColor
        chipLabel.font = designSystem.chipFont
        thumbnailContainer.backgroundColor = designSystem.thumbnailBackground
        thumbnailContainer.layer.borderWidth = 1
        thumbnailContainer.layer.borderColor = designSystem.cardBorder.cgColor
        guideLineView.backgroundColor = designSystem.guideLineColor
        guideTickView.backgroundColor = designSystem.guideLineColor
    }

    private func updateLeadingLayout(showExpand: Bool) {
        blurLeadingFromExpandConstraint?.isActive = showExpand
        blurLeadingFromContainerConstraint?.isActive = !showExpand
        layoutIfNeeded()
    }

    private func animateLeadingLayout(showExpand: Bool, expandWidth: CGFloat) {
        expandCollapseWidthConstraint?.constant = expandWidth
        updateLeadingLayout(showExpand: showExpand)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    private func configureLabels(for node: BaseModel) {
        let isParent = node is ParentModel
        let fallback: String
        switch node.modelType {
        case .Sticker:
            fallback = "STICKER"
        case .Text:
            fallback = "TEXT"
        case .Parent:
            fallback = "GROUP"
        case .Page:
            fallback = "PAGE"
        }
        if isParent {
            let parentName = node.identity.trimmingCharacters(in: .whitespacesAndNewlines)
            let childCount = (node as? ParentModel)?.activeChildren.count ?? 0
            titleLabel.text = nil
            subtitleLabel.text = "\(childCount) Elements"
            subtitleLabel.isHidden = false
            return
        }

        if let textNode = node as? TextInfo {
            let textValue = textNode.text.trimmingCharacters(in: .whitespacesAndNewlines)
            titleLabel.text = nil
            subtitleLabel.text = textValue.isEmpty ? nil : textValue
            subtitleLabel.isHidden = subtitleLabel.text == nil
            return
        }

        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
    }

    private func configureChip(for node: BaseModel) {
        let isParent = node is ParentModel
        chipView.isHidden = false
        chipLabel.isHidden = false
        chipHeightConstraint?.constant = 18
        if let designSystem = currentDesignSystem {
            switch node.modelType {
            case .Parent:
                chipLabel.text = "GROUP"
                chipView.backgroundColor = designSystem.groupChipBackground
                chipLabel.textColor = designSystem.groupChipText
                chipView.layer.borderColor = designSystem.groupChipBorder.cgColor
            case .Sticker:
                chipLabel.text = "STICKER"
                chipView.backgroundColor = designSystem.stickerChipBackground
                chipLabel.textColor = designSystem.stickerChipText
                chipView.layer.borderColor = designSystem.stickerChipBorder.cgColor
            case .Text:
                chipLabel.text = "TEXT"
                chipView.backgroundColor = designSystem.textChipBackground
                chipLabel.textColor = designSystem.textChipText
                chipView.layer.borderColor = designSystem.textChipBorder.cgColor
            case .Page:
                chipLabel.text = "PAGE"
                chipView.backgroundColor = designSystem.chipBackground
                chipLabel.textColor = designSystem.chipTextColor
                chipView.layer.borderColor = designSystem.chipBorder.cgColor
            }
        }
        if !isParent && node.modelType == .Sticker {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
        }
    }

    @objc  func expandCollapseButtonTapped() {
        print("[LayersV1] expand/collapse tapped id=\(node?.modelId ?? -1)")
        delegate?.didTapExpandCollapseButton(cell: self)
    }
    @objc private func lockButtonTapped() {
        
        delegate?.didTapLockButton(cell: self)
    }
    @objc private func hiddenButtonTapped() {
        delegate?.didTapHiddenButton(cell: self)
    }
    
    @objc private func selectButtonTapped() {
        delegate?.didTapSelectButton(cell: self)
    }
    
     var isTapped : Bool =  false{
        didSet {
            guard let designSystem = currentDesignSystem else { return }
            if isTapped {
                blurView.backgroundColor = designSystem.selectedRowBackground
                blurView.layer.borderColor = designSystem.selectedRowBorder.cgColor
                blurView.layer.borderWidth = designSystem.selectionBorderWidth
                selectionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                titleLabel.textColor = designSystem.accentColor
            } else {
                blurView.backgroundColor = designSystem.cardColor
                blurView.layer.borderColor = designSystem.cardBorder.cgColor
                blurView.layer.borderWidth = designSystem.cardBorderWidth
                selectionButton.setImage(UIImage(systemName: "circle"), for: .normal)
                titleLabel.textColor = designSystem.primaryText
            }
        }
    }
}


//extension LayerCell {
//    override var isSelected : Bool {
//        didSet {
//            isTapped = isSelected
//        }
//    }
//}

extension UICollectionViewCell {
    func heartBeat(duration:Double = 0.2 , repeatCount : Float = 1) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")

            animation.values = [1.0, 1.05, 1.0]
            animation.keyTimes = [0, 0.5, 1]
            animation.duration = duration
            animation.repeatCount = repeatCount
            animation.isRemovedOnCompletion = true
            self.layer.add(animation, forKey: "pulse")
        
       
    }
    
    func animateBorder() {
        let animation2 = CAKeyframeAnimation(keyPath: "borderColor")

        animation2.values = [self.layer.borderColor, UIColor.clear.cgColor, self.layer.borderColor]
            animation2.keyTimes = [0, 0.5, 1]
            animation2.duration = 0.2
            animation2.repeatCount = 3
            animation2.isRemovedOnCompletion = true
            self.layer.add(animation2, forKey: "border")
    }
    func unSelectedCell() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }
}

extension UIColor {
    convenience init(_ color: Color) {
        self.init(cgColor: color.cgColor!)
    }
}
