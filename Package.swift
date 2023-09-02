// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiveViewNativeLiveForm",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0"),
        .watchOS("9.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LiveViewNativeLiveForm",
            targets: ["LiveViewNativeLiveForm"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/liveviewnative/liveview-client-swiftui.git", branch: "revert-navigation-page-clear"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LiveViewNativeLiveForm",
            dependencies: [
                .product(name: "LiveViewNative", package: "liveview-client-swiftui")
            ],
            path: "./swiftui"),
    ]
)
