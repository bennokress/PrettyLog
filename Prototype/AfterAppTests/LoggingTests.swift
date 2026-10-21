//
// 📄 LoggingTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

@testable import AfterApp
import PrettyLog
import Testing

private final class MemoryLogTarget: LogTarget, @unchecked Sendable {

    var statements: [(level: AppLogLevel, message: String)] = []
    let canLogSensitiveInformation: Bool

    init(canLogSensitiveInformation: Bool = true) {
        self.canLogSensitiveInformation = canLogSensitiveInformation
    }

    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        statements.append((level, message))
    }

}

@Suite(.serialized)
struct LoggingTests {

    @Test func sensitivePartOnlyReachesPermissiveTarget() throws {
        let original = ActiveLogTargets.current
        defer { ActiveLogTargets.set(original) }
        let permissive = MemoryLogTarget(canLogSensitiveInformation: true)
        let restrictive = MemoryLogTarget(canLogSensitiveInformation: false)
        ActiveLogTargets.set([permissive, restrictive])

        logX("Current iCloud Record ID", sensitiveMessages: "secret", category: .service)

        #expect(try #require(permissive.statements.first).message == "Current iCloud Record ID - secret")
        #expect(try #require(restrictive.statements.first).message == "Current iCloud Record ID")
        #expect(permissive.statements.first?.level == .debug)
    }

    @Test func appStoreEnvironmentFiltersFromInfo() throws {
        let targets = [any LogTarget<AppLogLevel>].forEnvironment(bundleID: "test", isDevelopment: false, isTestFlight: false)
        let osLog = try #require(targets.first as? OSLogTarget)
        #expect(osLog.levelFilter.contains(.info))
        #expect(osLog.levelFilter.contains(.keyEvent))
        #expect(!osLog.levelFilter.contains(.verbose))
    }

    @Test func developmentEnvironmentUsesConsole() {
        let targets = [any LogTarget<AppLogLevel>].forEnvironment(bundleID: "test", isDevelopment: true, isTestFlight: false)
        #expect(targets.first is Console)
    }

    // New with the enum: the test can walk every level of the app.
    @Test(arguments: AppLogLevel.allCases)
    func consoleAcceptsEveryLevel(level: AppLogLevel) {
        #expect(Console().levelFilter.contains(level))
    }

}
