//
// 📄 LogDesigner.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 25.07.22
//

import Foundation

/// The Log Designer combines all the elements of a log statement into a visually consistent design.
class LogDesigner {

    /// Create the log statement with a consistent design.
    /// - Parameters:
    ///   - level: The log level is responsible for the emoji displayed in the log statement.
    ///   - message: The message is printed to the right of the log level emoji.
    ///   - category: The message is printed to the left of the log level emoji.
    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    /// Create the log statement with a consistent design.
    /// - Parameters:
    ///   - error: The error description is printed to the right of the log level emoji.
    ///   - category: The message is printed to the left of the log level emoji.
    func createLog(for error: Error, category: LogCategory) {
        print("\(prefix(level: .error, category: category)) \(error.localizedDescription) (\(error))")
    }

    /// Create the log statement with a consistent design.
    /// - Parameters:
    ///   - exception: The exception description is printed to the right of the log level emoji.
    ///   - category: The message is printed to the left of the log level emoji.
    func createLog(for exception: NSException, category: LogCategory) {
        print("\(prefix(level: .error, category: category)) \(exception.description)")
    }

    // MARK: Private Helpers

    private var currentTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date.now)
    }

    private func prefix(level: LogLevel, category: LogCategory) -> String {
        "\(currentTimestamp) \(category.fixedWidth) \(level.emoji)"
    }

}
