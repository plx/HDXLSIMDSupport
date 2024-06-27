import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDMatrixBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add4x4CompatibleMatrices
@AddCompatibleQuaternion
@FourColumnNumericAggregate
@FourColumnNativeSIMDHashable
@FourColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix4x4Storage :
  Matrix4x4Protocol,
  Sendable
{
}
