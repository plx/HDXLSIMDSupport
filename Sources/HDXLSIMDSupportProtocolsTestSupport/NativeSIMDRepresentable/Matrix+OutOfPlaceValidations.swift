import Testing
import HDXLSIMDSupportProtocols

@inlinable
package func validateOutOfPlaceMatrixOperation<
  Scalar,
  MatrixType: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  nativeRepresentation: MatrixType.NativeSIMDRepresentation,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  matrixOperation: (MatrixType) throws -> MatrixType,
  nativeEquivalent nativeOperation: (MatrixType.NativeSIMDRepresentation) throws -> MatrixType.NativeSIMDRepresentation,
  skippingWhen skipCondition: (MatrixType) throws -> Bool = { _ in false },
  additionalValidation: (ContextualizedValidationExample<(input: MatrixType, output: MatrixType)>) throws -> Void = { _ in (); }
) throws {
  
  let matrixRepresentation = MatrixType(nativeSIMDRepresentation: nativeRepresentation)
  guard !(try skipCondition(matrixRepresentation)) else {
    return
  }
  
  let nativeOutput = try nativeOperation(nativeRepresentation)

  let matrixOperationOutput = try matrixOperation(matrixRepresentation)
  let nativeOperationOutput = MatrixType(nativeSIMDRepresentation: nativeOutput)
  
  let matrixToNativeDistance = try metric.distance(
    from: matrixOperationOutput,
    to: nativeOperationOutput
  )
  
  #expect(
    matrixToNativeDistance < tolerance,
    """
    Found matrix-vs-native mismatch for `\(operation())`:
        
    - `nativeRepresentation`: \(String(reflecting: nativeRepresentation))
    - `matrixRepresentation`: \(String(reflecting: matrixRepresentation))
    - `nativeOutput`: \(String(reflecting: nativeOutput))
    - `matrixOperationOutput`: \(String(reflecting: matrixOperationOutput))
    - `nativeOperationOutput`: \(String(reflecting: nativeOperationOutput))
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
  try additionalValidation(
    ContextualizedValidationExample(
      example: (
        input: matrixRepresentation,
        output: matrixOperationOutput
      ),
      function: function,
      sourceLocation: sourceLocation
    )
  )
}

@inlinable
package func validateOutOfPlaceMatrixOperations<
  Scalar,
  MatrixType: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  nativeRepresentations: some Collection<MatrixType.NativeSIMDRepresentation>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  matrixOperation: (MatrixType) throws -> MatrixType,
  nativeEquivalent nativeOperation: (MatrixType.NativeSIMDRepresentation) throws -> MatrixType.NativeSIMDRepresentation,
  skippingWhen skipCondition: (MatrixType) throws -> Bool = { _ in false },
  additionalValidation: (ContextualizedValidationExample<(input: MatrixType, output: MatrixType)>) throws -> Void = { _ in (); }
) throws {
  for nativeRepresentation in nativeRepresentations {
    try validateOutOfPlaceMatrixOperation(
      nativeRepresentation: nativeRepresentation,
      operation: operation(),
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation,
      matrixOperation: matrixOperation,
      nativeEquivalent: nativeOperation,
      skippingWhen: skipCondition,
      additionalValidation: additionalValidation
    )
  }
}

@inlinable
package func validateOutOfPlaceMatrixOperations<
  Scalar,
  MatrixType: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  nativeRepresentations: some AsyncSequence<MatrixType.NativeSIMDRepresentation, some Error>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  matrixOperation: (MatrixType) throws -> MatrixType,
  nativeEquivalent nativeOperation: (MatrixType.NativeSIMDRepresentation) throws -> MatrixType.NativeSIMDRepresentation,
  skippingWhen skipCondition: (MatrixType) throws -> Bool = { _ in false },
  additionalValidation: (ContextualizedValidationExample<(input: MatrixType, output: MatrixType)>) throws -> Void = { _ in (); }
) async throws {
  for try await nativeRepresentation in nativeRepresentations {
    try validateOutOfPlaceMatrixOperation(
      nativeRepresentation: nativeRepresentation,
      operation: operation(),
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation,
      matrixOperation: matrixOperation,
      nativeEquivalent: nativeOperation,
      skippingWhen: skipCondition,
      additionalValidation: additionalValidation
    )
  }
}

