import Testing
import HDXLSIMDSupportProtocols

package func validateMatrixNegationProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(input: MatrixType, output: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "-X[i]"
  ) { (inputScalar) in -inputScalar }
}

package func validateMatrixAbsoluteValueProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(input: MatrixType, output: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "abs(X[i])"
  ) { (inputScalar) in abs(inputScalar) }
}
