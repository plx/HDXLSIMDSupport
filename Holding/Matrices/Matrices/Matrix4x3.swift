import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add4x3CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix4x3<Scalar:ExtendedSIMDScalar> :
  Matrix4x3Protocol,
  Sendable,
  Hashable,
  Codable
{
  
}
