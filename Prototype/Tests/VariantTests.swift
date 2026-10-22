import PrettyLog
import Testing
@testable import V2App

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

@Test func v2() { check(debug: V2App.AppLogLevel.debug, verbose: .verbose, info: .info, warning: .warning, error: .error, keyEvent: .keyEvent) }

@Test func v2PriorityIsTheRawValue() {
    #expect(V2App.AppLogLevel.keyEvent.priority == 1000)
    #expect(V2App.AppLogLevel(rawValue: 500) == .info)
}
