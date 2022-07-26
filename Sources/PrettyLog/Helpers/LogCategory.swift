//
// 📄 LogCategory.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Category can be used as a title of each log statement.
///
/// Custom Log Categories can be defined as an extension on `LogCategory`:
///
///     extension LogCategory {
///
///         /// This custom category can be used like all the predefined ones: logV("The login method is not yet implemented", category: .todo)
///         static var todo: LogCategory { .custom("To Do") }
///
///     }
///
/// - Attention: For the default `PrettyLog`s default Console Log the name of the category will always be truncated to 20 characters in order to keep the visual design of the log statements consistent.
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

    /// The name of the Log Category as a fixed width String and right aligned to make it look nice in a console log statement.
    /// - Parameter fixedLength: The desired fixed length of the output.
    public func truncatedOrPadded(to fixedLength: Int) -> String { name.truncateOrPad(to: fixedLength) }

    /// The name of the LogCategory that can be used in log statements.
    public var name: String {
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
