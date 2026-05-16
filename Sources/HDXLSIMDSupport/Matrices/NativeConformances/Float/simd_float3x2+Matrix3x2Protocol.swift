//
//  simd_float3x2+Matrix3x2Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 2, columnCount: 3, representation: .float)
extension simd_float3x2: Matrix3x2Protocol, NumericAggregate { }
