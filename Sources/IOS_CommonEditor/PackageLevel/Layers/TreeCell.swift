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
}

class LayerCell: UICollectionViewCell {
    private lazy var indentationViewWidthConstraint: NSLayoutConstraint = {
        return indentationView.widthAnchor.constraint(equalToConstant: 0)
    }()
    private var thumbImageLeadingConstraint: NSLayoutConstraint?
    
    weak var delegate: LayerCellDelegate?
    var node : BaseModel!
    
//    private var thumbImageWidthConstant: CGFloat = 40
    private var displayViewWidthConstraint: NSLayoutConstraint?
    
    let expandCollapseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        button.backgroundColor = .darkGray
        button.tintColor = .white//.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let indentationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurView: UIView = {
//        let blurEffect = UIBlurEffect(style: .light)
        let view = UIView()//UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()

    let lockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "unlockLayers"), for: .normal)
//        button.backgroundColor = .systemGray
        button.tintColor = .white//.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//    let thumbImage: UIView = {
//        let button = UIView(frame: .zero)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    lazy var colorView : UIView = {
        var colorView = UIView(frame: .zero)
        colorView.backgroundColor = .red
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        return colorView
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
    
    lazy var dividerView : UIView = {
        var dividerView = UIView(frame: .zero)
        dividerView.backgroundColor = .white//.gray
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        return dividerView
    }()

    private let orderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let draggableIndicator: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
//        button.backgroundColor = .systemGray
        button.tintColor = .white//.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .clear
        self.layer.cornerRadius = 5.0
        setupViews()
        
       
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    private func setupViews() {
        contentView.addSubview(blurView)
        blurView.addSubview(indentationView)
        blurView.addSubview(expandCollapseButton)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(sequenceLabel)
        blurView.addSubview(draggableIndicator)
        blurView.addSubview(thumbImageView)
//        contentView.addSubview(thumbImage)
        blurView.addSubview(lockButton)
//        thumbImage.addSubview(displayView)
        blurView.addSubview(colorView)
        blurView.addSubview(orderLabel)
        blurView.addSubview(dividerView)
        
        expandCollapseButton.addTarget(self, action: #selector(expandCollapseButtonTapped), for: .touchUpInside)
        lockButton.addTarget(self, action: #selector(lockButtonTapped), for: .touchUpInside)
       // thumbImage.addTarget(self, action: #selector(hiddenButtonTapped), for: .touchUpInside)


        NSLayoutConstraint.activate([
            
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            indentationView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                       indentationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                       
                                       expandCollapseButton.leadingAnchor.constraint(equalTo: indentationView.trailingAnchor, constant: 8),
                                       expandCollapseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                       expandCollapseButton.widthAnchor.constraint(equalToConstant: 40),
                                       expandCollapseButton.heightAnchor.constraint(equalToConstant: 40),
                                       
                                       thumbImageView.leadingAnchor.constraint(equalTo: expandCollapseButton.trailingAnchor, constant: 5),
                                       thumbImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                       thumbImageView.widthAnchor.constraint(equalToConstant: 80),
                                       thumbImageView.heightAnchor.constraint(equalToConstant: 40),
                                       
//                                       thumbImage.leadingAnchor.constraint(equalTo: expandCollapseButton.trailingAnchor, constant: 5),
//                                       thumbImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//                                       thumbImage.widthAnchor.constraint(equalToConstant: 40),
//                                       thumbImage.heightAnchor.constraint(equalToConstant: 40),
//                                       
//                                       displayView.centerXAnchor.constraint(equalTo: thumbImage.centerXAnchor),
//                                       displayView.centerYAnchor.constraint(equalTo: thumbImage.centerYAnchor),
////                                       displayView.widthAnchor.constraint(equalToConstant: 40),
//                                       displayView.heightAnchor.constraint(equalToConstant: 40),
                                       
                                       colorView.leadingAnchor.constraint(equalTo: thumbImageView.trailingAnchor, constant: 10),
                                       colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                       colorView.widthAnchor.constraint(equalToConstant: 10),
                                       colorView.heightAnchor.constraint(equalToConstant: 10),
                                       
                                       orderLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 6),
                                       orderLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                       orderLabel.widthAnchor.constraint(equalToConstant: 26),
                                       orderLabel.heightAnchor.constraint(equalToConstant: 16),
                                       
                                       lockButton.trailingAnchor.constraint(equalTo: draggableIndicator.leadingAnchor, constant: -5),
                                        lockButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                        lockButton.widthAnchor.constraint(equalToConstant: 40),
                                        lockButton.heightAnchor.constraint(equalToConstant: 40),
                                       
                                         draggableIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                                        draggableIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                        draggableIndicator.widthAnchor.constraint(equalToConstant: 40),
                                        draggableIndicator.heightAnchor.constraint(equalToConstant: 40),

                                       dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                       dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                                       dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                                       dividerView.widthAnchor.constraint(equalToConstant: self.frame.width),
                                       dividerView.heightAnchor.constraint(equalToConstant: 0.5)
                   
               ])
//        displayViewWidthConstraint = displayView.widthAnchor.constraint(equalToConstant: 40)
//        displayViewWidthConstraint?.isActive = true
        thumbImageLeadingConstraint = thumbImageView.leadingAnchor.constraint(equalTo: expandCollapseButton.trailingAnchor, constant: 5)
                thumbImageLeadingConstraint?.isActive = true

//                indentationViewWidthConstraint.isActive = true
        indentationViewWidthConstraint.isActive = true
        colorView.roundCorners(corners: .allCorners, radius: 5)
        
    }

    func updateConstraints1(node: BaseModel) {
        indentationViewWidthConstraint.constant = 0 //CGFloat(node.depthLevel) * 25.0
        layoutIfNeeded()
    }

    func lockToggle(isLocked:Bool) {
       // lockButton.setImage(node.thumbImage, for: .normal)

        lockButton.setImage(UIImage(named: isLocked ? "lockLayers" : "unlockLayers"), for: .normal)
    }
    
    func hiddenToggle() {
       // hiddenButton.image(UIImage(systemName: node.isHidden ? "eye.slash.fill" : "eye"), for: .normal)
    }
    
    
    func toggleExpanded(isEdit:Bool) {
        expandCollapseButton.isHidden = !node.isParent
        
        if node is ParentModel {
            
            expandCollapseButton.setImage(UIImage(systemName: isEdit ? "chevron.down" : "chevron.right"), for: .normal)
            thumbImageLeadingConstraint?.constant = 5
            thumbImageLeadingConstraint?.isActive = true
            if isEdit{
                colorView.backgroundColor = UIColor(named: "parentExpanded")
            }else{
                colorView.backgroundColor = UIColor(named: "parentCollapsed")
            }
        }else{
            thumbImageLeadingConstraint?.constant = -40
            thumbImageLeadingConstraint?.isActive = true
           
        }
    }
    private func adjustThumbImageLeadingConstraint() {
        guard node is ParentModel else {
             
               expandCollapseButton.isHidden = true
               return
           }

           
       }
    
    func configure(with node: BaseModel) {
        self.node = node
        cancellables.removeAll()
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
        }else{
            toggleExpanded(isEdit:false)

        }
        
        node.$thumbImage.sink { [weak self] newValue in
            
            self?.thumbImageView.image = resizeImage(image: newValue ?? UIImage(named: "none")!, targetSize: CGSize(width: 100, height: 100))
            self?.thumbImageView.contentMode = .scaleAspectFit
        }.store(in: &cancellables)

        orderLabel.text = "\(node.orderInParent)"
        
        node.$lockStatus.sink(receiveValue: { [weak self] newValue in
            self?.lockToggle(isLocked: newValue)
            if let parentNode = node as? ParentModel{
                self?.expandCollapseButton.isHidden = newValue
            }
        }).store(in: &cancellables)
        
       // lockToggle()
        hiddenToggle()
        //  hiddenButton.isHidden = node.isHidden

        updateConstraints1(node: node)
       

        if node.modelType == .Parent{
            
            colorView.backgroundColor = UIColor(named: "parentCollapsed")
        }else if node.modelType == .Sticker{
            colorView.backgroundColor = UIColor(named: "stickerLayer")
//            displayViewWidthConstraint?.constant = 40
        }else if node.modelType == .Text{
            colorView.backgroundColor = UIColor(named: "textLayer")
//            displayViewWidthConstraint?.constant = 180
        }else{
            colorView.backgroundColor = .black
        }
        
    }

    @objc  func expandCollapseButtonTapped() {
        delegate?.didTapExpandCollapseButton(cell: self)
    }
    @objc private func lockButtonTapped() {
        
        delegate?.didTapLockButton(cell: self)
    }
    @objc private func hiddenButtonTapped() {
        delegate?.didTapHiddenButton(cell: self)
    }
    
     var isTapped : Bool =  false{
        didSet {
            print("isTapped : \(isTapped) \(node.modelId)")
            if isTapped {
                self.layer.borderColor = UIColor.tintColor.cgColor//UIColor.blue.cgColor
                self.layer.borderWidth = 1
            }else{
                self.layer.borderColor = UIColor.blue.cgColor
                self.layer.borderWidth = 0
                
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
