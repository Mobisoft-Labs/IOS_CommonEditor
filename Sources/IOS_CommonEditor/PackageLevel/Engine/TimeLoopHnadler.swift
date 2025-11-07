//
//  TimeManager.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 27/01/23.
//

import MetalKit
import QuartzCore

import Combine

protocol TimeLooperListener : AnyObject {
//    func onDrawCall(currentTime: Float)
//    func onDrawCallStop()
    
    var currentTime : Float {get}
    var renderState : SceneRenderingState { get set }
    var replayAutomatically : Bool {get set}
    var isManualScrolling : Bool {get set}
    func setCurrentTime(_ time: Float)
    
}



public protocol PlayerControlsReadObservableProtocol {
    var playerControlsCancellables: Set<AnyCancellable> { get set }
    func observePlayerControls()
}

//enum TimeStatus {
//    case Start,Stop,Pause,Resume,Playing,NotStarted,Unknown,Manual
//}

public enum SceneRenderingState {
    case Prepared , Playing , Paused , Stopped , Completed
}



public class TimeLoopHnadler : DrawCallListener , TimeLooperListener ,PlayerControlsReadObservableProtocol, ObservableObject {
 
    public func setCurrentTime(_ time: Float) {
        self.currentTime = time.roundToDecimal(2)
    }
    
    public var isManualScrolling: Bool = true
    
    public var playerControlsCancellables: Set<AnyCancellable> = []
    weak var drawCallManager : DrawCallManager?
    
    var logger: PackageLogger?
    
    @Published public var currentTime: Float = 0
    
    @Published  public var renderState : SceneRenderingState = .Prepared
    
    @Published   var replayAutomatically: Bool = false
    
    @Published public var timeLengthDuration: TimeInterval = .zero

    var ID: Int = 0
    
    
    
    
    deinit {
        logger?.printLog("de-init \(ID) TimeLoop.deinit")
    }
  
    
//    enum TimeStatus {
//        case Restart
//        case Playing
//        case Pause
//        
//    }
    
  //  var timeStatus : TimeStatus = .Playing
    
    private(set) var timeSinceLastDraw: TimeInterval = 0.0
    private var _globalTimeOnStart: TimeInterval = 0.0
    public var _LastPausedTime: TimeInterval = 0.0


    init( timeLengthDuration : TimeInterval  , autoPlay: Bool = false , drawCallManager : DrawCallManager? ) {
      
        self.timeLengthDuration = timeLengthDuration
        self.drawCallManager = drawCallManager
        self.replayAutomatically = autoPlay
        
//        self.$currentTime.sink { [unowned self] value in
//
//        }
        observePlayerControls()
        
       
    }
    
    func setPackagelogger(logger: PackageLogger){
        self.logger = logger
    }
    
    public func observePlayerControls() {
        
        playerControlsCancellables.removeAll()
        logger?.logVerbose("TimeLoopHandler + PlayerControls listeners ON \(playerControlsCancellables.count)")

        self.$renderState.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
           
            case .Prepared:
                lastCurrentTime = 0.0
                currentTime = 0.0
                drawCallManager?.removeListener(self)

//            case .Restart:
//                currentTime = 0.0
//                drawCallManager.removeListener(self)
//                drawCallManager.addListener(self)
            case .Playing:
               // currentTime = Float(lastCurrentTime)
               // timeStatus = .Restart
                drawCallManager?.addListener(self)
            case .Paused:
               // timeStatus = .Pause
               // currentTime = Float(lastCurrentTime)
                drawCallManager?.removeListener(self)
            case .Stopped:
                lastCurrentTime = 0.0
                currentTime = 0.0
                
                drawCallManager?.removeListener(self)
                
            case .Completed:
                lastCurrentTime = 0.0
                currentTime = 0.0
                drawCallManager?.removeListener(self)
           
            }
        }.store(in: &playerControlsCancellables)
    }
    
    
    
//    public var currentTimeInSec : Float {
//        get {
//            return Float(timeSinceLastDraw.truncatingRemainder(dividingBy: 1000))
//        }
//        set {
//            
//          //  timeStatus = .Manual
//            timeSinceLastDraw = TimeInterval(newValue)//*100
//          //  updateTimer()
//        }
//    }
    var lastCurrentTime = 0.0
  
   
       private func updateTimer(){

          
           
          manageControlsInternally()
           
           currentTime += Float(1.0/Double(MetalDefaults.PreferredFrameRate))
           logger?.printLog("CurrentTime: \(currentTime)")
           lastCurrentTime = Double(currentTime)
         
     }

    
   private func manageControlsInternally(){
        
        // check if currentTime crosses duration
//       weak var drawCallManager : DrawCallManager?

       if currentTime > Float(timeLengthDuration) && renderState == .Playing {
            if replayAutomatically {
                renderState = .Prepared
                renderState = .Playing
            }else{
                renderState = .Stopped
            }
        }
       
      
    }
    
    internal  func onDrawCallListened(_ displayLink: CADisplayLink) {
        self.updateTimer()
    }
    
}

public enum AnimationLoopState {
    case Start(duration:Float,startTim:Float,type:PreviewAnimType),Stop
}



public class AnimationTimeLoopHnadler : DrawCallListener   {
    
    var cancellables: Set<AnyCancellable> = []
    weak var drawCallManager : DrawCallManager?
    
    @Published  var currentAnimTime: Float = 0
    
    @Published public var animLoopState : AnimationLoopState = .Stop
    
    
    var ID: Int = 1
    var logger: PackageLogger?
    
    
    
    deinit {
        logger?.printLog("\(ID) TimeLoop.deinit")
    }
 
    private(set) var timeLengthDuration: TimeInterval  = 0

    init(drawCallManager : DrawCallManager ) {
      
      
        self.drawCallManager = drawCallManager
        
        self.$animLoopState.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
           
//            case .Prepared:
//                currentTime = 0.0
//                drawCallManager.removeListener(self)
//
//            case .Playing:
//               // timeStatus = .Restart
//                drawCallManager.addListener(self)
//            case .Paused:
//               // timeStatus = .Pause
//                drawCallManager.removeListener(self)
//            case .Stopped:
//                
//                drawCallManager.removeListener(self)
//                currentTime = 0.0
//            case .Completed:
//                currentTime = 0.0
              //  drawCallManager.removeListener(self)
           
            case .Start(duration: let duration, startTim: let startTime, type: let type) :
                drawCallManager.removeListener(self)
                self.timeLengthDuration = TimeInterval(duration)
                currentAnimTime = startTime
                drawCallManager.addListener(self)

            case .Stop:
               // currentAnimTime = 0.0
                drawCallManager.removeListener(self)
            }
        }.store(in: &cancellables)
    }
    
    
    func setPackageLogger(logger: PackageLogger){
        self.logger = logger
    }
    
   
       private func updateTimer(){

          
           
          manageControlsInternally()
           
           currentAnimTime += Float(1.0/Double(MetalDefaults.PreferredFrameRate))
           logger?.printLog("currentAnimTime: \(currentAnimTime)")

         
     }

    
   private func manageControlsInternally(){
        
        // check if currentTime crosses duration
      // weak var drawCallManager : DrawCallManager?

       if currentAnimTime >= Float(timeLengthDuration) {
            
                animLoopState = .Stop
            
        }
       
      
    }
    
    internal  func onDrawCallListened(_ displayLink: CADisplayLink) {
        self.updateTimer()
    }
    
}

//class DisplayLinkWrapper: ObservableObject , DrawCallListener {
//    var ID: Int = 0
//    
//  internal  func onDrawCallListened(_ displayLink: CADisplayLink) {
//        self.handleDisplayLink()
//    }
//    
//    var animationDuration: TimeInterval = 1.0
//    var currentTime: TimeInterval = 0.0
//    var animationProgress: Double = 0.0 {
//        didSet {
//            // Notify SwiftUI when progress changes
//            objectWillChange.send()
//        }
//    }
//    
//    
//    init( animationDuration : TimeInterval  , loopTime: Int = 1 , drawCallManager : DrawCallManager ) {
//        
//    }
//    func startAnimation() {
//        stopAnimation() // Stop any ongoing animation
//        
//       
//    }
//    
//    func stopAnimation() {
//        displayLink?.invalidate()
//        displayLink = nil
//    }
//    
//    @objc func handleDisplayLink() {
//        let progress = min(1.0, max(0.0, currentTime / animationDuration))
//        
//        animationProgress = progress
//        
//        if progress >= 1.0 {
//            stopAnimation()
//        }
//        
//        currentTime += displayLink!.duration
//    }
//    
//    manageControlsInternally()
//     
//     currentTime += Float(1.0/Double(MetalDefaults.PreferredFrameRate))
//     printLog("CurrentTime:",currentTime)
//    
//    if currentTime > Float(timeLengthDuration) && renderState == .Playing {
//         if replayAutomatically {
//             renderState = .Prepared
//             renderState = .Playing
//         }else{
//             renderState = .Stopped
//         }
//     }
//}
