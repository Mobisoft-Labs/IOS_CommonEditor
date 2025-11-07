//
//  ToggleButton.swift
//  Timelines
//
//  Created by HKBeast on 05/02/24.
//

import UIKit

class ToggleButton: UIButton {
    var toggleCompletion: ((Bool) -> ())? // Closure to handle toggle completion
//    var name: String // Name of the button
    var isExpanded : Bool = false
    
    // Initializer with button title and frame
    override init(/*buttonTitle: String, */frame: CGRect) {
//        name = buttonTitle
        super.init(frame: frame)
        setupUI()
        onTapAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        self.name = ""
        super.init(coder: aDecoder)
        setupUI()
        onTapAction()
    }
    
    // Setup UI appearance
    func setupUI() {
//        setTitle("Expand", for: .normal)
        setTitleColor(.systemBackground, for: .normal)
        backgroundColor = TimelineConstants.accentColorToggleButton//ThemeManager.shared.accentColor
        layer.cornerRadius = 8.0
    }
    
    // Set action for button tap
    func onTapAction() {
        addTarget(self, action: #selector(didButtonClicked), for: .touchUpInside)
    }
    
    // Handle button tap event
    @objc func didButtonClicked() {
        print("buttonIsClicked")
        isExpanded.toggle()
        toggleCompletion?(isExpanded)
        
        // Change the name of the button based on the state
//        if isExpanded {
//            setTitle("Collapse", for: .normal)
//        } else {
//            setTitle("Expand", for: .normal)
//        }
    }
    
    // Show the button
    func show() {
        self.isHidden = false
    }
    
    // Hide the button
    func hide() {
        self.isHidden = true
    }
    
//    func changeName(name: String){
//        self.name = name
//    }
}
