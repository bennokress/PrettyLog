//
// 📄 OSLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import OSLog
import PrettyLogStruct

nonisolated struct OSLogTarget: LogTarget {

    let bundleID: String
    let canLogSensitiveInformation: Bool
    let levelFilter: LogLevelFilter

    func emit(_ level: LogLevel, message: String, category: LogCategory) {
        let logger = Logger(subsystem: bundleID, category: category.name)
        let formattedMessage = "\(level.emoji) \(message)"
        switch level {
        case .debug: logger.debug("\(formattedMessage, privacy: .public)")
        case .verbose: logger.notice("\(formattedMessage, privacy: .public)")
        case .info: logger.info("\(formattedMessage, privacy: .public)")
        case .warning: logger.warning("\(formattedMessage, privacy: .public)")
        case .error: logger.fault("\(formattedMessage, privacy: .public)")
        default: logger.notice("\(formattedMessage, privacy: .public)")
        }
    }

}
