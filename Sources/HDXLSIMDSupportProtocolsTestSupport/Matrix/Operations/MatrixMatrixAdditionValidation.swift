import Testing
import HDXLSIMDSupportProtocols

package func validateElementWiseMatrixMatrixMatrixNumericExpectation<Scalar, MatrixType>(
  lhs: MatrixType,
  rhs: MatrixType,
  result: MatrixType,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  _ expectation: (Scalar, Scalar) throws -> Scalar
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  for matrixPosition in MatrixType.matrixPositions {
    let lhsScalar = lhs[position: matrixPosition]
    let rhsScalar = rhs[position: matrixPosition]
    let expectedResult = try expectation(
      lhsScalar,
      rhsScalar
    )
    
    let observedResult = result[position: matrixPosition]
    let deviationFromExpectation = abs(observedResult - expectedResult)
    #expect(
      deviationFromExpectation < tolerance,
      """
      Unexpectedly found excessive deviation for componentwise matrix-matrix operation \(explanation()):
      
      - `matrixPosition`: \(matrixPosition)
      - `lhsScalar`: \(lhsScalar)
      - `rhsScalar`: \(rhsScalar)
      - `observedResult`: \(observedResult)
      - `expectedResult`: \(expectedResult)
      - `deviationFromExpectation`: \(deviationFromExpectation)
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `column`: \(sourceLocation.column)
      """,
      sourceLocation: sourceLocation
    )
  }
}

package func validateMatrixMatrixAdditionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(lhs: MatrixType, rhs: MatrixType, result: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementWiseMatrixMatrixMatrixNumericExpectation(
    lhs: example.example.lhs,
    rhs: example.example.rhs,
    result: example.example.result,
    tolerance: tolerance,
    explanation: "X[i] + Y[i] == Z[i]",
    function: example.function,
    sourceLocation: example.sourceLocation
  ) { (lhsScalar, rhsScalar) in lhsScalar + rhsScalar }
}
