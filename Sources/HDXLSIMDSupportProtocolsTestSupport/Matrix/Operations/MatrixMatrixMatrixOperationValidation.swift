import Testing
import HDXLSIMDSupportProtocols

package func validateMatrixMatrixAdditionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(lhs: MatrixType, rhs: MatrixType, result: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixMatrixMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] + Y[i] == Z[i]"
  ) { (lhsScalar, rhsScalar) in lhsScalar + rhsScalar }
}

package func validateMatrixMatrixSubtractionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(lhs: MatrixType, rhs: MatrixType, result: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixMatrixMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] - Y[i] == Z[i]"
  ) { (lhsScalar, rhsScalar) in lhsScalar - rhsScalar }
}

package func validateMatrixMatrixHadamardProductProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(lhs: MatrixType, rhs: MatrixType, result: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixMatrixMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] * Y[i] == Z[i]"
  ) { (lhsScalar, rhsScalar) in lhsScalar * rhsScalar }
}

package func validateMatrixMatrixHadamardDivisionProperties<Scalar, MatrixType>(
  example: ContextualizedValidationExample<(lhs: MatrixType, rhs: MatrixType, result: MatrixType)>,
  tolerance: Scalar
) throws where Scalar: BinaryFloatingPoint, MatrixType: MatrixProtocol<Scalar> {
  validateElementwiseMatrixMatrixMatrixNumericExpectation(
    example: example,
    tolerance: tolerance,
    explanation: "X[i] / Y[i] == Z[i]"
  ) { (lhsScalar, rhsScalar) in lhsScalar / rhsScalar }
}

