import Testing
import HDXLSIMDSupportProtocols

package func validateMatrix2x2StaticProperties<Scalar,MatrixType>(
  matrixType: MatrixType.Type,
  function: StaticString,
  sourceLocation: SourceLocation
) throws where Scalar: ExtendedSIMDScalar, MatrixType: Matrix2x2Protocol<Scalar> {
  #expect(
    matrixType.rowCount == 2
  )
}

package func validateMatrix2x2Conformance<Scalar,MatrixType>(
  matrixType: MatrixType.Type,
  metricType: (some DistanceMetric<Scalar>).Type
) throws where Scalar: ExtendedSIMDScalar, MatrixType: Matrix2x2Protocol<Scalar> {
  
}
