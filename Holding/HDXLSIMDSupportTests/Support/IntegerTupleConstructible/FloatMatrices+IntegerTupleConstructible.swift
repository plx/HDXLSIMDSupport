import Foundation
import simd

extension simd_float2x2 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous8<Int>
  
  init(integerTuple i: Homogeneous8<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1)),
        RowVector(integerTuple: (i.2,  i.3))
      ]
    )
  }
}

extension simd_float3x2 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous12<Int>
  
  init(integerTuple i: Homogeneous12<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1,  i.2)),
        RowVector(integerTuple: (i.3,  i.4,  i.5))
      ]
    )
  }
}

extension simd_float4x2 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous16<Int>
  
  init(integerTuple i: Homogeneous16<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1,  i.2,  i.3)),
        RowVector(integerTuple: (i.4,  i.5,  i.6,  i.7))
      ]
    )
  }
}

extension simd_float2x3 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous8<Int>
  
  init(integerTuple i: Homogeneous8<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1)),
        RowVector(integerTuple: (i.2,  i.3)),
        RowVector(integerTuple: (i.4,  i.5))
      ]
    )
  }
}

extension simd_float3x3 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous12<Int>
  
  init(integerTuple i: Homogeneous12<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1,  i.2)),
        RowVector(integerTuple: (i.3,  i.4,  i.5)),
        RowVector(integerTuple: (i.6,  i.7,  i.8))
      ]
    )
  }
}

extension simd_float4x3 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous16<Int>
  
  init(integerTuple i: Homogeneous16<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1,  i.2,  i.3)),
        RowVector(integerTuple: (i.4,  i.5,  i.6,  i.7)),
        RowVector(integerTuple: (i.8,  i.9,  i.10, i.11))
      ]
    )
  }
}

extension simd_float2x4 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous8<Int>
  
  init(integerTuple i: Homogeneous8<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1)),
        RowVector(integerTuple: (i.2,  i.3)),
        RowVector(integerTuple: (i.4,  i.5)),
        RowVector(integerTuple: (i.6, i.7))
      ]
    )
  }
}

extension simd_float3x4 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous12<Int>
  
  init(integerTuple i: Homogeneous12<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1,  i.2)),
        RowVector(integerTuple: (i.3,  i.4,  i.5)),
        RowVector(integerTuple: (i.6,  i.7,  i.8)),
        RowVector(integerTuple: (i.9, i.10, i.11))
      ]
    )
  }
}

extension simd_float4x4 : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous16<Int>
  
  init(integerTuple i: Homogeneous16<Int>) {
    self.init(
      rowVectors: [
        RowVector(integerTuple: (i.0,  i.1,  i.2,  i.3)),
        RowVector(integerTuple: (i.4,  i.5,  i.6,  i.7)),
        RowVector(integerTuple: (i.8,  i.9,  i.10, i.11)),
        RowVector(integerTuple: (i.12, i.13, i.14, i.15))
      ]
    )
  }
}

