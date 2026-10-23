//
// 📄 PrettyLogProxy.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The entry point of PrettyLog. It takes arrays instead of variadic parameters, so that your own project can define global log functions on top of it.
///
/// PrettyLog ships no log target and no global log functions, so every app decides itself where its log statements go and which of those destinations may receive
/// sensitive data. The setup is one file in your project that imports `PrettyLog`, defines the global log functions you want and passes your own targets.
/// The functions take arrays because Swift can't forward variadic parameters from one function to another, so your global functions hand them on:
///
///     import PrettyLog
///
///     nonisolated func logI(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: logTargets)
///     }
///
///     nonisolated var logTargets: [any LogTarget<AppLogLevel>] { [ConsoleLog(), BackendLog()] }
///
/// `ConsoleLog` and `BackendLog` stand for targets your app defines itself by conforming to `LogTarget`, and `.info` for a case of `AppLogLevel`, the enum your app declares with `@LogLevels`. Swift infers the level type from `as:` and `to:`, so the call never names it. Declare the functions, the targets and the levels `nonisolated`:
/// in an app whose default actor isolation is the main actor they would otherwise only be usable on the main actor. A complete file with the levels,
/// a console target and every log function is in the README under "Setup".
public struct PrettyLogProxy {

    /// The proxy is only a namespace for its static `log` functions, so an instance would mean nothing.
    private init() { }

    /// Log a statement with any level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement, each written as its `description`
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content, each written as its `description`
    ///   - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
    ///   - level: The level to log with
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to; an empty array logs nothing, so an app can switch logging off this way
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func log<Level: LogLevel>(_ messages: [(any CustomStringConvertible)?], sensitiveMessages: [(any CustomStringConvertible)?] = [], joinedBy separator: String = " - ", as level: Level, category: LogCategory = .uncategorized, to targets: [any LogTarget<Level>]) {
        let assembler = LogStatementAssembler(messages: messages.map { $0?.description }, sensitiveMessages: sensitiveMessages.map { $0?.description }, separator: separator)
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    // MARK: - Private Relay to the Log Designer

    /// Log a statement with any level.
    /// - Parameters:
    ///   - level: The level to log with
    ///   - statementAssembler: The log statement assembler containing all the messages
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to; an empty array logs nothing, so an app can switch logging off this way
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` inside the `statementAssembler` are both empty or consist only of `nil`-elements.
    private static func log<Level: LogLevel>(_ level: Level, statementAssembler: LogStatementAssembler, category: LogCategory, to targets: [any LogTarget<Level>]) {
        for target in targets {
            target.deliver(level, statement: statementAssembler, category: category)
        }
    }

}
