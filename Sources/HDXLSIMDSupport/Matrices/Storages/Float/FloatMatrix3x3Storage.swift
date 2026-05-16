//
//  FloatMatrix3x3Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 3, columnCount: 3, representation: .float)
public struct FloatMatrix3x3Storage:
  Matrix3x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x3OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
