import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public protocol ColumnarNumericAggregateMacroProtocol: ExtensionMacro, SIMDSupportMacro {
  
  static var simdColumnCount: Int { get }
 
}

extension ColumnarNumericAggregateMacroProtocol {

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let logicalCondition = (0..<simdColumnCount)
      .lazy
      .map { "columns.\($0).allNumericEntriesSatisfy(predicate)" }
      .joined(separator: "\n&&\n")
    
    let numericEntryRepresentation = try requiredScalar(
      node: node,
      typeName: "\(type.trimmed)"
    )
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type.trimmed) : @retroactive NumericAggregate {
        
          public typealias NumericEntryRepresentation = \(raw: numericEntryRepresentation)
        
          @inlinable
          public func allNumericEntriesSatisfy(
            _ predicate: (NumericEntryRepresentation) throws -> Bool
          ) rethrows -> Bool {
            try (
              \(raw: logicalCondition)
            )
          }
        }
        """
      )
    ]
  }
}

public struct TwoColumnNumericAggregateMacro: ColumnarNumericAggregateMacroProtocol, SIMDSupportMacro {
  public static let simdColumnCount: Int = 2
}

public struct ThreeColumnNumericAggregateMacro: ColumnarNumericAggregateMacroProtocol, SIMDSupportMacro {
  public static let simdColumnCount: Int = 3
}

public struct FourColumnNumericAggregateMacro: ColumnarNumericAggregateMacroProtocol, SIMDSupportMacro {
  public static let simdColumnCount: Int = 4
}
