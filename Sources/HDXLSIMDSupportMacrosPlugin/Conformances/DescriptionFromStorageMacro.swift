import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct DescriptionFromStorageMacro { }

extension DescriptionFromStorageMacro: ExtensionMacro {
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
        extension \(type.trimmed) : CustomStringConvertible {
        
          @inlinable
          public var description: String {
            String(describing: storage)
          }
        
        }
        """
      )
    ]
  }
}

