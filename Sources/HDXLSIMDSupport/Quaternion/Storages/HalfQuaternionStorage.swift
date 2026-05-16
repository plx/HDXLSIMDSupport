//
//  HalfQuaternionStorage.swift
//

import Foundation
import simd

@frozen
@AddStorageQuaternionConformance(representation: .half)
public struct HalfQuaternionStorage:
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
