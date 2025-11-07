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
                if let layers = delegate?.getFlattenTree()  {
                    let node = layers[item]
                    width = collectionView.frame.width
                    xOffset = CGFloat( (node.depthLevel-1) * 50)
                }
                
                maxWidth = max(maxWidth, width)
                maxX = max(maxX , xOffset)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: width*0.7, height: cellSize.height)

                cellAttributes.append(attributes)

               // xOffset += cellSize.width
                yOffset += cellSize.height
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
            // remove all index which is selected
            deselectAllItems()
            selectedItemIndexPath = indexPath
            
          
            delegate?.collectionView(collectionView!, didBeginDraggingItemAt: indexPath)
            
            guard let cell = collectionView?.cellForItem(at: indexPath) as? LayerCell else { return }
            destinationNodeID = cell.node.parentId
            order = cell.node.orderInParent
            print("node id", destinationNodeID)
            dropHereView.frame.size.width = cell.frame.width
            dropHereView.frame.origin =  cell.frame.origin
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
            dropHereView.isHidden = false
            updateSnapshotPosition(gesture)
            updateAutoScroll(gesture)
            inDragging(gesture)
        case .ended, .cancelled:
            endDragging(gesture)
            dropHereView.isHidden = true
            collectionView?.isScrollEnabled = true
        default:
            break
        }
    }
    
    private func updateSnapshotPosition(_ gesture: UIGestureRecognizer) {
        guard let snapshot = snapshot, let touchOffset = touchOffset  , let initialCenter = cellCenter else { return }
        
        let location = gesture.location(in: collectionView)
        
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
        
        let location = gesture.location(in: collectionView)

        let minYLimit: CGFloat = 0
        let maxYLimit: CGFloat = max(0,collectionView.contentSize.height - collectionView.bounds.height)
        let minXLimit: CGFloat = 0
        let maxXLimit: CGFloat = max(0,collectionView.contentSize.width - collectionView.bounds.width)

        if location.y < collectionView.bounds.minY + snapshot.frame.height/4 {
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
        } else if location.y > collectionView.bounds.maxY -  snapshot.frame.height/4 {
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
        if location.x < collectionView.bounds.minX + snapshot.frame.width/4 {
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
        } else if location.x > collectionView.bounds.maxX - snapshot.frame.width/4 {
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
    
    private func inDragging(_ gesture : UIGestureRecognizer) {
//        destinationNode = nil
        guard let draggedCell = snapshot else { return }

        if let indexPath = collectionView?.indexPathForItem(at: draggedCell.center){
            
            guard let cell = collectionView?.cellForItem(at: indexPath) as? LayerCell else { return }
            
            if handleHovering(cell, draggedCell: draggedCell, indexPath: indexPath) {
                return
            }
          
            let bottomCell = collectionView?.cellForItem(at: IndexPath(item: indexPath.item+1, section: indexPath.section)) as? LayerCell
            let upperCell =  collectionView?.cellForItem(at: IndexPath(item: indexPath.item-1, section: indexPath.section)) as? LayerCell
            
            if cell.node.modelId == sourceNode?.modelId{
                return
            }
            
            if indexPath.item == 0, let lowerCell = bottomCell{
                
                handleFirstItem(cell, draggedCell: draggedCell, indexPath: indexPath, lowerCell: lowerCell)
                
                //            print("first index")
            }
            else if let lowercell = bottomCell,let topCell = upperCell{
                //            print("middle cell index")
                handleNonFirstItem(cell, draggedCell: draggedCell, indexPath: indexPath,lowerCell: lowercell,topCell: topCell)
            }
            else if bottomCell == nil ,let topCell = upperCell {
                //            print("last cell")
                handleLastItem(cell, draggedCell: draggedCell, indexPath: indexPath, topCell: topCell)
            }
        }
        else{
            print("no cell is lies in this reason")
            
//            if destinationX == nil {
                destinationX = Float(draggedCell.center.x)
            if let node = destinationNode {
                if (Int(Float(draggedCell.center.x)) >= node.depthLevel * 40 && Int(Float(draggedCell.center.x)) <= (node.depthLevel + 1) * 40) {
                    // The center x-coordinate of draggedCell is within the specified range
                    return
                }
            }

//                if let y = draggedCell.center.y
                for i in stride(from:draggedCell.center.y, to: 0 as CGFloat, by: -1 as CGFloat) {
                    if let indexPath = collectionView?.indexPathForItem(at: CGPoint(x: draggedCell.center.x, y: i)){
                        guard let cell = collectionView?.cellForItem(at: indexPath) as? LayerCell else { return }
                        destinationNodeID = cell.node.parentId
                        print("node id", destinationNodeID)
                        dropHereView.frame.size.width = cell.frame.width
                        dropHereView.frame.origin =   CGPoint(x: cell.frame.minX, y: cell.frame.maxY-dropHereView.frame.height)
            //            destinationNodeID = cell.node.nodeID
                        destinationNode = cell.node
                        order = cell.node.orderInParent+1
                        
                        
                        //JD**
                        if  let parentNode = cell.node as? ParentModel {
                            
                            destinationIndexpath = IndexPath(item: indexPath.item+parentNode.children.count, section: 0)
                            print("new cell ",cell.node.modelId)
                        }
                        break
//                        destinationIndexpath = IndexPath(item: indexPath.item+cell.node.children.count, section: 0)
//                        print("new cell ",cell.node.modelId)
//                        break
                    }
                  
                }
                
        
                

        }

    }
    
    
    
    
    private func handleHovering(_ cell: LayerCell, draggedCell: UIView, indexPath: IndexPath) -> Bool {
        // Handle hovering logic here
        // ...
        if !cell.frame.contains(draggedCell.center) {return false}
        guard let cv = self.collectionView as? CustomCollectionView else{return false}
        if let _ = selectedNodes.firstIndex(where: {$0 == cell.node.modelId }){
            return false
        }
        else
        if let parentNode = cell.node as? ParentModel  {
            
            
            if parentNode.isExpanded == false {
                if draggedCell.center.y >= cell.center.y && draggedCell.center.y <= cell.frame.maxY {
                    logger?.printLog("handleHovering - Eligible For Expnsaion Y")
                    if draggedCell.center.x >= cell.center.x && draggedCell.center.x <= cell.frame.maxX {
                        logger?.printLog("handleHovering - Eligible For Expnsaion X")

                        if parentNode.isExpanded == false{
                            logger?.printLog("handleHovering - Expanding Parent")
                            cv.onCellExpand(modelId: parentNode.modelId, expand: true)

                            //                parentNode.editState = true
                            parentNode.isExpanded = true
                          //  cv.viewModel.isEditParent = true
                            
                        }
                    }
                }
            }else {
                
                
               
                if draggedCell.center.y >= cell.frame.minY && draggedCell.center.y < cell.center.y {
                    logger?.printLog("handleHovering - Eligible For collapsing Y")

                    if draggedCell.center.x >= cell.frame.minX &&  draggedCell.center.x <= cell.frame.maxX {
                        logger?.printLog("handleHovering - Eligible For Collapsing X")

                        if parentNode.isExpanded == true{
                            cv.onCellExpand(modelId: parentNode.modelId, expand: false)
                            logger?.printLog("handleHovering - Collapsing Parent")

                            parentNode.isExpanded = false
                            // cv.viewModel.isEditParent = false
                        }
                    }
                }else if draggedCell.center.y >= cell.center.y && draggedCell.center.y <= cell.frame.maxY {
                    logger?.printLog("handleHovering - Eligible For collapsing Y")

                    if draggedCell.center.x >= cell.frame.minX && draggedCell.center.x <= cell.center.x {
                        logger?.printLog("handleHovering - Eligible For collapsing X")

                        if parentNode.isExpanded == true{
                            cv.onCellExpand(modelId: parentNode.modelId, expand: false)
                            logger?.printLog("handleHovering - Collapsing Parent")

                            parentNode.isExpanded = false
                            // cv.viewModel.isEditParent = false
                        }
                    }
                }
                
            
            }
            
            

//            if parentNode.is
         
                   // cv.expandCollapse(cell: cell)
            
            
        }
      
        return false
    }

    private func handleFirstItem(_ cell: LayerCell, draggedCell: UIView, indexPath: IndexPath,lowerCell:LayerCell) {
        
        if draggedCell.frame.midY < cell.frame.midY{
            // order will be zero
            // indexpath will be zero
            // parent will be parent of cell.node.parent
            destinationNodeID = cell.node.parentId
            print("node id", destinationNodeID)
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
                print("node id", destinationNodeID)
                // ui blue line
                dropHereView.frame.size.width = cell.frame.width
                dropHereView.frame.origin =  cell.frame.origin
                
            }
            else{
                // order will
               // print("place indexPath",indexPath.item)
                destinationNodeID = cell.node.parentId
                order = cell.node.orderInParent+1
                destinationIndexpath = indexPath
                print("node id", destinationNodeID)
                
                if lowerCell.node.depthLevel>cell.node.depthLevel{
                    destinationNodeID = cell.node.modelId
                    order = 0
                    destinationIndexpath = indexPath
                    print("node id", destinationNodeID)
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
                    print("node id", destinationNodeID)
                    
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
            print("node id", destinationNodeID)
            // ui blue line
            dropHereView.frame.size.width = cell.frame.width
            dropHereView.frame.origin =  cell.frame.origin

        }
        else{
           
            logger?.logWarning("JD OrderInParent Doubt")
            order = cell.node.orderInParent + 1
            destinationNodeID = cell.node.parentId
            destinationIndexpath = indexPath
            let parentNode = cell.node as? ParentModel
            
            if draggedCell.frame.midX > cell.frame.minX+60, let parentNode = cell.node as? ParentModel ,  parentNode.children.isEmpty {
                order = 0
                destinationNodeID = cell.node.modelId
                dropHereView.frame.size.width = cell.frame.width
                dropHereView.frame.origin =  CGPoint(x: cell.frame.minX+40, y: cell.frame.maxY-dropHereView.frame.height)
            }else{
                
                // ui blue line
                dropHereView.frame.size.width = cell.frame.width
                dropHereView.frame.origin =  CGPoint(x: cell.frame.minX, y: cell.frame.maxY-dropHereView.frame.height)
            }

        }
    }
    
   lazy var dropHereView : UIView = {
        let dropHereView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 5))
        dropHereView.backgroundColor = .blue
       dropHereView.isHidden = true
       dropHereView.layer.cornerRadius = 5
        return dropHereView
    }()
    
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

           let location = gesture.location(in: collectionView)
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
