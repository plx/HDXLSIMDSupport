import Foundation
@testable import HDXLSIMDSupport

func matrixPositions(
  rowIndices: some Collection<Int>,
  columnIndices: some Collection<Int>
) -> [MatrixPosition] {
  var result: [MatrixPosition] = []
  result.reserveCapacity(rowIndices.count * columnIndices.count)
  for rowIndex in rowIndices {
    for columnIndex in columnIndices {
      result.append(
        MatrixPosition(
          rowIndex: rowIndex,
          columnIndex: columnIndex
        )
      )
    }
  }
  return result
}
