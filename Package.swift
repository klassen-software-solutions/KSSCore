// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSSCore",
    products: [
        .library(name: "KSSFoundation", targets: ["KSSFoundation"]),
        .library(name: "KSSCocoa", targets: ["KSSCocoa"]),
        .library(name: "KSSUI", targets: ["KSSUI"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "KSSFoundation", dependencies: []),
        .target(name: "KSSCocoa", dependencies: ["KSSFoundation"]),
        .target(name: "KSSUI", dependencies: ["KSSFoundation"]),
        .testTarget(name: "KSSFoundationTests", dependencies: ["KSSFoundation"]),
    ]
)
