//
// 📄 ConsoleLogTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func consoleLogCreation() {
    let consoleLog = ConsoleLog()
    #expect(consoleLog.canLogSensitiveInformation == true)
    #expect(consoleLog.logPriorityRange != nil)
}

@Test
func consoleLogDefaultPriorityRange() {
    let consoleLog = ConsoleLog()
    let range = consoleLog.logPriorityRange

    #expect(range != nil)
    #expect(range!.contains(.debug))
    #expect(range!.contains(.verbose))
    #expect(range!.contains(.info))
    #expect(range!.contains(.warning))
    #expect(range!.contains(.error))
    #expect(range!.contains(.keyEvent))
}

@Test
func consoleLogCreateLog() {
    let consoleLog = ConsoleLog()

    // This test verifies the method can be called without crashing
    // Since createLog prints to console, we can't easily capture the output
    consoleLog.createLog(.info, message: "Test message", category: .debug)

    #expect(true) // If we get here, the method executed successfully
}
