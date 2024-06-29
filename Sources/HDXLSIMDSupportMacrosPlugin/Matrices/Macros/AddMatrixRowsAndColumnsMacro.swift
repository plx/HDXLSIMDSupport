import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddMatrixRowsAndColumnsMacro { }

extension AddMatrixRowsAndColumnsMacro: MemberMacro, SIMDSupportMacro {
  
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
    
    let matrixShape = try requiredShape(
      node: node,
      typeName: typeName
    )
    
    return [
      """
      /// `\(raw: typeName)` has row-vector `\(raw: matrixShape.rowVectorTypeName())`.
      public typealias RowVector = \(raw: matrixShape.rowVectorTypeName())
      """,
      """
      /// `\(raw: typeName)` has column-vector `\(raw: matrixShape.columnVectorTypeName())`.
      public typealias ColumnVector = \(raw: matrixShape.columnVectorTypeName())
      """,
      """
      /// `\(raw: typeName)` has diagonal-vector `\(raw: matrixShape.diagonalVectorTypeName())`.
      public typealias DiagonalVector = \(raw: matrixShape.diagonalVectorTypeName())
      """,
      """
      /// `\(raw: typeName)` has rows-tuple `\(raw: matrixShape.rowsTypeName)`.
      public typealias Rows = \(raw: matrixShape.rowsTypeName)
      """,
      """
      /// `\(raw: typeName)` has columns-tuple `\(raw: matrixShape.columnsTypeName)`.
      public typealias Rows = \(raw: matrixShape.columnsTypeName)
      """,
    ]
  }
  
}
