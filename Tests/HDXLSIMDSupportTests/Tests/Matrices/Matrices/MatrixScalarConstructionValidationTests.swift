//
//  MatrixScalarConstructionValidationTests.swift
//

import XCTest
@testable import HDXLSIMDSupport

class MatrixScalarConstructionValidationTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitScalarConstructionShapeValidation() {
    // The shared validation helper checks the visual row/column layout accepted
    // by `init(scalars:)`. This example pins the success path plus each way the
    // shape can be wrong without invoking a trapping initializer.
    XCTAssertTrue(
      Matrix3x4<Double>.canConstruct(
        from: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [10, 11, 12]
        ]
      )
    )
    XCTAssertFalse(
      Matrix3x4<Double>.canConstruct(
        from: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ]
      )
    )
    XCTAssertFalse(
      Matrix3x4<Double>.canConstruct(
        from: [
          [1, 2, 3],
          [4, 5],
          [7, 8, 9],
          [10, 11, 12]
        ]
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

  func testScalarConstructionShapeValidationAcrossGeneratedMatrixShapes() {
    confirmCanConstruct(Matrix2x2<Double>.self)
    confirmCanConstruct(Matrix2x3<Double>.self)
    confirmCanConstruct(Matrix2x4<Double>.self)
    confirmCanConstruct(Matrix3x2<Double>.self)
    confirmCanConstruct(Matrix3x3<Double>.self)
    confirmCanConstruct(Matrix3x4<Double>.self)
    confirmCanConstruct(Matrix4x2<Double>.self)
    confirmCanConstruct(Matrix4x3<Double>.self)
    confirmCanConstruct(Matrix4x4<Double>.self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func confirmCanConstruct<M: MatrixProtocol>(
    _ type: M.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where M.Scalar == Double {
    let valid = scalars(rows: M.rowCount, columns: M.columnCount)
    XCTAssertTrue(
      M.canConstruct(from: valid),
      file: file,
      line: line
    )

    XCTAssertFalse(
      M.canConstruct(from: scalars(rows: M.rowCount + 1, columns: M.columnCount)),
      file: file,
      line: line
    )

    if M.rowCount > 0 {
      var wrongColumnCount = valid
      wrongColumnCount[0].append(999)
      XCTAssertFalse(
        M.canConstruct(from: wrongColumnCount),
        file: file,
        line: line
      )
    }
  }

  private func scalars(rows: Int, columns: Int) -> [[Double]] {
    var next = 1.0
    return (0..<rows).map { _ in
      (0..<columns).map { _ in
        defer { next += 1 }
        return next
      }
    }
  }

}
