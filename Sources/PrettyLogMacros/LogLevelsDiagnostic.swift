//
// 📄 LogLevelsDiagnostic.swift
// 👨🏼‍💻 Author: Benno Kress
//

import SwiftDiagnostics

/// The errors `@LogLevels` and `@Emoji` report. Each message says how to fix the declaration, because the app developer sees it in the editor next to their own code.
enum LogLevelsDiagnostic: String, DiagnosticMessage {

    case notAnEnum
    case rawTypeIsNotInt
    case caseWithoutEmoji
    case emojiIsNotAStringLiteral
    case emojiIsEmpty
    case severalLevelsInOneCase
    case emojiOutsideOfCase

    var message: String {
        switch self {
        case .notAnEnum:
            "@LogLevels can only be attached to an enum"
        case .rawTypeIsNotInt:
            "A @LogLevels enum needs Int as its raw type, because the raw value is the priority"
        case .caseWithoutEmoji:
            "Every level needs an emoji: @Emoji(\"🟤\") case debug = 100"
        case .emojiIsNotAStringLiteral:
            "The emoji has to be a string literal without interpolation"
        case .emojiIsEmpty:
            "The emoji must not be empty"
        case .severalLevelsInOneCase:
            "Declare every level in a case of its own, so that each one gets its own @Emoji"
        case .emojiOutsideOfCase:
            "@Emoji can only be attached to a case of a @LogLevels enum"
        }
    }

    var diagnosticID: MessageID { MessageID(domain: "PrettyLog", id: rawValue) }

    var severity: DiagnosticSeverity { .error }

}
