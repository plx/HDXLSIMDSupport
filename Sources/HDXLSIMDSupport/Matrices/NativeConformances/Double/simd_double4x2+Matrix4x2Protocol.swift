//
//  simd_double4x2+Matrix4x2Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 2, columnCount: 4, representation: .double)
extension simd_double4x2: Matrix4x2Protocol, NumericAggregate { }
