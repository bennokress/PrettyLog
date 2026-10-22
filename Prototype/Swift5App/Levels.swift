import PrettyLog

// V2: macro plus Int raw value. The compiler checks the priorities, the macro adds emoji and allCases.
@LogLevels
nonisolated enum AppLogLevel: Int {

    @Emoji("🟤") case debug = 100
    @Emoji("🔴") case error = 900
    @Emoji("🟢") case info = 500
    @Emoji("📊") case keyEvent = 1000
    @Emoji("🔵") case verbose = 300
    @Emoji("🟡") case warning = 700

}
