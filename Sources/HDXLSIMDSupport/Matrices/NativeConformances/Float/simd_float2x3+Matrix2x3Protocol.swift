//
//  simd_float2x3+Matrix2x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 2, representation: .float)
extension simd_float2x3: Matrix2x3Protocol, NumericAggregate { }
