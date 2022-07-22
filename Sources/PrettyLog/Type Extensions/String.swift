//
// 📄 String.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation

extension String {

    static func joined(from array: [String?], using separator: String) -> String? {
        let stringComponents = array.compactMap { $0 }
        guard !stringComponents.isEmpty else { return nil }
        return stringComponents.joined(separator: separator)
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

}
