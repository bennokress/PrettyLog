//
// 📄 Logging.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): an app module in Swift 5 language mode.

import Foundation
import PrettyLog

enum Swift5LogLevel: LogLevel {

    case debug
    case error

    var emoji: String {
        switch self {
        case .debug: "🟤"
        case .error: "🔴"
        }
    }

}

struct Console: LogTarget {

    let canLogSensitiveInformation = true

    func emit(_ level: Swift5LogLevel, message: String, category: LogCategory) {
        print("\(level.emoji) \(message)")
    }

}

var logTargets: [any LogTarget<Swift5LogLevel>] = [Console()]

func logD(_ messages: (any CustomStringConvertible)?..., category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, as: .debug, category: category, to: logTargets)
}

func useIt() {
    logD("Hello from Swift 5 mode")
}
