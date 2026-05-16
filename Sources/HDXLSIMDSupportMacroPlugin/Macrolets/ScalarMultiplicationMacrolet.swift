//
//  ScalarMultiplicationMacrolet.swift
//

import SwiftSyntax

/// `multiplied(by:)` / `formMultiplication(by:)` — scalar multiplication.
/// Half-3-row results use column-wise pure-Swift fallback.
struct ScalarMultiplicationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount).map { "columns.\($0) * scalar" }.joined(separator: ",")
          + ")"
        let formStmts = (0..<descriptor.columnCount)
          .map { "columns.\($0) *= scalar" }.joined(separator: "\n")
        return [
          """
          @inlinable
          public func multiplied(by scalar: Scalar) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formMultiplication(by scalar: Scalar) {
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func multiplied(by scalar: Scalar) -> Self { self * scalar }
        """,
        """
        @inlinable
        public mutating func formMultiplication(by scalar: Scalar) { self *= scalar }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func multiplied(by scalar: Scalar) -> Self {
          Self(storage: storage.multiplied(by: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formMultiplication(by scalar: Scalar) {
          storage.formMultiplication(by: scalar)
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
    let nativeMul: String
    switch descriptor.representation {
    case .half:  nativeMul = "simd_mul(s, m)"
    case .float, .double: nativeMul = "m * s"
    }
    return [
      """
      func test_scalarMultiplication() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateMatrixScalarEquivalence(
          "multiplied(by:)",
          matrices: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in m.multiplied(by: s) },
          native: { (m: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeMul) }
        )
      }
      """
    ]
  }
}
