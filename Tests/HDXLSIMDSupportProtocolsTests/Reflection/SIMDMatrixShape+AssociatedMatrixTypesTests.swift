import Testing
import simd
@testable import HDXLSIMDSupportProtocols
import HDXLSIMDSupportProtocolsTestSupport

@Test(
  "`SIMDMatrixShape.rowVectorTypeName(scalar:)` (properties)",
  arguments: SIMDMatrixShape.allCases, SIMDAggregateScalar.allCases
)
func testSIMDMatrixShapeRowVectorTypeNameScalarProperties(
  shape: SIMDMatrixShape,
  scalar: SIMDAggregateScalar
) throws {
  try validate(
    vectorTypeName: shape.rowVectorTypeName(scalar: scalar),
    expectedVectorLength: shape.rowLength,
    scalarTypeName: scalar.swiftTypeName,
    explanation: "`shape.rowVectorTypeName(scalar: scalar)`"
  )
}

@Test(
  "`SIMDMatrixShape.columnVectorTypeName(scalar:)` (properties)",
  arguments: SIMDMatrixShape.allCases, SIMDAggregateScalar.allCases
)
func testSIMDMatrixShapeColumnVectorTypeNameScalarProperties(
  shape: SIMDMatrixShape,
  scalar: SIMDAggregateScalar
) throws {
  try validate(
    vectorTypeName: shape.columnVectorTypeName(scalar: scalar),
    expectedVectorLength: shape.columnLength,
    scalarTypeName: scalar.swiftTypeName,
    explanation: "`shape.columnVectorTypeName(scalar: scalar)`"
  )
}

@Test(
  "`SIMDMatrixShape.diagonalVectorTypeName(scalar:)` (properties)",
  arguments: SIMDMatrixShape.allCases, SIMDAggregateScalar.allCases
)
func testSIMDMatrixShapeDiagonalVectorTypeNameScalarProperties(
  shape: SIMDMatrixShape,
  scalar: SIMDAggregateScalar
) throws {
  try validate(
    vectorTypeName: shape.diagonalVectorTypeName(scalar: scalar),
    expectedVectorLength: shape.diagonalLength,
    scalarTypeName: scalar.swiftTypeName,
    explanation: "`shape.diagonalVectorTypeName(scalar: scalar)`"
  )
}


// MARK: xxxTypeName(genericParameterName:)

fileprivate let exampleScalarNames: [String] = [
  "Scalar",
  "Float16",
  "Float",
  "Double",
  "FutureFloat256"
]

@Test(
  "`SIMDMatrixShape.rowVectorTypeName(genericParameterName:)` (properties)",
  arguments: SIMDMatrixShape.allCases, exampleScalarNames
)
func testSIMDMatrixShapeRowVectorTypeNameGenericParameterNameProperties(
  shape: SIMDMatrixShape,
  genericParameterName: String
) throws {
  try validate(
    vectorTypeName: shape.rowVectorTypeName(genericParameterName: genericParameterName),
    expectedVectorLength: shape.rowLength,
    scalarTypeName: genericParameterName,
    explanation: "`shape.rowVectorTypeName(genericParameterName: genericParameterName)`"
  )
}

@Test(
  "`SIMDMatrixShape.columnVectorTypeName(genericParameterName:)` (properties)",
  arguments: SIMDMatrixShape.allCases, exampleScalarNames
)
func testSIMDMatrixShapeColumnVectorTypeNameGenericParameterNameProperties(
  shape: SIMDMatrixShape,
  genericParameterName: String
) throws {
  try validate(
    vectorTypeName: shape.columnVectorTypeName(genericParameterName: genericParameterName),
    expectedVectorLength: shape.columnLength,
    scalarTypeName: genericParameterName,
    explanation: "`shape.columnVectorTypeName(genericParameterName: genericParameterName)`"
  )
}

@Test(
  "`SIMDMatrixShape.diagonalVectorTypeName(genericParameterName:)` (properties)",
  arguments: SIMDMatrixShape.allCases, exampleScalarNames
)
func testSIMDMatrixShapeDiagonalVectorTypeNameGenericParameterNameProperties(
  shape: SIMDMatrixShape,
  genericParameterName: String
) throws {
  try validate(
    vectorTypeName: shape.diagonalVectorTypeName(genericParameterName: genericParameterName),
    expectedVectorLength: shape.diagonalLength,
    scalarTypeName: genericParameterName,
    explanation: "`shape.diagonalVectorTypeName(genericParameterName: genericParameterName)`"
  )
}

// MARK: rowsTypeName

@Test(
  "`SIMDMatrixShape.rowsTypeName` (2-rows, properties)",
  arguments: matrixShapes(forRowCount: 2)
)
func testSIMDMatrixShapeRowsTypeNamePropertiesFor2RowShapes(
  shape: SIMDMatrixShape
) throws {
  #expect(
    "(RowVector, RowVector)" == shape.rowsTypeName
  )
}

@Test(
  "`SIMDMatrixShape.rowsTypeName` (3-rows, properties)",
  arguments: matrixShapes(forRowCount: 3)
)
func testSIMDMatrixShapeRowsTypeNamePropertiesFor3RowShapes(
  shape: SIMDMatrixShape
) throws {
  #expect(
    "(RowVector, RowVector, RowVector)" == shape.rowsTypeName
  )
}

@Test(
  "`SIMDMatrixShape.rowsTypeName` (4-rows, properties)",
  arguments: matrixShapes(forRowCount: 4)
)
func testSIMDMatrixShapeRowsTypeNamePropertiesFor4RowShapes(
  shape: SIMDMatrixShape
) throws {
  #expect(
    "(RowVector, RowVector, RowVector, RowVector)" == shape.rowsTypeName
  )
}

// MARK: columnsTypeName

@Test(
  "`SIMDMatrixShape.columnsTypeName` (2-columns, properties)",
  arguments: matrixShapes(forColumnCount: 2)
)
func testSIMDMatrixShapeRowsTypeNamePropertiesFor2ColumnShapes(
  shape: SIMDMatrixShape
) throws {
  #expect(
    "(ColumnVector, ColumnVector)" == shape.columnsTypeName
  )
}

@Test(
  "`SIMDMatrixShape.columnsTypeName` (3-columns, properties)",
  arguments: matrixShapes(forColumnCount: 3)
)
func testSIMDMatrixShapeColumnsTypeNamePropertiesFor3ColumnShapes(
  shape: SIMDMatrixShape
) throws {
  #expect(
    "(ColumnVector, ColumnVector, ColumnVector)" == shape.columnsTypeName
  )
}

@Test(
  "`SIMDMatrixShape.columnsTypeName` (4-columns, properties)",
  arguments: matrixShapes(forColumnCount: 4)
)
func testSIMDMatrixShapeRowsTypeNamePropertiesFor4ColumnShapes(
  shape: SIMDMatrixShape
) throws {
  #expect(
    "(ColumnVector, ColumnVector, ColumnVector, ColumnVector)" == shape.columnsTypeName
  )
}

// MARK: xxxTypeName - validation

fileprivate func validate(
  vectorTypeName: String,
  expectedVectorLength: Int,
  scalarTypeName: String,
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation()
) throws {
  #expect(
    !vectorTypeName.isEmpty,
    """
    Should never see empty vector-type-names!
    
    - `explanation`: \(explanation())
    - `vectorTypeName`: \(vectorTypeName)
    - `expectedVectorLength`: \(expectedVectorLength)
    - `scalarTypeName`: \(scalarTypeName)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  #expect(
    vectorTypeName.contains(scalarTypeName),
    """
    Couldn't find the scalar type name in the vector type name!
    
    - `explanation`: \(explanation())
    - `vectorTypeName`: \(vectorTypeName)
    - `expectedVectorLength`: \(expectedVectorLength)
    - `scalarTypeName`: \(scalarTypeName)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  #expect(
    vectorTypeName.contains("\(expectedVectorLength)"),
    """
    Couldn't find the expected vector length in the vector type name!
    
    - `explanation`: \(explanation())
    - `vectorTypeName`: \(vectorTypeName)
    - `expectedVectorLength`: \(expectedVectorLength)
    - `scalarTypeName`: \(scalarTypeName)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  
  let match = try #require(
    vectorTypeName.wholeMatch(
      of: /SIMD(\d)<(\w+)>/
    ),
    """
    Failed to match `vectorTypeName` against the pattern `/SIMD(\\d)<(\\w+)>/`!
    
    - `explanation`: \(explanation())
    - `vectorTypeName`: \(vectorTypeName)
    - `expectedVectorLength`: \(expectedVectorLength)
    - `scalarTypeName`: \(scalarTypeName)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  #expect(
    match.1 == "\(expectedVectorLength)",
    """
    Mismatch between `match.1` (\(match.1)) and `expectedVectorLength` (\(expectedVectorLength))!
    
    - `explanation`: \(explanation())
    - `vectorTypeName`: \(vectorTypeName)
    - `expectedVectorLength`: \(expectedVectorLength)
    - `scalarTypeName`: \(scalarTypeName)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  #expect(
    match.2 == scalarTypeName,
    """
    Mismatch between `match.2` (\(match.2)) and `scalarTypeName` (\(scalarTypeName))!
    
    - `explanation`: \(explanation())
    - `vectorTypeName`: \(vectorTypeName)
    - `expectedVectorLength`: \(expectedVectorLength)
    - `scalarTypeName`: \(scalarTypeName)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}
