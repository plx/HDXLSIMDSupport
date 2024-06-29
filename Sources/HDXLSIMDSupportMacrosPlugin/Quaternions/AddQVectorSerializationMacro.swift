import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct AddQVectorSerializationMacro { }

extension AddQVectorSerializationMacro: MemberMacro, SIMDSupportMacro {
  
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
      /// Typealias for the same-scalar, length-4 simd vector.
      @usableFromInline
      internal typealias QVector = SIMD4<\(raw: scalar.swiftTypeName)>
      """,
      """
      /// Get-or-set our backing storage via its `QVector` representation.
      @usableFromInline
      internal var qVectorRepresentation: QVector {
        get { QVector(i, j, k, r) }
        set { storage = Storage(ix: i, iy: j, iz: k, r: r) }
      }
      """,
      """
      /// Convenience initializer for initializing from the `QVector` representation.
      @inlinable
      internal init(qVectorRepresentation: QVector) {
        self.init(storage: Storage(
          ix: qVectorRepresentation[0],
          iy: qVectorRepresentation[1],
          iz: qVectorRepresentation[2],
          r: qVectorRepresentation[3]
        )
      }
      """
    ]
  }
  
}

extension AddQVectorSerializationMacro: ExtensionMacro {
  
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
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(raw: typeName) : Codable {
        
          @inlinable
          public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(qVectorRepresentation)
          }
        
          @inlinable
          public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.init(
              qVectorRepresentation: try container.decode(QVector.self)
            )
          }

        }
        """
      )
    ]
  }
}
