//
//  PackageLogger.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation

public enum ErrorTags : String {
    
    case LockAllLayers = "LockAllLayers"
    case isSelected = "IsSelected"
    case viewManager = "ViewManager"

    case selectedVsEdit = "selectedVsEdit"

}

public protocol PackageLogger {
    func logInfo(_ message: String)
    func logError(_ message: String)
    func logVerbose(_ message: String)
    func printLog(_ message: String)
    func getBaseSize() -> CGSize
    func logErrorJD(tag:ErrorTags, _ message: String)
    func logWarning(_ message: String)
}
