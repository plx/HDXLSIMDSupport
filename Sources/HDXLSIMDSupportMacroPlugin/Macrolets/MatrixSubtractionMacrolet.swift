//
//  MatrixSubtractionMacrolet.swift
//

import SwiftSyntax

/// Componentwise matrix-matrix subtraction.
///
/// Half-3-row results use column-wise pure-Swift fallback.
struct MatrixSubtractionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount).map { "columns.\($0) - other.columns.\($0)" }.joined(separator: ",")
          + ")"
        let formStmts = (0..<descriptor.columnCount)
          .map { "columns.\($0) -= other.columns.\($0)" }
          .joined(separator: "\n")
        return [
          """
          @inlinable
          public func subtracting(_ other: Self) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formSubtraction(of other: Self) {
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func subtracting(_ other: Self) -> Self { self - other }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self) { self -= other }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func subtracting(_ other: Self) -> Self {
          Self(passthroughValue: passthroughValue.subtracting(other.passthroughValue))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self) {
          passthroughValue.formSubtraction(of: other.passthroughValue)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let nativeSubtraction: String
    switch descriptor.representation {
    case .half:  nativeSubtraction = "simd_sub(a, b)"
    case .float, .double: nativeSubtraction = "a - b"
    }
    return [
      """
      func test_matrixSubtraction() {
        let probes: [[[\(raw: descriptor.representation.swiftScalarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateBinaryEquivalence(
          "subtraction",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (lhs: \(raw: wrapper), rhs: \(raw: wrapper)) -> \(raw: wrapper) in lhs.subtracting(rhs) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeSubtraction) }
        )
      }
      """
    ]
  }
}
