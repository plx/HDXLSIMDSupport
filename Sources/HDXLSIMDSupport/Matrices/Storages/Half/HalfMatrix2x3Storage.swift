//
//  HalfMatrix2x3Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 3, columnCount: 2, representation: .half)
public struct HalfMatrix2x3Storage:
  Matrix2x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x3OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
