//
//  ActionsModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 13/03/24.
//

import Foundation
import UIKit

enum scrollViewDirection{
    case right
    case left
}

public class MultiSelectedArrayObject : Equatable, ObservableObject{
    public static func == (lhs: MultiSelectedArrayObject, rhs: MultiSelectedArrayObject) -> Bool {
       return lhs.id == rhs.id
    }
    
    var id: Int
    public var thumbImage: UIImage?
    public var orderID : Int = 0
    @Published var isEdited : Bool = false
    
    init(id: Int, thumbImage: UIImage?, orderID: Int = 0, isEdited : Bool = false) {
        self.id = id
        self.thumbImage = thumbImage
        self.orderID = orderID
        self.isEdited = false
    }
}

enum ZoomEditView{
    case scaleDown
    case scaleUp
}


public class ActionStates: ObservableObject {
//    @Published var personalizedState : Bool = false
//    @Published public var didPersonalizeTapped : Bool = false
//    @Published var didPersonalizeTappedFromSaveNEdit : Bool = false
    @Published var zoomEditView : ZoomEditView = .scaleUp
    
    var logger: PackageLogger?
    var actionStateConfig: EngineConfiguration?
    
    func setPackageLogger(logger: PackageLogger, actionStateConfig: EngineConfiguration){
        self.logger = logger
        self.actionStateConfig = actionStateConfig
        snappingMode = getSnappingValue()
    }
    
    func getSnappingValue() -> SnappingMode{
        if actionStateConfig?.getSnappingMode == 0{
            return .off
        }
        else if actionStateConfig?.getSnappingMode == 1{
            return .basic
        }
        else if actionStateConfig?.getSnappingMode == 2{
            return .advanced
        }
        return .off
    }
    
    public init() {
//        snappingMode = getSnappingValue()
    }
    
    deinit {
        logger?.printLog("de-init \(self)")
    }
    
    @Published public var showPlayPauseButton : Bool = true
    @Published public var showMusicPickerRoundButton : Bool = true
    @Published public var ShowMusicSlider : Bool = true

    
    
    
    // MARK: - Template/Design State
    @Published public var zoomEnable: Bool = false
    @Published var isTextInUpdateMode: Bool = false
    @Published var thumbUpdateId: Int = 0
    @Published public var isTextNotValid = false
//    @Published var lastSelectedBGContent: AnyBGContent?
//    @Published public var lastSelctedOverlayContent: AnyBGContent?
//    @Published public var lastSelectedFilter: FiltersEnum = .none
    @Published public var isCurrentModelDeleted: Bool = false
    @Published public var deleteModelId: Int = 0
    @Published public var lockAllState: Bool? = nil
    @Published public var lockUnlockAllAction: lockUnlockAllAction? = nil
    @Published public var shouldRefreshOnAddComponent: Bool = false
//    @Published public var lastSelectedFont: String = "Default"
//    @Published public var lastSelectedFlipH: Bool = false
//    @Published public var lastSelectedFlipV: Bool = false
//    @Published public var lastSelectedBGColor: AnyBGContent?
  //  @Published var parentEditState: Bool = false
    
    // MARK: - Page-Level State
    @Published var pageSize: CGSize = CGSize(width: 100, height: 100)
    @Published var scrollOffset: CGFloat = 0
    @Published var pagerScrolledOff: Bool = false
    @Published var currentPage: Int = 0
    @Published var deletedPageID: Int = 0
    @Published var selectedPageID: Int = 0
    @Published public var pageModelArray: [MultiSelectedArrayObject] = []
    @Published public var updatePageArray: Bool = false
    @Published public var updateThumb: Bool = false
    @Published public var updatePageAndParentThumb: Bool = false
    @Published public var currentThumbTime: Float = 0.0

    // MARK: - Component-Level State
    @Published public var addNewText: String = "Enter Your Text"
    @Published public var updatedText: String = ""
    @Published var fontChanged: String = ""
    @Published public var addImage: ImageModel? = nil
    @Published public var replaceSticker: ImageModel? = nil
    @Published var addNewpage: AnyBGContent = BGColor(bgColor: .blue)
    
    // MARK: - Action Tracking State
//    @Published public var didUseMeTapped: Bool = false
//    @Published public var didPurchasedTapped: Bool = false
//    @Published public var didPreviewTapped: Bool = false
    @Published public var didGroupTapped: Bool = false
    @Published public var didCancelTapped: Bool = false
//    @Published public var didWatchAdsTapped: Bool = false
    @Published public var didGetPremiumTapped: Bool = false
//    @Published public var didCloseTabbarTapped: Bool = false
    @Published public var didUngroupTapped: Bool = false
//    @Published public var didLayersTapped: Bool = false
    @Published public var multiModeSelected: Bool = false
    @Published public var exportPageTapped: Bool = false
    @Published public var snappingMode: SnappingMode = .basic
  //  @Published var snappingOff: Bool = false
//    @Published var timelineHide: Bool = false
    @Published public var timelineShow: Bool = false
    @Published var moveModel: MoveModel? = nil

    // MARK: - Music Control State
    @Published var musicAdded: Bool = false
    @Published var musicUpdate: MusicInfo?
    @Published public var addNewMusicModel: MusicModel = MusicModel()
    @Published public var deleteMusic: MusicInfo = MusicInfo()
    @Published public var replaceMusic: MusicModel = MusicModel()
    @Published public var didMusicPlayOnEditor: Bool = false
    @Published public var currentMusic: MusicInfo?
    
    // MARK: - Multi-Select State
    @Published public var addItemToMultiSelect: Int = 0
    @Published public var removeItemFromMultiSelect: Int = 0
    @Published public var multiSelectedItems: [BaseModel] = [BaseModel]()
    @Published public var multiUnSelectItems: [BaseModel] = [BaseModel]()
    @Published public var showGroupButton: Bool = false

    // MARK: - Ratio/Layout State
    @Published public var didRatioSelected: DBRatioTableModel = DBRatioTableModel()
    @Published var currentRatio: Int = 0
    @Published public var copyModel: Int = 0
    @Published public var pasteModel: Bool = false
    @Published public var duplicateModel: Int = 0
    @Published var hasOnce: Bool = false
    @Published var hasOnceForScene: Bool = false

    // MARK: - Editor Visibility State
    @Published public var showNavgiationItems: Bool = false
    @Published public var showMultiSelectNavItems: Bool = false
//    @Published public var showThumbnailNavItems: Bool = false
   // @Published var hideTimeLine: Bool = false
    @Published var isScrollViewShowOrNot: Bool = false

    // MARK: - Mute and Audio Settings State
    @Published public var isMute: Bool = false

    // MARK: - Animation State
    @Published public var lastSelectedAnimType: String = "IN"
    @Published public var lastSelectedCategoryId: Int = 3
    
    // MARK: - Page Transitions/Duration State
//    @Published public var didShowDurationButtonCliked: Bool = false

    // MARK: - Last Selected States
//    @Published public var lastSelectedShadowButton: ShadowType = .direction
//    @Published public var lastSelectedBGButton: BGPanelType = .color
//    @Published public var lastSelectedFormatButton: HTextGravity = .Center
    @Published public var lastSelectedTextTab: String = ""
//    @Published public var lastSelectedBGTab: String = ""
//    @Published public var lastSelectedColor: AnyColorFilter?
//    @Published public var lastSelctedBGContent: AnyBGContent?

    @Published public var didEditTextClicked : Bool = false
    @Published var directionOfScrollView : scrollViewDirection = .left

    @Published public var isNudgeAllowed: Bool = false
}
