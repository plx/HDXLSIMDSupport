//
//  simd_half4x3+Matrix4x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 4, representation: .half)
extension simd_half4x3: Matrix4x3Protocol, NumericAggregate { }
