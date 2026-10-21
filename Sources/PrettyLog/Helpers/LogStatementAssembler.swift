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

    func assembleLogStatement(includingSensitiveData shouldContainSensitiveData: Bool) -> String? {
        String.combining(shouldContainSensitiveData ? [message, sensitiveMessage] : [message], using: separator)
    }

}
