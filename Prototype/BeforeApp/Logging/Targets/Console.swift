//
// 📄 Console.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLogStruct

nonisolated struct Console: LogTarget {

    let canLogSensitiveInformation = true

    func emit(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(category.name) \(level.emoji) \(message)")
    }

}
