//
// 📄 LogLevelFilter.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): the filter is generic over the app's level type and compares priorities, as on feature/api.

import Foundation

public struct LogLevelFilter<Level: LogLevel>: Sendable, Equatable {

    private let acceptedPriorities: AcceptedPriorities

    public static var all: LogLevelFilter { LogLevelFilter(acceptedPriorities: .range(.min ... .max)) }

    public static var none: LogLevelFilter { LogLevelFilter(acceptedPriorities: .nothing) }

    /// Accepts exactly the given levels, e.g. `.only(.keyEvent, .error)`.
    public static func only(_ levels: Level...) -> LogLevelFilter {
        LogLevelFilter(acceptedPriorities: levels.isEmpty ? .nothing : .set(Set(levels.map(\.priority))))
    }

    public static func from(_ level: Level) -> LogLevelFilter {
        LogLevelFilter(acceptedPriorities: .range(level.priority ... .max))
    }

    public static func until(_ level: Level) -> LogLevelFilter {
        LogLevelFilter(acceptedPriorities: .range(.min ... level.priority))
    }

    public static func between(_ firstLevel: Level, and secondLevel: Level) -> LogLevelFilter {
        let lowerPriority = min(firstLevel.priority, secondLevel.priority)
        let upperPriority = max(firstLevel.priority, secondLevel.priority)
        return LogLevelFilter(acceptedPriorities: .range(lowerPriority ... upperPriority))
    }

    public func contains(_ level: Level) -> Bool {
        switch acceptedPriorities {
        case .nothing: false
        case let .range(range): range.contains(level.priority)
        case let .set(set): set.contains(level.priority)
        }
    }

    private enum AcceptedPriorities: Sendable, Equatable {
        case nothing
        case range(ClosedRange<Int>)
        case set(Set<Int>)
    }

}
