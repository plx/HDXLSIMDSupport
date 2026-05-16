//
//  HalfMatrix2x4Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 4, columnCount: 2, representation: .half)
public struct HalfMatrix2x4Storage:
  Matrix2x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x4OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
