//
// 📄 LogTarget.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Target is a destination for log statements and can be local or remote.
///
/// A target names the level type of your app in `emit(_:message:category:)`, and Swift infers `Level` from it. An app keeps its targets in a list of type `[any LogTarget<AppLogLevel>]`.
/// A target that only needs what every level has, like the emoji and the priority, can stay generic and work with the levels of any app:
///
///     struct ConsoleLog<Level: LogLevel>: LogTarget {
///
///         let canLogSensitiveInformation = true
///
///         func emit(_ level: Level, message: String, category: LogCategory) {
///             print("\(level.emoji) \(category.name) \(message)")
///         }
///
///     }
public protocol LogTarget<Level> {

    /// The Log Level type of the app this target logs for.
    associatedtype Level: LogLevel

    /// Whether this target receives the sensitive messages of a log statement.
    ///
    /// Sensitive messages let you log extra detail where it helps, for example in debug builds,
    /// and leave it out elsewhere, for example in production or on a remote backend.
    /// If `true`, the message passed to `emit(_:message:category:)` contains the sensitive messages after the regular ones.
    /// If `false`, they are left out before `emit(_:message:category:)` is called.
    var canLogSensitiveInformation: Bool { get }

    /// Gives the log statement its form and passes it on to the destination of this target, for example the console or a backend.
    ///
    /// This method will only be called by `PrettyLog` if the `levelFilter` accepts the level.
    ///
    /// - Parameters:
    ///   - level: The log level can be used to visually distinguish between severities of the log statements and to filter what to log for this Log Target.
    ///   - message: The message is the main content of the log statement.
    ///   - category: The category is a title of the log statement.
    func emit(_ level: Level, message: String, category: LogCategory)

    /// The Log Levels that will be processed by this Log Target. This will default to `.all` if not specified otherwise.
    var levelFilter: LogLevelPriorityFilter<Level> { get }

}

public extension LogTarget {

    // If not specified otherwise a Log Target will log every statement sent to it.
    var levelFilter: LogLevelPriorityFilter<Level> { .all }

}

extension LogTarget {

    /// Assembles the statement and passes it to `emit(_:message:category:)`, if the `levelFilter` accepts the level.
    ///
    /// The name differs from `emit(_:message:category:)` on purpose: only this method checks the filter and leaves out sensitive messages, so the two must not be mistaken for each other.
    func deliver(_ level: Level, statement: LogStatementAssembler, category: LogCategory) {
        guard levelFilter.contains(level) else { return }
        guard let logStatement = statement.assembleLogStatement(includingSensitiveData: canLogSensitiveInformation) else { return }
        emit(level, message: logStatement, category: category)
    }

}
