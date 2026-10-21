//
// 📄 LogLevelFilterTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logLevelFilterNone() {
    let filter = LogLevelFilter.none
    #expect(!filter.contains(.debug))
    #expect(!filter.contains(.error))
    #expect(!filter.contains(.keyEvent))
}

@Test
func logLevelFilterAll() {
    let filter = LogLevelFilter.all
    #expect(filter.contains(.debug))
    #expect(filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(filter.contains(.error))
    #expect(filter.contains(.keyEvent))
    #expect(filter.contains(LogLevel(emoji: "⏬", priority: .min)))
    #expect(filter.contains(LogLevel(emoji: "⏫", priority: .max)))
}

@Test
func logLevelFilterFrom() {
    let filter = LogLevelFilter.from(.info)
    #expect(!filter.contains(.debug))
    #expect(!filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(filter.contains(.error))
    #expect(filter.contains(.keyEvent))
}

@Test
func logLevelFilterUntil() {
    let filter = LogLevelFilter.until(.warning)
    #expect(filter.contains(.debug))
    #expect(filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(!filter.contains(.error))
    #expect(!filter.contains(.keyEvent))
}

@Test
func logLevelFilterBetween() {
    let filter = LogLevelFilter.between(.verbose, and: .warning)
    #expect(!filter.contains(.debug))
    #expect(filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(!filter.contains(.error))
}

@Test
func logLevelFilterBetweenReversedBoundsOrdersThem() {
    // A reversed `ClosedRange` stopped the app at runtime. The filter orders the bounds instead.
    #expect(LogLevelFilter.between(.warning, and: .verbose) == .between(.verbose, and: .warning))
}

@Test
func logLevelFilterBetweenSameLevel() {
    let filter = LogLevelFilter.between(.info, and: .info)
    #expect(!filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(!filter.contains(.warning))
}

@Test
func logLevelFilterIsSendable() {
    // Compiles only while LogLevelFilter conforms to Sendable, which `Sendable` targets need to store a filter.
    let filters: [any Sendable] = [LogLevelFilter.all, LogLevelFilter.from(.info)]
    #expect(filters.count == 2)
}
