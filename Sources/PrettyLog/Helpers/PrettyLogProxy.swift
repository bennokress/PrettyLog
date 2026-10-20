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
///     func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: [ConsoleLog(), BackendLog()])
///     }
///
/// `ConsoleLog` and `BackendLog` stand for targets your app defines itself by conforming to `LogTarget`. A complete file with a console target, every log function
/// and a custom level is in the README under "Setup".
public struct PrettyLogProxy {

    /// Log a statement with DEBUG level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logD(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: targets)
    }

    /// Log a statement targeting only Xcode (with DEBUG level).
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logX(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: targets)
    }

    /// Log a statement with VERBOSE level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logV(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: targets)
    }

    /// Log a statement targeting Xcode and the Staging Environment (with VERBOSE level).
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logS(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: targets)
    }

    /// Log a statement with INFO level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logI(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: targets)
    }

    /// Log a statement targeting all Environments from Xcode to Production (with INFO level).
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logP(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: targets)
    }

    /// Log a statement with WARNING level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logW(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .warning, category: category, to: targets)
    }

    /// Log a statement with ERROR level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logE(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .error, category: category, to: targets)
    }

    /// Log a Key Event.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - separator: The separator between messages (defaults to `" - "`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages`is empty or consist only of `nil`-elements!
    public static func logK(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        log(messages, joinedBy: separator, as: .keyEvent, category: category, to: targets)
    }

    /// Log an `Error`.
    ///
    /// The `localizedDescription` is logged as the public part. The full description of the error is logged as sensitive part, because it contains the `userInfo` of an `NSError`,
    /// the complete URL of a `URLError` and every associated value of a custom error enum. Targets that can't log sensitive information only receive the `localizedDescription`.
    /// - Parameters:
    ///   - error: The error to log
    ///   - level: The level to log with (defaults to `.error`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `error` is `nil`.
    public static func log(_ error: Error?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget]) {
        guard let error else { return }
        let assembler = LogStatementAssembler(message: error.localizedDescription, sensitiveMessage: "\(error)")
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    /// Log a `NSException`.
    ///
    /// The `name` of the exception is logged as the public part. Its `reason` and `userInfo` are free text that can contain anything, so they are logged as sensitive part.
    /// Targets that can't log sensitive information only receive the `name`.
    /// - Parameters:
    ///   - exception: The exception to log
    ///   - level: The level to log with (defaults to `.error`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `exception` is `nil`.
    public static func log(_ exception: NSException?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget]) {
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
    ///   - targets: The targets this log statement is sent to
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
    ///   - targets: The targets this log statement is sent to
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` inside the `statementAssembler` are both empty or consist only of `nil`-elements.
    private static func log(_ level: LogLevel, statementAssembler: LogStatementAssembler, category: LogCategory, to targets: [LogTarget]) {
        assert(!targets.isEmpty, "⚠️ Warning: trying to log, but no log targets were passed to the log method. No logs will be recorded!")
        for target in targets {
            target.log(level, messages: statementAssembler, category: category)
        }
    }

}
