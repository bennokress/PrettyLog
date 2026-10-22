//
// 📄 LogLevelsMacro.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#73): rough, no polish. Reads the `@Emoji` attribute of every case.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PrettyLogMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [LogLevelsMacro.self, CaseMarkerMacro.self]
}

/// `@Emoji` generates nothing itself; `@LogLevels` reads them.
public struct CaseMarkerMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
}

struct LevelCase {
    let name: String
    let emoji: String
    let attribute: AttributeSyntax
}

struct Message: DiagnosticMessage {
    let message: String
    var diagnosticID: MessageID { MessageID(domain: "PrettyLog", id: message) }
    var severity: DiagnosticSeverity { .error }
}

public struct LogLevelsMacro: MemberMacro, ExtensionMacro {

    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: node, message: Message(message: "@LogLevels can only be attached to an enum")))
            return []
        }
        // The Int raw value is the priority, so the compiler rejects two levels with the same one.
        let rawType = enumDecl.inheritanceClause?.inheritedTypes.first?.type.trimmedDescription
        guard rawType == "Int" || rawType == "Swift.Int" else {
            context.diagnose(Diagnostic(node: enumDecl.name, message: Message(message: "A @LogLevels enum needs Int as its raw type, the raw value is the priority: enum \(enumDecl.name.text): Int")))
            return []
        }
        let cases = levelCases(of: declaration, in: context)
        guard !cases.isEmpty else { return [] }

        let emojiBranches = cases.map { "case .\($0.name): \($0.emoji.debugDescription)" }.joined(separator: "\n")
        let allCases = cases.map { ".\($0.name)" }.joined(separator: ", ")
        return [
            "var emoji: String { switch self { \(raw: emojiBranches) } }",
            "static var allCases: [Self] { [\(raw: allCases)] }",
            "static var _$logLevelsMacro: PrettyLog.LogLevelsMacroMarker { ._$generated() }",
        ]
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
                return name == "Emoji"
            }
            guard let attribute, let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else {
                context.diagnose(Diagnostic(node: caseDecl, message: Message(message: "Every case needs an emoji: @Emoji(\"🟤\") case …")))
                continue
            }
            let values = Array(arguments)
            guard let emoji = values.first?.expression.as(StringLiteralExprSyntax.self)?.representedLiteralValue else {
                context.diagnose(Diagnostic(node: attribute, message: Message(message: "The emoji has to be a string literal")))
                continue
            }
            for element in caseDecl.elements {
                result.append(LevelCase(name: element.name.text, emoji: emoji, attribute: attribute))
            }
        }
        return result
    }

}
