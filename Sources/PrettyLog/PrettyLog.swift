//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// Log messages in the provided order with VERBOSE level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logV(messages, joinedBy: separator, category: category, to: targets)
}

/// Log messages in the provided order with DEBUG level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logD(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logD(messages, joinedBy: separator, category: category, to: targets)
}

/// Log messages in the provided order with INFO level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logI(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logI(messages, joinedBy: separator, category: category, to: targets)
}

/// Log messages in the provided order with WARNING level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logW(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logW(messages, joinedBy: separator, category: category, to: targets)
}

/// Log messages in the provided order with ERROR level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logE(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logE(messages, joinedBy: separator, category: category, to: targets)
}

/// Log an `Error` with ERROR level.
/// - Parameters:
///     - error: The error to log
///     - level: The level to log with (defaults to `.error`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `error` is `nil`.
public func log(_ error: Error?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.log(error, as: level, category: category, to: targets)
}

/// Log a `NSException` with ERROR level.
/// - Parameters:
///     - exception: The exception to log
///     - level: The level to log with (defaults to `.error`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `exception` is `nil`.
public func log(_ exception: NSException?, as level: LogLevel = .error, category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.log(exception, as: level, category: category, to: targets)
}
