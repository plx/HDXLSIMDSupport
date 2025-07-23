import Testing
@testable import HDXLSIMDSupport


func verifyRHSInPlaceBinaryOperation<Representation, SIMDType>(
  _ operationName: @autoclosure () -> String,
  on operands: (SIMDType, SIMDType),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (SIMDType, inout SIMDType) throws -> Void,
  native nativeEquivalent: (SIMDType.NativeSIMDRepresentation, inout SIMDType.NativeSIMDRepresentation) throws -> Void
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try mutation(of: operands.1) { try operation(operands.0, &$0) }
  let nativeOperands = (operands.0.nativeSIMDRepresentation, operands.1.nativeSIMDRepresentation)
  let nativeResult = try mutation(of: nativeOperands.1) { try nativeEquivalent(nativeOperands.0, &$0) }
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

func verifyRHSInPlaceBinaryOperation<Representation, SIMDType, Scalar>(
  _ operationName: @autoclosure () -> String,
  on operands: (Scalar, SIMDType),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (Scalar, inout SIMDType) throws -> Void,
  native nativeEquivalent: (Scalar, inout SIMDType.NativeSIMDRepresentation) throws -> Void
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try mutation(of: operands.1) { try operation(operands.0, &$0) }
  let nativeOperands = (operands.0, operands.1.nativeSIMDRepresentation)
  let nativeResult = try mutation(of: nativeOperands.1) { try nativeEquivalent(nativeOperands.0, &$0) }
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

