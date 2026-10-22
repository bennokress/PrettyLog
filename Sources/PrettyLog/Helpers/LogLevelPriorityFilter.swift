//
// 📄 LogLevelPriorityFilter.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Level Priority Filter decides which Log Levels a Log Target accepts. A log statement with a level outside the filter never reaches the target.
///
///     struct BackendLog: LogTarget {
///
///         var levelFilter: LogLevelPriorityFilter<AppLogLevel> { .from(.info) }
///
///         // …
///
///     }
///
/// The filter compares priorities, so `.from(.info)` accepts `.info` and every level with a higher priority, whatever the order of the cases.
/// It stores the levels it accepts, picked from `allCases`, so two filters are equal when they accept the same levels: `.only(.info)` equals `.between(.info, and: .info)`.
public struct LogLevelPriorityFilter<Level: LogLevel>: Sendable, Equatable {

    private let acceptedLevels: Set<Level>

    /// Accepts every Log Level. This is the default of every Log Target.
    public static var all: LogLevelPriorityFilter<Level> { LogLevelPriorityFilter { _ in true } }

    /// Accepts no Log Level, e.g. when log statements require approval by the user to be sent to a server.
    public static var none: LogLevelPriorityFilter<Level> { LogLevelPriorityFilter { _ in false } }

    /// Accepts exactly the given Log Levels, e.g. to send only key events to an analytics service.
    ///
    /// Without any level, the filter accepts nothing, like ``none``.
    /// - Parameter levels: The Log Levels the target accepts.
    public static func only(_ levels: Level...) -> LogLevelPriorityFilter<Level> {
        LogLevelPriorityFilter { levels.contains($0) }
    }

    /// Accepts the given Log Level and every level with a higher priority, e.g. to leave out debug statements when logging to a server.
    /// - Parameter level: The level with the lowest priority the target accepts.
    public static func from(_ level: Level) -> LogLevelPriorityFilter<Level> {
        LogLevelPriorityFilter { $0 >= level }
    }

    /// Accepts the given Log Level and every level with a lower priority, e.g. to concentrate on debug statements when logging to the console.
    /// - Parameter level: The level with the highest priority the target accepts.
    public static func until(_ level: Level) -> LogLevelPriorityFilter<Level> {
        LogLevelPriorityFilter { $0 <= level }
    }

    /// Accepts every Log Level with a priority between the priorities of the given levels, both included.
    ///
    /// The order of the two levels does not matter: `.between(.warning, and: .debug)` accepts the same levels as `.between(.debug, and: .warning)`.
    /// - Parameters:
    ///   - firstLevel: The level whose priority is one bound of the accepted priorities.
    ///   - secondLevel: The level whose priority is the other bound of the accepted priorities.
    public static func between(_ firstLevel: Level, and secondLevel: Level) -> LogLevelPriorityFilter<Level> {
        let acceptedRange = min(firstLevel, secondLevel) ... max(firstLevel, secondLevel)
        return LogLevelPriorityFilter { acceptedRange.contains($0) }
    }

    /// Returns whether the filter accepts the given Log Level.
    /// - Parameter level: The Log Level of a log statement.
    public func contains(_ level: Level) -> Bool {
        acceptedLevels.contains(level)
    }

    private init(accepting isAccepted: (Level) -> Bool) {
        // The compiler rejects two cases with the same raw value, so only a hand-written conformance can get here with duplicates. Their order would be undefined.
        assert(Self.levelsSharingAPriority.isEmpty, "\(Level.self) gives more than one level the same priority: \(Self.levelsSharingAPriority). Declare your levels with @LogLevels.")
        self.acceptedLevels = Set(Level.allCases.filter(isAccepted))
    }

}

extension LogLevelPriorityFilter {

    /// The levels in `allCases` whose priority another level has as well. Empty for every enum declared with `@LogLevels`.
    static var levelsSharingAPriority: [Level] {
        let levelsByPriority = Dictionary(grouping: Level.allCases, by: \.priority)
        return Level.allCases.filter { levelsByPriority[$0.priority, default: []].count > 1 }
    }

}
