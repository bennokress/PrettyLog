//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

/// The Log Level will show up visually in each log statement represented as an emoji. All the default levels use colored circles, but custom Log Levels may use other emoji.
///
/// Custom Log Levels can be defined as an extension on `LogLevel`:
///
///     extension LogLevel {
///
///         /// This custom level can be used like all the predefined ones, has to be defined though: logI("Running Unit Tests ...", category: .test)
///         static var important: LogLevel { .custom(emoji: "🟣") }
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

    case custom(emoji: Character)

    /// The emoji is used as a quickly glanceable representation of the Log Level in our log statements.
    var emoji: String {
        switch self {
        case .verbose: return "🔵"
        case .debug: return "🟤"
        case .info: return "🟢"
        case .warning: return "🟡"
        case .error: return "🔴"
        case let .custom(emoji): return "\(emoji)"
        }
    }

}
