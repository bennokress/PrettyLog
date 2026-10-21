//
// 📄 PrettyLogProxyTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

class MockLogTarget: LogTarget {
    var canLogSensitiveInformation = true
    var logPriorityRange: ClosedRange<LogLevel>? = .allowAll
    var capturedLogs: [(LogLevel, String, LogCategory)] = []

    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        capturedLogs.append((level, message, category))
    }
}

@Test
func prettyLogProxyLogV() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.log(["Test", "Message"], as: .verbose, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .verbose)
    #expect(mockTarget.capturedLogs[0].1 == "Test - Message")
    #expect(mockTarget.capturedLogs[0].2.name == "Debug")
}

@Test
func prettyLogProxyLogD() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.log(["Debug", "Info"], as: .debug, category: .service, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .debug)
    #expect(mockTarget.capturedLogs[0].1 == "Debug - Info")
}

@Test
func prettyLogProxyLogI() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.log(["Info", "Message"], as: .info, category: .general, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .info)
    #expect(mockTarget.capturedLogs[0].1 == "Info - Message")
}

@Test
func prettyLogProxyLogW() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.log(["Warning", "Message"], as: .warning, category: .manager, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .warning)
    #expect(mockTarget.capturedLogs[0].1 == "Warning - Message")
}

@Test
func prettyLogProxyLogE() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.log(["Error", "Message"], as: .error, category: .storage, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .error)
    #expect(mockTarget.capturedLogs[0].1 == "Error - Message")
}

@Test
func prettyLogProxyLogError() {
    let mockTarget = MockLogTarget()
    let testError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error"])

    PrettyLogProxy.log(testError, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .error)
    #expect(mockTarget.capturedLogs[0].1.contains("Test error"))
}

@Test
func prettyLogProxyLogNilError() {
    let mockTarget = MockLogTarget()
    let nilError: Error? = nil

    PrettyLogProxy.log(nilError, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 0) // Should not log nil errors
}

@Test
func prettyLogProxyLogException() {
    let mockTarget = MockLogTarget()
    let testException = NSException(name: .genericException, reason: "Test exception", userInfo: nil)

    PrettyLogProxy.log(testException, as: .error, category: .view, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .error)
    #expect(mockTarget.capturedLogs[0].1.contains("Test exception"))
}

@Test
func prettyLogProxyLogNilException() {
    let mockTarget = MockLogTarget()
    let nilException: NSException? = nil

    PrettyLogProxy.log(nilException, as: .error, category: .view, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 0) // Should not log nil exceptions
}

@Test
func prettyLogProxyLogErrorHidesDetailsFromTargetWithoutSensitiveInformation() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false
    let testError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error", "token": "secret-token"])

    PrettyLogProxy.log(testError, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Test error")
    #expect(!mockTarget.capturedLogs[0].1.contains("secret-token"))
}

@Test
func prettyLogProxyLogErrorShowsDetailsToTargetWithSensitiveInformation() {
    let mockTarget = MockLogTarget()
    let testError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error", "token": "secret-token"])

    PrettyLogProxy.log(testError, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1.hasPrefix("Test error - "))
    #expect(mockTarget.capturedLogs[0].1.contains("secret-token"))
}

@Test
func prettyLogProxyLogEnumErrorHidesAssociatedValuesFromTargetWithoutSensitiveInformation() {
    enum TestError: Error {
        case unauthorized(token: String)
    }
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false

    PrettyLogProxy.log(TestError.unauthorized(token: "secret-token"), as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(!mockTarget.capturedLogs[0].1.contains("secret-token"))
}

@Test
func prettyLogProxyLogPlainSwiftErrorUsesTypeNameAsPublicPart() {
    enum NetworkError: Error {
        case notFound
    }
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false

    PrettyLogProxy.log(NetworkError.notFound, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "NetworkError")
}

@Test
func prettyLogProxyLogPlainSwiftErrorShowsCaseToTargetWithSensitiveInformation() {
    enum NetworkError: Error {
        case notFound
    }
    let mockTarget = MockLogTarget()

    PrettyLogProxy.log(NetworkError.notFound, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "NetworkError - notFound")
}

@Test
func prettyLogProxyLogLocalizedErrorUsesItsDescriptionAsPublicPart() {
    enum ReadableError: LocalizedError {

        case missingFile

        var errorDescription: String? { "The file is missing." }

    }

    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false

    PrettyLogProxy.log(ReadableError.missingFile, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "The file is missing.")
}

@Test
func prettyLogProxyLogBridgedFoundationErrorUsesLocalizedDescriptionAsPublicPart() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false
    let error = CocoaError(.fileNoSuchFile)

    PrettyLogProxy.log(error, as: .error, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == error.localizedDescription)
}

@Test
func prettyLogProxyLogExceptionHidesReasonAndUserInfoFromTargetWithoutSensitiveInformation() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false
    let testException = NSException(name: .genericException, reason: "secret-reason", userInfo: ["token": "secret-token"])

    PrettyLogProxy.log(testException, as: .error, category: .view, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == NSExceptionName.genericException.rawValue)
}

@Test
func prettyLogProxyLogExceptionShowsReasonAndUserInfoToTargetWithSensitiveInformation() {
    let mockTarget = MockLogTarget()
    let testException = NSException(name: .genericException, reason: "secret-reason", userInfo: ["token": "secret-token"])

    PrettyLogProxy.log(testException, as: .error, category: .view, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1.hasPrefix("\(NSExceptionName.genericException.rawValue) - secret-reason - "))
    #expect(mockTarget.capturedLogs[0].1.contains("secret-token"))
}

@Test
func prettyLogProxyWithSensitiveData() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = true

    PrettyLogProxy.log(["Public"], sensitiveMessages: ["Secret"], as: .info, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Public - Secret")
}

@Test
func prettyLogProxyWithoutSensitiveData() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false

    PrettyLogProxy.log(["Public"], sensitiveMessages: ["Secret"], as: .info, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Public")
}

@Test
func prettyLogProxyFilteredByPriority() {
    let mockTarget = MockLogTarget()
    mockTarget.logPriorityRange = .allowFrom(min: .warning)

    PrettyLogProxy.log(["This should be filtered"], as: .info, category: .debug, to: [mockTarget])
    PrettyLogProxy.log(["This should pass"], as: .warning, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "This should pass")
}

private struct SendableLogTarget: LogTarget {
    let canLogSensitiveInformation = false
    func createLog(_ level: LogLevel, message: String, category: LogCategory) { }
}

/// The README suggests keeping targets in a constant of type `[any LogTarget & Sendable]`. This compiles only while such a list can be passed to the proxy.
private let sendableLogTargets: [any LogTarget & Sendable] = [SendableLogTarget()]

@Test
func prettyLogProxyAcceptsSendableTargets() {
    PrettyLogProxy.log(["Info"], as: .info, to: sendableLogTargets)
    #expect(sendableLogTargets.count == 1)
}

/// An empty target list is how an app switches logging off, for example in its own unit tests. It used to trip an assertion in debug builds.
@Test
func prettyLogProxyWithoutTargetsLogsNothingAndDoesNotCrash() {
    let noTargets: [LogTarget] = []

    PrettyLogProxy.log(["Info"], as: .info, to: noTargets)
    PrettyLogProxy.log(NSError(domain: "TestDomain", code: 42), as: .error, to: noTargets)
    PrettyLogProxy.log(NSException(name: .genericException, reason: nil, userInfo: nil), as: .error, to: noTargets)

    #expect(noTargets.isEmpty)
}
