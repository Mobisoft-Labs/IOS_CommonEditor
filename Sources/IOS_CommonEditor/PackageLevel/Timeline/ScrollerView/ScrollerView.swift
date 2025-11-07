//
//  ContentView.swift
//  Gesture
//
//  Created by HKBeast on 10/02/24.
//

import Foundation
import UIKit
import Combine

class ScrollerView:UIScrollView{
   
    
    //MARK: - Variables


   
    weak var contentViewDelegate:CoponentViewDelegate?
     var rulerView:RulerView = {
         let view = RulerView()
//        view.backgroundColor = .red
        return view
    }()
    
    // demoView in which collectionView will add
     let rulingParent : ComponentView
    var model : BaseModel?
    // Content view within the scroll view
    let collectionView: ChildCollectionView

    var logger: PackageLogger?
    var timelineConfig: TimelineConfiguration?
    
     var endLineView:UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
         view.backgroundColor = .systemPink
        view.isHidden = true
        return view
    }()
     var startLineView:UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
         view.backgroundColor = .systemPink
        view.isHidden = true
        return view
    }()
    
//    @Published var isResetThumbImagePosition: Bool = false
    
    weak var timelineDelegate: TimelineViewDelegate?
    //MARK: - Init
    init( delegate : CoponentViewDelegate, timelineDelegate: TimelineViewDelegate, logger: PackageLogger?, timelineConfig: TimelineConfiguration?) {
        contentViewDelegate = delegate
        self.timelineDelegate = timelineDelegate
        self.logger = logger
        self.timelineConfig = timelineConfig
        rulingParent = ComponentView()
        collectionView = ChildCollectionView(delegate: delegate, timelineDelegate: timelineDelegate, logger: logger, timelineConfig: timelineConfig)
       // collectionView.backgroundColor = .green
        collectionView.translatesAutoresizingMaskIntoConstraints = false

         super.init(frame: .zero)
        setupUI()
    }
    
    func setRulingModel(rulingModel:ParentModel, pageStartTime: CGFloat) {
        model = rulingModel
        rulingParent.setModel(model: rulingModel,isRulingModel: true, pageStartTime: pageStartTime, timelineDelegate: timelineDelegate!, logger: logger, timelineConfig: timelineConfig)
        collectionView.setRulingModel(rulingModel: rulingModel, pageStartTime: pageStartTime)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        
//        updateSubViewFrame()
//        
//    }
    
    //MARK: - Private Method
    
     func setupUI(){
        
        //add views
         rulerView.setTimelineConfig(timelineConfig: timelineConfig)
        self.addSubview(rulerView)
        self.addSubview(rulingParent)
        self.addSubview(collectionView)
      //  self.addSubview(currentTimeLabel)
         self.addSubview(startLineView)
         self.addSubview(endLineView)
        rulingParent.delegate = contentViewDelegate
        rulingParent.setNeedsDisplay()
         collectionView.backgroundColor = timelineConfig?.collectionViewBGColor//UIColor(named: "editorBG")!
        collectionView.childComponentDelegate = contentViewDelegate
         
        collectionView.setNeedsDisplay()
     
        // Hide indicator
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        // Disable bouncing
        bounces = false
        
//        self.delegate = self
     
         
    
    }
    
    
}
