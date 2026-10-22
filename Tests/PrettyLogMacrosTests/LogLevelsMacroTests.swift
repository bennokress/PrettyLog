//
// 📄 LogLevelsMacroTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing

// The macro implementation runs on the machine that builds, so it can only be imported where the tests run on that machine, which is the Mac. On a simulator these tests are skipped.
#if canImport(PrettyLogMacros)
import PrettyLogMacros

private let macroSpecs: [String: MacroSpec] = [
    "LogLevels": MacroSpec(type: LogLevelsMacro.self, conformances: [TypeSyntax(IdentifierTypeSyntax(name: .identifier("LogLevel")))]),
    "Emoji": MacroSpec(type: EmojiMacro.self)
]
#endif

private let isMacroAvailable: Bool = {
    #if canImport(PrettyLogMacros)
    true
    #else
    false
    #endif
}()

/// Runs `assertMacroExpansion` and reports its failures to Swift Testing.
private func expectExpansion(of originalSource: String, expandedSource: String, diagnostics: [DiagnosticSpec] = [], sourceLocation: Testing.SourceLocation = #_sourceLocation) {
    #if canImport(PrettyLogMacros)
    assertMacroExpansion(originalSource, expandedSource: expandedSource, diagnostics: diagnostics, macroSpecs: macroSpecs) { failure in
        Issue.record(Comment(rawValue: failure.message), sourceLocation: sourceLocation)
    }
    #endif
}

@Suite(.enabled(if: isMacroAvailable, "The macro implementation can only be imported on the Mac"))
struct LogLevelsMacroTests {

    @Test
    func generatesEmojiAllCasesMarkerAndConformance() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel: Int {
                @Emoji("🟤") case debug = 100
                @Emoji("🔴") case error = 900
            }
            """,
            expandedSource: """
            enum AppLogLevel: Int {
                case debug = 100
                case error = 900

                var emoji: String {
                    switch self {
                    case .debug:
                        "🟤"
                    case .error:
                        "🔴"
                    }
                }

                static var allCases: [Self] {
                    [.debug, .error]
                }

                static var _$logLevelsMacro: PrettyLog.LogLevelsMacroMarker {
                    ._$generated()
                }
            }

            extension AppLogLevel: PrettyLog.LogLevel {
            }
            """
        )
    }

    @Test
    func membersOfAPublicEnumArePublic() {
        expectExpansion(
            of: """
            @LogLevels
            public enum SDKLogLevel: Int {
                @Emoji("🟤") case debug = 100
            }
            """,
            expandedSource: """
            public enum SDKLogLevel: Int {
                case debug = 100

                public var emoji: String {
                    switch self {
                    case .debug:
                        "🟤"
                    }
                }

                public static var allCases: [Self] {
                    [.debug]
                }

                public static var _$logLevelsMacro: PrettyLog.LogLevelsMacroMarker {
                    ._$generated()
                }
            }

            extension SDKLogLevel: PrettyLog.LogLevel {
            }
            """
        )
    }

    @Test
    func rejectsAStruct() {
        expectExpansion(
            of: """
            @LogLevels
            struct AppLogLevel {
            }
            """,
            expandedSource: """
            struct AppLogLevel {
            }
            """,
            diagnostics: [DiagnosticSpec(message: "@LogLevels can only be attached to an enum", line: 1, column: 1)]
        )
    }

    @Test
    func rejectsAnEnumWithoutRawType() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel {
                @Emoji("🟤") case debug
            }
            """,
            expandedSource: """
            enum AppLogLevel {
                case debug
            }
            """,
            diagnostics: [DiagnosticSpec(message: "A @LogLevels enum needs Int as its raw type, because the raw value is the priority", line: 2, column: 6)]
        )
    }

    @Test
    func rejectsAStringRawType() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel: String {
                @Emoji("🟤") case debug
            }
            """,
            expandedSource: """
            enum AppLogLevel: String {
                case debug
            }
            """,
            diagnostics: [DiagnosticSpec(message: "A @LogLevels enum needs Int as its raw type, because the raw value is the priority", line: 2, column: 17)]
        )
    }

    @Test
    func rejectsACaseWithoutEmoji() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel: Int {
                @Emoji("🟤") case debug = 100
                case error = 900
            }
            """,
            expandedSource: """
            enum AppLogLevel: Int {
                case debug = 100
                case error = 900
            }

            extension AppLogLevel: PrettyLog.LogLevel {
            }
            """,
            diagnostics: [DiagnosticSpec(message: "Every level needs an emoji: @Emoji(\"🟤\") case debug = 100", line: 4, column: 5)]
        )
    }

    @Test
    func rejectsAnInterpolatedEmoji() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel: Int {
                @Emoji("\\(debugEmoji)") case debug = 100
            }
            """,
            expandedSource: """
            enum AppLogLevel: Int {
                case debug = 100
            }

            extension AppLogLevel: PrettyLog.LogLevel {
            }
            """,
            diagnostics: [DiagnosticSpec(message: "The emoji has to be a string literal without interpolation", line: 3, column: 5)]
        )
    }

    @Test
    func rejectsAnEmptyEmoji() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel: Int {
                @Emoji("") case debug = 100
            }
            """,
            expandedSource: """
            enum AppLogLevel: Int {
                case debug = 100
            }

            extension AppLogLevel: PrettyLog.LogLevel {
            }
            """,
            diagnostics: [DiagnosticSpec(message: "The emoji must not be empty", line: 3, column: 5)]
        )
    }

    @Test
    func rejectsSeveralLevelsInOneCase() {
        expectExpansion(
            of: """
            @LogLevels
            enum AppLogLevel: Int {
                @Emoji("🟤") case debug = 100, verbose = 300
            }
            """,
            expandedSource: """
            enum AppLogLevel: Int {
                case debug = 100, verbose = 300
            }

            extension AppLogLevel: PrettyLog.LogLevel {
            }
            """,
            // Columns count UTF-8 bytes, so the emoji takes four of them. Column 25 is the `d` of `debug`.
            diagnostics: [DiagnosticSpec(message: "Declare every level in a case of its own, so that each one gets its own @Emoji", line: 3, column: 25)]
        )
    }

    @Test
    func rejectsEmojiOutsideOfACase() {
        expectExpansion(
            of: """
            @Emoji("🟤")
            var debug = 100
            """,
            expandedSource: """
            var debug = 100
            """,
            diagnostics: [DiagnosticSpec(message: "@Emoji can only be attached to a case of a @LogLevels enum", line: 1, column: 1)]
        )
    }

}
