import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddMatrixRowsAndColumnsMacro { }

extension AddMatrixRowsAndColumnsMacro: MemberMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard 
      let matrixStructDecl = declaration.as(StructDeclSyntax.self)
    else {
      fatalError()
    }
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    guard
      let matrixShape = SIMDMatrixShape.extracting(fromTypeName: typeName)
    else {
      fatalError()
    }
    
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
