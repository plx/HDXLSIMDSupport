import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public protocol ColumnarNumericAggregateMacroProtocol: ExtensionMacro {
  
  static var simdColumnCount: Int { get }
 
}

extension ColumnarNumericAggregateMacroProtocol {
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
    let logicalCondition = (0..<simdColumnCount)
      .lazy
      .map { "columns.\($0).allNumericEntriesSatisfy(predicate)" }
      .joined(separator: "\n&&\n")
    
    let numericEntryRepresentation = try extractNumericEntryRepresentation(from: "\(type.trimmed)")
    
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

public struct TwoColumnNumericAggregateMacro: ColumnarNumericAggregateMacroProtocol {
  public static let simdColumnCount: Int = 2
}

public struct ThreeColumnNumericAggregateMacro: ColumnarNumericAggregateMacroProtocol {
  public static let simdColumnCount: Int = 3
}

public struct FourColumnNumericAggregateMacro: ColumnarNumericAggregateMacroProtocol {
  public static let simdColumnCount: Int = 4
}
