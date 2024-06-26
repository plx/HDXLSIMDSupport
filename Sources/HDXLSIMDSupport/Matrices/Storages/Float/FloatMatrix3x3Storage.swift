import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@AddInferredScalar
@AddMatrixRowsAndColumns
@Add3x3CompatibleMatrices
@AddCompatibleQuaternion
@ThreeColumnNumericAggregate
@ThreeColumnNativeSIMDHashable
@ThreeColumnNativeSIMDCodable
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct FloatMatrix3x3Storage :
  Matrix3x3Protocol,
  Sendable
{
  
}
