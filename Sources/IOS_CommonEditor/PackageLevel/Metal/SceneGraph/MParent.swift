//
//  MParent.swift
//  VideoInvitation
//
//  Created by HKBeast on 22/08/23.
//

import Foundation
import Metal

struct MContext {
    var drawableSize : CGSize
    var rootSize : CGSize = .zero
    var pageSize : CGSize = .zero
    
   // var currentTime : Float = .zero
}

class MParent:MChild{
    
    
    var editState : Bool = false
    
    
    var backgroundChild:BGChild? = nil
    var watermarkChild : MWatermark? = nil
    var childern: [MChild]!
    var myFBOTexture: MTLTexture!
    var samplerState: MTLSamplerState!
    var textureDescriptorOffline: MTLTextureDescriptor!
    var sampleDescriptor: MTLSamplerDescriptor!
    
    var allChild:[MChild]{
        
        var childs:[MChild] = childern
        if backgroundChild != nil{
            backgroundChild?.parent = self
            childs.insert(backgroundChild!, at: 0)
            
        }
        if watermarkChild != nil && canRenderWatermark{ // Discuss about this problem
            watermarkChild?.parent = self
            childs.append(watermarkChild!)
        }
        
        return childs
    }
    
    
   override var context : MContext {
       
       willSet {
           if context.drawableSize != newValue.drawableSize {
               var size = getProportionalSize(currentSize: size, newSize: newValue.drawableSize)
               createEmptyFBOTexture(drawableSize: size)
           }
           
       }
        didSet {
           
            
            allChild.forEach { child in
                child.context = context
            }
        }
    }
    
     init(model: ParentModel) {
         super.init(model: model)
       
         //createEmptyTexture(drawableSize: context.drawableSize)
        
        
        childern = [MChild]()
        switchTo(type: .ParentRender)
    }
    
    func getMaxChildStartTime() ->Float{
        return childern.compactMap { $0.startTime }.max() ?? 0.0
    }
    
    override func setFragmentData(parentEncoder: MTLRenderCommandEncoder) {
//        super.setFragmentData(parentEncoder: parentEncoder)
        parentEncoder.bind(texture: myFBOTexture)
        parentEncoder.bind(opacity: &mOpacity)
        
    }
    
   
    
    override func setVertexData(parentEncoder: MTLRenderCommandEncoder) {
        parentEncoder.bind(geometry: geometry)
        parentEncoder.bind(modalConstants: &modalConstant)
        parentEncoder.bind(flipTypeHorizontal: &mFlipType_hori)
        parentEncoder.bind(flipTypeVertical: &mFlipType_vert)
        var currentTime = currentTime
        parentEncoder.bind(timeForVertex: &currentTime)
    }
}

extension MParent : FBOTexturable {
   
    
   
   
    func createEmptyFBOTexture(drawableSize: CGSize) {
        sampleDescriptor = MTLSamplerDescriptor()
        sampleDescriptor.minFilter = .linear
        sampleDescriptor.magFilter = .linear
        samplerState = MetalDefaults.GPUDevice.makeSamplerState(descriptor: sampleDescriptor)
        
        
        //if  myFBOTexture == nil  {
      
            textureDescriptorOffline = MTLTextureDescriptor()
            textureDescriptorOffline.textureType = .type2D
            textureDescriptorOffline.width = Int(drawableSize.width)
            textureDescriptorOffline.height = Int(drawableSize.height)
            textureDescriptorOffline.pixelFormat = MetalDefaults.MainPixelFormat
        textureDescriptorOffline.usage = [.renderTarget,.shaderRead,.renderTarget]
            myFBOTexture = MetalDefaults.GPUDevice.makeTexture(descriptor: textureDescriptorOffline)
       // }
    }
    
    func prepareMyChildern() {
        allChild.forEach { child in
           
            if let parentable = child as? MParent {
                parentable.prepareMyChildern()
                
            }else {
                child.preRenderCalculation()
            }
        }
        self.preRenderCalculation()

    }
    
    func renderMyChildren(commandBuffer: MTLCommandBuffer) {
        
        // before rendering check if self is alive(currentTime)
        parentableChilds.forEach { parentable in
            parentable.renderMyChildren(commandBuffer: commandBuffer)
            }
        
        // TODO: -  JD Filtering And Adjustment Pending Engine 2.0
        allChild.forEach { child in
            if let compute = child as? TexturableChild {
                let encoder = commandBuffer.makeComputeCommandEncoder()!

                compute.precomuteData(computeEncoder: encoder)
                encoder.endEncoding()

            }
        }
        
        
      
        if let FBO = getLocalRenderEncoder(from: commandBuffer) {
            FBO.label = "\(self)"
            FBO.setFragmentSamplerState(samplerState, index: FRAGMENT_BUFFER_INDEX.SAMPLER_INDEX)
            
            allChild.forEach { child in
              
                    child.renderOnParent(parentEncoder: FBO)
                

            }
            FBO.endEncoding()
            
//           let thumbImage = Conversion.textureToUIImage(myFBOTexture)
//            
//            printLog("image",thumbImage?.mySize)
            
            
        }
    }
    
 

   
    
 
    
    
    
}



protocol FBOTexturable {
    var editState : Bool {get set}
    var myFBOTexture : MTLTexture! { get}
    var samplerState : MTLSamplerState! {get}
    var textureDescriptorOffline : MTLTextureDescriptor! {get}
    var sampleDescriptor : MTLSamplerDescriptor! { get}

    func createEmptyFBOTexture(drawableSize:CGSize)
    func prepareMyChildern()
    func renderMyChildren(commandBuffer:MTLCommandBuffer)
}

extension FBOTexturable {
    func getLocalRenderEncoder(from commandBuffer : MTLCommandBuffer) -> MTLRenderCommandEncoder? {
        let childTextureRPD = MTLRenderPassDescriptor()
                childTextureRPD.colorAttachments[0].texture = myFBOTexture
        childTextureRPD.colorAttachments[0].loadAction = .clear
//        if self is MScene {
//            childTextureRPD.colorAttachments[0].clearColor = MetalClearColors.Green
//
//        }
//        else
       
        if self is MPage {
            childTextureRPD.colorAttachments[0].clearColor = MetalClearColors.transparent

      } else if self is MParent {
          childTextureRPD.colorAttachments[0].clearColor = editState ? MetalClearColors.Green :  MetalClearColors.transparent
      }else{
          childTextureRPD.colorAttachments[0].clearColor = MetalClearColors.transparent
 }
                    childTextureRPD.colorAttachments[0].storeAction = .store
       
        
        
        return commandBuffer.makeRenderCommandEncoder(descriptor: childTextureRPD)
    }
}



/*
 
 Draw() {
 
 1. PreRender Calcualtion - transofrm // stop
 2. PreComputation - Alive
 3. RendernPArent - Alive
 
 }
 
 
 */

extension MParent{
    
    // create decrease and increase function for
    func decreaseChildOrderInParent(order:Int){
        if order >= childern.count{
            return
        }
        for ord in order..<childern.count{
            let child = childern[ord]
            child.mOrder -= 1

        }
    }
    
    func decreaseChildOrderInParent(order:Int,at:Int){
        if order >= childern.count{
            return
        }
       
        for ord in order...at{
           
            let child = childern[ord]
            logger?.printLog("scene decrease old Order \(child.mOrder)")
            child.mOrder -= 1
            logger?.printLog("scene decrease new Order \(child.mOrder)")

        }
    }
    
    
    func increaseChildOrderInParent(order:Int){
        if order >= childern.count{
            return
        }
        for ord in order..<childern.count{
            if ord >= childern.count{
                return
            }
            let child = childern[ord]
            child.mOrder += 1

        }
    }
    
    func increaseChildOrderInParent(order:Int,at:Int){
        if order >= childern.count{
            logger?.printLog("Oreder is grater than childCount \(order)->\(childern.count)")

            return
        }
        
        for ord in order...at{
            
            let child = childern[ord]
            logger?.printLog("scene increase old Order \(child.mOrder)")
            child.mOrder += 1
            logger?.printLog("scene increase new Order \(child.mOrder)")

        }
    }
    
    func decreaseOrderOFChildren(from order: Int, to: Int, duration: Float) -> ([Int: Int], Float)? {
        // Check if the 'from' and 'to' indices are within valid bounds
        guard order >= 0, to >= 0, order < childern.count, to < childern.count else {
            print("Error: Invalid 'from' or 'to' index.")
            return nil
        }
        
        // Check if 'from' index is less than or equal to 'to' index
        guard order <= to else {
            print("Error: 'from' index should be less than or equal to 'to' index.")
            return nil
        }

        var updatedID = [Int: Int]()
        let startTime = childern[to].startTime

        // Loop through the children in the range and update their order and start time
        for ord in order...to {
            let child = childern[ord]
            
            // Ensure that the order does not become negative
            if child.mOrder <= 0 {
                print("Error: mOrder cannot be less than or equal to zero.")
                return nil
            }

            // Ensure that the start time does not become negative
            if child.startTime - duration < 0 {
                print("Error: startTime cannot become negative.")
                return nil
            }

            child.mOrder -= 1
            child.startTime -= duration
            updatedID[child.id] = child.mOrder
        }
        
        return (updatedID, startTime)
    }
    
    func increaseOrderOFChildren(from order: Int, to: Int, duration: Float) -> ([Int: Int], Float)? {
        // Check if the 'from' and 'to' indices are within valid bounds
        guard order >= 0, to >= 0, order < childern.count, to < childern.count else {
            print("Error: Invalid 'from' or 'to' index.")
            return nil
        }
        
        // Check if 'from' index is less than or equal to 'to' index
        guard order <= to else {
            print("Error: 'from' index should be less than or equal to 'to' index.")
            return nil
        }

        var updatedID = [Int: Int]()
        let startTime = childern[order].startTime

        // Loop through the children in the range and update their order and start time
        for ord in order...to {
            let child = childern[ord]
            
            // Ensure that updating the order does not result in invalid state
            if child.mOrder >= Int.max {
                print("Error: mOrder has reached its maximum value.")
                return nil
            }

            child.mOrder += 1
            child.startTime += duration
            updatedID[child.id] = child.mOrder
        }
        
        return (updatedID, startTime)
    }
}

extension MParent {
    func changeOrder(child:MChild,oldOrder:Int,newOrder:Int) {
        guard oldOrder != newOrder else {
               print("No change in order.")
               return
           }

      
                // If moving up in the order (from higher index to lower index)
                   if oldOrder > newOrder {
                       // Move the child from old position to the new position
                      addChild(child, at: newOrder)
                       print("scene addChild",newOrder+1)
                       
                       child.mOrder = newOrder
                      // removeChild(at: oldOrder+1)
                       removeChild(at: oldOrder)
                       increaseChildOrderInParent(order: newOrder+1, at: oldOrder)
                   }
                   // If moving down in the order (from lower index to higher index)
                   else if oldOrder < newOrder {
                       // Move the child from old position to the new position
                       addChild(child, at: newOrder + 1)
                     
                       print("scene addChild",newOrder)
                       child.mOrder = newOrder
                       removeChild(at: oldOrder)

                  
                       decreaseChildOrderInParent(order: oldOrder, at: newOrder-1)
                   }
    }
    
  
}
