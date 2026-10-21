//
// 📄 OSLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import OSLog
import PrettyLog

nonisolated struct OSLogTarget: LogTarget {

    let bundleID: String
    let canLogSensitiveInformation: Bool
    let levelFilter: LogLevelFilter<AppLogLevel>

    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        let logger = Logger(subsystem: bundleID, category: category.name)
        let formattedMessage = "\(level.emoji) \(message)"
        // No `default`: a new case in AppLogLevel stops the build here until it has a mapping.
        switch level {
        case .debug: logger.debug("\(formattedMessage, privacy: .public)")
        case .verbose: logger.notice("\(formattedMessage, privacy: .public)")
        case .info: logger.info("\(formattedMessage, privacy: .public)")
        case .warning: logger.warning("\(formattedMessage, privacy: .public)")
        case .error: logger.fault("\(formattedMessage, privacy: .public)")
        case .keyEvent: logger.notice("\(formattedMessage, privacy: .public)")
        }
    }

}
