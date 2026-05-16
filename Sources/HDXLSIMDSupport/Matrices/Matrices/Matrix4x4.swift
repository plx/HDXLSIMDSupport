//
//  Matrix4x4.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperMatrixConformance(rowCount: 4, columnCount: 4)
public struct Matrix4x4<Scalar: ExtendedSIMDScalar>:
  Matrix4x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x4OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
