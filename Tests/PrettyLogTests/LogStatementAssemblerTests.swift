//
// 📄 LogStatementAssemblerTests.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import Testing

@testable import PrettyLog

@Test
func logStatementAssemblerBasicInit() {
    let assembler = LogStatementAssembler(messages: ["Hello", "World"], separator: " - ")
    let result = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(result == "Hello - World")
}

@Test
func logStatementAssemblerWithSensitiveData() {
    let assembler = LogStatementAssembler(
        messages: ["Public message"],
        sensitiveMessages: ["Secret data"],
        separator: " | "
    )

    let withSensitive = assembler.assembleLogStatement(includingSensitiveData: true)
    #expect(withSensitive == "Public message | Secret data")

    let withoutSensitive = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(withoutSensitive == "Public message")
}

@Test
func logStatementAssemblerSingleMessageInit() {
    let assembler = LogStatementAssembler(message: "Single message")
    let result = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(result == "Single message")
}

@Test
func logStatementAssemblerMessageWithSensitiveInit() {
    let assembler = LogStatementAssembler(
        message: "Public",
        sensitiveMessage: "Private",
        separator: " :: "
    )

    let withSensitive = assembler.assembleLogStatement(includingSensitiveData: true)
    #expect(withSensitive == "Public :: Private")

    let withoutSensitive = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(withoutSensitive == "Public")
}

@Test
func logStatementAssemblerEmptyMessages() {
    let assembler = LogStatementAssembler(messages: [], sensitiveMessages: [])
    let result = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(result == nil)
}

@Test
func logStatementAssemblerNilMessages() {
    let assembler = LogStatementAssembler(messages: [nil, nil], sensitiveMessages: [nil])
    let result = assembler.assembleLogStatement(includingSensitiveData: true)
    #expect(result == nil)
}

@Test
func logStatementAssemblerMixedNilMessages() {
    let assembler = LogStatementAssembler(
        messages: ["Valid", nil, "Message"],
        sensitiveMessages: [nil, "Secret"],
        separator: " - "
    )

    let withSensitive = assembler.assembleLogStatement(includingSensitiveData: true)
    #expect(withSensitive == "Valid - Message - Secret")

    let withoutSensitive = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(withoutSensitive == "Valid - Message")
}

@Test
func logStatementAssemblerOnlySensitiveData() {
    let assembler = LogStatementAssembler(
        messages: [],
        sensitiveMessages: ["Only sensitive"],
        separator: " - "
    )

    let withSensitive = assembler.assembleLogStatement(includingSensitiveData: true)
    #expect(withSensitive == "Only sensitive")

    let withoutSensitive = assembler.assembleLogStatement(includingSensitiveData: false)
    #expect(withoutSensitive == nil)
}
