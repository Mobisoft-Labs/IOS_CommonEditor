//
//  ChildCollectionView.swift
//  Timelines
//
//  Created by HKBeast on 05/02/24.
//

import Foundation
import UIKit
var dataModel = [UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785"),UIImage(named: "IMG_6785")]


class ChildCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @Published var isResetThumbImagePosition: Bool = false
    
    var onToggleCompletion: (() -> ())?
    var onLeftPanCompletion: (() -> ())?
    var onRightPanCompletion: (() -> ())?
//    var componentViewDelegate:collectionDelegate?
  weak var childComponentDelegate:CoponentViewDelegate?
    var rulingModel : ParentModel?
   weak var timelineDelegate: TimelineViewDelegate?
    var currentIndex: IndexPath?
    var pageStartTime: CGFloat?
    var logger: PackageLogger?
    var timelineConfig: TimelineConfiguration?
    
    init(delegate:CoponentViewDelegate, timelineDelegate: TimelineViewDelegate, logger: PackageLogger?, timelineConfig: TimelineConfiguration?) {
        self.childComponentDelegate = delegate
        self.timelineDelegate = timelineDelegate
        self.logger = logger
        self.timelineConfig = timelineConfig
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
    }
    
    func setRulingModel(rulingModel:ParentModel, pageStartTime: CGFloat) {
        self.rulingModel = rulingModel
        self.pageStartTime = pageStartTime
        reloadData()
    }
    
    func updateFrames(){
        self.collectionViewLayout.invalidateLayout()
        self.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCollectionView() {
        // Set up the collection view layout, register cells, etc.
        
        let nib = UINib(nibName: "ChildCVCell", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "cell")
        // e.g., registerNib, set collectionViewLayout, etc.
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rulingModel?.activeChildren.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChildCVCell

        let childModel = rulingModel!.activeChildren[indexPath.item]
        cell.configure(indexPath: indexPath, model: childModel, delegate: childComponentDelegate, timelineDelegate: timelineDelegate!, pageStartTime: pageStartTime ?? 0, logger: logger, timelineConfig: timelineConfig)
        cell.componentView.tap.delaysTouchesBegan = true
        cell.componentView.tap.cancelsTouchesInView = false
        cell.componentView.tap.require(toFail: collectionView.panGestureRecognizer)


        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChildCVCell {
            let childModel = rulingModel!.activeChildren[indexPath.item]
           // cell.isSelectedCell(indexPath: indexPath, model: childModel)
        }
        // Handle other didSelect actions
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChildCVCell {
            
            let childModel = rulingModel!.activeChildren[indexPath.item]
            
           // cell.isDeSelectwdCell(indexPath: indexPath, model: childModel)
            
        }
        // Handle other didDeselect actions
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return CGSize representing the size of the cell at the specified indexPath
        
        let width = collectionView.frame.width // Use collectionView's width
        
        let height: CGFloat = TimelineConstants.rulerHeight // Set the height as per your requirement
        
        return CGSize(width: width, height: height)
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("Timeline collection view in begin dragging")
//        
//    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Timeline collection view in continuous dragging")
        isResetThumbImagePosition = true
        TimelineConstants.isVerticalScrolling = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("Timeline collection view in will end dragging")
        TimelineConstants.isVerticalScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        analyticsLogger.logEditorInteraction(action: .timelineScrolled)
        timelineConfig?.logTimelineScrolled()
        print("Timeline collection view in end dragging")
        TimelineConstants.isVerticalScrolling = false
    }
    
}
