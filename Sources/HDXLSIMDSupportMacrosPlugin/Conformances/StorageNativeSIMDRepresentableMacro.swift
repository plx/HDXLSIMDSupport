import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct StorageNativeSIMDRepresentableMacro { }

extension StorageNativeSIMDRepresentableMacro: ExtensionMacro {
  static func extractNumericEntryRepresentation(from typeName: String) throws -> String {
    if typeName.hasPrefix("Float16") {
      return "Float16"
    } else if typeName.hasPrefix("Float") {
      return "Float"
    } else if typeName.hasPrefix("Double") {
      return "Double"
    } else {
      fatalError() // TODO: real errors
    }
  }

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    // TODO: attachment-site validation, real errors, etc.
    
    let numericEntryRepresentation = try extractNumericEntryRepresentation(from: "\(type.trimmed)")
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : @retroactive NativeSIMDRepresentable {
        
          @usableFromInline
          package typealias NativeSIMDRepresentation = Storage.NativeSIMDRepresentation
        
          @inlinable
          package var nativeSIMDRepresentation: NativeSIMDRepresentation {
            get { storage.nativeSIMDRepresentation }
            set { storage.nativeSIMDRepresentation = newValue }
          }
        
          @inlinable
          package init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
            self.init(
              storage: Storage(nativeSIMDRepresentation)
            )
          }
        }
        """
      )
    ]
  }
}

