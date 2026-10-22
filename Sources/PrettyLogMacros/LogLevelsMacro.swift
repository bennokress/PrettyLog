//
// 📄 LogLevelsMacro.swift
// 👨🏼‍💻 Author: Benno Kress
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// `@LogLevels` turns an enum with `Int` as its raw type into a `LogLevel`: it generates `emoji` from the `@Emoji` of every case, `allCases`, the marker only this macro writes, and the conformance.
///
/// The macro leaves the priorities to the raw values on purpose: the compiler already rejects two cases with the same raw value, which is safer than a check of our own.
public struct LogLevelsMacro: MemberMacro, ExtensionMacro {

    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: node, message: LogLevelsDiagnostic.notAnEnum))
            return []
        }
        guard hasIntRawType(enumDeclaration) else {
            context.diagnose(Diagnostic(node: enumDeclaration.inheritanceClause.map(Syntax.init) ?? Syntax(enumDeclaration.name), message: LogLevelsDiagnostic.rawTypeIsNotInt))
            return []
        }
        guard let levels = levels(of: enumDeclaration, in: context) else { return [] }

        // The members have to be as visible as the enum, otherwise a public enum would not satisfy the public protocol.
        let accessModifier = accessModifier(of: enumDeclaration).map { "\($0) " } ?? ""
        let emojiBranches = levels.map { "case .\($0.name): \(StringLiteralExprSyntax(content: $0.emoji))" }.joined(separator: "\n")
        let allCases = levels.map { ".\($0.name)" }.joined(separator: ", ")
        return [
            "\(raw: accessModifier)var emoji: String {\nswitch self {\n\(raw: emojiBranches)\n}\n}",
            "\(raw: accessModifier)static var allCases: [Self] { [\(raw: allCases)] }",
            "\(raw: accessModifier)static var _$logLevelsMacro: PrettyLog.LogLevelsMacroMarker { ._$generated() }"
        ]
    }

    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        // The member expansion reports what is wrong. A conformance on top would only add follow-up errors about missing requirements.
        guard !protocols.isEmpty, let enumDeclaration = declaration.as(EnumDeclSyntax.self), hasIntRawType(enumDeclaration) else { return [] }
        return try [ExtensionDeclSyntax("extension \(type.trimmed): PrettyLog.LogLevel { }")]
    }

}

private extension LogLevelsMacro {

    struct Level {
        let name: String
        let emoji: String
    }

    static func hasIntRawType(_ enumDeclaration: EnumDeclSyntax) -> Bool {
        let rawType = enumDeclaration.inheritanceClause?.inheritedTypes.first?.type.trimmedDescription
        return rawType == "Int" || rawType == "Swift.Int"
    }

    static func accessModifier(of enumDeclaration: EnumDeclSyntax) -> String? {
        enumDeclaration.modifiers.map(\.name.text).first { $0 == "public" || $0 == "package" }
    }

    /// Reads the level of every case. Returns `nil` after reporting every case that is not a valid level, so that the app developer sees all of them at once.
    static func levels(of enumDeclaration: EnumDeclSyntax, in context: some MacroExpansionContext) -> [Level]? {
        var levels: [Level] = []
        var hasInvalidCase = false
        for member in enumDeclaration.memberBlock.members {
            guard let caseDeclaration = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
            guard let emoji = emoji(of: caseDeclaration, in: context) else {
                hasInvalidCase = true
                continue
            }
            guard caseDeclaration.elements.count == 1, let element = caseDeclaration.elements.first else {
                context.diagnose(Diagnostic(node: caseDeclaration.elements, message: LogLevelsDiagnostic.severalLevelsInOneCase))
                hasInvalidCase = true
                continue
            }
            levels.append(Level(name: element.name.text, emoji: emoji))
        }
        return hasInvalidCase ? nil : levels
    }

    static func emoji(of caseDeclaration: EnumCaseDeclSyntax, in context: some MacroExpansionContext) -> String? {
        guard let emojiAttribute = emojiAttribute(of: caseDeclaration) else {
            context.diagnose(Diagnostic(node: caseDeclaration.caseKeyword, message: LogLevelsDiagnostic.caseWithoutEmoji))
            return nil
        }
        guard let emoji = emojiAttribute.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.as(StringLiteralExprSyntax.self)?.representedLiteralValue else {
            context.diagnose(Diagnostic(node: emojiAttribute, message: LogLevelsDiagnostic.emojiIsNotAStringLiteral))
            return nil
        }
        guard !emoji.isEmpty else {
            context.diagnose(Diagnostic(node: emojiAttribute, message: LogLevelsDiagnostic.emojiIsEmpty))
            return nil
        }
        return emoji
    }

    static func emojiAttribute(of caseDeclaration: EnumCaseDeclSyntax) -> AttributeSyntax? {
        caseDeclaration.attributes.compactMap { $0.as(AttributeSyntax.self) }.first {
            ["Emoji", "PrettyLog.Emoji"].contains($0.attributeName.trimmedDescription)
        }
    }

}
