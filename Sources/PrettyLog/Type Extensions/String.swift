//
// 📄 String.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

extension String {

    /// Joins the given Strings with the given separator, skipping every `nil` and empty element.
    /// - Parameters:
    ///   - strings: The Strings to join together
    ///   - separator: The separator to use in between the given Strings
    /// - Returns: The joined String, or `nil` if no non-empty element remains.
    static func combining(_ strings: [String?], using separator: String = "") -> String? {
        strings.removingEmptyElements.joined(separator: separator).replacedWithNilIfEmpty
    }

}

// MARK: String Protocol

extension StringProtocol {

    /// Returns `nil` if empty
    var replacedWithNilIfEmpty: String? {
        isEmpty ? nil : String(self)
    }

}

// MARK: Colloection of Elements of Type Optional String

extension Collection where Element == String? {

    /// Returns the collection with all empty or `nil` elements removed.
    var removingEmptyElements: [String] {
        compactMap { $0?.replacedWithNilIfEmpty }
    }

}
