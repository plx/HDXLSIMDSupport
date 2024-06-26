import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct StorageNumericAggregateMacro { }

extension StorageNumericAggregateMacro: ExtensionMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    // TODO: attachment-site validation, real errors, etc.
    
    let typeName: String = "\(type.trimmed)"
    
    let numericEntryRepresentation: String
    switch SIMDMatrixScalar.extracting(fromSwiftTypeName: typeName) {
    case .some(let scalarType):
      numericEntryRepresentation = scalarType.swiftTypeName
    case .none:
      numericEntryRepresentation = "Scalar"
    }
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : @retroactive NumericAggregate {
        
          public typealias NumericEntryRepresentation = \(raw: numericEntryRepresentation)
        
          @inlinable
          public func allNumericEntriesSatisfy(
            _ predicate: (NumericEntryRepresentation) throws -> Bool
          ) rethrows -> Bool {
            try storage.allNumericEntriesSatisfy(predicate)
          }
        }
        """
      )
    ]
  }
  
}
