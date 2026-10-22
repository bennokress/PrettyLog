import PrettyLog

// V1: no macro. The raw value is a text of emoji and priority, parsed by `LogLevelSpec` from the package.
nonisolated enum AppLogLevel: LogLevelSpec, LogLevel {

    case debug = "🟤 100"
    case error = "🔴 900"
    case info = "🟢 500"
    case keyEvent = "📊 1000"
    case verbose = "🔵 300"
    case warning = "🟡 700"

}
