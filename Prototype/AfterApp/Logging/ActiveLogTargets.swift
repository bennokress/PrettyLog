//
// 📄 ActiveLogTargets.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

nonisolated enum ActiveLogTargets {

    nonisolated(unsafe) private(set) static var current: [any LogTarget<AppLogLevel>] = []

    static func set(_ newTargets: [any LogTarget<AppLogLevel>]) {
        current = newTargets
    }

    static func add(_ target: any LogTarget<AppLogLevel>) {
        current.append(target)
    }

}

nonisolated extension Array where Element == any LogTarget<AppLogLevel> {

    static func forEnvironment(bundleID: String, isDevelopment: Bool, isTestFlight: Bool) -> [any LogTarget<AppLogLevel>] {
        if isDevelopment {
            [Console()]
        } else if isTestFlight {
            [OSLogTarget(bundleID: bundleID, canLogSensitiveInformation: true, levelFilter: .from(.verbose))]
        } else {
            [OSLogTarget(bundleID: bundleID, canLogSensitiveInformation: false, levelFilter: .from(.info))]
        }
    }

}
