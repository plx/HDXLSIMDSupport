import Testing
import simd
@testable import HDXLSIMDSupport

// MARK: `MatrixPosition` Validation Support

func confirmCompatibility(
  _ condition: (MatrixPosition) -> Bool,
  for positions: some Collection<(Int, Int)>
) {
  for position in positions {
    #expect(
      condition(
        MatrixPosition(
          rowIndex: position.1,
          columnIndex: position.0
        )
      )
    )
  }
}

// MARK: `matrixPositions` Validation Support

func confirmPositions<Matrix>(
  of matrixType: Matrix.Type,
  satisfy condition: (MatrixPosition) -> Bool
) where Matrix: MatrixProtocol {
  for matrixPosition in matrixType.matrixPositions {
    #expect(condition(matrixPosition))
  }
}

func confirmPositions<each Matrix: MatrixProtocol>(
  satisfy condition: (MatrixPosition) -> Bool,
  forMatrixTypes matrixTypes: (repeat (each Matrix).Type)
) {
  for matrixType in repeat each matrixTypes {
    confirmPositions(
      of: matrixType,
      satisfy: condition
    )
  }
}

// MARK: 2xN Compatibility - Concrete

@Test("2x2 position-compatibility")
func test2x2PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith2x2Matrices,
     for: [
       (0, 0), (0, 1),
       (1, 0), (1, 1)
     ]
  )
}

@Test("2x3 position-compatibility")
func test2x3PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith2x3Matrices,
     for: [
       (0, 0), (0, 1), (0, 2),
       (1, 0), (1, 1), (1, 2)
     ]
  )
}

@Test("2x4 position-compatibility")
func test2x4PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith2x4Matrices,
     for: [
       (0, 0), (0, 1), (0, 2), (0, 3),
       (1, 0), (1, 1), (1, 2), (1, 3)
     ]
  )
}

// MARK: 3xN Compatibility - Concrete

@Test("3x2 position-compatibility")
func test3x2PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith3x2Matrices,
     for: [
       (0, 0), (0, 1),
       (1, 0), (1, 1),
       (2, 0), (2, 1)
     ]
  )
}

@Test("3x3 position-compatibility")
func test3x3PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith3x3Matrices,
     for: [
       (0, 0), (0, 1), (0, 2),
       (1, 0), (1, 1), (1, 2),
       (2, 0), (2, 1), (2, 2)
     ]
  )
}

@Test("3x4 position-compatibility")
func test3x4PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith3x4Matrices,
     for: [
       (0, 0), (0, 1), (0, 2), (0, 3),
       (1, 0), (1, 1), (1, 2), (1, 3),
       (2, 0), (2, 1), (2, 2), (2, 3)
     ]
  )
}

// MARK: 4xN Compatibility - Concrete

@Test("4x2 position-compatibility")
func test4x2PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith4x2Matrices,
     for: [
       (0, 0), (0, 1),
       (1, 0), (1, 1),
       (2, 0), (2, 1),
       (3, 0), (3, 1)
     ]
  )
}

@Test("4x3 position-compatibility")
func test4x3PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith4x3Matrices,
     for: [
       (0, 0), (0, 1), (0, 2),
       (1, 0), (1, 1), (0, 2),
       (2, 0), (2, 1), (2, 2),
       (3, 0), (3, 1), (3, 2)
     ]
  )
}

@Test("4x4 position-compatibility")
func test4x4PositionCompatibility() {
  confirmCompatibility(
    \.isCompatibleWith4x4Matrices,
     for: [
       (0, 0), (0, 1), (0, 2), (0, 3),
       (1, 0), (1, 1), (1, 2), (1, 3),
       (2, 0), (2, 1), (2, 2), (2, 3),
       (3, 0), (3, 1), (3, 2), (3, 3)
     ]
  )
}


// TODO: add test for the counts making sense
// TODO: add test for validity being consistent with the expected ranges

// MARK: 2xN Compatibility - `matrixPositions`

@Test("2x2 `matrixPositions` compatibility.")
func test2x2MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith2x2Matrices,
    forMatrixTypes: (
      Matrix2x2<Float>.self,
      Matrix2x2<Double>.self
    )
  )
}

@Test("2x3 `matrixPositions` compatibility.")
func test2x3MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith2x3Matrices,
    forMatrixTypes: (
      Matrix2x3<Float>.self,
      Matrix2x3<Double>.self
    )
  )
}

@Test("2x4 `matrixPositions` compatibility.")
func test2x4MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith2x4Matrices,
    forMatrixTypes: (
      Matrix2x4<Float>.self,
      Matrix2x4<Double>.self
    )
  )
}

// MARK: 3xN Compatibility - `matrixPositions`

@Test("3x2 `matrixPositions` compatibility.")
func test3x2MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith3x2Matrices,
    forMatrixTypes: (
      Matrix3x2<Float>.self,
      Matrix3x2<Double>.self
    )
  )
}

@Test("3x3 `matrixPositions` compatibility.")
func test3x3MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith3x3Matrices,
    forMatrixTypes: (
      Matrix3x3<Float>.self,
      Matrix3x3<Double>.self
    )
  )
}

@Test("3x4 `matrixPositions` compatibility.")
func test3x4MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith3x4Matrices,
    forMatrixTypes: (
      Matrix3x4<Float>.self,
      Matrix3x4<Double>.self
    )
  )
}

// MARK: 4xN Compatibility - `matrixPositions`

@Test("4x2 `matrixPositions` compatibility.")
func test4x2MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith4x2Matrices,
    forMatrixTypes: (
      Matrix4x2<Float>.self,
      Matrix4x2<Double>.self
    )
  )
}

@Test("4x3 `matrixPositions` compatibility.")
func test4x3MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith4x3Matrices,
    forMatrixTypes: (
      Matrix4x3<Float>.self,
      Matrix4x3<Double>.self
    )
  )
}

@Test("4x4 `matrixPositions` compatibility.")
func test4x4MatrixPositions() {
  confirmPositions(
    satisfy: \.isCompatibleWith4x4Matrices,
    forMatrixTypes: (
      Matrix4x4<Float>.self,
      Matrix4x4<Double>.self
    )
  )
}

// MARK: Simple Sanity Tests

@Test(
  "Universally-compatible positions are compatible with everything.",
  arguments: matrixPositions(
    rowIndices: 0...1,
    columnIndices: 0...1
  )
)
func testUniversallyCompatiblePositionsAreCompatibleWithEverything(
  position: MatrixPosition
) {
  #expect(position.isCompatibleWith2x2Matrices)
  #expect(position.isCompatibleWith2x3Matrices)
  #expect(position.isCompatibleWith2x4Matrices)
  #expect(position.isCompatibleWith3x2Matrices)
  #expect(position.isCompatibleWith3x3Matrices)
  #expect(position.isCompatibleWith3x4Matrices)
  #expect(position.isCompatibleWith4x2Matrices)
  #expect(position.isCompatibleWith4x3Matrices)
  #expect(position.isCompatibleWith4x4Matrices)
}

@Test(
  "Universally-incompatible positions are incompatible with everything.",
  arguments: (
    matrixPositions(
      rowIndices: 5...7,
      columnIndices: 5...7
    )
    + 
    matrixPositions(
      rowIndices: 0...3,
      columnIndices: 5...7
    )
    +
    matrixPositions(
      rowIndices: 5...7,
      columnIndices: 0...3
    )
  )
)
func testUniversallyIncompatiblePositionsAreIncompatibleWithEverything(
  position: MatrixPosition
) {
  #expect(!position.isCompatibleWith2x2Matrices)
  #expect(!position.isCompatibleWith2x3Matrices)
  #expect(!position.isCompatibleWith2x4Matrices)
  #expect(!position.isCompatibleWith3x2Matrices)
  #expect(!position.isCompatibleWith3x3Matrices)
  #expect(!position.isCompatibleWith3x4Matrices)
  #expect(!position.isCompatibleWith4x2Matrices)
  #expect(!position.isCompatibleWith4x3Matrices)
  #expect(!position.isCompatibleWith4x4Matrices)
}
