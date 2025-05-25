//
// 📄 LogStatementAssembler.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation

struct LogStatementAssembler {

    let message: String?
    let sensitiveMessage: String?
    let separator: String

    init(messages: [String?] = [], sensitiveMessages: [String?] = [], separator: String = " - ") {
        self.message = String.combining(messages, using: separator)
        self.sensitiveMessage = String.combining(sensitiveMessages, using: separator)
        self.separator = separator
    }

    init(message: String, sensitiveMessages: [String?] = [], separator: String = " - ") {
        self.init(messages: [message], sensitiveMessages: sensitiveMessages, separator: separator)
    }

    init(messages: [String?] = [], sensitiveMessage: String, separator: String = " - ") {
        self.init(messages: messages, sensitiveMessages: [sensitiveMessage], separator: separator)
    }

    init(message: String, sensitiveMessage: String, separator: String = " - ") {
        self.init(messages: [message], sensitiveMessages: [sensitiveMessage], separator: separator)
    }

    func assembleLogStatement(includingSensitiveData shouldContainSensitiveData: Bool) -> String? {
        String.combining(shouldContainSensitiveData ? [message, sensitiveMessage] : [message], using: separator)
    }

}
