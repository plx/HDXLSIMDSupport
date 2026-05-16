//
//  FloatQuaternionStorage.swift
//

import Foundation
import simd

@frozen
@AddStorageQuaternionConformance(representation: .float)
public struct FloatQuaternionStorage:
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
