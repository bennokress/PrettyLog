//
// 📄 LogLevelPriorityFilterTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

private typealias Filter = LogLevelPriorityFilter<AppLogLevel>

private func acceptedLevels(of filter: Filter) -> [AppLogLevel] {
    AppLogLevel.allCases.filter(filter.contains).sorted()
}

@Test
func logLevelPriorityFilterNone() {
    #expect(acceptedLevels(of: .none).isEmpty)
}

@Test
func logLevelPriorityFilterAll() {
    #expect(acceptedLevels(of: .all) == [.debug, .verbose, .info, .warning, .error, .keyEvent])
}

@Test
func logLevelPriorityFilterFrom() {
    #expect(acceptedLevels(of: .from(.info)) == [.info, .warning, .error, .keyEvent])
}

@Test
func logLevelPriorityFilterUntil() {
    #expect(acceptedLevels(of: .until(.warning)) == [.debug, .verbose, .info, .warning])
}

@Test
func logLevelPriorityFilterBetweenComparesPrioritiesNotCases() {
    // `.error` is declared between `.debug` and `.info`, but its priority is outside the range.
    #expect(acceptedLevels(of: .between(.verbose, and: .warning)) == [.verbose, .info, .warning])
}

@Test
func logLevelPriorityFilterBetweenReversedBoundsOrdersThem() {
    // A reversed `ClosedRange` stopped the app at runtime. The filter orders the bounds instead.
    #expect(Filter.between(.warning, and: .verbose) == .between(.verbose, and: .warning))
}

@Test
func logLevelPriorityFilterBetweenSameLevel() {
    #expect(acceptedLevels(of: .between(.info, and: .info)) == [.info])
}

@Test
func logLevelPriorityFilterOnlyOneLevel() {
    #expect(acceptedLevels(of: .only(.keyEvent)) == [.keyEvent])
}

@Test
func logLevelPriorityFilterOnlySeveralLevels() {
    #expect(acceptedLevels(of: .only(.verbose, .error)) == [.verbose, .error])
}

@Test
func logLevelPriorityFilterOnlyNoLevelAcceptsNothing() {
    #expect(Filter.only() == .none)
}

@Test
func logLevelPriorityFiltersAreEqualWhenTheyAcceptTheSameLevels() {
    #expect(Filter.only(.info) == .between(.info, and: .info))
    #expect(Filter.only(.info, .info) == .only(.info))
    #expect(Filter.from(.keyEvent) == .only(.keyEvent))
    #expect(Filter.until(.debug) == .only(.debug))
    #expect(Filter.from(.debug) == .all)
    #expect(Filter.between(.debug, and: .keyEvent) == .all)
    #expect(Filter.only(.info) != .only(.warning))
}

@Test
func logLevelPriorityFilterIsSendable() {
    // Compiles only while LogLevelPriorityFilter conforms to Sendable, which `Sendable` targets need to store a filter.
    let filters: [any Sendable] = [Filter.all, Filter.from(.info)]
    #expect(filters.count == 2)
}
