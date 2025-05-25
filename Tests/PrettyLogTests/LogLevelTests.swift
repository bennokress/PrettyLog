//
// 📄 LogLevelTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logLevelEmojis() {
    #expect(LogLevel.debug.emoji == "🟤")
    #expect(LogLevel.xcode.emoji == "🟤")
    #expect(LogLevel.verbose.emoji == "🔵")
    #expect(LogLevel.staging.emoji == "🔵")
    #expect(LogLevel.info.emoji == "🟢")
    #expect(LogLevel.production.emoji == "🟢")
    #expect(LogLevel.warning.emoji == "🟡")
    #expect(LogLevel.error.emoji == "🔴")
    #expect(LogLevel.keyEvent.emoji == "📊")
}

@Test
func logLevelPriorities() {
    #expect(LogLevel.debug.priority == 100)
    #expect(LogLevel.xcode.priority == 100)
    #expect(LogLevel.verbose.priority == 300)
    #expect(LogLevel.staging.priority == 300)
    #expect(LogLevel.info.priority == 500)
    #expect(LogLevel.production.priority == 500)
    #expect(LogLevel.warning.priority == 700)
    #expect(LogLevel.error.priority == 900)
    #expect(LogLevel.keyEvent.priority == .max)
}

@Test
func logLevelComparison() {
    #expect(LogLevel.debug < LogLevel.verbose)
    #expect(LogLevel.verbose < LogLevel.info)
    #expect(LogLevel.info < LogLevel.warning)
    #expect(LogLevel.warning < LogLevel.error)
    #expect(LogLevel.error < LogLevel.keyEvent)

    // Same priority levels should be equal
    #expect(!(LogLevel.debug < LogLevel.xcode))
    #expect(!(LogLevel.xcode < LogLevel.debug))
}

@Test
func customLogLevel() {
    let customLevel = LogLevel.custom(emoji: "🟣", priority: 200)
    #expect(customLevel.emoji == "🟣")
    #expect(customLevel.priority == 200)
    #expect(LogLevel.debug < customLevel)
    #expect(customLevel < LogLevel.verbose)
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
