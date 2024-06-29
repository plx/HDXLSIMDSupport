import Testing
import HDXLSIMDSupportProtocols

package func validateElementwiseMatrixMatrixMatrixNumericExpectation<Scalar, MatrixType>(
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
    
    verifyScalarExpectation(
      observation: result[position: matrixPosition],
      expectation: try expectation(
        lhsScalar,
        rhsScalar
      ),
      tolerance: tolerance,
      fields: (
        ("matrixPosition", matrixPosition),
        ("lhsScalar", lhsScalar),
        ("rhsScalar", rhsScalar),
        ("lhs", lhs),
        ("rhs", rhs),
        ("result", result)
      ),
      explanation: explanation(),
      function: function,
      sourceLocation: sourceLocation
    )
  }
}

package func validateElementwiseMatrixMatrixMatrixNumericExpectation<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(lhs: MatrixType, rhs: MatrixType, result: MatrixType)>,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  _ expectation: (Scalar, Scalar) throws -> Scalar
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  try validateElementwiseMatrixMatrixMatrixNumericExpectation(
    lhs: example.example.lhs,
    rhs: example.example.rhs,
    result: example.example.result,
    tolerance: tolerance,
    explanation: explanation(),
    function: example.function,
    sourceLocation: example.sourceLocation,
    expectation
  )
}
