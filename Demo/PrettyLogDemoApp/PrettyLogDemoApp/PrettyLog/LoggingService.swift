//
// 📄 LoggingService.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

// MARK: - Custom Log Levels

extension LogLevel {
    
    /// This custom level can be used for TODO items
    static var todo: LogLevel { .custom(emoji: "🟣", priority: 200) }
    
}

// MARK: - Global Logging Methods

/// Log a statement targeting only Xcode (with DEBUG level)
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logX(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logX(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: defaultTargets)
}

/// Log a statement targeting Xcode and the Staging Environment (with VERBOSE level)
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logS(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logS(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: defaultTargets)
}

/// Log a statement targeting all Environments from Xcode to Production (with INFO level)
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logP(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logP(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: defaultTargets)
}

/// Log a statement with WARNING level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logW(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logW(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: defaultTargets)
}

/// Log a statement with ERROR level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logE(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: defaultTargets)
}

/// Log a Key Event
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logK(messages, joinedBy: separator, category: category, to: defaultTargets)
}

/// Log a statement with TODO level
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
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
    PrettyLogProxy.log(error, category: category, to: defaultTargets)
}

/// Log a `NSException`
/// - Parameters:
///   - exception: The exception to log
///   - category: The category of the log statement (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `exception` is `nil`
func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(exception, category: category, to: defaultTargets)
}

// MARK: - Default Targets

private var defaultTargets: [LogTarget] {
    [ConsoleLog(), BackendLog()]
}
