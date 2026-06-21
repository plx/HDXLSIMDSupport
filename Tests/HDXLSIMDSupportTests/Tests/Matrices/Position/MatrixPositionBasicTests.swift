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

  func testExplicitHashingAndDescriptions() {
    // These conformances are how MatrixPosition appears in sets, dictionaries,
    // and diagnostics. The example pins both hash equivalence and string shape.
    let position = MatrixPosition(rowIndex: 2, columnIndex: 4)
    let equivalent = MatrixPosition(rowIndex: 2, columnIndex: 4)
    let different = MatrixPosition(rowIndex: 4, columnIndex: 2)

    XCTAssertEqual(Set([position, equivalent, different]).count, 2)
    XCTAssertEqual(position.description, "(rowIndex: 2, columnIndex: 4)")
    XCTAssertEqual(
      position.debugDescription,
      "MatrixPosition(rowIndex: 2, columnIndex: 4)"
    )
  }

  func testExplicitCodableRoundTrip() throws {
    // Codable is synthesized, but it is part of MatrixPosition's public surface
    // and coverage accounts for those synthesized functions. This example pins
    // the stored property names and round-trip behavior.
    let position = MatrixPosition(rowIndex: 2, columnIndex: 4)
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let encoded = try encoder.encode(position)

    XCTAssertEqual(
      try decoder.decode([String: Int].self, from: encoded),
      [
        "rowIndex": 2,
        "columnIndex": 4
      ]
    )
    XCTAssertEqual(
      try decoder.decode(MatrixPosition.self, from: encoded),
      position
    )
  }

  func testGeneratedInvalidPositionValidity() {
    // The initializer uses debug-only assertions for invalid indices, so in
    // ordinary test builds negative indices construct fine and `isValid`
    // remains the source of truth. Sweep both axes through invalid ranges.
    for rowIndex in -5...5 {
      for columnIndex in -5...5 {
        let position = MatrixPosition(rowIndex: rowIndex, columnIndex: columnIndex)
        XCTAssertEqual(
          rowIndex >= 0 && columnIndex >= 0,
          position.isValid
        )
      }
    }
  }

  func testGeneratedHashingAndDescriptions() {
    for position in self.positions {
      XCTAssertTrue(Set([position, position]).contains(position))
      XCTAssertEqual(
        position.description,
        "(rowIndex: \(position.rowIndex), columnIndex: \(position.columnIndex))"
      )
      XCTAssertEqual(
        position.debugDescription,
        "MatrixPosition(rowIndex: \(position.rowIndex), columnIndex: \(position.columnIndex))"
      )
    }
  }

  func testGeneratedCodableRoundTrips() throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for position in self.positions {
      XCTAssertEqual(
        try decoder.decode(
          MatrixPosition.self,
          from: encoder.encode(position)
        ),
        position
      )
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
