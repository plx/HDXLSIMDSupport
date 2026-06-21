//
//  ManualSquareMatrix.swift
//
//  There is intentionally no `SquareMatrixProtocol` in the library (it was
//  removed for compile-time reasons), so the square-only API — `determinant`,
//  `inverted()`, `transposed() -> Self`, square `multiplied(onRightBy: Self)`,
//  `identity`, … — is declared identically on `Matrix2x2Protocol`,
//  `Matrix3x3Protocol`, and `Matrix4x4Protocol`. To write the square invariant
//  tests *once* (rather than thrice), we introduce a thin *test-only* marker
//  protocol that surfaces exactly those uniform-signature members; the three
//  square wrappers satisfy it vacuously.
//

import Foundation
import XCTest
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: ManualSquareMatrix
// -------------------------------------------------------------------------- //

/// Test-only marker exposing the uniform-signature square-matrix API so the
/// `SquareMatrixManualValidation` tier can be written generically.
protocol ManualSquareMatrix: MatrixProtocol, LInfinityDistanceMeasureable
where Scalar: ExtendedSIMDScalar, LInfinityDistance == Scalar {

  static var identity: Self { get }

  var determinant: Scalar { get }

  func inverted() -> Self
  mutating func formInverse()

  func transposed() -> Self
  mutating func formTranspose()

  func multiplied(onRightBy rhs: Self) -> Self
  func multiplied(onLeftBy lhs: Self) -> Self
  mutating func formMultiplication(onRightBy rhs: Self)
  mutating func formMultiplication(onLeftBy lhs: Self)

  func divided(onRightBy rhs: Self) -> Self
  func divided(onLeftBy lhs: Self) -> Self
  mutating func formDivision(onRightBy rhs: Self)
  mutating func formDivision(onLeftBy lhs: Self)
}

// All members already exist on the wrappers via their per-size protocols, so
// these conformances are vacuous.
extension Matrix2x2: ManualSquareMatrix {}
extension Matrix3x3: ManualSquareMatrix {}
extension Matrix4x4: ManualSquareMatrix {}

// -------------------------------------------------------------------------- //
// MARK: SquareMatrixManualValidation
// -------------------------------------------------------------------------- //

/// Square-matrix algebraic invariants, written once and executed for every
/// square `(shape, scalar)` leaf. Concrete per-shape *values* (a specific
/// determinant, a specific inverse / product / transpose) live in the size
/// leaves, where the hand-computed expected matrices can be written out.
///
/// The probe matrices used here are deliberately small and well-conditioned
/// (upper/lower bidiagonal with diagonal `2`), so determinants stay within
/// `Float16`'s exact-integer range and inverses are dyadic (exactly
/// representable). That keeps these invariants meaningful even at half
/// precision.
class SquareMatrixManualValidation<M>: CommonMatrixManualValidation<M>
where
  M: ManualSquareMatrix,
  M.Scalar: ExtendedSIMDScalar,
  M.LInfinityDistance == M.Scalar
{

  // ------------------------------------------------------------------------ //
  // MARK: Square Probes
  // ------------------------------------------------------------------------ //

  /// Upper-bidiagonal, diagonal `2` → determinant `2^n`, dyadic inverse.
  var firstSquareProbeRows: [[Int]] {
    let n = M.rowCount
    return (0..<n).map { r in (0..<n).map { c in c == r ? 2 : (c == r + 1 ? 1 : 0) } }
  }

  /// Lower-bidiagonal, diagonal `2` (distinct from `firstSquareProbe`, and does
  /// not commute with it).
  var secondSquareProbeRows: [[Int]] {
    let n = M.rowCount
    return (0..<n).map { r in (0..<n).map { c in c == r ? 2 : (c == r - 1 ? 1 : 0) } }
  }

  /// A third small matrix (upper-bidiagonal, diagonal `1`, off-diagonal `-1`).
  var thirdSquareProbeRows: [[Int]] {
    let n = M.rowCount
    return (0..<n).map { r in (0..<n).map { c in c == r ? 1 : (c == r + 1 ? -1 : 0) } }
  }

  private(set) lazy var firstSquareProbe: M = makeProbe(firstSquareProbeRows)
  private(set) lazy var secondSquareProbe: M = makeProbe(secondSquareProbeRows)
  private(set) lazy var thirdSquareProbe: M = makeProbe(thirdSquareProbeRows)

  // ------------------------------------------------------------------------ //
  // MARK: Shape
  // ------------------------------------------------------------------------ //

  /// A square matrix has equal row and column counts.
  func testShapeIsSquare() {
    XCTAssertEqual(
      M.rowCount,
      M.columnCount,
      "[invariant] \(M.self) is a square shape but rowCount (\(M.rowCount)) != columnCount (\(M.columnCount))"
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Identity
  // ------------------------------------------------------------------------ //

  /// The identity has `1` on the diagonal and `0` elsewhere (concrete — anchors
  /// every "≈ identity" test below).
  func testIdentityIsConcrete() {
    let identity = M.identity
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          identity[columnIndex: c, rowIndex: r],
          c == r ? scalar(1) : scalar(0),
          "identity has \(c == r ? "1" : "0") at (col \(c), row \(r))"
        )
      }
    }
  }

  /// `init(diagonal:)` (via `identity`'s construction) is exercised by the
  /// identity-is-concrete test; here we additionally assert `det(identity) == 1`.
  func testDeterminantOfIdentityIsOne() {
    assertScalarsAlmostEqual(M.identity.determinant, scalar(1), "det(identity) == 1")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Multiplication Ring
  // ------------------------------------------------------------------------ //

  /// Multiplicative identity: `a·I == a` and `I·a == a`.
  func testMultiplicationByIdentity() {
    let a = firstSquareProbe
    assertAlmostEqual(a.multiplied(onRightBy: M.identity), a, "a·I == a")
    assertAlmostEqual(a.multiplied(onLeftBy: M.identity), a, "I·a == a")
  }

  /// Associativity of multiplication: `(a·b)·c == a·(b·c)`.
  func testMultiplicationIsAssociative() {
    let a = firstSquareProbe, b = secondSquareProbe, c = thirdSquareProbe
    assertAlmostEqual(
      a.multiplied(onRightBy: b).multiplied(onRightBy: c),
      a.multiplied(onRightBy: b.multiplied(onRightBy: c)),
      "Associativity of multiplication: (a·b)·c == a·(b·c)"
    )
  }

  /// Multiplication distributes over addition: `a·(b + c) == a·b + a·c`.
  func testMultiplicationDistributesOverAddition() {
    let a = firstSquareProbe, b = secondSquareProbe, c = thirdSquareProbe
    assertAlmostEqual(
      a.multiplied(onRightBy: b.adding(c)),
      a.multiplied(onRightBy: b).adding(a.multiplied(onRightBy: c)),
      "Distributivity: a·(b + c) == a·b + a·c"
    )
  }

  /// `multiplied(onLeftBy:)` is `multiplied(onRightBy:)` with operands swapped:
  /// `a.multiplied(onLeftBy: b) == b.multiplied(onRightBy: a)`.
  func testMultiplicationLeftRightDuality() {
    let a = firstSquareProbe, b = secondSquareProbe
    assertAlmostEqual(
      a.multiplied(onLeftBy: b),
      b.multiplied(onRightBy: a),
      "Left/right duality: a.multiplied(onLeftBy: b) == b.multiplied(onRightBy: a)"
    )
  }

  /// Matrix multiplication is non-commutative: there exist a, b with `a·b ≠ b·a`.
  func testMultiplicationIsNonCommutative() {
    let a = firstSquareProbe, b = secondSquareProbe
    let ab = a.multiplied(onRightBy: b)
    let ba = b.multiplied(onRightBy: a)
    let distance = ab.lInfinityDistance(to: ba)
    XCTAssertGreaterThan(
      distance,
      absoluteTolerance,
      """
      [invariant] Non-commutativity witness: a·b should differ from b·a, but L∞ Δ = \(distance) ≤ tol \(absoluteTolerance)
        a·b = \(ab)
        b·a = \(ba)
      """
    )
  }

  /// In-place multiplication agrees with the out-of-place siblings.
  func testInPlaceMultiplicationMatches() {
    let a = firstSquareProbe, b = secondSquareProbe
    var right = a; right.formMultiplication(onRightBy: b)
    assertAlmostEqual(right, a.multiplied(onRightBy: b), "formMultiplication(onRightBy:) == multiplied(onRightBy:)")
    var left = a; left.formMultiplication(onLeftBy: b)
    assertAlmostEqual(left, a.multiplied(onLeftBy: b), "formMultiplication(onLeftBy:) == multiplied(onLeftBy:)")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Determinant
  // ------------------------------------------------------------------------ //

  /// Determinant is multiplicative: `det(a·b) == det(a)·det(b)`.
  func testDeterminantIsMultiplicative() {
    let a = firstSquareProbe, b = secondSquareProbe
    assertScalarsAlmostEqual(
      a.multiplied(onRightBy: b).determinant,
      a.determinant * b.determinant,
      "det(a·b) == det(a)·det(b)"
    )
  }

  /// Determinant is transpose-invariant: `det(aᵀ) == det(a)`.
  func testDeterminantIsTransposeInvariant() {
    let a = firstSquareProbe
    assertScalarsAlmostEqual(a.transposed().determinant, a.determinant, "det(aᵀ) == det(a)")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Inversion / Division
  // ------------------------------------------------------------------------ //

  /// Inverse round-trips: `a·a⁻¹ ≈ I` and `a⁻¹·a ≈ I`.
  func testInverseRoundTrips() {
    let a = firstSquareProbe
    let inverse = a.inverted()
    assertAlmostEqual(a.multiplied(onRightBy: inverse), M.identity, "a·a⁻¹ ≈ I")
    assertAlmostEqual(inverse.multiplied(onRightBy: a), M.identity, "a⁻¹·a ≈ I")
  }

  /// Inverse is an involution: `(a⁻¹)⁻¹ ≈ a`.
  func testInverseIsInvolution() {
    let a = firstSquareProbe
    assertAlmostEqual(a.inverted().inverted(), a, "(a⁻¹)⁻¹ ≈ a")
  }

  /// Inverse of a product: `(a·b)⁻¹ ≈ b⁻¹·a⁻¹`.
  func testInverseOfProduct() {
    let a = firstSquareProbe, b = secondSquareProbe
    assertAlmostEqual(
      a.multiplied(onRightBy: b).inverted(),
      b.inverted().multiplied(onRightBy: a.inverted()),
      "(a·b)⁻¹ ≈ b⁻¹·a⁻¹"
    )
  }

  /// Determinant of the inverse: `det(a⁻¹) ≈ 1/det(a)`.
  func testDeterminantOfInverse() {
    let a = firstSquareProbe
    assertScalarsAlmostEqual(a.inverted().determinant, scalar(1) / a.determinant, "det(a⁻¹) ≈ 1/det(a)")
  }

  /// In-place inverse matches the out-of-place sibling.
  func testInPlaceInverseMatches() {
    let a = firstSquareProbe
    var inverted = a; inverted.formInverse()
    assertAlmostEqual(inverted, a.inverted(), "formInverse() == inverted()")
  }

  /// Right division is multiplication by the right operand's inverse:
  /// `a.divided(onRightBy: b) ≈ a·b⁻¹`.
  func testDivisionRightDefinition() {
    let a = firstSquareProbe, b = secondSquareProbe
    assertAlmostEqual(
      a.divided(onRightBy: b),
      a.multiplied(onRightBy: b.inverted()),
      "a.divided(onRightBy: b) ≈ a·b⁻¹"
    )
  }

  /// Left division is `b⁻¹·a` (NOT `a·b⁻¹`): `a.divided(onLeftBy: b) ≈ b⁻¹·a`.
  func testDivisionLeftDefinition() {
    let a = firstSquareProbe, b = secondSquareProbe
    assertAlmostEqual(
      a.divided(onLeftBy: b),
      b.inverted().multiplied(onRightBy: a),
      "a.divided(onLeftBy: b) ≈ b⁻¹·a"
    )
  }

  /// In-place division matches the out-of-place siblings.
  func testInPlaceDivisionMatches() {
    let a = firstSquareProbe, b = secondSquareProbe
    var right = a; right.formDivision(onRightBy: b)
    assertAlmostEqual(right, a.divided(onRightBy: b), "formDivision(onRightBy:) == divided(onRightBy:)")
    var left = a; left.formDivision(onLeftBy: b)
    assertAlmostEqual(left, a.divided(onLeftBy: b), "formDivision(onLeftBy:) == divided(onLeftBy:)")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Transpose (square → Self)
  // ------------------------------------------------------------------------ //

  /// Transpose swaps entries: `aᵀ[col c, row r] == a[col r, row c]` (concrete,
  /// on an asymmetric probe so the identity map can't pass).
  func testTransposeSwapsEntries() {
    let a = primaryProbe
    let transposed = a.transposed()
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          transposed[columnIndex: c, rowIndex: r],
          a[columnIndex: r, rowIndex: c],
          "transpose places (col \(r), row \(c)) at (col \(c), row \(r))"
        )
      }
    }
  }

  /// Transpose is an involution: `aᵀᵀ == a`.
  func testTransposeIsInvolution() {
    let a = primaryProbe
    assertAlmostEqual(a.transposed().transposed(), a, "aᵀᵀ == a")
  }

  /// Transpose of a sum: `(a + b)ᵀ == aᵀ + bᵀ`.
  func testTransposeOfSum() {
    let a = primaryProbe, b = secondaryProbe
    assertAlmostEqual(
      a.adding(b).transposed(),
      a.transposed().adding(b.transposed()),
      "(a + b)ᵀ == aᵀ + bᵀ"
    )
  }

  /// Transpose of a product reverses order: `(a·b)ᵀ == bᵀ·aᵀ`.
  func testTransposeOfProduct() {
    let a = firstSquareProbe, b = secondSquareProbe
    assertAlmostEqual(
      a.multiplied(onRightBy: b).transposed(),
      b.transposed().multiplied(onRightBy: a.transposed()),
      "(a·b)ᵀ == bᵀ·aᵀ"
    )
  }

  /// In-place transpose matches the out-of-place sibling.
  func testInPlaceTransposeMatches() {
    let a = primaryProbe
    var transposed = a; transposed.formTranspose()
    assertAlmostEqual(transposed, a.transposed(), "formTranspose() == transposed()")
  }
}
