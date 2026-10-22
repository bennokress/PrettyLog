//
// 📄 LogLevelsMacro.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#73): rough, no polish. Reads the `@Emoji` or `@Level` attribute of every case.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PrettyLogMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [LogLevelsMacro.self, CaseMarkerMacro.self]
}

/// `@Emoji` and `@Level` generate nothing themselves; `@LogLevels` reads them.
public struct CaseMarkerMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
}

struct LevelCase {
    let name: String
    let emoji: String
    let priority: Int?
    let attribute: AttributeSyntax
}

struct Message: DiagnosticMessage {
    let message: String
    var diagnosticID: MessageID { MessageID(domain: "PrettyLog", id: message) }
    var severity: DiagnosticSeverity { .error }
}

public struct LogLevelsMacro: MemberMacro, ExtensionMacro {

    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard declaration.is(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: node, message: Message(message: "@LogLevels can only be attached to an enum")))
            return []
        }
        let cases = levelCases(of: declaration, in: context)
        guard !cases.isEmpty else { return [] }

        var members: [DeclSyntax] = []
        let emojiBranches = cases.map { "case .\($0.name): \($0.emoji.debugDescription)" }.joined(separator: "\n")
        members.append("var emoji: String { switch self { \(raw: emojiBranches) } }")

        // V3: the priority comes from `@Level`, so the macro has to check what the compiler checks for raw values.
        if cases.allSatisfy({ $0.priority != nil }) {
            var seen: [Int: String] = [:]
            for levelCase in cases {
                guard let priority = levelCase.priority else { continue }
                if let other = seen[priority] {
                    context.diagnose(Diagnostic(node: levelCase.attribute, message: Message(message: "Priority \(priority) is already used by '\(other)'; every level needs its own priority")))
                }
                seen[priority] = levelCase.name
            }
            let priorityBranches = cases.map { "case .\($0.name): \($0.priority!)" }.joined(separator: "\n")
            members.append("var priority: Int { switch self { \(raw: priorityBranches) } }")
        }

        let allCases = cases.map { ".\($0.name)" }.joined(separator: ", ")
        members.append("static var allCases: [Self] { [\(raw: allCases)] }")
        return members
    }

    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard !protocols.isEmpty else { return [] }
        return [try ExtensionDeclSyntax("extension \(type.trimmed): PrettyLog.LogLevel {}")]
    }

    private static func levelCases(of declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) -> [LevelCase] {
        var result: [LevelCase] = []
        for member in declaration.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
            let attribute = caseDecl.attributes.compactMap { $0.as(AttributeSyntax.self) }.first {
                let name = $0.attributeName.trimmedDescription
                return name == "Emoji" || name == "Level"
            }
            guard let attribute, let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else {
                context.diagnose(Diagnostic(node: caseDecl, message: Message(message: "Every case needs @Emoji(\"…\") or @Level(\"…\", priority: …)")))
                continue
            }
            let values = Array(arguments)
            guard let emoji = values.first?.expression.as(StringLiteralExprSyntax.self)?.representedLiteralValue else {
                context.diagnose(Diagnostic(node: attribute, message: Message(message: "The emoji has to be a string literal")))
                continue
            }
            var priority: Int?
            if values.count > 1 {
                let text = values[1].expression.trimmedDescription
                priority = Int(text) ?? Int(text.filter { $0 != "_" })
                if priority == nil {
                    context.diagnose(Diagnostic(node: values[1], message: Message(message: "The priority has to be an integer literal")))
                    continue
                }
            }
            for element in caseDecl.elements {
                result.append(LevelCase(name: element.name.text, emoji: emoji, priority: priority, attribute: attribute))
            }
        }
        return result
    }

}
