//
//  CommonMatrixManualValidation.swift
//
//  Generic base for the hand-written matrix invariant suites. Every test here
//  is written *generically* against an arbitrary wrapper matrix type `M`, and
//  operates on concrete, hand-picked probe values (no probe-sweep loops in the
//  test bodies). XCTest cannot run a generic class, so these tests execute only
//  via the fully-concrete leaves (e.g. `Matrix2x2_Float_Manual`), once per
//  `(shape, scalar)` combination.
//

import Foundation
import XCTest
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: CommonMatrixManualValidation
// -------------------------------------------------------------------------- //

/// Base suite of invariants common to *all* matrix shapes. Parameterised over
/// the concrete wrapper matrix type `M` (the leaves bind `M = MatrixNxM<T>`).
class CommonMatrixManualValidation<M>: XCTestCase
where
  M: MatrixProtocol,
  M: LInfinityDistanceMeasureable,
  M.Scalar: ExtendedSIMDScalar,
  M.LInfinityDistance == M.Scalar
{

  // ------------------------------------------------------------------------ //
  // MARK: Probe Hooks (overridden per shape with hand-picked values)
  // ------------------------------------------------------------------------ //

  /// Row-major (visual) entries for the primary probe. Distinct, asymmetric
  /// values so e.g. a row/column swap can't pass degenerately. Overridden in
  /// each size leaf with hand-picked literals; the default is a shape-correct
  /// ascending ramp.
  var primaryProbeRows: [[Int]] {
    (0..<M.rowCount).map { r in (0..<M.columnCount).map { c in r * M.columnCount + c + 1 } }
  }

  /// Row-major entries for a second, distinct probe (for commutativity,
  /// associativity, subtraction, …).
  var secondaryProbeRows: [[Int]] {
    (0..<M.rowCount).map { r in (0..<M.columnCount).map { c in 2 * (r * M.columnCount + c) + 3 } }
  }

  /// Row-major entries for a third, distinct probe (for associativity).
  var tertiaryProbeRows: [[Int]] {
    (0..<M.rowCount).map { r in (0..<M.columnCount).map { c in (r * M.columnCount + c) - 4 } }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Named Probes
  // ------------------------------------------------------------------------ //

  private(set) lazy var primaryProbe: M = makeProbe(primaryProbeRows)
  private(set) lazy var secondaryProbe: M = makeProbe(secondaryProbeRows)
  private(set) lazy var tertiaryProbe: M = makeProbe(tertiaryProbeRows)

  // ------------------------------------------------------------------------ //
  // MARK: Construction & Comparison Helpers
  // ------------------------------------------------------------------------ //

  /// Build a scalar of the matrix's representation from an `Int`.
  final func scalar(_ value: Int) -> M.Scalar { M.Scalar(value) }

  /// Build a probe matrix from a row-major `[[Int]]` literal, validating shape.
  final func makeProbe(
    _ rows: [[Int]],
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> M {
    precondition(
      rows.count == M.rowCount,
      "probe has \(rows.count) rows but \(M.self) needs \(M.rowCount) (in \(file):\(line))"
    )
    precondition(
      rows.allSatisfy { $0.count == M.columnCount },
      "probe has a row whose length != \(M.columnCount) columns for \(M.self) (in \(file):\(line))"
    )
    return M(scalars: rows.map { $0.map { M.Scalar($0) } })
  }

  /// Per-representation absolute tolerance. Defaults to the shared ladder
  /// (`1e-6`, or `0.05` for `Float16`); leaves may override for ops that lose
  /// more precision (e.g. half-precision inverse round-trips).
  var absoluteTolerance: M.Scalar { M.Scalar.validationTestTolerance }

  /// Assert two matrices are equal within `tolerance` (L∞), with a property-
  /// naming failure message.
  final func assertAlmostEqual(
    _ lhs: M,
    _ rhs: M,
    _ property: @autoclosure () -> String,
    tolerance: M.Scalar? = nil,
    file: StaticString = #filePath,
    line: UInt = #line,
    function: StaticString = #function
  ) {
    let tol = tolerance ?? absoluteTolerance
    let distance = lhs.lInfinityDistance(to: rhs)
    XCTAssertLessThanOrEqual(
      distance,
      tol,
      """
      [invariant] \(property()) — matrices differ: L∞ Δ = \(distance) > tol \(tol)
        lhs = \(lhs)
        rhs = \(rhs)
        in \(function)
      """,
      file: file,
      line: line
    )
  }

  /// Assert two scalars are exactly equal, with a property-naming message.
  final func assertScalarsEqual(
    _ lhs: M.Scalar,
    _ rhs: M.Scalar,
    _ property: @autoclosure () -> String,
    file: StaticString = #filePath,
    line: UInt = #line,
    function: StaticString = #function
  ) {
    XCTAssertEqual(
      lhs,
      rhs,
      "[invariant] \(property()) — \(lhs) != \(rhs) in \(function)",
      file: file,
      line: line
    )
  }

  /// Assert two scalars are equal within `tolerance`.
  final func assertScalarsAlmostEqual(
    _ lhs: M.Scalar,
    _ rhs: M.Scalar,
    _ property: @autoclosure () -> String,
    tolerance: M.Scalar? = nil,
    file: StaticString = #filePath,
    line: UInt = #line,
    function: StaticString = #function
  ) {
    let tol = tolerance ?? absoluteTolerance
    XCTAssertLessThanOrEqual(
      abs(lhs - rhs),
      tol,
      "[invariant] \(property()) — |Δ| = \(abs(lhs - rhs)) > tol \(tol): \(lhs) vs \(rhs) in \(function)",
      file: file,
      line: line
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Additive Group
  // ------------------------------------------------------------------------ //

  /// Commutativity of addition: `a + b == b + a`.
  func testAdditionIsCommutative() {
    let a = primaryProbe, b = secondaryProbe
    assertAlmostEqual(a.adding(b), b.adding(a), "Commutativity of addition: a + b == b + a")
  }

  /// Associativity of addition: `(a + b) + c == a + (b + c)`.
  func testAdditionIsAssociative() {
    let a = primaryProbe, b = secondaryProbe, c = tertiaryProbe
    assertAlmostEqual(
      a.adding(b).adding(c),
      a.adding(b.adding(c)),
      "Associativity of addition: (a + b) + c == a + (b + c)"
    )
  }

  /// Additive identity: `a + 0 == a` and `0 + a == a`.
  func testAdditiveIdentity() {
    let a = primaryProbe
    let zero = M()
    assertAlmostEqual(a.adding(zero), a, "Additive identity: a + 0 == a")
    assertAlmostEqual(zero.adding(a), a, "Additive identity: 0 + a == a")
  }

  /// Negation is the additive inverse: `a + (-a) == 0`.
  func testNegationIsAdditiveInverse() {
    let a = primaryProbe
    assertAlmostEqual(a.adding(a.negated()), M(), "Additive inverse: a + (-a) == 0")
  }

  /// Negation negates each entry: `a.negated()[c,r] == -a[c,r]`. (Concrete —
  /// the involution invariant alone is satisfied by the identity map.)
  func testNegationNegatesEachEntry() {
    let a = primaryProbe
    let negated = a.negated()
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          negated[columnIndex: c, rowIndex: r],
          scalar(0) - a[columnIndex: c, rowIndex: r],
          "Negation negates entry (col \(c), row \(r))"
        )
      }
    }
  }

  /// Double negation is the identity: `-(-a) == a`.
  func testDoubleNegationIsIdentity() {
    let a = primaryProbe
    assertAlmostEqual(a.negated().negated(), a, "Double negation: -(-a) == a")
  }

  /// Subtraction is addition of the negation: `a - b == a + (-b)`.
  func testSubtractionIsAddingNegation() {
    let a = primaryProbe, b = secondaryProbe
    assertAlmostEqual(a.subtracting(b), a.adding(b.negated()), "Subtraction: a - b == a + (-b)")
  }

  /// Subtraction is componentwise: `(a - b)[c,r] == a[c,r] - b[c,r]` (concrete).
  func testSubtractionIsComponentwise() {
    let a = primaryProbe, b = secondaryProbe
    let difference = a.subtracting(b)
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          difference[columnIndex: c, rowIndex: r],
          a[columnIndex: c, rowIndex: r] - b[columnIndex: c, rowIndex: r],
          "Componentwise subtraction at (col \(c), row \(r))"
        )
      }
    }
  }

  /// Self-subtraction yields zero: `a - a == 0`.
  func testSubtractionOfSelfIsZero() {
    let a = primaryProbe
    assertAlmostEqual(a.subtracting(a), M(), "Self subtraction: a - a == 0")
  }

  /// In-place additive ops agree with their out-of-place siblings.
  func testInPlaceAdditiveOpsMatch() {
    let a = primaryProbe, b = secondaryProbe
    var negated = a; negated.formNegation()
    assertAlmostEqual(negated, a.negated(), "formNegation() == negated()")
    var sum = a; sum.formAddition(of: b)
    assertAlmostEqual(sum, a.adding(b), "formAddition(of:) == adding(_:)")
    var difference = a; difference.formSubtraction(of: b)
    assertAlmostEqual(difference, a.subtracting(b), "formSubtraction(of:) == subtracting(_:)")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Arithmetic
  // ------------------------------------------------------------------------ //

  /// Scalar multiplication distributes over matrix addition:
  /// `s * (a + b) == s*a + s*b`.
  func testScalarMultiplicationDistributesOverMatrixAddition() {
    let a = primaryProbe, b = secondaryProbe, s = scalar(3)
    assertAlmostEqual(
      a.adding(b).multiplied(by: s),
      a.multiplied(by: s).adding(b.multiplied(by: s)),
      "Distributivity: s·(a + b) == s·a + s·b"
    )
  }

  /// Scalar multiplication by 1 is the identity and by 0 is the zero matrix;
  /// and `(a·s)[c,r] == s·a[c,r]` concretely.
  func testScalarMultiplicationIdentityAndZero() {
    let a = primaryProbe, s = scalar(2)
    assertAlmostEqual(a.multiplied(by: scalar(1)), a, "Scalar identity: a·1 == a")
    assertAlmostEqual(a.multiplied(by: scalar(0)), M(), "Scalar absorbing: a·0 == 0")
    let scaled = a.multiplied(by: s)
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          scaled[columnIndex: c, rowIndex: r],
          s * a[columnIndex: c, rowIndex: r],
          "Scalar multiplication at (col \(c), row \(r)): (a·s)[c,r] == s·a[c,r]"
        )
      }
    }
  }

  /// Scalar division inverts scalar multiplication: `(a·s)/s == a` for `s != 0`.
  func testScalarDivisionInvertsMultiplication() {
    let a = primaryProbe, s = scalar(2)
    assertAlmostEqual(a.multiplied(by: s).divided(by: s), a, "Scalar division inverts multiplication: (a·s)/s == a")
  }

  /// `adding(scalar:)` adds the scalar to *every* entry (concrete; the point is
  /// "all entries", not just the diagonal).
  func testScalarAdditionFillsAllEntries() {
    let a = primaryProbe, s = scalar(5)
    let result = a.adding(scalar: s)
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          result[columnIndex: c, rowIndex: r],
          a[columnIndex: c, rowIndex: r] + s,
          "Scalar addition fills entry (col \(c), row \(r))"
        )
      }
    }
    // round-trip: adding then subtracting the same scalar restores `a`.
    assertAlmostEqual(a.adding(scalar: s).subtracting(scalar: s), a, "Scalar add/subtract inverse")
  }

  /// `subtracting(scalar:)` subtracts the scalar from *every* entry (concrete).
  func testScalarSubtractionFillsAllEntries() {
    let a = primaryProbe, s = scalar(3)
    let result = a.subtracting(scalar: s)
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          result[columnIndex: c, rowIndex: r],
          a[columnIndex: c, rowIndex: r] - s,
          "Scalar subtraction fills entry (col \(c), row \(r))"
        )
      }
    }
  }

  /// In-place scalar ops agree with their out-of-place siblings.
  func testInPlaceScalarOpsMatch() {
    let a = primaryProbe, s = scalar(2)
    var scaled = a; scaled.formMultiplication(by: s)
    assertAlmostEqual(scaled, a.multiplied(by: s), "formMultiplication(by:) == multiplied(by:)")
    var divided = a; divided.formDivision(by: s)
    assertAlmostEqual(divided, a.divided(by: s), "formDivision(by:) == divided(by:)")
    var added = a; added.formAddition(ofScalar: s)
    assertAlmostEqual(added, a.adding(scalar: s), "formAddition(ofScalar:) == adding(scalar:)")
    var subtracted = a; subtracted.formSubtraction(ofScalar: s)
    assertAlmostEqual(subtracted, a.subtracting(scalar: s), "formSubtraction(ofScalar:) == subtracting(scalar:)")
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMA / FMS / Linear Combination
  // ------------------------------------------------------------------------ //

  /// FMA definition: `a.adding(b, multipliedBy: s) == a + (s·b)`, plus concrete
  /// per-entry check.
  func testFusedMultiplyAddDefinition() {
    let a = primaryProbe, b = secondaryProbe, s = scalar(2)
    let fma = a.adding(b, multipliedBy: s)
    assertAlmostEqual(fma, a.adding(b.multiplied(by: s)), "FMA: a.adding(b, ×s) == a + s·b")
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          fma[columnIndex: c, rowIndex: r],
          a[columnIndex: c, rowIndex: r] + s * b[columnIndex: c, rowIndex: r],
          "FMA at (col \(c), row \(r)): result == a + s·b"
        )
      }
    }
    var inPlace = a; inPlace.formAddition(of: b, multipliedBy: s)
    assertAlmostEqual(inPlace, fma, "formAddition(of:multipliedBy:) == adding(_:multipliedBy:)")
  }

  /// FMS definition: `a.subtracting(b, multipliedBy: s) == a - (s·b)`.
  func testFusedMultiplySubtractDefinition() {
    let a = primaryProbe, b = secondaryProbe, s = scalar(2)
    let fms = a.subtracting(b, multipliedBy: s)
    assertAlmostEqual(fms, a.subtracting(b.multiplied(by: s)), "FMS: a.subtracting(b, ×s) == a - s·b")
    var inPlace = a; inPlace.formSubtraction(of: b, multipliedBy: s)
    assertAlmostEqual(inPlace, fms, "formSubtraction(of:multipliedBy:) == subtracting(_:multipliedBy:)")
  }

  /// Linear combination: `linearCombination(of:a,weight:wa,with:b,weight:wb)
  /// == wa·a + wb·b`, plus concrete per-entry check.
  func testLinearCombinationDefinition() {
    let a = primaryProbe, b = secondaryProbe
    let wa = scalar(2), wb = scalar(3)
    let combination = M.linearCombination(of: a, weight: wa, with: b, weight: wb)
    assertAlmostEqual(
      combination,
      a.multiplied(by: wa).adding(b.multiplied(by: wb)),
      "Linear combination: wa·a + wb·b"
    )
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          combination[columnIndex: c, rowIndex: r],
          wa * a[columnIndex: c, rowIndex: r] + wb * b[columnIndex: c, rowIndex: r],
          "Linear combination at (col \(c), row \(r))"
        )
      }
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Norms / Almost-Equal
  // ------------------------------------------------------------------------ //

  /// `componentwiseMagnitudeSquared == Σ entry²` (concrete).
  func testComponentwiseMagnitudeSquared() {
    let a = primaryProbe
    var expected = scalar(0)
    for row in primaryProbeRows {
      for value in row {
        let entry = scalar(value)
        expected += entry * entry
      }
    }
    assertScalarsAlmostEqual(
      a.componentwiseMagnitudeSquared,
      expected,
      "componentwiseMagnitudeSquared == Σ entry²"
    )
    assertScalarsEqual(M().componentwiseMagnitudeSquared, scalar(0), "magnitude² of zero matrix is 0")
  }

  /// Magnitude scaling: `(a·s).componentwiseMagnitudeSquared == s²·(a.componentwiseMagnitudeSquared)`.
  func testComponentwiseMagnitudeSquaredScaling() {
    let a = primaryProbe, s = scalar(2)
    assertScalarsAlmostEqual(
      a.multiplied(by: s).componentwiseMagnitudeSquared,
      s * s * a.componentwiseMagnitudeSquared,
      "magnitude² scales by s²"
    )
  }

  /// `hasAlmostEqualElements` is reflexive, and a real perturbation is detected.
  func testHasAlmostEqualElements() {
    let a = primaryProbe
    XCTAssertTrue(
      a.hasAlmostEqualElements(to: a, absoluteTolerance: scalar(0)),
      "[invariant] hasAlmostEqualElements is reflexive at tolerance 0 for \(a)"
    )
    // perturb one entry by a clearly-detectable amount.
    var perturbedRows = primaryProbeRows
    perturbedRows[0][0] += 10
    let perturbed = makeProbe(perturbedRows)
    XCTAssertFalse(
      a.hasAlmostEqualElements(to: perturbed, absoluteTolerance: scalar(1)),
      "[invariant] hasAlmostEqualElements should reject a +10 perturbation at tolerance 1: \(a) vs \(perturbed)"
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Constructors & Round-Trips
  // ------------------------------------------------------------------------ //

  /// `init(scalars:)` places `scalars[r][c]` at (column c, row r) — concrete
  /// placement, the anchor against a row/column transposition bug.
  func testInitScalarsPlacement() {
    let a = primaryProbe
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          a[columnIndex: c, rowIndex: r],
          scalar(primaryProbeRows[r][c]),
          "init(scalars:) places scalars[\(r)][\(c)] at (col \(c), row \(r))"
        )
      }
    }
  }

  /// `init(repeating:)` fills every entry with the scalar.
  func testInitRepeatingFillsAllEntries() {
    let s = scalar(7)
    let filled = M(repeating: s)
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          filled[columnIndex: c, rowIndex: r],
          s,
          "init(repeating:) fills entry (col \(c), row \(r))"
        )
      }
    }
  }

  /// `init()` is the zero matrix.
  func testInitDefaultIsZero() {
    let zero = M()
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(zero[columnIndex: c, rowIndex: r], scalar(0), "init() zero at (col \(c), row \(r))")
      }
    }
  }

  /// `init(linearizedScalars:)` round-trips `linearizedScalars`.
  func testLinearizedScalarsRoundTrip() {
    let a = primaryProbe
    assertAlmostEqual(M(linearizedScalars: a.linearizedScalars), a, "init(linearizedScalars: a.linearizedScalars) == a")
  }

  /// `init(columns:)` round-trips `columns`.
  func testColumnsRoundTrip() {
    let a = primaryProbe
    assertAlmostEqual(M(columns: a.columns), a, "init(columns: a.columns) == a")
  }

  /// `init(rows:)` round-trips `rows`.
  func testRowsRoundTrip() {
    let a = primaryProbe
    assertAlmostEqual(M(rows: a.rows), a, "init(rows: a.rows) == a")
  }

  /// `init(columnVectors:)` round-trips `columnVectors`.
  func testColumnVectorsRoundTrip() {
    let a = primaryProbe
    assertAlmostEqual(M(columnVectors: a.columnVectors), a, "init(columnVectors: a.columnVectors) == a")
  }

  /// `init(rowVectors:)` round-trips `rowVectors`.
  func testRowVectorsRoundTrip() {
    let a = primaryProbe
    assertAlmostEqual(M(rowVectors: a.rowVectors), a, "init(rowVectors: a.rowVectors) == a")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subscript Consistency
  // ------------------------------------------------------------------------ //

  /// The column subscript and the (column, row) subscript agree:
  /// `m[columnIndex: c][r] == m[columnIndex: c, rowIndex: r]`.
  func testColumnSubscriptConsistency() {
    let a = primaryProbe
    for c in 0..<M.columnCount {
      let column = a[columnIndex: c]
      for r in 0..<M.rowCount {
        assertScalarsEqual(
          column[r],
          a[columnIndex: c, rowIndex: r],
          "column subscript agrees with (col \(c), row \(r)) subscript"
        )
      }
    }
  }

  /// The row subscript and the (column, row) subscript agree:
  /// `m[rowIndex: r][c] == m[columnIndex: c, rowIndex: r]`.
  func testRowSubscriptConsistency() {
    let a = primaryProbe
    for r in 0..<M.rowCount {
      let row = a[rowIndex: r]
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          row[c],
          a[columnIndex: c, rowIndex: r],
          "row subscript agrees with (col \(c), row \(r)) subscript"
        )
      }
    }
  }

  /// The position subscript and the (column, row) subscript agree.
  func testPositionSubscriptConsistency() {
    let a = primaryProbe
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        assertScalarsEqual(
          a[position: MatrixPosition(rowIndex: r, columnIndex: c)],
          a[columnIndex: c, rowIndex: r],
          "position subscript agrees with (col \(c), row \(r)) subscript"
        )
      }
    }
  }

  /// The linearized-scalar subscript agrees with the (column, row) subscript
  /// at the matching linearized index.
  func testLinearizedSubscriptConsistency() {
    let a = primaryProbe
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        let index = M.linearizedScalarIndex(forColumnIndex: c, rowIndex: r)
        assertScalarsEqual(
          a[linearizedScalarIndex: index],
          a[columnIndex: c, rowIndex: r],
          "linearized subscript (index \(index)) agrees with (col \(c), row \(r))"
        )
      }
    }
  }

  /// Index-math is a bijection: `columnRowIndex(linearizedScalarIndex(c,r)) == (c,r)`.
  func testLinearizationBijection() {
    for r in 0..<M.rowCount {
      for c in 0..<M.columnCount {
        let index = M.linearizedScalarIndex(forColumnIndex: c, rowIndex: r)
        let (rc, rr) = M.columnRowIndex(forLinearizedScalarIndex: index)
        assertScalarsEqual(scalar(rc), scalar(c), "linearization round-trip column at (col \(c), row \(r))")
        assertScalarsEqual(scalar(rr), scalar(r), "linearization round-trip row at (col \(c), row \(r))")
      }
    }
  }
}

// -------------------------------------------------------------------------- //
// MARK: NonSquareMatrixManualValidation
// -------------------------------------------------------------------------- //

/// Organizational tier for non-square shapes. The genuinely non-square algebra
/// (shape-changing transpose, cross-shape multiplication) is size-specific and
/// lives in the size leaves; this tier holds only what's expressible against
/// `MatrixProtocol`.
class NonSquareMatrixManualValidation<M>: CommonMatrixManualValidation<M>
where
  M: MatrixProtocol,
  M: LInfinityDistanceMeasureable,
  M.Scalar: ExtendedSIMDScalar,
  M.LInfinityDistance == M.Scalar
{
  /// A non-square matrix has differing row and column counts.
  func testShapeIsNonSquare() {
    XCTAssertNotEqual(
      M.rowCount,
      M.columnCount,
      "[invariant] \(M.self) is a non-square shape but rowCount (\(M.rowCount)) == columnCount (\(M.columnCount))"
    )
  }
}
