//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#73): the protocol only asks for an emoji, a priority and all cases. How an app fills them in is what the
// variants in Prototype/ compare. The constrained extensions below are the package support for variants V0 and V1.

import Foundation

public protocol LogLevel: CaseIterable, Comparable, Hashable, Sendable {

    var emoji: String { get }
    var priority: Int { get }

}

public extension LogLevel {

    /// Levels are ordered by priority, never by the order of their declaration.
    static func < (lhs: Self, rhs: Self) -> Bool { lhs.priority < rhs.priority }

}

// V0 and V2: the `Int` raw value is the priority, so the compiler rejects two levels with the same priority.
public extension LogLevel where Self: RawRepresentable, RawValue == Int {

    var priority: Int { rawValue }

}

// V1: the raw value is a text like "🟤 100", parsed into emoji and priority.
public extension LogLevel where Self: RawRepresentable, RawValue == LogLevelSpec {

    var emoji: String { rawValue.emoji }
    var priority: Int { rawValue.priority }

}

/// V1: a raw value written as a string literal, emoji and priority separated by a space: `case debug = "🟤 100"`.
public struct LogLevelSpec: Hashable, Sendable, ExpressibleByStringLiteral {

    public let emoji: String
    public let priority: Int

    public init(stringLiteral value: String) {
        let parts = value.split(separator: " ", omittingEmptySubsequences: true)
        guard parts.count == 2, let priority = Int(parts[1]) else {
            preconditionFailure("A log level is written as \"<emoji> <priority>\", got \"\(value)\".")
        }
        self.emoji = String(parts[0])
        self.priority = priority
    }

}
