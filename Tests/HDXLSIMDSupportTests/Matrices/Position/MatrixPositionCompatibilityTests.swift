//
//  MatrixPositionCompatibilityTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class MatrixPositionCompatibilityTests: XCTestCase {
  
  // ------------------------------------------------------------------------ //
  // MARK: Test Management
  // ------------------------------------------------------------------------ //

  override func setUp() {
    super.setUp()
    self.continueAfterFailure = false
  }
  
  override func tearDown() {
    super.tearDown()
    self.continueAfterFailure = true
  }
  
  let positions: [[MatrixPosition]] = [
    [
      MatrixPosition(rowIndex: 0, columnIndex: 0),
      MatrixPosition(rowIndex: 0, columnIndex: 1),
      MatrixPosition(rowIndex: 0, columnIndex: 2),
      MatrixPosition(rowIndex: 0, columnIndex: 3),
      MatrixPosition(rowIndex: 0, columnIndex: 4),
      MatrixPosition(rowIndex: 0, columnIndex: 5)
    ],
    [
      MatrixPosition(rowIndex: 1, columnIndex: 0),
      MatrixPosition(rowIndex: 1, columnIndex: 1),
      MatrixPosition(rowIndex: 1, columnIndex: 2),
      MatrixPosition(rowIndex: 1, columnIndex: 3),
      MatrixPosition(rowIndex: 1, columnIndex: 4),
      MatrixPosition(rowIndex: 1, columnIndex: 5)
    ],
    [
      MatrixPosition(rowIndex: 2, columnIndex: 0),
      MatrixPosition(rowIndex: 2, columnIndex: 1),
      MatrixPosition(rowIndex: 2, columnIndex: 2),
      MatrixPosition(rowIndex: 2, columnIndex: 3),
      MatrixPosition(rowIndex: 2, columnIndex: 4),
      MatrixPosition(rowIndex: 2, columnIndex: 5)
    ],
    [
      MatrixPosition(rowIndex: 3, columnIndex: 0),
      MatrixPosition(rowIndex: 3, columnIndex: 1),
      MatrixPosition(rowIndex: 3, columnIndex: 2),
      MatrixPosition(rowIndex: 3, columnIndex: 3),
      MatrixPosition(rowIndex: 3, columnIndex: 4),
      MatrixPosition(rowIndex: 3, columnIndex: 5)
    ],
    [
      MatrixPosition(rowIndex: 4, columnIndex: 0),
      MatrixPosition(rowIndex: 4, columnIndex: 1),
      MatrixPosition(rowIndex: 4, columnIndex: 2),
      MatrixPosition(rowIndex: 4, columnIndex: 3),
      MatrixPosition(rowIndex: 4, columnIndex: 4),
      MatrixPosition(rowIndex: 4, columnIndex: 5)
    ],
    [
      MatrixPosition(rowIndex: 5, columnIndex: 0),
      MatrixPosition(rowIndex: 5, columnIndex: 1),
      MatrixPosition(rowIndex: 5, columnIndex: 2),
      MatrixPosition(rowIndex: 5, columnIndex: 3),
      MatrixPosition(rowIndex: 5, columnIndex: 4),
      MatrixPosition(rowIndex: 5, columnIndex: 5)
    ]
  ]

  // ------------------------------------------------------------------------ //
  // MARK: Position Tests
  // ------------------------------------------------------------------------ //
  
  func testCannedPositionValidity() {
    for rowIndex in 0...5 {
      for columnIndex in 0...5 {
        let position = self.positions[rowIndex][columnIndex]
        XCTAssertEqual(
          rowIndex,
          position.rowIndex
        )
        XCTAssertEqual(
          columnIndex,
          position.columnIndex
        )
      }
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Check Support
  // ------------------------------------------------------------------------ //
  
  // Note closure isn't final parameter, but reads nicer like this:
  fileprivate func confirm(
    _ compatibility: (MatrixPosition) -> Bool,
    isConsistentWith expectations: [[Bool]]) {
    XCTAssertEqual(
      expectations.count,
      self.positions.count
    )
    XCTAssertTrue(expectations.allSatisfy({$0.count == self.positions.count}))
    for rowIndex in 0...5 {
      for columnIndex in 0...5 {
        XCTAssertEqual(
          expectations[rowIndex][columnIndex],
          compatibility(self.positions[rowIndex][columnIndex])
        )
      }
    }
  }
  
  fileprivate func expectations(
    forCompatiblePositions compatiblePositions: [(Int,Int)]) -> [[Bool]] {
    var expectations: [[Bool]] = [[Bool]](
      repeating: [Bool](
        repeating: false,
        count: 6
      ),
      count: 6
    )
    for (rowIndex, columnIndex) in compatiblePositions {
      expectations[rowIndex][columnIndex] = true
    }
    return expectations
  }

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Compatibility Checks
  // ------------------------------------------------------------------------ //
  
  func testPosition2x2Compatibility() {
    self.confirm(
      {$0.isCompatibleWith2x2Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),
          (1,0),(1,1)
        ]
      )
    )
  }

  func testPosition2x3Compatibility() {
    self.confirm(
      {$0.isCompatibleWith2x3Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),
          (1,0),(1,1),
          (2,0),(2,1)
        ]
      )
    )
  }

  func testPosition2x4Compatibility() {
    self.confirm(
      {$0.isCompatibleWith2x4Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),
          (1,0),(1,1),
          (2,0),(2,1),
          (3,0),(3,1)
        ]
      )
    )
  }

  func testPosition3x2Compatibility() {
    self.confirm(
      {$0.isCompatibleWith3x2Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),(0,2),
          (1,0),(1,1),(1,2)
        ]
      )
    )
  }
  
  func testPosition3x3Compatibility() {
    self.confirm(
      {$0.isCompatibleWith3x3Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),(0,2),
          (1,0),(1,1),(1,2),
          (2,0),(2,1),(2,2)
        ]
      )
    )
  }
  
  func testPosition3x4Compatibility() {
    self.confirm(
      {$0.isCompatibleWith3x4Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),(0,2),
          (1,0),(1,1),(1,2),
          (2,0),(2,1),(2,2),
          (3,0),(3,1),(3,2)
        ]
      )
    )
  }

  func testPosition4x2Compatibility() {
    self.confirm(
      {$0.isCompatibleWith4x2Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),(0,2),(0,3),
          (1,0),(1,1),(1,2),(1,3)
        ]
      )
    )
  }
  
  func testPosition4x3Compatibility() {
    self.confirm(
      {$0.isCompatibleWith4x3Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),(0,2),(0,3),
          (1,0),(1,1),(1,2),(1,3),
          (2,0),(2,1),(2,2),(2,3)
        ]
      )
    )
  }
  
  func testPosition4x4Compatibility() {
    self.confirm(
      {$0.isCompatibleWith4x4Matrices},
      isConsistentWith: self.expectations(
        forCompatiblePositions: [
          (0,0),(0,1),(0,2),(0,3),
          (1,0),(1,1),(1,2),(1,3),
          (2,0),(2,1),(2,2),(2,3),
          (3,0),(3,1),(3,2),(3,3)
        ]
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Sanity Tests
  // ------------------------------------------------------------------------ //
  
  func testUniverallyIncompatiblePosition() {
    let position = MatrixPosition(rowIndex: 5, columnIndex: 5)
    XCTAssertFalse(position.isCompatibleWith2x2Matrices)
    XCTAssertFalse(position.isCompatibleWith2x3Matrices)
    XCTAssertFalse(position.isCompatibleWith2x4Matrices)
    XCTAssertFalse(position.isCompatibleWith3x2Matrices)
    XCTAssertFalse(position.isCompatibleWith3x3Matrices)
    XCTAssertFalse(position.isCompatibleWith3x4Matrices)
    XCTAssertFalse(position.isCompatibleWith4x2Matrices)
    XCTAssertFalse(position.isCompatibleWith4x3Matrices)
    XCTAssertFalse(position.isCompatibleWith4x4Matrices)
  }
  
  func testUniversallyCompatiblePosition() {
    let position = MatrixPosition(rowIndex: 0, columnIndex: 0)
    XCTAssertTrue(position.isCompatibleWith2x2Matrices)
    XCTAssertTrue(position.isCompatibleWith2x3Matrices)
    XCTAssertTrue(position.isCompatibleWith2x4Matrices)
    XCTAssertTrue(position.isCompatibleWith3x2Matrices)
    XCTAssertTrue(position.isCompatibleWith3x3Matrices)
    XCTAssertTrue(position.isCompatibleWith3x4Matrices)
    XCTAssertTrue(position.isCompatibleWith4x2Matrices)
    XCTAssertTrue(position.isCompatibleWith4x3Matrices)
    XCTAssertTrue(position.isCompatibleWith4x4Matrices)
  }

  // ------------------------------------------------------------------------ //
  // MARK: (2, _) Compatibility
  // ------------------------------------------------------------------------ //
  
  func testMatrix2x2PositionCompatibility() {
    Matrix2x2<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith2x2Matrices)
    }
    Matrix2x2<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith2x2Matrices)
    }
  }
  
  func testMatrix2x3PositionCompatibility() {
    Matrix2x3<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith2x3Matrices)
    }
    Matrix2x3<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith2x3Matrices)
    }
  }
  
  func testMatrix2x4PositionCompatibility() {
    Matrix2x4<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith2x4Matrices)
    }
    Matrix2x4<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith2x4Matrices)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: (3, _) Compatibility
  // ------------------------------------------------------------------------ //

  func testMatrix3x2PositionCompatibility() {
    Matrix3x2<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith3x2Matrices)
    }
    Matrix3x2<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith3x2Matrices)
    }
  }
  
  func testMatrix3x3PositionCompatibility() {
    Matrix3x3<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith3x3Matrices)
    }
    Matrix3x3<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith3x3Matrices)
    }
  }
  
  func testMatrix3x4PositionCompatibility() {
    Matrix3x4<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith3x4Matrices)
    }
    Matrix3x4<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith3x4Matrices)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: (4, _) Compatibility
  // ------------------------------------------------------------------------ //

  func testMatrix4x2PositionCompatibility() {
    Matrix4x2<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith4x2Matrices)
    }
    Matrix4x2<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith4x2Matrices)
    }
  }

  func testMatrix4x3PositionCompatibility() {
    Matrix4x3<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith4x3Matrices)
    }
    Matrix4x3<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith4x3Matrices)
    }
  }

  func testMatrix4x4PositionCompatibility() {
    Matrix4x4<Double>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith4x4Matrices)
    }
    Matrix4x4<Float>.matrixPositions.forEach() {
      XCTAssertTrue($0.isCompatibleWith4x4Matrices)
    }
  }
  
}
