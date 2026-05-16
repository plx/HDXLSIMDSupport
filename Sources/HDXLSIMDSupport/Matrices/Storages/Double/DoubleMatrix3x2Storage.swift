//
//  DoubleMatrix3x2Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 2, columnCount: 3, representation: .double)
public struct DoubleMatrix3x2Storage:
  Matrix3x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x2OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
