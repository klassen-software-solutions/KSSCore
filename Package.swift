// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSSCore",
    platforms: [
        .macOS(.v10_11)
    ],
    products: {
        var products: [Product] = [
            .library(name: "KSSFoundation", targets: ["KSSFoundation"]),
        ]
#if os(macOS)
        products.append(contentsOf: [
            .library(name: "KSSCocoa", targets: ["KSSCocoa"]),
            .library(name: "KSSMap", targets: ["KSSMap"]),
            .library(name: "KSSUI", targets: ["KSSUI"]),
            .library(name: "KSSWeb", targets: ["KSSWeb"]),
        ])
#endif
        return products
    }(),
    dependencies: [],
    targets: {
        var targets: [Target] = [
            .target(name: "KSSFoundation", dependencies: []),
            .testTarget(name: "KSSFoundationTests", dependencies: ["KSSFoundation"]),
        ]
#if os(macOS)
        targets.append(contentsOf: [
            .target(name: "KSSCocoa", dependencies: ["KSSFoundation"]),
            .target(name: "KSSUI", dependencies: ["KSSFoundation", "KSSCocoa"]),
            .target(name: "KSSMap", dependencies: ["KSSFoundation", "KSSCocoa"]),
            .target(name: "KSSWeb", dependencies: ["KSSFoundation", "KSSCocoa"]),
            .testTarget(name: "KSSCocoaTests", dependencies: ["KSSCocoa"]),
            .testTarget(name: "KSSUITests", dependencies: ["KSSUI"]),
            .testTarget(name: "KSSWebTests", dependencies: ["KSSWeb"]),
        ])
#endif
        return targets
    }()
)
