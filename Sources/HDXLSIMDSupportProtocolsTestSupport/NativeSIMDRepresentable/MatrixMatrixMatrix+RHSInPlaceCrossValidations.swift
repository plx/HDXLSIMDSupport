import Testing
import HDXLSIMDSupportProtocols

@inlinable
package func crossValidateRHSInPlaceMatrixMatrixMatrixOperation<
  Scalar,
  LHSMatrix: MatrixProtocol<Scalar>,
  RHSMatrix: MatrixProtocol<Scalar>
>(
  arguments: (LHSMatrix, RHSMatrix),
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  outOfPlaceOperation: (LHSMatrix, RHSMatrix) throws -> RHSMatrix,
  inPlaceEquivalent inPlaceOperation: (LHSMatrix, inout RHSMatrix) throws -> Void,
  skippingWhen skipCondition: (LHSMatrix, RHSMatrix) throws -> Bool = { _, _ in false }
) throws {
  let matrixLHS = arguments.0
  let matrixRHS = arguments.1
  guard !(try skipCondition(matrixLHS, matrixRHS)) else {
    return
  }

  let outOfPlaceOutput = try outOfPlaceOperation(matrixLHS, matrixRHS)
  
  var inPlaceOutput = matrixRHS
  try inPlaceOperation(matrixLHS, &inPlaceOutput)
  
  let inPlaceToOutOfPlaceDistance = try metric.distance(
    from: inPlaceOutput,
    to: outOfPlaceOutput
  )
  
  #expect(
    inPlaceToOutOfPlaceDistance < tolerance,
    """
    Found in-place vs out-of-place mismatch for `\(operation())`:
        
    - `matrixLHS`: \(String(reflecting: matrixLHS))
    - `matrixRHS`: \(String(reflecting: matrixRHS))
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
package func crossValidateRHSInPlaceMatrixMatrixMatrixOperations<
  Scalar,
  LHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  RHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  lhses: some Collection<LHSMatrix>,
  rhses: some Collection<RHSMatrix>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  outOfPlaceOperation: (LHSMatrix, RHSMatrix) throws -> RHSMatrix,
  inPlaceEquivalent inPlaceOperation: (LHSMatrix, inout RHSMatrix) throws -> Void,
  skippingWhen skipCondition: (LHSMatrix, RHSMatrix) throws -> Bool = { _, _ in false }
) throws {
  for lhs in lhses {
    for rhs in rhses {
      try crossValidateRHSInPlaceMatrixMatrixMatrixOperation(
        arguments: (lhs, rhs),
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
}

@inlinable
package func crossValidateRHSInPlaceMatrixMatrixMatrixOperations<
  Scalar,
  LHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable,
  RHSMatrix: MatrixProtocol<Scalar> & NativeSIMDRepresentable
>(
  lhses: @autoclosure () throws -> some AsyncSequence<LHSMatrix, some Error>,
  rhses: @autoclosure () throws -> some AsyncSequence<RHSMatrix, some Error>,
  operation: @autoclosure () -> String,
  metric: (some DistanceMetric<Scalar>).Type,
  tolerance: Scalar,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  outOfPlaceOperation: (LHSMatrix, RHSMatrix) throws -> RHSMatrix,
  inPlaceEquivalent inPlaceOperation: (LHSMatrix, inout RHSMatrix) throws -> Void,
  skippingWhen skipCondition: (LHSMatrix, RHSMatrix) throws -> Bool = { _, _ in false }
) async throws {
  for try await lhs in try lhses() {
    for try await rhs in try rhses() {
      try crossValidateRHSInPlaceMatrixMatrixMatrixOperation(
        arguments: (lhs, rhs),
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
}

