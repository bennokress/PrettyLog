//
// 📄 Console.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

nonisolated struct Console: LogTarget {

    let canLogSensitiveInformation = true

    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        print("\(category.name) \(level.emoji) \(message)")
    }

}
