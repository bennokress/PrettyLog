//
// 📄 LogTarget.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Target is a destination for log statements and can be local or remote.
public protocol LogTarget {

    /// Creates the log statement with a consistent design and sends it to its destination.
    ///
    /// This method will only be called by `PrettyLog` if the `logPriorityRange` requirements are met.
    ///
    /// - Parameters:
    ///   - level: The log level can be used to visually distinguish between severities of the log statements and to filter what to log for this Log Target.
    ///   - message: The message is the main content of the log statement.
    ///   - category: The category is a title of the log statement.
    func createLog(_ level: LogLevel, message: String, category: LogCategory)

    /// The range of Log Levels that will be processed by this Log Target. This will default to every possible value if not specified otherwise.
    var logPriorityRange: ClosedRange<LogLevel>? { get }

}

public extension LogTarget {

    // If not specified otherwise a Log Target will log every statement sent to it.
    var logPriorityRange: ClosedRange<LogLevel>? { .allowAll }

}

extension LogTarget {

    /// Log the desired statement with the design defined in `createLog` if the Log Level allows it according to its `logPriorityRange`.
    func log(_ level: LogLevel, message: String, category: LogCategory) {
        guard logPriorityRange.contains(level) else { return }
        createLog(level, message: message, category: category)
    }

}
