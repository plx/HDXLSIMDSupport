//
//  simd_half3x3+Matrix3x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 3, representation: .half)
extension simd_half3x3: Matrix3x3Protocol, NumericAggregate { }
