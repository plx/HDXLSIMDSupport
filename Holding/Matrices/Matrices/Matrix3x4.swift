import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add3x4CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix3x4<Scalar:ExtendedSIMDScalar>  :
  Matrix3x4Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix3x4: Sendable where Scalar.Matrix3x4Storage: Sendable { }
