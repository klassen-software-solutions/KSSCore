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
//            .library(name: "KSSUI", targets: ["KSSUI"]),
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
//            .testTarget(name: "KSSUITests", dependencies: ["KSSUI"]),
//        ])
//#endif
        return targets
    }()
)
