//
//  TimelineView.swift
//  Gesture
//
//  Created by HKBeast on 09/02/24.
import UIKit
import Combine

/**
 This class represents a custom UIView subclass named TimelineView.

 It provides functionality for displaying a timeline with horizontal scrolling and pinch-to-zoom capability.
 
 */
class TimelineManager {
    
    
    
    
   weak  var looper : TimeLoopHnadler?
   weak  var templateHandler : TemplateHandler?
    
    init(){
        
    }
    
    func setTemplateHandler(templateHandler:TemplateHandler) {
        self.looper = templateHandler.playerControls
        
        self.templateHandler = templateHandler
        
        
      
        
    }
    
    
}

struct TimelineConstants {
    static var isVerticalScrolling : Bool = false 
    static let initialPointsPerSec : CGFloat = 40
    static var initialMargin : CGFloat {
        return expand_Button_Width + drag_Button_Width + expandDragSpacing
    }
    static let maximumScale = 250.0
    static let minimumScale = 10.0
    static let spacingParentAndChild = 5.0
    static let middleLine_Width : CGFloat = 40
    static let expand_Button_Width : CGFloat = 80
    static let drag_Button_Width : CGFloat = 20
    static let expandDragSpacing: CGFloat = 20
    static let rulerHeight : CGFloat = 30
    
    
    static var timelineBackgroundColr : UIColor = UIColor(named: "editorBG") ?? .secondarySystemBackground
    static var rulingParentBGColor : UIColor = .orange
    static var parentModelColor : UIColor = UIColor(named: "parentExpanded") ?? .orange
    static var stickerModelColor : UIColor = UIColor(named: "stickerLayer") ?? .cyan
    static var textModelColor : UIColor = UIColor(named: "textLayer") ?? .green
    static var accentColorMiddleLine = UIColor.gray
    static var accentColorToggleButton = UIColor.gray
    
    static func applyConfig(_ config: TimelineConfiguration) {
        timelineBackgroundColr = config.timelineBackgroundColor
        rulingParentBGColor = config.rulingParentBGColor
        parentModelColor = config.parentModelColor
        stickerModelColor = config.stickerModelColor
        textModelColor = config.textModelColor
        accentColorMiddleLine = config.accentColorMiddleLine
        accentColorToggleButton = config.accentColorToggleButton
    }
    
}
struct ZoomLevel   {
    
    let MaxZoomIn : CGFloat = TimelineConstants.maximumScale // 250
    let ZoomIn3X : CGFloat = 100.0
    let ZoomIn2X : CGFloat = 75.0
    let ZoomIn : CGFloat = 60.0
    let Normal : CGFloat = TimelineConstants.initialPointsPerSec // 40
    let ZoomOut : CGFloat = 35.0
    let ZoomOut2X : CGFloat = 20.0
    let MaxZoomOut : CGFloat = TimelineConstants.minimumScale // 25
}

  
protocol TimelineViewDelegate : class{
    func updateThumbPostion(componentView: ComponentView)
}

public final class TimelineView: UIView , ActionStateObserversProtocol , PlayerControlsReadObservableProtocol , TemplateObserversProtocol {
    public var modelPropertiesCancellables: Set<AnyCancellable> = []
    
    public func observeAsCurrentSticker(_ stickerModel: StickerInfo) {
        // No Need Yet
    }
    
    public func observeAsCurrentText(_ textModel: TextInfo) {
        // No Need Yet
    }
    
    public func observeAsCurrentPage(_ pageModel: PageInfo) {
        // No Need Yet
    }
    
    public func observeAsCurrentParent(_ parentModel: ParentInfo) {
        // No Need Yet
    }
    
   
    
    
    public var actionStateCancellables: Set<AnyCancellable> = []
    
    public var playerControlsCancellables: Set<AnyCancellable> = []
    
    
    private var isAutomaticScrollingEnabled = false
    private var isScrollingOnLeft = false
    private var deltaPixels: CGFloat = 0
    private let maxPixels: CGFloat = 25
    private let multiplierPixels: CGFloat = 1
    private var scrollTimer: Timer?
    let SCREEN_WIDTH : CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    
    var logger: PackageLogger?
    var timelineConfig: TimelineConfiguration?{
        didSet{
            if let config = timelineConfig {
                TimelineConstants.applyConfig(config)
            }
        }
    }
    
    deinit {
        logger?.printLog("de-init \(self)")
    }
    // MARK: - CONSTANTS
   
    var tlManager = TimelineManager()
//   weak var selectedComponentView : ComponentView?
  //  var cancellables = Set<AnyCancellable>()
  //  var modelCancellables = Set<AnyCancellable>()
    var cellCancellables = Set<AnyCancellable>()
    
    // MARK: - FLAGS AND VARIABLES
    internal var isScrollDisable : Bool = false
    
    internal var canScrollOutsideOfTimeline : Bool = false
    
    internal var isManualScrolling : Bool  {
        get {
            tlManager.looper?.isManualScrolling ?? true
        }
        set {
            tlManager.looper?.isManualScrolling = newValue
        }
    }
    internal var isLongPressActive : Bool = false
    
    
    public func setTemplateHandler(templateHandler:TemplateHandler) {
        tlManager.setTemplateHandler(templateHandler: templateHandler)
        
        observeCurrentActions()
        observePlayerControls()

    }
    
   
    
    
    var baseView : UIView!
    
    //MARK: - Variables
    
    
   // var totalDuration = 5.0
    
   // var baseTime = 5.0
    
    var didDragEnd : Bool = false {
        didSet {
            tlManager.templateHandler?.templateDuration = TimeInterval(totalDuration)
            //tlManager.templateHandler?.currentActionState.updatePageAndParentThumb = true

        }
        
    }
    
    
    
    var totalDuration : CGFloat {
        set {
            tlManager.looper?.timeLengthDuration = TimeInterval(Float(newValue))
            tlManager.templateHandler?.currentTemplateInfo?.totalDuration = Float(newValue)
            scroller.rulerView.duration =  newValue
        }
        get {
            CGFloat(tlManager.looper?.timeLengthDuration ?? 0.0)
        }
    }
   
    var baseTime : CGFloat {
        set {
            scroller.rulerView.startTime = newValue
            
        }
        get {
            scroller.rulerView.startTime
        }
    }
    
    var currentPPW : CGFloat {
        set {
            pointsPerSecond = newValue
            
        }
        get {
            pointsPerSecond
        }
    }
    
    
    
    
    var rulingParentModel:ParentModel?
    
 
   // var pageModel:PageInfo
    
   // var parentModel:ParentModel
    
    var originalTouchPoint:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
  //  var timelineComponentModel:BaseModel?

    
    var tickSpacing : CGFloat = 0
    
    var  contentOffSetPoint:CGFloat{
        return self.frame.width/2
    }
    
    var drag_expand_constants : CGFloat  {
        return TimelineConstants.expand_Button_Width + 2 * ( TimelineConstants.drag_Button_Width) + 2 * (TimelineConstants.expandDragSpacing)
    }
    
    var startTimeConstant : CGFloat {
        return baseTime * currentPPW
    }
   
    var contentWidth : CGFloat {
        return (totalDuration) * currentPPW
    }
    
    
    //MARK: - Extra views in Timeline

    var scroller:ScrollerView!
    
    private var middleLineView:MiddleLineView = {
        let view = MiddleLineView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
//        view.backgroundColor = .red
         return view
     }()
 
    
    

    //MARK: - Init // JD StartHere - Removing model but before that create architecture on EXCEL
    public init(frame:CGRect, logger: PackageLogger, timelineConfig: TimelineConfiguration){
         
        // pageModel = model
//         rulingParentModel = model
        self.logger = logger
        self.timelineConfig = timelineConfig
        super.init(frame: frame)
         
        commonSetup()
    }
    
//    public func setPackageLogger(logger: PackageLogger, timelineConfig: TimelineConfiguration){
//        self.logger = logger
//        self.timelineConfig = timelineConfig
//        commonSetup()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func layoutSubviews() {
   
      
      updateFrames()
     
       
    }
    
    
    
   
    func updateFrames(){
       // let height = self.frame.height
       // let contentViewWidth:CGFloat = totalDuration*currentPPW
        
//        middleLineView.textToDisplay = "\(currentTime)"
        
      
        
        // set middle view frame
        
        middleLineView.frame = CGRect(x: 0, y: 0, width: TimelineConstants.middleLine_Width, height: self.frame.height)
        middleLineView.center = CGPoint(x: contentOffSetPoint, y: self.frame.height/2)
       
        setContentSize()
        // set ruler view frame
        
        setRulerView()
        // set parent view frame
        
        setRulingParent()
        
        //scroller.parentView.updateFrame(desiredX: (contentOffSetPoint - TimelineConstants.initialMargin), desiredWidth: contentViewWidth)
        setCollectionView()
        
        // set child collection view frame
        
       
        
       // scrollToCurrentTime(currentTime: Float(currentTime))
       
    }
    
    public func hideTimelines(){
        self.isHidden = true
    }
    
    public func showTimeline(){
        self.isHidden = false
//        scroller.rulingParent.isHidden = false
//        scroller.collectionView.isHidden = false
    }
    
    var totalcontentsizeWidthConstant : CGFloat {
        return self.bounds.size.width
    }
    
    var collectionViewWidthConstants : CGFloat {
        return drag_expand_constants + self.bounds.size.width/2
    }
    
    var rulingParentWidthConstants : CGFloat {
        return drag_expand_constants
    }
    
    var  rulerWidthConstants : CGFloat {
        return drag_expand_constants + self.bounds.size.width/2
    }
    
   
    var height_collectionView : CGFloat {
        return hideTimeline ? 0 : self.frame.height-150.0
    }
    var height_rulingParent : CGFloat {
        return hideTimeline ? 0 : TimelineConstants.rulerHeight
    }
    var hideTimeline : Bool = false {
        didSet {
            
            layoutSubviews()
        }
    }
    
//    var myHeight : CGFloat {
//        return height_collectionView + TimelineConstants.rulerHeight + height_rulingParent + 100 + TimelineConstants.spacingParentAndChild
//    }
    
    func setCollectionView() {
        
        if let pageModel = scroller.rulingParent.model{
            if let children = tlManager.templateHandler?.getChildrenFor(parentID: pageModel.modelId) {
                let maxDuration = children.reduce(0.0) { currentMax, child in
                    let childDuration = child.baseTimeline.startTime + child.baseTimeline.duration
                    return max(currentMax, Double(childDuration))
                }
                scroller.collectionView.frame = CGRect(x: startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin), y: (2*TimelineConstants.rulerHeight)+TimelineConstants.spacingParentAndChild, width:  contentWidth+drag_expand_constants+(maxDuration * currentPPW), height: height_collectionView )
                scroller.collectionView.updateFrames()
            }
        }else{
            scroller.collectionView.frame = CGRect(x: startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin), y: (2*TimelineConstants.rulerHeight)+TimelineConstants.spacingParentAndChild, width:  contentWidth+drag_expand_constants, height: height_collectionView )
        }
            
//        scroller.collectionView.frame = CGRect(x: startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin), y: (2*TimelineConstants.rulerHeight)+TimelineConstants.spacingParentAndChild, width:  contentWidth+drag_expand_constants, height: height_collectionView )
    }
    
    func setRulerView() {
        scroller.rulerView.frame = CGRect(x:  (contentOffSetPoint - TimelineConstants.initialMargin), y: 0, width: contentWidth + drag_expand_constants + startTimeConstant + self.bounds.size.width/2, height: TimelineConstants.rulerHeight)
        scroller.rulerView.duration = totalDuration
     

    }
    func setRulingParent() {
        if scroller.rulingParent.model?.modelType == .Page{
            scroller.rulingParent.frame =  CGRect(x: startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin) , y: TimelineConstants.rulerHeight, width: /*contentWidth*/ (CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.duration ?? 0) * currentPPW) + rulingParentWidthConstants   , height: height_rulingParent)
        }else{
//            if scroller.rulingParent.model?.modelId == tlManager.templateHandler?.currentModel?.modelId{
            scroller.rulingParent.frame =  CGRect(x: startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin) , y: TimelineConstants.rulerHeight, width: /*contentWidth*/ /*(CGFloat(tlManager.templateHandler?.currentParentModel?.baseTimeline.duration ?? 0)*/(CGFloat(scroller.rulingParent.model?.baseTimeline.duration ?? 0) * currentPPW) + rulingParentWidthConstants   , height: height_rulingParent)
//            }
        }
    }
    
    
    func setContentSize() {
        scroller.contentSize.width = startTimeConstant + contentWidth  + totalcontentsizeWidthConstant
        scroller.layoutIfNeeded()
        baseView.frame = CGRect(x: 0, y: 0, width: startTimeConstant + contentWidth  + totalcontentsizeWidthConstant, height: self.bounds.size.height)
    }
    
    func showStartTime(startTime:CGFloat){
        
    }
    
    var currentTime :CGFloat  {
        set {
            tlManager.looper?.setCurrentTime(Float(newValue))
        }
        get {
            CGFloat(tlManager.looper?.currentTime ?? -1)
        }
    }
    //MARK: - Private Methods
    private func commonSetup(){
        scroller = ScrollerView(delegate: self, timelineDelegate: self, logger: logger, timelineConfig: timelineConfig)
        timelineInternalViewIsHidden = true
        baseView = UIView(frame: self.frame)
        self.addSubview(baseView)
        
        baseView.addSubview(scroller)
        scroller.translatesAutoresizingMaskIntoConstraints = false
        addContentViewConstraint()
       
        scroller.delegate = self
     
       // self.scroller.contentViewDelegate = self
        self.scroller.setupUI()
        addLines()
        addPinchGesture()
   
       
        
        
        // add contentView contrasint
       
       // changeModel()
        baseView.backgroundColor = TimelineConstants.timelineBackgroundColr
        // make content view bounce off l add currentindicator as child
        
    }
    

    var timelineInternalViewIsHidden : Bool = true {
        didSet {
            scroller.collectionView.isHidden = timelineInternalViewIsHidden
            scroller.rulingParent.isHidden = timelineInternalViewIsHidden
        }
    }
    
    func changeModel(rulineModel:ParentModel){
        middleLineView.longStick = true
        self.rulingParentModel = rulineModel
        
       // if rulineModel.modelType == .Parent{
            baseTime = CGFloat(tlManager.templateHandler!.getStartTimeForSacredTimeline(model: rulineModel))
//        }else{
//            baseTime = CGFloat(rulingParentModel!.baseTimeline.startTime)
//        }
        
        /*
         Jay Code comment by JD
         if rulineModel.modelType == .Parent{
             baseTime = CGFloat(rulingParentModel!.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
         }else{
             baseTime = CGFloat(rulingParentModel!.baseTimeline.startTime)
         }
         */
        
        //totalDuration = CGFloat(rulingParentModel!.duration)
      //  currentTime = baseTime
        //currentPPW = pointsPerSecond
        scroller.setRulingModel(rulingModel: rulineModel, pageStartTime: tlManager.templateHandler!.currentPageStartTime())
        updateFrames()
        setSelectectedComponent(scroller.rulingParent)
        scroller.rulerView.pageStartTime = tlManager.templateHandler!.currentPageStartTime()
        scroller.rulerView.setNeedsDisplay()
        
        UIView.animate(withDuration: 1.0) {
            self.timelineInternalViewIsHidden = false
        }
    }
    
    func setSelectectedComponent(_ v : ComponentView) {
//        selectedComponentView = v
        v.delegate = self
    }
    
    func addLines(){
        self.addSubview(middleLineView)
    }
    
    func addContentViewConstraint(){
        self.addConstraint(NSLayoutConstraint(item: self.scroller!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))

            self.addConstraint(NSLayoutConstraint(item: self.scroller!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))

            self.addConstraint(NSLayoutConstraint(item: self.scroller!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))

            self.addConstraint(NSLayoutConstraint(item: self.scroller!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    // Adds a pinch gesture recognizer to the contentView.
    
//     - Parameter None.
    
//     - Returns: None.
//     */
    private func addPinchGesture() {
        zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        self.addGestureRecognizer(zoomGesture!)
    }
    
    

    /**
     Handles the pinch gesture recognized by the pinchGesture.
    
     - Parameter gestureRecognizer: A UIPinchGestureRecognizer instance that recognizes the pinch gesture.
    
     - Returns: None.
     */
    
    var lastPPW : CGFloat = 0
   // var initialWidth: CGFloat = 0.0
    var initialScale:CGFloat = 0.0
    var zoomGesture:UIPinchGestureRecognizer?
    
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began {
            isScrollDisable = true
            canScrollOutsideOfTimeline = false
           // initialOffsetX = scroller.contentOffset.x
           // initialWidth = scroller.collectionView.frame.size.width
            initialScale = gestureRecognizer.scale
            lastPPW = currentPPW
            
        } else if  gestureRecognizer.state == .changed {
          
            // print(initialPointsPerSecond)
          
            let scale = gestureRecognizer.scale
            
           // let newWidth = (scale * initialScale) * initialWidth
            let ppw = (scale * initialScale) * lastPPW
           
            
            if ppw > TimelineConstants.maximumScale || ppw < TimelineConstants.minimumScale{
               return
            }
            
            currentPPW = ppw
            
           zoomChildren()
            
        } else if gestureRecognizer.state == .ended {
            initialScale = 1.0
            isScrollDisable = false
            canScrollOutsideOfTimeline = true
            updateCollectionViewSize()

        }
        
    }
    
    
    func zoomChildren() {
        updateRuler()
        updateRulingParentView()
        updateCollectionViewSize()
        updateTotalContentSize()
        scrollToCurrentTime(currentTime: Float(currentTime))
    }
    
    func updateRuler() {
        scroller.rulerView.frame.size.width = contentWidth + rulerWidthConstants
    }
  
    func updateRulingParentView() {
        scroller.rulingParent.frame.size.width = contentWidth+rulingParentWidthConstants
//        scroller.rulingParent.center.x = scroller.rulingParent.frame.width / 2
//        scroller.rulingParent.setNeedsDisplay()
    }
    
    func updateRulingParentViewWithDurationAndStartTime(duration : Double, startTime: Double){
        let contentWidth = (duration) * currentPPW
        let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
        scroller.rulingParent.displayView.offset = 0.0
        scroller.rulingParent.frame.size.width = contentWidth+rulingParentWidthConstants
        scroller.rulingParent.frame.origin.x = (startTime * currentPPW) + offsetX
    }
    
    
   func  updateCollectionViewSize() {
//       if let children = tlManager.templateHandler?.getChildrenFor(parentID: scroller.rulingParent.model!.modelId) {
//           let maxDuration = children.reduce(0.0) { currentMax, child in
//               let childDuration = child.baseTimeline.startTime + child.baseTimeline.duration
//               return max(currentMax, Double(childDuration))
//           }
//           scroller.collectionView.frame.size.width = contentWidth+collectionViewWidthConstants + (maxDuration * currentPPW)
//           scroller.collectionView.updateFrames()
//       }
       
       scroller.collectionView.frame.size.width = contentWidth+collectionViewWidthConstants
       scroller.collectionView.updateFrames()
       
       
//       scroller.collectionView.center.x = scroller.collectionView.frame.width / 2
//       scroller.collectionView.setNeedsDisplay()
    }
   
    func updateTotalContentSize() {
        scroller.contentSize.width = contentWidth + totalcontentsizeWidthConstant
        baseView.frame.size.width = contentWidth + totalcontentsizeWidthConstant
//        baseView.center.x = scroller.collectionView.frame.width / 2
//        baseView.setNeedsLayout()
    }
    
    
    func scrollToCurrentTime(currentTime:Float,animate:Bool = false){
        scroller.delegate = nil
        // Adjust content offset
        let offSetX = Double(currentTime) * pointsPerSecond
        let offset = CGPoint(x: offSetX, y: scroller.contentOffset.y)
        scroller.setContentOffset(offset, animated: animate)
        // Reload data and update ruler view
        //scroller.collectionView.reloadData()
        scroller.rulerView.setNeedsDisplay()
        
        scroller.delegate = self
        
    }
    
    //MARK: - Public Methods


   

}

extension TimelineView:CoponentViewDelegate{
    func onTapExpand(timelineComponentModel: ParentModel) {
        if timelineComponentModel.editState{
            timelineComponentModel.editState = false
        }else{
            timelineComponentModel.editState = true
        }
        
//        timelineComponentModel.editState.toggle()
        print("parent Edit state: \(timelineComponentModel.editState), \(timelineComponentModel.modelId)")
    }
    
    
    func onTap(isSelected: Bool, model: BaseModel) {
        if let model = model as? ParentInfo , let currentSuperModel = tlManager.templateHandler?.currentSuperModel , model.modelId == currentSuperModel.modelId {
            scroller.collectionView.isResetThumbImagePosition = true
            tlManager.templateHandler?.setCurrentModel(id: model.modelId)
            
        }else {
            scroller.collectionView.isResetThumbImagePosition = true
            tlManager.templateHandler?.deepSetCurrentModel(id: model.modelId)
            
        }
//        if isSelected{
           
//        }else{
//            tlManager.templateHandler?.setCurrentModel(id: model.parentId)
//        }
            
    }
    
    func onLongPress(gesture: UILongPressGestureRecognizer, model: BaseModel, isScrollEnabled: inout Bool) {
        if gesture.state == .began{
            if model.modelType != .Page {
//                if scroller.rulingParent.model?.modelType == .Parent {
//                    if scroller.rulingParent.model?.modelId == model.modelId{
//                        return
//                    }
//                }
                
                isScrollDisable = true
                canScrollOutsideOfTimeline = false
                middleLineView.isHidden = true
                originalTouchPoint = gesture.location(in: self.scroller)
                scroller.endLineView.isHidden = false
                isScrollEnabled = true
                isLongPressActive = true
                scroller.collectionView.isScrollEnabled = false
                if let displayView = gesture.view, let componentView = displayView.superview as? ComponentView{
                    displayView.backgroundColor = timelineConfig?.accentColor//ThemeManager.shared.accentColor
                    //                componentView.panGesture?.isEnabled = true
                    tlManager.templateHandler?.deepSetCurrentModel(id: model.modelId)
//                    model.beginBaseTimeline = model.baseTimeline
                    componentView.leftDragButton.isHidden = true
                    componentView.rightDragButton.isHidden = true
                }

                
            }
            
        }
        else if gesture.state == .changed{
            if model.modelType != .Page || scroller.rulingParent.model?.modelType != .Parent{
                isScrollEnabled = true
            }
        }
        else if gesture.state == .ended {
            if model.modelType != .Page || scroller.rulingParent.model?.modelType != .Parent{
                
                isLongPressActive = false
                if let model = tlManager.templateHandler?.currentModel {
                    model.endBaseTimeline.startTime = model.baseTimeline.startTime
                }
                isScrollDisable = false
                canScrollOutsideOfTimeline = true
                scroller.collectionView.isScrollEnabled = true
                middleLineView.isHidden = false
                scroller.endLineView.isHidden = true
                isScrollEnabled = false
                if let displayView = gesture.view, let componentView = displayView.superview as? ComponentView{
                    componentView.setDisplayColor(model: tlManager.templateHandler!.currentModel!)
                    //                componentView.panGesture?.isEnabled = false
                    componentView.leftDragButton.isHidden = false
                    componentView.rightDragButton.isHidden = false
                }
                
                
                
//                if let model = tlManager.templateHandler?.currentModel{
//                    model.endBaseTimeline = model.baseTimeline
//                   
//                }
                
                
                if let parentModel = tlManager.templateHandler?.currentModel as? ParentModel{
                    if parentModel.editState{
    //                    baseTime = CGFloat(parentModel.baseTimeline.startTime)
                        baseTime = CGFloat(parentModel.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                        setCollectionView()
                    }
                }
                scroller.collectionView.updateFrames()
                scrollToCurrentTime(currentTime: Float(currentTime))
            }
        }
    }
    
    func onPan(gesture: UIPanGestureRecognizer) {
        guard isLongPressActive else { return }  // Ensure pan only works when long press is active
            
            if gesture.state == .began {
                // Start panning
                print("Pan gesture began")
                if let model = tlManager.templateHandler?.currentModel{
                    model.beginBaseTimeline = model.baseTimeline
                }
            } else if gesture.state == .changed {
               print("Panning")
                let newTouchPoint = gesture.location(in: self.scroller)
                // print("new touch point",newTouchPoint.x,originalTouchPoint.x)
                let deltaX = newTouchPoint.x - originalTouchPoint.x
                
                originalTouchPoint = newTouchPoint
                let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
                
                if gesture.horizontalDirection == .Left {
                    
                    guard let dragView = gesture.view, let componentView = dragView.superview as? ComponentView else {
                        print("No DragView ")
                        return
                    }
                    
                    let dragOrigin = componentView.leftDragButton.superview!.convert(dragView.frame.origin, to: self) // BUGGY
                    
                    let currentX = dragOrigin.x
                    
//                    let startScrollX = CGFloat(dragView.frame.width/2)
                    
                    logger?.printLog("\(gesture.horizontalDirection)")
                    
                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
                        if let model = tlManager.templateHandler?.currentModel{
                            
                            let newStartTime = CGFloat(model.baseTimeline.startTime) + (deltaX / currentPPW)
                            model.baseTimeline.startTime = max(0.0,Float(newStartTime))
                            if scroller.rulingParent.model?.modelType == .Parent && model.modelType == .Parent &&  model.modelId == scroller.rulingParent.model?.modelId{
                                componentView.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW, offsetX: offsetX)
                            }else{
                                componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                            }
                        }
                    }
                }else{
                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView {
                        if let model = tlManager.templateHandler?.currentModel {
                            let newStartTime = CGFloat(model.baseTimeline.startTime) + (deltaX / currentPPW)
                            
                            // Handle Parent type where ruling parent matches the model
                             if scroller.rulingParent.model?.modelType == .Parent &&
                                    model.modelType == .Parent &&
                                    scroller.rulingParent.model?.modelId == model.modelId {
                                
                                let maxAllowedStartTime = totalDuration - CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)
                                
                                if newStartTime > 0 {
                                    if (newStartTime + CGFloat(model.baseTimeline.duration)) <= maxAllowedStartTime {
                                        model.baseTimeline.startTime = Float(round(newStartTime * 100) / 100)
                                    } else {
                                        let adjustedMaxTime = maxAllowedStartTime - CGFloat(model.baseTimeline.duration)
                                        model.baseTimeline.startTime = Float(round(adjustedMaxTime * 100) / 100)
                                    }
                                } else {
                                    model.baseTimeline.startTime = 0
                                }
                                
                                 print("ST Neeshu \(model.baseTimeline.startTime), duration \(model.baseTimeline.duration) ,offset \(offsetX)")
                                componentView.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW, offsetX: offsetX)
                               
                            }
                            // Handle Page type
                            else if scroller.rulingParent.model?.modelType == .Page {
                                let maxAllowedStartTime = totalDuration - CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)
                                
                                if newStartTime >= 0 {
                                    if (newStartTime + CGFloat(model.baseTimeline.duration)) <= maxAllowedStartTime {
                                        model.baseTimeline.startTime = Float(newStartTime)
                                    } else {
                                        model.baseTimeline.startTime = Float(maxAllowedStartTime - CGFloat(model.baseTimeline.duration))
                                    }
                                } else {
                                    model.baseTimeline.startTime = 0
                                }
                                // Update component view frame
                                componentView.setFrame(
                                    startTime: CGFloat(model.baseTimeline.startTime),
                                    duration: CGFloat(model.baseTimeline.duration),
                                    currentPPW: currentPPW
                                )
                            }
                            // Handle parent model (non-page type)
                            else if scroller.rulingParent.model?.modelType == .Parent{
                                let parentModel = tlManager.templateHandler?.getModel(modelId: model.parentId)
                                if newStartTime >= 0 {
                                    if (CGFloat(model.baseTimeline.duration) + newStartTime) <= CGFloat(parentModel?.startTime ?? 0 + parentModel!.duration ?? 0) {
                                        model.baseTimeline.startTime = Float(newStartTime)
                                    } else {
                                        // Revert to original logic for maximum position
                                        model.baseTimeline.startTime = Float(parentModel?.baseTimeline.duration ?? 0) - model.baseTimeline.duration
                                    }
                                } else {
                                    model.baseTimeline.startTime = 0
                                }
                                // Update component view frame
                                componentView.setFrame(
                                    startTime: CGFloat(model.baseTimeline.startTime),
                                    duration: CGFloat(model.baseTimeline.duration),
                                    currentPPW: currentPPW
                                )
                            }
                           
                        
                        }
                    }
                }
                
            } else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
                print("Pan gesture ended or cancelled")
                if let model = tlManager.templateHandler?.currentModel {
                    model.endBaseTimeline = model.baseTimeline
//                    isLongPressActive = false
                }
            }
    }
    
    func onDragLeft(gesture: UIPanGestureRecognizer, model: BaseModel) {
        print("drag left")
        if gesture.state == .began {
            canScrollOutsideOfTimeline = false
        }
        if model.modelType == .Page {
            
            if gesture.state == .began {
                print("width total")
                isScrollDisable = true
                canScrollOutsideOfTimeline = false
                middleLineView.isHidden = true
                originalTouchPoint = gesture.location(in: self.scroller)
                scroller.endLineView.isHidden = false
            }
            
        }else if /*scroller.rulingParent.model?.modelType*/model.modelType == .Parent {
            onParentDragLeftSide(gesture: gesture)
        }else{
            onChildDragLeftSide(gesture: gesture)
        }
        
        if gesture.state == .ended {
            canScrollOutsideOfTimeline = true
        }
        
    }
    
   
    
    func onDragRight(gesture: UIPanGestureRecognizer, model: BaseModel) {
        print("drag right")
        if gesture.state == .began {
            canScrollOutsideOfTimeline = false
        }
        if model.modelType == .Page{
          onPageDragRightSide(gesture: gesture)
        } else if /*scroller.rulingParent.model?.modelType*/model.modelType == .Parent {
            onParentDragRightSide(gesture: gesture)
        }else {
            onChildDragRightSide(gesture: gesture)
        }
            
        if gesture.state == .ended {
            canScrollOutsideOfTimeline = true
        }
        }
    
    private func onParentDragLeftSide(gesture: UIPanGestureRecognizer){
        if gesture.state == .began {
            print("width total")
            isScrollDisable = true
            middleLineView.isHidden = true
            originalTouchPoint = gesture.location(in: self.scroller)
            scroller.startLineView.isHidden = false
            
//            if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
//                        let superView = dragView.superview
//                        print("Superview: \(String(describing: superView))")
                if let model = tlManager.templateHandler?.currentModel{
//                    model.beginBaseTimeline.startTime = model.baseTimeline.startTime
                    model.beginBaseTimeline = model.baseTimeline
                }
//            }
            
        }
        
        else if  gesture.state == .changed {
            print(currentPPW)
 
            guard let dragView = gesture.view as? DragView else {
                print("No DragView ")
                return
            }
            let dragOrigin = dragView.superview!.convert(dragView.frame.origin, to: self) // BUGGY
            let currentX = dragOrigin.x
            
                let newTouchPoint = gesture.location(in: self.scroller)
                // print("new touch point",newTouchPoint.x,originalTouchPoint.x)
                let deltaX = newTouchPoint.x - originalTouchPoint.x
                
                
                // print("PX",predictedX)
                
                //  let originX = contentView.parentView.frame.origin.x
                // it drags the view
                //  scroller.rulingParent.frame.size.width += deltaX
                
                originalTouchPoint = newTouchPoint
//                let newDuration = totalDuration + timeDetla(widthDelta: deltaX)
                print("TD:",totalDuration)
                
                //
                let startScrollX = CGFloat(dragView.frame.width/2)
            logger?.printLog("\(gesture.horizontalDirection)")
                
                if gesture.horizontalDirection == .Left {

                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
//                        let superView = dragView.superview
//                        print("Superview: \(String(describing: superView))")
                        
                        if let model = tlManager.templateHandler?.currentModel{
                            
                            print("model start Time: \(model.startTime)")
                            if model.baseTimeline.startTime > 0.0{
                                let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
                                let newStartTime = CGFloat(model.baseTimeline.startTime) + (deltaX / currentPPW)
//                                model.baseTimeline.startTime = max(0.0,Float(newStartTime))//Float(newStartTime)
                                let newDuration = model.baseTimeline.duration - Float(deltaX / currentPPW)
//                                model.baseTimeline.duration = min(Float(totalDuration),Float(newDuration))
                                model.baseTimeline = StartDuration(startTime: max(0.0,Float(newStartTime)), duration: min(Float(totalDuration),Float(newDuration)))
                                print("Start time on left: \(model.startTime)")
                                if let parent = tlManager.templateHandler?.currentModel as? ParentInfo{
                                    if parent.editState == true{
                                        componentView.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)), duration: CGFloat(model.baseTimeline.duration + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)), currentPPW: currentPPW, offsetX: offsetX)
                                                                                
                                        scroller.startLineView.frame = CGRect(x: componentView.frame.minX + offsetX + 10 + (2 * TimelineConstants.drag_Button_Width), y: 0, width: 1.0, height: self.frame.height)
                                        
                                        currentTime = CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                        currentTime = max(0.0,currentTime + (deltaX / currentPPW))
                                        
                                        
                                    }else{
                                        componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                                        
                                        print("component VIew minx X: \(componentView.frame.minX) display view min X: \(componentView.displayView.frame.minX)")
                                        
                                        scroller.startLineView.frame = CGRect(x: componentView.frame.minX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + TimelineConstants.initialMargin, y: 0, width: 1.0, height: self.frame.height)
                                        
                                        currentTime = CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                        currentTime = max(0.0,currentTime + (deltaX / currentPPW))
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
                    let predictedX = currentX + deltaX


                }else {
                    
 
                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {

                        if let model = tlManager.templateHandler?.currentModel{
 
                            let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
                                let minSecs = 0.5 * currentPPW
                                let minDuration = (model.baseTimeline.duration) * Float(currentPPW)
                                if minDuration >= Float(minSecs){
                                    let newStartTime = CGFloat(model.baseTimeline.startTime) + ((deltaX / currentPPW))
//                                    model.baseTimeline.startTime = Float(newStartTime)
                                    let newDuration = model.baseTimeline.duration - Float(deltaX / currentPPW)
//                                    model.baseTimeline.duration = newDuration
                                    
                                    model.baseTimeline = StartDuration(startTime: Float(newStartTime), duration: model.baseTimeline.duration - Float(deltaX / currentPPW))
                                    print("Start time on right: \(model.startTime)")

                                    if let parent = tlManager.templateHandler?.currentModel as? ParentInfo{
                                        if parent.editState == true{
                                            componentView.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)), duration: CGFloat(model.baseTimeline.duration + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)), currentPPW: currentPPW, offsetX: offsetX)
                                            scroller.startLineView.frame = CGRect(x: componentView.frame.minX + offsetX + 10 + (2 * TimelineConstants.drag_Button_Width), y: 0, width: 1.0, height: self.frame.height)
                                            
                                            currentTime = CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                            currentTime = min(totalDuration - 0.5,currentTime + (deltaX / currentPPW))
                                            
                                        }else{
                                            componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                                            
                                            scroller.startLineView.frame = CGRect(x: componentView.frame.minX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + TimelineConstants.initialMargin, y: 0, width: 1.0, height: self.frame.height)
                                            
                                            currentTime = CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                            currentTime = min(totalDuration - 0.5,currentTime + (deltaX / currentPPW))
                                        }
                                    }

                                    
                                }
                        }
                    }
                    
                    let endScrollX = self.scroller.contentOffset.x + self.frame.width - dragView.frame.width/2

                    let predictedX = scroller.contentOffset.x + currentX + deltaX + dragView.frame.width

                }
                
                
        }
        
        else if gesture.state == .ended {
            //            didDragEnd = true
            middleLineView.isHidden = false
            isScrollDisable = false
            scroller.startLineView.isHidden = true
            
            if let model = tlManager.templateHandler?.currentModel{
                model.endBaseTimeline = model.baseTimeline
               
            }
            
            
            if let parentModel = tlManager.templateHandler?.currentModel as? ParentModel{
                if parentModel.editState{
//                    baseTime = CGFloat(parentModel.baseTimeline.startTime)
                    baseTime = CGFloat(parentModel.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                    setCollectionView()
                }
            }
            scroller.collectionView.updateFrames()
            scrollToCurrentTime(currentTime: Float(currentTime))
            //            }
            
        }
    }
    
    private func onChildDragLeftSide(gesture: UIPanGestureRecognizer){
        if gesture.state == .began {
            print("width total")
            isScrollDisable = true
            middleLineView.isHidden = true
            originalTouchPoint = gesture.location(in: self.scroller)

            scroller.startLineView.isHidden = false
            
//            if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
//                        let superView = dragView.superview
//                        print("Superview: \(String(describing: superView))")
                if let model = tlManager.templateHandler?.currentModel{
//                    model.beginBaseTimeline.startTime = model.baseTimeline.startTime
                    model.beginBaseTimeline = model.baseTimeline
                }
//            }
            
        }
        
        else if  gesture.state == .changed {
            print(currentPPW)

            guard let dragView = gesture.view as? DragView else {
                print("No DragView ")
                return
            }
            let dragOrigin = dragView.superview!.convert(dragView.frame.origin, to: self) // BUGGY
            let currentX = dragOrigin.x
            
                let newTouchPoint = gesture.location(in: self.scroller)
                // print("new touch point",newTouchPoint.x,originalTouchPoint.x)
                let deltaX = newTouchPoint.x - originalTouchPoint.x
                
                originalTouchPoint = newTouchPoint
//                let newDuration = totalDuration + timeDetla(widthDelta: deltaX)
                print("TD:",totalDuration)
                
                //
                let startScrollX = CGFloat(dragView.frame.width/2)
            logger?.printLog("\(gesture.horizontalDirection)")
                
                if gesture.horizontalDirection == .Left {

                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
//                        let superView = dragView.superview
//                        print("Superview: \(String(describing: superView))")
                        
                        if let model = tlManager.templateHandler?.currentModel{
                            //                            let minSecs: Float = 0.0
                            //                            let minStartTime = model.startTime * Float(currentPPW)
                            //                            if minSecs <= minStartTime{
                            if model.baseTimeline.startTime > 0.0{
                                let newStartTime = CGFloat(model.baseTimeline.startTime) + (deltaX / currentPPW)
                                model.baseTimeline.startTime = max(0.0,Float(newStartTime))//Float(newStartTime)
                                let newDuration = model.baseTimeline.duration - Float(deltaX / currentPPW)
                                model.baseTimeline.duration = min(Float(totalDuration),Float(newDuration))
                                componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                                
                                currentTime = CGFloat(model.baseTimeline.startTime + /*(scroller.model?.baseTimeline.startTime ?? 0) +*/ (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                currentTime = max(0.0,currentTime + (deltaX / currentPPW))
 
                                print("component VIew minx X: \(componentView.frame.minX) display view min X: \(componentView.displayView.frame.minX)")
                                
                                scroller.startLineView.frame = CGRect(x: componentView.frame.minX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + TimelineConstants.initialMargin, y: 0, width: 1.0, height: self.frame.height)
                            }
                        }
                    }
                    
                    
                    let predictedX = currentX + deltaX
                    
                }else {
 
                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
//                        let superView = dragView.superview
//                        print("Superview: \(String(describing: superView))")
                        if let model = tlManager.templateHandler?.currentModel{
                            
                            let minSecs = 0.5 * currentPPW
                            let minDuration = (model.baseTimeline.duration) * Float(currentPPW)
                            if minDuration >= Float(minSecs){
                                let newStartTime = CGFloat(model.baseTimeline.startTime) + (deltaX / currentPPW)
                                model.baseTimeline.startTime = Float(newStartTime)
                                let newDuration = model.baseTimeline.duration - Float(deltaX / currentPPW)
                                model.baseTimeline.duration = newDuration
                                componentView.setFrame(startTime: newStartTime, duration: CGFloat(newDuration), currentPPW: currentPPW)
                                
                                currentTime = CGFloat(model.baseTimeline.startTime + /*(scroller.model?.baseTimeline.startTime ?? 0) +*/ (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                currentTime = min(totalDuration - 0.5,currentTime + (deltaX / currentPPW))
                                
                                scroller.startLineView.frame = CGRect(x: componentView.frame.minX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + TimelineConstants.initialMargin, y: 0, width: 1.0, height: self.frame.height)
                            }
                        }
                    }
                    
                    let endScrollX = self.scroller.contentOffset.x + self.frame.width - dragView.frame.width/2
                    
                    let predictedX = scroller.contentOffset.x + currentX + deltaX + dragView.frame.width
                    
                }
                
                
        }
        
        else if gesture.state == .ended {
//            didDragEnd = true
            middleLineView.isHidden = false
            isScrollDisable = false
            scroller.startLineView.isHidden = true
//            onPageDragEnd()
//            if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
//                        let superView = dragView.superview
//                        print("Superview: \(String(describing: superView))")
                if let model = tlManager.templateHandler?.currentModel{
                    model.endBaseTimeline = model.baseTimeline
                }
//            }
            scrollToCurrentTime(currentTime: Float(currentTime))
        }
    }
    
    private func onChildDragRightSide(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            print("width total")
            isScrollDisable = true
            middleLineView.isHidden = true
            originalTouchPoint = gesture.location(in: self.scroller)
            
            scroller.endLineView.isHidden = false
            if let model = tlManager.templateHandler?.currentModel{
//                model.endStartTime = model.startTime
                model.beginBaseTimeline = model.baseTimeline
            }
        }
        
        else if  gesture.state == .changed {
            print(currentPPW)
       
            guard let dragView = gesture.view as? DragView else {
                print("No DragView ")
                return
            }
            let dragOrigin = dragView.superview!.convert(dragView.frame.origin, to: self) // BUGGY
            let currentX = dragOrigin.x
            
                let newTouchPoint = gesture.location(in: self.scroller)
                // print("new touch point",newTouchPoint.x,originalTouchPoint.x)
                let deltaX = newTouchPoint.x - originalTouchPoint.x
                
            print("new touch pont: \(newTouchPoint), delta X : \(deltaX), scroller content offset X: \(scroller.contentOffset.x) currentX: \(currentX)")
          
                originalTouchPoint = newTouchPoint
            logger?.printLog("\(gesture.horizontalDirection)")
                
                if gesture.horizontalDirection == .Left {
                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
                        if let model = tlManager.templateHandler?.currentModel{
                            let newDuration = model.baseTimeline.duration + Float(deltaX / currentPPW)
                            model.baseTimeline.duration = max(0.5,newDuration)
                            componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                            
                            currentTime = CGFloat(model.baseTimeline.duration + model.baseTimeline.startTime + /*(scroller.model?.startTime ?? 0) +*/ (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                            currentTime = max(0.5,currentTime + (deltaX / currentPPW))
                            
                            scroller.endLineView.frame = CGRect(x: componentView.displayView.frame.maxX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + (CGFloat(model.baseTimeline.startTime) * currentPPW), y: 0, width: 1.0, height: self.frame.height)
                            
                        }
                    }
                    
                }else {

                    if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
                        if let model = tlManager.templateHandler?.currentModel{
                            let newDuration = (model.baseTimeline.duration + Float(deltaX / currentPPW))
                            
                            model.baseTimeline.duration = min(Float(/*totalDuration*/CGFloat(scroller.model?.baseTimeline.duration ?? 0) - CGFloat(model.baseTimeline.startTime)),newDuration)
                            componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                            
                            currentTime = CGFloat(model.baseTimeline.duration + model.baseTimeline.startTime + /*(scroller.model?.startTime ?? 0) +*/ (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                            currentTime = min(totalDuration,currentTime + (deltaX / currentPPW))
                            print("component VIew max X: \(componentView.frame.maxX) display view max X: \(componentView.displayView.frame.maxX)")
                            scroller.endLineView.frame = CGRect(x: componentView.displayView.frame.maxX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + (CGFloat(model.baseTimeline.startTime) * currentPPW), y: 0, width: 1.0, height: self.frame.height)
                        }
                    }
                    
                }
                
                
        }
        
        else if gesture.state == .ended {
//            didDragEnd = true
            middleLineView.isHidden = false
            scroller.endLineView.isHidden = true
            isScrollDisable = false
            scrollToCurrentTime(currentTime: Float(currentTime))
//            onPageDragEnd()
            if let model = tlManager.templateHandler?.currentModel{
//                model.endStartTime = model.startTime
                model.endBaseTimeline = model.baseTimeline
            }
            
        }
    }
    
    private func onParentDragRightSide(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            print("width total")
            isScrollDisable = true
            middleLineView.isHidden = true
            originalTouchPoint = gesture.location(in: self.scroller)
           
            scroller.endLineView.isHidden = false
            
            if let model = tlManager.templateHandler?.currentModel{
//                model.beginBaseTimeline.startTime = model.baseTimeline.startTime
                model.beginBaseTimeline = model.baseTimeline
            }
        }
        
        else if  gesture.state == .changed {
            print(currentPPW)
            
            guard let dragView = gesture.view as? DragView else {
                print("No DragView ")
                return
            }
            let dragOrigin = dragView.superview!.convert(dragView.frame.origin, to: self) // BUGGY
            let currentX = dragOrigin.x
            
            let newTouchPoint = gesture.location(in: self.scroller)
            // print("new touch point",newTouchPoint.x,originalTouchPoint.x)
            let deltaX = newTouchPoint.x - originalTouchPoint.x

            originalTouchPoint = newTouchPoint
//            let newDuration = totalDuration + timeDetla(widthDelta: deltaX)
//            print("TD:",totalDuration)
            
            
            //
            let startScrollX = CGFloat(dragView.frame.width/2)
            logger?.printLog("\(gesture.horizontalDirection)")
            
            if gesture.horizontalDirection == .Left {

                let predictedX = currentX + deltaX

                if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
                    if let model = tlManager.templateHandler?.currentModel{

                            let newDuration = model.baseTimeline.duration + Float(deltaX / currentPPW)
                            model.baseTimeline.duration = max(0.5,newDuration)
                        
                        if let parent = tlManager.templateHandler?.currentModel as? ParentInfo{
                            if parent.editState == true{
                                let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
                                componentView.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW, offsetX: offsetX)
                                
                                scroller.endLineView.frame = CGRect(x: componentView.displayView.frame.maxX + offsetX + (CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)) * currentPPW), y: 0, width: 1.0, height: self.frame.height)
                            }else{
                                componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                                
                                scroller.endLineView.frame = CGRect(x: componentView.displayView.frame.maxX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + (CGFloat(model.baseTimeline.startTime) * currentPPW), y: 0, width: 1.0, height: self.frame.height)
                            }
                        }
                        currentTime = CGFloat(model.baseTimeline.duration + model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                        currentTime = max(0.5,currentTime + (deltaX / currentPPW))
                                                    
                    }
                }
            }else {
                

                let endScrollX = self.scroller.contentOffset.x + self.frame.width - dragView.frame.width/2
                
                let predictedX = scroller.contentOffset.x + currentX + deltaX + dragView.frame.width

                if let dragView = gesture.view, let componentView = dragView.superview as? ComponentView  {
                    if let model = tlManager.templateHandler?.currentModel{

                            let parentModel = tlManager.templateHandler?.getModel(modelId: model.parentId)
                            let newDuration = model.baseTimeline.duration + Float(deltaX / currentPPW)
                            model.baseTimeline.duration = min(Float(parentModel!.baseTimeline.duration - model.baseTimeline.startTime),newDuration)
                        if let parent = tlManager.templateHandler?.currentModel as? ParentInfo{
                            if parent.editState == true{
                                let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
                                componentView.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW, offsetX: offsetX)
                                
                                scroller.endLineView.frame = CGRect(x: componentView.displayView.frame.maxX + offsetX + (CGFloat(model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)) * currentPPW), y: 0, width: 1.0, height: self.frame.height)
                                
                            }else{
                                componentView.setFrame(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW)
                                
                                scroller.endLineView.frame = CGRect(x: componentView.displayView.frame.maxX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)) + (CGFloat(model.baseTimeline.startTime) * currentPPW), y: 0, width: 1.0, height: self.frame.height)
                            }
                        }
                            
                        currentTime = CGFloat(model.baseTimeline.duration + model.baseTimeline.startTime + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                        currentTime = min(totalDuration,currentTime + (deltaX / currentPPW))
                    }
                }
            }
            
            
            
            
            
        }
        
        else if gesture.state == .ended {
//            didDragEnd = true
            
            middleLineView.isHidden = false
            scroller.endLineView.isHidden = true
            isScrollDisable = false
            //                    onPageDragEnd()
            if let model = tlManager.templateHandler?.currentModel{
                model.endBaseTimeline = model.baseTimeline
            }
            
            scroller.collectionView.updateFrames()
            scrollToCurrentTime(currentTime: Float(currentTime))
        }
    }
    
    private func onPageDragRightSide(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            print("width total")
            isScrollDisable = true
//            middleLineView.isHidden = true
            originalTouchPoint = gesture.location(in: self.scroller)
 
            middleLineView.isHidden = true
            scroller.endLineView.isHidden = false
            if let model = tlManager.templateHandler?.currentModel{
//                model.beginBaseTimeline.startTime = model.baseTimeline.startTime
                model.beginBaseTimeline = model.baseTimeline
            }
        }
        
        else if  gesture.state == .changed {
            print(currentPPW)

        guard let dragView = gesture.view as? DragView else {
                print("No DragView ")
                return
            }
            let dragOrigin = dragView.superview!.convert(dragView.frame.origin, to: self) // BUGGY
            let currentX = dragOrigin.x
            
            let newTouchPoint = gesture.location(in: self.scroller)
           // print("new touch point",newTouchPoint.x,originalTouchPoint.x)
            let deltaX = newTouchPoint.x - originalTouchPoint.x
            print("page deltaX: \(deltaX)")
            
//            currentTime = currentTime + (deltaX / currentPPW)
            let offsetX = (contentOffSetPoint - TimelineConstants.initialMargin)
           
            originalTouchPoint = newTouchPoint

            let newDuration = totalDuration + timeDetla(widthDelta: deltaX)
            print("TD:",totalDuration)

//
//            let startScrollX = CGFloat(dragView.frame.width/2)
            logger?.printLog("\(gesture.horizontalDirection)")
            
            if gesture.horizontalDirection == .Left {
                guard totalDuration > 0 else { print("DIscarding"); return }
//                currentTime = totalDuration
                totalDuration = max(0.5,newDuration)
                
                
                
                if let model = tlManager.templateHandler?.currentModel{
                   let duration = model.baseTimeline.duration + Float(deltaX / currentPPW)
                    model.baseTimeline.duration = Float(max(0.5,duration))
                    
                    scroller.rulingParent.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW, offsetX: offsetX)
                    
                    currentTime = CGFloat(model.baseTimeline.duration + model.baseTimeline.startTime)
                    currentTime = max(0.5,currentTime + (deltaX / currentPPW))
                    
                    scroller.endLineView.frame = CGRect(x: scroller.rulingParent.displayView.frame.maxX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)), y: 0, width: 1.0, height: self.frame.height)
                }
                

            }else {
                
                //guard totalDuration > 0 else { print("DIscarding"); return }
//                currentTime = totalDuration
                totalDuration = max(0,newDuration)
                
                if let model = tlManager.templateHandler?.currentModel{
                    
                    let duration = (model.baseTimeline.duration + Float(deltaX / currentPPW))
                    model.baseTimeline.duration = Float(duration)
                    
                    scroller.rulingParent.setFrameRulingParent(startTime: CGFloat(model.baseTimeline.startTime), duration: CGFloat(model.baseTimeline.duration), currentPPW: currentPPW, offsetX: offsetX)
                    
                    currentTime = CGFloat(model.baseTimeline.duration + model.baseTimeline.startTime)
                    currentTime = min(totalDuration,currentTime + (deltaX / currentPPW))
                    
                    scroller.endLineView.frame = CGRect(x: scroller.rulingParent.displayView.frame.maxX + (startTimeConstant + (contentOffSetPoint - TimelineConstants.initialMargin)), y: 0, width: 1.0, height: self.frame.height)
                }
            }

                  
                
                    
                    
       }
                
                else if gesture.state == .ended {
//                    scrollTimer?.invalidate()
                    didDragEnd = true
                    onPageDragEnd()
                    middleLineView.isHidden = false
                    if let model = tlManager.templateHandler?.currentModel{
                        model.endBaseTimeline = model.baseTimeline
                        
                    }
                   
                }
    }
    
    func startAutoScroll() {
        // Invalidate any existing timer
               scrollTimer?.invalidate()
               
               // Reset deltaPixels to 0updaterulingpa
        
               deltaPixels = 0
        // Start the timer for automatic scrolling
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            
            guard let self = self else { return }
            
            // Check if scrolling is still enabled
            if self.isAutomaticScrollingEnabled {
                logger?.printLog("startAutoScroll")
                
                    // add offSet points
                if self.deltaPixels < self.maxPixels {
                    self.deltaPixels += self.multiplierPixels
                }
                
                // Calculate the scroll delta
                let deltaScroll: CGFloat = self.isScrollingOnLeft ? -self.deltaPixels : self.deltaPixels
                
                

                // Scroll the scrollView
//                let newContentOffsetX = self.scroller.contentOffset.x + deltaScroll
                let newDuration = totalDuration + timeDetla(widthDelta: deltaScroll)
                currentTime = currentTime + (deltaScroll / currentPPW)
                canScrollOutsideOfTimeline = false
                scrollToCurrentTime(currentTime: Float(currentTime))
                canScrollOutsideOfTimeline = true

                updateRuler()
                updateTotalContentSize()
                totalDuration = max(0.5, newDuration)
                updateRulingParentView()


                
            } else {
                timer.invalidate()
            }
        }
        
    }
    
    private func cancelScrollHandler() {
        isAutomaticScrollingEnabled = false
        scrollTimer?.invalidate()
        scrollTimer = nil
    }

    
    func onPageDragEnd() {
//        middleLineView.isHidden = false
        initialScale = 1.0
        isScrollDisable = false
        
        updateRuler()
        updateTotalContentSize()
        updateCollectionViewSize()
//        makeDurationCurrentTime()
        scrollToCurrentTime(currentTime: Float(currentTime),animate: true)
        scroller.endLineView.isHidden = true
    }
    
    
}


extension TimelineView : UIScrollViewDelegate {
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tlManager.looper?.renderState = .Paused
        tlManager.templateHandler?.renderingState = .Animating
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        canScrollOutsideOfTimeline = false
        if !isScrollDisable {
            
            
            let cTime = scroller.contentOffset.x / currentPPW
//            if cTime <= baseTime {
//                cTime = baseTime
////                scrollToCurrentTime(currentTime: Float(currentTime))
//            }
            
            if tlManager.templateHandler?.currentModel == nil{
                currentTime = cTime
            }else{
                if cTime <= totalDuration{
                    if tlManager.templateHandler?.currentModel?.modelType == .Page{
                        currentTime = cTime
                    }else{
                        if scroller.rulingParent.model?.modelType == .Page{
                            if cTime <= CGFloat((tlManager.templateHandler?.currentPageModel?.baseTimeline.duration ?? 0) + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)) && cTime >= CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0){
                                currentTime = cTime
                            }else if cTime >= CGFloat((tlManager.templateHandler?.currentPageModel?.baseTimeline.duration ?? 0) + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)){
                                
                                currentTime = CGFloat((tlManager.templateHandler?.currentPageModel?.baseTimeline.duration ?? 0) + (tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                scrollToCurrentTime(currentTime: Float(currentTime))
                            }else if cTime <= CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0){
                                currentTime = CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)
                                scrollToCurrentTime(currentTime: Float(currentTime))
                            }
                        }else{
                            if cTime <= (CGFloat(scroller.rulingParent.model?.baseTimeline.startTime ?? 0) + CGFloat(scroller.rulingParent.model?.baseTimeline.duration ?? 0) + CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)) && cTime >= (CGFloat(scroller.rulingParent.model?.baseTimeline.startTime ?? 0) + CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)){
                                currentTime = cTime
                            }else if cTime >= (CGFloat(scroller.rulingParent.model?.baseTimeline.startTime ?? 0) + CGFloat(scroller.rulingParent.model?.baseTimeline.duration ?? 0) + CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)){
                                currentTime = (CGFloat(scroller.rulingParent.model?.baseTimeline.duration ?? 0) + CGFloat(scroller.rulingParent.model?.baseTimeline.startTime ?? 0) + CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0))
                                scrollToCurrentTime(currentTime: Float(currentTime))
                            }else if cTime <= (CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0) + CGFloat(scroller.rulingParent.model?.baseTimeline.startTime ?? 0)){
                                currentTime = (CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0) + CGFloat(scroller.rulingParent.model?.baseTimeline.startTime ?? 0))
                                scrollToCurrentTime(currentTime: Float(currentTime))
                            }
                           
                        }
                    }
                }else{
                    currentTime = totalDuration
                    scrollToCurrentTime(currentTime: Float(currentTime))
                }
            }

            print("Rounded Time:", currentTime)

        }
        canScrollOutsideOfTimeline = true
        scroller.collectionView.isResetThumbImagePosition = true
       
    }
    
        
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tlManager.templateHandler?.renderingState = .Edit
        scroller.collectionView.isResetThumbImagePosition = false
        tlManager.templateHandler?.currentActionState.currentThumbTime = Float(currentTime)
        if currentTime <= totalDuration{
            tlManager.templateHandler?.currentActionState.updatePageAndParentThumb = true
        }

    }
    
    
    func timeDetla(widthDelta:CGFloat) -> Double {
        widthDelta / currentPPW
    }
    
//    func timeDelta2(width:CGFloat) -> CGFloat {
//          return width / initialPointsPerSecond
//    }
    
    func updateTotalDuration(by timeDelta : CGFloat) {
        totalDuration += timeDelta
    }
     
    func makeDurationCurrentTime() {
        currentTime = baseTime + totalDuration - CGFloat(tlManager.templateHandler?.currentPageModel?.baseTimeline.startTime ?? 0)
    }
}

extension TimelineView: TimelineViewDelegate{
    func updateThumbPostion(componentView: ComponentView) {
//        cellCancellables.removeAll()
        scroller.collectionView.$isResetThumbImagePosition.sink { [weak self] value in
            guard let self = self else { return }
            
            if value{
                
                // 2. Convert the middle line point from mainView to the scrollView's coordinate system
                let middleLinePointInScrollView = self.convert(CGPoint(x: (SCREEN_WIDTH / 2), y: 0), to: scroller)
                
                // 3. Convert the middle line point from scrollView to displayView's coordinate system
                let middleLinePointInDisplayView = scroller.convert(middleLinePointInScrollView, to: scroller.rulingParent.displayView)
                
                // 4. Extract the X-coordinate on displayView
                let middleLineXInDisplayView = middleLinePointInDisplayView.x
                
               // print("middle line x on display view: \(middleLineXInDisplayView)")
                                
                scroller.rulingParent.displayView.postionImageViewWithMiddleLineView(offSet: middleLineXInDisplayView, componentView: scroller.rulingParent)
//                let visibleCells = scroller.collectionView.visibleCells as! [ChildCVCell]
//                
//                
//                for cell in visibleCells {
//                    // 2. Convert the middle line point from mainView to the scrollView's coordinate system
//                    let middleLinePointInScrollView = self.convert(CGPoint(x: (SCREEN_WIDTH / 2), y: 0), to: scroller)
//                    
                    // 3. Convert the middle line point from scrollView to displayView's coordinate system
                    let middleLinePointInDisplayView2 = scroller.convert(middleLinePointInScrollView, to: componentView.displayView)
                    
                    // 4. Extract the X-coordinate on displayView
                    let middleLineXInDisplayView2 = middleLinePointInDisplayView2.x
                    
                componentView.displayView.postionImageViewWithMiddleLineView(offSet: middleLineXInDisplayView2, componentView: componentView)
//                }
                
              //  print("updated thumb frame")
            }
        }.store(in: &cellCancellables)
    }
    
    
}

// Function to round to the nearest value with snap tolerance
func roundToNearest(_ value: Double, snapTolerance: Double) -> Double {
    // Calculate the rounded value
    let roundedValue = round(value / snapTolerance) * snapTolerance
    
    // Return the rounded value
    return roundedValue
}


/*
 pageModel ID
 pageModel StartTime
 pageModel EndTime
 
 
 
 Model {
            startTime
            endTime
            id
            type
            content
            
 */


/*
 
 
 class Model
    
 
 parentModel -> Timeline
 
 rulingView ( parentModel )
 
 
 container {
                startTime
                duration
                parentModel
 
            Ruling(x,y,w,h,content)
 
            CollectionView(children)
                        Cell(child)
                            Ruling(x,y,w,h,content)
                        Cell(child)
                            Ruling(x,y,w,h,content)
 
 id , image
 isSelected
 expand/collapse
 order
 delete
 insert
 hidden
 ruling modelChange
 onPageChange - Done
 
 
 startTime
 endTime
 
 /*
  TODO : -
  1. Ruler Fill Area And Minimilistic - Done
  2. Dynamic Colors
  3. Dynamic Layout - Hide Unhide CollectionView
  4. Expand Button Inside
  5. Image Thumbspread And Text Content
  6. Haptics And Animations
  */
 
 
 1. Middle And DragLines
 2. isSelected , Drag
 3. Long Press
 4. Expand Collapse
 5. Conidtioning For Parent And Page
 
 */


enum GestureHorizontalDirection {
    case Left , Right
}

enum GestureVerticalDirection {
    case Top , Bottom
}
extension UIPanGestureRecognizer {
    
    var horizontalDirection : GestureHorizontalDirection {
        let translation = self.translation(in: self.view)
               
               // Check the horizontal component of the translation
               if translation.x > 0 {
                   // Pan gesture is moving to the right
                   return .Right
               } else if translation.x < 0 {
                   // Pan gesture is moving to the left
                   return .Left
               }
                   return .Right
               
    }
    var verticalDirection : GestureVerticalDirection {
        let translation = self.translation(in: self.view)
               
               // Check the horizontal component of the translation
               if translation.y > 0 {
                   // Pan gesture is moving to the right
                   return .Top
               } else if translation.y < 0 {
                   // Pan gesture is moving to the left
                   return .Bottom
               }
                   return .Bottom
               
    }
    
}

