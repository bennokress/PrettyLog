//
// 📄 TestLogLevels.swift
// 👨🏼‍💻 Author: Benno Kress
//

import PrettyLog

/// PrettyLog ships no levels, so the tests define the same set the README suggests, as an app would.
extension LogLevel {

    static var debug: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
    static var verbose: LogLevel { LogLevel(emoji: "🔵", priority: 300) }
    static var info: LogLevel { LogLevel(emoji: "🟢", priority: 500) }
    static var warning: LogLevel { LogLevel(emoji: "🟡", priority: 700) }
    static var error: LogLevel { LogLevel(emoji: "🔴", priority: 900) }
    static var keyEvent: LogLevel { LogLevel(emoji: "📊", priority: .max) }

}
