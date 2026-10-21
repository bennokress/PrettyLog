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
func logCategoryIsSendable() {
    // Compiles only while LogCategory conforms to Sendable, which consumers need to store categories in a `static let` or pass them into a `Task`.
    let categories: [any Sendable] = [LogCategory.user, LogCategory("To Do")]
    #expect(categories.count == 2)
}
