//
// 📄 SharedTargets.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): targets written once and used by apps with different level enums.
// A target that only needs the emoji is generic over any LogLevel. A target that maps levels
// (OSLog, a backend) needs a second protocol the app's enum conforms to.

import Foundation
import OSLog
import PrettyLog

public struct SharedConsole<Level: LogLevel>: LogTarget {

    public let canLogSensitiveInformation = true
    public let levelFilter: LogLevelFilter<Level>

    public init(levelFilter: LogLevelFilter<Level> = .all) {
        self.levelFilter = levelFilter
    }

    public func emit(_ level: Level, message: String, category: LogCategory) {
        print("\(category.name) \(level.emoji) \(message)")
    }

}

/// What an app's level enum adds so the shared OSLog target can map it.
public protocol OSLogMappable: LogLevel {
    var osLogType: OSLogType { get }
}

public struct SharedOSLog<Level: OSLogMappable>: LogTarget {

    public let subsystem: String
    public let canLogSensitiveInformation: Bool
    public let levelFilter: LogLevelFilter<Level>

    public init(subsystem: String, canLogSensitiveInformation: Bool, levelFilter: LogLevelFilter<Level>) {
        self.subsystem = subsystem
        self.canLogSensitiveInformation = canLogSensitiveInformation
        self.levelFilter = levelFilter
    }

    public func emit(_ level: Level, message: String, category: LogCategory) {
        Logger(subsystem: subsystem, category: category.name).log(level: level.osLogType, "\(level.emoji) \(message, privacy: .public)")
    }

}
