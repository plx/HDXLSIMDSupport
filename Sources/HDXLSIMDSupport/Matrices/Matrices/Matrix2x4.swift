//
//  Matrix2x4.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 4, columnCount: 2)
public struct Matrix2x4<Scalar: ExtendedSIMDScalar>:
  Matrix2x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x4OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
