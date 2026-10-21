//
// 📄 Logging.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): a second app with semantic level names reuses the shared targets.

import Foundation
import OSLog
import PrettyLog
import SharedLogTargets

nonisolated enum OtherAppLogLevel: LogLevel, OSLogMappable {

    case xcode
    case staging
    case production
    case warning
    case error

    var emoji: String {
        switch self {
        case .xcode: "🟤"
        case .staging: "🔵"
        case .production: "🟢"
        case .warning: "🟡"
        case .error: "🔴"
        }
    }

    // The exhaustive mapping lives with the levels, not in the target.
    var osLogType: OSLogType {
        switch self {
        case .xcode: .debug
        case .staging: .default
        case .production: .info
        case .warning: .error
        case .error: .fault
        }
    }

}

/// Saves writing `any LogTarget<OtherAppLogLevel>` in every place that lists targets.
typealias AppLogTarget = any LogTarget<OtherAppLogLevel>

nonisolated enum ActiveLogTargets {

    // `SharedConsole()` needs no `<OtherAppLogLevel>`: Swift infers it from the array type.
    nonisolated(unsafe) static var current: [AppLogTarget] = [
        SharedConsole(),
        SharedOSLog(subsystem: "de.bennokress.other", canLogSensitiveInformation: false, levelFilter: .from(.production)),
        SharedOSLog(subsystem: "de.bennokress.other", canLogSensitiveInformation: false, levelFilter: .only(.staging, .error)),
    ]

}

nonisolated func logS(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .staging, category: category, to: ActiveLogTargets.current)
}

nonisolated func useIt() {
    logS("Staging statement")
}
