//
// 📄 Macros.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#73): the macros of variant V2.

/// Makes an enum a `LogLevel`: generates `emoji`, `allCases` and the marker that only this macro writes.
@attached(member, names: named(emoji), named(allCases), named(_$logLevelsMacro))
@attached(extension, conformances: LogLevel)
public macro LogLevels() = #externalMacro(module: "PrettyLogMacros", type: "LogLevelsMacro")

/// V2: the emoji of a case whose `Int` raw value is its priority: `@Emoji("🟤") case debug = 100`.
@attached(peer)
public macro Emoji(_ emoji: String) = #externalMacro(module: "PrettyLogMacros", type: "CaseMarkerMacro")

