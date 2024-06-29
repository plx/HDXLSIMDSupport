import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public protocol NativeSIMDColumnarHashableMacroProtocol: ExtensionMacro {
  
  static var simdColumnCount: Int { get }
  
}

extension NativeSIMDColumnarHashableMacroProtocol {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {

    let hashOperations = (0..<simdColumnCount)
      .lazy
      .map { "nativeSIMDRepresentation.columns.\($0).hash(into: &hasher)" }
      .joined(separator: "\n")
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : Hashable {
        
          @inlinable
          public func hash(into hasher: inout Hasher) {
            \(raw: hashOperations)
          }
        }
        """
      )
    ]
  }
}

public struct TwoColumnNativeSIMDHashableMacro: NativeSIMDColumnarHashableMacroProtocol {
  public static let simdColumnCount: Int = 2
}

public struct ThreeColumnNativeSIMDHashableMacro: NativeSIMDColumnarHashableMacroProtocol {
  public static let simdColumnCount: Int = 3
}

public struct FourColumnNativeSIMDHashableMacro: NativeSIMDColumnarHashableMacroProtocol {
  public static let simdColumnCount: Int = 4
}
