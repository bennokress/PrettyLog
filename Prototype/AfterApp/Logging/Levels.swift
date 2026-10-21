//
// 📄 Levels.swift
// 👨🏼‍💻 Author: Benno Kress
//

import PrettyLog

// The order of the cases is the order of the levels: `.keyEvent` is the highest because it comes last.
nonisolated enum AppLogLevel: LogLevel, CaseIterable {

    case debug
    case verbose
    case info
    case warning
    case error
    case keyEvent

    var emoji: String {
        switch self {
        case .debug: "🟤"
        case .verbose: "🔵"
        case .info: "🟢"
        case .warning: "🟡"
        case .error: "🔴"
        case .keyEvent: "📊"
        }
    }

}
