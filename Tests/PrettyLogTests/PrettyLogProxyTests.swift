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

    PrettyLogProxy.logV(["Test", "Message"], category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .verbose)
    #expect(mockTarget.capturedLogs[0].1 == "Test - Message")
    #expect(mockTarget.capturedLogs[0].2.name == "Debug")
}

@Test
func prettyLogProxyLogD() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.logD(["Debug", "Info"], category: .service, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .debug)
    #expect(mockTarget.capturedLogs[0].1 == "Debug - Info")
}

@Test
func prettyLogProxyLogI() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.logI(["Info", "Message"], category: .general, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .info)
    #expect(mockTarget.capturedLogs[0].1 == "Info - Message")
}

@Test
func prettyLogProxyLogW() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.logW(["Warning", "Message"], category: .manager, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .warning)
    #expect(mockTarget.capturedLogs[0].1 == "Warning - Message")
}

@Test
func prettyLogProxyLogE() {
    let mockTarget = MockLogTarget()

    PrettyLogProxy.logE(["Error", "Message"], category: .storage, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .error)
    #expect(mockTarget.capturedLogs[0].1 == "Error - Message")
}

@Test
func prettyLogProxyLogError() {
    let mockTarget = MockLogTarget()
    let testError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error"])

    PrettyLogProxy.log(testError, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .error)
    #expect(mockTarget.capturedLogs[0].1.contains("Test error"))
}

@Test
func prettyLogProxyLogNilError() {
    let mockTarget = MockLogTarget()
    let nilError: Error? = nil

    PrettyLogProxy.log(nilError, category: .user, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 0) // Should not log nil errors
}

@Test
func prettyLogProxyLogException() {
    let mockTarget = MockLogTarget()
    let testException = NSException(name: .genericException, reason: "Test exception", userInfo: nil)

    PrettyLogProxy.log(testException, category: .view, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].0 == .error)
    #expect(mockTarget.capturedLogs[0].1.contains("Test exception"))
}

@Test
func prettyLogProxyLogNilException() {
    let mockTarget = MockLogTarget()
    let nilException: NSException? = nil

    PrettyLogProxy.log(nilException, category: .view, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 0) // Should not log nil exceptions
}

@Test
func prettyLogProxyWithSensitiveData() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = true

    PrettyLogProxy.logI(["Public"], sensitiveMessages: ["Secret"], category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Public - Secret")
}

@Test
func prettyLogProxyWithoutSensitiveData() {
    let mockTarget = MockLogTarget()
    mockTarget.canLogSensitiveInformation = false

    PrettyLogProxy.logI(["Public"], sensitiveMessages: ["Secret"], category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "Public")
}

@Test
func prettyLogProxyFilteredByPriority() {
    let mockTarget = MockLogTarget()
    mockTarget.logPriorityRange = .allowFrom(min: .warning)

    PrettyLogProxy.logI(["This should be filtered"], category: .debug, to: [mockTarget])
    PrettyLogProxy.logW(["This should pass"], category: .debug, to: [mockTarget])

    #expect(mockTarget.capturedLogs.count == 1)
    #expect(mockTarget.capturedLogs[0].1 == "This should pass")
}
