//
// 📄 LogCategoryTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logCategoryName() {
    #expect(LogCategory("Test Category").name == "Test Category")
}

@Test
func uncategorizedHasAnEmptyName() {
    #expect(LogCategory.uncategorized.name == "")
}

@Test
func logCategoriesWithTheSameNameAreEqual() {
    #expect(LogCategory("Storage") == LogCategory("Storage"))
    #expect(LogCategory("Storage") != LogCategory("View"))
    #expect(Set([LogCategory("Storage"), LogCategory("Storage")]).count == 1)
}

@Test
func logCategoryTruncateOrPad() {
    let category = LogCategory.debug

    // Test padding (name is shorter than desired length)
    let padded = category.truncatedOrPadded(to: 10)
    #expect(padded == "     Debug")
    #expect(padded.count == 10)

    // Test exact length
    let exact = category.truncatedOrPadded(to: 5)
    #expect(exact == "Debug")
    #expect(exact.count == 5)

    // Test truncation
    let truncated = category.truncatedOrPadded(to: 3)
    #expect(truncated == "De…")
    #expect(truncated.count == 3)
}

@Test
func logCategoryUncategorizedPadding() {
    let uncategorized = LogCategory.uncategorized
    let padded = uncategorized.truncatedOrPadded(to: 10)
    #expect(padded == "          ") // 10 spaces
    #expect(padded.count == 10)
}

@Test
func logCategoryLongCustomName() {
    let longCategory = LogCategory("This is a very long category name")
    let truncated = longCategory.truncatedOrPadded(to: 10)
    #expect(truncated == "This is a…")
    #expect(truncated.count == 10)
}

@Test
func logCategoryIsSendable() {
    // Compiles only while LogCategory conforms to Sendable, which consumers need to store categories in a `static let` or pass them into a `Task`.
    let categories: [any Sendable] = [LogCategory.user, LogCategory("To Do")]
    #expect(categories.count == 2)
}
