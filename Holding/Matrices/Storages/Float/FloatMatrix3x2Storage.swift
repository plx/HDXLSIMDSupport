import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDMatrixBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add3x2CompatibleMatrices
@ThreeColumnNumericAggregate
@ThreeColumnNativeSIMDHashable
@ThreeColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix3x2Storage :
  Matrix3x2Protocol,
  Sendable
{
  
}
