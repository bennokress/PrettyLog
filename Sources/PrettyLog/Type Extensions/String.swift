//
// 📄 String.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

extension String {

    /// Joins all the given Strings with the given separator.
    /// - Parameters:
    ///   - strings: The Strings to join together
    ///   - separator: The separator to use in between the given Strings
    /// - Returns: The String that results from combining the given Strings.
    static func combining(_ strings: String..., using separator: String = "") -> String {
        String.combining(strings, using: separator)
    }

    /// Joins all the given Strings with the given separator.
    /// - Parameters:
    ///   - strings: The Strings to join together
    ///   - separator: The separator to use in between the given Strings
    /// - Returns: The String that results from combining the given Strings.
    static func combining(_ strings: String?..., using separator: String = "") -> String? {
        String.combining(strings, using: separator)
    }

    /// Joins all the given Strings with the given separator.
    /// - Parameters:
    ///   - strings: The Strings to join together
    ///   - separator: The separator to use in between the given Strings
    /// - Returns: The String that results from combining the given Strings.
    static func combining(_ strings: [String], using separator: String = "") -> String {
        strings.joined(separator: separator)
    }

    /// Joins all the given Strings with the given separator.
    /// - Parameters:
    ///   - strings: The Strings to join together
    ///   - separator: The separator to use in between the given Strings
    /// - Returns: The String that results from combining the given Strings.
    static func combining(_ strings: [String?], using separator: String = "") -> String? {
        strings.removingEmptyElements.joined(separator: separator).replacedWithNilIfEmpty
    }

    /// Removes all characters from the String exceeding the desired length and pads the String from  the beginning using spaces, if the String is shorter than the desired length.
    /// - Parameter desiredLength: The desired fixed length of the String.
    /// - Returns: The truncated or padded String.
    func truncateOrPad(to desiredLength: Int, using character: Character = " ") -> String {
        guard count != desiredLength else { return self }
        var editedString = self
        if count > desiredLength {
            let surplusCharacterCount = count - desiredLength + 1 // Adding 1 more to fit "…" in later
            editedString = String(dropLast(surplusCharacterCount))
            editedString.append("…")
        } else {
            let padding = String(repeating: character, count: desiredLength - count)
            editedString = padding + self
        }
        return editedString
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
