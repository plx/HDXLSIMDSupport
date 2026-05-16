//
//  simd_double2x4+Matrix2x4Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 4, columnCount: 2, representation: .double)
extension simd_double2x4: Matrix2x4Protocol, NumericAggregate { }
