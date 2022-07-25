//
// 📄 LogCategory.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

/// The Log Category will show up as a title of each log statement.
///
/// Custom Log Categories can be defined as an extension on `LogCategory`:
///
///     extension LogCategory {
///
///         /// This custom category can be used like all the predefined ones: logV("Running Unit Tests ...", category: .test)
///         static var test: LogCategory { .custom("Test") }
///
///     }
///
/// - Attention: The name of the category will always be truncated to 20 characters in order to keep the visual design of the log statements consistent.
public enum LogCategory {

    case appState
    case debug
    case general
    case manager
    case service
    case storage
    case uncategorized
    case user
    case view

    case custom(_ name: String)

    // MARK: - Properties & Methods

    /// The name of the LogCategory with a fixed width String and right aligned to make it look nice in the Console Output.
    var fixedWidth: String { name.truncateOrPad(to: 20) }

    // MARK: Private Helpers

    /// The name of the LogCategory that will be used in log statements.
    private var name: String {
        switch self {
        case .appState: return "App State"
        case .debug: return "Debug"
        case .general: return "General"
        case .manager: return "Manager"
        case .service: return "Service"
        case .storage: return "Storage"
        case .uncategorized: return ""
        case .user: return "User Action"
        case .view: return "View"
        case let .custom(name): return name
        }
    }

}
