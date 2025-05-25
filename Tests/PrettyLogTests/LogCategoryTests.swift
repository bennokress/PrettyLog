//
// 📄 LogCategoryTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logCategoryNames() {
    #expect(LogCategory.appState.name == "App State")
    #expect(LogCategory.debug.name == "Debug")
    #expect(LogCategory.general.name == "General")
    #expect(LogCategory.manager.name == "Manager")
    #expect(LogCategory.service.name == "Service")
    #expect(LogCategory.storage.name == "Storage")
    #expect(LogCategory.uncategorized.name == "")
    #expect(LogCategory.user.name == "User Action")
    #expect(LogCategory.view.name == "View")
}

@Test
func customLogCategory() {
    let customCategory = LogCategory.custom("Test Category")
    #expect(customCategory.name == "Test Category")
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
    let longCategory = LogCategory.custom("This is a very long category name")
    let truncated = longCategory.truncatedOrPadded(to: 10)
    #expect(truncated == "This is a…")
    #expect(truncated.count == 10)
}
