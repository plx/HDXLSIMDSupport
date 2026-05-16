//
//  simd_half2x3+Matrix2x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 2, representation: .half)
extension simd_half2x3: Matrix2x3Protocol, NumericAggregate { }
