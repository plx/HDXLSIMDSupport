//
//  ManualMatrixProductOracle.swift
//
//  Shared helpers for the size-specific (leaf) manual suites: a textbook
//  matrix-product oracle and a cross-type comparison helper. The oracle is an
//  independent, integer-exact reference implementation of matrix multiplication
//  (the mathematical *definition*), used to check cross-shape products without
//  error-prone hand-arithmetic. Each leaf still hand-anchors at least one
//  product / transpose with literal expected values; the oracle covers the rest
//  of each shape's multiplication menu.
//

import Foundation
import XCTest
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Row-Major Reference Operations (integer-exact)
// -------------------------------------------------------------------------- //

/// Textbook matrix product of two row-major `[[Int]]` matrices.
///
/// `lhs` is `(rL × cL)` and `rhs` is `(rR × cR)`, requiring `cL == rR`; the
/// result is `(rL × cR)` with `result[i][j] == Σ_k lhs[i][k]·rhs[k][j]`.
///
/// Because the wrapper's `init(scalars:)` takes the *visual* (row-major) matrix,
/// feeding the operands' `…ProbeRows` straight in and building the expected
/// result via the result type's `init(scalars:)` Just Works for every shape.
func standardMatrixProduct(_ lhs: [[Int]], _ rhs: [[Int]]) -> [[Int]] {
  let rowsL = lhs.count
  let colsL = lhs.first?.count ?? 0
  let rowsR = rhs.count
  let colsR = rhs.first?.count ?? 0
  precondition(colsL == rowsR, "incompatible shapes for product: \(rowsL)x\(colsL) · \(rowsR)x\(colsR)")
  return (0..<rowsL).map { i in
    (0..<colsR).map { j in
      (0..<colsL).reduce(0) { partial, k in partial + lhs[i][k] * rhs[k][j] }
    }
  }
}

/// Row-major transpose of an `[[Int]]` matrix.
func transposedRows(_ rows: [[Int]]) -> [[Int]] {
  guard let first = rows.first else { return [] }
  return (0..<first.count).map { c in rows.map { $0[c] } }
}

// -------------------------------------------------------------------------- //
// MARK: Typed Construction & Comparison
// -------------------------------------------------------------------------- //

/// Build a matrix of an arbitrary wrapper type `R` from row-major `[[Int]]`.
func matrix<R>(
  _ type: R.Type,
  _ rows: [[Int]]
) -> R where R: MatrixProtocol {
  precondition(rows.count == R.rowCount, "row count \(rows.count) != \(R.rowCount) for \(R.self)")
  precondition(rows.allSatisfy { $0.count == R.columnCount }, "column count mismatch for \(R.self)")
  return R(scalars: rows.map { $0.map { R.Scalar($0) } })
}

/// Assert two matrices of an arbitrary (possibly non-`Self`) wrapper type `R`
/// are equal within `tolerance`, with a property-naming failure message.
func assertMatricesAlmostEqual<R>(
  _ actual: R,
  _ expected: R,
  _ property: @autoclosure () -> String,
  tolerance: R.Scalar,
  file: StaticString = #filePath,
  line: UInt = #line,
  function: StaticString = #function
) where
  R: MatrixProtocol,
  R: LInfinityDistanceMeasureable,
  R.LInfinityDistance == R.Scalar
{
  let distance = actual.lInfinityDistance(to: expected)
  XCTAssertLessThanOrEqual(
    distance,
    tolerance,
    """
    [invariant] \(property()) — matrices differ: L∞ Δ = \(distance) > tol \(tolerance)
      actual   = \(actual)
      expected = \(expected)
      in \(function)
    """,
    file: file,
    line: line
  )
}
