import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddMatrixStorageMacro { }

extension AddMatrixStorageMacro: MemberMacro, SIMDSupportMacro {

  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let matrixStructDecl = try requiredStructDeclaration(
      node: node,
      declaration: declaration
    )

    return [
      """
      /// The backing concrete type for this matrix.
      @usableFromInline
      internal typealias Storage = \(matrixStructDecl.name.trimmed)Storage
      """,
      """
      /// The underlying storage for this matrix's backing concrete type.
      @usableFromInline
      internal var storage: Storage
      """,
      """
      /// The preferred, primary initializer for this matrix.
      @inlinable
      internal init(storage: Storage) {
        self.storage = storage
      }
      """
    ]
  }
}
