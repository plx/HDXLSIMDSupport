//
//  HalfMatrix2x2Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 2, columnCount: 2, representation: .half)
public struct HalfMatrix2x2Storage:
  Matrix2x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x2OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
