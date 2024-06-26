import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@AddMatrixRowsAndColumns
@Add2x2CompatibleMatrices
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
@DescriptionFromStorage
@DebugDescriptionFromNativeSIMDRepresentation
public struct Matrix2x2<Scalar:ExtendedSIMDScalar> :
  Matrix2x2Protocol,
  Hashable,
  Codable
{
  
}

extension Matrix2x2: Sendable where Scalar.Matrix2x2Storage: Sendable { }
