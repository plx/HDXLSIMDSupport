//
//  simd_double4x3+Matrix4x3Protocol.swift
//

import Foundation
import simd

@AddNativeMatrixConformance(rowCount: 3, columnCount: 4, representation: .double)
extension simd_double4x3: Matrix4x3Protocol, NumericAggregate { }
