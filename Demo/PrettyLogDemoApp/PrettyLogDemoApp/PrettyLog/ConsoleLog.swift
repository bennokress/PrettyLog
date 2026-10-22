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

    /// Created once instead of per log call, because logging happens often. A format style is a `Sendable` value type,
    /// so it can be shared without a lock. The time zone is fixed at first use.
    private static let timestampFormat = Date.VerbatimFormatStyle(
        format: "\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits).\(secondFraction: .fractional(3))",
        timeZone: .current,
        calendar: .current
    )

    // MARK: - LogTarget Implementation

    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    // MARK: - Private Methods

    private var currentTimestamp: String {
        Date.now.formatted(Self.timestampFormat)
    }

    private func prefix(level: AppLogLevel, category: LogCategory) -> String {
        "\(currentTimestamp) \(category.name.truncatedOrPadded(to: 20)) \(level.emoji)"
    }

}

// MARK: - Fixed Width

extension String {

    /// The String cut or padded to exactly the given length, so the categories of all log statements line up.
    /// A longer String ends in "…", a shorter one is padded with spaces at the beginning.
    func truncatedOrPadded(to length: Int) -> String {
        guard length > 0 else { return "" }
        guard count <= length else { return String(prefix(length - 1)) + "…" }
        return String(repeating: " ", count: length - count) + self
    }

}
