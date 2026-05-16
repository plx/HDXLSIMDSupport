//
//  simd_float4x4+Matrix4x4Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 4, columnCount: 4, representation: .float)
extension simd_float4x4: Matrix4x4Protocol, NumericAggregate { }
