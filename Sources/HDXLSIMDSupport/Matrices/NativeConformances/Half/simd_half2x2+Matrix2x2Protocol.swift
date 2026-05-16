//
//  simd_half2x2+Matrix2x2Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 2, columnCount: 2, representation: .half)
extension simd_half2x2: Matrix2x2Protocol, NumericAggregate { }
