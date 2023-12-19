// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONDrivenUI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JSONDrivenUI",
            targets: ["JSONDrivenUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
