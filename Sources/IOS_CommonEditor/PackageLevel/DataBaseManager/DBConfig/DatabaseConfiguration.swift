//
//  DatabaseConfiguration.swift
//  FlyerDemo
//
//  Created by HKBeast on 05/11/25.
//

import Foundation
import UIKit

//protocol DatabaseConfiguration{
//    var printLog: String { get }
//}

//public enum DBEnvironment {
//    public static var sharedLogger: PackageLogger?
//}

public protocol DBLogger {
    func printLog(_ message: String)
    func logInfo(_ message: String)
    func logError(_ message: String)
    func getDBPath() -> URL?
    func getDBName() -> String
    func getBaseSize() -> CGSize
    func getThumnailPath() -> URL?
    func getMyDesignsPath() -> URL?
    func documentsDirectoryNotFound() -> Error
    func fetchImage(imageURL: String) async throws -> UIImage?
    func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory : URL) throws
    func getAssetPath() -> URL?
}
