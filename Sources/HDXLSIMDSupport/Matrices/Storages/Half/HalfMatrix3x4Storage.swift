//
//  HalfMatrix3x4Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 4, columnCount: 3, representation: .half)
public struct HalfMatrix3x4Storage:
  Matrix3x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x4OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
