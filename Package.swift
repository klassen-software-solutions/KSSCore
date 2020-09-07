// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSSCore",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v13),
    ],
    products: {
        let products: [Product] = [
            .library(name: "KSSFoundation", targets: ["KSSFoundation"]),
            .library(name: "KSSTest", targets: ["KSSTest"]),
        ]
//#if os(macOS)
//        products.append(contentsOf: [
//            .library(name: "KSSMap", targets: ["KSSMap"]),
//            .library(name: "KSSUI", targets: ["KSSUI"]),
//            .library(name: "KSSWeb", targets: ["KSSWeb"]),
//        ])
//#endif
        return products
    }(),
    dependencies: [],
    targets: {
        let targets: [Target] = [
            .target(name: "KSSFoundation", dependencies: []),
            .target(name: "KSSTest", dependencies: []),
            .testTarget(name: "KSSFoundationTests", dependencies: ["KSSFoundation"]),
            .testTarget(name: "KSSTestTests", dependencies: ["KSSTest"]),
        ]
//#if os(macOS)
//        targets.append(contentsOf: [
//            .target(name: "KSSUI", dependencies: ["KSSFoundation", "KSSCocoa"]),
//            .target(name: "KSSMap", dependencies: ["KSSFoundation", "KSSCocoa"]),
//            .target(name: "KSSWeb", dependencies: ["KSSFoundation", "KSSCocoa"]),
//            .testTarget(name: "KSSCocoaTests", dependencies: ["KSSCocoa"]),
//            .testTarget(name: "KSSUITests", dependencies: ["KSSUI"]),
//            .testTarget(name: "KSSWebTests", dependencies: ["KSSWeb"]),
//        ])
//#endif
        return targets
    }()
)
