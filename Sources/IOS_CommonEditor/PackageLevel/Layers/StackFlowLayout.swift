//
//  StackFlowLayout.swift
//  Tree
//
//  Created by IRIS STUDIO IOS on 31/12/23.
//

import UIKit




 // if Parent Node of source and destination is same
 func nodeTransferInSameParent(sourceIndex:IndexPath,destinationIndex:IndexPath,ParentNode:BaseModel){
 // it change the order
 // source sequence = destination Sequence
 //destination Sequence = Source sequence
 // remove from parent of Source sequence
 // add in parent at destination sequencce
 
 }
 
 // if Parent Node Is not Same But level is same
 
func nodeTransferInDiffrentParent(SourceIndex:IndexPath,destinationIndex:IndexPath,DestinationParentNode:BaseModel,order:Int){
    // get SourceNode of sourceIndex
    // remove node from SourceNodeParent
    // add Node in destinationParentNode at order
}
 
// if ParentNode is not same but sourceLevel is less then destination level
 
 





protocol StackedCollectionViewDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didBeginDraggingItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, sourceIndex : IndexPath ,didEndDraggingItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView,sourceIndex : IndexPath,didEndDraggingItemAt destinationIndexPath: IndexPath,destinationParentNode:Int?,atWhich order:Int,sourceNode:BaseModel)
    func getFlattenTree() -> [BaseModel]
    func getSelectedTree(node:BaseModel)->[Int]
}

class StackedVerticalFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate, UICollectionViewDelegate {
    
    weak var delegate: StackedCollectionViewDelegate?
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var selectedItemIndexPath: IndexPath?
    private var snapshot: UIView?
    private var touchOffset: CGPoint?
    private var cellAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    let cellSize = CGSize(width: 0, height: 60)  // Set your cell size
   // var delegate : CustomLayoutDelegate?

    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    override func prepare() {
        guard let collectionView = collectionView else { return }
        itemSize = cellSize
        cellAttributes.removeAll()
        
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var maxWidth = CGFloat.zero
        var maxX = CGFloat.zero

        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                var width = collectionView.frame.width
                xOffset = 0
//                if indexPath.item == 4 {
//                    width = cellSize.width * 1.5
//                    xOffset = 50
//                }
//                if indexPath.item == 5 {
//                    width = cellSize.width * 1.6
//                    xOffset = 60
//                }
//
                var rowHeight = cellSize.height
                if let layers = delegate?.getFlattenTree() {
                    if item >= 0 && item < layers.count {
                        let node = layers[item]
                        width = collectionView.frame.width
                        xOffset = CGFloat((node.depthLevel - 1) * 50)
                    }
                }
                
                maxWidth = max(maxWidth, width)
                maxX = max(maxX , xOffset)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: width*0.7, height: rowHeight)

                cellAttributes.append(attributes)

               // xOffset += cellSize.width
                yOffset += rowHeight
            }

//            xOffset = 0

        }
            
        contentSize = CGSize(width:maxX + maxWidth  , height: yOffset + 60)
    }
    
    func setPackageLogger(logger: PackageLogger, layersConfig: LayersConfiguration){
        self.logger = logger
        self.layersConfig = layersConfig
    }
    
    func addGesture() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer.isEnabled = true
        
        longPressGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
        
        if let collectionViewGestureRecognizers = self.collectionView!.gestureRecognizers {
            for case let gestureRecognizer as UILongPressGestureRecognizer in collectionViewGestureRecognizers {
                gestureRecognizer.require(toFail: longPressGestureRecognizer!)
            }
        }
       
        collectionView?.addGestureRecognizer(longPressGestureRecognizer)
        collectionView?.addGestureRecognizer(panGestureRecognizer)
        collectionView?.setContentOffset(.zero, animated: false)
        
        collectionView?.addSubview(dropHereView)
        collectionView?.addSubview(dropDetailView)
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes.filter { rect.intersects($0.frame) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath.item]
    }
    
    private func initialize() {
      
      //  sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)

    }
    
    var cellCenter : CGPoint?
    var needToExpand : Bool = false
    var sourceNode:BaseModel?
    var destinationNodeID:Int?
    var order:Int = 0
    var destinationIndexpath = IndexPath(item: 0, section: 0)
    var selectedNodes = [-1]
    var selectedCell : LayerCell?
    var engine:MetalEngine?
    var logger: PackageLogger?
    var layersConfig: LayersConfiguration?
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        logger?.logVerbose("LongPressGesture : \(gesture.state)")
        
        switch gesture.state {
        case .began:
            
          
           selectionVibrate()
            
            collectionView?.isScrollEnabled = false
            guard let indexPath = collectionView?.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            lastTouchPoint = gesture.location(in: collectionView)
            // remove all index which is selected
            deselectAllItems()
            selectedItemIndexPath = indexPath
            
          
            delegate?.collectionView(collectionView!, didBeginDraggingItemAt: indexPath)
            
            guard let cell = collectionView?.cellForItem(at: indexPath) as? LayerCell else { return }
            destinationNodeID = cell.node.parentId
            order = cell.node.orderInParent
            print("[LayersV1][LongPressBegin] destinationNodeID=\(String(describing: destinationNodeID))")
            dropHereView.frame.size.width = cell.frame.width
            dropHereView.frame.origin =  cell.frame.origin
            syncDropIndicatorView()
            syncDropIndicatorView()
            selectedCell = cell
            sourceNode = cell.node
            if let value = delegate?.getSelectedTree(node: cell.node){
                selectedNodes = value
            }
            touchOffset = gesture.location(in: collectionView)
            if let parentNode = cell.node as? ParentModel , parentNode.isExpanded {
                needToExpand = true
                if let cv = collectionView as? CustomCollectionView {
                    parentNode.isExpanded = false
                   // cv.viewModel.isEditParent = false
                    cv.onCellExpand(modelId: parentNode.modelId, expand: false)

                   // cv.expandCollapse(cell: cell)
                }
            }else{
                needToExpand = false
            }
//            cell.subviews.forEach({$0.isHidden = true })
//            cell.backgroundColor = .systemPink
           
            snapshot = cell.snapshotView(afterScreenUpdates: false)
            snapshot?.center = cell.center
            snapshot?.alpha = 0.0
            snapshot?.backgroundColor = .white
            snapshot?.layer.borderWidth = 0
            snapshot?.layer.cornerRadius = 0

           // snapshot?.layer.borderColor = UIColor.green.cgColor
            collectionView?.addSubview(snapshot!)
            cellCenter = cell.center
            
            UIView.animate(withDuration: 0.3) { [self] in
                self.snapshot?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                snapshot?.alpha = 0.5
                snapshot?.layer.cornerRadius = 5
                snapshot?.backgroundColor = layersConfig?.accentColorUIKit
                updateSnapshotPosition(gesture)
                cell.isHidden = true
                cell.backgroundColor = .clear
            }
            
        case .changed:
            
            updateSnapshotPosition(gesture)
           updateAutoScroll(gesture)
            
        case .ended, .cancelled:
          
            autoScrollYtimer?.invalidate()
            autoScrollXtimer?.invalidate()

            endDragging(gesture)
            // remove all selected index
            deselectAllItems()
            // select the current new index
            
            
        default:
            break
        }
    }
    
    
   private func deselectAllItems() {
       if let selectedItems = collectionView?.indexPathsForSelectedItems {
              for indexPath in selectedItems {
                  collectionView?.deselectItem(at: indexPath, animated: false)
              }
          }
      }
    
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        logger?.logVerbose("Layers - PanGesture : \(gesture.state)")

        guard let snapshot = snapshot else {
            logger?.logError("No Snapshot")
            dropHereView.isHidden = true
            collectionView?.isScrollEnabled = true
            return
        }
        
        switch gesture.state {
        case .changed:
            dropHereView.isHidden = useDetailedDropView
            dropDetailView.isHidden = !useDetailedDropView
            updateSnapshotPosition(gesture)
            updateAutoScroll(gesture)
            inDragging(gesture)
        case .ended, .cancelled:
            endDragging(gesture)
            dropHereView.isHidden = true
            dropDetailView.isHidden = true
            collectionView?.isScrollEnabled = true
        default:
            break
        }
    }
    
    private func updateSnapshotPosition(_ gesture: UIGestureRecognizer) {
        guard let snapshot = snapshot, let touchOffset = touchOffset  , let initialCenter = cellCenter else { return }
        
        let location = gesture.location(in: collectionView)
        lastTouchPoint = location
        
        let deltaX = location.x - touchOffset.x
        let deltaY = location.y - touchOffset.y

        snapshot.center = CGPoint(x:   location.x, y: location.y)

    }
    var autoScrollYtimer : Timer?
    var autoScrollXtimer : Timer?

    private func updateAutoScroll(_ gesture: UIGestureRecognizer) {
        guard let collectionView = collectionView, let snapshot = snapshot else { return }
        
        // Adjust the scroll speed by changing the duration value
        let scrollAnimationDuration: TimeInterval = 0.2
        autoScrollYtimer?.invalidate()
        autoScrollXtimer?.invalidate()
        
        let dragFrame = snapshot.frame

        let minYLimit: CGFloat = 0
        let maxYLimit: CGFloat = max(0,collectionView.contentSize.height - collectionView.bounds.height)
        let minXLimit: CGFloat = 0
        let maxXLimit: CGFloat = max(0,collectionView.contentSize.width - collectionView.bounds.width)
        let yThreshold = snapshot.frame.height / 4
        let xThreshold: CGFloat = 0

        if dragFrame.minY < collectionView.bounds.minY + yThreshold {
            if  collectionView.contentOffset.y  > minYLimit {
                logger?.logVerbose("Can Scroll Offset In Y ")

                // Scroll up
                if collectionView.contentOffset.y < minYLimit {
                    let contentOffset = CGPoint(x: collectionView.contentOffset.x, y: 0)
                    collectionView.setContentOffset(contentOffset, animated: false)
                } else {
                    autoScrollYtimer?.invalidate()
                    autoScrollYtimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer_ in
                        
                        let contentOffset = CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y - 1)
                        collectionView.setContentOffset(contentOffset, animated: false)
                        snapshot.center.y -= 1
                        
                        if collectionView.contentOffset.y  <= minYLimit {
                            timer_.invalidate()
                        }
                    })
                }
            }
        } else if dragFrame.maxY > collectionView.bounds.maxY - yThreshold {
            if maxYLimit != 0 && collectionView.contentOffset.y  < maxYLimit {
                
                logger?.logVerbose("Can Scroll Offset In Y ")
                // Scroll down
                if collectionView.contentOffset.y > maxYLimit {
                    let contentOffset = CGPoint(x: collectionView.contentOffset.x, y: maxYLimit)
                    collectionView.setContentOffset(contentOffset, animated: false)
                } else {
                    autoScrollYtimer?.invalidate()
                    autoScrollYtimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer_ in
                        
                        let contentOffset = CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y + 1)
                        collectionView.setContentOffset(contentOffset, animated: false)
                        snapshot.center.y += 1

                        if collectionView.contentOffset.y  >= maxYLimit {
                            timer_.invalidate()
                        }
                        
                    })
                }
            }
        }

        

        // Handling for X direction
        if dragFrame.minX < collectionView.bounds.minX + xThreshold {
            // Scroll left
            if  collectionView.contentOffset.x  > minXLimit {
                logger?.logVerbose("Can Scroll Offset In X ")

                if collectionView.contentOffset.x < minXLimit {
                    let contentOffset = CGPoint(x: 0, y: collectionView.contentOffset.y)
                    collectionView.setContentOffset(contentOffset, animated: false)
                } else {
                    autoScrollXtimer?.invalidate()
                    autoScrollXtimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer_ in
                        self.logger?.logVerbose("AutoScroll X Left \(collectionView.contentOffset.x)")

                        let contentOffset = CGPoint(x: collectionView.contentOffset.x - 1, y: collectionView.contentOffset.y)
                        collectionView.setContentOffset(contentOffset, animated: false)
                        if collectionView.contentOffset.x  <= minXLimit {
                            timer_.invalidate()
                        }
                    })
                }
            }
        } else if dragFrame.maxX > collectionView.bounds.maxX - 10 {
            // Scroll right
            if  collectionView.contentOffset.x  < maxXLimit {
                logger?.logVerbose("Can Scroll Offset In X ")

                if collectionView.contentOffset.x > maxXLimit {
                    let contentOffset = CGPoint(x: maxXLimit, y: collectionView.contentOffset.y)
                    collectionView.setContentOffset(contentOffset, animated: false)
                } else {
                    autoScrollXtimer?.invalidate()
                    autoScrollXtimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer_ in
                        self.logger?.logVerbose("AutoScroll X Rght \(collectionView.contentOffset.x)")
                        let contentOffset = CGPoint(x: collectionView.contentOffset.x + 1, y: collectionView.contentOffset.y)
                        collectionView.setContentOffset(contentOffset, animated: false)
                        
                        if collectionView.contentOffset.x  >= maxXLimit {
                            timer_.invalidate()
                        }
                        
                    })
                    }
            }
        }


    }
    

    
    
    var isHovering = false
    var destinationX:Float?
    var destinationY:Float?
    var destinationNode:BaseModel?
    var dropGapHeight: CGFloat = 40
    var useDetailedDropView = false {
        didSet {
            dropHereView.isHidden = useDetailedDropView
            dropDetailView.isHidden = !useDetailedDropView
            syncDropIndicatorView()
        }
    }
    enum DragCoordinateSource {
        case origin
        case center
        case touchPoint
    }
    var dragHitTestXSource: DragCoordinateSource = .origin
    var dragHitTestYSource: DragCoordinateSource = .center
    private var lastTouchPoint: CGPoint?

    private func dragHitPoint(_ draggedCell: UIView) -> CGPoint {
        let x: CGFloat
        let y: CGFloat
        switch dragHitTestXSource {
        case .origin:
            x = draggedCell.frame.origin.x
        case .center:
            x = draggedCell.center.x
        case .touchPoint:
            x = lastTouchPoint?.x ?? draggedCell.frame.origin.x
        }
        switch dragHitTestYSource {
        case .origin:
            y = draggedCell.frame.origin.y
        case .center:
            y = draggedCell.center.y
        case .touchPoint:
            y = lastTouchPoint?.y ?? draggedCell.frame.origin.y
        }
        return CGPoint(x: x, y: y)
    }

    private func findNodeById(_ modelId: Int) -> BaseModel? {
        delegate?.getFlattenTree().first(where: { $0.modelId == modelId })
    }

    private func cellForNodeId(_ modelId: Int) -> LayerCell? {
        guard let collectionView = collectionView else { return nil }
        for cell in collectionView.visibleCells {
            guard let layerCell = cell as? LayerCell else { continue }
            if layerCell.node.modelId == modelId {
                return layerCell
            }
        }
        return nil
    }

       private func lastDescendantFrame(for parentId: Int) -> CGRect? {
        guard let layers = delegate?.getFlattenTree(),
              let parentIndex = layers.firstIndex(where: { $0.modelId == parentId }) else { return nil }
        let parentDepth = layers[parentIndex].depthLevel
        var lastIndex = parentIndex
        var idx = parentIndex + 1
        while idx < layers.count {
            let node = layers[idx]
            if node.depthLevel <= parentDepth { break }
            lastIndex = idx
            idx += 1
        }
        let indexPath = IndexPath(item: lastIndex, section: 0)
        print("[LayersV1][OutsideCells] lastDescendantFrame parent=\(parentId) lastIndex=\(lastIndex)")
        return collectionView?.layoutAttributesForItem(at: indexPath)?.frame
    }
    
    private func inDragging(_ gesture : UIGestureRecognizer) {
//        destinationNode = nil
        guard let draggedCell = snapshot, let collectionView = collectionView else { return }
        let hitPoint = dragHitPoint(draggedCell)
        if let indexPath = collectionView.indexPathForItem(at: hitPoint),
           let cell = collectionView.cellForItem(at: indexPath) as? LayerCell {
            handleDragOnCell(at: indexPath, draggedCell: draggedCell)
            return
        }

        handleDragOutsideCells(at: hitPoint)

    }

    private func handleDragOnCell(at indexPath: IndexPath, draggedCell: UIView) {
        guard let collectionView = collectionView,
              let cell = collectionView.cellForItem(at: indexPath) as? LayerCell else { return }

        if handleHovering(cell, draggedCell: draggedCell, indexPath: indexPath) {
            return
        }

        let bottomCell = collectionView.cellForItem(at: IndexPath(item: indexPath.item + 1, section: indexPath.section)) as? LayerCell
        let upperCell = collectionView.cellForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section)) as? LayerCell

        if cell.node.modelId == sourceNode?.modelId {
            return
        }

        if indexPath.item == 0, let lowerCell = bottomCell {
            handleFirstItem(cell, draggedCell: draggedCell, indexPath: indexPath, lowerCell: lowerCell)
        } else if let lowercell = bottomCell, let topCell = upperCell {
            handleNonFirstItem(cell, draggedCell: draggedCell, indexPath: indexPath, lowerCell: lowercell, topCell: topCell)
        } else if bottomCell == nil, let topCell = upperCell {
            handleLastItem(cell, draggedCell: draggedCell, indexPath: indexPath, topCell: topCell)
        }
    }

    private func handleDragOutsideCells(at hitPoint: CGPoint) {
        guard let collectionView = collectionView else { return }
        logger?.printLog("[LayersV1] drag outside cells hit=\(hitPoint)")

        destinationX = Float(hitPoint.x)
        if let node = destinationNode {
            let minBand = node.depthLevel * 40
            let maxBand = (node.depthLevel + 1) * 40
            if (Int(Float(hitPoint.x)) >= minBand && Int(Float(hitPoint.x)) <= maxBand) {
                logger?.printLog("[LayersV1] drag outside cells keep band node=\(node.modelId) band=\(minBand)-\(maxBand)")
                // Still within the same depth band; keep the last destination.
                return
            }
        }

        for i in stride(from: hitPoint.y, to: 0 as CGFloat, by: -1 as CGFloat) {
            if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: hitPoint.x, y: i)) {
                guard let cell = collectionView.cellForItem(at: indexPath) as? LayerCell,
                      let targetNode = cell.node else { return }
                var resolvedParentId = targetNode.parentId
                var resolvedOrder = targetNode.orderInParent + 1
                var resolvedIndentX = cell.frame.minX
                var dropAnchorFrame: CGRect? = cell.frame
                let outdentThresholdX = cell.frame.minX - 20
                print("[LayersV1][OutsideCells] hitX=\(hitPoint.x) cellMinX=\(cell.frame.minX) threshold=\(outdentThresholdX)")
                if /*hitPoint.x < outdentThresholdX,*/
                   let parentNode = findNodeById(targetNode.modelId) {
                    resolvedParentId = parentNode.parentId
                    resolvedOrder = parentNode.orderInParent + 1
                    resolvedIndentX = CGFloat((parentNode.depthLevel - 1) * 50)
                    dropAnchorFrame = lastDescendantFrame(for: parentNode.modelId) ??
                        cellForNodeId(parentNode.modelId)?.frame ??
                        cell.frame
                    print("[LayersV1][OutsideCells] dropAnchorFrame : \(dropAnchorFrame)")

                }
                destinationNodeID = resolvedParentId
                print("[LayersV1] drag outside cells resolve parent=\(resolvedParentId) order=\(resolvedOrder) indentX=\(resolvedIndentX)")
                let anchorFrame = dropAnchorFrame ?? cell.frame
                dropHereView.frame.size.width = anchorFrame.width
                dropHereView.frame.origin = CGPoint(x: resolvedIndentX, y: anchorFrame.maxY - dropHereView.frame.height)
                syncDropIndicatorView()
                destinationNode = targetNode
                order = resolvedOrder

                if let parentNode = targetNode as? ParentModel {
                    destinationIndexpath = IndexPath(item: indexPath.item + parentNode.children.count, section: 0)
                    print("[LayersV1][OutsideCells] destinationIndexpath updated for parent \(cell.node.modelId)")
                }
                break
            }
        }
    }
    
    
    
    
    private func handleHovering(_ cell: LayerCell, draggedCell: UIView, indexPath: IndexPath) -> Bool {
        // Handle hovering logic here
        // ...
        let hitPoint = dragHitPoint(draggedCell)
        if !cell.frame.contains(hitPoint) {return false}
        guard let cv = self.collectionView as? CustomCollectionView else{return false}
        if let _ = selectedNodes.firstIndex(where: {$0 == cell.node.modelId }){
            return false
        }
        else if let parentNode = cell.node as? ParentModel  {
            let expandThresholdX = cell.frame.minX + 40
            if parentNode.isExpanded == false {
                if hitPoint.y >= cell.center.y && hitPoint.y <= cell.frame.maxY {
                    logger?.printLog("handleHovering - Eligible For Expnsaion Y")
                    if hitPoint.x >= expandThresholdX && hitPoint.x <= cell.frame.maxX {
                        logger?.printLog("handleHovering - Eligible For Expnsaion X")
                        logger?.printLog("handleHovering - Expanding Parent")
                        cv.onCellExpand(modelId: parentNode.modelId, expand: true)
                        parentNode.isExpanded = true
                        blinkParentCell(cell)
                    }
                }
            } else {
                if hitPoint.y >= cell.frame.minY && hitPoint.y < cell.center.y {
                    logger?.printLog("handleHovering - Eligible For collapsing Y")
                    if hitPoint.x >= cell.frame.minX &&  hitPoint.x <= cell.frame.maxX {
                        logger?.printLog("handleHovering - Eligible For Collapsing X")
                        cv.onCellExpand(modelId: parentNode.modelId, expand: false)
                        logger?.printLog("handleHovering - Collapsing Parent")
                        parentNode.isExpanded = false
                    }
                } else if hitPoint.y >= cell.center.y && hitPoint.y <= cell.frame.maxY {
                    logger?.printLog("handleHovering - Eligible For collapsing Y")
                    if hitPoint.x >= cell.frame.minX && hitPoint.x <= expandThresholdX {
                        logger?.printLog("handleHovering - Eligible For collapsing X")
                        cv.onCellExpand(modelId: parentNode.modelId, expand: false)
                        logger?.printLog("handleHovering - Collapsing Parent")
                        parentNode.isExpanded = false
                    }
                }
            }
        }
      
        return false
    }

    private func blinkParentCell(_ cell: LayerCell) {
        UIView.animate(withDuration: 0.08, animations: {
            cell.contentView.alpha = 0.4
        }, completion: { _ in
            UIView.animate(withDuration: 0.12) {
                cell.contentView.alpha = 1.0
            }
        })
    }

    private func handleFirstItem(_ cell: LayerCell, draggedCell: UIView, indexPath: IndexPath,lowerCell:LayerCell) {
        
        if draggedCell.frame.midY < cell.frame.midY{
            // order will be zero
            // indexpath will be zero
            // parent will be parent of cell.node.parent
            destinationNodeID = cell.node.parentId
            print("[LayersV1][FirstItem][Above] destinationNodeID=\(String(describing: destinationNodeID))")
            dropHereView.frame.size.width = cell.frame.width
            dropHereView.frame.origin =  cell.frame.origin
//            destinationNodeID = cell.node.nodeID
            order = 0
            destinationIndexpath = indexPath
            //print("place indexPath",indexPath.item)
        }
        else{
            // confirm destinationPath will be 1
            destinationIndexpath = IndexPath(item: indexPath.item+1, section: indexPath.section)
            //if lower cell is sibling
            if lowerCell.node.depthLevel == cell.node.depthLevel{
                order = cell.node.orderInParent+1
                destinationNodeID = cell.node.parentId
//                // ui blue line
//                dropHereView.frame.size.width = cell.frame.width
//                dropHereView.frame.origin =  CGPoint(x: cell.frame.minX, y: cell.frame.maxY-dropHereView.frame.height)
                
            }
            //lower cell is child
            else if lowerCell.node.depthLevel > cell.node.depthLevel{
                order = 0
                destinationNodeID = cell.node.modelId
//                // ui blue line
//                dropHereView.frame.size.width = cell.frame.width
//                dropHereView.frame.origin =  cell.frame.origin
            }
        
            // ui blue line
            dropHereView.frame.size.width = lowerCell.frame.width
            dropHereView.frame.origin =  lowerCell.frame.origin
            syncDropIndicatorView()
        }
    }

    private func handleNonFirstItem(_ cell: LayerCell, draggedCell: UIView, indexPath: IndexPath,lowerCell:LayerCell,topCell:LayerCell) {
        // Handle logic for items other than the first
        // ...
//        print("place indexPath",indexPath.item)
       
        if indexPath.item>selectedItemIndexPath!.item{
          
            if draggedCell.frame.midY < cell.frame.midY{
                
                // order will be zero
                // indexpath will be zero
//                 parent will be parent of cell.node.parent
               // print("place indexPath",indexPath.item-1)
                destinationNodeID = cell.node.parentId
                order = cell.node.orderInParent
                destinationIndexpath = IndexPath(item: indexPath.item-1, section: indexPath.section)
                print("[LayersV1][NonFirstItem][Above] destinationNodeID=\(String(describing: destinationNodeID))")
                // ui blue line
                dropHereView.frame.size.width = cell.frame.width
                dropHereView.frame.origin =  cell.frame.origin
                syncDropIndicatorView()
                
            }
            else{
                // order will
               // print("place indexPath",indexPath.item)
                destinationNodeID = cell.node.parentId
                order = cell.node.orderInParent+1
                destinationIndexpath = indexPath
                print("[LayersV1][NonFirstItem][Below] destinationNodeID=\(String(describing: destinationNodeID))")
                
                if lowerCell.node.depthLevel>cell.node.depthLevel{
                    destinationNodeID = cell.node.modelId
                    order = 0
                    destinationIndexpath = indexPath
                print("[LayersV1][NonFirstItem][IntoParent] destinationNodeID=\(String(describing: destinationNodeID))")
                }
                
                
                // ui blue line
                if lowerCell.node.depthLevel<cell.node.depthLevel{
                    dropHereView.frame.size.width = cell.frame.width
                    dropHereView.frame.origin =  CGPoint(x: cell.frame.minX, y: cell.frame.maxY-dropHereView.frame.height)
                }else if let parentNode = cell.node as? ParentModel ,  parentNode.children.isEmpty{
                    order = 0
                    destinationNodeID = cell.node.modelId
                    dropHereView.frame.size.width = lowerCell.frame.width
                    dropHereView.frame.origin =  CGPoint(x: lowerCell.frame.minX+40, y: lowerCell.frame.minY)
                }
                
                else{
                    dropHereView.frame.size.width = lowerCell.frame.width
                    dropHereView.frame.origin =  lowerCell.frame.origin
                }
                syncDropIndicatorView()
                
                
            }
            
            
        }else{
           
            if draggedCell.frame.midY < cell.frame.midY{
                // order will be zero
                // indexpath will be zero
                // parent will be parent of cell.node.parent
                order = cell.node.orderInParent
                destinationIndexpath = indexPath
                destinationNodeID = cell.node.parentId
                // ui blue line
                dropHereView.frame.size.width = cell.frame.width
                dropHereView.frame.origin =  cell.frame.origin
                syncDropIndicatorView()
               // print("place indexPath",indexPath.item)
            }
            else{
                // order will
               // print("place indexPath",indexPath.item+1)
                order = cell.node.orderInParent+1
                destinationNodeID = cell.node.parentId
                destinationIndexpath = IndexPath(item: indexPath.item+1, section: indexPath.section)
                if lowerCell.node.depthLevel>cell.node.depthLevel{
                    destinationNodeID = cell.node.modelId
                    order = 0
                    destinationIndexpath = IndexPath(item: indexPath.item+1, section: indexPath.section)
                    print("[LayersV1][NonFirstItem][IntoParent] destinationNodeID=\(String(describing: destinationNodeID))")
                    
                }
                
                // ui blue line
                if lowerCell.node.depthLevel<cell.node.depthLevel{
                    dropHereView.frame.size.width = cell.frame.width
                    dropHereView.frame.origin =  CGPoint(x: cell.frame.minX, y: cell.frame.maxY-dropHereView.frame.height)
                }else if let parentNode = cell.node as? ParentModel , parentNode.children.isEmpty{
                    order = 0
                    destinationNodeID = cell.node.modelId
                    dropHereView.frame.size.width = lowerCell.frame.width
                    dropHereView.frame.origin =  CGPoint(x: lowerCell.frame.minX+40, y: lowerCell.frame.minY)
                }
                
                else{
                    dropHereView.frame.size.width = lowerCell.frame.width
                    dropHereView.frame.origin =  lowerCell.frame.origin
                }
                syncDropIndicatorView()
            }
            
        }
        

    }
    private func handleLastItem(_ cell: LayerCell, draggedCell: UIView, indexPath: IndexPath,topCell:LayerCell) {
        // Handle logic for items other than the first
        // ...
        
        //order
        // destination indexpath
        // destination Parent id
        // ui on which blue line will appear
       
        if draggedCell.frame.midY < cell.frame.midY{
            destinationIndexpath = IndexPath(item: indexPath.item-1, section: indexPath.section)
            order = cell.node.orderInParent
            destinationNodeID = cell.node.parentId
            print("[LayersV1][LastItem][Above] destinationNodeID=\(String(describing: destinationNodeID))")
            // ui blue line
            dropHereView.frame.size.width = cell.frame.width
            dropHereView.frame.origin =  cell.frame.origin
            syncDropIndicatorView()

        }
        else{
           
            logger?.logWarning("JD OrderInParent Doubt")
            order = cell.node.orderInParent + 1
            destinationNodeID = cell.node.parentId
            destinationIndexpath = indexPath
            var dropIndentX = cell.frame.minX
            var dropY = cell.frame.maxY - dropHereView.frame.height

            if draggedCell.frame.midX > cell.frame.minX + 60,
               let parentNode = cell.node as? ParentModel,
               parentNode.children.isEmpty {
                // Dropping into an empty parent: show the line at the bottom of that parent.
                order = 0
                destinationNodeID = cell.node.modelId
                dropIndentX = cell.frame.minX + 40
            } else if draggedCell.frame.midX < cell.frame.minX - 20,
                      let parentNode = findNodeById(cell.node.parentId) {
                // Outdent: place the line under the parent row to indicate same-level drop.
                destinationNodeID = parentNode.parentId
                order = parentNode.orderInParent + 1
                if let parentCell = cellForNodeId(parentNode.modelId) {
                    dropIndentX = parentCell.frame.minX
                    dropY = parentCell.frame.maxY - dropHereView.frame.height
                } else {
                    dropIndentX = max(0, cell.frame.minX - 40)
                }
            }

            dropHereView.frame.size.width = cell.frame.width
            dropHereView.frame.origin = CGPoint(x: dropIndentX, y: dropY)
            syncDropIndicatorView()

        }
    }
    
   lazy var dropHereView : UIView = {
        let dropHereView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 5))
        dropHereView.backgroundColor = .blue
       dropHereView.isHidden = true
       dropHereView.layer.cornerRadius = 5
        return dropHereView
    }()

   private lazy var dropDetailView: DropIndicatorView = {
        let view = DropIndicatorView()
        view.isHidden = true
        return view
    }()

    private func syncDropIndicatorView() {
        guard useDetailedDropView else { return }
        let accent = layersConfig?.accentColorUIKit ?? .blue
        dropDetailView.accentColor = accent
        let lineFrame = dropHereView.frame
        let height = dropGapHeight
        let y = lineFrame.midY - height / 2
        dropDetailView.frame = CGRect(x: lineFrame.minX, y: y, width: lineFrame.width, height: height)
    }
    
    private func endDragging(_ gesture: UIGestureRecognizer) {
        
        // ensure here if snapshot frame in not in the range of 
        
        // this is to make sure all items are avilables else nil everything and reset hidden cell
        
        guard let collectionView = self.collectionView as? CustomCollectionView, let snapshot = snapshot, var selectedItemIndexPath = selectedItemIndexPath , let sourceNode = sourceNode else {
            self.snapshot = nil
            self.selectedItemIndexPath = nil
            self.touchOffset = nil
                self.sourceNode = nil
                self.destinationNodeID = nil
            logger?.logError("Data Is Missing")
            selectedCell?.isHidden = false
            return
            
        }

           let location = snapshot.frame.origin
           snapshot.removeFromSuperview()
          
        if let indexPath = collectionView.indexPathForItem(at: location) {
            guard let dropLocationCell = collectionView.cellForItem(at: indexPath) as? LayerCell else {
                self.snapshot = nil
                self.selectedItemIndexPath = nil
                self.touchOffset = nil
                    self.sourceNode = nil
                    self.destinationNodeID = nil
                selectedCell?.isHidden = false

                logger?.logError("Data Is Missing")
                return
            }
            //               cell.subviews.forEach({$0.isHidden = false })
            //               cell.backgroundColor = .clear
            
            if sourceNode.modelId == dropLocationCell.node.modelId {
                dropLocationCell.backgroundColor = .clear
                dropLocationCell.isHidden = false
                self.snapshot = nil
                self.selectedItemIndexPath = nil
                self.touchOffset = nil
                    self.sourceNode = nil
                    self.destinationNodeID = nil
                selectedCell?.isHidden = false

                logger?.logError("Data Is Missing GotIt")
                return
            }else{
                if let layers = delegate?.getFlattenTree()  {
                    if let index = layers.firstIndex(where: {$0.modelId == sourceNode.modelId}){
                        selectedItemIndexPath = IndexPath(item: index, section: 0)
                        let selectedCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? LayerCell
                        selectedCell?.isHidden = false
                        selectedCell?.backgroundColor = .clear
                        logger?.logError("Data Is Missing Not")
                    }else{
                        logger?.logError("Cell Not Found To Hide")
                    }
                }
                if order == sourceNode.orderInParent && sourceNode.parentId == destinationNodeID!{
                    self.snapshot = nil
                    self.selectedItemIndexPath = nil
                    self.touchOffset = nil
                        self.sourceNode = nil
                        self.destinationNodeID = nil
                    logger?.logError("Data Is Missing")
                    selectedCell?.isHidden = false

                    return
                }
                delegate?.collectionView(collectionView, sourceIndex: selectedItemIndexPath, didEndDraggingItemAt: destinationIndexpath, destinationParentNode: destinationNodeID, atWhich: order, sourceNode: sourceNode)
               dropLocationCell.backgroundColor = .clear
//                cell.isHidden = false
            }

        }
        
        
        
        else{
            
            
            if let layers = delegate?.getFlattenTree()  {
              
                if let index = layers.firstIndex(where: {$0.modelId == sourceNode.modelId}){
                    if let selectedCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? LayerCell{
                        selectedItemIndexPath = IndexPath(item: index, section: 0)
                        
                        selectedCell.isHidden = false
                        selectedCell.backgroundColor = .clear
                        logger?.logError("Data Is Missing Not")
                    }
                }else{
                    logger?.logError("Selected Cell Not found , Could,nt UnHide ")
                }
                
                
                if order == sourceNode.orderInParent && sourceNode.parentId == destinationNodeID!{
                    snapshot.transform = .identity
                    self.snapshot = nil
                    self.selectedItemIndexPath = nil
                    self.touchOffset = nil
                        self.sourceNode = nil
                        self.destinationNodeID = nil
                    selectedCell?.isHidden = false

                    logger?.logError("Data Is Missing")
                    return
                }
                
                delegate?.collectionView(collectionView, sourceIndex: selectedItemIndexPath, didEndDraggingItemAt: destinationIndexpath, destinationParentNode: destinationNodeID, atWhich: order, sourceNode: sourceNode)
                
              
            }
        }
        
           snapshot.transform = .identity
           self.snapshot = nil
           self.selectedItemIndexPath = nil
           self.touchOffset = nil
               self.sourceNode = nil
               self.destinationNodeID = nil
        destinationNode = nil
        selectionVibrate()
//               self.destinationIndexpath = nil
       }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
class DropIndicator: UIView {
    private let copyDropIconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "square.on.square.dashed")
            imageView.tintColor = UIColor.systemBlue
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        private let dottedLineView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.green
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }

        private func setupUI() {
            addSubview(copyDropIconImageView)
            addSubview(dottedLineView)

            NSLayoutConstraint.activate([
                copyDropIconImageView.widthAnchor.constraint(equalToConstant: 20),
                copyDropIconImageView.heightAnchor.constraint(equalToConstant: 20),
                copyDropIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                copyDropIconImageView.topAnchor.constraint(equalTo: topAnchor),

                dottedLineView.widthAnchor.constraint(equalTo: widthAnchor),
                dottedLineView.heightAnchor.constraint(equalToConstant: 4),
                dottedLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
                dottedLineView.topAnchor.constraint(equalTo: copyDropIconImageView.bottomAnchor)
            ])

            let dashPattern: [NSNumber] = [4, 4]
            let dashedBorder = CAShapeLayer()
            dashedBorder.strokeColor = UIColor.green.cgColor
            dashedBorder.lineDashPattern = dashPattern
            let path = UIBezierPath(rect: dottedLineView.bounds)
            dashedBorder.path = path.cgPath
            dottedLineView.layer.addSublayer(dashedBorder)
        }
    }
