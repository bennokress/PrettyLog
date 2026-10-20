//
// 📄 BuildConfiguration.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// `true` in builds with the `DEBUG` compilation condition, which Xcode sets for the Debug configuration only.
var isDebugApp: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}
