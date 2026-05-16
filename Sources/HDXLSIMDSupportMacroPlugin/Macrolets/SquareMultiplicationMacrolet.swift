//
//  SquareMultiplicationMacrolet.swift
//

import SwiftSyntax

/// Square self-multiplication operations from `MatrixNxNProtocol`:
///
///   - `multiplied(onRightBy rhs: Self) -> Self`  (≡ `self * rhs`)
///   - `multiplied(onLeftBy lhs: Self) -> Self`   (≡ `lhs * self`)
///   - `formMultiplication(onRightBy:)`           (≡ `self *= rhs`)
///   - `formMultiplication(onLeftBy:)`            (≡ `self = lhs * self`)
///
/// Half representation uses pure-Swift column-wise multiplication. Each
/// output column hoists the per-input-column references into local `let`s
/// before summing, otherwise the type-checker chokes on the large nested
/// expression.
struct SquareMultiplicationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    switch context.layer {
    case .native:
      // half-2x2 / half-4x4: use `simd_mul` (C-level, works for non-3-row).
      // half-3x3: use pure-Swift column-wise (overlay's matrix-level routines
      // miscompute half-3-row results).
      // float / double: use `*` (operator overload from the overlay).
      if descriptor.representation == .half && descriptor.rowCount != 3 {
        return [
          """
          @inlinable
          public func multiplied(onRightBy rhs: Self) -> Self { simd_mul(self, rhs) }
          """,
          """
          @inlinable
          public func multiplied(onLeftBy lhs: Self) -> Self { simd_mul(lhs, self) }
          """,
          """
          @inlinable
          public mutating func formMultiplication(onRightBy rhs: Self) { self = simd_mul(self, rhs) }
          """,
          """
          @inlinable
          public mutating func formMultiplication(onLeftBy lhs: Self) { self = simd_mul(lhs, self) }
          """
        ]
      }
      if descriptor.producesBuggyHalfThreeRow {
        // Half-3x3 column-wise pure-Swift. Imperative accumulation keeps
        // type checking trivial.
        let dim = descriptor.columnCount  // == rowCount for square (3)
        let selfLets = (0..<dim).map { i in "let s\(i): ColumnVector = self.columns.\(i)" }.joined(separator: "\n  ")
        let rightBuilders: [String] = (0..<dim).flatMap { k -> [String] in
          var lines: [String] = ["var rc\(k): ColumnVector = s0 * rhs.columns.\(k)[0]"]
          for i in 1..<dim {
            lines.append("rc\(k) += s\(i) * rhs.columns.\(k)[\(i)]")
          }
          return lines
        }
        let rightTuple = "(" + (0..<dim).map { "rc\($0)" }.joined(separator: ", ") + ")"

        let lhsLets = (0..<dim).map { i in "let l\(i): ColumnVector = lhs.columns.\(i)" }.joined(separator: "\n  ")
        let leftBuilders: [String] = (0..<dim).flatMap { k -> [String] in
          var lines: [String] = ["var lc\(k): ColumnVector = l0 * self.columns.\(k)[0]"]
          for i in 1..<dim {
            lines.append("lc\(k) += l\(i) * self.columns.\(k)[\(i)]")
          }
          return lines
        }
        let leftTuple = "(" + (0..<dim).map { "lc\($0)" }.joined(separator: ", ") + ")"
        return [
          """
          @inlinable
          public func multiplied(onRightBy rhs: Self) -> Self {
            \(raw: selfLets)
            \(raw: rightBuilders.joined(separator: "\n  "))
            return Self(columns: \(raw: rightTuple))
          }
          """,
          """
          @inlinable
          public func multiplied(onLeftBy lhs: Self) -> Self {
            \(raw: lhsLets)
            \(raw: leftBuilders.joined(separator: "\n  "))
            return Self(columns: \(raw: leftTuple))
          }
          """,
          """
          @inlinable
          public mutating func formMultiplication(onRightBy rhs: Self) {
            self = multiplied(onRightBy: rhs)
          }
          """,
          """
          @inlinable
          public mutating func formMultiplication(onLeftBy lhs: Self) {
            self = multiplied(onLeftBy: lhs)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func multiplied(onRightBy rhs: Self) -> Self { self * rhs }
        """,
        """
        @inlinable
        public func multiplied(onLeftBy lhs: Self) -> Self { lhs * self }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onRightBy rhs: Self) { self = self * rhs }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onLeftBy lhs: Self) { self = lhs * self }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func multiplied(onRightBy rhs: Self) -> Self {
          Self(storage: storage.multiplied(onRightBy: rhs.storage))
        }
        """,
        """
        @inlinable
        public func multiplied(onLeftBy lhs: Self) -> Self {
          Self(storage: storage.multiplied(onLeftBy: lhs.storage))
        }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onRightBy rhs: Self) {
          storage.formMultiplication(onRightBy: rhs.storage)
        }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onLeftBy lhs: Self) {
          storage.formMultiplication(onLeftBy: lhs.storage)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let nativeMul: String
    switch descriptor.representation {
    case .half:  nativeMul = "simd_mul(a, b)"
    case .float, .double: nativeMul = "a * b"
    }
    return [
      """
      func test_squareMatrixMultiplication() {
        let probes: [[[\(raw: descriptor.representation.swiftScalarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateBinaryEquivalence(
          "multiplied(onRightBy: Self)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.multiplied(onRightBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeMul) }
        )
      }
      """
    ]
  }
}
