//
//  CrossShapeMultiplicationMacrolet.swift
//

import SwiftSyntax

/// Cross-shape (M × N) matrix multiplication.
///
/// For a matrix of shape (M cols, N rows):
///
///   - Right-mult: `self * rhs` where rhs is (X, M) → result (X, N).
///     X ∈ {2,3,4}. When the result type equals Self we additionally emit
///     `formMultiplication(onRightBy:)`.
///   - Left-mult:  `lhs * self` where lhs is (N, X) → result (M, X).
///     Symmetric.
///
/// Square-`Self`-multiplication is handled separately by
/// `SquareMultiplicationMacrolet`. This macrolet skips that case.
///
/// Native dispatch strategy:
///   - float / double: use the `*` operator from the simd overlay.
///   - half, result is NOT 3-row: `simd_mul(a, b)` C function.
///   - half, result IS 3-row: column-wise pure Swift (the C function
///     miscomputes half-3-row results).
struct CrossShapeMultiplicationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  enum NativeStrategy {
    case swiftOperator
    case simdMul
    case columnWise
  }

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    var result: [DeclSyntax] = []
    result.append(contentsOf: rightMultiplications(in: context))
    result.append(contentsOf: leftMultiplications(in: context))
    return result
  }

  // MARK: - Strategy selection

  private func strategy(forResultRowCount resultRowCount: Int) -> NativeStrategy {
    switch descriptor.representation {
    case .float, .double:
      return .swiftOperator
    case .half:
      return resultRowCount == 3 ? .columnWise : .simdMul
    }
  }

  // MARK: - Right multiplications

  /// `self * rhs` for each compatible rhs shape (X, M).
  private func rightMultiplications(in context: MatrixLayerContext) -> [DeclSyntax] {
    let M = descriptor.columnCount
    let N = descriptor.rowCount
    var decls: [DeclSyntax] = []
    for X in 2...4 {
      let rhsRowCount = M
      let rhsColumnCount = X
      let resultRowCount = N
      let resultColumnCount = X
      if descriptor.isSquare && X == M { continue }
      let isSelfResult = (resultColumnCount == descriptor.columnCount && resultRowCount == descriptor.rowCount)
      let rhsTypeName = compatibleTypeName(rowCount: rhsRowCount, columnCount: rhsColumnCount)
      let resultTypeName = isSelfResult ? "Self" : compatibleTypeName(rowCount: resultRowCount, columnCount: resultColumnCount)
      let nativeStrategy = strategy(forResultRowCount: resultRowCount)

      decls.append(contentsOf: rightMultiplicationDecl(
        rhsTypeName: rhsTypeName,
        resultTypeName: resultTypeName,
        resultColumnCount: resultColumnCount,
        nativeStrategy: nativeStrategy,
        isSelfResult: isSelfResult,
        in: context
      ))

      if isSelfResult {
        decls.append(contentsOf: formRightMultiplicationDecl(
          rhsTypeName: rhsTypeName,
          nativeStrategy: nativeStrategy,
          in: context
        ))
      }
    }
    return decls
  }

  private func rightMultiplicationDecl(
    rhsTypeName: String,
    resultTypeName: String,
    resultColumnCount: Int,
    nativeStrategy: NativeStrategy,
    isSelfResult: Bool,
    in context: MatrixLayerContext
  ) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      switch nativeStrategy {
      case .swiftOperator:
        return [
          """
          @inlinable
          public func multiplied(onRightBy rhs: \(raw: rhsTypeName)) -> \(raw: resultTypeName) {
            self * rhs
          }
          """
        ]
      case .simdMul:
        return [
          """
          @inlinable
          public func multiplied(onRightBy rhs: \(raw: rhsTypeName)) -> \(raw: resultTypeName) {
            simd_mul(self, rhs)
          }
          """
        ]
      case .columnWise:
        let M = descriptor.columnCount
        // Build each output column with imperative `+=` accumulation. Each
        // statement is a simple `SIMD<n> * Scalar` (or `+= SIMD<n>`), which
        // the type checker resolves in O(1).
        let selfLets = (0..<M).map { i in "let s\(i): ColumnVector = self.columns.\(i)" }.joined(separator: "\n  ")
        let colBuilders: [String] = (0..<resultColumnCount).flatMap { k -> [String] in
          var lines: [String] = ["var col\(k): ColumnVector = s0 * rhs.columns.\(k)[0]"]
          for i in 1..<M {
            lines.append("col\(k) += s\(i) * rhs.columns.\(k)[\(i)]")
          }
          return lines
        }
        let tuple = "(" + (0..<resultColumnCount).map { "col\($0)" }.joined(separator: ", ") + ")"
        return [
          """
          @inlinable
          public func multiplied(onRightBy rhs: \(raw: rhsTypeName)) -> \(raw: resultTypeName) {
            \(raw: selfLets)
            \(raw: colBuilders.joined(separator: "\n  "))
            return \(raw: resultTypeName)(columns: \(raw: tuple))
          }
          """
        ]
      }
    case .storage, .wrapper:
      let wrap: String
      if isSelfResult {
        wrap = "Self(storage: storage.multiplied(onRightBy: rhs.storage))"
      } else {
        wrap = "\(resultTypeName)(storage: storage.multiplied(onRightBy: rhs.storage))"
      }
      return [
        """
        @inlinable
        public func multiplied(onRightBy rhs: \(raw: rhsTypeName)) -> \(raw: resultTypeName) {
          \(raw: wrap)
        }
        """
      ]
    }
  }

  /// Result column-vector spelled out as `SIMD<resultRowCount><scalar>` —
  /// for half-3-row results this is `SIMD3<Float16>`; for other half
  /// shapes the column-wise path isn't taken anyway.
  private func resultColumnVectorType(forResultRowCount resultRowCount: Int) -> String {
    "SIMD\(resultRowCount)<\(descriptor.representation.swiftScalarTypeName)>"
  }

  private func formRightMultiplicationDecl(
    rhsTypeName: String,
    nativeStrategy: NativeStrategy,
    in context: MatrixLayerContext
  ) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      switch nativeStrategy {
      case .swiftOperator:
        return [
          """
          @inlinable
          public mutating func formMultiplication(onRightBy rhs: \(raw: rhsTypeName)) {
            self = self * rhs
          }
          """
        ]
      case .simdMul:
        return [
          """
          @inlinable
          public mutating func formMultiplication(onRightBy rhs: \(raw: rhsTypeName)) {
            self = simd_mul(self, rhs)
          }
          """
        ]
      case .columnWise:
        return [
          """
          @inlinable
          public mutating func formMultiplication(onRightBy rhs: \(raw: rhsTypeName)) {
            self = multiplied(onRightBy: rhs)
          }
          """
        ]
      }
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public mutating func formMultiplication(onRightBy rhs: \(raw: rhsTypeName)) {
          storage.formMultiplication(onRightBy: rhs.storage)
        }
        """
      ]
    }
  }

  // MARK: - Left multiplications

  /// `lhs * self` for each compatible lhs shape (N, X).
  private func leftMultiplications(in context: MatrixLayerContext) -> [DeclSyntax] {
    let M = descriptor.columnCount
    let N = descriptor.rowCount
    var decls: [DeclSyntax] = []
    for X in 2...4 {
      let lhsRowCount = X
      let lhsColumnCount = N
      let resultRowCount = X
      let resultColumnCount = M
      if descriptor.isSquare && X == N { continue }
      let isSelfResult = (resultColumnCount == descriptor.columnCount && resultRowCount == descriptor.rowCount)
      let lhsTypeName = compatibleTypeName(rowCount: lhsRowCount, columnCount: lhsColumnCount)
      let resultTypeName = isSelfResult ? "Self" : compatibleTypeName(rowCount: resultRowCount, columnCount: resultColumnCount)
      let nativeStrategy = strategy(forResultRowCount: resultRowCount)

      decls.append(contentsOf: leftMultiplicationDecl(
        lhsTypeName: lhsTypeName,
        resultTypeName: resultTypeName,
        resultColumnCount: resultColumnCount,
        nativeStrategy: nativeStrategy,
        isSelfResult: isSelfResult,
        in: context
      ))

      if isSelfResult {
        decls.append(contentsOf: formLeftMultiplicationDecl(
          lhsTypeName: lhsTypeName,
          nativeStrategy: nativeStrategy,
          in: context
        ))
      }
    }
    return decls
  }

  private func leftMultiplicationDecl(
    lhsTypeName: String,
    resultTypeName: String,
    resultColumnCount: Int,
    nativeStrategy: NativeStrategy,
    isSelfResult: Bool,
    in context: MatrixLayerContext
  ) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      switch nativeStrategy {
      case .swiftOperator:
        return [
          """
          @inlinable
          public func multiplied(onLeftBy lhs: \(raw: lhsTypeName)) -> \(raw: resultTypeName) {
            lhs * self
          }
          """
        ]
      case .simdMul:
        return [
          """
          @inlinable
          public func multiplied(onLeftBy lhs: \(raw: lhsTypeName)) -> \(raw: resultTypeName) {
            simd_mul(lhs, self)
          }
          """
        ]
      case .columnWise:
        // For left-mult `lhs * self`, lhs has shape (N, X) with X = lhs.rowCount
        // = resultRowCount. Each lhs column is SIMD<X>; result columns are SIMD<X>.
        let N = descriptor.rowCount
        // For half-3-row result, the result-column vector type is SIMD3<Float16>.
        // We resolve via the result's row count (lhs.rowCount which is the same).
        // No explicit annotation is strictly required since lhs.columns.\(j) is
        // already typed; the imperative form makes type-checking cheap regardless.
        let lhsLets = (0..<N).map { j in "let l\(j) = lhs.columns.\(j)" }.joined(separator: "\n  ")
        let colBuilders: [String] = (0..<resultColumnCount).flatMap { k -> [String] in
          var lines: [String] = ["var col\(k) = l0 * self.columns.\(k)[0]"]
          for j in 1..<N {
            lines.append("col\(k) += l\(j) * self.columns.\(k)[\(j)]")
          }
          return lines
        }
        let tuple = "(" + (0..<resultColumnCount).map { "col\($0)" }.joined(separator: ", ") + ")"
        return [
          """
          @inlinable
          public func multiplied(onLeftBy lhs: \(raw: lhsTypeName)) -> \(raw: resultTypeName) {
            \(raw: lhsLets)
            \(raw: colBuilders.joined(separator: "\n  "))
            return \(raw: resultTypeName)(columns: \(raw: tuple))
          }
          """
        ]
      }
    case .storage, .wrapper:
      let wrap: String
      if isSelfResult {
        wrap = "Self(storage: storage.multiplied(onLeftBy: lhs.storage))"
      } else {
        wrap = "\(resultTypeName)(storage: storage.multiplied(onLeftBy: lhs.storage))"
      }
      return [
        """
        @inlinable
        public func multiplied(onLeftBy lhs: \(raw: lhsTypeName)) -> \(raw: resultTypeName) {
          \(raw: wrap)
        }
        """
      ]
    }
  }

  private func lhsColumnVectorType(forResultRowCount resultRowCount: Int) -> String {
    "SIMD\(resultRowCount)<\(descriptor.representation.swiftScalarTypeName)>"
  }

  private func formLeftMultiplicationDecl(
    lhsTypeName: String,
    nativeStrategy: NativeStrategy,
    in context: MatrixLayerContext
  ) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      switch nativeStrategy {
      case .swiftOperator:
        return [
          """
          @inlinable
          public mutating func formMultiplication(onLeftBy lhs: \(raw: lhsTypeName)) {
            self = lhs * self
          }
          """
        ]
      case .simdMul:
        return [
          """
          @inlinable
          public mutating func formMultiplication(onLeftBy lhs: \(raw: lhsTypeName)) {
            self = simd_mul(lhs, self)
          }
          """
        ]
      case .columnWise:
        return [
          """
          @inlinable
          public mutating func formMultiplication(onLeftBy lhs: \(raw: lhsTypeName)) {
            self = multiplied(onLeftBy: lhs)
          }
          """
        ]
      }
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public mutating func formMultiplication(onLeftBy lhs: \(raw: lhsTypeName)) {
          storage.formMultiplication(onLeftBy: lhs.storage)
        }
        """
      ]
    }
  }

  // MARK: - Helpers

  /// Resolves the appropriate `CompatibleMatrixCxR` typealias name (or `Self`)
  /// for a matrix of shape (rowCount, columnCount). Note: the typealias name
  /// uses Apple's `CxR` form, so we feed (columnCount, rowCount) in.
  private func compatibleTypeName(rowCount: Int, columnCount: Int) -> String {
    if rowCount == descriptor.rowCount && columnCount == descriptor.columnCount {
      return "Self"
    }
    return "CompatibleMatrix\(columnCount)x\(rowCount)"
  }

  // MARK: - Validation

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    var result: [DeclSyntax] = []
    result.append(contentsOf: rightMultValidations())
    result.append(contentsOf: leftMultValidations())
    return result
  }

  private func rightMultValidations() -> [DeclSyntax] {
    let M = descriptor.columnCount
    let N = descriptor.rowCount
    let scalar = descriptor.representation.swiftScalarTypeName
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    var decls: [DeclSyntax] = []
    for X in 2...4 {
      // Skip the square self-mul case (handled by SquareMultiplicationMacrolet).
      if descriptor.isSquare && X == M { continue }
      let resultRowCount = N
      let resultColumnCount = X
      // Skip when the half-precision result is 3-row (no independent ground truth).
      if descriptor.representation == .half && resultRowCount == 3 { continue }
      let rhsDescriptor = MatrixDescriptor(rowCount: M, columnCount: X, representation: descriptor.representation)
      let resultDescriptor = MatrixDescriptor(rowCount: resultRowCount, columnCount: resultColumnCount, representation: descriptor.representation)
      let rhsWrapperType = rhsDescriptor.wrapperTypeInstantiation
      let rhsNativeType = rhsDescriptor.nativeTypeName
      let resultWrapperType = resultDescriptor.wrapperTypeInstantiation
      let resultNativeType = resultDescriptor.nativeTypeName
      let testName = "test_rightMult_by_\(X)x\(M)"
      let nativeExpr: String
      switch descriptor.representation {
      case .half:           nativeExpr = "simd_mul(a, b)"
      case .float, .double: nativeExpr = "a * b"
      }
      decls.append(
        """
        func \(raw: testName)() {
          let lhses: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
          let rhses: [[[\(raw: scalar)]]] = \(raw: rhsDescriptor.probeMatricesArrayExpression)
          validateHeterogeneousBinaryEquivalence(
            "multiplied(onRightBy: \(raw: rhsWrapperType))",
            lhses: lhses,
            rhses: rhses,
            epsilon: \(raw: descriptor.defaultEpsilonLiteral),
            wrapped: { (a: \(raw: wrapper), b: \(raw: rhsWrapperType)) -> \(raw: resultWrapperType) in a.multiplied(onRightBy: b) },
            native: { (a: \(raw: native), b: \(raw: rhsNativeType)) -> \(raw: resultNativeType) in \(raw: nativeExpr) }
          )
        }
        """
      )
    }
    return decls
  }

  private func leftMultValidations() -> [DeclSyntax] {
    let M = descriptor.columnCount
    let N = descriptor.rowCount
    let scalar = descriptor.representation.swiftScalarTypeName
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    var decls: [DeclSyntax] = []
    for X in 2...4 {
      // Skip the square self-mul case (handled by SquareMultiplicationMacrolet).
      if descriptor.isSquare && X == N { continue }
      let resultRowCount = X
      let resultColumnCount = M
      // Skip when the half-precision result is 3-row.
      if descriptor.representation == .half && resultRowCount == 3 { continue }
      let lhsDescriptor = MatrixDescriptor(rowCount: X, columnCount: N, representation: descriptor.representation)
      let resultDescriptor = MatrixDescriptor(rowCount: resultRowCount, columnCount: resultColumnCount, representation: descriptor.representation)
      let lhsWrapperType = lhsDescriptor.wrapperTypeInstantiation
      let lhsNativeType = lhsDescriptor.nativeTypeName
      let resultWrapperType = resultDescriptor.wrapperTypeInstantiation
      let resultNativeType = resultDescriptor.nativeTypeName
      let testName = "test_leftMult_by_\(N)x\(X)"
      let nativeExpr: String
      switch descriptor.representation {
      case .half:           nativeExpr = "simd_mul(b, a)"
      case .float, .double: nativeExpr = "b * a"
      }
      decls.append(
        """
        func \(raw: testName)() {
          let lhses: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
          let rhses: [[[\(raw: scalar)]]] = \(raw: lhsDescriptor.probeMatricesArrayExpression)
          validateHeterogeneousBinaryEquivalence(
            "multiplied(onLeftBy: \(raw: lhsWrapperType))",
            lhses: lhses,
            rhses: rhses,
            epsilon: \(raw: descriptor.defaultEpsilonLiteral),
            wrapped: { (a: \(raw: wrapper), b: \(raw: lhsWrapperType)) -> \(raw: resultWrapperType) in a.multiplied(onLeftBy: b) },
            native: { (a: \(raw: native), b: \(raw: lhsNativeType)) -> \(raw: resultNativeType) in \(raw: nativeExpr) }
          )
        }
        """
      )
    }
    return decls
  }
}
