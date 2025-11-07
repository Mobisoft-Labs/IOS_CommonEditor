//
//  Math.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 07/02/23.
//

import MetalKit
import simd
import GLKit

public var X_AXIS: float3{
    return float3(1,0,0)
}

public var Y_AXIS: float3{
    return float3(0,1,0)
}

public var Z_AXIS: float3{
    return float3(0,0,1)
}

extension matrix_float4x4 {
    
    mutating func multiplyBy(parentMatrix: matrix_float4x4) {
        self = matrix_multiply(parentMatrix, self)
    }
    
    mutating func translate(direction:float3) {
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            float4(1,0,0,0),
            float4(0,1,0,0),
            float4(0,0,1,0),
            float4(x,y,z,1)
        )
        
        self = matrix_multiply(self, result)
    }
    mutating func scale(axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            float4(x,0,0,0),
            float4(0,y,0,0),
            float4(0,0,z,0),
            float4(0,0,0,1)
        )
        
        self = matrix_multiply(self, result)
    }
    mutating func rotate(angle: Float, axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            float4(r1c1, r2c1, r3c1, r4c1),
            float4(r1c2, r2c2, r3c2, r4c2),
            float4(r1c3, r2c3, r3c3, r4c3),
            float4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
   
    mutating func skewTransform(angleInDegX: Float, angleInDegY: Float, pivotX: Float, pivotY: Float) {
        var baseSkew = matrix_float3x3(1.0) // Initialized to identity
        
        let fi =    deg2rad(Double(angleInDegX))  //radians(fromDegrees: angleInDegX)
        let theta = deg2rad(Double(angleInDegY))  //radians(fromDegrees: angleInDegY)
        
        // Initialize Skew values
        baseSkew[1][0] = Float(tan(fi))
        baseSkew[1][2] = -pivotX * tan(Float(fi))
        
        baseSkew[0][1] = Float(tan(theta))
        baseSkew[0][2] = -pivotY * Float(tan(theta))
        
        var base = matrix_float4x4(1.0)
        base[0][0] = baseSkew[0][0]
        base[0][1] = baseSkew[0][1]
        base[0][2] = 0.0
        base[0][3] = 0.0
        
        base[1][0] = baseSkew[1][0]
        base[1][1] = baseSkew[1][1]
        base[1][2] = 0.0
        base[1][3] = 0.0
        
        base[2][0] = 0.0
        base[2][1] = 0.0
        base[2][2] = 1.0
        base[2][3] = 0.0
        
        base[3][0] = baseSkew[2][0]
        base[3][1] = baseSkew[2][1]
        base[3][2] = 0.0
        base[3][3] = 1.0
        
       
        
        self = matrix_multiply(self, base)

    }
}

extension float4x4 {
  
    public init() {
    self = unsafeBitCast(GLKMatrix4Identity, to: float4x4.self)
  }
    public init(matrix: GLKMatrix4) {
        self.init(columns: (float4(x: matrix.m00, y: matrix.m01, z: matrix.m02, w: matrix.m03),
                            float4(x: matrix.m10, y: matrix.m11, z: matrix.m12, w: matrix.m13),
                            float4(x: matrix.m20, y: matrix.m21, z: matrix.m22, w: matrix.m23),
                            float4(x: matrix.m30, y: matrix.m31, z: matrix.m32, w: matrix.m33)))
    }
  
  static func makeScale(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeScale(x, y, z), to: float4x4.self)
  }
  
  static func makeRotate(_ radians: Float, _ x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeRotation(radians, x, y, z), to: float4x4.self)
  }
  
  static func makeTranslation(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeTranslation(x, y, z), to: float4x4.self)
  }
  
  static func makePerspectiveViewAngle(_ fovyRadians: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> float4x4 {
    var q = unsafeBitCast(GLKMatrix4MakePerspective(fovyRadians, aspectRatio, nearZ, farZ), to: float4x4.self)
    let zs = farZ / (nearZ - farZ)
    q[2][2] = zs
    q[3][2] = zs * nearZ
    return q
  }
  
  static func makeFrustum(_ left: Float, _ right: Float, _ bottom: Float, _ top: Float, _ nearZ: Float, _ farZ: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeFrustum(left, right, bottom, top, nearZ, farZ), to: float4x4.self)
  }
  
  static func makeOrtho(_ left: Float, _ right: Float, _ bottom: Float, _ top: Float, _ nearZ: Float, _ farZ: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeOrtho(left, right, bottom, top, nearZ, farZ), to: float4x4.self)
  }
  
  static func makeLookAt(_ eyeX: Float, _ eyeY: Float, _ eyeZ: Float, _ centerX: Float, _ centerY: Float, _ centerZ: Float, _ upX: Float, _ upY: Float, _ upZ: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ), to: float4x4.self)
  }
  
  
  mutating public func scale(_ x: Float, y: Float, z: Float) {
    self = self * float4x4.makeScale(x, y, z)
  }
  
  mutating public func rotate(_ radians: Float, x: Float, y: Float, z: Float) {
    self = float4x4.makeRotate(radians, x, y, z) * self
  }
  
  mutating public func rotateAroundX(_ x: Float, y: Float, z: Float) {
    var rotationM = float4x4.makeRotate(x, 1, 0, 0)
    rotationM = rotationM * float4x4.makeRotate(y, 0, 1, 0)
    rotationM = rotationM * float4x4.makeRotate(z, 0, 0, 1)
    self = self * rotationM
  }
  
  mutating public func translate(_ x: Float, y: Float, z: Float) {
    self = self * float4x4.makeTranslation(x, y, z)
  }
  
  static func numberOfElements() -> Int {
    return 16
  }
  
  static func degrees(toRad angle: Float) -> Float {
    return Float(Double(angle) * .pi / 180)
  }
  
  mutating public func multiplyLeft(_ matrix: float4x4) {
    let glMatrix1 = unsafeBitCast(matrix, to: GLKMatrix4.self)
    let glMatrix2 = unsafeBitCast(self, to: GLKMatrix4.self)
    let result = GLKMatrix4Multiply(glMatrix1, glMatrix2)
    self = unsafeBitCast(result, to: float4x4.self)
  }
  
}

