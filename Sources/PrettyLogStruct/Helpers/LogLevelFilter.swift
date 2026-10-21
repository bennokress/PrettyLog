//
// 📄 LogLevelFilter.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Level Filter decides which Log Levels a Log Target accepts. A log statement with a level outside the filter never reaches the target.
///
///     struct BackendLog: LogTarget {
///
///         var levelFilter: LogLevelFilter { .fromPriority(of: .info) }
///
///         // …
///
///     }
///
/// The filter compares priorities only. Two levels with the same priority count as the same level, so a filter that accepts one of them accepts the other too, whatever their emoji.
public struct LogLevelFilter: Sendable, Equatable {

    private let acceptedPriorities: AcceptedPriorities

    /// Accepts every Log Level. This is the default of every Log Target.
    public static var all: LogLevelFilter { LogLevelFilter(acceptedPriorities: .range(.min ... .max)) }

    /// Accepts no Log Level, e.g. when log statements require approval by the user to be sent to a server.
    public static var none: LogLevelFilter { LogLevelFilter(acceptedPriorities: .nothing) }

    /// Accepts every Log Level with the priority of one of the given levels, e.g. to send only key events to an analytics service.
    ///
    /// Without any level, the filter accepts nothing, like ``none``.
    /// - Attention: A level with the same priority as one of the given levels is accepted as well, whatever its emoji. Give every level of your app its own priority.
    /// - Parameter levels: The Log Levels whose priorities the target accepts.
    public static func onlyPriority(of levels: LogLevel...) -> LogLevelFilter {
        let priorities = Set(levels.map(\.priority))
        // A single priority is stored as a range, so `.onlyPriority(of: .info)` equals `.betweenPriority(of: .info, and: .info)`.
        let acceptedPriorities: AcceptedPriorities = if priorities.isEmpty {
            .nothing
        } else if priorities.count == 1, let priority = priorities.first {
            .range(priority ... priority)
        } else {
            .set(priorities)
        }
        return LogLevelFilter(acceptedPriorities: acceptedPriorities)
    }

    /// Accepts every Log Level with the priority of the given level or a higher one, e.g. to leave out debug statements when logging to a server.
    /// - Attention: A level with the same priority as the given level is accepted as well, whatever its emoji. Give every level of your app its own priority.
    /// - Parameter level: The level with the lowest priority the target accepts.
    public static func fromPriority(of level: LogLevel) -> LogLevelFilter {
        LogLevelFilter(acceptedPriorities: .range(level.priority ... .max))
    }

    /// Accepts every Log Level with the priority of the given level or a lower one, e.g. to concentrate on debug statements when logging to the console.
    /// - Attention: A level with the same priority as the given level is accepted as well, whatever its emoji. Give every level of your app its own priority.
    /// - Parameter level: The level with the highest priority the target accepts.
    public static func untilPriority(of level: LogLevel) -> LogLevelFilter {
        LogLevelFilter(acceptedPriorities: .range(.min ... level.priority))
    }

    /// Accepts every Log Level with a priority between the priorities of the given levels, both included.
    ///
    /// The order of the two levels does not matter: `.betweenPriority(of: .warning, and: .debug)` accepts the same levels as `.betweenPriority(of: .debug, and: .warning)`.
    /// - Attention: A level with the same priority as one of the given levels is accepted as well, whatever its emoji. Give every level of your app its own priority.
    /// - Parameters:
    ///   - firstLevel: The level whose priority is one bound of the accepted priorities.
    ///   - secondLevel: The level whose priority is the other bound of the accepted priorities.
    public static func betweenPriority(of firstLevel: LogLevel, and secondLevel: LogLevel) -> LogLevelFilter {
        let lowerPriority = min(firstLevel.priority, secondLevel.priority)
        let upperPriority = max(firstLevel.priority, secondLevel.priority)
        return LogLevelFilter(acceptedPriorities: .range(lowerPriority ... upperPriority))
    }

    /// Returns whether the filter accepts the given Log Level.
    /// - Parameter level: The Log Level of a log statement.
    public func contains(_ level: LogLevel) -> Bool {
        switch acceptedPriorities {
        case .nothing:
            false
        case let .range(range):
            range.contains(level.priority)
        case let .set(set):
            set.contains(level.priority)
        }
    }

}

private extension LogLevelFilter {

    // A `ClosedRange` cannot be empty, so accepting nothing needs its own case.
    enum AcceptedPriorities: Sendable, Equatable {

        case nothing
        case range(ClosedRange<Int>)
        case set(Set<Int>)

    }

}
