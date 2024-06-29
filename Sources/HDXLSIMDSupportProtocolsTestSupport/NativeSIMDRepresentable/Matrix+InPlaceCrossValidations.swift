import Testing
import HDXLSIMDSupportProtocols

@inlinable
package func crossValidateInPlaceMatrixOperation<
  Scalar,
  MatrixType: MatrixProtocol<Scalar>
>(
  matrix: MatrixType,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  outOfPlaceOperation: (MatrixType) throws -> MatrixType,
  inPlaceEquivalent inPlaceOperation: (inout MatrixType) throws -> Void,
  skippingWhen skipCondition: (MatrixType) throws -> Bool = { _ in false }
) throws {
  
  guard !(try skipCondition(matrix)) else {
    return
  }
  
  let outOfPlaceOutput = try outOfPlaceOperation(matrix)
  var inPlaceOutput = matrix
  try inPlaceOperation(&inPlaceOutput)
  

  let inPlaceToOutOfPlaceDistance = try metric.distance(
    from: inPlaceOutput,
    to: outOfPlaceOutput
  )
  
  #expect(
    inPlaceToOutOfPlaceDistance < tolerance,
    """
    Found in-place vs out-of-place mismatch for `\(operation())`:
        
    - `matrix`: \(String(reflecting: matrix))
    - `outOfPlaceOutput`: \(String(reflecting: outOfPlaceOutput))
    - `inPlaceOutput`: \(String(reflecting: inPlaceOutput))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}

@inlinable
package func crossValidateInPlaceMatrixOperations<
  Scalar,
  MatrixType: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  matrices: some Collection<MatrixType>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  outOfPlaceOperation: (MatrixType) throws -> MatrixType,
  inPlaceEquivalent inPlaceOperation: (inout MatrixType) throws -> Void,
  skippingWhen skipCondition: (MatrixType) throws -> Bool = { _ in false }
) throws {
  for matrix in matrices {
    try crossValidateInPlaceMatrixOperation(
      matrix: matrix,
      operation: operation(),
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation,
      outOfPlaceOperation: outOfPlaceOperation,
      inPlaceEquivalent: inPlaceOperation,
      skippingWhen: skipCondition
    )
  }
}

@inlinable
package func crossValidateInPlaceMatrixOperations<
  Scalar,
  MatrixType: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  matrices: some AsyncSequence<MatrixType, some Error>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  outOfPlaceOperation: (MatrixType) throws -> MatrixType,
  inPlaceEquivalent inPlaceOperation: (inout MatrixType) throws -> Void,
  skippingWhen skipCondition: (MatrixType) throws -> Bool = { _ in false }
) async throws {
  for try await matrix in matrices {
    try crossValidateInPlaceMatrixOperation(
      matrix: matrix,
      operation: operation(),
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation,
      outOfPlaceOperation: outOfPlaceOperation,
      inPlaceEquivalent: inPlaceOperation,
      skippingWhen: skipCondition
    )
  }
}

