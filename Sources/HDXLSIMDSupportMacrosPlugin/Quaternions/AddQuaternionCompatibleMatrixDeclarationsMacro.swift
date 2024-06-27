import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddQuaternionCompatibleMatrixDeclarationsMacro: SIMDSupportMacro { }

extension AddQuaternionCompatibleMatrixDeclarationsMacro: MemberMacro {
    
  static func compatibleMatrixTypeName(
    node: AttributeSyntax,
    typeName: String,
    shape: SIMDMatrixShape
  ) throws -> String {
    guard shape.isCompatibleWithQuaternions else {
      throw diagnosticError(
        for: node,
        explanation: "`shape` \(shape) isn't compatible-with quaternions!"
      )
    }
    
    switch typeName.hasSuffix("Storage") {
    case false:
      return "Matrix\(shape.typeNameComponent)<Scalar>"
    case true:
      let scalarType = try requiredScalar(
        node: node,
        typeName: typeName
      )
      
      return "\(scalarType.swiftTypeName)Matrix\(shape.typeNameComponent)Storage"
    }
  }

  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let quaternionStructDecl = try requiredStructDeclaration(
      node: node,
      declaration: declaration
    )
    
    let typeName = "\(quaternionStructDecl.name.trimmed)"

    let matrix3x3TypeName = try compatibleMatrixTypeName(
      node: node,
      typeName: typeName,
      shape: ._3x3
    )

    let matrix4x4TypeName = try compatibleMatrixTypeName(
      node: node,
      typeName: typeName,
      shape: ._4x4
    )
    
    return [
      """
      /// `\(raw: typeName)` has compatible-3x3 matrix: \(raw: matrix3x3TypeName)
      public typealias CompatibleMatrix3x3 = \(raw: matrix3x3TypeName)
      """,
      """
      /// `\(raw: typeName)` has compatible-4x4 matrix: \(raw: matrix4x4TypeName)
      public typealias CompatibleMatrix4x4 = \(raw: matrix4x4TypeName)
      """
    ]
  }
}
