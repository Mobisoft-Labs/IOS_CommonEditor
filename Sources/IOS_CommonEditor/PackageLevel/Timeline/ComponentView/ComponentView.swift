//
//  ModelView.swift
//  Timelines
//
//  Created by HKBeast on 05/02/24.
//

import UIKit
import Photos
import Combine

protocol CoponentViewDelegate:AnyObject{
    func onTap(isSelected : Bool , model : BaseModel)
    func onLongPress(gesture: UILongPressGestureRecognizer, model: BaseModel, isScrollEnabled: inout Bool)
    func onPan(gesture: UIPanGestureRecognizer)
    func onTapExpand(timelineComponentModel:ParentModel)
    func onDragLeft(gesture:UIPanGestureRecognizer, model:BaseModel)
    func onDragRight(gesture:UIPanGestureRecognizer, model:BaseModel)
}

class DisplayView2 : UIView {
    
    
    
    lazy var imageView : UIImageView = {
        
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height))
        imageV.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        imageV.translatesAutoresizingMaskIntoConstraints = true
        imageV.contentMode = .scaleAspectFit

        return imageV
        
    }()
    
    var currentView : UIImageView?
    var origin: CGFloat = 0.0
    var offset: CGFloat = 0.0
    
// Hello
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.mySize
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func setImage(image:UIImage , tile : Bool = false ) {
        self.subviews.forEach({$0.removeFromSuperview()})
        addSubview(imageView)
//        currentView = imageView
        let patternImage = image.withRenderingMode(.alwaysTemplate)
       // let resizedImage = resizeImage(image: patternImage!, targetSize: CGSize(width: self.bounds.height, height: self.bounds.height))
        if tile {
            let image = UIImage(cgImage: patternImage.cgImage! , scale: 1, orientation: patternImage.imageOrientation)
            
            let resizedImage = resizeImage(image: image, targetSize: self.frame.size)

            imageView.backgroundColor = UIColor(patternImage: resizedImage!)
            imageView.image = nil

        }else{
            let image = UIImage(cgImage: patternImage.cgImage! , scale: 1, orientation: patternImage.imageOrientation)
            
            imageView.backgroundColor = .clear
            imageView.image = image
        }
    }
    
    func postionImageViewWithMiddleLineView(offSet: CGFloat, componentView: ComponentView){
        let origin = componentView.convert(self.frame.origin, to: self)
        var originX : CGFloat
        self.origin = origin.x
        self.offset = offSet
        
        if ((origin.x + imageView.frame.width) >= offSet){
            originX = origin.x
       
        }else{
            originX = min(offSet - imageView.frame.width, self.frame.width - imageView.frame.width)
           
        }
        imageView.frame = CGRect(x: originX, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        
        
        // Force layout update if necessary
        imageView.layoutIfNeeded()
    }
    

    override func layoutSubviews() {
        guard let image = imageView.image else { return }
            
            // Get the aspect ratio of the image
            let imageAspectRatio = image.mySize.width / image.mySize.height
            
            // Determine the frame of the parent view
            let parentWidth = self.frame.width
            let parentHeight = self.frame.height
            
            // Calculate the new size for the imageView based on the image's aspect ratio
            var imageViewWidth: CGFloat
            var imageViewHeight: CGFloat
            
            if imageAspectRatio >= 1 {
                // If the image is wider or square, fit it within the parent's width and adjust height
                imageViewWidth = min(parentWidth, parentHeight * imageAspectRatio)
                imageViewHeight = imageViewWidth / imageAspectRatio
            } else {
                // If the image is taller, fit it within the parent's height and adjust width
                imageViewHeight = parentHeight
                imageViewWidth = imageViewHeight * imageAspectRatio
            }
            
            // Ensure that the imageView does not exceed the parent's frame
            imageViewWidth = min(imageViewWidth, parentWidth)
            imageViewHeight = parentHeight
            
            
            // Set the imageView's frame
        var originX: CGFloat
        if ((origin + imageView.frame.width) >= offset){
            originX = origin
       
        }else{
            originX = min(offset - imageView.frame.width, self.frame.width - imageView.frame.width)
           
        }
            imageView.frame = CGRect(x: originX, y: 0, width: imageViewWidth, height: imageViewHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  addGesture()
      //  self.addSubview(imageView)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // addGesture()
      //  self.addSubview(imageView)
    }
    
    
}

extension ComponentView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture{
            print("is Scroll value: \(isScrollEnabled)")
            return !isScrollEnabled
        }
        return true
    }
    
}

//class DisplayView : UIView {
//    
//    
//    lazy var imageView : UIImageView = {
//        
//        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height))
//        imageV.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        imageV.translatesAutoresizingMaskIntoConstraints = true
//        imageV.contentMode = .scaleAspectFit
//        return imageV
//        
//    }()
//    
//    
//    lazy var label : UILabel = {
//        let imageV = UILabel(frame: self.bounds)
//        imageV.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        imageV.translatesAutoresizingMaskIntoConstraints = true
//        imageV.text = "Hello Jarvis"
//        return imageV
//    }()
//    
//    var currentView : UIView?
//    
//// Hello
//    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
//        let size = image.mySize
//        
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//        
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
//        
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(origin: .zero, size: newSize)
//        
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
//    
//    func setImage(image:UIImage , tile : Bool = false ) {
//        self.subviews.forEach({$0.removeFromSuperview()})
//        addSubview(imageView)
//        currentView = imageView
//        let patternImage = image.withRenderingMode(.alwaysTemplate)
//       // let resizedImage = resizeImage(image: patternImage!, targetSize: CGSize(width: self.bounds.height, height: self.bounds.height))
//        if tile {
//            let image = UIImage(cgImage: patternImage.cgImage! , scale: 1, orientation: patternImage.imageOrientation)
//            
//            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
//
//            imageView.backgroundColor = UIColor(patternImage: resizedImage!)
//            imageView.image = nil
//
//        }else{
//            let image = UIImage(cgImage: patternImage.cgImage! , scale: 1, orientation: patternImage.imageOrientation)
//            imageView.backgroundColor = .clear
//            imageView.image = image
//        }
//    }
//    
//    func setText(text:String) {
//        self.subviews.forEach({$0.removeFromSuperview()})
//        addSubview(label)
//        currentView = label
//        label.text = text
//        label.textColor = .black
//        currentView?.backgroundColor = .yellow
//    }
//
//    override func layoutSubviews() {
//        currentView?.frame = self.bounds.insetBy(dx: 0, dy: 0)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//      //  addGesture()
//      //  self.addSubview(imageView)
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//       // addGesture()
//      //  self.addSubview(imageView)
//    }
//    
//    
//}


class ComponentView: UIView {


    var panGesture: UIPanGestureRecognizer!
    var tap: UITapGestureRecognizer!

    var isScrollEnabled: Bool = false
//    var longPressGesture: UILongPressGestureRecognizer!
    
    lazy var displayView : DisplayView2 = {
        var displayView = DisplayView2(frame: self.frame)
        displayView.backgroundColor = .blue
        displayView.translatesAutoresizingMaskIntoConstraints = false
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        tap.delegate = self
        displayView.addGestureRecognizer(tap)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        displayView.addGestureRecognizer(longPressGesture)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
//        panGesture?.isEnabled = false
        panGesture.delegate = self
        
        displayView.addGestureRecognizer(panGesture)
        return displayView
    }()
   
    @objc func onLongPress(_ gesture : UILongPressGestureRecognizer) {
        delegate?.onLongPress(gesture: gesture, model: model!, isScrollEnabled: &isScrollEnabled)
    }
    
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        delegate?.onPan(gesture: gesture)
    }
    
    @objc func onTap(_ gesture : UITapGestureRecognizer) {
        guard model?.isActive == false else { return }
        //            guard TimelineConstants.isVerticalScrolling == false else { return }
        
        delegate?.onTap(isSelected: true, model: model!)
    }
    /// Button for right drag action
    var rightDragButton: DragView = {
        let btn = DragView(frame: .zero, image: UIImage(named: "right")!)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var leftDragButton: DragView = {
        let btn = DragView(frame: .zero, image: UIImage(named: "left")!)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5)
        return btn
    }()
    
   lazy var expandButton: ToggleButton = {
       let btn = ToggleButton(/*buttonTitle: "Expand", frame: .zero*/)
        btn.translatesAutoresizingMaskIntoConstraints = false
       btn.isHidden = true
        return btn
    }()
    


   weak var timelineDelegate: TimelineViewDelegate?
    // MARK: - Properties
    weak var delegate:CoponentViewDelegate?

    var model: BaseModel? // Model associated with this view

    // MARK: - Initializers
    override init(frame: CGRect) {
        
         super.init(frame: .zero)
        setupXIB()
       // displayView.backgroundColor = .clear
        setupUI()
    }
    var cancellables: Set<AnyCancellable> = []
    var isRulingModel : Bool = false
    var logger: PackageLogger?
    var timelineConfig: TimelineConfiguration?
    
    func setModel(model:BaseModel , isRulingModel : Bool = false, pageStartTime: CGFloat, timelineDelegate: TimelineViewDelegate, logger: PackageLogger?, timelineConfig: TimelineConfiguration?) {
        self.isRulingModel = isRulingModel
        self.timelineDelegate = timelineDelegate
        self.logger = logger
        self.timelineConfig = timelineConfig
        self.timelineDelegate?.updateThumbPostion(componentView: self)
        cancellables.removeAll()
       // onSelectView(isSelected: model.isSelected)
        
        if let parentModel = model as? ParentModel, parentModel.editState{
            self.frame = CGRect(x: (CGFloat(model.baseTimeline.startTime) + pageStartTime) * pointsPerSecond, y: 0, width: TimelineConstants.initialMargin + TimelineConstants.expandDragSpacing + TimelineConstants.expandDragSpacing + CGFloat(model.baseTimeline.duration) * pointsPerSecond, height: TimelineConstants.rulerHeight)
        }else{
            self.frame = CGRect(x: CGFloat(model.baseTimeline.startTime) * pointsPerSecond, y: 0, width: TimelineConstants.initialMargin + TimelineConstants.expandDragSpacing + TimelineConstants.expandDragSpacing + CGFloat(model.baseTimeline.duration) * pointsPerSecond, height: TimelineConstants.rulerHeight)
        }
       

//        self.frame.width =
        self.model = model
       
        
//        setDisplayColor(model: model)
        logger?.logVerbose("setModel \(model.modelType)")
        model.$isActive.removeDuplicates().sink { [weak self] isSelected in
            guard let self = self else { return }
               
            onSelectView(isSelected: isSelected)
        }.store(in: &cancellables)
        
        model.$thumbImage.sink { [weak self] image in
            logger?.logVerbose("thumb Image component \(model.modelType) : \(image)")
            guard let self = self else { return }
            displayView.imageView.image = image

        }.store(in: &cancellables)
        

        
    }
    
    
    func setFrame(startTime: CGFloat, duration: CGFloat, currentPPW: CGFloat){
        self.frame.origin.x = CGFloat(startTime) * currentPPW
        self.frame.size.width = (TimelineConstants.initialMargin + TimelineConstants.expandDragSpacing + TimelineConstants.expandDragSpacing + duration * currentPPW)
        
    }
    
    func setFrameRulingParent(startTime: CGFloat, duration: CGFloat, currentPPW: CGFloat, offsetX: CGFloat){
        self.frame.origin.x = (CGFloat(startTime) * currentPPW) + offsetX
        print("ST Neeshu Origin \(self.frame.origin.x)")
        self.frame.size.width = (TimelineConstants.initialMargin + TimelineConstants.expandDragSpacing + TimelineConstants.expandDragSpacing + duration * currentPPW)
        print("ST Neeshu Width \(self.frame.size.width)")
        
    }
    
    
    func setDisplayColor(model:BaseModel) {
        switch model.modelType {
        case .Parent:
           // displayView.setText(text: "Parent")
//            displayView.setImage(image: model.thumbImage)
            if let image = model.thumbImage{
                displayView.setImage(image: image)
            }
            
                displayView.backgroundColor = /*isRulingModel ? TimelineConstants.rulingParentBGColor :*/ TimelineConstants.parentModelColor
            

        case .Page:
          //  displayView.setText(text: "Page")
            if let image = model.thumbImage{
                displayView.setImage(image: image)
            }
            displayView.backgroundColor = isRulingModel ? TimelineConstants.rulingParentBGColor : TimelineConstants.parentModelColor

        case .Sticker :
            //if model is StickerInfo {
            if let image = model.thumbImage{
                displayView.setImage(image: image)
            }
                displayView.backgroundColor = TimelineConstants.stickerModelColor
           // }
        case .Text :
           // if model is TextInfo {
            if let image = model.thumbImage{
                displayView.setImage(image: image)
            }
                displayView.backgroundColor = TimelineConstants.textModelColor

                
               // displayView.setText(text: textModel.text)
           // }


        }
    }
    func onSelectView(isSelected:Bool) {
        guard let model = model else { return }
        // leftfDrag update as normal
        leftDragButton.isHidden = !isSelected
      //  expandButton.isHidden = !isSelected
        rightDragButton.isHidden = !isSelected
        
        setDisplayColor(model: model)
        if isSelected {
//            displayView.backgroundColor = ThemeManager.shared.accentColor
            
            if model.modelType == .Page{
                displayView.layer.borderColor = timelineConfig?.accentColor.cgColor//ThemeManager.shared.accentColor.cgColor
                displayView.layer.borderWidth = 2.0
                displayView.layer.cornerRadius = 5
            }else{
                if model.modelType == .Parent{
                    expandButton.isHidden = false
//                    if let parentModel = model as? ParentModel{
//                        if parentModel.editState{
//                            expandButton.setTitle("Collapse", for: .normal)
//                        }else{
//                            expandButton.setTitle("Expand", for: .normal)
//                        }
//                        
//                    }
                    if isRulingModel{
                        expandButton.setTitle("Collapse_".translate(), for: .normal)
                    }else{
                        expandButton.setTitle("Expand_".translate(), for: .normal)
                    }
                    
                    
                }else{
                    expandButton.isHidden = true
                }
                displayView.layer.borderColor = timelineConfig?.accentColor.cgColor//ThemeManager.shared.accentColor.cgColor
                displayView.layer.borderWidth = 2.0
                displayView.layer.cornerRadius = 0
            }
        }else{
//            setDisplayColor(model: model)
            displayView.layer.borderColor = UIColor.clear.cgColor
            displayView.layer.borderWidth = 0.0
            displayView.layer.cornerRadius = 5
            expandButton.isHidden = true
            
        }
       
        
        if  model is PageInfo { // Its Page
            
            expandButton.isHidden = true // hide expandButton
//            if model.baseTimeline.startTime == 0.0 {
                leftDragButton.isHidden = true // left drag hidden for first page
//            }

        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
    
       // model = TimelineComponentModel(modelType: .PARENT, thumbImage: nil, isSelected: false, children: [])
        super.init(coder: aDecoder)
        setupXIB()
       
    }
    
    // MARK: - Private Methods
    private func setupXIB() {
        let nib = UINib(nibName: "ComponentView", bundle: nil)
        if let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(contentView)
            contentView.backgroundColor = .clear
        }
    }
    
    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.frame.size.width = self.frame.width+160
        rightDragButton.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
        leftDragButton.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
    }

    override func draw(_ rect: CGRect) {
       
       
    }
    func addContraintLayout() {
        NSLayoutConstraint.activate([
            expandButton.widthAnchor.constraint(equalToConstant: 80),
            expandButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            expandButton.topAnchor.constraint(equalTo: self.topAnchor),
            expandButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        // Left Drag Button Constraints
        NSLayoutConstraint.activate([
            leftDragButton.widthAnchor.constraint(equalToConstant: 20),
            leftDragButton.leadingAnchor.constraint(equalTo: expandButton.trailingAnchor, constant: 20),
            leftDragButton.topAnchor.constraint(equalTo: self.topAnchor),
            leftDragButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        // Right Drag Button Constraints
        NSLayoutConstraint.activate([
            rightDragButton.widthAnchor.constraint(equalToConstant: 20),
            rightDragButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            rightDragButton.topAnchor.constraint(equalTo: self.topAnchor),
            rightDragButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        // Display View Constraints
        NSLayoutConstraint.activate([
            displayView.leadingAnchor.constraint(equalTo: leftDragButton.trailingAnchor),
            displayView.trailingAnchor.constraint(equalTo: rightDragButton.leadingAnchor)
        ])

        // Optionally, add top and bottom constraints to displayView if needed
         displayView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         displayView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
    
      //  self.displayView.frame.size.width = CGFloat(model?.width ?? 0.0)
        
        
      //  expandButton.isHidden = true
        leftDragButton.isHidden = true
        rightDragButton.isHidden = true
        rightDragButton.setUpTimelineConfig(timelineConfig: timelineConfig)
        leftDragButton.setUpTimelineConfig(timelineConfig: timelineConfig)
        addSubview(expandButton)
        addSubview(leftDragButton)
        addSubview(displayView)
        addSubview(rightDragButton)
        
       addContraintLayout()
                
        expandButton.toggleCompletion = { [weak self] isExpanded in
            
            guard let self = self else { return }

            if let parentModel = model as? ParentModel {
                delegate?.onTapExpand(timelineComponentModel: parentModel)
            }
       
        }

        leftDragButton.panCompletion = { [weak self] gesture in
            guard let self = self else { return }
//            self.leftPanCompletion?(gesture, self.model)
            delegate?.onDragLeft(gesture: gesture, model: self.model!)
            
        }

        rightDragButton.panCompletion = { [weak self] gesture in
            guard let self = self else { return }
//            self.rightPanCompletion?(gesture, self.model)
            delegate?.onDragRight(gesture: gesture, model: self.model!)
        }
        
    }

    func isSelectedDisplayUpdate() {
        expandButton.show()
        leftDragButton.show()
        rightDragButton.show()
        displayViewHighlight()
    }

    func isDeSelectedDisplayUpdate() {
        
        expandButton.hide()
        leftDragButton.hide()
        rightDragButton.hide()
        displayViewUnHighlight()
        
    }

    func displayViewHighlight() {
        
        displayView.layer.borderWidth = 2
        displayView.layer.borderColor = UIColor.blue.cgColor
        
    }

    func displayViewUnHighlight() {
        
        displayView.layer.borderWidth = 0
        displayView.layer.borderColor = UIColor.green.cgColor
        
    }
}
