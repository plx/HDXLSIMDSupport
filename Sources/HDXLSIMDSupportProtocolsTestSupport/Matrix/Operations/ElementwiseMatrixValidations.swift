import Testing
import HDXLSIMDSupportProtocols

package func validateElementwiseMatrixNumericExpectation<Scalar, MatrixType>(
  matrix: MatrixType,
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  _ property: (Scalar) throws -> Bool
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  for matrixPosition in MatrixType.matrixPositions {
    try verifyScalarProperty(
      value: matrix[position: matrixPosition],
      fields: (
        ("matrixPosition", matrixPosition),
        ("input", matrix)
      ),
      explanation: explanation(),
      function: function,
      sourceLocation: sourceLocation,
      property
    )
  }
}

package func validateElementwiseMatrixNumericExpectation<Scalar, MatrixType>(
  example: ContextualizedValidationExample<MatrixType>,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  _ property: (Scalar) throws -> Bool
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  try validateElementwiseMatrixNumericExpectation(
    matrix: example.example,
    explanation: explanation(),
    function: example.function,
    sourceLocation: example.sourceLocation,
    property
  )
}
