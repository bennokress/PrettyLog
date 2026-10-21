//
// 📄 LoggingService.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

// MARK: - Log Levels

extension LogLevel {

    static var debug: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
    static var verbose: LogLevel { LogLevel(emoji: "🔵", priority: 300) }
    static var info: LogLevel { LogLevel(emoji: "🟢", priority: 500) }
    static var warning: LogLevel { LogLevel(emoji: "🟡", priority: 700) }
    static var error: LogLevel { LogLevel(emoji: "🔴", priority: 900) }
    static var keyEvent: LogLevel { LogLevel(emoji: "📊", priority: .max) }

    /// This custom level can be used for TODO items
    static var todo: LogLevel { LogLevel(emoji: "🟣", priority: 200) }

}

// MARK: - Global Logging Methods

/// Log a statement targeting only Xcode (with DEBUG level)
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logX(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: defaultTargets)
}

/// Log a statement with VERBOSE level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logV(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: defaultTargets)
}

/// Log a statement targeting Xcode and the Staging Environment (with VERBOSE level)
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logS(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: defaultTargets)
}

/// Log a statement targeting all Environments from Xcode to Production (with INFO level)
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logP(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: defaultTargets)
}

/// Log a statement with WARNING level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logW(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .warning, category: category, to: defaultTargets)
}

/// Log a statement with ERROR level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logE(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .error, category: category, to: defaultTargets)
}

/// Log a Key Event
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, joinedBy: separator, as: .keyEvent, category: category, to: defaultTargets)
}

/// Log a statement with TODO level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logT(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .todo, category: category, to: defaultTargets)
}

/// Log an `Error`
/// - Parameters:
///   - error: The error to log
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `error` is `nil`
func log(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(error, as: .error, category: category, to: defaultTargets)
}

/// Log a `NSException`
/// - Parameters:
///   - exception: The exception to log
///   - category: The category of the log statement (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `exception` is `nil`
func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(exception, as: .error, category: category, to: defaultTargets)
}

// MARK: - Default Targets

private var defaultTargets: [LogTarget] {
    [ConsoleLog(), BackendLog()]
}
