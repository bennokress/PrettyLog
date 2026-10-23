//
// 📄 StringExtensionTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func stringCombiningOptionalArray() {
    let result = String.combining(["Hello", nil, "World"], using: " ")
    #expect(result == "Hello World")
}

@Test
func stringCombiningAllNil() {
    let result = String.combining([nil, nil, nil], using: " ")
    #expect(result == nil)
}

@Test
func stringCombiningEmptyArray() {
    let result = String.combining([], using: " ")
    #expect(result == nil)
}

@Test
func stringCombiningEmptyStrings() {
    let result = String.combining(["", "", ""], using: " ")
    #expect(result == nil)
}

@Test
func stringCombiningSkipsEmptyStringsBetweenValues() {
    let result = String.combining(["A", "", "B"], using: " ")
    #expect(result == "A B")
}

@Test
func stringCombiningMixedEmptyAndNil() {
    let result = String.combining(["", nil, "Valid"], using: " ")
    #expect(result == "Valid")
}

@Test
func stringProtocolReplacedWithNilIfEmpty() {
    #expect("Hello".replacedWithNilIfEmpty == "Hello")
    #expect("".replacedWithNilIfEmpty == nil)

    let substring = "Hello World".prefix(0)
    #expect(substring.replacedWithNilIfEmpty == nil)
}

@Test
func collectionRemovingEmptyElements() {
    let strings: [String?] = ["Hello", nil, "", "World", nil]
    let result = strings.removingEmptyElements
    #expect(result == ["Hello", "World"])
}

@Test
func collectionRemovingEmptyElementsAllEmpty() {
    let strings: [String?] = [nil, "", nil, ""]
    let result = strings.removingEmptyElements
    #expect(result.isEmpty)
}

@Test
func collectionRemovingEmptyElementsNoneEmpty() {
    let strings: [String?] = ["Hello", "World", "Test"]
    let result = strings.removingEmptyElements
    #expect(result == ["Hello", "World", "Test"])
}
