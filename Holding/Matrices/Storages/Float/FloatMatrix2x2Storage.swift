import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDMatrixBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add2x2CompatibleMatrices
@TwoColumnNumericAggregate
@TwoColumnNativeSIMDHashable
@TwoColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix2x2Storage :
  Matrix2x2Protocol,
  Sendable
{
  
}
