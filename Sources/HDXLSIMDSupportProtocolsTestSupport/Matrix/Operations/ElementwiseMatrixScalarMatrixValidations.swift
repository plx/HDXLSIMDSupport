import Testing
import HDXLSIMDSupportProtocols

package typealias MatrixScalarMatrix<Scalar,MatrixType> = (matrix: MatrixType, scalar: Scalar, output: MatrixType)
where MatrixType: MatrixProtocol<Scalar>


package func validateElementwiseMatrixScalarMatrixNumericExpectation<Scalar, MatrixType>(
  matrix: MatrixType,
  scalar: Scalar,
  output: MatrixType,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  _ expectation: (Scalar, Scalar) throws -> Scalar
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  for matrixPosition in MatrixType.matrixPositions {
    verifyScalarExpectation(
      observation: output[position: matrixPosition], 
      expectation: try expectation(matrix[position: matrixPosition], scalar),
      tolerance: tolerance,
      fields: (
        ("matrixPosition", matrixPosition),
        ("inputScalar", matrix[position: matrixPosition]),
        ("matrix", matrix),
        ("scalar", scalar),
        ("output", output)
      ),
      explanation: explanation(),
      function: function,
      sourceLocation: sourceLocation
    )
  }
}

package func validateElementwiseMatrixScalarMatrixNumericExpectation<Scalar, MatrixType>(
  example: ContextualizedValidationExample<MatrixScalarMatrix<Scalar, MatrixType>>,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  _ expectation: (Scalar, Scalar) throws -> Scalar
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  try validateElementwiseMatrixScalarMatrixNumericExpectation(
    matrix: example.example.matrix,
    scalar: example.example.scalar,
    output: example.example.output,
    tolerance: tolerance,
    explanation: explanation(),
    function: example.function,
    sourceLocation: example.sourceLocation,
    expectation
  )
}
