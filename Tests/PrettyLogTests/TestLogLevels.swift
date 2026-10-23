//
// 📄 TestLogLevels.swift
// 👨🏼‍💻 Author: Benno Kress
//

import PrettyLog

/// PrettyLog ships no levels, so the tests declare the same set the README suggests, as an app would.
/// The cases are sorted alphabetically on purpose: every test that compares levels then also checks that the order of the cases means nothing.
@LogLevels
nonisolated enum AppLogLevel: Int {

    @Emoji("🟤") case debug = 100
    @Emoji("🔴") case error = 900
    @Emoji("🟢") case info = 500
    @Emoji("📊") case keyEvent = 1000
    @Emoji("🔵") case verbose = 300
    @Emoji("🟡") case warning = 700

}

/// A second app's levels, to check that a generic target works with more than one level type.
@LogLevels
nonisolated enum OtherAppLogLevel: Int {
    @Emoji("⬇️") case low = 1
    @Emoji("⬆️") case high = 2
}
