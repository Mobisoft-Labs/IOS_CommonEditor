import UIKit
var pointsPerSecond : CGFloat = TimelineConstants.initialPointsPerSec

class RulerView: UIView {
    
    private  enum BaseZoomLevel {
        case ZoomIn
        case ZoomOut
    }
    
    var timelineConfig: TimelineConfiguration?
//    private let rulerColor: UIColor = .label
//    private let rulerColor2: UIColor = .secondaryLabel
//    private let rulerColor3: UIColor = .tertiaryLabel

    private  var numberOfLongTicks : Int {
        return Int(self.frame.width/pointsPerSecond)
    }
    
    private var tickSpacing: CGFloat {
        return pointsPerSecond
    }

    private  var zoomDirection : BaseZoomLevel {
        return tickSpacing >= TimelineConstants.initialPointsPerSec ? .ZoomIn : .ZoomOut
    }
    
    // MARK: - Constants
    private let longTickHeight: CGFloat = 8.0
    private  let mediumTickHeight: CGFloat = 4.0
    private let shortTickHeight: CGFloat = 2.5
  //  public var pointsPerSecond = 30.0
    public var startTime : CGFloat = 0
    public var duration : CGFloat = 0
    public var pageStartTime : CGFloat = 0
    
    // MARK: - Initialization


    override init(frame:CGRect){
        super.init(frame: frame)
//        backgroundColor = UIColor(named: "editorBG")!
        self.isUserInteractionEnabled = true

    }
    
    func setTimelineConfig(timelineConfig: TimelineConfiguration?){
        self.timelineConfig = timelineConfig
        backgroundColor = timelineConfig?.rulerViewBGColor//UIColor(named: "editorBG")!
    }
    
    required init?(coder aDecoder: NSCoder) {
       // self.duration = 0.0
        super.init(coder: aDecoder)
       // backgroundColor = .white
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawRulerLines(rect)
    }

  
    
   
   
   
    
    
    
        

    
    
    

    
    
 
    
    private  func drawRulerLines(_ rect :  CGRect) {
      //  calculatePointsPerSecond(perPixelSecond: pointsPerSecond)
        let stickDesginer = TicksValidation(ppw: tickSpacing)
        print("PPW_",pointsPerSecond)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(timelineConfig?.rulerColor.cgColor ?? UIColor.label.cgColor)
        context?.setLineWidth(1.0)
        // Set fill color to dark gray for the background areas
        context?.setFillColor(UIColor.lightGray.cgColor)
        
        //context?.setFillColor(UIColor.secondarySystemBackground.cgColor)
        let leftFillWidth = TimelineConstants.initialMargin + (pageStartTime * tickSpacing)
        let rightFillX = leftFillWidth + (duration * tickSpacing)
        let rightFillWidth = rect.width - rightFillX
        let rightStartingPoint = (duration * tickSpacing) + TimelineConstants.initialMargin
        context?.fill([CGRect(x: 0 , y: 0, width: leftFillWidth , height: rect.height)])
        context?.fill([CGRect(x: rightStartingPoint, y: 0, width: rect.width, height: rect.height)])
        
//        let initialWidth = TimelineConstants.initialMargin
//        let lastWidth =


        
        // decide zoom direction In or Out
        
        // Zoom In Drawing    // If In
        if zoomDirection == .ZoomIn {
            
            // longSticks With Number
            if stickDesginer.shoudDraw(stickStyle: .LongTicksWithNumber) {
                // medium Sticks
                for item in 0...numberOfLongTicks{
                    context?.setStrokeColor(timelineConfig?.rulerColor.cgColor ?? UIColor.label.cgColor)

                    let xPosition = (CGFloat(item)*tickSpacing)+TimelineConstants.initialMargin
                    drawLongTick(at: CGPoint(x: xPosition, y: 0), withLabel: "\(item)")

                    if stickDesginer.shoudDraw(stickStyle: .MediumTicks) {
                        context?.setStrokeColor(timelineConfig?.rulerColor2.cgColor ?? UIColor.secondaryLabel.cgColor)

                        drawMediumTick(at: CGPoint(x: xPosition+tickSpacing/2, y: 0))

                        // medium Sticks With Number
                        if stickDesginer.shoudDraw(stickStyle: .MediumTicksWithNumber) {
                            context?.setStrokeColor(timelineConfig?.rulerColor3.cgColor ?? UIColor.tertiaryLabel.cgColor)
                            drawLabel("\(Double(item) + 0.5)", in: CGRect(origin: CGPoint(x: xPosition+tickSpacing/2-5.0, y:  labelHeight), size: CGSize(width: 30, height: labelHeight)))

                            // short Sticks
                            if stickDesginer.shoudDraw(stickStyle: .ShortTicks){
                                context?.setStrokeColor(timelineConfig?.rulerColor3.cgColor ?? UIColor.tertiaryLabel.cgColor)

                                for i in 1...10{
                                    if i%5 != 0 {
                                        drawShortTick(at: CGPoint(x: (xPosition + (tickSpacing) * CGFloat(CGFloat(i)/10)), y: 0))
                                    }
                                }
                            }
                        }
                    }
                }
                  
            }
                     
        }else {
            // Zoom Out Drawing
            // long Sticks With Number
           // if stickDesginer.shoudDraw(stickStyle: .LongTicksWithNumber) {
            
                for item in 0...numberOfLongTicks{
                    
                    var currentLabel = "\(item)"
                    
                    let xPosition = (CGFloat(item)*tickSpacing)+TimelineConstants.initialMargin
                    
                        
                    if stickDesginer.shoudDraw(stickStyle: .LongTicksSkip3Sec) {
                      
                        currentLabel = "\(item % 4 == 0 ? "\(item)" : "")"

                    }else if stickDesginer.shoudDraw(stickStyle: .LongTicksSkip2Sec) {
                        currentLabel = "\(item % 3 == 0 ? "\(item)" : "")"


                    }else  if stickDesginer.shoudDraw(stickStyle: .LongTicksSkip1Sec) {
                        currentLabel = "\(item % 2 == 0 ? "\(item)" : "")"
                        
                    }
                    
                    context?.setStrokeColor(currentLabel == "" ? timelineConfig?.rulerColor2.cgColor ?? UIColor.secondaryLabel.cgColor : timelineConfig?.rulerColor.cgColor ?? UIColor.label.cgColor)
                    
                    
                    drawLongTick(at: CGPoint(x: xPosition, y: 0), withLabel: "\(currentLabel)")


                    
                    // if
                    // Long Stick skip 1
                    // Long Stick skip 2
                    // Long Stick skip 3
                }
          //  }
        }
       
        // If Out
           
                    
  
              
    }
    var labelHeight : CGFloat = 8
    // MARK: - private methods
    
   private func drawLongTick(at point: CGPoint, withLabel label: String) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: point.x, y: point.y))
        path.addLine(to: CGPoint(x: point.x, y: point.y + longTickHeight))
        path.stroke()
        
        
       let labelFrame = CGRect(x: point.x-3, y:labelHeight, width: 30, height: labelHeight)
        
        if label != "" {
            
            drawLabel(label, in: labelFrame)
        }
    }

    private  func drawMediumTick(at point: CGPoint) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: point.x, y: point.y))
        path.addLine(to: CGPoint(x: point.x, y: point.y + mediumTickHeight))
        path.stroke()
    }
    
    private func drawShortTick(at point: CGPoint) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: point.x, y: point.y))
        path.addLine(to: CGPoint(x: point.x, y: point.y + shortTickHeight))
        path.stroke()
    }

    private func drawLabel(_ text: String, in frame: CGRect) {
     
//        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let font = UIFont.systemFont(ofSize: 12)
        let string = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor : UIColor.label])
        string.draw(at: frame.origin)
    }

  

 
    
  
    
 
    private struct TicksValidation {
        var ppw : CGFloat = 0.0
        var zoomLevel = ZoomLevel()

        init(ppw:CGFloat){
            self.ppw = ppw
        }
        
        enum StickStyle {
            case LongTicksWithNumber
            
            case MediumTicks
            case MediumTicksWithNumber
            case ShortTicks
            
            case LongTicksSkip1Sec
            case LongTicksSkip2Sec
            case LongTicksSkip3Sec
        }
        
        func shoudDraw(stickStyle: StickStyle) -> Bool {
           
            switch stickStyle {
            case .LongTicksWithNumber:
                ppw >= zoomLevel.ZoomOut && ppw <= zoomLevel.MaxZoomIn
            case .MediumTicks:
                ppw >= zoomLevel.ZoomIn && ppw <= zoomLevel.MaxZoomIn
            case .MediumTicksWithNumber:
                ppw >= zoomLevel.ZoomIn2X && ppw <= zoomLevel.MaxZoomIn
            case .ShortTicks:
                ppw > zoomLevel.ZoomIn3X  && ppw <= zoomLevel.MaxZoomIn
           
            case .LongTicksSkip1Sec:
                ppw <= zoomLevel.ZoomOut && ppw >= zoomLevel.MaxZoomOut
            case .LongTicksSkip2Sec:
                ppw <= zoomLevel.ZoomOut2X  && ppw >= zoomLevel.MaxZoomOut
            case .LongTicksSkip3Sec:
                ppw <= zoomLevel.MaxZoomOut  &&  ppw >= zoomLevel.MaxZoomOut

            }
        }
    }
   
    
    
    
   
}
