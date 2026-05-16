//
//  DoubleMatrix2x3Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 3, columnCount: 2, representation: .double)
public struct DoubleMatrix2x3Storage:
  Matrix2x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x3OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
