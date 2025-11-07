//
//  TextureResourceProvider.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation
import UIKit

public protocol TextureResourceProvider {
    func getDefaultImage() -> UIImage?
    func loadImageUsingQL(fileURL:URL , maxSize:CGSize) async -> CGImage?
    func readDataFromFileQLFromDocument(fileName: String , maxSize:CGSize) async -> CGImage?
    func readDataFromFileQLFromAssets(fileName: String , maxSize:CGSize) async -> CGImage?
    func readDataFromFileQLFromLocalAssets(fileName: String , maxSize:CGSize) async -> CGImage?
    func fetchImage(imageURL: String) async throws -> UIImage?
    func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory : URL) throws
    func getAssetsPath() -> URL?
}

public protocol DependencyResolverProtocol: AnyObject {
    func resolve<T>(_ type: T.Type) -> T?
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T?
    func resolve<T>(id: String, type: T.Type, argument: Any?) -> T?
}

public enum DependencyResolver {
    public private(set) static var shared: DependencyResolverProtocol?
    
    public static func register(_ resolver: DependencyResolverProtocol) {
            DependencyResolver.shared = resolver
        }
}

@propertyWrapper
struct Injected<Dependency> {
    var wrappedValue: Dependency

    init(_ key: String? = nil, argument: Any? = nil) {
        guard let resolver = DependencyResolver.shared else {
            fatalError("❌ No DependencyResolver registered. Call DependencyResolver.register(...) at app startup.")
        }

        if let key = key, let resolved = resolver.resolve(id: key, type: Dependency.self, argument: argument) {
            self.wrappedValue = resolved
        } else if let resolved = resolver.resolve(Dependency.self) {
            self.wrappedValue = resolved
        } else {
            fatalError("❌ Dependency not found for \(Dependency.self)")
        }
    }
}
