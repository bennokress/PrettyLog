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
///     //
///     // 📄 PrettyLog.swift
///     // 👨🏼‍💻 Author: Benno Kress
///     // 🗓️ Created: 22.07.22
///     //
///
///     import Foundation
///     import PrettyLog
///
///     /// Log messages in the provided order with VERBOSE level
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` is empty or `nil`.
///     func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logV(messages, joinedBy: separator, category: category)
///     }
///
///     /// Log messages in the provided order with DEBUG level
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` is empty or `nil`.
///     func logD(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logD(messages, joinedBy: separator, category: category)
///     }
///
///     /// Log messages in the provided order with INFO level
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` is empty or `nil`.
///     func logI(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logI(messages, joinedBy: separator, category: category)
///     }
///
///     /// Log messages in the provided order with WARNING level
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` is empty or `nil`.
///     func logW(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logW(messages, joinedBy: separator, category: category)
///     }
///
///     /// Log messages in the provided order with ERROR level
///     /// - Parameters:
///     ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     ///     - separator: The separator between messages (defaults to `-`)
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `messages` is empty or `nil`.
///     func logE(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
///         PrettyLogProxy.logE(messages, joinedBy: separator, category: category)
///     }
///
///     /// Log an `Error` with ERROR level.
///     /// - Parameters:
///     ///     - error: The error to log
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `error` is `nil`.
///     func log(_ error: Error?, category: LogCategory = .uncategorized) {
///         PrettyLogProxy.log(error, category: category)
///     }
///
///     /// Log a `NSException` with ERROR level.
///     /// - Parameters:
///     ///     - exception: The exception to log
///     ///     - category: The category of the log message (defaults to `.uncategorized`)
///     /// - Attention: No log will be created, if `exception` is `nil`.
///     func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
///         PrettyLogProxy.log(exception, category: category)
///     }
///
///     // TODO: Add custom global log methods if needed -> for example: if you have custom LogLevel and LogCategory `.todo`, you could define `logT for that.
///
///     // /// Log messages in the provided order with TODO level
///     // /// - Parameters:
///     // ///     - messages: One or more strings and string-convertible objects to include in the log statement
///     // ///     - separator: The separator between messages (defaults to `-`)
///     // /// - Attention: No log will be created, if `messages` is empty or `nil`.
///     // public func logT(_ messages: String?..., joinedBy separator: String = " - ") {
///     //     PrettyLogProxy.log(messages, joinedBy: separator, as: .todo, category: .todo)
///     // }
///
public struct PrettyLogProxy {

    /// Log messages in the provided order with VERBOSE level
    /// - Parameters:
    ///     - messages: One or more strings and string-convertible objects to include in the log statement
    ///     - separator: The separator between messages (defaults to `-`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    public static func logV(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, joinedBy: separator, as: .verbose, category: category, to: targets)
    }

    /// Log messages in the provided order with DEBUG level
    /// - Parameters:
    ///     - messages: One or more strings and string-convertible objects to include in the log statement
    ///     - separator: The separator between messages (defaults to `-`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    public static func logD(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, joinedBy: separator, as: .debug, category: category, to: targets)
    }

    /// Log messages in the provided order with INFO level
    /// - Parameters:
    ///     - messages: One or more strings and string-convertible objects to include in the log statement
    ///     - separator: The separator between messages (defaults to `-`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    public static func logI(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, joinedBy: separator, as: .info, category: category, to: targets)
    }

    /// Log messages in the provided order with WARNING level
    /// - Parameters:
    ///     - messages: One or more strings and string-convertible objects to include in the log statement
    ///     - separator: The separator between messages (defaults to `-`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    public static func logW(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, joinedBy: separator, as: .warning, category: category, to: targets)
    }

    /// Log messages in the provided order with ERROR level
    /// - Parameters:
    ///     - messages: One or more strings and string-convertible objects to include in the log statement
    ///     - separator: The separator between messages (defaults to `-`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    public static func logE(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        log(messages, joinedBy: separator, as: .error, category: category, to: targets)
    }

    /// Log an `Error` with ERROR level.
    /// - Parameters:
    ///     - error: The error to log
    ///     - level: The level to log with (defaults to `.error`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `error` is `nil`.
    public static func log(_ error: Error?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        guard let error = error else { return }
        let statement = "\(error.localizedDescription) (\(error))"
        log(level, statement: statement, category: category, to: targets)
    }

    /// Log a `NSException` with ERROR level.
    /// - Parameters:
    ///     - exception: The exception to log
    ///     - level: The level to log with (defaults to `.error`)
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `exception` is `nil`.
    public static func log(_ exception: NSException?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        guard let exception = exception else { return }
        let statement = exception.description
        log(level, statement: statement, category: category, to: targets)
    }

    /// Log messages in the provided order with any level.
    /// - Parameters:
    ///     - messages: One or more strings and string-convertible objects to include in the log statement
    ///     - separator: The separator between messages (defaults to `-`)
    ///     - level: The level to log with
    ///     - category: The category of the log message (defaults to `.uncategorized`)
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    public static func log(_ messages: [String?], joinedBy separator: String = " - ", as level: LogLevel, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
        guard let statement = String.joined(from: messages, using: separator) else { return }
        log(level, statement: statement, category: category, to: targets)
    }

    // MARK: - Private Relay to the Log Designer

    /// Log messages in the provided order with any level.
    /// - Parameters:
    ///     - level: The level to log with
    ///     - statement: The statement to log
    ///     - category: The category of the log message
    /// - Attention: No log will be created, if `messages` is empty or `nil`.
    private static func log(_ level: LogLevel, statement: String, category: LogCategory, to targets: [LogTarget]) {
        for target in targets {
            target.log(level, message: statement, category: category)
        }
    }

}
