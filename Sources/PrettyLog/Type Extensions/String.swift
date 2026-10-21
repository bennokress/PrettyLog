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

    /// Brings the String to exactly the desired length.
    ///
    /// A longer String is cut and ends in "…", which counts towards the desired length. A shorter String is padded at the beginning with the given character.
    /// - Parameters:
    ///   - desiredLength: The desired fixed length of the String. A length of 0 or less returns an empty String.
    ///   - character: The character used for padding. Defaults to a space.
    /// - Returns: The truncated or padded String.
    func truncateOrPad(to desiredLength: Int, using character: Character = " ") -> String {
        guard desiredLength > 0 else { return "" }
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
