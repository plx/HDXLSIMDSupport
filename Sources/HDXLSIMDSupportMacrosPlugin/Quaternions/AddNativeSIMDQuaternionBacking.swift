import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddNativeSIMDQuaternionBackingMacro: SIMDSupportMacro { }

extension AddNativeSIMDQuaternionBackingMacro: MemberMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
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
      """
      /// The underlying concrete type wrapped by this storage-type.
      @usableFromInline
      internal typealias Storage = \(raw: scalar.nativeSIMDQuaternionTypeName)
      """,
      """
      /// The concrete value wrapped by this storage-type.
      @usableFromInline
      internal var storage: Storage
      """,
      """
      /// The preferred, primary initializer for this storage-type.
      @inlinable
      internal init(storage: Storage) {
        self.storage = storage
      }
      """
    ]
  }
  
}

extension AddNativeSIMDQuaternionBackingMacro: ExtensionMacro {
  
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
        extension \(raw: typeName) : NativeSIMDRepresentable {
        
          @usableFromInline
          package typealias NativeSIMDRepresentation = \(raw: scalar.nativeSIMDQuaternionTypeName)
        
          @inlinable
          package init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
            self.init(storage: nativeSIMDRepresentation)
          }
        
        }
        """
      )
    ]
  }
}
