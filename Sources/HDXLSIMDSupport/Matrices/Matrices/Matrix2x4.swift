import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add2x4CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix2x4<Scalar:ExtendedSIMDScalar>  :
  Matrix2x4Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix2x4: Sendable where Scalar.Matrix2x4Storage: Sendable { }
