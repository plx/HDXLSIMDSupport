//
//  ScalarDivisionMacrolet.swift
//

import SwiftSyntax

/// `divided(by:)` / `formDivision(by:)` — scalar division.
///
/// Half-3-row results use column-wise pure-Swift fallback.
struct ScalarDivisionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount).map { "columns.\($0) * inv" }.joined(separator: ",")
          + ")"
        let formStmts = (0..<descriptor.columnCount)
          .map { "columns.\($0) *= inv" }.joined(separator: "\n")
        return [
          """
          @inlinable
          public func divided(by scalar: Scalar) -> Self {
            let inv = (1 as Scalar) / scalar
            return Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formDivision(by scalar: Scalar) {
            let inv = (1 as Scalar) / scalar
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func divided(by scalar: Scalar) -> Self { self * (1.0 / scalar) }
        """,
        """
        @inlinable
        public mutating func formDivision(by scalar: Scalar) { self *= (1.0 / scalar) }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func divided(by scalar: Scalar) -> Self {
          Self(storage: storage.divided(by: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formDivision(by scalar: Scalar) {
          storage.formDivision(by: scalar)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let nativeDiv: String
    switch descriptor.representation {
    case .half:  nativeDiv = "simd_mul((1 as \(scalar)) / s, m)"
    case .float, .double: nativeDiv = "m * ((1 as \(scalar)) / s)"
    }
    return [
      """
      func test_scalarDivision() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        // Filter zeros to avoid division-by-zero in the test.
        let scalars: [\(raw: scalar)] = [\(raw: scalar)(-2), \(raw: scalar)(-1), \(raw: scalar)(1), \(raw: scalar)(2)]
        validateMatrixScalarEquivalence(
          "divided(by:)",
          matrices: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in m.divided(by: s) },
          native: { (m: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeDiv) }
        )
      }
      """
    ]
  }
}
