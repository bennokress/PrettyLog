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
///     nonisolated func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: [ConsoleLog(), BackendLog()])
///     }
///
/// `ConsoleLog` and `BackendLog` stand for targets your app defines itself by conforming to `LogTarget`, and `.info` for a `LogLevel` it defines. Declare the functions, the targets and the levels `nonisolated`:
/// in an app whose default actor isolation is the main actor they would otherwise only be usable on the main actor. A complete file with the levels,
/// a console target and every log function is in the README under "Setup".
public struct PrettyLogProxy {

    /// Log an `Error`.
    ///
    /// The public part is the `localizedDescription` of a `LocalizedError` or an `NSError`, including the bridged ones like `URLError` and `CocoaError`. For any other error
    /// it is the name of its type, because Foundation would only produce "The operation couldn't be completed." with the module, the type and a case number that doesn't
    /// match the order in the source. The full description of the error is logged as sensitive part, because it contains the `userInfo` of an `NSError`,
    /// the complete URL of a `URLError` and every associated value of a custom error enum. Targets that can't log sensitive information only receive the public part.
    /// - Parameters:
    ///   - error: The error to log
    ///   - level: The level to log with
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to; an empty array logs nothing, so an app can switch logging off this way
    /// - Attention: No log will be created, if `error` is `nil`.
    public static func log(_ error: Error?, as level: LogLevel, category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        guard let error else { return }
        let assembler = LogStatementAssembler(message: publicDescription(of: error), sensitiveMessage: "\(error)")
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    /// The part of an error that any target may receive.
    private static func publicDescription(of error: Error) -> String {
        guard error is LocalizedError || type(of: error) is NSError.Type else { return String(describing: type(of: error)) }
        return error.localizedDescription
    }

    /// Log a `NSException`.
    ///
    /// The `name` of the exception is logged as the public part. Its `reason` and `userInfo` are free text that can contain anything, so they are logged as sensitive part.
    /// Targets that can't log sensitive information only receive the `name`.
    /// - Parameters:
    ///   - exception: The exception to log
    ///   - level: The level to log with
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to; an empty array logs nothing, so an app can switch logging off this way
    /// - Attention: No log will be created, if `exception` is `nil`.
    public static func log(_ exception: NSException?, as level: LogLevel, category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        guard let exception else { return }
        let userInfo = exception.userInfo.map { "\($0)" }
        let assembler = LogStatementAssembler(messages: [exception.name.rawValue], sensitiveMessages: [exception.reason, userInfo])
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    /// Log a statement with any level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - level: The level to log with
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to; an empty array logs nothing, so an app can switch logging off this way
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func log(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", as level: LogLevel, category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        let assembler = LogStatementAssembler(messages: messages, sensitiveMessages: sensitiveMessages, separator: separator)
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
    private static func log(_ level: LogLevel, statementAssembler: LogStatementAssembler, category: LogCategory, to targets: [LogTarget]) {
        for target in targets {
            target.log(level, messages: statementAssembler, category: category)
        }
    }

}
