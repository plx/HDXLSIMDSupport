import Testing
@testable import HDXLSIMDSupport

func verifyLHSInPlaceBinaryOperation<Representation, SIMDType>(
  _ operationName: @autoclosure () -> String,
  on operands: (SIMDType, SIMDType),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (inout SIMDType, SIMDType) throws -> Void,
  native nativeEquivalent: (inout SIMDType.NativeSIMDRepresentation, SIMDType.NativeSIMDRepresentation) throws -> Void
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try mutation(of: operands.0) { try operation(&$0, operands.1) }
  let nativeOperands = (operands.0.nativeSIMDRepresentation, operands.1.nativeSIMDRepresentation)
  let nativeResult = try mutation(of: nativeOperands.0) { try nativeEquivalent(&$0, nativeOperands.1) }
  let indirect = SIMDType(nativeSIMDRepresentation: nativeResult)
  
  #expect(
    indirect.isWithinLInfinityDistance(
      epsilon,
      of: direct
    ),
    """
    Found mismatch between operation and native equivalent for `\(operationName())`!
    
    - lhs: \(String(describing: operands.0))
    - rhs: \(String(describing: operands.1))
    - direct: \(String(describing: direct))
    - indirect: \(String(describing: indirect))
    - nativeLHS: \(String(describing: nativeOperands.0))
    - nativeRHS: \(String(describing: nativeOperands.1))
    - nativeResult: \(String(describing: nativeResult))
    - epsilon: \(String(describing: epsilon))
    """,
    sourceLocation: sourceLocation
  )
}

func verifyLHSInPlaceBinaryOperation<Representation, SIMDType, Scalar>(
  _ operationName: @autoclosure () -> String,
  on operands: (SIMDType, Scalar),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (inout SIMDType, Scalar) throws -> Void,
  native nativeEquivalent: (inout SIMDType.NativeSIMDRepresentation, Scalar) throws -> Void
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try mutation(of: operands.0) { try operation(&$0, operands.1) }
  let nativeOperands = (operands.0.nativeSIMDRepresentation, operands.1)
  let nativeResult = try mutation(of: nativeOperands.0) { try nativeEquivalent(&$0, nativeOperands.1) }
  let indirect = SIMDType(nativeSIMDRepresentation: nativeResult)
  
  #expect(
    indirect.isWithinLInfinityDistance(
      epsilon,
      of: direct
    ),
    """
    Found mismatch between operation and native equivalent for `\(operationName())`!
    
    - lhs: \(String(describing: operands.0))
    - rhs: \(String(describing: operands.1))
    - direct: \(String(describing: direct))
    - indirect: \(String(describing: indirect))
    - nativeLHS: \(String(describing: nativeOperands.0))
    - nativeRHS: \(String(describing: nativeOperands.1))
    - nativeResult: \(String(describing: nativeResult))
    - epsilon: \(String(describing: epsilon))
    """,
    sourceLocation: sourceLocation
  )
}

