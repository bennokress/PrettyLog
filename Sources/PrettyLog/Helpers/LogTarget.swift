//
// 📄 LogTarget.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71, #73): `Level` is a primary associated type, so an app writes `any LogTarget<AppLogLevel>`.

import Foundation

public protocol LogTarget<Level> {

    associatedtype Level: LogLevel

    var canLogSensitiveInformation: Bool { get }

    func emit(_ level: Level, message: String, category: LogCategory)

    var levelFilter: LogLevelPriorityFilter<Level> { get }

}

public extension LogTarget {

    var levelFilter: LogLevelPriorityFilter<Level> { .all }

}

extension LogTarget {

    func deliver(_ level: Level, statement: LogStatementAssembler, category: LogCategory) {
        guard levelFilter.contains(level) else { return }
        guard let logStatement = statement.assembleLogStatement(includingSensitiveData: canLogSensitiveInformation) else { return }
        emit(level, message: logStatement, category: category)
    }

}
