//
//  DoubleMatrix2x4Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 4, columnCount: 2, representation: .double)
public struct DoubleMatrix2x4Storage:
  Matrix2x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x4OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
