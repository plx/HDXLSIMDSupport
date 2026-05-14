//
//  MatrixDistanceSanityTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class MatrixDistanceSanityTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Individual Validators
  // ------------------------------------------------------------------------ //
  //
  // Each helper takes `l1` / `lInf` *closures* rather than calling the methods
  // directly. The aggregate then runs every helper twice — once against the
  // canonical `l1Distance` / `lInfinityDistance`, once against the generic
  // reference `_l1Distance` / `_lInfinityDistance` — so the same battery of
  // sanity checks verifies *both* code paths.

  /// Sanity check: zero/self-distance is zero for any matrix.
  internal func validateSelfDistanceIsZero<Matrix>(
    forMatrix matrix: Matrix.Type,
    using label: String,
    l1: (Matrix, Matrix) -> Matrix.Scalar,
    lInf: (Matrix, Matrix) -> Matrix.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol,
    Matrix: L1DistanceMeasureable,
    Matrix: LInfinityDistanceMeasureable,
    Matrix.L1Distance == Matrix.Scalar,
    Matrix.LInfinityDistance == Matrix.Scalar
  {
    let zero = Matrix()
    XCTAssertEqual(
      l1(zero, zero),
      0,
      "[\(label)] `\(String(reflecting: matrix))`: expected `l1(zero, zero) == 0`.",
      file: file,
      line: line
    )
    XCTAssertEqual(
      lInf(zero, zero),
      0,
      "[\(label)] `\(String(reflecting: matrix))`: expected `lInf(zero, zero) == 0`.",
      file: file,
      line: line
    )

    var populated = Matrix()
    var nextValue: Matrix.Scalar = 1
    for position in Matrix.matrixPositions {
      populated[position: position] = nextValue
      nextValue += 1
    }
    XCTAssertEqual(
      l1(populated, populated),
      0,
      "[\(label)] `\(String(reflecting: matrix))`: expected `l1(populated, populated) == 0`.",
      file: file,
      line: line
    )
    XCTAssertEqual(
      lInf(populated, populated),
      0,
      "[\(label)] `\(String(reflecting: matrix))`: expected `lInf(populated, populated) == 0`.",
      file: file,
      line: line
    )
  }

  /// For every `(position, value)` pair, the matrix with `value` at `position` (and
  /// zeros elsewhere) must be exactly `|value|` away from the zero matrix in both
  /// L1 and L∞. If any slot is silently dropped this fails; if the helper indexes
  /// a row that doesn't exist this traps.
  internal func validateSingleEntryDistanceFromZero<Matrix>(
    forMatrix matrix: Matrix.Type,
    using label: String,
    l1: (Matrix, Matrix) -> Matrix.Scalar,
    lInf: (Matrix, Matrix) -> Matrix.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol,
    Matrix: L1DistanceMeasureable,
    Matrix: LInfinityDistanceMeasureable,
    Matrix.L1Distance == Matrix.Scalar,
    Matrix.LInfinityDistance == Matrix.Scalar
  {
    let zero = Matrix()
    let values: [Matrix.Scalar] = [1, -1, 2, -2]
    for position in Matrix.matrixPositions {
      for value in values {
        var single = Matrix()
        single[position: position] = value
        let expected = abs(value)

        XCTAssertEqual(
          l1(single, zero),
          expected,
          "[\(label)] `\(String(reflecting: matrix))` at \(position) with value \(value): expected `l1(single, zero) == \(expected)`.",
          file: file,
          line: line
        )
        XCTAssertEqual(
          lInf(single, zero),
          expected,
          "[\(label)] `\(String(reflecting: matrix))` at \(position) with value \(value): expected `lInf(single, zero) == \(expected)`.",
          file: file,
          line: line
        )
        XCTAssertEqual(
          l1(zero, single),
          expected,
          "[\(label)] `\(String(reflecting: matrix))` at \(position) with value \(value): expected `l1(zero, single) == \(expected)` (symmetric).",
          file: file,
          line: line
        )
        XCTAssertEqual(
          lInf(zero, single),
          expected,
          "[\(label)] `\(String(reflecting: matrix))` at \(position) with value \(value): expected `lInf(zero, single) == \(expected)` (symmetric).",
          file: file,
          line: line
        )
      }
    }
  }

  /// Cartesian sweep of single-entry matrices against each other.
  ///
  /// - same position: L1 = L∞ = `|v₁ - v₂|`
  /// - distinct positions: L1 = `|v₁| + |v₂|`, L∞ = `max(|v₁|, |v₂|)`
  internal func validateSingleEntryPairDistances<Matrix>(
    forMatrix matrix: Matrix.Type,
    using label: String,
    l1: (Matrix, Matrix) -> Matrix.Scalar,
    lInf: (Matrix, Matrix) -> Matrix.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol,
    Matrix: L1DistanceMeasureable,
    Matrix: LInfinityDistanceMeasureable,
    Matrix.L1Distance == Matrix.Scalar,
    Matrix.LInfinityDistance == Matrix.Scalar
  {
    let positions = Matrix.matrixPositions
    let values: [Matrix.Scalar] = [1, -1]
    for pos1 in positions {
      for value1 in values {
        var m1 = Matrix()
        m1[position: pos1] = value1
        for pos2 in positions {
          for value2 in values {
            var m2 = Matrix()
            m2[position: pos2] = value2

            let expectedL1: Matrix.Scalar
            let expectedLInf: Matrix.Scalar
            if pos1 == pos2 {
              let diff = abs(value1 - value2)
              expectedL1 = diff
              expectedLInf = diff
            } else {
              let a1 = abs(value1)
              let a2 = abs(value2)
              expectedL1 = a1 + a2
              expectedLInf = max(a1, a2)
            }

            XCTAssertEqual(
              l1(m1, m2),
              expectedL1,
              "[\(label)] `\(String(reflecting: matrix))`: m1@\(pos1)=\(value1), m2@\(pos2)=\(value2): expected `l1 == \(expectedL1)`.",
              file: file,
              line: line
            )
            XCTAssertEqual(
              lInf(m1, m2),
              expectedLInf,
              "[\(label)] `\(String(reflecting: matrix))`: m1@\(pos1)=\(value1), m2@\(pos2)=\(value2): expected `lInf == \(expectedLInf)`.",
              file: file,
              line: line
            )
          }
        }
      }
    }
  }

  /// Populate every slot with `1` (via the position subscript — doesn't rely on
  /// a possibly-buggy `init(repeating:)`). L1 distance to zero should equal the
  /// scalar count; L∞ should equal 1.
  internal func validateFullyPopulatedDistanceFromZero<Matrix>(
    forMatrix matrix: Matrix.Type,
    using label: String,
    l1: (Matrix, Matrix) -> Matrix.Scalar,
    lInf: (Matrix, Matrix) -> Matrix.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol,
    Matrix: L1DistanceMeasureable,
    Matrix: LInfinityDistanceMeasureable,
    Matrix.L1Distance == Matrix.Scalar,
    Matrix.LInfinityDistance == Matrix.Scalar
  {
    let zero = Matrix()
    var ones = Matrix()
    for position in Matrix.matrixPositions {
      ones[position: position] = 1
    }

    let expectedL1 = Matrix.Scalar(Matrix.scalarCount)
    let expectedLInf: Matrix.Scalar = 1

    XCTAssertEqual(
      l1(ones, zero),
      expectedL1,
      "[\(label)] `\(String(reflecting: matrix))`: expected `l1(ones, zero) == \(expectedL1)`.",
      file: file,
      line: line
    )
    XCTAssertEqual(
      lInf(ones, zero),
      expectedLInf,
      "[\(label)] `\(String(reflecting: matrix))`: expected `lInf(ones, zero) == \(expectedLInf)`.",
      file: file,
      line: line
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Cross-Check
  // ------------------------------------------------------------------------ //

  /// For each `(a, b)` in a deterministic sweep, assert that the canonical
  /// `l1Distance` / `lInfinityDistance` agree with the generic reference
  /// `_l1Distance` / `_lInfinityDistance` to within an epsilon. If a hand-
  /// written per-shape implementation diverges from the spec for any input,
  /// this surfaces it directly (regardless of whether the value happens to
  /// match the analytic expectation in `validateSingleEntry*`).
  internal func validateGenericMatchesCanonical<Matrix>(
    forMatrix matrix: Matrix.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol,
    Matrix: L1DistanceMeasureable,
    Matrix: LInfinityDistanceMeasureable,
    Matrix.L1Distance == Matrix.Scalar,
    Matrix.LInfinityDistance == Matrix.Scalar
  {
    let epsilon = Matrix.Scalar.validationTestTolerance

    func compare(
      _ a: Matrix,
      _ b: Matrix,
      scenario: @autoclosure () -> String
    ) {
      let canonicalL1 = a.l1Distance(to: b)
      let genericL1 = a._l1Distance(to: b)
      XCTAssertEqual(
        canonicalL1,
        genericL1,
        accuracy: epsilon,
        "`\(String(reflecting: matrix))` (l1 cross-check, \(scenario())): canonical \(canonicalL1) vs generic \(genericL1).",
        file: file,
        line: line
      )

      let canonicalLInf = a.lInfinityDistance(to: b)
      let genericLInf = a._lInfinityDistance(to: b)
      XCTAssertEqual(
        canonicalLInf,
        genericLInf,
        accuracy: epsilon,
        "`\(String(reflecting: matrix))` (lInf cross-check, \(scenario())): canonical \(canonicalLInf) vs generic \(genericLInf).",
        file: file,
        line: line
      )
    }

    let zero = Matrix()
    compare(zero, zero, scenario: "zero-zero")

    let values: [Matrix.Scalar] = [1, -1, 2, -2]
    for position in Matrix.matrixPositions {
      for value in values {
        var single = Matrix()
        single[position: position] = value
        compare(single, zero, scenario: "single@\(position)=\(value), zero")
        compare(zero, single, scenario: "zero, single@\(position)=\(value)")
      }
    }

    var ones = Matrix()
    for position in Matrix.matrixPositions {
      ones[position: position] = 1
    }
    compare(ones, zero, scenario: "ones, zero")
    compare(zero, ones, scenario: "zero, ones")

    var ramped = Matrix()
    var step: Matrix.Scalar = 1
    for position in Matrix.matrixPositions {
      ramped[position: position] = step
      step += 1
    }
    compare(ramped, zero, scenario: "ramped, zero")
    compare(ramped, ones, scenario: "ramped, ones")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Aggregate Validator
  // ------------------------------------------------------------------------ //

  internal func validateMatrixDistanceFunctions<Matrix>(
    forMatrix matrix: Matrix.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol,
    Matrix: L1DistanceMeasureable,
    Matrix: LInfinityDistanceMeasureable,
    Matrix.L1Distance == Matrix.Scalar,
    Matrix.LInfinityDistance == Matrix.Scalar
  {
    let canonicalL1: (Matrix, Matrix) -> Matrix.Scalar = { $0.l1Distance(to: $1) }
    let canonicalLInf: (Matrix, Matrix) -> Matrix.Scalar = { $0.lInfinityDistance(to: $1) }
    let genericL1: (Matrix, Matrix) -> Matrix.Scalar = { $0._l1Distance(to: $1) }
    let genericLInf: (Matrix, Matrix) -> Matrix.Scalar = { $0._lInfinityDistance(to: $1) }

    for (label, l1, lInf) in [
      ("canonical", canonicalL1, canonicalLInf),
      ("generic", genericL1, genericLInf)
    ] {
      self.validateSelfDistanceIsZero(
        forMatrix: matrix,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
      self.validateFullyPopulatedDistanceFromZero(
        forMatrix: matrix,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
      self.validateSingleEntryDistanceFromZero(
        forMatrix: matrix,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
      self.validateSingleEntryPairDistances(
        forMatrix: matrix,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
    }

    self.validateGenericMatchesCanonical(
      forMatrix: matrix,
      file: file,
      line: line
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (2, _) Shapes
  // ------------------------------------------------------------------------ //

  func testMatrix2x2() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double2x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float2x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half2x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x2<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x2<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x2<Float16>.self)
  }

  func testMatrix2x3() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double2x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float2x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half2x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x3<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x3<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x3<Float16>.self)
  }

  func testMatrix2x4() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double2x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float2x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half2x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x4<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x4<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix2x4<Float16>.self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: (3, _) Shapes
  // ------------------------------------------------------------------------ //

  func testMatrix3x2() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double3x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float3x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half3x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x2<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x2<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x2<Float16>.self)
  }

  func testMatrix3x3() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double3x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float3x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half3x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x3<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x3<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x3<Float16>.self)
  }

  func testMatrix3x4() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double3x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float3x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half3x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x4<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x4<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix3x4<Float16>.self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: (4, _) Shapes
  // ------------------------------------------------------------------------ //

  func testMatrix4x2() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double4x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float4x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half4x2.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x2<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x2<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x2<Float16>.self)
  }

  func testMatrix4x3() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double4x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float4x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half4x3.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x3<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x3<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x3<Float16>.self)
  }

  func testMatrix4x4() {
    self.validateMatrixDistanceFunctions(forMatrix: simd_double4x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_float4x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: simd_half4x4.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x4<Double>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x4<Float>.self)
    self.validateMatrixDistanceFunctions(forMatrix: Matrix4x4<Float16>.self)
  }

}
