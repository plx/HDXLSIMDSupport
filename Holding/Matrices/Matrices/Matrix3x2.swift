import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add3x2CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix3x2<Scalar:ExtendedSIMDScalar>  :
  Matrix3x2Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix3x2: Sendable where Scalar.Matrix3x2Storage: Sendable { }
