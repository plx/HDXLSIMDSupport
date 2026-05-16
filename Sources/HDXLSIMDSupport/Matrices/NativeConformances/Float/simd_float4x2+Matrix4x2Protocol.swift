//
//  simd_float4x2+Matrix4x2Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 2, columnCount: 4, representation: .float)
extension simd_float4x2: Matrix4x2Protocol, NumericAggregate { }
