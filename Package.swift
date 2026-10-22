// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

let packageName = "PrettyLog"
let displayName = packageName
let dependencies: [Dependency] = []

// `any LogTarget<Level>` needs runtime support for constrained existential types, which starts with these versions.
let platforms: [SupportedPlatform] = [
    .iOS(.v16),
    .macCatalyst(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9)
]

let module: Product = .library(name: packageName, targets: [packageName])
let macroTarget: Target = .macro(name: packageName + "Macros", dependencies: ["SwiftCompilerPlugin", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntaxBuilder", "SwiftSyntaxMacros"].map { .product(name: $0, package: "swift-syntax") })
let mainTarget: Target = .target(name: packageName, dependencies: dependencies.target + [.target(name: macroTarget.name)])
let testTarget: Target = .testTarget(name: packageName + "Tests", dependencies: [.target(name: packageName)])
let macroTestTarget: Target = .testTarget(name: macroTarget.name + "Tests", dependencies: [.target(name: macroTarget.name)] + ["SwiftSyntax", "SwiftSyntaxMacroExpansion", "SwiftSyntaxMacrosGenericTestSupport"].map { .product(name: $0, package: "swift-syntax") })

let package = Package(
    name: displayName,
    platforms: platforms,
    products: [module],
    dependencies: dependencies.package + [.package(url: "https://github.com/swiftlang/swift-syntax", from: "604.0.0")],
    targets: [macroTarget, mainTarget, testTarget, macroTestTarget],
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
