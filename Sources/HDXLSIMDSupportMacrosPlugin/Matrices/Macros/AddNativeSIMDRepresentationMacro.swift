import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddNativeSIMDBackingMacro { }

extension AddNativeSIMDBackingMacro: MemberMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let matrixStructDecl = declaration.as(StructDeclSyntax.self)
    else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    guard let matrixTypeDescriptor = SIMDMatrixTypeDescriptor.extracting(
      fromSwiftTypeName: typeName
    ) else {
      fatalError()
    }

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

extension AddNativeSIMDBackingMacro: ExtensionMacro {

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    guard
      let matrixStructDecl = declaration.as(StructDeclSyntax.self)
    else {
      // TODO: attachment-site validation, real errors, etc.
      fatalError()
    }
    
    let typeName = "\(matrixStructDecl.name.trimmed)"
    
    guard let matrixTypeDescriptor = SIMDMatrixTypeDescriptor.extracting(
      fromSwiftTypeName: typeName
    ) else {
      fatalError()
    }

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
