// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "PrettyLog"
let displayName = packageName
let dependencies: [Dependency] = []

let platforms: [SupportedPlatform] = [
    .iOS(.v12),
    .macCatalyst(.v13),
    .macOS(.v10_13),
    .tvOS(.v12),
    .watchOS(.v4)
]

let module: Product = .library(name: packageName, targets: [packageName])
let mainTarget: Target = .target(name: packageName, dependencies: dependencies.target)

let package = Package(
    name: displayName,
    platforms: platforms,
    products: [module],
    dependencies: dependencies.package,
    targets: [mainTarget],
    swiftLanguageModes: [.v5, .v6]
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
