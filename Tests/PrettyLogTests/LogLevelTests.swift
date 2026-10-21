//
// 📄 LogLevelTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logLevelStoresEmojiAndPriority() {
    let level = LogLevel(emoji: "🟣", priority: 200)
    #expect(level.emoji == "🟣")
    #expect(level.priority == 200)
}

@Test
func logLevelComparison() {
    #expect(LogLevel.debug < LogLevel.verbose)
    #expect(LogLevel.verbose < LogLevel.info)
    #expect(LogLevel.info < LogLevel.warning)
    #expect(LogLevel.warning < LogLevel.error)
    #expect(LogLevel.error < LogLevel.keyEvent)
    #expect(LogLevel.debug < LogLevel(emoji: "🟣", priority: 200))
}

@Test
func logLevelEquality() {
    #expect(LogLevel.debug == LogLevel(emoji: "🟤", priority: 100))
    #expect(LogLevel.debug != LogLevel(emoji: "🟤", priority: 101))
    #expect(LogLevel.debug != LogLevel(emoji: "🔵", priority: 100))
}

@Test
func logLevelSwitchMatchesAppDefinedLevels() {
    // Targets that map levels to something else, like an `os.Logger` type, switch over the levels the app defines.
    func name(of level: LogLevel) -> String {
        switch level {
        case .debug: return "debug"
        case .error: return "error"
        default: return "other"
        }
    }
    #expect(name(of: .debug) == "debug")
    #expect(name(of: .error) == "error")
    #expect(name(of: .info) == "other")
}

@Test
func logLevelRangeAllowNone() {
    let range: ClosedRange<LogLevel>? = .allowNone
    #expect(range == nil)
    #expect(!range.contains(.debug))
    #expect(!range.contains(.error))
    #expect(!range.contains(.keyEvent))
}

@Test
func logLevelRangeAllowAll() {
    let range = ClosedRange<LogLevel>?.allowAll
    #expect(range != nil)
    #expect(range!.contains(.debug))
    #expect(range!.contains(.verbose))
    #expect(range!.contains(.info))
    #expect(range!.contains(.warning))
    #expect(range!.contains(.error))
    #expect(range!.contains(.keyEvent))
}

@Test
func logLevelRangeAllowFrom() {
    let range = ClosedRange<LogLevel>?.allowFrom(min: .info)
    #expect(range != nil)
    #expect(!range!.contains(.debug))
    #expect(!range!.contains(.verbose))
    #expect(range!.contains(.info))
    #expect(range!.contains(.warning))
    #expect(range!.contains(.error))
    #expect(range!.contains(.keyEvent))
}

@Test
func logLevelRangeAllowUntil() {
    let range = ClosedRange<LogLevel>?.allowUntil(max: .warning)
    #expect(range != nil)
    #expect(range!.contains(.debug))
    #expect(range!.contains(.verbose))
    #expect(range!.contains(.info))
    #expect(range!.contains(.warning))
    #expect(!range!.contains(.error))
    #expect(!range!.contains(.keyEvent))
}

@Test
func logLevelIsSendable() {
    // Compiles only while LogLevel conforms to Sendable, which consumers need to store levels in a `static let` or pass them into a `Task`.
    let levels: [any Sendable] = [LogLevel.debug, LogLevel(emoji: "🟣", priority: 200)]
    #expect(levels.count == 2)
}
