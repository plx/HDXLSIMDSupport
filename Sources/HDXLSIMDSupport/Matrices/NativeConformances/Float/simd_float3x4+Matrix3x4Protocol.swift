//
//  simd_float3x4+Matrix3x4Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 4, columnCount: 3, representation: .float)
extension simd_float3x4: Matrix3x4Protocol, NumericAggregate { }
