//
// 📄 PrettyLogProxy.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// This is a proxy that can be used to define global log methods in your own project.
///
/// You can always call the global methods provided by the `PrettyLog` package. However importing `PrettyLog` in every single file might become cumbersome, especially for large projects. That's why the preferred way of using `PrettyLog` is probably
/// to create one file that defines global log messages (and maybe even custom categories using `LogCategory`). This step is necessary because variadic parameters can't be forwarded from one method to another. Your Logging Service could look like this:
///
///     import Foundation
///     import PrettyLog
///
///     /// Log a statement with VERBOSE level.
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
///     func logV(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logV(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
///     }
///
///     /// Log a statement with DEBUG level.
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
///     func logD(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logD(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
///     }
///
///     /// Log a statement with INFO level.
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
///     func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
///     }
///
///     /// Log a statement with WARNING level.
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
///     func logW(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logW(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
///     }
///
///     /// Log a statement with ERROR level.
///     /// - Parameters:
///     ///   - messages: One or more strings and string-convertible objects to include in the log statement
///     ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     ///   - separator: The separator between messages (defaults to `-`)
///     ///   - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
///     func logE(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logE(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
///     }
///
///     /// Log a Key Event.
///     /// - Parameters:
///     ///   - messages: One or more strings and string-convertible objects to include in the log statement
///     ///   - separator: The separator between messages (defaults to `-`)
///     ///   - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
///     func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logK(messages, joinedBy: separator, category: category)
///     }
///
///     /// Log an `Error`.
///     /// - Parameters:
///     ///   - error: The error to log
///     ///   - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `error` is `nil`.
///     func log(_ error: Error?, category: LogCategory = .uncategorized) {
///         PrettyLogProxy.log(error, category: category)
///     }
///
///     /// Log a `NSException`.
///     /// - Parameters:
///     ///   - exception: The exception to log
///     ///   - category: The category of the log statement (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `exception` is `nil`.
///     func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
///         PrettyLogProxy.log(exception, category: category)
///     }
///
///     // TODO: Add custom global log methods if needed -> for example: if you have custom LogLevel and LogCategory `.todo`, you could define `logT for that.
///
///     // /// Log a statement with TODO level.
///     // /// - Parameters:
///     // ///   - messages: One or more strings and string-convertible objects to include in the log statement
///     // ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     // ///   - separator: The separator between messages (defaults to `-`)
///     // /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
///     // public func logT(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ") {
///     //     PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .todo, category: .todo)
///     // }
///
public struct PrettyLogProxy {

    /// Log a statement with DEBUG level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logD(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: targets)
    }

    /// Log a statement targeting only Xcode (with DEBUG level).
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logX(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: targets)
    }

    /// Log a statement with VERBOSE level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logV(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: targets)
    }

    /// Log a statement targeting Xcode and the Staging Environment (with VERBOSE level).
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logS(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: targets)
    }

    /// Log a statement with INFO level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logI(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: targets)
    }

    /// Log a statement targeting all Environments from Xcode to Production (with INFO level).
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logP(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: targets)
    }

    /// Log a statement with WARNING level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logW(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .warning, category: category, to: targets)
    }

    /// Log a statement with ERROR level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func logE(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .error, category: category, to: targets)
    }

    /// Log a Key Event.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages`is empty or consist only of `nil`-elements!
    public static func logK(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, joinedBy: separator, as: .keyEvent, category: category, to: targets)
    }

    /// Log an `Error`.
    /// - Parameters:
    ///   - error: The error to log
    ///   - level: The level to log with (defaults to `.error`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `error` is `nil`.
    public static func log(_ error: Error?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        guard let error = error else { return }
        let assembler = LogStatementAssembler(message: "\(error.localizedDescription) (\(error))")
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    /// Log a `NSException`.
    /// - Parameters:
    ///   - exception: The exception to log
    ///   - level: The level to log with (defaults to `.error`)
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `exception` is `nil`.
    public static func log(_ exception: NSException?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        guard let exception else { return }
        let assembler = LogStatementAssembler(message: exception.description)
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    /// Log a statement with any level.
    /// - Parameters:
    ///   - messages: One or more strings and string-convertible objects to include in the log statement
    ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
    ///   - separator: The separator between messages (defaults to `-`)
    ///   - level: The level to log with
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
    public static func log(_ messages: [String?], sensitiveMessages: [String?] = [], joinedBy separator: String = " - ", as level: LogLevel, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        let assembler = LogStatementAssembler(messages: messages, sensitiveMessages: sensitiveMessages, separator: separator)
        log(level, statementAssembler: assembler, category: category, to: targets)
    }

    // MARK: - Private Relay to the Log Designer

    /// Log a statement with any level.
    /// - Parameters:
    ///   - level: The level to log with
    ///   - statementAssembler: The log statement assembler containing all the messages
    ///   - category: The category of the log statement (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` and `sensitiveMessages` inside the `statementAssembler` are both empty or consist only of `nil`-elements.
    private static func log(_ level: LogLevel, statementAssembler: LogStatementAssembler, category: LogCategory, to targets: [LogTarget]) {
        assert(!targets.isEmpty, "⚠️ Warning: trying to log, but no log targets were passed to the log method. No logs will be recorded!")
        for target in targets {
            target.log(level, messages: statementAssembler, category: category)
        }
    }

}
