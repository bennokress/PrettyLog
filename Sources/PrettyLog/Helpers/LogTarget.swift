//
// 📄 LogTarget.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Target is a destination for log statements and can be local or remote.
public protocol LogTarget {

    /// Whether this target receives the sensitive messages of a log statement.
    ///
    /// Sensitive messages let you log extra detail where it helps, for example in debug builds,
    /// and leave it out elsewhere, for example in production or on a remote backend.
    /// If `true`, the message passed to `createLog` contains the sensitive messages after the regular ones.
    /// If `false`, they are left out before `createLog` is called.
    var canLogSensitiveInformation: Bool { get }

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
    ///
    /// - Important: The lower bound of the range must not have a higher priority than the upper bound.
    ///   A reversed range like `.warning ... .debug` stops the app at runtime the first time this target logs, in debug and release builds alike.
    ///   The helpers `.allowAll`, `.allowNone`, `.allowFrom(min:)` and `.allowUntil(max:)` always produce a valid range.
    var logPriorityRange: ClosedRange<LogLevel>? { get }

}

public extension LogTarget {

    // If not specified otherwise a Log Target will log every statement sent to it.
    var logPriorityRange: ClosedRange<LogLevel>? { .allowAll }

}

extension LogTarget {

    /// Log the desired statement with the design defined in `createLog` if the Log Level allows it according to its `logPriorityRange`.
    func log(_ level: LogLevel, messages: LogStatementAssembler, category: LogCategory) {
        guard logPriorityRange.contains(level) else { return }
        guard let logStatement = messages.assembleLogStatement(includingSensitiveData: canLogSensitiveInformation) else { return }
        createLog(level, message: logStatement, category: category)
    }

}
