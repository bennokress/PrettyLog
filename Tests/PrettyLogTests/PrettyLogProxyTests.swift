//
// 📄 PrettyLogProxyTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

class MockLogTarget: LogTarget {
    var canLogSensitiveInformation = true
    var levelFilter: LogLevelFilter = .all
    var capturedLogs: [(LogLevel, String, LogCategory)] = []

    func emit(_ level: LogLevel, message: String, category: LogCategory) {
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
    mockTarget.levelFilter = .fromPriority(of: .warning)

    PrettyLogProxy.log(["This should be filtered"], as: .info, category: .debug, to: [mockTarget])
    PrettyLogProxy.log(["This should pass"], as: .warning, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "This should pass")
}

private struct SendableLogTarget: LogTarget {
    let canLogSensitiveInformation = false
    func emit(_ level: LogLevel, message: String, category: LogCategory) { }
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

    #expect(noTargets.isEmpty)
}

@Test
func prettyLogProxyWritesNonStringMessagesAsTheirDescription() throws {
    let mockTarget = MockLogTarget()
    let missingCount: Int? = nil
    let url = try #require(URL(string: "https://example.com/items"))

    PrettyLogProxy.log(["Loaded", 3, missingCount, url], sensitiveMessages: [4.5], as: .info, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Loaded - 3 - https://example.com/items - 4.5")
}

/// Log functions in apps were declared with `String?...` before the proxy took `CustomStringConvertible`, so an array of optional strings has to keep compiling.
@Test
func prettyLogProxyStillAcceptsOptionalStrings() {
    let mockTarget = MockLogTarget()
    let messages: [String?] = ["Test", nil, "Message"]
    let sensitiveMessages: [String?] = ["Secret"]

    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, as: .info, category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Test - Message - Secret")
}
