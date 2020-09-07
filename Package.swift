// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSSCore",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v13),
    ],
    products: [
        .library(name: "KSSFoundation", targets: ["KSSFoundation"]),
        .library(name: "KSSTest", targets: ["KSSTest"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "KSSFoundation", dependencies: []),
        .target(name: "KSSTest", dependencies: []),
        .testTarget(name: "KSSFoundationTests", dependencies: ["KSSFoundation"]),
        .testTarget(name: "KSSTestTests", dependencies: ["KSSTest"]),
    ]
)
