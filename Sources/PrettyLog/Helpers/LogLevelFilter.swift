//
// 📄 LogLevelFilter.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Level Filter decides which Log Levels a Log Target accepts. A log statement with a level outside the filter never reaches the target.
///
///     struct BackendLog: LogTarget {
///
///         var levelFilter: LogLevelFilter { .from(.info) }
///
///         // …
///
///     }
///
/// The filter compares priorities only, so a level is accepted if its priority lies within the bounds, both bounds included.
public struct LogLevelFilter: Sendable, Equatable {

    // `nil` accepts nothing. A `ClosedRange` cannot be empty, so it cannot express this on its own.
    private let priorities: ClosedRange<Int>?

    /// Accepts every Log Level. This is the default of every Log Target.
    public static var all: LogLevelFilter { LogLevelFilter(priorities: .min ... .max) }

    /// Accepts no Log Level, e.g. when log statements require approval by the user to be sent to a server.
    public static var none: LogLevelFilter { LogLevelFilter(priorities: nil) }

    /// Accepts the given Log Level and every level above it, e.g. to leave out debug statements when logging to a server.
    /// - Parameter level: The lowest Log Level the target accepts.
    public static func from(_ level: LogLevel) -> LogLevelFilter {
        LogLevelFilter(priorities: level.priority ... .max)
    }

    /// Accepts the given Log Level and every level below it, e.g. to concentrate on debug statements when logging to the console.
    /// - Parameter level: The highest Log Level the target accepts.
    public static func until(_ level: LogLevel) -> LogLevelFilter {
        LogLevelFilter(priorities: .min ... level.priority)
    }

    /// Accepts both given Log Levels and every level between them.
    ///
    /// The order of the two levels does not matter: `.between(.warning, and: .debug)` accepts the same levels as `.between(.debug, and: .warning)`.
    /// - Parameters:
    ///   - firstLevel: One bound of the accepted levels.
    ///   - secondLevel: The other bound of the accepted levels.
    public static func between(_ firstLevel: LogLevel, and secondLevel: LogLevel) -> LogLevelFilter {
        let lowerPriority = min(firstLevel.priority, secondLevel.priority)
        let upperPriority = max(firstLevel.priority, secondLevel.priority)
        return LogLevelFilter(priorities: lowerPriority ... upperPriority)
    }

    /// Returns whether the filter accepts the given Log Level.
    /// - Parameter level: The Log Level of a log statement.
    public func contains(_ level: LogLevel) -> Bool {
        priorities?.contains(level.priority) ?? false
    }

}
