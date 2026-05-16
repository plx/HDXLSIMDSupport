//
//  HalfMatrix4x3Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 3, columnCount: 4, representation: .half)
public struct HalfMatrix4x3Storage:
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
