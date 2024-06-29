import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add4x2CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix4x2<Scalar:ExtendedSIMDScalar>  :
  Matrix4x2Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix4x2: Sendable where Scalar.Matrix4x2Storage: Sendable { }
