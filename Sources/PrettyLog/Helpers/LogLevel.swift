//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): the level is a protocol the app's own enum conforms to.
// The order of the enum cases is the order of the levels, so no priority is needed:
// an enum without raw values and without associated values gets `Comparable` for free.

import Foundation

public protocol LogLevel: Sendable, Hashable, Comparable {

    /// The emoji shown in log statements of this level.
    var emoji: String { get }

}
