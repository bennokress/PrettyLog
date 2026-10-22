//
// 📄 PrettyLogMacrosPlugin.swift
// 👨🏼‍💻 Author: Benno Kress
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PrettyLogMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [LogLevelsMacro.self, EmojiMacro.self]
}
