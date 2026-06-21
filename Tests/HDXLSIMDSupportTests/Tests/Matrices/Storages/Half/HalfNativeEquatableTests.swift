//
//  HalfNativeEquatableTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class HalfNativeEquatableTests: XCTestCase {

  func testHalfNativeMatrixEqualityAcrossGeneratedValues() {
    for seed in -3...3 {
      assertNativeMatrixEquality(Matrix2x2<Float16>.self, rows: 2, columns: 2, seed: seed)
      assertNativeMatrixEquality(Matrix2x3<Float16>.self, rows: 3, columns: 2, seed: seed + 1)
      assertNativeMatrixEquality(Matrix2x4<Float16>.self, rows: 4, columns: 2, seed: seed + 2)
      assertNativeMatrixEquality(Matrix3x2<Float16>.self, rows: 2, columns: 3, seed: seed + 3)
      assertNativeMatrixEquality(Matrix3x3<Float16>.self, rows: 3, columns: 3, seed: seed + 4)
      assertNativeMatrixEquality(Matrix3x4<Float16>.self, rows: 4, columns: 3, seed: seed + 5)
      assertNativeMatrixEquality(Matrix4x2<Float16>.self, rows: 2, columns: 4, seed: seed + 6)
      assertNativeMatrixEquality(Matrix4x3<Float16>.self, rows: 3, columns: 4, seed: seed + 7)
      assertNativeMatrixEquality(Matrix4x4<Float16>.self, rows: 4, columns: 4, seed: seed + 8)
    }
  }

  func testHalfNativeQuaternionEqualityAcrossGeneratedValues() {
    for seed in -3...3 {
      let base = Float16(seed)
      let lhs = Quaternion<Float16>(
        i: base + 1,
        j: base + 2,
        k: base + 3,
        real: base + 4
      ).nativeSIMDRepresentation
      let same = Quaternion<Float16>(
        i: base + 1,
        j: base + 2,
        k: base + 3,
        real: base + 4
      ).nativeSIMDRepresentation
      let different = Quaternion<Float16>(
        i: base + 1,
        j: base + 2,
        k: base + 3,
        real: base + 5
      ).nativeSIMDRepresentation

      XCTAssertEqual(lhs, same)
      XCTAssertNotEqual(lhs, different)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func assertNativeMatrixEquality<Matrix>(
    _ matrixType: Matrix.Type,
    rows: Int,
    columns: Int,
    seed: Int,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol & NativeSIMDRepresentable,
    Matrix.Scalar == Float16,
    Matrix.NativeSIMDRepresentation: Equatable
  {
    let lhs = Matrix(scalars: scalars(rows: rows, columns: columns, seed: seed))
      .nativeSIMDRepresentation
    let same = Matrix(scalars: scalars(rows: rows, columns: columns, seed: seed))
      .nativeSIMDRepresentation
    let different = Matrix(scalars: scalars(rows: rows, columns: columns, seed: seed + 1))
      .nativeSIMDRepresentation

    XCTAssertEqual(lhs, same, file: file, line: line)
    XCTAssertNotEqual(lhs, different, file: file, line: line)
  }

  private func scalars(
    rows: Int,
    columns: Int,
    seed: Int
  ) -> [[Float16]] {
    return (0..<rows).map { row in
      (0..<columns).map { column in
        Float16(seed + (row * columns) + column)
      }
    }
  }

}
