//
// 📄 Categories.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): the same in BeforeApp and AfterApp.

import PrettyLogStruct

nonisolated extension LogCategory {

    static var general: LogCategory { LogCategory("General") }
    static var service: LogCategory { LogCategory("Service") }
    static var storage: LogCategory { LogCategory("Storage") }

}
