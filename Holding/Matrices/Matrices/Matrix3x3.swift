import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add3x3CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix3x3<Scalar:ExtendedSIMDScalar>  :
  Matrix3x3Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix3x3: Sendable where Scalar.Matrix3x3Storage: Sendable { }
