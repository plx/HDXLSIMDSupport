import HDXLSIMDSupportMacrosPlugin

func matrixShapes(forRowCount rowCount: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { rowCount == $0.rowCount }
}

func matrixShapes(forColumnCount columnCount: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { columnCount == $0.columnCount }
}

func matrixShapes(forRowLength rowLength: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { rowLength == $0.rowLength }
}

func matrixShapes(forColumnLength columnLength: Int) -> [SIMDMatrixShape] {
  SIMDMatrixShape.allCases.filter { columnLength == $0.columnLength }
}
