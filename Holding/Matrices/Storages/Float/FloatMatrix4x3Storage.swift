import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDMatrixBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add4x3CompatibleMatrices
@FourColumnNumericAggregate
@FourColumnNativeSIMDHashable
@FourColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix4x3Storage :
  Matrix4x3Protocol,
  Sendable
{
    
}
