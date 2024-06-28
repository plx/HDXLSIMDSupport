import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDMatrixBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add2x3CompatibleMatrices
@TwoColumnNumericAggregate
@TwoColumnNativeSIMDHashable
@TwoColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix2x3Storage :
  Matrix2x3Protocol,
  Sendable
{

}
