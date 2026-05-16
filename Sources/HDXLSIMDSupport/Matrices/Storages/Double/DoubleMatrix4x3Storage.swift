//
//  DoubleMatrix4x3Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 3, columnCount: 4, representation: .double)
public struct DoubleMatrix4x3Storage:
  Matrix4x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x3OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
