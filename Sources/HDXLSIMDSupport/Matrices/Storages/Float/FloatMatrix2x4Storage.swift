import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDMatrixBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add2x4CompatibleMatrices
@TwoColumnNumericAggregate
@TwoColumnNativeSIMDHashable
@TwoColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix2x4Storage :
  Matrix2x4Protocol,
  Sendable
{
  
}
