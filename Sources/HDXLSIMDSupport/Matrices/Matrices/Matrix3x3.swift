//
//  Matrix3x3.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 3, columnCount: 3)
public struct Matrix3x3<Scalar: ExtendedSIMDScalar>:
  Matrix3x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x3OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
