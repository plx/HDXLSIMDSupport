import Testing
import HDXLSIMDSupportProtocols

package func validateMatrixProtocolStaticProperties<Scalar,MatrixType>(
  matrixType: MatrixType.Type,
  expectedShape: SIMDMatrixShape,
  function: StaticString,
  sourceLocation: SourceLocation
) throws where Scalar: ExtendedSIMDScalar, MatrixType: MatrixProtocol<Scalar> {
  #expect(
    matrixType.rowCount == expectedShape.rowCount,
    """
    Found `rowCount` mismatch: `matrixType.rowCount` \(matrixType.rowCount) != `expectedShape.rowCount` (\(expectedShape.rowCount))!
    
    - `matrixType`: \(String(reflecting: matrixType))
    - `expectedShape`: \(String(reflecting: expectedShape))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  #expect(
    matrixType.columnCount == expectedShape.columnCount,
    """
    Found `columnCount` mismatch: `matrixType.columnCount` \(matrixType.columnCount) != `expectedShape.columnCount` (\(expectedShape.columnCount))!
    
    - `matrixType`: \(String(reflecting: matrixType))
    - `expectedShape`: \(String(reflecting: expectedShape))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  #expect(
    matrixType.rowLength == expectedShape.rowLength,
    """
    Found `rowLength` mismatch: `matrixType.rowLength` \(matrixType.rowLength) != `expectedShape.rowLength` (\(expectedShape.rowLength))!
    
    - `matrixType`: \(String(reflecting: matrixType))
    - `expectedShape`: \(String(reflecting: expectedShape))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  #expect(
    matrixType.columnLength == expectedShape.columnLength,
    """
    Found `columnLength` mismatch: `matrixType.columnLength` \(matrixType.columnLength) != `expectedShape.columnLength` (\(expectedShape.columnLength))!
    
    - `matrixType`: \(String(reflecting: matrixType))
    - `expectedShape`: \(String(reflecting: expectedShape))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  #expect(
    matrixType.diagonalLength == expectedShape.diagonalLength,
    """
    Found `diagonalLength` mismatch: `matrixType.diagonalLength` \(matrixType.diagonalLength) != `expectedShape.diagonalLength` (\(expectedShape.diagonalLength))!
    
    - `matrixType`: \(String(reflecting: matrixType))
    - `expectedShape`: \(String(reflecting: expectedShape))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  #expect(
    matrixType.scalarCount == matrixType.rowCount * matrixType.columnCount,
    """
    Found `scalarCount` mismatch: `matrixType.scalarCount` \(matrixType.scalarCount) != `matrixType.rowCount` (\(matrixType.rowCount) *  `matrixType.columnCount` (\(matrixType.columnCount))!
    
    - `matrixType`: \(String(reflecting: matrixType))
    - `expectedShape`: \(String(reflecting: expectedShape))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}
