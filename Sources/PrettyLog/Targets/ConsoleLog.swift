//
// 📄 ConsoleLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Default Console Log combines all the elements of a log statement into a visually consistent design printed to the Xcode console. It uses the default `logPriorityRange` that allows all Log Levels.
public struct ConsoleLog: LogTarget {

    public var canLogSensitiveInformation = true

    public init() { }

    public func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        print(String.combining(prefix(level: level, category: category), message, using: " "))
    }

    // MARK: Private Helpers

    private var currentTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }

    private func prefix(level: LogLevel, category: LogCategory) -> String {
        String.combining(currentTimestamp, category.truncatedOrPadded(to: 20), level.emoji, using: " ")
    }

}
