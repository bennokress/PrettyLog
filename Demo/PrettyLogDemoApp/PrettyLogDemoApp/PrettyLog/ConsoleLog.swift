//
// 📄 ConsoleLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

/// A log target that prints every log statement to the Xcode console.
/// Sensitive messages are only included in debug builds, so a release build never prints them to stdout.
struct ConsoleLog: LogTarget {

    // MARK: - Properties

    var canLogSensitiveInformation: Bool { isDebugApp }

    // MARK: - LogTarget Implementation

    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    // MARK: - Private Methods

    private var currentTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }

    private func prefix(level: LogLevel, category: LogCategory) -> String {
        "\(currentTimestamp) \(category.truncatedOrPadded(to: 20)) \(level.emoji)"
    }

}
