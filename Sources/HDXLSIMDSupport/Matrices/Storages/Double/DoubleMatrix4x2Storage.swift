//
//  DoubleMatrix4x2Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 2, columnCount: 4, representation: .double)
public struct DoubleMatrix4x2Storage:
  Matrix4x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x2OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
