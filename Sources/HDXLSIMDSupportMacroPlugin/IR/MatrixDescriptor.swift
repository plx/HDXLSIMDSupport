//
//  MatrixDescriptor.swift
//

import SwiftSyntax

/// The minimal IR that drives matrix macro expansion. Three fields name *every*
/// distinguishing property of a concrete matrix shape:
///
/// - `rowCount`: number of rows (2, 3, or 4)
/// - `columnCount`: number of columns (2, 3, or 4)
/// - `representation`: scalar precision (.half / .float / .double)
///
/// Everything else — type names, vector sizes, transpose target, compatible
/// matrices, square-only operations — is derived.
struct MatrixDescriptor: Equatable {
  let rowCount: Int
  let columnCount: Int
  let representation: MatrixRepresentation

  init(rowCount: Int, columnCount: Int, representation: MatrixRepresentation) {
    precondition((2...4).contains(rowCount), "rowCount must be in 2...4 (got \(rowCount))")
    precondition((2...4).contains(columnCount), "columnCount must be in 2...4 (got \(columnCount))")
    self.rowCount = rowCount
    self.columnCount = columnCount
    self.representation = representation
  }

  // MARK: Shape predicates

  /// `true` iff `rowCount == columnCount`.
  var isSquare: Bool { rowCount == columnCount }

  /// `true` iff the row count is 3. Half-precision shapes with a 3-row layout
  /// hit overlay bugs in the simd bridge; macrolets that emit native-style
  /// implementations must take this into account.
  var hasThreeRowColumns: Bool { rowCount == 3 }

  /// The transpose of this matrix shape (swap rows/cols).
  var transposed: MatrixDescriptor {
    MatrixDescriptor(rowCount: columnCount, columnCount: rowCount, representation: representation)
  }

  // MARK: Names

  /// Pretty shape label like `2x2`, `3x4`, ...
  var shapeLabel: String { "\(columnCount)x\(rowCount)" }

  /// C-bridged simd type for this shape, e.g. `simd_float2x2`.
  var nativeTypeName: String {
    "\(representation.simdTypePrefix)\(columnCount)x\(rowCount)"
  }

  /// Storage type name, e.g. `FloatMatrix2x2Storage`.
  var storageTypeName: String {
    "\(representation.storageTypeNamePrefix)Matrix\(shapeLabel)Storage"
  }

  /// Wrapper struct name (generic over the scalar), e.g. `Matrix2x2`. This is
  /// the type users instantiate as `Matrix2x2<Float>`.
  var wrapperTypeName: String { "Matrix\(shapeLabel)" }

  /// Concrete-protocol name, e.g. `Matrix2x2Protocol`.
  var concreteProtocolName: String { "Matrix\(shapeLabel)Protocol" }

  /// SIMD vector type name for column / row / diagonal vectors.
  /// e.g. for a 4x2 matrix the column vector is `SIMD2<Float>` and the row
  /// vector is `SIMD4<Float>`.
  var columnVectorTypeName: String { "SIMD\(rowCount)<\(representation.swiftScalarTypeName)>" }
  var rowVectorTypeName: String { "SIMD\(columnCount)<\(representation.swiftScalarTypeName)>" }
  /// For non-square matrices the diagonal length is `min(rowCount, columnCount)`.
  var diagonalVectorTypeName: String {
    "SIMD\(Swift.min(rowCount, columnCount))<\(representation.swiftScalarTypeName)>"
  }

  /// True iff a matrix-returning native simd operation on this shape is
  /// miscomputed by the Swift simd overlay on macOS 26 (Float16 only).
  ///
  /// The bug is that any C-level `simd_*` routine that *produces* a
  /// `simd_halfNx3` shape returns wrong values. So for half-precision shapes
  /// with 3 rows, operations that yield "the same shape" (negation, addition,
  /// scalar multiplication, etc.) must be implemented in pure Swift by
  /// composing per-column operations.
  ///
  /// Operations that DON'T produce a half-3-row matrix (e.g. `determinant`
  /// returning a scalar, or `transposed()` from a 3-row to a non-3-row shape)
  /// continue to use the native simd routines because those return values are
  /// correct.
  var producesBuggyHalfThreeRow: Bool {
    representation == .half && rowCount == 3
  }

  /// True iff the descriptor's representation lacks the matrix-level Swift
  /// operators (`+`, `-`, `*`, `*=`, ...) on the simd type.
  ///
  /// Specifically: `simd_halfNxM` does not have the operator overloads that
  /// `simd_floatNxM` and `simd_doubleNxM` have. So for the half representation
  /// we have to use either the C-level `simd_add` / `simd_sub` / `simd_mul`
  /// routines (which still misbehave for half-3-row results) or pure-Swift
  /// column-wise composition.
  ///
  /// We pick column-wise pure Swift uniformly for the half representation:
  /// it's correct in every case (including 3-row), it's the same Swift
  /// vector operations the C routines lower to, and it keeps the generated
  /// source uniform.
  var usesColumnWiseSwiftFallback: Bool {
    representation == .half
  }

  // MARK: Compatible matrices

  /// Compatible matrix shape `MxN` (in the same representation) given an
  /// (m, n) pair, or `nil` if the pair isn't a supported shape.
  func compatibleDescriptor(rowCount otherRowCount: Int, columnCount otherColumnCount: Int) -> MatrixDescriptor? {
    guard (2...4).contains(otherRowCount), (2...4).contains(otherColumnCount) else {
      return nil
    }
    return MatrixDescriptor(
      rowCount: otherRowCount,
      columnCount: otherColumnCount,
      representation: representation
    )
  }
}
