//
//  FMAMacrolet.swift
//

import SwiftSyntax

/// Fused-multiply-add: `adding(_:multipliedBy:)` and the mutating variant.
///
/// Half-3-row results use column-wise pure-Swift fallback.
struct FMAMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount).map { "columns.\($0) + other.columns.\($0) * scalar" }
            .joined(separator: ",")
          + ")"
        let formStmts = (0..<descriptor.columnCount)
          .map { "columns.\($0) += other.columns.\($0) * scalar" }
          .joined(separator: "\n")
        return [
          """
          @inlinable
          public func adding(_ other: Self, multipliedBy scalar: Scalar) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formAddition(of other: Self, multipliedBy scalar: Scalar) {
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func adding(_ other: Self, multipliedBy scalar: Scalar) -> Self {
          self + (other * scalar)
        }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self, multipliedBy scalar: Scalar) {
          self += other * scalar
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func adding(_ other: Self, multipliedBy scalar: Scalar) -> Self {
          Self(passthroughValue: passthroughValue.adding(other.passthroughValue, multipliedBy: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self, multipliedBy scalar: Scalar) {
          passthroughValue.formAddition(of: other.passthroughValue, multipliedBy: scalar)
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
    let nativeFMA: String
    switch descriptor.representation {
    case .half:  nativeFMA = "simd_add(a, simd_mul(s, b))"
    case .float, .double: nativeFMA = "a + (b * s)"
    }
    return [
      """
      func test_fusedMultiplyAdd() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateMatrixMatrixScalarEquivalence(
          "adding(_:multipliedBy:)",
          lhses: probes,
          rhses: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in a.adding(b, multipliedBy: s) },
          native: { (a: \(raw: native), b: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeFMA) }
        )
      }
      """
    ]
  }
}
