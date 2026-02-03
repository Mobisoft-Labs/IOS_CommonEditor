// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let package = Package(
//    name: "IOS_CommonEditor",
//    products: [
//        // Products define the executables and libraries a package produces, making them visible to other packages.
//        .library(
//            name: "IOS_CommonEditor",
//            targets: ["IOS_CommonEditor"]),
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package, defining a module or a test suite.
//        // Targets can depend on other targets in this package and products from dependencies.
//        .target(
//            name: "IOS_CommonEditor"),
//
//    ]
//)

let package = Package(
    name: "IOS_CommonEditor",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "IOS_CommonEditor",
            targets: ["IOS_CommonEditor"]
        ),
        .library(
            name: "LayersV2Core",
            targets: ["LayersV2Core"]
        ),
    ],
    dependencies: [
        // ✅ Add FMDB dependency here
        .package(url: "https://github.com/ccgus/fmdb.git", from: "2.7.9")
    ],
    targets: [
        .target(
            name: "IOS_CommonEditor",
            dependencies: [
                // ✅ Link FMDB to this target
                .product(name: "FMDB", package: "fmdb")
            ]
        ),
        .target(
            name: "LayersV2Core",
            path: "LayersV2Core"
        ),
        .testTarget(
            name: "IOS_CommonEditorTests",
            dependencies: ["IOS_CommonEditor"]
        ),
        .testTarget(
            name: "LayersV2CoreTests",
            dependencies: ["LayersV2Core"]
        ),
    ],
    swiftLanguageModes: [.v5]
)
