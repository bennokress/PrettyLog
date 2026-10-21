//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Level can be used to filter log statements before they are sent to a Log Target. It also carries an emoji as a way to visually distinguish the severity of each log statement.
///
/// PrettyLog ships no Log Levels. Your app defines the ones it needs as an extension on `LogLevel` and passes them to `PrettyLogProxy.log(_:sensitiveMessages:joinedBy:as:category:to:)`.
/// The package gives a level no meaning of its own: targets only compare priorities to decide what they log, so it is up to your app what "debug" or "production" means.
///
///     nonisolated extension LogLevel {
///
///         static var debug: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
///         static var info: LogLevel { LogLevel(emoji: "🟢", priority: 500) }
///         static var error: LogLevel { LogLevel(emoji: "🔴", priority: 900) }
///
///     }
///
/// A target can tell levels apart with `==` or `switch`. Because the levels are values and not enum cases, a `switch` needs a `default` branch.
///
/// - Attention: The level should always be represented by emoji in order to keep the visual design of the log statements consistent, although other characters could be used.
public struct LogLevel: Sendable {

    /// The emoji can be used as a quickly glanceable representation of the Log Level in log statements.
    public var emoji: String { String(emojiCharacter) }

    /// The priority can be used to determine which log statement should be sent to a specific target.
    /// - Attention: The priority identifies the level: two levels with the same priority are equal, whatever their emoji. Give every level of your app its own priority.
    public let priority: Int

    private let emojiCharacter: Character

    /// Creates a Log Level.
    /// - Parameters:
    ///   - emoji: The emoji shown in log statements of this level
    ///   - priority: The priority targets use to filter log statements; higher means more important
    public init(emoji: Character, priority: Int) {
        self.emojiCharacter = emoji
        self.priority = priority
    }

}

extension LogLevel: Comparable {

    // Equality follows the same key as the order, otherwise two levels with the same priority and different emoji would be neither equal nor ordered, which breaks `Comparable`.
    public static func == (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.priority == rhs.priority
    }

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
    @inlinable
    func contains(_ element: LogLevel) -> Bool {
        guard let range = self else { return false }
        return range.contains(element)
    }

}

private extension LogLevel {

    static var maxPriority: LogLevel { LogLevel(emoji: "⏫", priority: Int.max) }
    static var minPriority: LogLevel { LogLevel(emoji: "⏬", priority: Int.min) }

}
