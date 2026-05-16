//
//  Matrix4x3.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 3, columnCount: 4)
public struct Matrix4x3<Scalar: ExtendedSIMDScalar>:
  Matrix4x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x3OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
