//
//  FloatMatrix4x4Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 4, columnCount: 4, representation: .float)
public struct FloatMatrix4x4Storage:
  Matrix4x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x4OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
