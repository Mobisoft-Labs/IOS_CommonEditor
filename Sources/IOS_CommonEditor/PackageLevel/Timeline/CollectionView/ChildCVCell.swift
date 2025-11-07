

import UIKit

class ChildCVCell: UICollectionViewCell {
    var originalIndexPath: IndexPath?
    var componentView = ComponentView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.addSubview(componentView)
        componentView.frame = self.frame
        componentView.setNeedsDisplay()

    }
    

    var startTimeConstant : CGFloat {
        return CGFloat((model?.startTime ?? 0.0) * Float(pointsPerSecond))
    }
    
    var model : BaseModel?
    

    func configure(indexPath: IndexPath, model: BaseModel,delegate:CoponentViewDelegate?, timelineDelegate: TimelineViewDelegate, pageStartTime: CGFloat, logger: PackageLogger?, timelineConfig: TimelineConfiguration?) {
        
        componentView.setModel(model: model, pageStartTime: pageStartTime, timelineDelegate: timelineDelegate, logger: logger, timelineConfig: timelineConfig)

        componentView.delegate = delegate

    }
}
