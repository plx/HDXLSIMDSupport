import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct DebugDescriptionFromNativeSIMDRepresentationMacro { }

extension DebugDescriptionFromNativeSIMDRepresentationMacro: ExtensionMacro {
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
        extension \(type.trimmed) : CustomDebugStringConvertible {
        
          @inlinable
          public var description: String {
            "\\(String(reflecting: Self.self))(nativeSIMDRepresentation: \\(String(reflecting: nativeSIMDRepresentation)))"
          }
        
        }
        """
      )
    ]
  }
}

