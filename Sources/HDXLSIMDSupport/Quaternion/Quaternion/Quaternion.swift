//
//  Quaternion.swift
//

import Foundation
import simd
import SwiftUI

@frozen
@AddWrapperQuaternionConformance
public struct Quaternion<Scalar: ExtendedSIMDScalar>:
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{ }
