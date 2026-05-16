//
//  DoubleMatrix3x3Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 3, columnCount: 3, representation: .double)
public struct DoubleMatrix3x3Storage:
  Matrix3x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x3OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
