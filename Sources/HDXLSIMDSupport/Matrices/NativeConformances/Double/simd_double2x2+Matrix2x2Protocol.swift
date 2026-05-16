//
//  simd_double2x2+Matrix2x2Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 2, columnCount: 2, representation: .double)
extension simd_double2x2: Matrix2x2Protocol, NumericAggregate { }
