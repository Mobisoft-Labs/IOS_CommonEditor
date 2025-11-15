//
//  GradientParser.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation

public func parseGradient(from jsonString: String) -> GradientInfo? {
    
    let data = jsonString.data(using: .utf8)!
    let decoder = JSONDecoder()
    
    do {
        let gradient = try decoder.decode(GradientInfo.self, from: data)
        return gradient
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

public func convertGradientToJSONString(_ gradient: GradientInfo) -> String? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let data = try encoder.encode(gradient)
        return String(data: data, encoding: .utf8)
    } catch {
        print("Error encoding JSON: \(error)")
        return nil
    }
}
