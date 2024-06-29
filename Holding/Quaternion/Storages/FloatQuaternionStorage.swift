import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

//@DebugDescription
@frozen
@AddInferredScalar
@AddQuaternionNumericAggregate
@AddNativeSIMDQuaternionBacking
@AddQVectorSerialization
@AddQuaternionCompatibleMatrices
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatQuaternionStorage :
  QuaternionProtocol,
  Sendable
{
  
    
}

