//
// 📄 PrettyLogProxy.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): `log` is generic over the level type. The caller does not name it, Swift infers it from `as:` and `to:`.

import Foundation

public struct PrettyLogProxy {

    private init() { }

    public static func log<Level: LogLevel>(_ messages: [(any CustomStringConvertible)?], sensitiveMessages: [(any CustomStringConvertible)?] = [], joinedBy separator: String = " - ", as level: Level, category: LogCategory = .uncategorized, to targets: [any LogTarget<Level>]) {
        let assembler = LogStatementAssembler(messages: messages.map { $0?.description }, sensitiveMessages: sensitiveMessages.map { $0?.description }, separator: separator)
        for target in targets {
            target.deliver(level, statement: assembler, category: category)
        }
    }

}
