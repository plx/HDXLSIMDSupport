//
//  simd_double2x3+Matrix2x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 2, representation: .double)
extension simd_double2x3: Matrix2x3Protocol, NumericAggregate { }
