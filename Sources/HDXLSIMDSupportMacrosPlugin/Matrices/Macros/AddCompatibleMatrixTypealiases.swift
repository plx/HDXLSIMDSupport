import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddCompatibleMatrixDeclarationsMacro { }

extension AddCompatibleMatrixDeclarationsMacro: MemberMacro {

  static func compatibleMatrixTypeName(
    typeName: String,
    shape: SIMDMatrixShape
  ) throws -> String {
    switch typeName.hasSuffix("Storage") {
    case false:
      return "Matrix\(shape.typeNameComponent)<Scalar>"
    case true:
      guard let scalarType = SIMDMatrixScalar.extracting(
        fromSwiftTypeName: typeName
      ) else {
        // TODO: real errors!
        fatalError()
      }
      
      return "\(scalarType.swiftTypeName)\(shape.typeNameComponent)Storage"
    }
  }
  
  static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let matrixStructDecl = declaration.as(StructDeclSyntax.self),
    else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    guard let matrixShape = SIMDMatrixShape.extracting(
      from: typeName
    ) else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }

    
    
    
    let compatibleTypeSuffix = typeName.hasSuffix("Storage") ? "Storage" : ""
    
    return try matrixShape
      .allCompatibleMatrixShapesInAestheticOrdering
      .lazy
      .map { compatibleShape in
        let compatibleName = try compatibleMatrixTypeName(
          typeName: typeName,
          shape: compatibleShape
        )
        
        """
        /// The type of the corresponding \(raw: String(describing: compatibleShape)) matrix.
        public typealias CompatibleMatrix\(raw: compatibleShape.typeNameComponent) = \(raw: compatibleName)
        """
      }
      .joined(separator: "\n")
  }
}
