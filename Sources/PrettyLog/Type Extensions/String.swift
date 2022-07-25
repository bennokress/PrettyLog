//
// 📄 String.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

extension String {

    /// Joins all the given Strings with the given separator
    /// - Parameters:
    ///   - separator: The separator to use in between the given Strings.
    ///   - strings: The Strings to join together.
    /// - Returns: The joined String
    static func joined(with separator: String = "", combining strings: String?...) -> String {
        joined(from: strings, using: separator) ?? ""
    }

    /// Joins all the given Strings with the given separator
    /// - Parameters:
    ///   - array: The Strings to join together.
    ///   - separator: The separator to use in between the given Strings.
    /// - Returns: The joined String or `nil` if no Strings were given.
    static func joined(from array: [String?], using separator: String) -> String? {
        let stringComponents = array.compactMap { $0 }
        return stringComponents.joined(separator: separator).replacedWithNilIfEmpty
    }

    /// Removes all characters from the String exceeding the desired length and pads the String from  the beginning using spaces, if the String is shorter than the desired length.
    /// - Parameter desiredLength: The desired fixed length of the String.
    /// - Returns: The truncated or padded String.
    func truncateOrPad(to desiredLength: Int, using character: Character = " ") -> String {
        guard count != desiredLength else { return self }
        var editedString = self
        if count > desiredLength {
            let surplusCharacterCount = count - desiredLength - 1 // Subtracting 1 more to fit "…" in later
            editedString = String(dropLast(surplusCharacterCount))
            editedString.append("…")
        } else {
            let padding = String(repeating: character, count: desiredLength - count)
            editedString = padding + self
        }
        return editedString
    }

    /// Returns `nil` if the String is empty
    var replacedWithNilIfEmpty: String? {
        isEmpty ? nil : self
    }

}
