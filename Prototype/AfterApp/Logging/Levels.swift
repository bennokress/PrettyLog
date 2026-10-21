//
// 📄 Levels.swift
// 👨🏼‍💻 Author: Benno Kress
//

import PrettyLog

// Sorted alphabetically. The raw value is the priority, the order of the cases means nothing.
nonisolated enum AppLogLevel: Int, LogLevel, CaseIterable {

    case debug = 100
    case error = 900
    case info = 500
    case keyEvent = 1000
    case verbose = 300
    case warning = 700

    var emoji: String {
        switch self {
        case .debug: "🟤"
        case .error: "🔴"
        case .info: "🟢"
        case .keyEvent: "📊"
        case .verbose: "🔵"
        case .warning: "🟡"
        }
    }

}
