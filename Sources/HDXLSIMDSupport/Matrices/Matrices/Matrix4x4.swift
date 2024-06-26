import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add4x4CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix4x4<Scalar:ExtendedSIMDScalar>  :
  Matrix4x4Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix4x4: Sendable where Scalar.Matrix4x4Storage: Sendable { }
