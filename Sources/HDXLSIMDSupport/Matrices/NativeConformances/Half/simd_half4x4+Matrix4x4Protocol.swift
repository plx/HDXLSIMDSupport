//
//  simd_half4x4+Matrix4x4Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 4, columnCount: 4, representation: .half)
extension simd_half4x4: Matrix4x4Protocol, NumericAggregate { }
