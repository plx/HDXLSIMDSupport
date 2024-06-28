import Testing
import HDXLSIMDSupportProtocols

@inlinable
package func validateOutOfPlaceMatrixMatrixMatrixOperation<
  Scalar,
  LHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  RHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  OutputMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  arguments: (LHSMatrix.NativeSIMDRepresentation, RHSMatrix.NativeSIMDRepresentation),
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  matrixOperation: (LHSMatrix, RHSMatrix) throws -> OutputMatrix,
  nativeEquivalent nativeOperation: (LHSMatrix.NativeSIMDRepresentation, RHSMatrix.NativeSIMDRepresentation) throws -> OutputMatrix.NativeSIMDRepresentation,
  skippingWhen skipCondition: (LHSMatrix, RHSMatrix) throws -> Bool = { _, _ in false }
) throws {
  let nativeLHS = arguments.0
  let nativeRHS = arguments.1
  let matrixLHS = LHSMatrix(nativeSIMDRepresentation: nativeLHS)
  let matrixRHS = RHSMatrix(nativeSIMDRepresentation: nativeRHS)
  guard !(try skipCondition(matrixLHS, matrixRHS)) else {
    return
  }
  
  let nativeOutput = try nativeOperation(nativeLHS, nativeRHS)
  let matrixOperationOutput = try matrixOperation(matrixLHS, matrixRHS)
  let nativeOperationOutput = OutputMatrix(nativeSIMDRepresentation: nativeOutput)
  
  let matrixToNativeDistance = try metric.distance(
    from: matrixOperationOutput,
    to: nativeOperationOutput
  )
  
  #expect(
    matrixToNativeDistance < tolerance,
    """
    Found matrix-vs-native mismatch for `\(operation())`:
        
    - `nativeLHS`: \(String(reflecting: nativeLHS))
    - `nativeRHS`: \(String(reflecting: nativeRHS))
    - `matrixLHS`: \(String(reflecting: matrixLHS))
    - `matrixRHS`: \(String(reflecting: matrixRHS))
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
}

@inlinable
package func validateOutOfPlaceMatrixMatrixMatrixOperations<
  Scalar,
  LHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  RHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  OutputMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  lhses: some Collection<LHSMatrix.NativeSIMDRepresentation>,
  rhses: some Collection<RHSMatrix.NativeSIMDRepresentation>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  matrixOperation: (LHSMatrix, RHSMatrix) throws -> OutputMatrix,
  nativeEquivalent nativeOperation: (LHSMatrix.NativeSIMDRepresentation, RHSMatrix.NativeSIMDRepresentation) throws -> OutputMatrix.NativeSIMDRepresentation,
  skippingPairsWhere skipCondition: (LHSMatrix, RHSMatrix) throws -> Bool = { _, _ in false }
) throws {
  for lhs in lhses {
    for rhs in rhses {
      try validateOutOfPlaceMatrixMatrixMatrixOperation(
        arguments: (lhs, rhs),
        operation: operation(),
        metric: metric,
        tolerance: tolerance,
        function: function,
        sourceLocation: sourceLocation,
        matrixOperation: matrixOperation,
        nativeEquivalent: nativeOperation,
        skippingWhen: skipCondition
      )
    }
  }
}

@inlinable
package func validateOutOfPlaceMatrixMatrixMatrixOperations<
  Scalar,
  LHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  RHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  OutputMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  lhses: @autoclosure () throws -> some AsyncSequence<LHSMatrix.NativeSIMDRepresentation, some Error>,
  rhses: @autoclosure () throws -> some AsyncSequence<RHSMatrix.NativeSIMDRepresentation, some Error>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  matrixOperation: (LHSMatrix, RHSMatrix) throws -> OutputMatrix,
  nativeEquivalent nativeOperation: (LHSMatrix.NativeSIMDRepresentation, RHSMatrix.NativeSIMDRepresentation) throws -> OutputMatrix.NativeSIMDRepresentation,
  skippingPairsWhere skipCondition: (LHSMatrix, RHSMatrix) throws -> Bool = { _, _ in false }
) async throws {
  for try await lhs in try lhses() {
    for try await rhs in try rhses() {
      try validateOutOfPlaceMatrixMatrixMatrixOperation(
        arguments: (lhs, rhs),
        operation: operation(),
        metric: metric,
        tolerance: tolerance,
        function: function,
        sourceLocation: sourceLocation,
        matrixOperation: matrixOperation,
        nativeEquivalent: nativeOperation,
        skippingWhen: skipCondition
      )
    }
  }
}

