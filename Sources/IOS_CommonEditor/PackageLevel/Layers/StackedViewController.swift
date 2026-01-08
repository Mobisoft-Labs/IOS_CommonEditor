//
//  StackedViewController.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 02/05/24.
//

import UIKit
import Combine
//import UIKit

public class StackedViewController: UIViewController, CustomCollectionViewDelegate {

    var multiPlier: Float = 1.0
    var viewModel: LayersViewModel2!
    var customCollectionView: CustomCollectionView!
    var navigationPanel = UIView()
    var blurView: UIVisualEffectView!
//    var navBlurView: UIVisualEffectView!
    var isAllModelsLocked: Bool{
        return viewModel.isLockAllStatus
    }


    public init(viewModel: LayersViewModel2, multiPlier: Float = 1.0) {
        self.viewModel = viewModel
        self.multiPlier = multiPlier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the navigation panel
        navigationPanel.translatesAutoresizingMaskIntoConstraints = false
        //        navigationPanel.backgroundColor = .lightGray // Customize as needed
        navigationPanel.backgroundColor = .systemBackground
        view.addSubview(navigationPanel)
        
        // Add the "Layers" label to the navigation panel
        let layersLabel = UILabel()
        layersLabel.text = "Layers_".translate()
        layersLabel.textColor = .label
        layersLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationPanel.addSubview(layersLabel)
        
        // Add elements to the navigation panel (e.g., buttons, labels)
        let panelButton = UIButton(type: .system)
        panelButton.setTitle("Done_".translate(), for: .normal)
        panelButton.setTitleColor(UIColor(viewModel.layerConfig!.accentColorSwiftUI), for: .normal)
        panelButton.translatesAutoresizingMaskIntoConstraints = false
        panelButton.addTarget(self, action: #selector(panelButtonTapped), for: .touchUpInside)
        navigationPanel.addSubview(panelButton)
        
        
//        // Add the lock all button to the navigation panel
//        let lockAllImage = UIButton(type: .system)
//        lockAllImage.setImage(UIImage(named: "lock"), for: .normal)
//        lockAllImage.tintColor = .label
//        lockAllImage.translatesAutoresizingMaskIntoConstraints = false
//        lockAllImage.addTarget(self, action: #selector(didLeftButtonClick), for: .touchUpInside)
//        navigationPanel.addSubview(lockAllImage)
//        
//        let LockAllTitle = UIButton(type: .system)
//        LockAllTitle.setTitle("All", for: .normal)
//        LockAllTitle.setTitleColor(.label, for: .normal)
//        LockAllTitle.translatesAutoresizingMaskIntoConstraints = false
//        LockAllTitle.addTarget(self, action: #selector(didLeftButtonClick), for: .touchUpInside)
//        // Add target and action for lockAllButton if needed
//        navigationPanel.addSubview(LockAllTitle)
//
        
        // Create and configure the blur view
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = .systemBackground
        view.addSubview(blurView)
        
        setupNavigationBar()
        
        
        
        // Set up the collection view
        customCollectionView = CustomCollectionView(viewModel: viewModel)
        customCollectionView.customDelegate = self
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        customCollectionView.backgroundColor = .clear
        blurView.contentView.addSubview(customCollectionView)
        
        // Set up constraints for the navigation panel, blur view, and collection view
        NSLayoutConstraint.activate([
            
//            navBlurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            navBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            navBlurView.heightAnchor.constraint(equalToConstant: 60),
//            
            navigationPanel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationPanel.heightAnchor.constraint(equalToConstant: 60), // Adjust height as needed
            
            blurView.topAnchor.constraint(equalTo: navigationPanel.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            customCollectionView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 10),
            customCollectionView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 10),
            customCollectionView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -10),
            customCollectionView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -20),
            customCollectionView.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: CGFloat(multiPlier), constant: -60), // Adjust multiplier as needed
            
            //            panelButton.centerXAnchor.constraint(equalTo: navigationPanel.centerXAnchor),
            //            panelButton.centerYAnchor.constraint(equalTo: navigationPanel.centerYAnchor),
            // Center the "Layers" label horizontally and vertically within the navigation panel
            layersLabel.centerXAnchor.constraint(equalTo: navigationPanel.centerXAnchor),
            layersLabel.centerYAnchor.constraint(equalTo: navigationPanel.centerYAnchor),
            
            // Align the panel button to the trailing edge of the navigation panel
            panelButton.trailingAnchor.constraint(equalTo: navigationPanel.trailingAnchor, constant: -10),
            panelButton.centerYAnchor.constraint(equalTo: navigationPanel.centerYAnchor),
            
            // Align the lock all button to the leading edge of the navigation panel
//            lockAllImage.centerYAnchor.constraint(equalTo: navigationPanel.centerYAnchor),
//            lockAllImage.leadingAnchor.constraint(equalTo: navigationPanel.leadingAnchor, constant: 10),
//            lockAllImage.heightAnchor.constraint(equalToConstant: 20),
//            lockAllImage.widthAnchor.constraint(equalToConstant: 20),
//            
//            LockAllTitle.leadingAnchor.constraint(equalTo: lockAllImage.trailingAnchor, constant: 0),
//            LockAllTitle.centerYAnchor.constraint(equalTo: navigationPanel.centerYAnchor)
        ])
        
        
        // Initialize lockAllButton UI based on isAllModelsLocked state
//              let initialImage = isAllModelsLocked ? UIImage(named: "unlock") : UIImage(named: "lock")
//              lockAllImage.setImage(initialImage, for: .normal)
    }

    func setupNavigationBar() {
        let navBarView = UIView()
        navBarView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Home_".translate()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(titleLabel)
        
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("Cancel", for: .normal)
        leftButton.addTarget(self, action: #selector(didLeftButtonClick), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(leftButton)
        
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("Done", for: .normal)
        rightButton.addTarget(self, action: #selector(didRightButtonClick), for: .touchUpInside)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            
            leftButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 8),
            leftButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -8),
            rightButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor)
        ])
        
        navigationItem.titleView = navBarView
    }

    @objc func didLeftButtonClick() {
        print("Cancel button tapped")
//        isAllModelsLocked.toggle()

           

              if isAllModelsLocked {
                  viewModel.unLockAll()
              } else {
                  viewModel.lockAll()
              }
        let lockAllButton = navigationPanel.subviews.compactMap { $0 as? UIButton }.first { $0.currentImage == UIImage(named: "lock") || $0.currentImage == UIImage(named: "unlock") }
        let newImage = isAllModelsLocked ? UIImage(named: "unlock") : UIImage(named: "lock")
        lockAllButton?.setImage(newImage, for: .normal)
        
        customCollectionView.reloadData()
        
    }
    
    private func lockAll(){
        viewModel.lockAll()
        
    }
     
    

    @objc func didRightButtonClick() {
        print("Done button tapped")
        viewModel.onDoneClicked()
    }
    
    @objc func panelButtonTapped() {
        print("Panel button tapped")
        viewModel.onDoneClicked()

        self.navigationController?.isNavigationBarHidden = false
        viewModel.layerConfig!.removeOrDismissViewController(self)
//        self.dismiss(animated: true)
    
        // Handle panel button action
    }
    
    @objc func didcancelClicked(_ sender: UIButton) {
        viewModel.layerConfig!.removeOrDismissViewController(self)
//        self.dismiss(animated: true)
    }
    
    
    func lockAllModels() {
          // Implement lock all logic
        viewModel.lockAllModels()
      }

      func unlockAllModels() {
          // Implement unlock all logic
          viewModel.unlockAllModels()
      }


    // MARK: - CustomCollectionViewDelegate

    func didTapLockButton(cell: LayerCell) {
        // Handle lock button tap
        let lockAllButton = navigationPanel.subviews.compactMap { $0 as? UIButton }.first { $0.currentImage == UIImage(named: "lock") || $0.currentImage == UIImage(named: "unlock") }
        let newImage = isAllModelsLocked ? UIImage(named: "unlock") : UIImage(named: "lock")
        lockAllButton?.setImage(newImage, for: .normal)
    }

    func didTapHiddenButton(cell: LayerCell) {
        // Handle hidden button tap
    }

    func didTapExpandCollapseButton(cell: LayerCell) {
        // Handle expand/collapse button tap
    }
}


protocol CustomCollectionViewDelegate: AnyObject {
    func didTapLockButton(cell: LayerCell)
    func didTapHiddenButton(cell: LayerCell)
    func didTapExpandCollapseButton(cell: LayerCell)
}

class CustomCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UICollectionViewDelegateFlowLayout, LayerCellDelegate, StackedCollectionViewDelegate {
   
    func getSelectedTree(node:BaseModel) -> [Int] {
      
       var selectedNodeParent = [Int]()
        
        selectedNodeParent.append(node.modelId)
        func getSelectedTree(node: BaseModel, selectedNodeParent: inout [Int]) {
            // Check if the current node has a parent
            if node.parentId != -1 {
                // If yes, add the parent ID to the array
                selectedNodeParent.append(node.parentId)
                
                // Recursively call the function with the parent node
                if let parentNode = viewModel.findNodeByID(node.parentId) {
                    getSelectedTree(node: parentNode, selectedNodeParent: &selectedNodeParent)
                }
            }
//            else{
//                selectedNodeParent.append(-1)
//            }
        }
        getSelectedTree(node: node, selectedNodeParent: &selectedNodeParent)
        return selectedNodeParent
    }
    
 
    
    var updateIndexs = [IndexPath]()
    
    func collectionView(_ collectionView: UICollectionView, sourceIndex: IndexPath, didEndDraggingItemAt destinationIndexPath: IndexPath, destinationParentNode: Int?, atWhich order: Int, sourceNode: BaseModel) {
        viewModel.logger?.logError("Data Is Missing Not")
        viewModel.templateHandler.deepSetCurrentModel(id: viewModel.templateHandler.currentPageModel!.modelId)
        if let destinationParentId = destinationParentNode{
            let oldParentId = sourceNode.parentId
            let oldOrder = sourceNode.orderInParent
            var newOrder = order
            var moveModel = MoveModel(type: .NotDefined, oldMM: [], newMM: [])
            
            if destinationParentId == sourceNode.parentId{
                viewModel.logger?.logInfo("Order Change Only Same Parent ")
                if sourceNode.orderInParent < order{
                    if order > 0{
                        newOrder -= 1
                    }
                }
                
                 moveModel = viewModel.templateHandler.moveChildIntoNewParent(modelID: sourceNode.modelId, newParentID: destinationParentId, order: newOrder)
                
                moveModel.type = .OrderChangeOnly
//                moveModel.oldParentID = sourceNode.parentId
//                moveModel.newParentID = destinationParentId
//                moveModel.lastSelectedId = sourceNode.modelId
                moveModel.newLastSelected = sourceNode.modelId
                moveModel.oldlastSelectedId = sourceNode.modelId
                let orderChangeObject = OrderChange(selectedModelId: sourceNode.modelId, oldOrder: sourceNode.orderInParent, newOrder: newOrder)
                
                moveModel.orderChange = orderChangeObject


               // viewModel.templateHandler.currentActionState.moveModel = moveModel
              
                
            }else{
                viewModel.logger?.logInfo("Order And Parent Change")
                 moveModel = viewModel.templateHandler.moveChildIntoNewParent(modelID: sourceNode.modelId, newParentID: destinationParentId, order: newOrder)
//                moveModel.oldParentID = sourceNode.parentId
//                moveModel.newParentID = destinationParentId
                moveModel.newLastSelected = sourceNode.modelId
                moveModel.oldlastSelectedId = sourceNode.modelId
                moveModel.type = .MoveModel
               // moveModel.lastSelectedId = sourceNode.modelId
                
                //viewModel.templateHandler.currentActionState.moveModel = moveModel
            }
            viewModel.templateHandler.performGroupAction(moveModel: moveModel)
            
           // viewModel.templateHandler.setCurrentModel(id: viewModel.templateHandler.lastSelectedId!)
            viewModel.updateFlatternTree()
            viewModel.selectedChild = sourceNode
            if let newIndex = viewModel.flatternTree.firstIndex(where: { $0.modelId == sourceNode.modelId }) {
                let newIndexPath = IndexPath(item: newIndex, section: sourceIndex.section)
                let parentIds = Set([oldParentId, destinationParentId])
                var reloadIndexPaths = [IndexPath]()
                for (idx, node) in viewModel.flatternTree.enumerated() {
                    if parentIds.contains(node.parentId) {
                        reloadIndexPaths.append(IndexPath(item: idx, section: 0))
                    }
                }
                let isMove = newIndexPath != sourceIndex
                if isMove {
                    reloadIndexPaths.removeAll { $0 == sourceIndex || $0 == newIndexPath }
                }
                performBatchUpdates({
                    if isMove {
                        moveItem(at: sourceIndex, to: newIndexPath)
                    }
                }, completion: { [weak self] _ in
                    guard let self else { return }
                    if !reloadIndexPaths.isEmpty {
                        self.reloadItems(at: reloadIndexPaths)
                    }
                    if newOrder != oldOrder {
                        self.setNeedsLayout()
                    }
                })
            } else {
                reloadData()
            }
            
        }
        
//        // remove all indexPath from update index
//        updateIndexs.removeAll()
//        updateIndexs = getUpdatedIndexPathsFromSourceParent(collectionView: collectionView, sourceNode: sourceNode, sourceIndex: sourceIndex, destinationParentNode: destinationParentNode, order: order)
//      
//        viewModel.moveNode(sourceNode: sourceNode, inParent: destinationParentNode, at: order)
//        getUpdatedIndexPathsFromDestinationParent(collectionView: collectionView, sourceNode: sourceNode, sourceIndex: destinationIndexPath, destinationParentNode: destinationParentNode, order: order, updatedIndexArray: &updateIndexs)
//        let destinationNode = viewModel.findNodeByID(destinationParentNode!)
//        
//      let x = updateIndexs
//            collectionView.performBatchUpdates({
//            moveItem(at: sourceIndex, to: destinationIndexPath)
//                
//            
//        }, completion: { _ in
//           // self.reloadData()
//            self.update()
//        })
      
    }
    
    
    func update() {
        self.reloadItems(at: updateIndexs)

    }
   
    func collectionView(_ collectionView: UICollectionView, didBeginDraggingItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,sourceIndex:IndexPath, didEndDraggingItemAt indexPath: IndexPath) {
        
        
//        _ =  viewModel.transferNode(from: sourceIndex, to: indexPath)
//        performBatchUpdates({
//            moveItem(at: sourceIndex, to: indexPath)
//
//        }, completion: { _ in
//            collectionView.reloadItems(at: [sourceIndex,indexPath])
//
//        })
//
    }
    
    private func getUpdatedIndexPathsFromSourceParent(collectionView: UICollectionView, sourceNode: BaseModel, sourceIndex: IndexPath, destinationParentNode: Int?, order: Int) -> [IndexPath] {
        var updateIndexes = [IndexPath]()
        
        // Run a for loop from sourceIndex to flattened tree count-1
        for item in sourceIndex.item..<viewModel.flatternTree.count{
            
                let indexPath = IndexPath(item: item, section: 0)
                
                // Get cell for indexPath of type LayerCell
                
                    
                    // If cell.node.parentID is same as sourceNode.parentID and cell.node.sequence > sourceNode.sequence
            if viewModel.flatternTree[item].parentId == sourceNode.parentId && viewModel.flatternTree[item].orderInParent >= sourceNode.orderInParent {
                        updateIndexes.append(indexPath)
                    }
                    
                    // Else if cell.node parentID != sourceNode.parentID
//            else if viewModel.flatternTree[item].parentID != sourceNode.parentID {
//                        // Break and return with updated Index
//                        return updateIndexes
//                    }
                
            
        }
        
        return updateIndexes
    }

    private func getUpdatedIndexPathsFromDestinationParent(collectionView: UICollectionView, sourceNode: BaseModel, sourceIndex: IndexPath, destinationParentNode: Int?, order: Int, updatedIndexArray: inout [IndexPath]) {
        
        // destinationIndex
//        updateIndexs.append(sourceIndex)
        // Iterate from the order to the end of the flattened tree
        for i in sourceIndex.item..<viewModel.flatternTree.count {
            let indexPath = IndexPath(item: i, section: 0)
            
         
            // Check if the cell's node has the same parent ID as the destinationParentNode
            if viewModel.flatternTree[i].parentId == destinationParentNode && viewModel.flatternTree[i].orderInParent >= order {
                updatedIndexArray.append(indexPath)
            }
            
            else if viewModel.flatternTree[i].parentId != destinationParentNode {
                // Break the loop if the parent ID is different
                continue
            }
        }
    }

    
    var cancellables = Set<AnyCancellable>()

    func getFlattenTree() -> [BaseModel] {
        return viewModel.flatternTree
    }
    
    weak var customDelegate: CustomCollectionViewDelegate?
    var viewModel: LayersViewModel2
    var selectedID : Int = 0
    init(viewModel: LayersViewModel2) {
        self.viewModel = viewModel
        let layout = StackedVerticalFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.backgroundColor = .red
        setupCollectionView()

//        viewModel.$lockStatus.sink { [unowned self] newValue in
//            selectedCell?.lockToggle(isLocked: newValue)
//        }.store(in: &cancellables)
//        viewModel.$isEditParent.dropFirst().sink { [unowned self] newValue in
//                    
//                    onCellExpand(modelId: viewModel.templateHandler.currentModel!.modelId, expand: newValue)
//                }.store(in: &cancellables)

        
    }

    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

        func setupCollectionView() {
           dataSource = self
           delegate = self
           register(LayerCell.self, forCellWithReuseIdentifier: "LayerCell")

           if let layout = collectionViewLayout as? StackedVerticalFlowLayout {
               layout.delegate = self
               layout.addGesture()
               layout.setPackageLogger(logger: viewModel.logger!, layersConfig: viewModel.layerConfig!)
           }
        
           layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
           showsVerticalScrollIndicator = false
//           backgroundColor = .red
            
            

       }
    
    func deselectCell() {
        self.selectedCell?.isTapped = false
    }

    func setDropGapHeight(_ height: CGFloat) {
        guard let layout = collectionViewLayout as? StackedVerticalFlowLayout else { return }
        layout.dropGapHeight = height
    }

    func setDropIndicatorStyle(useDetailed: Bool) {
        guard let layout = collectionViewLayout as? StackedVerticalFlowLayout else { return }
        layout.useDetailedDropView = useDetailed
    }

    func setDragHitTestSources(x: StackedVerticalFlowLayout.DragCoordinateSource,
                               y: StackedVerticalFlowLayout.DragCoordinateSource) {
        guard let layout = collectionViewLayout as? StackedVerticalFlowLayout else { return }
        layout.dragHitTestXSource = x
        layout.dragHitTestYSource = y
    }
    
    func selectCell() {
       // self.selectedCell = cell
        self.selectedCell?.isTapped = true

    }
    
    var selectedCell : LayerCell?
    
//    func setSelectedCell(cell:LayerCell) {
//       
//            self.selectedCell?.isTapped = false
//            self.selectedCell = cell
//            self.selectedCell?.isTapped = true
//        
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LayerCell else { return }
       
       
       // viewModel.templateHandler.setCurrentModel(id: cell.node.modelId)
      //  self.viewModel.selectedID = cell.node.modelId
        self.viewModel.selectedChild = cell.node
//        self.viewModel.templateHandler.deepSetCurrentModel(id: cell.node.modelId)
       
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? LayerCell else { return }
//                cell.isTapped = false
//
//    }
    
    // MARK: - UICollectionViewDataSource
var isFirstTime = true
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.flatternTree.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = dequeueReusableCell(withReuseIdentifier: "LayerCell", for: indexPath) as? LayerCell else {
                return UICollectionViewCell()
            }
          
            let node = viewModel.flatternTree[indexPath.item]

            cell.configure(with: node)
            cell.delegate = self

            if let mode = viewModel.selectedChild{
                if node.modelId == mode.modelId{
                    if isFirstTime {
                        selectedCell = cell
                        cell.isTapped  = true
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3){
                            cell.heartBeat(duration: 0.5)
                           // cell.animateBorder()
                        }
                       // UIView.animate(withDuration: 1.0) { [unowned self] in
                       // }
                        isFirstTime = false
                    }else{
                      //  cell.isTapped  = true

                    }
                }
            }
            
            return cell
        }
    
    // MARK: - UICollectionViewDelegateFlowLayout

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: bounds.width , height: 40)
       }

       // MARK: - LayerCellDelegate

       func didTapLockButton(cell: LayerCell) {
           guard let indexPath = indexPath(for: cell) else { return }
          // cell.lockToggle()
        
            let didSucceed =  viewModel.templateHandler.deepSetCurrentModel(id:  cell.node.modelId)
           self.viewModel.selectedChild = cell.node

           
//           self.viewModel.selectedID = cell.node.modelId
           
//           selectCell()
           
           if didSucceed {
               viewModel.toggleLock(nodeID: cell.node.modelId)
               customDelegate?.didTapLockButton(cell: cell)
           }

          // setSelectedCell(cell: cell)
       }

       func didTapHiddenButton(cell: LayerCell) {
//           guard let indexPath = indexPath(for: cell) else { return }
//           viewModel.toggleHidden(nodeID: cell.node.modelId)
//           cell.hiddenToggle()
//           customDelegate?.didTapHiddenButton(cell: cell)
          // setSelectedCell(cell: cell)
       }

       func didTapExpandCollapseButton(cell: LayerCell) {
//           expandCollapse(cell: cell)
//           cell.toggleExpanded()
           
          // viewModel.templateHandler.setCurrentModel(id: cell.node.modelId)
           viewModel.toggleExpansion(nodeID: cell.node.modelId)
           
           onCellExpand(modelId: cell.node.modelId, expand: (cell.node as! ParentModel).isExpanded)
           
//           viewModel.isEditParent = !(cell.node as! ParentModel).isExpanded
       }

    func onCellExpand(modelId: Int, expand: Bool) {
        guard let index = viewModel.flatternTree.firstIndex(where: { $0.modelId == modelId }) else {
            viewModel.logger?.printLog("Model ID \(modelId) not found in the tree.")
            return
        }
        
        guard let node = viewModel.flatternTree[index] as? ParentModel else {
            viewModel.logger?.printLog("Node at index \(index) is not a ParentModel.")
            return
        }
        
        if node.lockStatus{
            return
        }
        
//        if node.isExpanded == expand {
//            return
//        }
      
        
        let indexPath = IndexPath(item: index, section: 0)
        
        if expand {
            viewModel.logger?.printLog("BAtch- Expanding cell at index \(index) \(viewModel.flatternTree.count)")
            
            
            viewModel.expandNode(node, expand: true)
//            node.isExpanded = true
            
            
            
            
            self.performBatchUpdates({
                let childrenIndexPaths = viewModel.getChildrenIndexPaths(for: indexPath)
                viewModel.logger?.printLog("BAtch- \(viewModel.flatternTree.count)")
                viewModel.logger?.printLog("BAtch-  \(childrenIndexPaths.count)")
                insertItems(at: childrenIndexPaths)
            })
        } else if !expand  {
            viewModel.logger?.printLog("Collapsing cell at index \(index)")
            
           // node.isExpanded = false
            
            self.performBatchUpdates({
                let childrenIndexPaths = viewModel.getChildrenIndexPaths(for: indexPath)
                
                viewModel.expandNode(node, expand: false)
//                node.isExpanded = false
                deleteItems(at: childrenIndexPaths)
            })
        } else {
            viewModel.logger?.printLog("No change in expansion state needed for cell at index \(index)")
        }
    }


    var isScrollingVertically = true
        var isScrollingHorizontally = true
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let verticalOffset = scrollView.contentOffset.y
            let horizontalOffset = scrollView.contentOffset.x
       
        let maxXLimit: CGFloat = contentSize.width - bounds.width
        let maxYLimit: CGFloat = contentSize.height - bounds.height //- 150

        guard  maxXLimit > 0 else { return }
        if horizontalOffset > maxXLimit {
            setContentOffset(CGPoint(x: maxXLimit, y: contentOffset.y), animated: false)
        }
        if horizontalOffset < 0 {
            setContentOffset(CGPoint(x: 0, y: contentOffset.y), animated: false)
        }
        
        if verticalOffset < 0 {
            setContentOffset(CGPoint(x: contentOffset.x, y: 0), animated: false)
        }
        print(contentOffset)
//        if verticalOffset > maxYLimit {
//            setContentOffset(CGPoint(x: contentOffset.x, y: maxYLimit), animated: false)
//        }
//        if horizontalOffset < 0 {
//            setContentOffset(CGPoint(x: 0, y: contentOffset.y), animated: false)
//        }
        
            // Check if the user is scrolling more vertically or horizontally
            if verticalOffset > 0 && abs(verticalOffset) > abs(horizontalOffset) {
                // Scrolling more vertically
                isScrollingVertically = true
                isScrollingHorizontally = false
            } else if horizontalOffset > 0 && abs(horizontalOffset) > abs(verticalOffset) {
                // Scrolling more horizontally
                isScrollingVertically = false
                isScrollingHorizontally = true
            }

            // Perform actions based on the scrolling direction
            updateScrollingDirection()
        
      
        
        }

        func updateScrollingDirection() {
            // Use isScrollingVertically and isScrollingHorizontally to determine the scrolling direction
            // Perform actions based on the scrolling direction, such as locking the other direction temporarily
            if isScrollingVertically {
                // Allow vertical scrolling, lock horizontal scrolling
                isScrollEnabled = true
                alwaysBounceVertical = true
                isDirectionalLockEnabled = true
            } else if isScrollingHorizontally {
                // Allow horizontalscrolling, lock vertical scrolling
                isScrollEnabled = true
                alwaysBounceHorizontal = true
                isDirectionalLockEnabled = true
            }
        }
}
