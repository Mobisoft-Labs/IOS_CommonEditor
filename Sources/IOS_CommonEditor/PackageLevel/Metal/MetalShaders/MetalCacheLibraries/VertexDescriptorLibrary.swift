//
//  VertexDescriptorLibrary.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 14/02/23.
//

import MetalKit
protocol MVertexDescriptor {
    var name: String {get}
    var vertexDescriptor : MTLVertexDescriptor {get}
}
enum MVertexDescriptorType {
    case PositionColorTexture
}

class PCTVertedDescriptor : MVertexDescriptor {
    var name: String = "Position Color Texture VertexDescriptor"
    var vertexDescriptor : MTLVertexDescriptor
    
    init() {
        vertexDescriptor = MTLVertexDescriptor()
        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        // color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size1
        
        // textCOrd
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = float3.size1 + float4.size1
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
    }
}

// MARK: - "LIBRARY HERE ---"
public class MVertexDescriptorLibrary {
    
    private  var vertesDescriptors: [MVertexDescriptorType: MVertexDescriptor] = [:]

    public  func cleanUp() {
        vertesDescriptors.removeAll()
    }
    
    public init() {
//       initialise()
    }
     func initialise() {
       vertesDescriptors.updateValue(PCTVertedDescriptor(), forKey: .PositionColorTexture)
   }
    
    func get(_vertexDescriptorBy type: MVertexDescriptorType) -> MTLVertexDescriptor {
        return  vertesDescriptors[type]!.vertexDescriptor
    }
    
   
}


