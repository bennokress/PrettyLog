// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let prettyLog = "PrettyLog"

let package = Package(
    name: prettyLog,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: prettyLog, targets: [prettyLog])
    ],
    targets: [
        .target(name: prettyLog, dependencies: [])
    ]
)
