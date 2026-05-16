//
//  simd_quath+QuaternionProtocol.swift
//

import Foundation
import simd

@AddNativeQuaternionConformance(representation: .half)
extension simd_quath: QuaternionProtocol, NumericAggregate { }
