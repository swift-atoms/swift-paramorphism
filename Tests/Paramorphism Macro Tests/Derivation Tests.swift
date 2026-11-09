import SwiftParser
import SwiftSyntax
import Testing

@testable import Paramorphism_Macro_Core

enum `Derivation Tests` {}

extension `Derivation Tests` {
    @Suite
    struct `Paramorphism access` {
        func access(of modifier: String) throws -> String {
            let source = Parser.parse(source: "\(modifier) indirect enum Tree { case leaf }")
            let declaration = try #require(source.statements.first?.item.as(EnumDeclSyntax.self))
            let function = try #require(Derivation.expansion(of: declaration).first?.as(FunctionDeclSyntax.self))
            return function.modifiers.map(\.name.text).joined(separator: " ")
        }

        @Test(arguments: [
            ("public", "public"),
            ("package", "package"),
            ("", ""),
            ("internal", ""),
            ("fileprivate", "fileprivate"),
            ("private", "fileprivate"),
        ])
        func `the generated method carries the enum's access level`(modifier: String, expected: String) throws {
            #expect(try access(of: modifier) == expected)
        }
    }
}
