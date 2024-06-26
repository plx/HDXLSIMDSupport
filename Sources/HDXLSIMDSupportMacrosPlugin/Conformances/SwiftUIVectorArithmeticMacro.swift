import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct SwiftUIVectorArithmeticMacro { }

extension SwiftUIVectorArithmeticMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    // TODO: attachment-site validation, real errors, etc.
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : VectorArithmetic {
        
          @inlinable
          public var magnitudeSquared: Double {
            Double(componentwiseMagnitudeSquared)
          }
          
          @inlinable
          public mutating func scale(by factor: Double) {
            formMultiplication(
              by: Scalar(factor)
            )
          }
        
        }
        """
      )
    ]
  }
}
