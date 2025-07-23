import Testing
@testable import HDXLSIMDSupport

// MARK: Binary Operations

func verifyOutOfPlaceBinaryOperation<Representation, SIMDType>(
  _ operationName: @autoclosure () -> String,
  on operands: (SIMDType, SIMDType),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (SIMDType, SIMDType) throws -> SIMDType,
  native nativeEquivalent: (SIMDType.NativeSIMDRepresentation, SIMDType.NativeSIMDRepresentation) throws -> SIMDType.NativeSIMDRepresentation
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try operation(operands.0, operands.1)
  let nativeOperands = (operands.0.nativeSIMDRepresentation, operands.1.nativeSIMDRepresentation)
  let nativeResult = try nativeEquivalent(nativeOperands.0, nativeOperands.1)
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

func verifyOutOfPlaceBinaryOperation<Representation, SIMDType, Scalar>(
  _ operationName: @autoclosure () -> String,
  on operands: (SIMDType, Scalar),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (SIMDType, Scalar) throws -> SIMDType,
  native nativeEquivalent: (SIMDType.NativeSIMDRepresentation, Scalar) throws -> SIMDType.NativeSIMDRepresentation
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try operation(operands.0, operands.1)
  let nativeOperands = (operands.0.nativeSIMDRepresentation, operands.1)
  let nativeResult = try nativeEquivalent(nativeOperands.0, nativeOperands.1)
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

func verifyOutOfPlaceBinaryOperation<Representation, SIMDType, Scalar>(
  _ operationName: @autoclosure () -> String,
  on operands: (Scalar, SIMDType),
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (Scalar, SIMDType) throws -> SIMDType,
  native nativeEquivalent: (Scalar, SIMDType.NativeSIMDRepresentation) throws -> SIMDType.NativeSIMDRepresentation
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try operation(operands.0, operands.1)
  let nativeOperands = (operands.0, operands.1.nativeSIMDRepresentation)
  let nativeResult = try nativeEquivalent(nativeOperands.0, nativeOperands.1)
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
