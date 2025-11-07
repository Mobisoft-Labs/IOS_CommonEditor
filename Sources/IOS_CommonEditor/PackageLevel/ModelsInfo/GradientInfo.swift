//
//  GradientInfo.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation

public struct GradientInfo :AnyBGContent,Codable{
    public var GradientType: Int
    public var StartColor: Int
    public var EndColor: Int
    public var Radius: Float
    public var AngleInDegrees:Float
    
    public init(GradientType: Int, StartColor: Int, EndColor: Int, Radius: Float, AngleInDegrees: Float) {
        self.GradientType = GradientType
        self.StartColor = StartColor
        self.EndColor = EndColor
        self.Radius = Radius
        self.AngleInDegrees = AngleInDegrees
    }
}
