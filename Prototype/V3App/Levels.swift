import PrettyLog

// V3: macro without raw value. The macro adds emoji, priority and allCases, and checks the priorities itself.
@LogLevels
nonisolated enum AppLogLevel {

    @Level("🟤", priority: 100) case debug
    @Level("🔴", priority: 900) case error
    @Level("🟢", priority: 500) case info
    @Level("📊", priority: 1000) case keyEvent
    @Level("🔵", priority: 300) case verbose
    @Level("🟡", priority: 700) case warning

}
