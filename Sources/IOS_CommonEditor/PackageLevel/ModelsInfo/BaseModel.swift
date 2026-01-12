//
//  BaseModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 28/03/24.
//

import Foundation
import UIKit

public class BaseModel :ObservableObject, BaseModelProtocol{
    
    @Published public var filterType: FiltersEnum = .none
    
    @Published public var colorAdjustmentType: String = "brightness"
    
    @Published public var brightnessIntensity: Float = 0
    
    @Published public var contrastIntensity: Float = 0
    
    @Published public var highlightIntensity: Float = 0
    
    @Published public var shadowsIntensity: Float = 0
    
    @Published public var saturationIntensity: Float = 0
    
    @Published public var vibranceIntensity: Float = 0
    
    @Published public var sharpnessIntensity: Float = 0
    
    @Published public var warmthIntensity: Float = 0
    
    @Published public var tintIntensity: Float = 0
    
    @Published public var hasMask: Bool = false
    
    @Published public var maskShape: String = ""
    
    public var size: CGSize = .zero
    
    public var center: CGPoint = .zero
    
    @Published var endFilterType: FiltersEnum = .none
    
    @Published public var beginBrightnessIntensity: Float = 0
    @Published public var endBrightnessIntensity: Float = 0
    
    @Published public var beginContrastIntensity: Float = 0
    @Published public var endContrastIntensity: Float = 0
    
    @Published public var beginHighlightIntensity: Float = 0
    @Published public var endHighlightIntensity: Float = 0
    
    @Published public var beginShadowsIntensity: Float = 0
    @Published public var endShadowsIntensity: Float = 0
    
    @Published public var beginSaturationIntensity: Float = 0
    @Published public var endSaturationIntensity: Float = 0
    
    @Published public var beginVibranceIntensity: Float = 0
    @Published public var endVibranceIntensity: Float = 0
    
    @Published public var beginSharpnessIntensity: Float = 0
    @Published public var endSharpnessIntensity: Float = 0
    
    @Published public var beginWarmthIntensity: Float = 0
    @Published public var endWarmthIntensity: Float = 0
    
    @Published public var beginTintIntensity: Float = 0
    @Published public var endTintIntensity: Float = 0
    
    @Published public var baseFrame: Frame = Frame(size: CGSize(width: 1, height: 1), center: CGPoint(x: 0.5, y: 0.5), rotation: 0.0){
        didSet{
            let size = baseFrame.size

            if size.width <= 0 || size.height <= 0 {
                // 🔴 ALWAYS log (release-safe)
                print("""
                        ❌ Invalid baseFrame size detected
                        width: \(size.width)
                        height: \(size.height)
                        oldValue: \(oldValue)
                        newValue: \(baseFrame)
                        thread: \(Thread.current)
                        """)
            }
        }
    }
    @Published public var baseTimeline: StartDuration = StartDuration(startTime: 0.0, duration: 5.0)
//    @Published var endFrame:Frame = Frame(size: .zero, center: .zero, rotation: 0.0)
    
    
    
  
    public var identity: String = "Basemodel"
    public var depthLevel : Int = 0 {
        didSet {
            if isParent {
                updateDepthLevelForChildren()
            }
        }
    }
   
     func findNodeByID(_ nodeID: Int) -> BaseModel? {
        if self.modelId == nodeID {
            return self
        }
         return nil
    }
   
       
    
    func updateDepthLevelForChildren() { }
    
    var isParent:Bool {
        return self is ParentModel
    }
    var mainAnimationID : Int = 0
    
    @Published public var inAnimation: AnimTemplateInfo = AnimTemplateInfo()
    
    @Published public var inAnimationDuration: Float = 1.0
    
    @Published public var outAnimation: AnimTemplateInfo = AnimTemplateInfo()
    
    @Published public var outAnimationDuration: Float = 1.0
    
    @Published public var loopAnimation: AnimTemplateInfo = AnimTemplateInfo()
    
    @Published public var loopAnimationDuration: Float = 1.0
    
    // Opacity
    @Published public var beginOpacity: Float = 0
    @Published public var endOpacity: Float = 0
    
    
    // Animation
    @Published public var inAnimationBeginDuration: Float = 0
    @Published public var inAnimationEndDuration: Float = 1.0
    
    @Published public var outAnimationBeginDuration: Float = 0
    @Published public var outAnimationEndDuration: Float = 1.0
    
    @Published public var loopAnimationBeginDuration: Float = 0
    @Published public var loopAnimationEndDuration: Float = 1.0
//    
////    // Pos X,Y
//    @Published var beginPosX: Float = 0
//    @Published var beginPosY: Float = 0
//    @Published var endPosX: Float = 0
//    @Published var endPosY: Float = 0
    
    
//    @Published var beginSize:CGSize = .zero
//    @Published var beginCenter:CGPoint = .zero
//    @Published var endSize:CGSize = .zero
//    @Published var endCenter:CGPoint = .zero
    @Published public var beginFrame:Frame = Frame(size: .zero, center: .zero, rotation: .zero)
    @Published public var endFrame:Frame = Frame(size: .zero, center: .zero, rotation: .zero)
    
    @Published var beginBaseTimeline: StartDuration = StartDuration(startTime: 0.0, duration: 0.0)
    @Published var endBaseTimeline: StartDuration = StartDuration(startTime: 0.0, duration: 15.0)
//    // Color
//    @Published var startColor: UIColor = .clear
//    @Published var endColor: UIColor = .clear
    
    // new sticker added
    @Published var newStickerImageAdded: StickerModel = StickerModel()
    
//    @Published var duplicate : Bool = false
//    @Published var copy : Bool = false
//    @Published var paste : Bool = false
    
    @Published public var thumbImage: UIImage? = UIImage(named: "none") ?? UIImage(systemName: "plus")
    
    @Published var beginStartTime:Float = 0.0
    @Published var endStartTime:Float = 0.0
    
    // duration
    @Published var beginDuration: Float = 0.0
    @Published var endDuration: Float = 15.0
   
    enum UIState {
        case Selected
        case EditOn
        case Idle
    }
    
//    enum ActiveState {
//        case Active(uiState:UIState)
//        case DeActive(uiState:UIState)
//    }
    
    @Published var isActive: Bool = false
//    @Published var group : Bool = false
//    @Published var ungroup : Bool = false
    
    @Published var isLayerAtive : Bool = false
    
    
    
    
    
    
     var isSelectedForMultiSelect = false
    
    
    init(thumbImage: UIImage? = nil, isSelected: Bool = false){
        self.thumbImage = thumbImage
        self.isActive = isSelected
        
    }
    
    func setAnimation(animationModel: DBAnimationModel ) {
        
        let inAnim = DataSourceRepository.shared.fetchAnimationInfo(for: animationModel.inAnimationTemplateId)
        let outAnim = DataSourceRepository.shared.fetchAnimationInfo(for: animationModel.outAnimationTemplateId)
        let loopAnim = DataSourceRepository.shared.fetchAnimationInfo(for: animationModel.loopAnimationTemplateId)

        self.inAnimation = inAnim
        self.outAnimation = outAnim
        self.loopAnimation = loopAnim
        
        self.inAnimationDuration = animationModel.inAnimationDuration
        self.outAnimationDuration = animationModel.outAnimationDuration
        self.loopAnimationDuration = animationModel.loopAnimationDuration
        
        self.mainAnimationID = animationModel.animationId
    }
    
    
    func getAnimation() -> DBAnimationModel {
        
        return DBAnimationModel(animationId: mainAnimationID, modelId: modelId, inAnimationTemplateId: inAnimation.animationTemplateId, inAnimationDuration: inAnimationDuration, loopAnimationTemplateId: loopAnimation.animationTemplateId, loopAnimationDuration: loopAnimationDuration, outAnimationTemplateId: outAnimation.animationTemplateId, outAnimationDuration: outAnimationDuration, templateID:  templateID)
         
    }
    
//    func getBaseModel(refSize:CGSize) -> DBBaseModel {
//        return DBBaseModel(
//            filterType: filterType.rawValue,
//            brightnessIntensity: brightnessIntensity,
//            contrastIntensity: contrastIntensity,
//            highlightIntensity: highlightIntensity,
//            shadowsIntensity: shadowsIntensity,
//            saturationIntensity: saturationIntensity,
//            vibranceIntensity: vibranceIntensity,
//            sharpnessIntensity: sharpnessIntensity,
//            warmthIntensity: warmthIntensity,
//            tintIntensity: tintIntensity,
//            parentId: parentId,
//            modelId: modelId,
//            modelType: modelType.rawValue,
//            dataId: dataId,
//            posX: (baseFrame.center.x).toDouble()/refSize.width,
//            posY: (baseFrame.center.y).toDouble()/refSize.height,
//            width: (baseFrame.size.width).toDouble()/refSize.width,
//            height: (baseFrame.size.height).toDouble()/refSize.height,
//            prevAvailableWidth: (prevAvailableWidth).toDouble()/refSize.width,
//            prevAvailableHeight: (prevAvailableHeight).toDouble()/refSize.height,
//            rotation: (baseFrame.rotation).toDouble(),
//            modelOpacity: (modelOpacity).toDouble()*255.0,
//            modelFlipHorizontal: modelFlipHorizontal.toInt(),
//            modelFlipVertical: modelFlipVertical.toInt(),
//            lockStatus: lockStatus.toString(),
//            orderInParent: orderInParent,
//            bgBlurProgress: bgBlurProgress.toInt(),
//            overlayDataId: overlayDataId,
//            overlayOpacity: overlayOpacity.toInt(),
//            startTime: (baseTimeline.startTime).toDouble(),
//            duration: (baseTimeline.duration).toDouble(),
//            softDelete: softDelete.toInt(),
//            isHidden: isHidden,
//            templateID: templateID
//        )
//    }
    
        //base model
    public var parentId: Int = 0
    public var modelId: Int = 0
    public var modelType: ContentType = .Page
    public var dataId: Int = 0
    @Published public var posX: Float = 0.5
    @Published public var posY: Float = 0.5
    @Published public var width: Float = 1.0
    @Published public var height: Float = 1.0 // Neeshu : Frame : CGRect - XY Cetner ,WH - Size
    @Published public var prevAvailableWidth: Float = 0.0
    @Published public var prevAvailableHeight: Float = 0.0
    @Published public var rotation: Float = 0
    @Published public var modelOpacity: Float = 1
    @Published public var modelFlipHorizontal: Bool = false
    @Published public var modelFlipVertical: Bool = false
    @Published public var lockStatus: Bool = false
    @Published public var orderInParent: Int = 0
    @Published public var bgBlurProgress: Float = 0
    @Published public var overlayDataId: Int = 0
    @Published public var overlayOpacity: Float = 1
    @Published public var startTime: Float = 0.0
    @Published public var duration: Float = 5.0
    @Published public var softDelete: Bool = false
    @Published public var isHidden: Bool = false
    @Published public var templateID : Int = 0 //Updated by Neeshu
//    @Published var baseFrame:Frame = Frame(size: .zero, center: .zero, rotation: 0.0)
   // @Published var editState : Bool = false
    
    
    func addDefaultModel(parentModel:BaseModelProtocol,baseModel:BaseModel){
//        var model = BaseModel()
        // calculate Size
        baseModel.baseFrame.size.width = parentModel.baseFrame.size.width/2
        baseModel.baseFrame.size.height = parentModel.baseFrame.size.height/2
        baseModel.prevAvailableWidth = Float(parentModel.baseFrame.size.width/2)
        baseModel.prevAvailableHeight = Float(parentModel.baseFrame.size.height/2)
        
        // calculate Center
        
        baseModel.baseFrame.center.x = parentModel.baseFrame.size.width/2
        baseModel.baseFrame.center.y = parentModel.baseFrame.size.height/2
        // calculate Time
//        baseModel.startTime = Float(currentTime)
//        baseModel.duration = parentModel.duration - Float(currentTime)
        // calculate opacity
        
        // calculate rotation
        //model.rotation =
       
        
        baseModel.parentId = parentModel.modelId
        baseModel.templateID = parentModel.templateID
       
    }
    
    func getModelStartTime(templatehandler:TemplateHandler)-> Float{
        var startTime = self.baseTimeline.startTime
        if let parentModel = templatehandler.getModel(modelId: parentId) as? ParentModel{
            startTime += recursiveParentStartTime(model: parentModel, templatehandler: templatehandler)
        }
        
        return startTime
    }

    private func recursiveParentStartTime(model:ParentModel,templatehandler:TemplateHandler)->Float{
       if model.modelType == .Page{
           return 0
       }
        var time = model.baseTimeline.startTime
        if let parent = templatehandler.getModel(modelId: model.parentId) as? ParentModel{
            time += recursiveParentStartTime(model: parent, templatehandler: templatehandler)
        }
        return time
    }
}
