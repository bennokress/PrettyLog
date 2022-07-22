//
// 📄 LogCategory.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

public enum LogCategory {

    case appState
    case debug
    case general
    case manager
    case service
    case storage
    case user
    case view

    case custom(_ name: String)

    // MARK: - Properties & Methods

    internal var name: String {
        switch self {
        case .appState: return "App State"
        case .debug: return "Debug"
        case .general: return "General"
        case .manager: return "Manager"
        case .service: return "Service"
        case .storage: return "Storage"
        case .user: return "User Action"
        case .view: return "View"
        case let .custom(name): return name
        }
    }

    /// The Category with a fixed width String and right aligned to make it look nice in the Console Output.
    internal var fixedWidth: String { name.truncateOrPad(to: 20) }

}
