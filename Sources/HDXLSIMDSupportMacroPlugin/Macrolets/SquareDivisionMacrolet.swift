//
//  SquareDivisionMacrolet.swift
//

import SwiftSyntax

/// Square self-division operations from `MatrixNxNProtocol`.
///
/// For half representation we go through the protocol-level
/// `multiplied(onRightBy:)` / `inverted()` helpers rather than `*` and
/// `.inverse`, because (a) `*` doesn't exist on `simd_halfNxM`, and
/// (b) `simd_inverse(simd_half3x3)` is miscomputed.
struct SquareDivisionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    switch context.layer {
    case .native:
      if descriptor.representation == .half {
        return [
          """
          @inlinable
          public func divided(onRightBy rhs: Self) -> Self {
            multiplied(onRightBy: rhs.inverted())
          }
          """,
          """
          @inlinable
          public func divided(onLeftBy lhs: Self) -> Self {
            multiplied(onLeftBy: lhs.inverted())
          }
          """,
          """
          @inlinable
          public mutating func formDivision(onRightBy rhs: Self) {
            self = divided(onRightBy: rhs)
          }
          """,
          """
          @inlinable
          public mutating func formDivision(onLeftBy lhs: Self) {
            self = divided(onLeftBy: lhs)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func divided(onRightBy rhs: Self) -> Self { self * rhs.inverse }
        """,
        """
        @inlinable
        public func divided(onLeftBy lhs: Self) -> Self { lhs.inverse * self }
        """,
        """
        @inlinable
        public mutating func formDivision(onRightBy rhs: Self) {
          self = self * rhs.inverse
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onLeftBy lhs: Self) {
          self = lhs.inverse * self
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func divided(onRightBy rhs: Self) -> Self {
          Self(storage: storage.divided(onRightBy: rhs.storage))
        }
        """,
        """
        @inlinable
        public func divided(onLeftBy lhs: Self) -> Self {
          Self(storage: storage.divided(onLeftBy: lhs.storage))
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onRightBy rhs: Self) {
          storage.formDivision(onRightBy: rhs.storage)
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onLeftBy lhs: Self) {
          storage.formDivision(onLeftBy: lhs.storage)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    // Skip half-3x3: its inverse uses our pure-Swift adjugate fallback (no
    // independent simd ground truth), so there's nothing trustworthy to compare
    // the division against — the manual invariant suite covers it instead.
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let nativeRight: String
    let nativeLeft: String
    switch descriptor.representation {
    case .half:
      nativeRight = "simd_mul(a, simd_inverse(b))"
      nativeLeft = "simd_mul(simd_inverse(b), a)"
    case .float, .double:
      nativeRight = "a * b.inverse"
      nativeLeft = "b.inverse * a"
    }
    // Invertible probes only (the zero matrix in the broad sweep is singular).
    let identityRows = (0..<descriptor.rowCount).map { r -> String in
      "[" + (0..<descriptor.columnCount).map { c in "\(scalar)(\(r == c ? 1 : 0))" }.joined(separator: ", ") + "]"
    }
    let identity = "[" + identityRows.joined(separator: ", ") + "]"
    let upperRows = (0..<descriptor.rowCount).map { r -> String in
      "[" + (0..<descriptor.columnCount).map { c -> String in
        if r == c { return "\(scalar)(2)" }
        if c > r { return "\(scalar)(1)" }
        return "\(scalar)(0)"
      }.joined(separator: ", ") + "]"
    }
    let upper = "[" + upperRows.joined(separator: ", ") + "]"
    let diagRows = (0..<descriptor.rowCount).map { r -> String in
      "[" + (0..<descriptor.columnCount).map { c in "\(scalar)(\(r == c ? r + 2 : 0))" }.joined(separator: ", ") + "]"
    }
    let diag = "[" + diagRows.joined(separator: ", ") + "]"
    return [
      """
      func test_squareDivisionRight() {
        let probes: [[[\(raw: scalar)]]] = [\(raw: identity), \(raw: upper), \(raw: diag)]
        validateBinaryEquivalence(
          "divided(onRightBy:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.divided(onRightBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeRight) }
        )
      }
      """,
      """
      func test_squareDivisionLeft() {
        let probes: [[[\(raw: scalar)]]] = [\(raw: identity), \(raw: upper), \(raw: diag)]
        validateBinaryEquivalence(
          "divided(onLeftBy:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.divided(onLeftBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeLeft) }
        )
      }
      """
    ]
  }
}
