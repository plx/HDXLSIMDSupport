//
//  simd_half4x2+Matrix4x2Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 2, columnCount: 4, representation: .half)
extension simd_half4x2: Matrix4x2Protocol, NumericAggregate { }
