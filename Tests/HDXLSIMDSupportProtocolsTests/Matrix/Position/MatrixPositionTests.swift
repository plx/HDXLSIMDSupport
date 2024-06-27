import Testing
@testable import HDXLSIMDSupportProtocols

// MARK: Diagonal-Status

@Test(
  "`MatrixPosition.isOnDiagonal`",
  arguments: MatrixPosition.allValidMatrixPositions
)
func testMatrixPositionIsOnDiagonal(
  position: MatrixPosition
) {
  #expect(
    position.isOnDiagonal
    ==
    (position.rowIndex == position.columnIndex)
  )
}

@Test(
  "`MatrixPosition.isOffDiagonal`",
  arguments: MatrixPosition.allValidMatrixPositions
)
func testMatrixPositionIsOffDiagonal(
  position: MatrixPosition
) {
  #expect(
    position.isOffDiagonal
    ==
    (position.rowIndex != position.columnIndex)
  )
}

@Test(
  "`MatrixPosition` (diagonal cross-checking)",
  arguments: MatrixPosition.allValidMatrixPositions
)
func testMatrixPositionDiagonalCrossChecks(
  position: MatrixPosition
) {
  #expect(
    position.isOnDiagonal
    ==
    !position.isOffDiagonal
  )
}

// MARK: Transposes

@Test(
  "`MatrixPosition.transposed()`",
  arguments: MatrixPosition.allValidMatrixPositions
)
func testMatrixPositionTransposed(
  position: MatrixPosition
) {
  #expect(position == position.transposed().transposed())
  #expect(position.rowIndex == position.transposed().columnIndex)
  #expect(position.columnIndex == position.transposed().rowIndex)
  #expect(position.isOnDiagonal == position.transposed().isOnDiagonal)
  #expect(position.isOffDiagonal == position.transposed().isOffDiagonal)
  #expect(
    (position == position.transposed())
    ==
    (position.rowIndex == position.columnIndex)
  )
  #expect(
    (position == position.transposed())
    ==
    position.isOnDiagonal
  )
}

@Test(
  "`MatrixPosition.formTranspose()`",
  arguments: MatrixPosition.allValidMatrixPositions
)
func testMatrixPositionFormTranspose(
  position: MatrixPosition
) {
  var probe = position
  #expect(probe == position)
  probe.formTranspose()
  #expect(probe == position.transposed())
  #expect(position.isOnDiagonal == probe.isOnDiagonal)
  #expect(
    (probe == position)
    ==
    position.isOnDiagonal
  )
  
  probe.formTranspose()
  #expect(position == probe)
}

// MARK: with-derivation

@Test(
  "`MatrixPosition.with(rowIndex:)`",
  arguments: MatrixPosition.allValidMatrixPositions, (2...4)
)
func testMatrixPositionWithRowIndex(
  position: MatrixPosition,
  rowIndex newRowIndex: Int
) {
  let result = position.with(rowIndex: newRowIndex)
  #expect(result.rowIndex == newRowIndex)
  #expect(result.columnIndex == position.columnIndex)
}

@Test(
  "`MatrixPosition.with(columnIndex:)`",
  arguments: MatrixPosition.allValidMatrixPositions, (2...4)
)
func testMatrixPositionWithRowIndex(
  position: MatrixPosition,
  columnIndex newColumnIndex: Int
) {
  let result = position.with(columnIndex: newColumnIndex)
  #expect(result.rowIndex == position.rowIndex)
  #expect(result.columnIndex == newColumnIndex)
}

// MARK: stringification

@Test("`MatrixPosition.description` (coherence)")
func testMatrixPositionDescriptionCoherence() {
  #expect(
    MatrixPosition
      .allValidMatrixPositions
      .obtainsDistinctValues(for: \.description)
  )
}

@Test("`MatrixPosition.debugDescription` (coherence)")
func testMatrixPositionDebugDescriptionCoherence() {
  #expect(
    MatrixPosition
      .allValidMatrixPositions
      .obtainsDistinctValues(for: \.description)
  )
}
