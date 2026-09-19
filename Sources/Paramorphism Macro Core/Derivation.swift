public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)func paramorphism<Result>(
                _ algebra: (Base<Product<Self, Result>>) -> Result
            ) -> Result {
                algebra(project().map { child in
                    Product(child, child.paramorphism(algebra))
                })
            }
            """]
    }
}
