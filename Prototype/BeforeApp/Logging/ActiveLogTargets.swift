//
// 📄 ActiveLogTargets.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLogStruct

nonisolated enum ActiveLogTargets {

    nonisolated(unsafe) private(set) static var current: [any LogTarget] = []

    static func set(_ newTargets: [any LogTarget]) {
        current = newTargets
    }

    static func add(_ target: any LogTarget) {
        current.append(target)
    }

}

nonisolated extension Array where Element == any LogTarget {

    static func forEnvironment(bundleID: String, isDevelopment: Bool, isTestFlight: Bool) -> [any LogTarget] {
        if isDevelopment {
            [Console()]
        } else if isTestFlight {
            [OSLogTarget(bundleID: bundleID, canLogSensitiveInformation: true, levelFilter: .fromPriority(of: .verbose))]
        } else {
            [OSLogTarget(bundleID: bundleID, canLogSensitiveInformation: false, levelFilter: .fromPriority(of: .info))]
        }
    }

}
