//
//  DoubleQuaternionStorage.swift
//

import Foundation
import simd

@frozen
@AddStorageQuaternionConformance(representation: .double)
public struct DoubleQuaternionStorage:
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
