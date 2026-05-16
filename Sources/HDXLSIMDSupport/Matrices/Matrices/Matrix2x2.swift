//
//  Matrix2x2.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 2, columnCount: 2)
public struct Matrix2x2<Scalar: ExtendedSIMDScalar>:
  Matrix2x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x2OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
