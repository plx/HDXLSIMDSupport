//
//  simd_quatf+QuaternionProtocol.swift
//

import Foundation
import simd

@AddNativeQuaternionConformance(representation: .float)
extension simd_quatf: QuaternionProtocol, NumericAggregate { }
