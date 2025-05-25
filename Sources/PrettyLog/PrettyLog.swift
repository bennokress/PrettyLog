//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// Log a statement with DEBUG level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logD(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logD(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: targets)
}

/// Log a statement targeting only Xcode (with DEBUG level)
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logX(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logX(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: targets)
}

/// Log a statement with VERBOSE level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logV(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logV(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: targets)
}

/// Log a statement with INFO level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: targets)
}

/// Log a statement with WARNING level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logW(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logW(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: targets)
}

/// Log a statement with ERROR level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logE(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logE(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: targets)
}

/// Log a Key Event
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
///     - targets: The targets this log statement is sent to (defaults to the Xcode console only)
/// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
public func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized, to targets: [LogTarget] = [ConsoleLog()]) {
    PrettyLogProxy.logK(messages, joinedBy: separator, category: category, to: targets)
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
