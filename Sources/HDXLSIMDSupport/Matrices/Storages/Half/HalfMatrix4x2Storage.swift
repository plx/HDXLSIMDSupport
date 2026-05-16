//
//  HalfMatrix4x2Storage.swift
//

import Foundation
import simd

@frozen
@AddStorageMatrixConformance(rowCount: 2, columnCount: 4, representation: .half)
public struct HalfMatrix4x2Storage:
  Matrix4x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x2OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
