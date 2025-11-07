//
//  DragButton.swift
//  Timelines
//
//  Created by HKBeast on 05/02/24.
//

import UIKit

class DragView: UIView {
    var panCompletion: ((UIPanGestureRecognizer) -> ())? // Closure to handle pan gesture completion
    var image: UIImage? // Image to be displayed in the view
    var imageView: UIImageView? // Image view to display the image
    var timelineConfig: TimelineConfiguration?
    
    // Initialize the view with frame and image
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        self.image = image
//        self.backgroundColor = timelineConfig?.accentColor//ThemeManager.shared.accentColor
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setUpTimelineConfig(timelineConfig: TimelineConfiguration?){
        self.timelineConfig = timelineConfig
        self.backgroundColor = timelineConfig?.accentColor
    }
    
    // Setup UI appearance
    func setupUI() {
        // Create an image view with the given frame and image
        imageView = UIImageView()
//        imageView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.image = image
        imageView?.tintColor = .white
        imageView?.contentMode = .scaleAspectFit
        addSubview(imageView!)
        
        // Add constraints to center the imageView and make it square
        NSLayoutConstraint.activate([
            imageView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView!.widthAnchor.constraint(equalTo: heightAnchor), // Make the width equal to the height
            //                    imageView!.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8), // Limit width to 80% of DragView's width
            imageView!.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.6) // Limit height to 80% of DragView's height
        ])
        
        // Add a pan gesture recognizer to the view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag))
        addGestureRecognizer(panGesture)
    }

    // Handle the drag gesture
    @objc func onDrag(_ gesture: UIPanGestureRecognizer) {
        // Call the panCompletion closure with the current state of the gesture
        
        panCompletion?(gesture)
    }
    
    // Show the view
    func show() {
        self.isHidden = false
    }
    
    // Hide the view
    func hide() {
        self.isHidden = true
    }
}
