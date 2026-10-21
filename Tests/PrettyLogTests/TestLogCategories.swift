//
// 📄 TestLogCategories.swift
// 👨🏼‍💻 Author: Benno Kress
//

import PrettyLog

/// PrettyLog ships no categories apart from `.uncategorized`, so the tests define the same set the README suggests, as an app would.
extension LogCategory {

    static var appState: LogCategory { LogCategory("App State") }
    static var debug: LogCategory { LogCategory("Debug") }
    static var general: LogCategory { LogCategory("General") }
    static var manager: LogCategory { LogCategory("Manager") }
    static var service: LogCategory { LogCategory("Service") }
    static var storage: LogCategory { LogCategory("Storage") }
    static var user: LogCategory { LogCategory("User Action") }
    static var view: LogCategory { LogCategory("View") }

}
