//
//  MatrixPositionBasicTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class MatrixPositionBasicTests: XCTestCase {
  
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
  
  let positions: [MatrixPosition] = [
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
  ].flatMap() { $0 }
  
  // ------------------------------------------------------------------------ //
  // MARK: Position Tests
  // ------------------------------------------------------------------------ //
  
  func testValidity() {
    self.positions.forEach() {
      XCTAssertTrue($0.isValid)
    }
  }
  
  func testEquality() {
    for (lIndex,lhs) in self.positions.enumerated() {
      for (rIndex,rhs) in self.positions.enumerated() {
        // TODO: really want a `AssertEquivalentEquality`,
        // but still gathering ideas for an `HDXLTestSupport` package.
        if lIndex == rIndex {
          XCTAssertEqual(lhs,rhs)
        } else {
          XCTAssertNotEqual(lhs, rhs)
        }
      }
    }
  }
  
  func testDiagonal() {
    self.positions.forEach() {
      XCTAssertEqual(
        $0.rowIndex == $0.columnIndex,
        $0.isOnDiagonal
      )
      XCTAssertEqual(
        $0.rowIndex != $0.columnIndex,
        $0.isOffDiagonal
      )
    }
  }
  
  func testTransposition() {
    for position in self.positions {
      
      var clone = position
      clone.formTranspose()
      XCTAssertEqual(
        clone.rowIndex,
        position.columnIndex
      )
      XCTAssertEqual(
        clone.columnIndex,
        position.rowIndex
      )
      
      let transposed = position.transposed()
      XCTAssertEqual(
        clone,
        transposed
      )
      
      let doublyTransposed = transposed.transposed()
      XCTAssertEqual(
        position,
        doublyTransposed
      )
      
      clone.formTranspose()
      XCTAssertEqual(
        position,
        clone
      )

    }
  }
  
  func testWithRowIndex() {
    for position in self.positions {
      for rowIndex in 0...5 where rowIndex != position.rowIndex && rowIndex != position.columnIndex {
        XCTAssertNotEqual(
          rowIndex,
          position.rowIndex
        )
        XCTAssertNotEqual(
          rowIndex,
          position.columnIndex
        )
        
        let result = position.with(rowIndex: rowIndex)
        XCTAssertEqual(
          rowIndex,
          result.rowIndex
        )
        XCTAssertNotEqual(
          rowIndex,
          result.columnIndex
        )
        XCTAssertEqual(
          position.columnIndex,
          result.columnIndex
        )
      }
    }
  }

  func testWithColumnIndex() {
    for position in self.positions {
      for columnIndex in 0...5 where columnIndex != position.rowIndex && columnIndex != position.columnIndex {
        XCTAssertNotEqual(
          columnIndex,
          position.rowIndex
        )
        XCTAssertNotEqual(
          columnIndex,
          position.columnIndex
        )
        
        let result = position.with(columnIndex: columnIndex)
        XCTAssertEqual(
          columnIndex,
          result.columnIndex
        )
        XCTAssertNotEqual(
          columnIndex,
          result.rowIndex
        )
        XCTAssertEqual(
          position.rowIndex,
          result.rowIndex
        )
      }
    }
  }

}

