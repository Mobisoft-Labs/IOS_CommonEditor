//
//  SceneView.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 21/03/24.
//

import UIKit

public class SceneView : PageView {
    
    
    
    
    weak var _templateHandler : TemplateHandler?
    
    override var templateHandler: TemplateHandler? {
        return _templateHandler
    }
  
    
    override var editorView : UIView? {
        return self.superview?.superview ?? nil
    }
    internal var subscriptionView: UIView?
    var showWatermark : Bool = true {
        didSet {
            
            showWatermark ? addSubscriptionView() : removeSubscriptionView()
        }
    }
    
    
    public weak var currentPage : PageView?
    
    weak var viewManager : ViewManager?
    
    override var breathingSpace: CGFloat {
        set {
            _breath = 0
        }
        get {
            return 0
        }
    }
    override var currentTime: Float {
       return _currentTime
    }
    
    public override init(id: Int, name: String, logger: PackageLogger, vmConfig: ViewManagerConfiguration ) {
         super.init(id: id, name: name, logger: logger, vmConfig: vmConfig)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        self.center = CGPoint(x: self.superview!.frame.width/2, y: self.superview!.frame.height/2)
        addDropShadow()
    }
   
    
  
        func addDropShadow(color: UIColor = .black,
                           opacity: Float = 0.3,
                           offset: CGSize = CGSize(width: 0, height: 3),
                           radius: CGFloat = 5) {
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.masksToBounds = false
        }
    
}

extension SceneView {
    func addPage(pageInfo:PageInfo , templateHandler:TemplateHandler) {
       
//            logError("JD Refractor")
            let currentPageView  = PageView(id: pageInfo.modelId, name: pageInfo.modelType.rawValue, logger: logger, vmConfig: vmConfig)
            currentPageView.startTime = pageInfo.baseTimeline.startTime
            currentPageView.duration = pageInfo.baseTimeline.duration
            
            let size = pageInfo.baseFrame.size
            self.addSubChild(currentPageView)

            currentPage = currentPageView
//            currentPageView.setSize(size: size)
//            currentPageView.setCenter(center: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2))
//            currentPageView.setRotation(angle: Double(pageInfo.baseFrame.rotation))
        var frame = pageInfo.baseFrame
        frame.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        currentPageView.setFrame(frame: frame)
            currentPageView.setOrder(order: pageInfo.orderInParent)
           // focusedRootView = currentPageView
            
            for stickerBase in pageInfo.children {
                if let stickerInfo = stickerBase as? StickerInfo{
                    currentPageView.addStickerView(stickerInfo: stickerInfo)
                }
                if let textInfo = stickerBase as? TextInfo{
                    currentPageView.addTextView(textInfo: textInfo)
                }

                if let parentInfo = stickerBase as? ParentInfo{
                    currentPageView.addParentView(parentInfo: parentInfo)
                }
            }
        currentPageView.isActive = false

        showWatermark = !(vmConfig.isPremium || templateHandler.currentTemplateInfo?.isPremium == 1)
                        
            templateHandler.currentActionState.pageSize = currentPageView.size
        
        
    }
    func isPremiumTapped(_ point: CGPoint) -> Bool {
        return subscriptionView?.frame.contains(point) ?? false 
    }
    func replacePage(newPageInfo: PageInfo , templateHandler:TemplateHandler)  {
        
        if currentPage != nil {
            removeCurrentPage()
        }
        
        if newPageInfo.softDelete {
            logger.logError("Page SoftDelete Is True")
            return
        }
        addPage(pageInfo: newPageInfo, templateHandler: templateHandler)
    
        
    }
    
    
    func removeCurrentPage(){
        currentPage?.removeAllChild()
        self.removeAllChild()
        currentPage = nil
    }
    
    
    func addSubscriptionView() {
        
        guard let currentPageView = currentPage else { logger.logError("No Page Found"); return }
        
        if subscriptionView == nil {
            
            subscriptionView = UIView(frame: .zero)
            // Setup inner view
            subscriptionView?.backgroundColor = UIColor.clear
            subscriptionView?.alpha = 1.0
            
            self.addSubview(subscriptionView!)
            self.bringSubviewToFront(subscriptionView!)
        }
            
            let width = Double(currentPageView.size.width) * 0.2
            let height = Double(currentPageView.size.width) * 0.1
            let posX = Double(currentPageView.size.width)  - (Double(currentPageView.size.width) * 0.11)
            let posY = Double(currentPageView.size.height) - (Double(currentPageView.size.width) * 0.06)
            
            subscriptionView?.frame.size = CGSize(width: width, height: height)
            let newCenter = currentPageView.convert(CGPoint(x: posX, y: posY), to: self)
            subscriptionView?.center = newCenter
            
           
            
            guard let viewManager = viewManager else {
                logger.printLog("Could'nt find VM")
                return
            }
    
   }
    
    func removeSubscriptionView() {
        // Ensure the view exists
        guard let subscriptionView = subscriptionView else {
            logger.printLog("SubscriptionView does not exist.")
            return
        }
        
        subscriptionView.removeFromSuperview()
    }
    
    
    
}
