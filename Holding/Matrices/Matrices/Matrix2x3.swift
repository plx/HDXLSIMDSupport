import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add2x3CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix2x3<Scalar:ExtendedSIMDScalar>  :
  Matrix2x3Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix2x3: Sendable where Scalar.Matrix2x3Storage: Sendable { }
