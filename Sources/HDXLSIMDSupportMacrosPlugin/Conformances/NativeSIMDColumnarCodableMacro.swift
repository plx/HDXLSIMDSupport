import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public protocol NativeSIMDColumnarCodableMacroProtocol: ExtensionMacro {
  
  static var simdColumnCount: Int { get }
  
  static func serializationKeysName() throws -> String
}

extension NativeSIMDColumnarCodableMacroProtocol {
  public static func serializationKeysName() throws -> String {
    switch simdColumnCount {
    case 2:
      return "TwoColumnCodingKey"
    case 3:
      return "ThreeColumnCodingKey"
    case 4:
      return "FourColumnCodingKey"
    default:
      fatalError() // TODO: proper errors
    }
  }
  
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let encodeOperations = (0..<simdColumnCount)
      .lazy
      .map {
        """
        try container.encode(
          nativeSIMDRepresentation.columns.\($0),
          forKey: .c\($0)
        )
        """
      }
      .joined(separator: "\n")
    
    let decodeOperations = (0..<simdColumnCount)
      .lazy
      .map {
        """
        let c\($0) = try container.decode(
          ColumnVector.self,
          forKey: .c\($0)
        )
        """
      }
      .joined(separator: "\n")
    
    let initInvocation = (0..<simdColumnCount)
      .lazy
      .map {
        "c\($0)"
      }
      .joined(separator: ",\n")
    
    let serializationKeys = try serializationKeysName()

    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : Codable {
          @usableFromInline
          package typealias SerializationKeys = \(raw: serializationKeys)
        
          @inlinable
          public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: SerializationKeys.self)
            \(raw: encodeOperations)
          }
        
          @inlinable
          public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: SerializationKeys.self)
            \(raw: decodeOperations)
            
            self.init(
              nativeSIMDRepresentation: NativeSIMDRepresentation(
                \(raw: initInvocation)
              )
            )
          }
        }
        """
      )
    ]
  }
}

public struct TwoColumnNativeSIMDCodableMacro: NativeSIMDColumnarCodableMacroProtocol {
  public static let simdColumnCount: Int = 2
}

public struct ThreeColumnNativeSIMDCodableMacro: NativeSIMDColumnarCodableMacroProtocol {
  public static let simdColumnCount: Int = 3
}

public struct FourColumnNativeSIMDCodableMacro: NativeSIMDColumnarCodableMacroProtocol {
  public static let simdColumnCount: Int = 4
}
