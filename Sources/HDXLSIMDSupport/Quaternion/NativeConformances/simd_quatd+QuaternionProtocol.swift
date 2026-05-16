//
//  simd_quatd+QuaternionProtocol.swift
//

import Foundation
import simd

@AddNativeQuaternionConformance(representation: .double)
extension simd_quatd: QuaternionProtocol, NumericAggregate { }
