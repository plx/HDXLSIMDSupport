import Testing
@testable import HDXLSIMDSupport

func verifyOutOfPlaceUnaryOperation<Representation, SIMDType>(
  _ operationName: @autoclosure () -> String,
  on value: SIMDType,
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (SIMDType) throws -> SIMDType,
  native nativeEquivalent: (SIMDType.NativeSIMDRepresentation) throws -> SIMDType.NativeSIMDRepresentation
) rethrows
where
  Representation: BinaryFloatingPoint,
  SIMDType: NativeSIMDRepresentable,
  SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try operation(value)
  let nativeValue = value.nativeSIMDRepresentation
  let nativeResult = try nativeEquivalent(nativeValue)
  let indirect = SIMDType(nativeSIMDRepresentation: nativeResult)
  
  #expect(
    indirect.isWithinLInfinityDistance(
      epsilon,
      of: direct
    ),
    """
    Found mismatch between operation and native equivalent for `\(operationName())`!
    
    - value: \(String(describing: value))
    - direct: \(String(describing: direct))
    - indirect: \(String(describing: indirect))
    - nativeValue: \(String(describing: nativeValue))
    - nativeResult: \(String(describing: nativeResult))
    - epsilon: \(String(describing: epsilon))
    """,
    sourceLocation: sourceLocation
  )
}

func verifyInPlaceUnaryOperation<Representation, SIMDType>(
  _ operationName: @autoclosure () -> String,
  on value: SIMDType,
  epsilon: Representation = 0.0,
  sourceLocation: Testing.SourceLocation = #_sourceLocation,
  _ operation: (inout SIMDType) throws -> Void,
  native nativeEquivalent: (inout SIMDType.NativeSIMDRepresentation) throws -> Void
) rethrows
where
Representation: BinaryFloatingPoint,
SIMDType: NativeSIMDRepresentable,
SIMDType: LInfinityDistanceMeasureable<Representation>
{
  let direct = try mutation(of: value, by: operation)
  let nativeValue = value.nativeSIMDRepresentation
  let nativeResult = try mutation(of: nativeValue, by: nativeEquivalent)
  let indirect = SIMDType(nativeSIMDRepresentation: nativeResult)
  
  #expect(
    indirect.isWithinLInfinityDistance(
      epsilon,
      of: direct
    ),
    """
    Found mismatch between operation and native equivalent for `\(operationName())`!
    
    - value: \(String(describing: value))
    - direct: \(String(describing: direct))
    - indirect: \(String(describing: indirect))
    - nativeValue: \(String(describing: nativeValue))
    - nativeResult: \(String(describing: nativeResult))
    - epsilon: \(String(describing: epsilon))
    """,
    sourceLocation: sourceLocation
  )
}

