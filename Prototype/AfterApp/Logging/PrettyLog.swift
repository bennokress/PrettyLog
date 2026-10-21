//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): this file is the same in BeforeApp and AfterApp, apart from the import.

import Foundation
import PrettyLog

nonisolated func logD(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: ActiveLogTargets.current)
}

nonisolated func logX(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: ActiveLogTargets.current)
}

nonisolated func logV(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: ActiveLogTargets.current)
}

nonisolated func logI(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: ActiveLogTargets.current)
}

nonisolated func logW(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .warning, category: category, to: ActiveLogTargets.current)
}

nonisolated func logE(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .error, category: category, to: ActiveLogTargets.current)
}

nonisolated func logK(_ messages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.log(messages, joinedBy: separator, as: .keyEvent, category: category, to: ActiveLogTargets.current)
}

nonisolated func log(_ error: (any Error)?, category: LogCategory = .general) {
    guard let error else { return }
    PrettyLogProxy.log([String(describing: type(of: error))], sensitiveMessages: [error.localizedDescription], as: .error, category: category, to: ActiveLogTargets.current)
}

nonisolated func fatalLog(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .general) -> Never {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .error, category: category, to: ActiveLogTargets.current)
    fatalError(messages.compactMap { $0?.description }.joined(separator: separator))
}
