import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddNativeSIMDMatrixBackingMacro: SIMDSupportMacro { }

extension AddNativeSIMDMatrixBackingMacro: MemberMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let matrixStructDecl = try requiredStructDeclaration(
      node: node,
      declaration: declaration
    )
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    let matrixTypeDescriptor = try requiredMatrixTypeDescriptor(
      node: node,
      typeName: typeName
    )

    return [
      """
      /// The underlying concrete type wrapped by this storage-type.
      @usableFromInline
      internal typealias Storage = \(raw: matrixTypeDescriptor.nativeSIMDMatrixTypeName)
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

extension AddNativeSIMDMatrixBackingMacro: ExtensionMacro {

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let matrixStructDecl = try requiredStructDeclaration(
      node: node,
      declaration: declaration
    )
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    let matrixTypeDescriptor = try requiredMatrixTypeDescriptor(
      node: node,
      typeName: typeName
    )

    return [
      try ExtensionDeclSyntax(
        """
        extension \(raw: typeName) : NativeSIMDRepresentable {
        
          @usableFromInline
          package typealias NativeSIMDRepresentation = \(raw: matrixTypeDescriptor.nativeSIMDMatrixTypeName)
        
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
