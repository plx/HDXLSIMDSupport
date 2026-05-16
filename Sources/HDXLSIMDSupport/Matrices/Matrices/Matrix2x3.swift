//
//  Matrix2x3.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 3, columnCount: 2)
public struct Matrix2x3<Scalar: ExtendedSIMDScalar>:
  Matrix2x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x3OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
