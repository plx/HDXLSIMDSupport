//
//  Matrix3x4.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 4, columnCount: 3)
public struct Matrix3x4<Scalar: ExtendedSIMDScalar>:
  Matrix3x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x4OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
