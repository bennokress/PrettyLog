//
// 📄 LogCategory.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

/// The Log Category can be used as a title of each log statement.
///
/// PrettyLog ships no Log Categories apart from `.uncategorized`, which stands for a log statement without a category. Your app defines the ones it needs as an extension on `LogCategory` and passes them to `PrettyLogProxy.log(_:sensitiveMessages:joinedBy:as:category:to:)`.
///
///     nonisolated extension LogCategory {
///
///         static var storage: LogCategory { LogCategory("Storage") }
///         static var todo: LogCategory { LogCategory("To Do") }
///
///     }
///
/// Two categories are equal when their names are equal, so a target can compare a category with `==` or use it as a dictionary key.
///
/// - Attention: For the default `PrettyLog`s default Console Log the name of the category will always be truncated to 20 characters in order to keep the visual design of the log statements consistent.
public struct LogCategory: Sendable, Hashable {

    /// The name of the Log Category that can be used in log statements.
    public let name: String

    /// Creates a Log Category.
    /// - Parameter name: The name shown as the title of log statements in this category
    public init(_ name: String) {
        self.name = name
    }

    // MARK: - Properties & Methods

    /// The name of the Log Category as a fixed width String and right aligned to make it look nice in a console log statement.
    ///
    /// A longer name is cut and ends in "…", a shorter one is padded with spaces at the beginning.
    /// - Parameter fixedLength: The desired fixed length of the output. A length of 0 or less returns an empty String.
    public func truncatedOrPadded(to fixedLength: Int) -> String { name.truncateOrPad(to: fixedLength) }

}

public extension LogCategory {
    /// The category of a log statement without a category. Its name is empty, and it is the default of every `category:` parameter in `PrettyLogProxy`.
    static var uncategorized: LogCategory { LogCategory("") }
}
