import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddCompatibleMatrixDeclarationsMacro { }

extension AddCompatibleMatrixDeclarationsMacro: MemberMacro, SIMDSupportMacro {

  static func compatibleMatrixTypeName(
    node: AttributeSyntax,
    typeName: String,
    shape: SIMDMatrixShape
  ) throws -> String? {
    switch typeName.hasSuffix("Storage") {
    case false:
      return "Matrix\(shape.typeNameComponent)<Scalar>"
    case true:
      let scalarType = try requiredScalar(
        node: node,
        typeName: typeName
      )
      
      return "\(scalarType.swiftTypeName)\(shape.typeNameComponent)Storage"
    }
  }
  
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

    return try matrixShape
      .allCompatibleMatrixShapesInAestheticOrdering
      .lazy
      .map { compatibleShape in
        let compatibleName = try compatibleMatrixTypeName(
          node: node,
          typeName: typeName,
          shape: compatibleShape
        )
        
        return """
        /// The type of the corresponding \(raw: String(describing: compatibleShape)) matrix.
        public typealias CompatibleMatrix\(raw: compatibleShape.typeNameComponent) = \(raw: compatibleName)
        """ as DeclSyntax
      }
  }
}
