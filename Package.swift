// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONDrivenUI",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "JSONDrivenUI",
            targets: ["JSONDrivenUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.11.0"),
    ],
    targets: [
        .target(
            name: "JSONDrivenUI",
            dependencies: [
                .byName(name: "Kingfisher"),
            ],
            exclude: ["Preview"]),
        .testTarget(
            name: "JSONDrivenUITests",
            dependencies: ["JSONDrivenUI"]),
    ]
)
