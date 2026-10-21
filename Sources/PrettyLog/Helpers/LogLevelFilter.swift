//
// 📄 LogLevelFilter.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): the filter is generic over the app's level type and compares levels, not priorities.

import Foundation

public struct LogLevelFilter<Level: LogLevel>: Sendable, Equatable {

    private let accepted: Accepted

    public static var all: LogLevelFilter { LogLevelFilter(accepted: .everything) }

    public static var none: LogLevelFilter { LogLevelFilter(accepted: .nothing) }

    /// Accepts exactly the given levels, e.g. `.only(.keyEvent, .error)`.
    public static func only(_ levels: Level...) -> LogLevelFilter {
        LogLevelFilter(accepted: levels.isEmpty ? .nothing : .set(Set(levels)))
    }

    public static func from(_ level: Level) -> LogLevelFilter {
        LogLevelFilter(accepted: .from(level))
    }

    public static func until(_ level: Level) -> LogLevelFilter {
        LogLevelFilter(accepted: .until(level))
    }

    public static func between(_ firstLevel: Level, and secondLevel: Level) -> LogLevelFilter {
        LogLevelFilter(accepted: .range(min(firstLevel, secondLevel) ... max(firstLevel, secondLevel)))
    }

    public func contains(_ level: Level) -> Bool {
        switch accepted {
        case .everything: true
        case .nothing: false
        case let .from(lowest): level >= lowest
        case let .until(highest): level <= highest
        case let .range(range): range.contains(level)
        case let .set(set): set.contains(level)
        }
    }

    // There is no `.min` / `.max` for an arbitrary level type, so open ranges need their own cases.
    private enum Accepted: Sendable, Equatable {
        case everything
        case nothing
        case from(Level)
        case until(Level)
        case range(ClosedRange<Level>)
        case set(Set<Level>)
    }

}
