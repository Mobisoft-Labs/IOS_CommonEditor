//
//  DragHandler.swift
//  VideoInvitation
//
//
//  Created by Caroline on 7/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

let diameter:CGFloat = 40

import UIKit

class DragHandle: UIView {

    var fillColor = UIColor.darkGray
    var strokeColor = UIColor.lightGray
  var strokeWidth:CGFloat = 2.0
  var imageName = ""
    var image : UIImage?
    
    var vmConfig: ViewManagerConfiguration
    
  required init(coder aDecoder: NSCoder) {
    fatalError("Use init(fillColor:, strokeColor:)")
  }
  
    init(fillColor:UIColor, strokeColor:UIColor, strokeWidth width:CGFloat = 2.0 , imageName:String = "", vmConfig: ViewManagerConfiguration) {
        self.imageName = imageName
        self.vmConfig = vmConfig
    super.init(frame:CGRectMake(0, 0, diameter, diameter))
        self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.strokeWidth = width
    self.backgroundColor = UIColor.clear
        image = UIImage(systemName:  imageName)?.withRenderingMode(.alwaysTemplate).tint(with: vmConfig.accentColorUIKit)
  }
  
 override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        // Set shadow properties
        let shadowOffset = CGSize(width: 0, height: 0) // Adjust the offset as needed
        let shadowRadius: CGFloat = 5 // Set the shadow radius
        let shadowColor = UIColor.black.withAlphaComponent(0.3) // Adjust the shadow color and opacity
        
        UIGraphicsGetCurrentContext()?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)

    let handlePath = UIBezierPath(ovalIn: CGRectInset(rect,  diameter/3,  diameter/3))
      fillColor.setFill()
      handlePath.fill()
      strokeColor.setStroke()
      handlePath.lineWidth = strokeWidth
      handlePath.stroke()
    

    let rect = CGRectInset(rect,  diameter/4,  diameter/4)
        image?.draw(in: rect)
    }
}

class RotateHandle: UIView {

    var fillColor = UIColor.darkGray
    var strokeColor = UIColor.lightGray
  var strokeWidth:CGFloat = 2.0
  var imageName = ""
    var image : UIImage?
    var vmConfig: ViewManagerConfiguration
    
  required init(coder aDecoder: NSCoder) {
    fatalError("Use init(fillColor:, strokeColor:)")
  }
  
    init(fillColor:UIColor, strokeColor:UIColor, strokeWidth width:CGFloat = 2.0 , imageName:String = "", vmConfig: ViewManagerConfiguration) {
        self.imageName = imageName
        self.vmConfig = vmConfig
    super.init(frame:CGRectMake(0, 0, diameter, diameter))
        self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.strokeWidth = width
    self.backgroundColor = UIColor.clear
        image = UIImage(systemName:  imageName)?.withRenderingMode(.alwaysTemplate).tint(with: vmConfig.accentColorUIKit)
  }
  
 override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        // Set shadow properties
           let shadowOffset = CGSize(width: 0, height: 0) // Adjust the offset as needed
           let shadowRadius: CGFloat = 4 // Set the shadow radius
           let shadowColor = UIColor.black.withAlphaComponent(0.5) // Adjust the shadow color and opacity
           

    let handlePath = UIBezierPath(ovalIn: CGRectInset(rect,  diameter/4,  diameter/4))
      fillColor.setFill()
      handlePath.fill()
      strokeColor.setStroke()
      handlePath.lineWidth = strokeWidth
      handlePath.stroke()
    
        UIGraphicsGetCurrentContext()?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)

    let rect = CGRectInset(rect,  diameter/4,  diameter/4)
        image?.draw(in: rect)
        

    }
}
