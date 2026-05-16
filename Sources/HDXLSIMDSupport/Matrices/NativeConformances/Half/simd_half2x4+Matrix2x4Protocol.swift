//
//  simd_half2x4+Matrix2x4Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 4, columnCount: 2, representation: .half)
extension simd_half2x4: Matrix2x4Protocol, NumericAggregate { }
