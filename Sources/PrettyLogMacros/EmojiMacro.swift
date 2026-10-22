//
// 📄 EmojiMacro.swift
// 👨🏼‍💻 Author: Benno Kress
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// `@Emoji` generates nothing. `@LogLevels` reads it from every case; this macro only exists so that the attribute compiles and is rejected anywhere but on a case.
public struct EmojiMacro: PeerMacro {

    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        if !declaration.is(EnumCaseDeclSyntax.self) {
            context.diagnose(Diagnostic(node: node, message: LogLevelsDiagnostic.emojiOutsideOfCase))
        }
        return []
    }

}
