//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): the level is a protocol the app's own enum conforms to, with an `Int` raw value as its priority.
// The order of the cases means nothing, so they can be sorted alphabetically. Swift rejects two cases with
// the same raw value, so two levels with the same priority can't exist within one enum.

import Foundation

public protocol LogLevel: RawRepresentable, Sendable, Hashable where RawValue == Int {

    /// The emoji shown in log statements of this level.
    var emoji: String { get }

}

public extension LogLevel {

    /// The priority is the raw value. It is no requirement, so an enum can't replace it with values of its own.
    var priority: Int { rawValue }

}
