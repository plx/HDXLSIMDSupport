//
//  DoubleMatrix3x4Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 4, columnCount: 3, representation: .double)
public struct DoubleMatrix3x4Storage:
  Matrix3x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x4OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
