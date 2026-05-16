//
//  CodableMacrolet.swift
//

import SwiftSyntax

/// `Codable` — encodes/decodes one column-vector per CodingKey (`c0`, `c1`,
/// ...). Only emitted for passthroughValue / wrapper layers; native simd matrices are
/// not Codable.
///
/// The encoding uses sortable string keys (`c0`, `c1`, ...) with matching
/// `intValue`s so users can read/write either flavor.
struct CodableMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage, .wrapper:
      return codingDeclarations()
    }
  }

  private func codingDeclarations() -> [DeclSyntax] {
    // Build the CodingKeys enum cases and case-mappings.
    let caseNames = (0..<descriptor.columnCount).map { "c\($0)" }

    let enumCases = caseNames
      .map { name in "case \(name) = \"\(name)\"" }
      .joined(separator: "\n")

    let intValueGetCases = caseNames.enumerated()
      .map { (i, name) in "case .\(name): return \(i)" }
      .joined(separator: "\n")

    let intValueInitCases = caseNames.enumerated()
      .map { (i, name) in "case \(i): self = .\(name)" }
      .joined(separator: "\n")

    let encodeStatements = caseNames.enumerated()
      .map { (i, name) in "try container.encode(columns.\(i), forKey: .\(name))" }
      .joined(separator: "\n")

    let decodeLetStatements = caseNames.enumerated()
      .map { (i, name) in "let c\(i) = try container.decode(ColumnVector.self, forKey: .\(name))" }
      .joined(separator: "\n")

    let initCallArgs = (0..<descriptor.columnCount).map { "c\($0)" }.joined(separator: ", ")

    return [
      """
      public enum CodingKeys: String, CodingKey {
        \(raw: enumCases)

        @inlinable
        public var intValue: Int? {
          get {
            switch self {
            \(raw: intValueGetCases)
            }
          }
        }

        @inlinable
        public init?(intValue: Int) {
          switch intValue {
          \(raw: intValueInitCases)
          default: return nil
          }
        }
      }
      """,
      """
      @inlinable
      public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        \(raw: encodeStatements)
      }
      """,
      """
      @inlinable
      public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        \(raw: decodeLetStatements)
        self.init(\(raw: initCallArgs))
      }
      """
    ]
  }
}
