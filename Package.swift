// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let prettyLog = "PrettyLog"

let package = Package(
    name: prettyLog,
    platforms: [
        .iOS(.v11),
        .macCatalyst(.v13),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(name: prettyLog, targets: [prettyLog])
    ],
    targets: [
        .target(name: prettyLog, dependencies: [])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
