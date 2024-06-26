import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddCompatibleQuaternionDeclarationsMacro { }

extension AddCompatibleQuaternionDeclarationsMacro: MemberMacro {
  
  static func compatibleQuaternionTypeName(
    typeName: String,
    shape: SIMDMatrixShape
  ) throws -> String {
    guard shape.isCompatibleWithQuaternions else {
      fatalError() // TODO: real errors!
    }
    
    switch typeName.hasSuffix("Storage") {
    case false:
      return "Quaternion\(shape.typeNameComponent)<Scalar>"
    case true:
      guard let scalarType = SIMDMatrixScalar.extracting(
        fromSwiftTypeName: typeName
      ) else {
        // TODO: real errors!
        fatalError()
      }
      
      return "\(scalarType.swiftTypeName)QuaternionStorage"
    }
  }
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let matrixStructDecl = declaration.as(StructDeclSyntax.self)
    else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    guard 
      let matrixShape = SIMDMatrixShape.extracting(
        fromTypeName: typeName
      )
    else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }

    let quaternionTypeName = try compatibleQuaternionTypeName(
      typeName: typeName,
      shape: matrixShape
    )
    
    return [
      """
      /// `\(raw: typeName)` has compatible-quaternion: \(raw: quaternionTypeName)
      public typealias CompatibleQuaternion = \(raw: quaternionTypeName)
      """
    ]
  }
}
