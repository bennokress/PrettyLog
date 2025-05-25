//
// 📄 PrettyLogTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func globalLogFunctionsExist() {
    // Test that global functions can be called without crashing
    logV("Test verbose message", category: .debug)
    logD("Test debug message", category: .debug)
    logI("Test info message", category: .debug)
    logW("Test warning message", category: .debug)
    logE("Test error message", category: .debug)

    // Test error logging
    let testError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    log(testError, category: .debug)

    // Test exception logging
    let testException = NSException(name: .genericException, reason: "Test exception", userInfo: nil)
    log(testException, category: .debug)

    #expect(true) // If we get here without crashing, the functions work
}

@Test
func globalLogFunctionsHandleNilInputs() {
    // Test that nil inputs are handled gracefully
    let nilError: Error? = nil
    let nilException: NSException? = nil

    log(nilError, category: .debug)
    log(nilException, category: .debug)

    #expect(true) // Should not crash with nil inputs
}
