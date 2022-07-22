//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

// MARK: - Global aliases

/// Log strings in order with VERBOSE level
/// - Attention: No log will be created, if `messages` is empty or only contains `nil`.
public func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory, _ data: [String: Any]? = nil) {
    guard let message = String.joined(from: messages, using: separator) else { return }
    PrettyLog.shared.log(.verbose, message: message, category: category)
}

/// Log strings in order with DEBUG level
/// - Attention: No log will be created, if `messages` is empty or only contains `nil`.
public func logD(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory, _ data: [String: Any]? = nil) {
    guard let message = String.joined(from: messages, using: separator) else { return }
    PrettyLog.shared.log(.debug, message: message, category: category)
}

/// Log strings in order with INFO level
/// - Attention: No log will be created, if `messages` is empty or only contains `nil`.
public func logI(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory, _ data: [String: Any]? = nil) {
    guard let message = String.joined(from: messages, using: separator) else { return }
    PrettyLog.shared.log(.info, message: message, category: category)
}

/// Log strings in order with WARNING level
/// - Attention: No log will be created, if `messages` is empty or only contains `nil`.
public func logW(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory, _ data: [String: Any]? = nil) {
    guard let message = String.joined(from: messages, using: separator) else { return }
    PrettyLog.shared.log(.warning, message: message, category: category)
}

/// Log strings in order with ERROR level
/// - Attention: No log will be created, if `messages` is empty or only contains `nil`.
public func logE(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory, _ data: [String: Any]? = nil) {
    guard let message = String.joined(from: messages, using: separator) else { return }
    PrettyLog.shared.log(.error, message: message, category: category)
}

/// Log with ERROR level
/// - Attention: No log will be created, if `error` is `nil`.
public func logE(_ error: Error?, category: LogCategory) {
    guard let error = error else { return }
    PrettyLog.shared.log(error: error, category: category)
}

/// Log with ERROR level
/// - Attention: No log will be created, if `exception` is `nil`.
public func logE(_ exception: NSException?, category: LogCategory) {
    guard let exception = exception else { return }
    PrettyLog.shared.log(exception: exception, category: category)
}

// MARK: - Private Logger Implementation

private final class PrettyLog {

    static let shared = PrettyLog()

    func log(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    func log(error: Error, category: LogCategory) {
        print("\(prefix(level: .error, category: category)) \(error)")
        print(Thread.callStackSymbols.description)
    }

    func log(exception: NSException, category: LogCategory) {
        print("\(prefix(level: .error, category: category)) \(exception)")
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
