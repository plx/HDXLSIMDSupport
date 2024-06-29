import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddQuaternionNumericAggregateMacro: SIMDSupportMacro { }

extension AddQuaternionNumericAggregateMacro: ExtensionMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let quaternionStructDecl = try requiredStructDeclaration(
      node: node,
      declaration: declaration
    )
    
    let typeName = "\(quaternionStructDecl.name.trimmed)"
    
    let scalar = try requiredScalar(
      node: node,
      typeName: typeName
    )

    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : @retroactive NumericAggregate {
        
          public typealias NumericEntryRepresentation = \(raw: scalar.swiftTypeName)
        
          @inlinable
          public func allNumericEntriesSatisfy(
            _ predicate: (NumericEntryRepresentation) throws -> Bool
          ) rethrows -> Bool {
            try (
            predicate(realComponent)
            &&
            imaginaryComponent.allNumericEntriesSatisfy(predicate)
            )
          }
        }
        """
      )
    ]
  }
  
}

