//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Level can be used to filter log statements before they are sent to a Log Target. They also use emoji as a way to visually distinguish each of the log statements severity levels. All the default levels use colored circles, but custom Log Levels may use other emoji.
///
/// Custom Log Levels can be defined as an extension on `LogLevel`:
///
///     extension LogLevel {
///
///         /// This custom level can be used like all the predefined ones, it has to be called with the universal `log` method though: `log("The login method is not yet implemented", category: .todo, as: .todo)
///         static var todo: LogLevel { .custom(emoji: "🟣", priority: 200) }
///
///     }
///
/// - Attention: The level should always be represented by emoji in order to keep the visual design of the log statements consistent, although other characters could be defined for custom levels.
public enum LogLevel {

    case debug
    case verbose
    case info
    case warning
    case error

    case custom(emoji: Character, priority: Int)

    // MARK: - Properties & Methods

    /// The emoji can be used as a quickly glanceable representation of the Log Level in log statements.
    public var emoji: String {
        switch self {
        case .debug: return "🟤"
        case .verbose: return "🔵"
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
        case .debug: return 100
        case .verbose: return 300
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

    /// This range of Log Levels can be used to filter out all incoming log statements, e.g. when they require approval by the user to be sent to a server.
    static var allowNone: Self { nil }

    /// This range of Log Levels can be used to never filter any incoming log statements.
    static var allowAll: Self { .minPriority ... .maxPriority }

    /// This range of Log Levels can be used to filter out incoming log statements below the given level, e.g. to filter out debug statements when logging to a server.
    /// - Parameter minLevel: The minimum Log Level that will be sent to the Log Target.
    static func allowFrom(min minLevel: LogLevel) -> Self { minLevel ... .maxPriority }

    /// This range of Log Levels can be used to filter out incoming log statements above the given level, e.g. to concentrate on debug statements when logging to the console.
    /// - Parameter maxLevel: The maximum Log Level that will be sent to the Log Target.
    static func allowUntil(max maxLevel: LogLevel) -> Self { .minPriority ... maxLevel }

    /// Returns a Boolean value indicating whether the given element is contained
    /// within the range.
    ///
    /// A `ClosedRange` instance contains both its lower and upper bound.
    /// `element` is contained in the range if it is between the two bounds or
    /// equal to either bound.
    ///
    /// - Parameter element: The element to check for containment.
    /// - Attention: This will always return `false` if the range is `nil`.
    @inlinable func contains(_ element: LogLevel) -> Bool {
        guard let range = self else { return false }
        return range.contains(element)
    }

}

private extension LogLevel {

    static var maxPriority: LogLevel { .custom(emoji: "⏫", priority: Int.max) }
    static var minPriority: LogLevel { .custom(emoji: "⏬", priority: Int.min) }

}
