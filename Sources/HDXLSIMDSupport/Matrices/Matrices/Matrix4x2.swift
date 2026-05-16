//
//  Matrix4x2.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 2, columnCount: 4)
public struct Matrix4x2<Scalar: ExtendedSIMDScalar>:
  Matrix4x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x2OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
