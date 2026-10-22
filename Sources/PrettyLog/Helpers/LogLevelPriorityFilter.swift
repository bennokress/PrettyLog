//
// 📄 LogLevelPriorityFilter.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#73): every filter stores the set of levels it accepts, picked from `allCases`.
// `==` therefore compares what two filters accept, and `.only(.info)` accepts exactly `.info`.

import Foundation

public struct LogLevelPriorityFilter<Level: LogLevel>: Sendable, Equatable {

    private let acceptedLevels: Set<Level>

    public static var all: Self { Self(where: { _ in true }) }
    public static var none: Self { Self(where: { _ in false }) }
    public static func only(_ levels: Level...) -> Self { Self(where: { levels.contains($0) }) }
    public static func from(_ level: Level) -> Self { Self(where: { $0 >= level }) }
    public static func until(_ level: Level) -> Self { Self(where: { $0 <= level }) }
    public static func between(_ first: Level, and second: Level) -> Self {
        Self(where: { (min(first, second) ... max(first, second)).contains($0) })
    }

    public func contains(_ level: Level) -> Bool { acceptedLevels.contains(level) }

    private init(where isAccepted: (Level) -> Bool) {
        let cases = Array(Level.allCases)
        // Only a hand-written type can get here with duplicates: enums with raw values and the macro variants reject them at compile time.
        assert(Set(cases.map(\.priority)).count == cases.count, "\(Level.self) gives two levels the same priority.")
        acceptedLevels = Set(cases.filter(isAccepted))
    }

}
