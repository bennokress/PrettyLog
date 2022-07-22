//
// 📄 LogLevel.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

enum LogLevel: UInt32 {

    case verbose = 20
    case debug = 30
    case info = 40
    case warning = 50
    case error = 60

    var description: String {
        switch self {
        case .verbose: return "VERBOSE"
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }

    var emoji: String {
        switch self {
        case .verbose: return "🔵"
        case .debug: return "🟤"
        case .info: return "🟢"
        case .warning: return "🟡"
        case .error: return "🔴"
        }
    }

}
