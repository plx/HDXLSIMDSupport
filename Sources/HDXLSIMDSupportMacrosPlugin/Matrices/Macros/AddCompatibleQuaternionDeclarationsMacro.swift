import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddMatrixCompatibleQuaternionDeclarationMacro { }

extension AddMatrixCompatibleQuaternionDeclarationMacro: MemberMacro, SIMDSupportMacro {
    
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
    
    let matrixScalar = try requiredScalar(
      node: node,
      typeName: typeName
    )
    
    return [
      """
      /// ``\(raw: typeName)`` has compatible-quaternion: ``\(raw: matrixScalar.quaternionStorageTypeName)``
      public typealias CompatibleQuaternion = \(raw: matrixScalar.quaternionStorageTypeName)
      """
    ]
  }
}
