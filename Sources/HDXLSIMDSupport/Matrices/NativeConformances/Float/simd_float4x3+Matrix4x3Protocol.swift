//
//  simd_float4x3+Matrix4x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 4, representation: .float)
extension simd_float4x3: Matrix4x3Protocol, NumericAggregate { }
