//
//  MatrixAdditionMacrolet.swift
//

import SwiftSyntax

/// Componentwise matrix-matrix addition: `adding(_:)` and `formAddition(of:)`.
///
/// Half-precision shapes that return half-3-row matrices fall back to
/// column-wise pure Swift, because the C-level `simd_*` overload is
/// miscomputed by the macOS 26 simd overlay.
struct MatrixAdditionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount).map { "columns.\($0) + other.columns.\($0)" }.joined(separator: ",")
          + ")"
        let formStmts = (0..<descriptor.columnCount)
          .map { "columns.\($0) += other.columns.\($0)" }
          .joined(separator: "\n")
        return [
          """
          @inlinable
          public func adding(_ other: Self) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formAddition(of other: Self) {
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func adding(_ other: Self) -> Self { self + other }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self) { self += other }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func adding(_ other: Self) -> Self {
          Self(passthroughValue: passthroughValue.adding(other.passthroughValue))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self) {
          passthroughValue.formAddition(of: other.passthroughValue)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let nativeAddition: String
    switch descriptor.representation {
    case .half:  nativeAddition = "simd_add(a, b)"
    case .float, .double: nativeAddition = "a + b"
    }
    return [
      """
      func test_matrixAddition() {
        let probes: [[[\(raw: descriptor.representation.swiftScalarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateBinaryEquivalence(
          "addition",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (lhs: \(raw: wrapper), rhs: \(raw: wrapper)) -> \(raw: wrapper) in lhs.adding(rhs) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeAddition) }
        )
      }
      """
    ]
  }
}
