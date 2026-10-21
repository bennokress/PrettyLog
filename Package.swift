// swift-tools-version: 6.2

import PackageDescription

let packageName = "PrettyLog"
let displayName = packageName
let dependencies: [Dependency] = []

let platforms: [SupportedPlatform] = [
    // PROTOTYPE (#71): `any LogTarget<Level>` needs runtime support from iOS 16, macOS 13, tvOS 16 and watchOS 9 on.
    .iOS(.v16),
    .macCatalyst(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9)
]

let module: Product = .library(name: packageName, targets: [packageName])
let mainTarget: Target = .target(name: packageName, dependencies: dependencies.target)

// PROTOTYPE (#71): the package tests are left out, they test the struct API. Instead, two sample apps show the
// same code before (PrettyLogStruct, the API on feature/api) and after (PrettyLog, the enum design).
let mainActorApp: [SwiftSetting] = [
    .defaultIsolation(MainActor.self),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
]
let prototypeTargets: [Target] = [
    .target(name: "PrettyLogStruct"),
    .target(name: "BeforeApp", dependencies: ["PrettyLogStruct"], path: "Prototype/BeforeApp", swiftSettings: mainActorApp),
    .target(name: "AfterApp", dependencies: ["PrettyLog"], path: "Prototype/AfterApp", swiftSettings: mainActorApp),
    .target(name: "SharedLogTargets", dependencies: ["PrettyLog"], path: "Prototype/SharedLogTargets"),
    .target(name: "OtherApp", dependencies: ["PrettyLog", "SharedLogTargets"], path: "Prototype/OtherApp", swiftSettings: mainActorApp),
    .target(name: "Swift5App", dependencies: ["PrettyLog"], path: "Prototype/Swift5App", swiftSettings: [.swiftLanguageMode(.v5)]),
    .testTarget(name: "BeforeAppTests", dependencies: ["BeforeApp", "PrettyLogStruct"], path: "Prototype/BeforeAppTests", swiftSettings: mainActorApp),
    .testTarget(name: "AfterAppTests", dependencies: ["AfterApp", "PrettyLog"], path: "Prototype/AfterAppTests", swiftSettings: mainActorApp),
]

let package = Package(
    name: displayName,
    platforms: platforms,
    products: [module, .library(name: "PrototypeApps", targets: ["BeforeApp", "AfterApp", "OtherApp", "Swift5App"])],
    dependencies: dependencies.package,
    targets: [mainTarget] + prototypeTargets,
    swiftLanguageModes: [.v6, .v5]
)

// MARK: - Helpers

protocol Dependency {

    /// This can be used to include a dependency from the target dependencies. Default is `true`.
    var isIncludedInTarget: Bool { get }
    var targetDependency: Target.Dependency { get }

    /// This can be used to include a dependency from the package dependencies. Default is `true`.
    var isIncludedInPackage: Bool { get }
    var packageDependency: Package.Dependency { get }

}

extension Dependency {

    var isIncludedInTarget: Bool { true }
    var isIncludedInPackage: Bool { true }

}

extension Array where Element == Dependency {

    var target: [Target.Dependency] { filter(\.isIncludedInTarget).map(\.targetDependency) }
    var package: [Package.Dependency] { filter(\.isIncludedInPackage).map(\.packageDependency) }

}
