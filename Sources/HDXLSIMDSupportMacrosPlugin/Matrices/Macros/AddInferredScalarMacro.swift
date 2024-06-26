import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddInferredScalarMacro { }

extension AddInferredScalarMacro: MemberMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let matrixStructDecl = declaration.as(StructDeclSyntax.self),
      let matrixTypeDescriptor = SIMDMatrixTypeDescriptor.extracting(
        fromSwiftTypeName: "\(matrixStructDecl.name.trimmed)"
      )
    else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    let scalarTypeName = matrixTypeDescriptor.scalar.swiftTypeName
    
    return [
      """
      /// `\(raw: typeName)` has (inferred) `Scalar` `\(raw: scalarTypeName)"
      public typealias Scalar = \(raw: scalarTypeName)
      """,
    ]
  }
  
}
