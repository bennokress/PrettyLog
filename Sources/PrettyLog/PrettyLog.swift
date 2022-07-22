//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

// MARK: - Global aliases

/// Log strings in order with VERBOSE level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logV(messages, joinedBy: separator, category: category)
}

/// Log strings in order with DEBUG level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.     
public func logD(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logD(messages, joinedBy: separator, category: category)
}

/// Log strings in order with INFO level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.     
public func logI(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logI(messages, joinedBy: separator, category: category)
}

/// Log strings in order with WARNING level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.     
public func logW(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logW(messages, joinedBy: separator, category: category)
}

/// Log strings in order with ERROR level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.     
public func logE(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(messages, joinedBy: separator, category: category)
}

/// Log with ERROR level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.     
public func logE(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(error, category: category)
}

/// Log with ERROR level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.     
public func logE(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(exception, category: category)
}

// MARK: - Alternative Call Signature for Usage as a Proxy
// -> Variadic Parameters can't be passed on to another method

public struct PrettyLogProxy {
    
    public static func logV(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
        guard let message = String.joined(from: messages, using: separator) else { return }
        PrettyLog.shared.log(.verbose, message: message, category: category)
    }
    
    public static func logD(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
        guard let message = String.joined(from: messages, using: separator) else { return }
        PrettyLog.shared.log(.debug, message: message, category: category)
    }
    
    public static func logI(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
        guard let message = String.joined(from: messages, using: separator) else { return }
        PrettyLog.shared.log(.info, message: message, category: category)
    }
    
    public static func logW(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
        guard let message = String.joined(from: messages, using: separator) else { return }
        PrettyLog.shared.log(.warning, message: message, category: category)
    }
    
    public static func logE(_ messages: [String?], joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
        guard let message = String.joined(from: messages, using: separator) else { return }
        PrettyLog.shared.log(.error, message: message, category: category)
    }
    
    public static func logE(_ error: Error?, category: LogCategory = .uncategorized) {
        guard let error = error else { return }
        PrettyLog.shared.log(error: error, category: category)
    }
    
    public static func logE(_ exception: NSException?, category: LogCategory = .uncategorized) {
        guard let exception = exception else { return }
        PrettyLog.shared.log(exception: exception, category: category)
    }

    
}

// MARK: - Private Logger Implementation

private final class PrettyLog {

    static let shared = PrettyLog()

    func log(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    func log(error: Error, category: LogCategory) {
        print("\(prefix(level: .error, category: category)) \(error.localizedDescription) (\(error)")
    }

    func log(exception: NSException, category: LogCategory) {
        print("\(prefix(level: .error, category: category)) \(exception): \(exception.description)")
    }

    private var currentTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date.now)
    }

    private func prefix(level: LogLevel, category: LogCategory) -> String {
        "\(currentTimestamp) \(category.fixedWidth) \(level.emoji)"
    }

}
