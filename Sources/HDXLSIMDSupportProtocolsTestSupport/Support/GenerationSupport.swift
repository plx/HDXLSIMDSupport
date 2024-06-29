import HDXLSIMDSupportProtocols

@inlinable
package func matrixShapes(forRowCount rowCount: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { rowCount == $0.rowCount }
}

@inlinable
package func matrixShapes(forColumnCount columnCount: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { columnCount == $0.columnCount }
}

@inlinable
package func matrixShapes(forRowLength rowLength: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { rowLength == $0.rowLength }
}

@inlinable
package func matrixShapes(forColumnLength columnLength: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { columnLength == $0.columnLength }
}
