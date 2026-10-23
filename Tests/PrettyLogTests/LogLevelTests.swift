//
// 📄 LogLevelTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logLevelEmojiComesFromTheEmojiAttribute() {
    #expect(AppLogLevel.debug.emoji == "🟤")
    #expect(AppLogLevel.keyEvent.emoji == "📊")
}

@Test
func logLevelPriorityIsTheRawValue() {
    #expect(AppLogLevel.debug.priority == 100)
    #expect(AppLogLevel.keyEvent.priority == 1000)
    #expect(AppLogLevel(rawValue: 500) == .info)
    #expect(AppLogLevel(rawValue: 501) == nil)
}

@Test
func logLevelAllCasesFollowTheDeclaration() {
    #expect(AppLogLevel.allCases == [.debug, .error, .info, .keyEvent, .verbose, .warning])
}

@Test
func logLevelsAreOrderedByPriorityNotByTheirCases() {
    #expect(AppLogLevel.allCases.sorted() == [.debug, .verbose, .info, .warning, .error, .keyEvent])
    #expect(AppLogLevel.debug < .verbose)
    #expect(AppLogLevel.error < .keyEvent)
    #expect(!(AppLogLevel.info < .info))
}

@Test
func logLevelSwitchNeedsNoDefault() {
    // Targets that map levels to something else, like an `os.Logger` type, switch over the levels the app defines. This compiles only while the switch is exhaustive without a `default`.
    func name(of level: AppLogLevel) -> String {
        switch level {
        case .debug: "debug"
        case .error: "error"
        case .info: "info"
        case .keyEvent: "keyEvent"
        case .verbose: "verbose"
        case .warning: "warning"
        }
    }
    #expect(name(of: .debug) == "debug")
    #expect(name(of: .warning) == "warning")
}

@Test
func logLevelIsSendable() {
    // Compiles only while LogLevel requires Sendable, which consumers need to store levels in a `static let` or pass them into a `Task`.
    let levels: [any Sendable] = [AppLogLevel.debug, OtherAppLogLevel.high]
    #expect(levels.count == 2)
}

@Test
func logLevelsOfAMacroEnumNeverShareAPriority() {
    #expect(LogLevelPriorityFilter<AppLogLevel>.levelsSharingAPriority.isEmpty)
}

@Test
func logLevelsSharingAPriorityAreFoundInAHandWrittenConformance() {
    // Only a type that copies the marker line can get here; building a filter for it would stop the app in debug builds.
    #expect(LogLevelPriorityFilter<HandWrittenLogLevel>.levelsSharingAPriority.map(\.emoji) == ["🟢", "🟣"])
}

/// What an app would have to write to get around `@LogLevels`: a struct that copies the marker line the macro generates. It compiles, which can't be prevented.
private struct HandWrittenLogLevel: LogLevel {

    static let allCases = [HandWrittenLogLevel(rawValue: 100, emoji: "🟤"), HandWrittenLogLevel(rawValue: 500, emoji: "🟢"), HandWrittenLogLevel(rawValue: 500, emoji: "🟣")]
    static var _$logLevelsMacro: LogLevelsMacroMarker { ._$generated() }

    let rawValue: Int
    let emoji: String

    init(rawValue: Int, emoji: String) {
        self.rawValue = rawValue
        self.emoji = emoji
    }

    init?(rawValue: Int) {
        nil
    }

}
