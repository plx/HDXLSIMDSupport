import Testing
import HDXLSIMDSupportProtocols

package func validateElementwiseMatrixMatrixNumericExpectation<Scalar, MatrixType>(
  input: MatrixType,
  output: MatrixType,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  _ expectation: (Scalar) throws -> Scalar
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  for matrixPosition in MatrixType.matrixPositions {
    verifyScalarExpectation(
      observation: output[position: matrixPosition],
      expectation: try expectation(input[position: matrixPosition]),
      tolerance: tolerance,
      fields: (
        ("matrixPosition", matrixPosition),
        ("input", input),
        ("output", output)
      ),
      explanation: explanation(),
      function: function,
      sourceLocation: sourceLocation
    )
  }
}

package func validateElementwiseMatrixMatrixNumericExpectation<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(input: MatrixType, output: MatrixType)>,
  tolerance: Scalar,
  explanation: @autoclosure () -> String,
  _ expectation: (Scalar) throws -> Scalar
) rethrows where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  try validateElementwiseMatrixMatrixNumericExpectation(
    input: example.example.input,
    output: example.example.output,
    tolerance: tolerance,
    explanation: explanation(),
    function: example.function,
    sourceLocation: example.sourceLocation,
    expectation
  )
}
