//
//  TextDragHandle.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 02/05/24.
//


import UIKit

class TextDragHandleForVertical: UIView {

    var fillColor = UIColor.darkGray
    var strokeColor = UIColor.blue
    var strokeWidth: CGFloat = 2.0
    var imageName = ""
    var diameter: CGFloat // Added property for diameter

    
    required init(coder aDecoder: NSCoder) {
        fatalError("Use init(fillColor:, strokeColor:)")
    }

    init(fillColor: UIColor, strokeColor: UIColor, strokeWidth width: CGFloat = 2.0, imageName: String = "", diameter: CGFloat = 25.0) {
        self.imageName = imageName
        self.diameter = diameter // Initialize diameter property
        super.init(frame: CGRect(x: 0, y: 0, width: diameter  * 1.5, height: diameter)) // Set height as 1.5 times diameter
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = width
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let cornerRadius: CGFloat = 5.0 // Set the corner radius value
        let shadowOffset = CGSize(width: 0, height: 0) // Adjust the offset as needed
        let shadowRadius: CGFloat = 5 // Set the shadow radius
        let shadowColor = UIColor.black.withAlphaComponent(0.3) // Adjust the shadow color and opacity
        
        UIGraphicsGetCurrentContext()?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)
        let handlePath = UIBezierPath(roundedRect: rect.insetBy(dx: 5 + strokeWidth, dy: 7 + strokeWidth), cornerRadius: cornerRadius) // Adjust insets and use roundedRect to draw with rounded corners
        fillColor.setFill()
        handlePath.fill()
        strokeColor.setStroke()
        handlePath.lineWidth = strokeWidth
        handlePath.stroke()
        
        let imageRect = CGRect(x: 0, y: 0, width: diameter, height: diameter * 1) // Adjust image rectangle
        UIImage(named: imageName)?.draw(in: imageRect)
    }

}


import UIKit

class TextDragHandleForHorizontal: UIView {

    var fillColor = UIColor.darkGray
    var strokeColor = UIColor.blue
    var strokeWidth: CGFloat = 2.0
    var imageName = ""
    var diameter: CGFloat // Added property for diameter
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Use init(fillColor:, strokeColor:)")
    }

    init(fillColor: UIColor, strokeColor: UIColor, strokeWidth width: CGFloat = 2.0, imageName: String = "", diameter: CGFloat = 25.0) {
        self.imageName = imageName
        self.diameter = diameter // Initialize diameter property
        super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter * 1.5)) // Set height as 1.5 times diameter
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = width
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let cornerRadius: CGFloat = 5.0 // Set the corner radius value
        let shadowOffset = CGSize(width: 0, height: 0) // Adjust the offset as needed
        let shadowRadius: CGFloat = 5 // Set the shadow radius
        let shadowColor = UIColor.black.withAlphaComponent(0.3) // Adjust the shadow color and opacity
        
        UIGraphicsGetCurrentContext()?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)
        let handlePath = UIBezierPath(roundedRect: rect.insetBy(dx: 7 + strokeWidth, dy: 5 + strokeWidth), cornerRadius: cornerRadius) // Adjust insets and use roundedRect to draw with rounded corners
        fillColor.setFill()
        handlePath.fill()
        strokeColor.setStroke()
        handlePath.lineWidth = strokeWidth
        handlePath.stroke()
        
        let imageRect = CGRect(x: 0, y: 0, width: diameter * 1, height: diameter * 0.5) // Adjust image rectangle
        UIImage(named: imageName)?.draw(in: imageRect)
    }

}
