//
//  TransposeMacrolet.swift
//

import SwiftSyntax

/// Transpose support.
///
/// - Square: `transposed() -> Self` and `formTranspose()`. Implementation uses
///   the native simd `.transpose` property (except for half-3x3, which
///   returns a buggy half-3-row shape and so uses column-wise pure Swift).
/// - Non-square: `transposed() -> CompatibleMatrixNxM` where the shape swaps
///   (no `formTranspose()` because the type changes). For half-precision
///   shapes whose transpose result is 3-row, uses pure-Swift fallback.
struct TransposeMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    if descriptor.isSquare {
      return squareTransposeDeclarations(in: context)
    } else {
      return nonSquareTransposeDeclarations(in: context)
    }
  }

  /// True iff transpose needs a column-wise pure-Swift fallback. For half
  /// representation we always emit the fallback (the Swift simd overlay
  /// doesn't expose `.transpose` on `simd_halfNxM` at all, and for half-3-row
  /// results the simd_transpose C function is miscomputed).
  private var transposeIsBuggy: Bool {
    descriptor.representation == .half
  }

  /// Build the columns-tuple expression for a manual transpose. The result
  /// has shape (columnCount=descriptor.rowCount, rowCount=descriptor.columnCount).
  /// For result column j (j in 0..<descriptor.rowCount), the column is built
  /// from `self.columns.0[j], self.columns.1[j], ..., self.columns.M-1[j]`
  /// where M == descriptor.columnCount.
  private func manualTransposeColumnsTuple(of selfRef: String, resultColumnVectorType: String) -> String {
    let resultColumnCount = descriptor.rowCount
    let M = descriptor.columnCount
    let cols = (0..<resultColumnCount).map { j -> String in
      let entries = (0..<M).map { i in "\(selfRef).columns.\(i)[\(j)]" }.joined(separator: ",")
      return "\(resultColumnVectorType)(\(entries))"
    }
    return "(" + cols.joined(separator: ",") + ")"
  }

  private var transposeResultColumnVectorType: String {
    // The result has columnVector length M (= descriptor.columnCount), scalar
    // matches representation.
    "SIMD\(descriptor.columnCount)<\(descriptor.representation.swiftScalarTypeName)>"
  }

  private func squareTransposeDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if transposeIsBuggy {
        let tuple = manualTransposeColumnsTuple(of: "self", resultColumnVectorType: transposeResultColumnVectorType)
        return [
          """
          @inlinable
          public func transposed() -> Self {
            Self(columns: \(raw: tuple))
          }
          """,
          """
          @inlinable
          public mutating func formTranspose() {
            self = transposed()
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func transposed() -> Self { self.transpose }
        """,
        """
        @inlinable
        public mutating func formTranspose() { self = self.transpose }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func transposed() -> Self {
          Self(storage: storage.transposed())
        }
        """,
        """
        @inlinable
        public mutating func formTranspose() {
          storage.formTranspose()
        }
        """
      ]
    }
  }

  private func nonSquareTransposeDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let transposeShape = descriptor.transposed
    let transposeTypealias = "CompatibleMatrix\(transposeShape.columnCount)x\(transposeShape.rowCount)"
    switch context.layer {
    case .native:
      if transposeIsBuggy {
        let tuple = manualTransposeColumnsTuple(of: "self", resultColumnVectorType: transposeResultColumnVectorType)
        return [
          """
          @inlinable
          public func transposed() -> \(raw: transposeTypealias) {
            \(raw: transposeTypealias)(columns: \(raw: tuple))
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func transposed() -> \(raw: transposeTypealias) {
          self.transpose
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func transposed() -> \(raw: transposeTypealias) {
          \(raw: transposeTypealias)(storage: storage.transposed())
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    // Only validate square transpose for now (result == Self). Non-square
    // transpose returns a different shape; the helper would need a separate
    // signature.
    guard descriptor.isSquare else { return [] }
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let nativeTranspose: String
    switch descriptor.representation {
    case .half:  nativeTranspose = "simd_transpose(m)"
    case .float, .double: nativeTranspose = "m.transpose"
    }
    return [
      """
      func test_transpose() {
        let probes: [[[\(raw: descriptor.representation.swiftScalarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateUnaryEquivalence(
          "transposed",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) in m.transposed() },
          native: { (m: \(raw: native)) -> \(raw: native) in \(raw: nativeTranspose) }
        )
      }
      """
    ]
  }
}
