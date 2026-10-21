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
func logLevelFilterFromPriority() {
    let filter = LogLevelFilter.fromPriority(of: .info)
    #expect(!filter.contains(.debug))
    #expect(!filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(filter.contains(.error))
    #expect(filter.contains(.keyEvent))
}

@Test
func logLevelFilterUntilPriority() {
    let filter = LogLevelFilter.untilPriority(of: .warning)
    #expect(filter.contains(.debug))
    #expect(filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(!filter.contains(.error))
    #expect(!filter.contains(.keyEvent))
}

@Test
func logLevelFilterBetweenPriority() {
    let filter = LogLevelFilter.betweenPriority(of: .verbose, and: .warning)
    #expect(!filter.contains(.debug))
    #expect(filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(filter.contains(.warning))
    #expect(!filter.contains(.error))
}

@Test
func logLevelFilterBetweenPriorityReversedBoundsOrdersThem() {
    // A reversed `ClosedRange` stopped the app at runtime. The filter orders the bounds instead.
    #expect(LogLevelFilter.betweenPriority(of: .warning, and: .verbose) == .betweenPriority(of: .verbose, and: .warning))
}

@Test
func logLevelFilterBetweenPrioritySameLevel() {
    let filter = LogLevelFilter.betweenPriority(of: .info, and: .info)
    #expect(!filter.contains(.verbose))
    #expect(filter.contains(.info))
    #expect(!filter.contains(.warning))
}

@Test
func logLevelFilterOnlyPriorityOfOneLevel() {
    let filter = LogLevelFilter.onlyPriority(of: .keyEvent)
    #expect(!filter.contains(.error))
    #expect(filter.contains(.keyEvent))
}

@Test
func logLevelFilterOnlyPriorityOfSeveralLevels() {
    let filter = LogLevelFilter.onlyPriority(of: .verbose, .error)
    #expect(!filter.contains(.debug))
    #expect(filter.contains(.verbose))
    #expect(!filter.contains(.info))
    #expect(!filter.contains(.warning))
    #expect(filter.contains(.error))
    #expect(!filter.contains(.keyEvent))
}

@Test
func logLevelFilterOnlyPriorityOfNoLevelAcceptsNothing() {
    #expect(LogLevelFilter.onlyPriority() == .none)
}

@Test
func logLevelFilterOnlyPriorityOfOneLevelEqualsBetweenPriorityOfThatLevel() {
    #expect(LogLevelFilter.onlyPriority(of: .info) == .betweenPriority(of: .info, and: .info))
    #expect(LogLevelFilter.onlyPriority(of: .info, .info) == .betweenPriority(of: .info, and: .info))
}

@Test
func logLevelFilterAcceptsLevelsWithTheSamePriority() {
    // The priority identifies the level, so a level with another emoji but the same priority is the same level.
    let lookalike = LogLevel(emoji: "🟣", priority: LogLevel.info.priority)
    #expect(LogLevelFilter.onlyPriority(of: .info).contains(lookalike))
    #expect(LogLevelFilter.onlyPriority(of: .info, .error).contains(lookalike))
}

@Test
func logLevelFilterIsSendable() {
    // Compiles only while LogLevelFilter conforms to Sendable, which `Sendable` targets need to store a filter.
    let filters: [any Sendable] = [LogLevelFilter.all, LogLevelFilter.fromPriority(of: .info)]
    #expect(filters.count == 2)
}
