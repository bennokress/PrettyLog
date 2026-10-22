// swift-tools-version: 6.2

// PROTOTYPE (#73): throwaway, never merged. Compares four ways for an app to define its log levels.

import CompilerPluginSupport
import PackageDescription

let mainActorApp: [SwiftSetting] = [
    .defaultIsolation(MainActor.self),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
]

let package = Package(
    name: "PrettyLog",
    platforms: [.iOS(.v16), .macCatalyst(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(name: "PrettyLog", targets: ["PrettyLog"]),
        .library(name: "PrototypeApps", targets: ["V0App", "V1App", "V2App", "V3App", "Swift5App"]),
    ],
    dependencies: [.package(url: "https://github.com/swiftlang/swift-syntax", from: "604.0.0")],
    targets: [
        .macro(name: "PrettyLogMacros", dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        ]),
        .target(name: "PrettyLog", dependencies: ["PrettyLogMacros"]),
        .target(name: "V0App", dependencies: ["PrettyLog"], path: "Prototype/V0App", swiftSettings: mainActorApp),
        .target(name: "V1App", dependencies: ["PrettyLog"], path: "Prototype/V1App", swiftSettings: mainActorApp),
        .target(name: "V2App", dependencies: ["PrettyLog"], path: "Prototype/V2App", swiftSettings: mainActorApp),
        .target(name: "V3App", dependencies: ["PrettyLog"], path: "Prototype/V3App", swiftSettings: mainActorApp),
        .target(name: "Swift5App", dependencies: ["PrettyLog"], path: "Prototype/Swift5App", swiftSettings: [.swiftLanguageMode(.v5)]),
        .testTarget(name: "PrototypeTests", dependencies: ["V0App", "V1App", "V2App", "V3App", "PrettyLog"], path: "Prototype/Tests", swiftSettings: mainActorApp),
    ],
    swiftLanguageModes: [.v6, .v5]
)
