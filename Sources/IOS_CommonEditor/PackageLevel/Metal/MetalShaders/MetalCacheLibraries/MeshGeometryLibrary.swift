//
//  MeshGeometryLibrary.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 07/02/23.
//

import MetalKit
import simd
enum MMeshType {
    case Background , Sticker1 , Sticker2
}

struct MColor {
    static public var RedColor = float4(1.0,0.0,0.0,0.0)
    static public var BlueColor = float4(0.0,0.0,1.0,0.0)
    static public var BlackColor = float4(0.0,0.0,0.0,0.0)
    static public var GreenColor = float4(0.0,1.0,0.0,1.0)
}
protocol MeshGeometry {
    var vertexBuffer: MTLBuffer! { get }
    var indexBuffer : MTLBuffer! { get }
    var indicesCount: Int! { get }
    var vertexCount: Int! { get }
    var color : float4! { get }
    func updateCropRect(topLeft:float2,topRight:float2,bottomLeft:float2,bottomRight:float2)
}

public class BaseMesh : MeshGeometry {
    func updateCropRect(topLeft: float2, topRight: float2, bottomLeft: float2, bottomRight: float2) {
        
    }
    
   
    
    var indicesCount: Int! {
        return indices.count
    }
    
    var indexBuffer: MTLBuffer!
    var color: float4!
    var vertices: [Vertex]!
    var indices : [UInt16]!
    var vertexBuffer: MTLBuffer!
    var vertexCount : Int! {
        return vertices.count
    }
    
     init(color: float4) {
        self.color = color
        buildVertices()
        buildBuffer()
    }
    
    func buildVertices(){
        vertices = [

        Vertex(position: float3( 1,  1, 0), color:color, textCoords: float2(1,1)), //v0
        Vertex(position: float3(-1,  1, 0), color: color, textCoords: float2(0,1)), //v1
        Vertex(position: float3(-1, -1, 0), color: color, textCoords: float2(0,0)), //v2
        ]
        
        indices = [
            0, 1, 2,
            0, 2, 3
        ]
    }
    func buildBuffer() {
        vertexBuffer = MetalDefaults.GPUDevice.makeBuffer(bytes: vertices, length: Vertex.stride(vertexCount),options: [])
        indexBuffer = MetalDefaults.GPUDevice.makeBuffer(bytes: indices, length: UInt16.size(indices.count), options: [])

    }
}

public class QuadMesh : BaseMesh {
    override func buildVertices() {
        vertices = [
            Vertex(position: float3( 1,  1, 0), color:color, textCoords: float2(1,1)), //v0
            Vertex(position: float3(-1,  1, 0), color: color, textCoords: float2(0,1)), //v1
            Vertex(position: float3(-1, -1, 0), color: color, textCoords: float2(0,0)), //v2
            Vertex(position: float3( 1, -1, 0), color: color, textCoords: float2(1,0)), //v3
        ]
        indices = [
            0, 1, 2,
            0,2,3
        ]
    }
    
    func setVertices(size:CGSize) {
        var width : Float = Float(size.width)
        var height : Float = Float(size.height)
        
        vertices = [
            Vertex(position: float3( width,  height, 0), color:color, textCoords: float2(1,1)), //v0
            Vertex(position: float3(-width,  height, 0), color: color, textCoords: float2(0,1)), //v1
            Vertex(position: float3(-width, -height, 0), color: color, textCoords: float2(0,0)), //v2
            Vertex(position: float3( width, -height, 0), color: color, textCoords: float2(1,0)), //v3
        ]
        
        indices = [
            0, 1, 2,
            0,2,3
        ]
        
        buildBuffer()

    }
    
    
    override func updateCropRect(topLeft: float2, topRight: float2, bottomLeft: float2, bottomRight: float2) {
    
//        /*bottomRight*/  vertices[0].textCoords = bottomRight
//        /*bottomLeft*/   vertices[1].textCoords = bottomLeft
//        /*topLEft*/  vertices[2].textCoords = topLeft
//        /*topRight*/  vertices[3].textCoords = topRight
//   
//         buildBuffer()
    }
 
    
}
