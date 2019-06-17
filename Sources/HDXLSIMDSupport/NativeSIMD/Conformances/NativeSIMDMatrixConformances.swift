//
//  NativeSIMDConformances.swift
//

import Foundation
import simd

extension simd_double2x2 : NativeSIMDMatrix2x2Protocol {
  
  public typealias NativeSIMDScalar = Double

  public typealias NativeSIMDRowVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD2<NativeSIMDScalar>

  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>

  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector)
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector)

}

extension simd_double2x3 : NativeSIMDMatrix2x3Protocol {
  
  public typealias NativeSIMDScalar = Double

  public typealias NativeSIMDRowVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector)
  
}

extension simd_double2x4 : NativeSIMDMatrix2x4Protocol {
  
  public typealias NativeSIMDScalar = Double

  public typealias NativeSIMDRowVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD4<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_double3x2 : NativeSIMDMatrix3x2Protocol {
  
  public typealias NativeSIMDScalar = Double
  
  public typealias NativeSIMDRowVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_double3x3 : NativeSIMDMatrix3x3Protocol {
  
  public typealias NativeSIMDScalar = Double
  
  public typealias NativeSIMDRowVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDDiagonalVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)

}

extension simd_double3x4 : NativeSIMDMatrix3x4Protocol {
  
  public typealias NativeSIMDScalar = Double

  public typealias NativeSIMDRowVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD4<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_double4x2 : NativeSIMDMatrix4x2Protocol {
  
  public typealias NativeSIMDScalar = Double

  public typealias NativeSIMDRowVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_double4x3 : NativeSIMDMatrix4x3Protocol {
  
  public typealias NativeSIMDScalar = Double
 
  public typealias NativeSIMDRowVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_double4x4 : NativeSIMDMatrix4x4Protocol {
  
  public typealias NativeSIMDScalar = Double

  public typealias NativeSIMDRowVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDDiagonalVector = SIMD4<NativeSIMDScalar>
  
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)

}

extension simd_float2x2 : NativeSIMDMatrix2x2Protocol {
  
  public typealias NativeSIMDScalar = Float

  public typealias NativeSIMDRowVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector)
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector)

}

extension simd_float2x3 : NativeSIMDMatrix2x3Protocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRowVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_float2x4 : NativeSIMDMatrix2x4Protocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRowVector = SIMD2<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD4<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_float3x2 : NativeSIMDMatrix3x2Protocol {
  
  public typealias NativeSIMDScalar = Float

  public typealias NativeSIMDRowVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_float3x3 : NativeSIMDMatrix3x3Protocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRowVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDDiagonalVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)

}

extension simd_float3x4 : NativeSIMDMatrix3x4Protocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRowVector = SIMD3<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD4<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_float4x2 : NativeSIMDMatrix4x2Protocol {
  
  public typealias NativeSIMDScalar = Float

  public typealias NativeSIMDRowVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD2<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_float4x3 : NativeSIMDMatrix4x3Protocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRowVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDDiagonalVector = SIMD3<NativeSIMDScalar>
  
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)

}

extension simd_float4x4 : NativeSIMDMatrix4x4Protocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRowVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDColumnVector = SIMD4<NativeSIMDScalar>
  public typealias NativeSIMDDiagonalVector = SIMD4<NativeSIMDScalar>
  
  public typealias NativeSIMDColumns = (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector)
  public typealias NativeSIMDRows = (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector)

}
