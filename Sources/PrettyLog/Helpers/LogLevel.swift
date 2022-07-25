//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Level will show up visually in each log statement represented as an emoji. All the default levels use colored circles, but custom Log Levels may use other emoji.
///
/// Custom Log Levels can be defined as an extension on `LogLevel`:
///
///     extension LogLevel {
///
///         /// This custom level can be used like all the predefined ones, has to be called with the universal `log` method though: `log("The login method is not yet implemented", category: .todo, as: .todo)
///         static var todo: LogLevel { .custom(emoji: "🟣", priority: 200) }
///
///     }
///
/// - Attention: The level should always be represented by emoji in order to keep the visual design of the log statements consistent, although other characters could be defined for custom levels.
public enum LogLevel {

    case verbose
    case debug
    case info
    case warning
    case error

    case custom(emoji: Character, priority: Int)

    // MARK: - Properties & Methods

    /// The emoji is used as a quickly glanceable representation of the Log Level in our log statements.
    public var emoji: String {
        switch self {
        case .verbose: return "🔵"
        case .debug: return "🟤"
        case .info: return "🟢"
        case .warning: return "🟡"
        case .error: return "🔴"
        case let .custom(emoji, _): return "\(emoji)"
        }
    }

    /// The priority can be used to determine which log statement should be sent to a specific target.
    /// - Attention: Multiple Log Levels will be comparable by priority although they can have the same priority!
    public var priority: Int {
        switch self {
        case .verbose: return 100
        case .debug: return 300
        case .info: return 500
        case .warning: return 700
        case .error: return 900
        case let .custom(_, priority): return priority
        }
    }

}

extension LogLevel: Comparable {

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.priority < rhs.priority
    }

}

public extension Optional where Wrapped == ClosedRange<LogLevel> {

    static var allowNone: Self { nil }
    static var allowAll: Self { .minPriority ... .maxPriority }
    static func allowFrom(min minLevel: LogLevel) -> Self { minLevel ... .maxPriority }
    static func allowUntil(max maxLevel: LogLevel) -> Self { .minPriority ... maxLevel }

    @inlinable func contains(_ element: LogLevel) -> Bool {
        guard let range = self else { return false }
        return range.contains(element)
    }

}

private extension LogLevel {

    static var maxPriority: LogLevel { .custom(emoji: "⏫", priority: Int.max) }
    static var minPriority: LogLevel { .custom(emoji: "⏬", priority: Int.min) }

}
