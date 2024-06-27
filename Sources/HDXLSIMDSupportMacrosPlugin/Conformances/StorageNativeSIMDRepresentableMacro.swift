import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct StorageNativeSIMDRepresentableMacro { }

extension StorageNativeSIMDRepresentableMacro: ExtensionMacro {
  
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
