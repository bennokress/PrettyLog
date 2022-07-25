//
// 📄 ConsoleLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

public struct ConsoleLog: LogTarget {

    /// The Console Log combines all the elements of a log statement into a visually consistent design printed to the Xcode console.
    public init() { }

    /// Create the log statement with a consistent design.
    /// - Parameters:
    ///   - level: The log level is responsible for the emoji displayed in the log statement.
    ///   - message: The message is printed to the right of the log level emoji.
    ///   - category: The category is printed to the left of the log level emoji.
    public func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        print(String.joined(with: " ", combining: prefix(level: level, category: category), message))
    }

    // MARK: Private Helpers

    private var currentTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date.now)
    }

    private func prefix(level: LogLevel, category: LogCategory) -> String {
        String.joined(with: " ", combining: currentTimestamp, category.truncatedOrPadded(to: 20), level.emoji)
    }

}
