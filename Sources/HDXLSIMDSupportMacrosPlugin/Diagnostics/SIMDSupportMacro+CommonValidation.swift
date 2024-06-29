import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import HDXLSIMDSupportProtocols

extension SIMDSupportMacro {

  static func requiredStructDeclaration(
    node: AttributeSyntax,
    declaration: some DeclGroupSyntax,
    explanation: @autoclosure () -> String = ""
  ) throws -> StructDeclSyntax {
    guard
      let structDeclaration = declaration.as(StructDeclSyntax.self)
    else {
      throw diagnosticError(
        for: node,
        explanation: "\(node) can only be attached-to `struct` declarations, not \(declaration)! (\(explanation()))"
      )
    }
    
    return structDeclaration
  }

  static func requiredScalar(
    node: AttributeSyntax,
    typeName: String,
    explanation: @autoclosure () -> String = ""
  ) throws -> SIMDAggregateScalar {
    guard
      let scalar = SIMDAggregateScalar.extracting(
        fromSwiftTypeName: typeName
      )
    else {
      throw diagnosticError(
        for: node,
        explanation: "Couldn't extract a type-name from `typeName` \(typeName)!  (\(explanation()))"
      )
    }
    
    return scalar
  }

  static func requiredShape(
    node: AttributeSyntax,
    typeName: String,
    explanation: @autoclosure () -> String = ""
  ) throws -> SIMDMatrixShape {
    guard
      let shape = SIMDMatrixShape.extracting(
        fromTypeName: typeName
      )
    else {
      throw diagnosticError(
        for: node,
        explanation: "Couldn't extract an MxN-style SIMD matrix-shape from `typeName` \(typeName)!  (\(explanation()))"
      )
    }
    
    return shape
  }

  static func requiredMatrixTypeDescriptor(
    node: AttributeSyntax,
    typeName: String,
    explanation: @autoclosure () -> String = ""
  ) throws -> SIMDMatrixTypeDescriptor {
    SIMDMatrixTypeDescriptor(
      scalar: try requiredScalar(
        node: node,
        typeName: typeName,
        explanation: "getting scalar for `SIMDMatrixTypeDescriptor` w/explanation: \(explanation())"
      ),
      shape: try requiredShape(
        node: node,
        typeName: typeName,
        explanation: "getting scalar for `SIMDMatrixTypeDescriptor` w/explanation: \(explanation())"
      )
    )
  }

}
