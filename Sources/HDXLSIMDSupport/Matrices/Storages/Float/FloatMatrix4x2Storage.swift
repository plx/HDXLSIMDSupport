import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add4x2CompatibleMatrices
@FourColumnNumericAggregate
@FourColumnNativeSIMDHashable
@FourColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix4x2Storage :
  Matrix4x2Protocol,
  Sendable
{
  
}
