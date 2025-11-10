//
//  ShadersLibrary.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 14/02/23.
//

import MetalKit

enum ShaderType {
    case VERTEX , FRAGMENT , COMPUTE
}

// update every new shader added
public enum VertexShaderTypes : String {
    case standard_Vertex_Shader = "standardVertexShader"
    case passThrough_vertexShader = "passThrough_vertexShader"
}

public enum FragmentShaderTypes : String {
    case passThrough_fragmentShader = "passThrough_fragmentShader"
    case texture2_fragment_function = "texture2_fragment_function"
    case fbo_render_fragment_shader = "fbo_render_fragment_shader"
    case passthough_image_fragmentShader = "passthough_image_fragmentShader"
    case ImageFragmentShader = "imageFragmentShader"
    case ColorFragmentShader = "colorFragmentShader"
    case passThrough_fragmentShader2 = "passThrough_fragmentShader2"


}


public enum ComputeShaderTypes : String {
    case adjustments = "adjustments"
}

protocol MShader {
    var name: String { get }
    var functionName: String { get }
    var function: MTLFunction! { get }
    var shaderType: ShaderType { get }
}

class FragmentShader : MShader {
    @Injected var shaderLibrary : ShaderLibrary

    var name: String = ""
    var functionName: String = ""
    var function: MTLFunction!
    var shaderType: ShaderType

    init(name: String) {
        self.name = name
        self.functionName = name
        self.shaderType = .FRAGMENT

        function = shaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
}

class VertexShader : MShader {
    @Injected var shaderLibrary : ShaderLibrary
//
//    private var shaderLibrary: ShaderLibrary {
//            guard let lib = DependencyResolver.shared?.resolve(ShaderLibrary.self) else {
//                fatalError("❌ ShaderLibrary not found in resolver")
//            }
//            return lib
//        }
    
    var name: String
    var functionName: String
    var function: MTLFunction!
    var shaderType: ShaderType

    init(name: String) {
        self.name = name
        self.functionName = name
        self.shaderType = .VERTEX

        function = shaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
}

class ComputeShader : MShader {
    @Injected var shaderLibrary : ShaderLibrary

    var name: String
    var functionName: String
    var function: MTLFunction!
    var shaderType: ShaderType

    init(name: String) {
        self.name = name
        self.functionName = name
        self.shaderType = .COMPUTE

        function = shaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
    
}




// MARK: - LIBRARY HERE
public class ShaderLibrary {
    
    public  var DefaultLibrary: MTLLibrary!
    
    private var vertexShaders: [String: MShader] = [:]
    private var fragmentShaders: [String: MShader] = [:]
    private var computeShaders: [String: MShader] = [:]

    var logger: PackageLogger?
    
    public func initialise(logger: PackageLogger){
        DefaultLibrary = try? MetalDefaults.GPUDevice.makeDefaultLibrary(bundle: .module)
        setPackLogger(logger: logger)
        loadDefaultShaders()
        
    }
    
    func setPackLogger(logger: PackageLogger){
        self.logger = logger
    }
    
    public init() {
//        initialise()
    }
    public func cleanUp() {
        vertexShaders.removeAll()
        fragmentShaders.removeAll()
        computeShaders.removeAll()
    }
    // update every new shader added
//   static func setDefaultShaders() {
//
//   }
    
    public func getVertexFunction(_byType vertexShaderType: VertexShaderTypes)->MTLFunction{
        return getVertexFunction(_byName: vertexShaderType.rawValue)
    }
    public func getVertexFunction(_byName vertexShaderName: String)->MTLFunction{
       
        if let function =  vertexShaders[vertexShaderName]?.function {
            logger?.printLog("Set Vertex Shaders")
            return function
        }else{
            addNewShader(name: vertexShaderName, type: .VERTEX)
            return  vertexShaders[vertexShaderName]!.function
        }
    }

    public func getFragment(_byType fragmentShaderType: FragmentShaderTypes)->MTLFunction{
        return getFragment(_byName: fragmentShaderType.rawValue)
    }
   
   
    public func getFragment(_byName fragmentShaderName: String)->MTLFunction{
        if let function =  fragmentShaders[fragmentShaderName]?.function {
            logger?.printLog("Loading Fragment Shaders")
            return function
        }else{
            addNewShader(name: fragmentShaderName, type: .FRAGMENT)
            return  fragmentShaders[fragmentShaderName]!.function
        }
    }
    
    
    public func getCompute(_byType computeShaderType: ComputeShaderTypes)->MTLFunction{
        return getCompute(_byName: computeShaderType.rawValue)
    }
    public func getCompute(_byName computeShaderType: String)->MTLFunction{
        if let function =  computeShaders[computeShaderType]?.function {
            return function
        }else{
            addNewShader(name: computeShaderType, type: .COMPUTE)
            return  computeShaders[computeShaderType]!.function
        }
    }
//
//
func loadDefaultShaders() {
       addNewShader(name: "passThrough_V_F", type: .VERTEX)
       addNewShader(name: "passThrough_V_F_position", type: .VERTEX)
       
       addNewShader(name: "basic_fragment_function", type: .FRAGMENT)
       addNewShader(name: "texture2_fragment_function", type: .FRAGMENT)
       addNewShader(name: "fbo_render_fragment_shader", type: .FRAGMENT)
       addNewShader(name: "imageFragmentShader", type: .FRAGMENT)
       addNewShader(name: "passthough_image_fragmentShader", type: .FRAGMENT)
    addNewShader(name: "passThrough_fragmentShader", type: .FRAGMENT)
    addNewShader(name: "passThrough_fragmentShader2", type: .FRAGMENT)

       addNewShader(name: "colorFragmentShader", type: .FRAGMENT)
       addNewShader(name: "adjustments", type: .COMPUTE)

    }
    
    private func addNewShader(name:String,type:ShaderType) {
        if type == .FRAGMENT {
            let shader = FragmentShader(name: name)
            fragmentShaders.updateValue(shader, forKey: name)
        } else if type == .VERTEX {
            let shader = VertexShader(name: name)
             vertexShaders.updateValue(shader, forKey: name)
         }else if type == .COMPUTE {
             let shader = VertexShader(name: name)
              computeShaders.updateValue(shader, forKey: name)
          }
    }

}



//func getBackgroundPipelineDecsriptor()->MTLRenderPipelineDescriptor {
//    var renderPipelineDescriptor = MTLRenderPipelineDescriptor()
//    renderPipelineDescriptor.colorAttachments[0].pixelFormat = MetalDefaults.MainPixelFormat
//    renderPipelineDescriptor.vertexFunction = ShaderLibrary.getVertexFunction(_byName: "passThrough_V_F")
//    renderPipelineDescriptor.fragmentFunction = ShaderLibrary.getFragment(_byName: "fbo_render_fragment_shader")
//    renderPipelineDescriptor.depthAttachmentPixelFormat = MetalDefaults.DepthPixelFormat
//    renderPipelineDescriptor.vertexDescriptor = MVertexDescriptorLibrary.get(_vertexDescriptorBy: .PositionColorTexture)
//    renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
//    renderPipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
//    renderPipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
//    renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
//    renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .destinationAlpha
//    renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
//    renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
//    return renderPipelineDescriptor
//}
//
//func getBGrenderPipelineState()->MTLRenderPipelineState? {
//    do {
//         var renderPipelineState = try MetalDefaults.GPUDevice.makeRenderPipelineState(descriptor: getBackgroundPipelineDecsriptor())
//        return renderPipelineState
//    } catch let error as NSError {
//        printLog("ERROR::CREATE::RENDER_PIPELINE_STATE::__'BGObject'__::\(error)")
//        return nil
//    }
//
//}
