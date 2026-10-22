import PrettyLog

// V0: the plan before #73. Two places per level: the case with its priority, and the emoji in a switch.
nonisolated enum AppLogLevel: Int, LogLevel {

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
