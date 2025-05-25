//
// 📄 StringExtensionTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func stringCombiningVariadic() {
    let result = String.combining("Hello", "World", using: " ")
    #expect(result == "Hello World")
}

@Test
func stringCombiningVariadicOptional() {
    let result = String.combining("Hello", nil, "World", using: " ")
    #expect(result == "Hello World")
}

@Test
func stringCombiningArray() {
    let result = String.combining(["Hello", "World"], using: " ")
    #expect(result == "Hello World")
}

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
    #expect(result == "")
}

@Test
func stringCombiningEmptyStrings() {
    let result = String.combining(["", "", ""], using: " ")
    #expect(result == "  ")
}

@Test
func stringCombiningMixedEmptyAndNil() {
    let result = String.combining(["", nil, "Valid"], using: " ")
    #expect(result == "Valid")
}

@Test
func stringTruncateOrPadExactLength() {
    let text = "Hello"
    let result = text.truncateOrPad(to: 5)
    #expect(result == "Hello")
    #expect(result.count == 5)
}

@Test
func stringTruncateOrPadShorter() {
    let text = "Hi"
    let result = text.truncateOrPad(to: 5)
    #expect(result == "   Hi")
    #expect(result.count == 5)
}

@Test
func stringTruncateOrPadLonger() {
    let text = "This is a long string"
    let result = text.truncateOrPad(to: 10)
    #expect(result == "This is a…")
    #expect(result.count == 10)
}

@Test
func stringTruncateOrPadCustomCharacter() {
    let text = "Hi"
    let result = text.truncateOrPad(to: 5, using: "*")
    #expect(result == "***Hi")
    #expect(result.count == 5)
}

@Test
func stringTruncateOrPadVeryShort() {
    let text = "Hello World"
    let result = text.truncateOrPad(to: 1)
    #expect(result == "…")
    #expect(result.count == 1)
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
