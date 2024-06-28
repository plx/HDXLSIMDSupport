import Foundation
import simd
import HDXLSIMDSupport

extension simd_quatf : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous4<Int>
  
  init(integerTuple t: Homogeneous4<Int>) {
    self.init(
      i: Float(t.0),
      j: Float(t.1),
      k: Float(t.2),
      real: Float(t.3)
    )
  }
}

extension simd_quatd : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous4<Int>
  
  init(integerTuple t: Homogeneous4<Int>) {
    self.init(
      i: Double(t.0),
      j: Double(t.1),
      k: Double(t.2),
      real: Double(t.3)
    )
  }
}

extension Quaternion : IntegerTupleConstructible {
  typealias IntegerTuple = Homogeneous4<Int>
  
  init(integerTuple t: Homogeneous4<Int>) {
    self.init(
      i: Scalar(t.0),
      j: Scalar(t.1),
      k: Scalar(t.2),
      real: Scalar(t.3)
    )
  }
}
