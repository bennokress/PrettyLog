//
// 📄 Macros.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#73): macros for variants V2 and V3.

/// Makes an enum a `LogLevel`: generates `emoji`, `allCases` and, for `@Level` cases, `priority`.
@attached(member, names: named(emoji), named(priority), named(allCases))
@attached(extension, conformances: LogLevel)
public macro LogLevels() = #externalMacro(module: "PrettyLogMacros", type: "LogLevelsMacro")

/// V2: the emoji of a case whose `Int` raw value is its priority: `@Emoji("🟤") case debug = 100`.
@attached(peer)
public macro Emoji(_ emoji: String) = #externalMacro(module: "PrettyLogMacros", type: "CaseMarkerMacro")

/// V3: emoji and priority of a case in an enum without raw values: `@Level("🟤", priority: 100) case debug`.
@attached(peer)
public macro Level(_ emoji: String, priority: Int) = #externalMacro(module: "PrettyLogMacros", type: "CaseMarkerMacro")
