import Testing
import HDXLSIMDSupportProtocols

package func validateMatrixScalarProductProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<MatrixScalarMatrix<Scalar, MatrixType>>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixScalarMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] * x"
  ) { matrixScalar, scalarFactor in matrixScalar * scalarFactor }
}

package func validateMatrixScalarDivisionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<MatrixScalarMatrix<Scalar, MatrixType>>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixScalarMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] / x"
  ) { matrixScalar, scalarFactor in matrixScalar / scalarFactor }
}

package func validateMatrixScalarAdditionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<MatrixScalarMatrix<Scalar, MatrixType>>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixScalarMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] + x"
  ) { matrixScalar, scalarFactor in matrixScalar + scalarFactor }
}

package func validateMatrixScalarSubtractionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<MatrixScalarMatrix<Scalar, MatrixType>>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixScalarMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] - x"
  ) { matrixScalar, scalarFactor in matrixScalar - scalarFactor }
}
