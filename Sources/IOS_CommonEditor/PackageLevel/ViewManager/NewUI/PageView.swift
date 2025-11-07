//
//  PageView.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 26/03/24.
//

import UIKit

public class PageView: ParentView {
    deinit {
        logger.printLog("de-init \(self)")
    }
    
    override var notSelectedColor: UIColor {
        return UIColor.gray.withAlphaComponent(0.3)
    }
    
    override var notSelectedBorderWidth: CGFloat {
        return 0.5
    }
    
    var panRect : CGRect = .zero {
        didSet {
            
            setNeedsDisplay()
        }
    }
    public override func draw(_ rect: CGRect) {
        
        
        super.draw(rect)
            
      // this is pending,,,... can be done in next release
        
    }
    
   
    
    override func onActiveOn() {
        _internalUILayerState = .Selected
        _internalDragHandlerState = .hideHandlers
        SelectedStateUI()
        updateBoarder()
        manageHandlers()
       
    }
    
    override func onActiveOff() {
        _internalUILayerState = .NotSelected
        _internalDragHandlerState = .hideHandlers
        NotSelectedStateUI()
        updateBoarder()
        manageHandlers()
        
    }
    override func onActiveOnMultiselect() {
        _internalUILayerState = .NotSelected
        _internalDragHandlerState = .hideHandlers
            updateBoarder()
            manageHandlers()
    }
    
    override func onActiveOffMultiselect() {
        _internalUILayerState = .NotSelected
        _internalDragHandlerState = .hideHandlers
        updateBoarder()
        manageHandlers()
    }
    public override init(id: Int, name: String, logger: PackageLogger, vmConfig: ViewManagerConfiguration) {
        super.init(id: id, name: name, logger: logger, vmConfig: vmConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func isActiveAnimation() {
    }
   
}
