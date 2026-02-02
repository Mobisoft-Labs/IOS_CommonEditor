//
//  EngineConfiguration.swift
//  FlyerDemo
//
//  Created by HKBeast on 05/11/25.
//

import Foundation
import UIKit


public protocol EngineConfiguration {
    var progress: Float { get set }
    var isPremium: Bool { get }
    var canvasViewBGColor: UIColor { get }
    var contentScaleFactor: CGFloat { get }
    var getSnappingMode: Int { get }
    func fetchImage(imageURL: String) async throws -> UIImage?
    func downloadFontFromServer(fontName: String) async throws -> URL
    func downloadMusicFromServer(musicPath: String) async throws -> URL
    func readDataFromFileFromFontAssets(fileName: String) ->Data?
    func readDataFromFileFromMusic(fileName: String) -> Data?
    func readDataFromFileLocalMusic(fileName: String) -> Data?
    func readDataFromFileLocalAssets(fileName: String) -> Data?
    func readDataFromFileFromAssets(fileName: String) -> Data?
    func loadImageFromDocumentsDirectory(filename: String, directory : URL) throws -> UIImage?
    func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory : URL) throws
    func loadFontFromDocumentsDirectory(fontName: String) -> String?
    func getAssetsPath() -> URL?
    func getFontAssetsPath() -> URL?
    func getMuicPath() -> URL?
    func getLocalMusicPath() -> URL?
    func getBaseSize() -> CGSize
    func logReplaceSticker()
    func logAddText()
    func logAddSticker()
    func logGroup()
    func logResizeTapped()
    func logAddMusic()
    func logAddAnimation()
    func logAddBackground()
    func logUpdateText()
}
