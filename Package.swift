// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "JSONDrivenUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "JSONDrivenUI",
            targets: ["JSONDrivenUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
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
