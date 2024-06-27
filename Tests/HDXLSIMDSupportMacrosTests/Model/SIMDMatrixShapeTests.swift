import Testing
import simd
@testable import HDXLSIMDSupportMacrosPlugin

@Test("`SIMDMatrixShape.description` (uniqueness)")
func testSIMDMatrixShapeDescriptionCoherence() {
  #expect(
    SIMDMatrixShape
      .allCases
      .obtainsDistinctValues(for: \.description)
  )
}

@Test(
  "`SIMDMatrixShape.description` (contains shape)",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeDescriptionContainsShape(
  matrixShape: SIMDMatrixShape
) {
  #expect(
    matrixShape.description.contains(matrixShape.typeNameComponent)
  )
}

@Test("`SIMDMatrixShape.debugDescription` (uniqueness)")
func testSIMDMatrixShapeDebugDescriptionCoherence() {
  #expect(
    SIMDMatrixShape
      .allCases
      .obtainsDistinctValues(for: \.debugDescription)
  )
}

@Test(
  "`SIMDMatrixShape.debugDescription` (contains shape, typename)",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeDebugDescriptionContainsShapeAndTypeName(
  matrixShape: SIMDMatrixShape
) {
  #expect(
    matrixShape.debugDescription.contains(matrixShape.typeNameComponent)
  )
  #expect(
    matrixShape.debugDescription.contains("SIMDMatrixShape")
  )
}


@Test("`SIMDMatrixShape.typeNameComponent`")
func testSIMDMatrixShapeTypeNameComponent() {
  // manual check:
  #expect(
    "2x2" == SIMDMatrixShape._2x2.typeNameComponent
  )
  #expect(
    "2x3" == SIMDMatrixShape._2x3.typeNameComponent
  )
  #expect(
    "2x4" == SIMDMatrixShape._2x4.typeNameComponent
  )
  #expect(
    "3x2" == SIMDMatrixShape._3x2.typeNameComponent
  )
  #expect(
    "3x3" == SIMDMatrixShape._3x3.typeNameComponent
  )
  #expect(
    "3x4" == SIMDMatrixShape._3x4.typeNameComponent
  )
  #expect(
    "4x2" == SIMDMatrixShape._4x2.typeNameComponent
  )
  #expect(
    "4x3" == SIMDMatrixShape._4x3.typeNameComponent
  )
  #expect(
    "4x4" == SIMDMatrixShape._4x4.typeNameComponent
  )
  
  // coherency check:
  #expect(
    SIMDMatrixShape
      .allCases
      .obtainsDistinctValues(for: \.typeNameComponent)
  )
}

@Test(
  "`SIMDMatrixShape.columnCount`",
  arguments: zip(
    [2, 3, 4],
    [
      [SIMDMatrixShape._2x2, SIMDMatrixShape._3x2, SIMDMatrixShape._4x2],
      [SIMDMatrixShape._2x3, SIMDMatrixShape._3x3, SIMDMatrixShape._4x3],
      [SIMDMatrixShape._2x4, SIMDMatrixShape._3x4, SIMDMatrixShape._4x4]
    ]
  )
)
func testSIMDMatrixShapeColumnCount(
  columnCount: Int,
  examples: [SIMDMatrixShape]
) {
  for example in examples {
    #expect(columnCount == example.columnCount)
  }
}

@Test(
  "`SIMDMatrixShape.rowCount`",
  arguments: zip(
    [2, 3, 4],
    [
      [SIMDMatrixShape._2x2, SIMDMatrixShape._2x3, SIMDMatrixShape._2x4],
      [SIMDMatrixShape._3x2, SIMDMatrixShape._3x3, SIMDMatrixShape._3x4],
      [SIMDMatrixShape._4x2, SIMDMatrixShape._4x3, SIMDMatrixShape._4x4]
    ]
  )
)
func testSIMDMatrixShapeRowCount(
  rowCount: Int,
  examples: [SIMDMatrixShape]
) {
  for example in examples {
    #expect(rowCount == example.rowCount)
  }
}

@Test(
  "`SIMDMatrixShape.columnCount`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeColumnCount(
  example: SIMDMatrixShape
) {
  #expect(example.rowLength == example.columnCount)
}

@Test(
  "`SIMDMatrixShape.rowCount`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeRowCount(
  example: SIMDMatrixShape
) {
  #expect(example.rowCount == example.columnLength)
}

@Test(
  "Cross-check row-counts and column-counts w/type-name-component",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixTypeNameComponentAgainstRowCountsAndColumnCounts(
  matrixShape: SIMDMatrixShape
) {
  #expect(
    matrixShape.typeNameComponent == "\(matrixShape.rowCount)x\(matrixShape.columnCount)"
  )
}

@Test(
  "`SIMDMatrixShape.transpose`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixTranspose(
  matrixShape: SIMDMatrixShape
) {
  // transpose.transpose is always self:
  #expect(matrixShape == matrixShape.transpose.transpose)
  
  #expect(matrixShape.rowCount == matrixShape.transpose.columnCount)
  #expect(matrixShape.columnCount == matrixShape.transpose.rowCount)
  #expect(
    (matrixShape == matrixShape.transpose)
    ==
    matrixShape.isSquare
  )
  #expect(
    (matrixShape == matrixShape.transpose)
    ==
    (matrixShape.rowCount == matrixShape.columnCount)
  )
}

@Test(
  "`SIMDMatrixShape.isSquare`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixIsSquare(
  matrixShape: SIMDMatrixShape
) {
  #expect(
    matrixShape.isSquare
    ==
    (matrixShape == matrixShape.transpose)
  )
  #expect(
    matrixShape.isSquare
    ==
    (matrixShape.rowCount == matrixShape.columnCount)
  )
}

@Test(
  "`SIMDMatrixShape.allAxisLengths`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixAllAxisLengths(
  matrixShape: SIMDMatrixShape
) {
  let axisLengths = matrixShape.allAxisLengths
  #expect((1...2).contains(axisLengths.count))
  #expect(
    (axisLengths.count == 1)
    ==
    matrixShape.isSquare
  )
  #expect(
    axisLengths.contains(matrixShape.rowLength)
  )
  #expect(
    axisLengths.contains(matrixShape.columnLength)
  )
  
  for probe in 0...5 {
    #expect(
      axisLengths.contains(probe)
      ==
      (
        matrixShape.rowLength == probe
        ||
        matrixShape.columnLength == probe
      )
    )
  }
}

extension SIMDMatrixShape {
  
  fileprivate var exampleMatrixNames: [String] {
    [
      "Matrix\(typeNameComponent)",
      "Matrix\(typeNameComponent)<Float16>",
      "Matrix\(typeNameComponent)<Float>",
      "Matrix\(typeNameComponent)<Double>",
      "Float16Matrix\(typeNameComponent)Storage",
      "FloatMatrix\(typeNameComponent)Storage",
      "DoubleMatrix\(typeNameComponent)Storage"
    ]
  }
  
}

@Test(
  "`SIMDMatrixShape.extracting(fromTypeName:)` (matrix types)",
  arguments: zip(
    SIMDMatrixShape.allCases,
    SIMDMatrixShape.allCases.map(\.exampleMatrixNames)
  )
)
func testSIMDMatrixShapeExtractingFromKnownMatrixTypeNames(
  expectedShape: SIMDMatrixShape,
  typeNames: [String]
) throws {
  for typeName in typeNames {
    let extractedShape = try #require(
      SIMDMatrixShape.extracting(
        fromTypeName: typeName
      )
    )
    
    #expect(
      expectedShape == extractedShape,
      "Expected to extract `\(expectedShape)` from `\(typeName)`, but got `\(extractedShape)` instead!"
    )
  }
}

@Test(
  "`SIMDMatrixShape.extracting(fromTypeName:)` (nil expected)",
  arguments: [
    "NotATypeName",
    "FloatQuaternionStorage",
    "DoubleMatrix5x5Storage"
  ]
)
func testSIMDMatrixShapeExtractingFromTypeNamesWithoutSupportedMatrixShapes(
  typeName: String
) {
  #expect(
    nil == SIMDMatrixShape.extracting(
      fromTypeName: typeName
    )
  )
}

@Test(
  "`SIMDMatrixShape.isCompatibleWithQuaternions`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeIsCompatibleWithQuaternions(
  shape: SIMDMatrixShape
) {
  #expect(
    shape.isCompatibleWithQuaternions
    ==
    (shape.isSquare && (3...4).contains(shape.diagonalLength))
  )
}

@Test(
  "`SIMDMatrixShape.diagonalLength`",
  arguments: SIMDMatrixShape.allCases
) 
func testSIMDMatrixShapeDiagonalLength(
  shape: SIMDMatrixShape
) {
  #expect(
    shape.diagonalLength == Swift.min(
      shape.rowLength,
      shape.columnLength
    )
  )
}

@Test(
  "`SIMDMatrixShape.isCompatible(with:)`",
  arguments: SIMDMatrixShape.allCases, SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeIsCompatible(
  shape: SIMDMatrixShape,
  candidate: SIMDMatrixShape
) {
  #expect(
    shape.isCompatible(with: candidate)
    ==
    !shape.allAxisLengths.isDisjoint(with: candidate.allAxisLengths)
  )
}

@Test(
  "`SIMDMatrixShape.allCompatibleMatrixShapes`",
  arguments: SIMDMatrixShape.allCases
)
func testSIMDMatrixShapeAllCompatibleMatrixShapes(
  shape: SIMDMatrixShape
) {
  let allCompatibleShapes = shape.allCompatibleMatrixShapes
  for compatibleShape in allCompatibleShapes {
    #expect(shape.isCompatible(with: compatibleShape))
  }
  
  for candidate in SIMDMatrixShape.allCases {
    #expect(
      shape.isCompatible(with: candidate)
      ==
      allCompatibleShapes.contains(candidate)
    )
  }
}
