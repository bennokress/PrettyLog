import PrettyLog
import Testing
@testable import V0App
@testable import V1App
@testable import V2App
@testable import V3App

// The same checks for every variant: emoji, priority, order by priority, and the filters.
nonisolated func check<Level: LogLevel>(debug: Level, verbose: Level, info: Level, warning: Level, error: Level, keyEvent: Level) {
    #expect(debug.emoji == "🟤")
    #expect(info.priority == 500)
    #expect(Level.allCases.count == 6)
    #expect(Level.allCases.sorted() == [debug, verbose, info, warning, error, keyEvent])
    #expect(LogLevelPriorityFilter.only(info) == .between(info, and: info))
    #expect(LogLevelPriorityFilter.from(keyEvent) == .only(keyEvent))
    #expect(LogLevelPriorityFilter.between(warning, and: verbose).contains(info))
    #expect(!LogLevelPriorityFilter.between(verbose, and: warning).contains(error))
    #expect(LogLevelPriorityFilter<Level>.none == .only())
}

@Test func v0() { check(debug: V0App.AppLogLevel.debug, verbose: .verbose, info: .info, warning: .warning, error: .error, keyEvent: .keyEvent) }
@Test func v1() { check(debug: V1App.AppLogLevel.debug, verbose: .verbose, info: .info, warning: .warning, error: .error, keyEvent: .keyEvent) }
@Test func v2() { check(debug: V2App.AppLogLevel.debug, verbose: .verbose, info: .info, warning: .warning, error: .error, keyEvent: .keyEvent) }
@Test func v3() { check(debug: V3App.AppLogLevel.debug, verbose: .verbose, info: .info, warning: .warning, error: .error, keyEvent: .keyEvent) }
