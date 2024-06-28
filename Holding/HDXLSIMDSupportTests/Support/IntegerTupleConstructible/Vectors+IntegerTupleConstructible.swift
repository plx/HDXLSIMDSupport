import Foundation
import simd

extension SIMD2 : IntegerTupleConstructible where Scalar: BinaryFloatingPoint {
  typealias IntegerTuple = Homogeneous2<Int>
  
  init(integerTuple: Homogeneous2<Int>) {
    self.init(
      Scalar(integerTuple.0), Scalar(integerTuple.1)
    )
  }
}

extension SIMD3 : IntegerTupleConstructible where Scalar: BinaryFloatingPoint {
  typealias IntegerTuple = Homogeneous3<Int>
  
  init(integerTuple: Homogeneous3<Int>) {
    self.init(
      Scalar(integerTuple.0), Scalar(integerTuple.1), Scalar(integerTuple.2)
    )
  }
}

extension SIMD4 : IntegerTupleConstructible where Scalar: BinaryFloatingPoint {
  typealias IntegerTuple = Homogeneous4<Int>
  
  init(integerTuple: Homogeneous4<Int>) {
    self.init(
      Scalar(integerTuple.0), Scalar(integerTuple.1), Scalar(integerTuple.2), Scalar(integerTuple.3)
    )
  }
}
