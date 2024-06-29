import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct ExtendedSIMDScalarMacro: DeclarationMacro, ExtensionMacro {

  static let storageTypeNames: [String] = [
    "QuaternionStorage",
    "Matrix2x2Storage",
    "Matrix2x3Storage",
    "Matrix2x4Storage",
    "Matrix3x2Storage",
    "Matrix3x3Storage",
    "Matrix3x4Storage",
    "Matrix4x2Storage",
    "Matrix4x3Storage",
    "Matrix4x4Storage"
  ]
  
  public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
    let typeName = type.trimmed

    let typealiases = storageTypeNames
      .lazy
      .map { "public typealias \($0) == \(typeName)\($0)" }
      .joined(separator: "\n")
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(typeName) : ExtendedSIMDScalar {
        
          \(raw: typealiases)
        
        }
        """
      )
    ]
  }
  
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let typeName = node
        .genericArgumentClause?
        .arguments
        .first?
        .argument
        .as(IdentifierTypeSyntax.self)?
        .name.text
    else {
      fatalError("Need real errors.")
    }
    

    let typealiases = storageTypeNames
      .lazy
      .map { "public typealias \($0) == \(typeName)\($0)" }
      .joined(separator: "\n")
    
    return [
      """
      \(raw: typealiases)
      """
    ]
  }

}

