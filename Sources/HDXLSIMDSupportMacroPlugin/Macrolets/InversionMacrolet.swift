//
//  InversionMacrolet.swift
//

import SwiftSyntax

/// `inverted() -> Self` / `formInverse()` — only for square matrices.
///
/// - Native float/double: `self.inverse` via the simd overlay.
/// - Native half-2x2 / half-4x4: `simd_inverse(self)` C function.
/// - Native half-3x3: pure-Swift adjugate formula using `simd_determinant` +
///   `simd_cross`. The C function `simd_inverse(simd_half3x3)` is miscomputed
///   because its result crosses the broken half-3-row overlay bridge.
/// - Storage / Wrapper: forwards.
struct InversionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    switch context.layer {
    case .native:
      if descriptor.representation == .half && descriptor.rowCount == 3 {
        // 3x3 inverse via cofactor / adjugate formula.
        return [
          """
          @inlinable
          public func inverted() -> Self {
            let c0 = columns.0
            let c1 = columns.1
            let c2 = columns.2
            let invDet = (1 as Scalar) / simd_determinant(self)
            let r0 = simd_cross(c1, c2)
            let r1 = simd_cross(c2, c0)
            let r2 = simd_cross(c0, c1)
            return Self(
              columns: (
                ColumnVector(r0[0], r1[0], r2[0]) * invDet,
                ColumnVector(r0[1], r1[1], r2[1]) * invDet,
                ColumnVector(r0[2], r1[2], r2[2]) * invDet
              )
            )
          }
          """,
          """
          @inlinable
          public mutating func formInverse() {
            self = inverted()
          }
          """
        ]
      }
      if descriptor.representation == .half {
        return [
          """
          @inlinable
          public func inverted() -> Self { simd_inverse(self) }
          """,
          """
          @inlinable
          public mutating func formInverse() { self = simd_inverse(self) }
          """
        ]
      }
      return [
        """
        @inlinable
        public func inverted() -> Self { self.inverse }
        """,
        """
        @inlinable
        public mutating func formInverse() { self = self.inverse }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func inverted() -> Self {
          Self(passthroughValue: passthroughValue.inverted())
        }
        """,
        """
        @inlinable
        public mutating func formInverse() {
          passthroughValue.formInverse()
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    // Skip half-3x3: our pure-Swift adjugate formula IS the implementation;
    // there's no independent ground truth via simd_inverse to compare against.
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let nativeInverse: String
    switch descriptor.representation {
    case .half:  nativeInverse = "simd_inverse(m)"
    case .float, .double: nativeInverse = "m.inverse"
    }
    // Only use non-singular probes — invertible matrices. We hardcode a few
    // here rather than relying on the macrolet's broader probe sweep
    // (which includes the zero matrix).
    let identityRows = (0..<descriptor.rowCount).map { r -> String in
      let cells = (0..<descriptor.columnCount).map { c in "\(scalar)(\(r == c ? 1 : 0))" }
      return "[" + cells.joined(separator: ", ") + "]"
    }
    let identity = "[" + identityRows.joined(separator: ", ") + "]"
    let upperRows = (0..<descriptor.rowCount).map { r -> String in
      let cells = (0..<descriptor.columnCount).map { c -> String in
        if r == c { return "\(scalar)(2)" }
        if c > r { return "\(scalar)(1)" }
        return "\(scalar)(0)"
      }
      return "[" + cells.joined(separator: ", ") + "]"
    }
    let upper = "[" + upperRows.joined(separator: ", ") + "]"
    let diagRows = (0..<descriptor.rowCount).map { r -> String in
      let cells = (0..<descriptor.columnCount).map { c in "\(scalar)(\(r == c ? r + 2 : 0))" }
      return "[" + cells.joined(separator: ", ") + "]"
    }
    let diag = "[" + diagRows.joined(separator: ", ") + "]"
    return [
      """
      func test_matrixInversion() {
        let probes: [[[\(raw: scalar)]]] = [
          \(raw: identity),
          \(raw: upper),
          \(raw: diag)
        ]
        validateUnaryEquivalence(
          "inverted",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) in m.inverted() },
          native: { (m: \(raw: native)) -> \(raw: native) in \(raw: nativeInverse) }
        )
      }
      """
    ]
  }
}
