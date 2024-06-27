import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddInferredScalarMacro { }

extension AddInferredScalarMacro: MemberMacro, SIMDSupportMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let matrixStructDecl = try requiredStructDeclaration(
      node: node,
      declaration: declaration
    )
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    let scalar = try requiredScalar(
      node: node,
      typeName: typeName
    )

    let scalarTypeName = scalar.swiftTypeName
    
    return [
      """
      /// `\(raw: typeName)` has (inferred) `Scalar` `\(raw: scalarTypeName)"
      public typealias Scalar = \(raw: scalarTypeName)
      """,
    ]
  }
  
}
