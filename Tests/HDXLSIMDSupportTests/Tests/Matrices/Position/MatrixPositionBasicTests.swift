import Testing
import simd
@testable import HDXLSIMDSupport

let testPositions = matrixPositions(
  rowIndices: 0...5,
  columnIndices: 0...5
)
  

@Test(
  "`MatrixPosition.isValid` for known-valid positions.",
  arguments: testPositions
)
func goodMatrixPositionsAreValid(position: MatrixPosition) {
  #expect(position.isValid)
}

@Test(
  "`MatrixPosition` diagonal calculations are correct.",
  arguments: testPositions
)
func testMatrixPositionDiagonalChecks(
  value: MatrixPosition
) {
  #expect(
    (value.isOnDiagonal)
    ==
    (value.rowIndex == value.columnIndex)
  )
  #expect(
    (value.isOffDiagonal)
    ==
    (value.rowIndex != value.columnIndex)
  )
  #expect(
    value.isOnDiagonal == !value.isOffDiagonal
  )
}

@Test(
  "`MatrixPosition.with(rowIndex:)` works as-expected.",
  arguments: testPositions, 6...9
)
func testMatrixPositionWithRowIndex(
  value: MatrixPosition,
  newRowIndex: Int
) {
  #expect(newRowIndex != value.rowIndex)
  let updatedValue = value.with(rowIndex: newRowIndex)
  #expect(updatedValue.rowIndex == newRowIndex)
  #expect(updatedValue.columnIndex == value.columnIndex)
}

@Test(
  "`MatrixPosition.with(columnIndex:)` works as-expected.",
  arguments: testPositions, 6...9
)
func testMatrixPositionWithRowIndex(
  value: MatrixPosition,
  newColumnIndex: Int
) {
  #expect(newColumnIndex != value.columnIndex)
  let updatedValue = value.with(columnIndex: newColumnIndex)
  #expect(updatedValue.rowIndex == value.rowIndex)
  #expect(updatedValue.columnIndex == newColumnIndex)
}

@Test(
  "`MatrixPosition` transposition is correct and coherent.",
  arguments: testPositions
)
func testMatrixPositionWithRowIndex(
  value: MatrixPosition
) {
  let transposed = value.transposed()
  #expect(value.rowIndex == transposed.columnIndex)
  #expect(value.columnIndex == transposed.rowIndex)
  
  let doublyTransposed = transposed.transposed()
  #expect(doublyTransposed == value)
  
  var clone = value
  #expect(clone == value)
  clone.formTranspose()
  #expect(clone == transposed)
  clone.formTranspose()
  #expect(clone == value)
}
